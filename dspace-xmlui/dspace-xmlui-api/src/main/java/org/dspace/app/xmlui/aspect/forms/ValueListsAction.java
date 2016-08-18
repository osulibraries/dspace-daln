package org.dspace.app.xmlui.aspect.forms;

import java.sql.SQLException;
import java.util.List;
import java.util.Set;
import java.util.Vector;

import org.dspace.app.xmlui.utils.UIException;
import org.dspace.app.xmlui.wing.Message;

public class ValueListsAction extends BaseInputFormsAction {

	private static final Message T_already_used = message("xmlui.Forms.ValueListsAction.already_used");
	private static final Message T_no_such_value = message("xmlui.Forms.ValueListsAction.no_such_value");
	private static final Message T_cannot_delete = message("xmlui.Forms.ValueListsAction.cannot_delete");
	private static final Message T_confirm_delete = message("xmlui.Forms.ValueListsAction.confirm_delete");
	
    public ValueListsAction()
    {    	
    }
    
    public Set<String> getValueListNames()
    {
		return getInputsReader().getValueListNames();
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

	private void doActions() throws UIException, FormException
	{
        if (getParameter("new") != null)
        {
        	String name = URLDecode(getRequiredParameter("name"));        	
        	checkErrors();

        	synchronized (getInputsReader())
        	{
        		assertField("name",!getInputsReader().hasValueList(name),T_already_used);
        		checkErrors();
        		getInputsReader().addValuePairs(name,"",new Vector<String>());
        	}
        	getParams().remove("name");
			return;
        }
        if (getParameter("copy") != null)
        {
        	String name = URLDecode(getRequiredParameter("name"));
        	String base = URLDecode(getRequiredParameter("base"));
        	checkErrors();
        	
        	synchronized (getInputsReader())
        	{
        		assertField("name",!getInputsReader().hasValueList(name),T_already_used);
        		assertField("base",getInputsReader().hasValueList(base),T_no_such_value);
        		checkErrors();
        		
        		List<String> pairs = getInputsReader().getPairs(base);
        		getInputsReader().addValuePairs(name,"",new Vector<String>(pairs));
        	}
        	getParams().remove("name");
			return;
        }
		for (String name : getValueListNames())
		{
			if (getParameter("remove"+name) != null)
			{
				getInputsReader().removeValuePairs(name);
				return;
			}
		}
	}
	
	@Override
	public void checkRequest() throws UIException, SQLException
	{
		super.checkRequest();

		for (String name : getValueListNames())
		{
			if (getParameter("remove"+name) != null)
			{
	        	Set<String> used = getInputsReader().isValueListUsed(name);
	        	if (!used.isEmpty())
	        	{
	        		String s = "";
	        		for (String form : used)
	        		{
	        			s += form + " ";
	        		}
	        		getResult().denyAction(T_cannot_delete.parameterize(name,s));
	        		return;
	        	}
	        	
				getResult().needsConfirm(T_confirm_delete.parameterize(URLDecode(name)));
				return;
	        }
		}		
	}
	
}
