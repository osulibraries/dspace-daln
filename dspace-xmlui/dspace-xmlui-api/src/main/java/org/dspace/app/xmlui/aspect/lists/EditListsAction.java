package org.dspace.app.xmlui.aspect.lists;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.Map;

import org.apache.cocoon.environment.ObjectModelHelper;
import org.dspace.app.xmlui.aspect.forms.BaseAction;
import org.dspace.app.xmlui.aspect.forms.FormException;
import org.dspace.app.xmlui.utils.ContextUtil;
import org.dspace.app.xmlui.utils.UIException;
import org.dspace.app.xmlui.wing.Message;
import org.dspace.core.Context;
import org.dspace.eperson.EPerson;
import org.dspace.storage.rdbms.TableRow;

public class EditListsAction extends BaseAction {

	private static final Message T_already_used = message("xmlui.Lists.EditListsAction.already_used");
	private static final Message T_no_such_value = message("xmlui.Lists.EditListsAction.no_such_value");
	private static final Message T_confirm_delete = message("xmlui.Lists.EditListsAction.confirm_delete");
	
	private EPerson eperson;
	private Map<Integer,String> lists;
	private Map<Integer,Boolean> shared;
	
    public EditListsAction()
    {    	
    }
    
    public Map<Integer,String> getLists()
    {
    	return lists;
    }
    
    public boolean isShared(Integer list_id)
    {
    	return shared.get(list_id);
    }

    private void loadLists() throws SQLException
    {
		eperson = getContext().getCurrentUser();
		lists = new LinkedHashMap<Integer,String>();
		shared = new HashMap<Integer, Boolean>();
			
		for (TableRow row : ListUtils.getListsRaw(getContext(), eperson))
        {
			int list_id = row.getIntColumn("list_id");
			String list_name = row.getStringColumn("list_name");
			Boolean isShared = row.getBooleanColumn("shared");
			lists.put(list_id, list_name);
			shared.put(list_id, isShared);
        }
    }
    
	@Override
	public void initializeAction(Map objectModel) throws SQLException, UIException {
		super.initializeAction(objectModel);
		loadLists();
	}

	// XXX kludgy
	@Override
	public void refreshContext(Map objectModel) throws SQLException {
		super.refreshContext(objectModel);
		loadLists();
	}

	public void handleActions() throws UIException, FormException, SQLException
	{
		if (getParameter("cancel") != null)
		{
			getResult().doReturn();
			return;
		}
		
		loadLists();
		
		// exit on errors
		checkErrors();
		
		doActions();
        
		loadLists();
		
		getContext().commit();
	}

	private void doActions() throws UIException, FormException, SQLException
	{
        if (getParameter("new") != null)
        {
        	String name = URLDecode(getRequiredParameter("name"));        	
        	checkErrors();

        	assertField("name",!getLists().containsValue(name),T_already_used);
        	checkErrors();
     
        	ListUtils.createList(getContext(), eperson, name);

        	getParams().remove("name");
			return;
        }
        if (getParameter("copy") != null)
        {
        	String name = URLDecode(getRequiredParameter("name"));
        	assertRequiredParameter("base");
        	Integer base = getIntParameter("base");
        	checkErrors();

        	assertField("name",!getLists().containsValue(name),T_already_used);
        	assertField("base",getLists().containsKey(base),T_no_such_value);
        	checkErrors();
        		
    		Integer list_id = ListUtils.createList(getContext(), eperson, name);
    		ListUtils.copyList(getContext(), base, list_id);

        	getParams().remove("name");
			return;
        }
		for (Integer id : getLists().keySet())
		{
			if (getParameter("remove"+id) != null)
			{
				ListUtils.deleteList(getContext(), id);
				return;
			}
		}
		for (Integer id : getLists().keySet())
		{
			if (getParameter("share"+id) != null)
			{
				ListUtils.shareList(getContext(), id, true);
				return;
			}
		}
		for (Integer id : getLists().keySet())
		{
			if (getParameter("unshare"+id) != null)
			{
				ListUtils.shareList(getContext(), id, false);
				return;
			}
		}
	}
	
	@Override
	public void checkRequest() throws UIException, SQLException
	{
		super.checkRequest();

		for (Map.Entry<Integer, String> entry: getLists().entrySet())
		{
			Integer id = entry.getKey();
			String name = entry.getValue();
			if (getParameter("remove"+id) != null)
			{
				getResult().needsConfirm(T_confirm_delete.parameterize(URLDecode(name)));
				return;
	        }
		}		
	}
	
}
