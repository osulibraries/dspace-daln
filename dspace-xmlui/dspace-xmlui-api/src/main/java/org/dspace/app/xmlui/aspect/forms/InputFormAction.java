package org.dspace.app.xmlui.aspect.forms;

import java.sql.SQLException;
import java.util.Iterator;
import java.util.Map;
import java.util.Set;

import org.apache.cocoon.environment.ObjectModelHelper;
import org.apache.cocoon.environment.Request;
import org.dspace.app.util.DCInput;
import org.dspace.app.util.DCInputSet;
import org.dspace.app.util.DCInputsReaderException;
import org.dspace.app.xmlui.utils.UIException;
import org.dspace.app.xmlui.wing.Message;

public class InputFormAction extends BaseInputFormsAction {

	private static final Message T_duplicate = message("xmlui.Forms.InputFormAction.duplicate");
	private static final Message T_does_not_exist = message("xmlui.Forms.InputFormAction.does_not_exist");
	private static final Message T_not_empty = message("xmlui.Forms.InputFormAction.not_empty");
	private static final Message T_last_page = message("xmlui.Forms.InputFormAction.last_page");
	private static final Message T_confirm_delete = message("xmlui.Forms.InputFormAction.confirm_delete");
	
	private String name;
	
	private Integer curpage;
	private Integer curfield;
	
	private String[] visibility;
	
	private DCInputSet inputSet;
	
	private DCInput errorfield; 
	
    public InputFormAction()
    {    	
    }
    
	public Integer getCurrentPage() {
		return curpage;
	}

	public Integer getCurrentField() {
		return curfield;
	}
	
	public DCInputSet getInputSet() {
		return inputSet;
	}
	
	// XXX maybe provide a default field with sensible defaults for obscure fields
	// when adding a new field.  If the defaults are not already sensible, that is.
	/**
	 * Returns the field data to use when displaying the field.
	 * 
	 * If there are any errors, use the locally cached, unsaved errorfield.
	 * If there are not errors, use the locally cached, saved errorfield
	 * if we are editing an existing field.  Otherwise, use null.
	 * 
	 * @return the field editing data to be displayed in the form
	 */
	public DCInput getEditField() {
		if (hasErrors())
		{
			return errorfield;
		}
		else 
		{
			return (curfield == -1)? null : inputSet.getField(curpage, curfield);
		}
	}
	
    public Set<String> getValueListNames()
    {
    	return getInputsReader().getValueListNames();
    }
	
	public void initializeAction(Map objectModel) throws SQLException, UIException
	{
		Request request = ObjectModelHelper.getRequest(objectModel);

		name = request.getParameter("base");
        assertCondition(name != null, "Malformed input form edit request: No name provided");
        
        // create local copy
		synchronized (getInputsReader())
		{
			// double check against race condition
			assertCondition(getInputsReader().hasInputSet(name), "Input form '" + name + "' does not exist");
			try {
				inputSet = getInputsReader().getInputsByName(name);
			}
			catch (DCInputsReaderException e) // not reached
			{}
		}
	}

    public void setupRequest(Map objectModel) throws SQLException, UIException
    {
    	super.setupRequest(objectModel);
    	// XXX this is horribly ugly, but we require special handling for visibility
    	//     because it is multiple-valued
    	Request request = ObjectModelHelper.getRequest(objectModel);
    	
    	// save the multiple values for visibility
    	visibility = request.getParameterValues("visibility");

    	// this needs to be done here
		int numPages = inputSet.getNumberPages();

		curpage = getIntParameter("curpage");
		if (curpage == null && numPages > 0)
			curpage = 0;
		
		curfield = getIntParameter("curfield");		
    }
	
	public void handleActions() throws FormException, UIException, SQLException
	{
		if (getParameter("base") != null)
		{
			// this is the first pass through, so perform no action
			return;
		}
    	if (getParameter("cancel") != null)
		{
    		getResult().doReturn();
    		return;
		}
		if (getParameter("cancelfield") != null)
		{
			curfield = null; // clear out curfield so we don't bother with it below
			return;
		}
				
		createLocalState();

		checkErrors();

		curfield = null; // most actions reset the current field (we don't want it hanging around at -1, for instance)
		doActions();
		// XXX if just field edit or page edit then don't save (but that's an optimization)
		
		updateSharedState();

		// and save to disk
		saveForm();
	}

	private void createLocalState()
	{
		// Only if editing a field
		if (curfield != null)
		{
			// process params and fill in errors as appropriate
			processFields();
			verifyFields();
	
			// populate temporary state
			DCInput field = getInputsReader().newField(getParams());
	
			// either hold it in a temporary field (if there are errors)
			// or write it back to the local state
			if (hasErrors())
			{
				errorfield = field;
			}
			else if (curfield == -1)
			{
				inputSet.addField(curpage, field);
			}
			else
			{
				inputSet.setField(curpage, curfield, field);
			}
		}
	}
	
	private void processFields()
	{
		massageVisibility();
		
		//squash empty fields
		for (Iterator<Map.Entry<String,String>> i = getParams().entrySet().iterator(); i.hasNext(); )
		{
			Map.Entry<String,String> entry = i.next();
			if (entry.getValue().isEmpty())
			{
				i.remove();
			}
		}
	}
	
