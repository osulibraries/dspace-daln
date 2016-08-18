/*
 * OhioLINKIPDbAuthentication.java
 * 
 * July 07 2008
 * 
 * 
 */
package edu.ohiolink.dspace.authenticate;

import java.sql.SQLException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import java.util.List;
import java.util.Map;
import java.util.HashMap;
import java.util.ArrayList;
import java.util.Enumeration;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.dspace.core.Context;
import org.dspace.eperson.EPerson;
import org.dspace.eperson.Group;
import org.dspace.core.ConfigurationManager;
import org.dspace.authenticate.IPMatcher;
import org.dspace.authenticate.IPMatcherException;

import org.apache.log4j.Logger;
import org.dspace.core.LogManager;

/**
 * <p>
 * An implicit authentication method that temporarily adds users 
 * to special DSpace groups based on their IP address. 
 * 
 * Each special DSpace group configured for this authentication method
 * is associated with an institution code in the OhioLINK auth database.
 *
 * The auth database provides CIDR blocks for each configured institution.
 * The user IP is then matched up against the CIDR blocks, and the user is added
 * to the associated DSpace groups for the length of the session.   
 * 
 * 
 * Configuration parameters are added to the DSpace configuration file.
 * </p>
 * <p>
 * Example configuration parameter:
 * </p>
 * <p>
 * {@code authentication.ipdb.<GROUPNAME> = <collegecode> }
 * </p>
 * <p>
 *  Where <GROUPNAME> is a DSpace group, and <collegecode> is an institution code
 *  from the auth database.
 * e.g. {@code authentication.ipdb.UDAYTON = uday}
 *  
 *  Multiple codes can be listed on a line:
 *  {@code authentication.ipdb.UDAYTON = uday, ox}
 *  
 * </p>
 * <p>
 * For supported college codes, see the OhioLINK authorization database.
 *  There are also two special codes for the purpose of this class:
 *
 * allohio:  All Ohio libraries including OPLIN and INFOhio libraries
 * allohiolink:  All OhioLINK member institutions
 *
 * This class expects that all IP ranges returned from the database will be 
 * expressed as CIDR blocks.
 * 
 * </p>
 * 
 * <p>
 * {@code ipdb.dbusername = <DATABASE_USERNAME>}
 * </p>
 * <p>
 * {@code ipdb.dbpassword = <DATABASE_PASSWORD>}
 * </p>
 * <p>
 * {@code ipdb.driver = <DATABASE_DRIVER>}
 * </p>
 *  <p>
 * {@code ipdb.url = <DATABASE_URL>}
 * </p>
 * <p>
 * Note: Remember to include SSL parameters in the database URL.
 * </p>
 * @author Keith
 *
 * TODO: Add support for IP based restriction by campus branch
 */
public class OhioLINKIpDbAuthentication implements org.dspace.authenticate.AuthenticationMethod {

	// Use log4j logging system
	private static Logger log = Logger.getLogger(OhioLINKIpDbAuthentication.class);
	// Maintain a list of IP Matchers for all configured groups
	private List<IPMatcher> ipMatchers;
	
	/*
	 * There are two Maps associated with the IPMatchers.  The first maps IPMatchers to
	 * group names.  The second matches IPMatchers to the DSpace group database ID.  When
	 * the DB ID is known, the IPMatcher is moved from the map containing the group name
	 * into the map containing the database ID.
	 */
	/* Maps IPMatchers to group names */
	private Map<IPMatcher, String> ipMatcherGroupNames;
	
	/* Maps IPMatchers to group database IDs */
	private Map<IPMatcher, Integer> ipMatcherGroupIDs;
	
	/* Database parameters */
	private String dbusername;
	private String dbpassword;
	private String dbUrl;
	
