package org.dspace.app.xmlui.aspect.lists;

import java.io.Serializable;
import java.sql.SQLException;
import java.util.Enumeration;
import java.util.Locale;

import org.apache.cocoon.caching.CacheableProcessingComponent;
import org.apache.cocoon.environment.ObjectModelHelper;
import org.apache.cocoon.environment.Request;
import org.apache.cocoon.util.HashUtil;
import org.apache.excalibur.source.SourceValidity;
import org.apache.excalibur.source.impl.validity.NOPValidity;
import org.dspace.app.xmlui.cocoon.AbstractDSpaceTransformer;
import org.dspace.app.xmlui.utils.DSpaceValidity;
import org.dspace.app.xmlui.wing.Message;
import org.dspace.app.xmlui.wing.WingException;
import org.dspace.app.xmlui.wing.element.List;
import org.dspace.app.xmlui.wing.element.Options;
import org.dspace.eperson.EPerson;
import org.dspace.eperson.Group;

public class Navigation extends AbstractDSpaceTransformer implements CacheableProcessingComponent
{
    /** Language Strings */
    private static final Message T_head_browse = message("xmlui.ArtifactBrowser.Navigation.head_browse");
    private static final Message T_search_lists = message("xmlui.Lists.Navigation.search_lists");

    private static final Message T_my_account =
        message("xmlui.EPerson.Navigation.my_account");
    
    private static final Message T_lists =
        message("xmlui.Lists.Navigation.lists");
    
	/** Cached validity object */
	private SourceValidity validity;
	
    /**
     * Generate the unique key.
     * This key must be unique inside the space of this component.
     *
     * @return The generated key hashes the src
     */
    public Serializable getKey() 
    {
        Request request = ObjectModelHelper.getRequest(objectModel);
        
        // Special case, don't cache anything if the user is logging 
        // in. The problem occures because of timming, this cache key
        // is generated before we know whether the operation has 
        // succeded or failed. So we don't know whether to cache this 
        // under the user's specific cache or under the anonymous user.
        if (request.getParameter("login_email")    != null ||
            request.getParameter("login_password") != null ||
            request.getParameter("login_realm")    != null )
        {
            return null;
        }
                
        // FIXME:
        // Do not cache the home page. There is a bug that is causing the
        // homepage to be cached with user's data after a logout. This
        // polutes the cache. As a work-around this problem we just won't
        // cache this page.
        if (request.getSitemapURI().length() == 0)
        {
        	return null;
        }
        
    	String key;
        if (context.getCurrentUser() != null)
            key = context.getCurrentUser().getEmail();
        else
        	key = "anonymous";
        
        // Add the user's language
        Enumeration locales = request.getLocales();
        while (locales.hasMoreElements())
        {
            Locale locale = (Locale) locales.nextElement();
            key += "-" + locale.toString();    
        }
        
        return HashUtil.hash(key);
    }

    /**
     * Generate the validity object.
     *
     * @return The generated validity object or <code>null</code> if the
     *         component is currently not cacheable.
     */
    public SourceValidity getValidity() 
    {
    	if (this.validity == null)
    	{
    		// Only use the DSpaceValidity object is someone is logged in.
    		if (context.getCurrentUser() != null)
    		{
		        try {
		            DSpaceValidity validity = new DSpaceValidity();
		            
		            validity.add(eperson);
		            
		            Group[] groups = Group.allMemberGroups(context, eperson);
		            for (Group group : groups)
		            {
		            	validity.add(group);
		            }
		            
		            this.validity = validity.complete();
		        } 
		        catch (SQLException sqle)
		        {
		            // Just ignore it and return invalid.
		        }
    		}
    		else
    		{
    			this.validity = NOPValidity.SHARED_INSTANCE;
    		}
    	}
    	return this.validity;
    }
    
    /**
     * Add the eperson aspect navigational options.
     * @throws WingException 
     */
    public void addOptions(Options options) throws WingException
    {
    	/* Create skeleton menu structure to ensure consistent order between aspects,
    	 * even if they are never used 
    	 */
        List browse = options.addList("browse");
        List account = options.addList("account");
        options.addList("context");
        options.addList("administrative");
        
        browse.setHead(T_head_browse);
        browse.addItemXref(contextPath+"/lists/search-lists/view",T_search_lists);
        browse.addItemXref(contextPath+"/lists/showall-lists/view","Show All Lists"); // XXX i18n
        
        account.setHead(T_my_account);
        EPerson eperson = this.context.getCurrentUser();
        if (eperson != null)
        {
            account.addItemXref(contextPath+"/lists/lists",T_lists);
        } 
    }

    /**
     * recycle
     */
    public void recycle()
    {
        this.validity = null;
        super.recycle();
    }
    
}