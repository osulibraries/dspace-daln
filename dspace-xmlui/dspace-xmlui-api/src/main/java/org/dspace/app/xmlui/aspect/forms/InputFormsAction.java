package org.dspace.app.xmlui.aspect.forms;

import java.sql.SQLException;
import java.util.Set;

import org.dspace.app.util.DCInputSet;
import org.dspace.app.util.DCInputsReader;
import org.dspace.app.util.DCInputsReaderException;
import org.dspace.app.xmlui.utils.UIException;
import org.dspace.app.xmlui.wing.Message;

public class InputFormsAction extends BaseInputFormsAction {

	private static final Message T_already_used = message("xmlui.Forms.InputFormsAction.already_used");
	private static final Message T_no_such_value = message("xmlui.Forms.InputFormsAction.no_such_value");
	private static final Message T_cannot_delete = message("xmlui.Forms.InputFormsAction.cannot_delete");
	private static final Message T_confirm_delete = message("xmlui.Forms.InputFormsAction.confirm_delete");
	
    public InputFormsAction()
    {    	
    }
    
    public Set<String> getInputFormNames()
    {
		return getInputsReader().getInputSetNames();
    }
    
    public String getDefaultForm()
    {
		return getInputsReader().getMapEntry(DCInputsReader.DEFAULT_COLLECTION);
    }

	public void handleActions() throws UIException, FormException, SQLException
	{
		if (getParameter("cancel") != null)
		{
			getResult().doReturn();
			return;
		}

		doActions();
		
		saveForm();
	}    

	private void doActions() throws FormException, UIException
	{
		if (getParameter("new") != null)
		{
			String name = URLDecode(getRequiredParameter("name"));
			checkErrors();

			synchronized (getInputsReader())
			{
				assertField("name",!getInputsReader().hasInputSet(name),T_already_used);
				DCInputSet inputSet = new DCInputSet(name);
				inputSet.addPage();
				getInputsReader().addInputSet(inputSet);     		
			}
			return;
		}
		else if (getParameter("copy") != null)
		{
			String name = URLDecode(getRequiredParameter("name"));
			String base = URLDecode(getRequiredParameter("base"));
			checkErrors();

			synchronized (getInputsReader())
			{
				try 
				{
					assertField("name",!getInputsReader().hasInputSet(name),T_already_used);
					assertField("base",getInputsReader().hasInputSet(base),T_no_such_value);
					// NB throws error if 'base' does not exist, which can't happen here
					DCInputSet inputSet = new DCInputSet(getInputsReader().getInputsByName(base), name);
					getInputsReader().addInputSet(inputSet);
				}
				catch (DCInputsReaderException e) 
				{
					throw new UIException(e);
				}
			} 
			return;
		}

		for (String name : getInputFormNames())
		{
			if (getParameter("default"+name) != null)
			{
				getInputsReader().addMapEntry(DCInputsReader.DEFAULT_COLLECTION, name);
				return;
			}
			if (getParameter("remove"+name) != null)
			{
				getInputsReader().removeInputSet(name);
				return;
			}
		}
	}

	
	@Override
	public void checkRequest() throws UIException, SQLException
	{
		super.checkRequest();

		for (String name : getInputFormNames())
		{
			if (getParameter("remove"+name) != null)
			{
	        	Set<String> used = getInputsReader().isInputFormUsed(name);
	        	if (!used.isEmpty())
	        	{
	        		String s = "";
	        		for (String form : used)
	        		{
	        			s += form + " ";
	        		}
	        		getResult().denyAction(T_cannot_delete.parameterize(name, s));
	        		return;
	        	}

	        	getResult().needsConfirm(T_confirm_delete.parameterize(URLDecode(name)));
	        	return;
			}
        }
	}

}
