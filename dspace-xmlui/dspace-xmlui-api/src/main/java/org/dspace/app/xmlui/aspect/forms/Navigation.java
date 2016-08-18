package org.dspace.app.xmlui.aspect.forms;

import java.io.IOException;
import java.io.Serializable;
import java.sql.SQLException;

import org.apache.cocoon.caching.CacheableProcessingComponent;
import org.apache.excalibur.source.SourceValidity;
import org.apache.excalibur.source.impl.validity.NOPValidity;
import org.dspace.app.xmlui.cocoon.AbstractDSpaceTransformer;
import org.dspace.app.xmlui.utils.HandleUtil;
import org.dspace.app.xmlui.utils.UIException;
import org.dspace.app.xmlui.wing.Message;
import org.dspace.app.xmlui.wing.WingException;
import org.dspace.app.xmlui.wing.element.List;
import org.dspace.app.xmlui.wing.element.Options;
import org.dspace.authorize.AuthorizeException;
import org.dspace.authorize.AuthorizeManager;
import org.dspace.content.Collection;
import org.dspace.content.DSpaceObject;
import org.dspace.core.Constants;
import org.xml.sax.SAXException;

/**
 * Simple navigation class to add the top level link to 
 * the main submissions page.
 * 
 * @author Scott Phillips
 */
public class Navigation extends AbstractDSpaceTransformer implements CacheableProcessingComponent
{
	/** Language Strings **/
	private static final Message T_choose = message("xmlui.Forms.Navigation.choose");
	private static final Message T_edit = message("xmlui.Forms.Navigation.edit");
	
	
	 /**
     * Generate the unique caching key.
     * This key must be unique inside the space of this component.
     */
    public Serializable getKey() {
        
        return 1;
    }

    /**
     * Generate the cache validity object.
     */
    public SourceValidity getValidity() 
    {
        return NOPValidity.SHARED_INSTANCE;
    }
	
   
    public void addOptions(Options options) throws SAXException, WingException,
            UIException, SQLException, IOException, AuthorizeException
    {
		// Basic navigation skeleton
        options.addList("browse");
        options.addList("account");
        List contextl = options.addList("context");
        List admin    = options.addList("administrative");
    	
        // put the submission link somewhere
        DSpaceObject dso = HandleUtil.obtainHandle(objectModel);
        
        if (dso instanceof Collection)
        {
            Collection collection = (Collection)dso;
            
            if (AuthorizeManager.authorizeActionBoolean(context, dso, Constants.ADMIN, true)) {
                //contextl.setHead(T_context_head);
                contextl.addItemXref(contextPath+"/handle/"+collection.getHandle()+"/forms/collection-forms",T_choose);
            }
        }
        
        if (AuthorizeManager.isAdmin(context))
        {
        	// global admin
        	admin.addItemXref(contextPath+"/forms/other-forms/form",T_edit);
        }

    }
}
