package org.dspace.app.xmlui.aspect.forms;

import java.sql.SQLException;
import java.util.Map;

import org.dspace.app.util.DCInputsReader;
import org.dspace.app.util.DCInputsReaderException;
import org.dspace.app.xmlui.utils.UIException;
import org.dspace.app.xmlui.wing.Message;
import org.dspace.authorize.AuthorizeManager;

/**
 * Base form processor with additional specialization for input forms handling. 
 * 
 * @author james
 *
 */
public abstract class BaseInputFormsAction extends BaseAction {

	private static final Message T_deny = message("xmlui.Forms.BaseInputFormsAction.deny");

	/**
	 * The cached input forms data.
	 */
	protected static DCInputsReader inputsReader;
	
	
    /**
     * Cache the input forms data.
     * @throws UIException if there are any problems when reading the data from the file
     */
    protected static void initInputsReader() throws UIException
    {
    	try {
    		if (inputsReader == null)
    		{
    			inputsReader = DCInputsReader.getInstance();
    		}
		} catch (DCInputsReaderException e) {
			throw new UIException(e);
		}
    }

    /**
     * Get the cached input form data.
     * 
     * @return the cached input form data.
     */
    public static DCInputsReader getInputsReader()
    {
    	return inputsReader;
    }
    
    /**
     * Save the input form data back to disk.
     * 
     * @throws UIException if there are any problems saving the data.
     */
    public static void saveForm() throws UIException
    {
    	try {
			DCInputsReader.getInstance().buildOutputs();
		} catch (DCInputsReaderException e) {
			throw new UIException(e);
		}
    }
    
    /* cache the input form data */
    public void initializeAction(Map objectModel) throws SQLException, UIException
    {
    	initInputsReader();
    	super.initializeAction(objectModel);
    }
    
    // for now, all form editing requires admin privileges.
    public void checkRequest() throws SQLException, UIException 
    {
		if (!AuthorizeManager.isAdmin(getContext()))
		{			
			getResult().denyPage(T_deny);			
		}
    }

	
}