	private void verifyFields()
	{
		// XXX flag in form
		String schema = getParameter("dc-schema");
		String element = getParameter("dc-element");
		String qualifier = getParameter("dc-qualifier");
		int numpages = inputSet.getNumberPages();
		for (int page = 0; page < numpages; page++)
		{
			int numfields = inputSet.getNumFields(page);
			for (int field = 0; field < numfields; field++)
			{
				DCInput input = inputSet.getField(page, field);
				String inputschema = input.getSchema();
				String inputelement = input.getElement();
				String inputqualifier = input.getQualifier();
				boolean sameschema = (schema == null && inputschema == null) ||
									 (schema != null && schema.equals(inputschema));
				boolean sameelement = (element == null && inputelement == null) ||
				                      (element != null && element.equals(inputelement));
				boolean samequalifier = (qualifier == null && inputqualifier == null) ||
				                        (qualifier != null && qualifier.equals(inputqualifier));
				boolean same = sameschema && sameelement && samequalifier;
				assertField("name", !same, T_duplicate);
			}
		}
		
		assertRequiredParameter("dc-element");
		assertRequiredParameter("label");
		assertRequiredParameter("input-type");

		if (DCInput.requiresValues(getParameter("input-type")))
		{
			String valueList = getRequiredParameter("value-pairs-name");
			if (valueList != null)
			{
				// NB only from race condition
				assertField("value-pairs-name", getInputsReader().hasValueList(valueList), T_does_not_exist);
			}
		}
		
	}	
	
	private void massageVisibility()
	{
		if (getParams().containsKey("visibility"))
		{
			getParams().remove("visibility");
			for (String vis : visibility)
			{
				if (vis.equals("submit"))
				{
					if ("workflow".equals(getParams().get("visibility")))
					{
						getParams().remove("visibility"); // null for both
						break;
					}
					else
						getParams().put("visibility", "submit");
				}
				else if (vis.equals("workflow"))
				{
					if ("submit".equals(getParams().get("visibility")))
					{
						getParams().remove("visibility"); // null for both
						break;
					}
					else
						getParams().put("visibility", "workflow");        			
				}
			}
		}		
	}

	private void doActions()
	{
		int numPages = inputSet.getNumberPages();
		int numFields = (curpage == null)? 0 : inputSet.getNumFields(curpage); 

		// page-level actions
		if (getParameter("pageadd") != null)
		{
			inputSet.addPage();
			return;
		}
		// I did not want to do it this way, and really don't have to,
		// but because IE doesn't process Buttons correctly, I'm forced
		// to do other forms this way, and so for the sake of uniformity
		// I'm doing it like that here, too
		for (int i = 0; i < numPages; i++)
		{
			if (getParameter("pageedit"+i) != null)
			{
				curpage = i;
				return;
			}
			if (getParameter("pageup"+i) != null)
			{
				inputSet.movePage(i, i-1);
				return;
			}
			if (getParameter("pagedown"+i) != null)
			{
				inputSet.movePage(i, i+1);
				return;
			}
			if (getParameter("pageremove"+i) != null)
			{
				inputSet.removePage(i);
				return;
			}
		}
	
		// field-level actions
		if (getParameter("fieldadd") != null)
		{
			curfield = -1;
			return;
		}
		for (int i = 0; i < numFields; i++)
		{
			if (getParameter("fieldedit"+i) != null)
			{
				curfield = i;
				return;
			}
			if (getParameter("fieldup"+i) != null)
			{
				inputSet.moveField(curpage, i, i-1);
				return;
			}
			if (getParameter("fielddown"+i) != null)
			{
				inputSet.moveField(curpage, i, i+1);
				return;
			}
			if (getParameter("fieldprev"+i) != null)
			{
				DCInput tmp = inputSet.removeField(curpage, i);
				inputSet.addField(curpage-1, tmp);
				return;
			}
			if (getParameter("fieldnext"+i) != null)
			{
				DCInput tmp = inputSet.removeField(curpage, i);
				inputSet.addField(curpage+1, tmp);
				return;
			}
			if (getParameter("fieldremove"+i) != null)
			{
				inputSet.removeField(curpage, i);
				return;
			}
		}
		// NB the save button works by virtue of not being anything else
		//    because anything else drops through and saves no matter what 
	}

	private void updateSharedState()
	{
		// translate to external format and update shared state
		getInputsReader().addInputSet(inputSet);
	}

	public void checkRequest() throws UIException, SQLException
	{
		super.checkRequest();
		
		int numPages = inputSet.getNumberPages();
		int numFields = (curpage == null)? 0 : inputSet.getNumFields(curpage); 

		for (int i = 0; i < numPages; i++)
		{
			if (getParameter("pageremove"+i) != null)
			{
				if (i == 0)
					getResult().denyAction(T_last_page);
				
				if (numFields != 0)
					getResult().denyAction(T_not_empty);
				return;
			}
		}
	
		for (int i = 0; i < numFields; i++)
		{
			if (getParameter("fieldremove"+i) != null)
			{
				getResult().needsConfirm(T_confirm_delete.parameterize(inputSet.getField(curpage,i).getName()));
				return;
			}
		}
	}

}
