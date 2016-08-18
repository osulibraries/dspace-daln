package org.dspace.app.xmlui.aspect.lists;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;
import java.util.Vector;

import org.dspace.app.xmlui.aspect.forms.BaseAction;
import org.dspace.app.xmlui.aspect.forms.FormException;
import org.dspace.app.xmlui.utils.UIException;
import org.dspace.eperson.EPerson;
import org.dspace.storage.rdbms.DatabaseManager;
import org.dspace.storage.rdbms.TableRow;

public class EditListAction extends BaseAction {

	private Integer list_id;
	private String list_name;
	private String list_comment;
	private List<TableRow> rows;
	private List<Integer> items;
	
    public EditListAction()
    {    	
    }
    
    public List<Integer> getList()
    {
    	return items;
    }
    
    public String getName()
    {
    	return list_name;
    }
    
    public String getComment()
    {
    	return list_comment;
    }

    private void loadList() throws SQLException
    {
    	rows = ListUtils.getListItems(getContext(), list_id);
		items = new Vector<Integer>();
    	for (TableRow row : rows)
        {
    		items.add(row.getIntColumn("item_id"));
        }
    }

	@Override
	public void initializeAction(Map objectModel) throws SQLException, UIException {
		super.initializeAction(objectModel);

		list_id = getIntParameter("base");
        assertCondition(list_id != null, "Malformed value list edit request: No list_id provided");

        // check access
		EPerson eperson = getContext().getCurrentUser();		
		list_name = ListUtils.checkList(getContext(), eperson, list_id);
        assertCondition(list_name != null, "Malformed value list edit request: Not authorized");
        
        list_comment = ListUtils.getListComment(getContext(), list_id);
        
        loadList();
	}

	public void handleActions() throws FormException, UIException, SQLException
	{
		if (getParameter("cancel") != null)
		{
			getResult().doReturn();
			return;
		}
		if (getParameter("base") != null)
		{
			// this is the first pass through, so perform no action
			return;
		}

		loadList();
				
		// exit on errors
		checkErrors();
		
		doActions();

		loadList();
		
		getContext().commit();
	}
	
	private void doActions() throws SQLException
	{
		if (getParameter("list-comment") != null)
		{
			String new_comment = getParameter("list-comment");
			if (!new_comment.equals(list_comment))
			{
				list_comment = new_comment; 
				ListUtils.setListComment(getContext(), list_id, list_comment);
			}
		}
		if (getParameter("list-name") != null)
		{
			String new_name = getParameter("list-name");
			if (!new_name.equals(list_name))
			{
				list_name = new_name; 
				ListUtils.setListName(getContext(), list_id, list_name);
			}
		}
		
		int numItems = items.size();
		// I did not want to do it this way,
		// but because IE doesn't process Buttons correctly, I'm forced to
		for (int i = 0; i < numItems; i++)
		{
			if (getParameter("itemup"+i) != null)
			{
				upItem(i);
				return;
			}
			if (getParameter("itemdown"+i) != null)
			{
				downItem(i);
				return;
			}
			if (getParameter("itemremove"+i) != null)
			{
				removeItem(i);
				return;
			}
		}
	}

	public void upItem(int i) throws SQLException
	{
		ListUtils.swapItemOrder(getContext(), rows.get(i), rows.get(i-1));
	}
	
	public void downItem(int i) throws SQLException
	{
		ListUtils.swapItemOrder(getContext(), rows.get(i), rows.get(i+1));
	}

	public void removeItem(int i) throws SQLException
	{
		DatabaseManager.delete(getContext(), rows.get(i));
	}
	
}