	/**
	 * Initialize an OhioLINK IP database authenticator, reading in
	 * the configuration.
	 * 
	 * If the configuration property name is bad, a warning will be logged.
	 */
	public OhioLINKIpDbAuthentication()
	{
		
		ipMatchers = new ArrayList<IPMatcher>();
		ipMatcherGroupNames = new HashMap<IPMatcher, String>();
		ipMatcherGroupIDs = new HashMap<IPMatcher, Integer>();
		
		dbusername = ConfigurationManager.getProperty("ipdb.dbusername");
		dbpassword = ConfigurationManager.getProperty("ipdb.dbpassword");
		dbUrl = ConfigurationManager.getProperty("ipdb.url");
		
		// Get all of the properties that start with 'authentication.ipdb.'
		// These properties correlate DSpace groups with college codes.
		// Users on an IP address at a configured institution will be added to 
		// the appropriate group.
		
		Enumeration <?> e =  ConfigurationManager.propertyNames();
	
		while (e.hasMoreElements())
		{
			String propName = (String)e.nextElement();
			if ( propName.startsWith("authentication.ipdb.") )
			{
				String[] nameParts = propName.split("\\.");
				
				if (nameParts.length == 3)
				{
					addMatchers(nameParts[2], ConfigurationManager.getProperty(propName));
				}
				else 
				{
					log.warn("Malformed configuration property name: "
							+ propName);
				}
			}
		}
	}
	
	/**
	 * Add matchers for the given group and comma-delimited college codes
	 * 
	 * @param groupName
	 *             name of group
	 * @param collegeCodes
	 */
	private void addMatchers(String groupName, String collegeCodes)
	{
		/* Use college codes to look in the database and get IP ranges for
		   the college.  
		   College codes may be separated with commas.
		   Add an IP Matcher for each IP range.
		*/
		String[] codes = collegeCodes.split("\\s*,\\s*");
		
		// Use SSL mode when connecting to the database
		// Register basic JDBC driver
		try
		{
			Class.forName(ConfigurationManager
					.getProperty("ipdb.driver"));
		}
		catch (ClassNotFoundException e)
		{
			log.warn("Could not load database driver in ipdb.driver property", e);
		
		}
		
		Connection con;
		PreparedStatement stmtByInstitution; // code for one institution
		PreparedStatement stmtAllOhioLINK;   // Special code for all OhioLINK institutions, except ones banned from DRC/DMC via Stu's checkbox system
		PreparedStatement stmtAllOhio;       // special code for "all" ohio, which includes OPLIN and INFOhio
		
		ResultSet rs;
		try
		{
			con = DriverManager.getConnection(dbUrl, dbusername, dbpassword);
			stmtByInstitution = con.prepareStatement("SELECT range FROM ip_ranges WHERE colcode = ?");
			stmtAllOhioLINK = con.prepareStatement("SELECT range FROM ip_ranges WHERE (colcode,brcode) in " +
			                     "(SELECT DISTINCT colcode,brcode FROM database_permissions where dbid='dmc')"); 
								 //DRC to replace dmc, but will use the same database permissions code 'dmc' above
			stmtAllOhio = con.prepareStatement("SELECT range FROM ip_ranges");					 
								                         
			for(int i=0;i<codes.length; i++)
			{
			
			    String collegeCode = codes[i];
				if ( collegeCode.equals("allohio") )
				{
					rs = stmtAllOhio.executeQuery();
				}
				else if ( collegeCode.equals("allohiolink") )
				{
					rs = stmtAllOhioLINK.executeQuery();
				}
				else  // standard college code for a single institution
				{
					stmtByInstitution.setString(1, codes[i]);
					rs = stmtByInstitution.executeQuery();
				}
				while(rs.next())
				{
					try
					{
						// column 1 contains the range
						// get the CIDR block as a string and pass to the IPMatcher constructor
						String ipRange = rs.getString(1);
						IPMatcher ipm = new IPMatcher(ipRange);
						ipMatchers.add(ipm);
						ipMatcherGroupNames.put(ipm, groupName);
					
						if ( log.isDebugEnabled() )
						{
							log.debug("Configured " + ipRange + " for special group " +
								groupName);
						}
					}
					catch(IPMatcherException ipme)
					{
						log.warn("Malformed IP range specified for group " +
							groupName,
							ipme);
					}
				}
			}
			stmtByInstitution.close();
			stmtAllOhio.close();
			stmtAllOhioLINK.close();
			con.close();
		}
		catch (SQLException e)
		{
				log.warn("There was a problem interacting with the database", e);
		}
		
	}
		
