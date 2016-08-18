package org.dspace.app.xmlui.aspect.forms;

import java.sql.SQLException;
import java.util.Map;
import java.util.Set;

import org.dspace.app.util.DCInputsReader;
import org.dspace.app.xmlui.utils.UIException;
import org.dspace.app.xmlui.wing.Message;
import org.dspace.authorize.AuthorizeManager;
import org.dspace.core.Constants;


// XXX if this pattern is ever repeated, factor into CompoundFormAction
public class CollectionFormsAction extends BaseAction {
	
	public static final Message T_deny = message("xmlui.Forms.CollectionFormsAction.deny");

	protected class CollectionInputFormsAction extends BaseInputFormsAction {

	    public Set<String> getInputFormNames()
	    {
	    	return getInputsReader().getInputSetNames();
	    }
	    
	    public String getInputFormName(String handle)
	    {
	    	String result = getInputsReader().getMapEntry(handle);
	    	if (result == null)
	    		result = getInputsReader().getMapEntry(DCInputsReader.DEFAULT_COLLECTION);
	    	return result;

	    }
	    
	    public boolean isDefaultForm(String handle)
	    {
	    	return getInputsReader().hasMapEntry(handle);
	    }

		public void handleActions() throws UIException, FormException
		{
	        if (getParameter("useinput") != null)
	        {
	            String baseName = getParameter("baseinput");
	            synchronized (getInputsReader())
	            {
	            	assertCondition(getInputsReader().hasInputSet(baseName), 
	            				    "Form " + baseName + "does not exist.");
	            	getInputsReader().addMapEntry(getDSO().getHandle(), baseName);
	            }
	            saveForm();
	            exitHandler();
	        }
	        else if (getParameter("revertinput") != null)
	        {
	        	getInputsReader().removeMapEntry(getDSO().getHandle());
	            saveForm();
	            exitHandler();	            
	        }
		}

		@Override
		public void checkRequest() throws SQLException, UIException {
			// do nothing
		}
	}
	
	protected CollectionInputFormsAction inputFormsAction;
	
    public CollectionFormsAction()
    {    	
    	inputFormsAction = new CollectionInputFormsAction();
    }
    
    public CollectionInputFormsAction getInputFormsAction()
    {
    	return inputFormsAction;
    }
    
	protected void handleActions() throws SQLException, UIException, FormException {
		inputFormsAction.handleActions();
	}

	@Override
	public void initializeAction(Map objectModel) throws SQLException, UIException {
		super.initializeAction(objectModel);
		inputFormsAction.initializeAction(objectModel);
	}

	@Override
	public void setupRequest(Map objectModel) throws SQLException, UIException {
		super.setupRequest(objectModel);
		inputFormsAction.setupRequest(objectModel);
	}

	public void checkRequest() throws SQLException, UIException // for now, whatever, later Message 
    {
		if (!AuthorizeManager.authorizeActionBoolean(getContext(), getDSO(), Constants.ADMIN, true))
		{
			getResult().denyPage(T_deny);			
		}
		inputFormsAction.checkRequest();
    }

}
