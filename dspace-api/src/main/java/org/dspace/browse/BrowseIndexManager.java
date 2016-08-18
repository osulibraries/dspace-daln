package org.dspace.browse;

import java.lang.reflect.InvocationTargetException;
import java.lang.reflect.Method;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import org.dspace.core.ConfigurationManager;
import org.dspace.sort.SortException;
import org.dspace.sort.SortOption;

public class BrowseIndexManager {

    /** additional 'internal' tables that are always defined */
    private static BrowseIndexItem itemIndex      = createBrowseIndexInternal("bi_item");
    private static BrowseIndexItem withdrawnIndex = createBrowseIndexInternal("bi_withdrawn");

    private static Map<String, Class<BrowseIndex>> browseTypes = null;
    
    /**
     * Constructor for creating generic / internal index objects
     * @param baseName The base of the table name
     */
    private static BrowseIndexItem createBrowseIndexInternal(String baseName)
    {
        try
        {
        	SortOption sortOption = SortOption.getDefaultSortOption();
        	return new BrowseIndexItem(-1, null, "item", null, baseName, sortOption);
        }
        catch (SortException se)
        {
        }
        return null;
    }
    
    /**
     * Create a new BrowseIndex object using the definition from the configuration,
     * and the number of the configuration option.  The definition should be of
     * the form:
     * 
     * <code>
     * [name]:[metadata]:[data type]:[display type]
     * </code>
     * 
     * [name] is a freetext name for the field
     * [metadata] is the usual format of the metadata such as dc.contributor.author
     * [data type] must be either "title", "date" or "text"
     * [display type] must be either "single" or "full"
     * 
     * @param definition	the configuration definition of this index
     * @param number		the configuration number of this index
     * @throws BrowseException 
     */
    private static BrowseIndex createBrowseIndex(String definition, int number)
    	throws BrowseException
    {
        try
        {
        	Map<String, Class<BrowseIndex>> browseTypes = getBrowseTypes();
        	
        	// XXX might want to move this down into individual classes
        	// and just match on the first two fields here
            String rx = "(\\w+):(\\w+):?([\\w\\.\\*,]*):?(\\w*):?(\\w*)";
            Pattern pattern = Pattern.compile(rx);
            Matcher matcher = pattern.matcher(definition);

            BrowseIndex result = null;
            
            if (matcher.matches())
            {
                String displayType = matcher.group(2);
                
                if (displayType != null)
                {
                	for (Map.Entry<String, Class<BrowseIndex>> entry : getBrowseTypes().entrySet())
                	{
                		if (displayType.startsWith(entry.getKey()))
                		{
                			Class<BrowseIndex> klass = entry.getValue();
                			Method method = klass.getMethod("createBrowseIndex", int.class, Matcher.class);
                			result = (BrowseIndex)method.invoke(null, number, matcher);                			
                		}                		
                	}
                }
            }

            if (result == null)
            {
            	throw new BrowseException("Browse Index configuration is not valid: webui.browse.index." +
                        number + " = " + definition);
            }
           
            return result;
        }
        catch (InvocationTargetException e)
        {
            throw new BrowseException("Error in SortOptions", e.getCause());        	
        }
        catch (NoSuchMethodException e)
        {
        	throw new BrowseException("Configuration error for " + definition);
        }
        catch (IllegalAccessException e)
        {
        	throw new BrowseException("Configuration error for " + definition);        	
        }
    }

    
    /**
     * @deprecated
     * @return
     * @throws BrowseException
     */
    public static String[] tables()
            throws BrowseException
    {
        BrowseIndex[] bis = getBrowseIndices();
        String[] returnTables = new String[bis.length];
        for (int i = 0; i < bis.length; i++)
        {
            returnTables[i] = bis[i].getTableName();
        }

        return returnTables;
    }
    
    /**
     * Get an array of all the browse indices for the current configuration
     * 
     * @return	an array of all the current browse indices
     * @throws BrowseException
     */
    // XXX is it worth caching these?
    public static BrowseIndex[] getBrowseIndices()
    	throws BrowseException
    {
        int idx = 1;
        String definition;
        ArrayList browseIndices = new ArrayList();

        while ( ((definition = ConfigurationManager.getProperty("webui.browse.index." + idx))) != null)
        {
            BrowseIndex bi = createBrowseIndex(definition, idx);
            browseIndices.add(bi);
            idx++;
        }

        BrowseIndex[] bis = new BrowseIndex[browseIndices.size()];
        bis = (BrowseIndex[]) browseIndices.toArray((BrowseIndex[]) bis);

        return bis;
    }
    
    private static Map<String, Class<BrowseIndex>> getBrowseTypes() throws BrowseException
    {
    	if (browseTypes == null)
    	{
    		Map<String,Class<BrowseIndex>> types = new HashMap<String,Class<BrowseIndex>>();

    		try 
    		{
    			types.put("metadata", (Class<BrowseIndex>)Class.forName("org.dspace.browse.BrowseIndexMetadata"));
    			types.put("item", (Class<BrowseIndex>)Class.forName("org.dspace.browse.BrowseIndexItem"));
    		}
    		catch (Exception e)
    		{
    			throw new BrowseException("fatal internal error");
    		}
    		
    		int idx = 1;
    		String line;
    		while (((line = ConfigurationManager.getProperty("webui.browse.type." + idx))) != null)
    		{
        		try 
        		{
        			String rx = "(\\w+):(.+)";
        			Pattern pattern = Pattern.compile(rx);
        			Matcher matcher = pattern.matcher(line);

        			matcher.matches();
        			String tag = matcher.group(1);
        			String klassname = matcher.group(2);
        			Class<BrowseIndex> klass = (Class<BrowseIndex>)Class.forName(klassname);
        			
        			types.put(tag, klass);
        			
        			idx++;
        		}
        		catch (Exception e)
        		{
        			e.printStackTrace();
        			throw new BrowseException("misconfigured browse type " + line);
        		}
    		}
    		
    		browseTypes = types; // make the update atomic
    	}
    	
    	return browseTypes;
    }

    /**
     * Get the browse index from configuration with the specified name.
     * The name is the first part of the browse configuration
     *
     * @param name		the name to retrieve
     * @return			the specified browse index
     * @throws BrowseException
     */
    public static BrowseIndex getBrowseIndex(String name)
    	throws BrowseException
    {
        for (BrowseIndex bix : getBrowseIndices())
        {
            if (bix.getName().equals(name))
                return bix;
        }
         
        return null;
    }
    
    /**
     * Get the configured browse index that is defined to use this sort option
     * 
     * @param so
     * @return
     * @throws BrowseException
     */
    public static BrowseIndex getBrowseIndex(SortOption so) throws BrowseException
    {
        for (BrowseIndex bix : getBrowseIndices())
        {
            if (bix.getSortOption() == so)
                return bix;
        }
        
        return null;
    }
    
    /**
     * Get the internally defined browse index for archived items
     * 
     * @return
     */
    public static BrowseIndexItem getItemBrowseIndex()
    {
        return itemIndex;
    }
    
    /**
     * Get the internally defined browse index for withdrawn items
     * @return
     */
    public static BrowseIndexItem getWithdrawnBrowseIndex()
    {
        return withdrawnIndex;
    }
    
    /**
     * Does the browse index represent one of the internal item indexes
     * 
     * @param bi
     * @return
     */
    public static boolean isInternalIndex(BrowseIndex bi)
    {
        return (bi == itemIndex || bi == withdrawnIndex);
    }

}