	 /** Implicit authentication mode; set password not allowed */
	public boolean allowSetPassword(Context context,
			HttpServletRequest request, String username) throws SQLException {
		
		return false;
	}

	
	/** Implicit authentication method; username and password not used */
	public int authenticate(Context context, String username, String password,
			String realm, HttpServletRequest request) throws SQLException {
	
		return BAD_ARGS;
	}

	/** Implicit authentication method; no self-registration */
	public boolean canSelfRegister(Context context, HttpServletRequest request,
			String username) throws SQLException {
		return false;
	}

	/**
     * Get list of extra groups that user implicitly belongs to.
     * Returns IDs of any EPerson-groups that the user authenticated by
     * this request is <em>implicitly</em> a member of -- e.g.
     * a group that depends on the client network-address.
     * 
     * @param context
     *  A valid DSpace context.
     *
     * @param request
     *  The request that started this operation, or null if not applicable.
     *
     * @return array of EPerson-group IDs, possibly 0-length, but
     * never <code>null</code>.
     */
	public int[] getSpecialGroups(Context context, HttpServletRequest request)
			throws SQLException {
		List<Integer> groupIDs = new ArrayList<Integer>();
		
		String addr = request.getRemoteAddr();
		if (log.isDebugEnabled())
		{
			log.debug("Remote address: " + addr);
		}
		
		/*
		 * Examine all of the IPMatchers and check if any match this address.
		 * When there is a match, add the database ID of the group to the list.
		 * 
		 */
		if (log.isDebugEnabled())
		{
			log.debug("Trying " + ipMatchers.size() + "ip matchers for address " + addr);
		}
		for (int i=0; i<ipMatchers.size();i++)
		{
			IPMatcher ipm = ipMatchers.get(i);
			
			try
			{
				if (ipm.match(addr))
				{
					if (log.isDebugEnabled())
					{
						log.debug("Match found.");
					}
					// Do we know the group ID in the DSpace database?
					Integer groupID = ipMatcherGroupIDs.get(ipm);
					if (groupID != null)
					{
						groupIDs.add(groupID);
					}
					else
					{
						// See if we have a group name
						String groupName = ipMatcherGroupNames.get(ipm);
						
						if(groupName != null)
						{
							Group group = Group.findByName(context, groupName);
							
							if (group != null)
							{
								// Add ID so we won't have to do lookup again
								ipMatcherGroupIDs.put(ipm, new Integer(group.getID()));
								ipMatcherGroupNames.remove(ipm);
								
								groupIDs.add(new Integer(group.getID()));
							}
							else
							{
								log.warn(LogManager.getHeader(context, "configuration_error",
										"unknown_group=" + groupName));
							}
						}
					}
				}
			}
			catch(IPMatcherException ipme)
			{
				
				log.warn( LogManager.getHeader(context, "configuration_error",
						"bad_ip=" + addr),  
						ipme);
					
			}
		}
		
		int[] results = new int[groupIDs.size()];
		for (int i=0; i< groupIDs.size();i++)
		{
			results[i] = (groupIDs.get(i)).intValue();
		}
		
		if (log.isDebugEnabled())
		{
			StringBuffer gsb = new StringBuffer();
			for (int i =0; i<results.length; i++)
			{
				if (i > 0)
				{
					gsb.append(",");
				}
				gsb.append(results[i]);
			}
		}
		
		return results;
	}

	/** Implicit authentication method; nothing needs to be performed here */
	public void initEPerson(Context context, HttpServletRequest request,
			EPerson eperson) throws SQLException {

	}
	

	public boolean isImplicit() {
		return true;
	}

	
	public String loginPageTitle(Context context) {
		return null;
	}

	public String loginPageURL(Context context, HttpServletRequest request,
			HttpServletResponse response) {
		return null;
	}

}
