package org.dspace.app.xmlui.aspect.lists;

import java.sql.SQLException;
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

import org.dspace.core.Context;
import org.dspace.eperson.EPerson;
import org.dspace.storage.rdbms.DatabaseManager;
import org.dspace.storage.rdbms.TableRow;
import org.dspace.storage.rdbms.TableRowIterator;

public class ListUtils {

	public static final String STATUS_ATTR = "list_status";
	
	public static List<TableRow> getListsRaw(Context context, EPerson eperson) throws SQLException
	{
		String query = "SELECT * FROM lists WHERE eperson_id=" + eperson.getID();
		return (List<TableRow>)DatabaseManager.query(context, query).toList();		
	}

	public static Map<Integer, String> getListsShared(Context context, EPerson eperson) throws SQLException
	{
		String query = "";
		if (eperson == null) {
			query = "SELECT * FROM lists WHERE shared=true";			
		}
		else {
		    query = "SELECT * FROM lists WHERE eperson_id=" + eperson.getID() + " AND shared=true";
		}
		List<TableRow> rows = (List<TableRow>)DatabaseManager.query(context, query).toList();		

		return rowsToMap(rows);
	}

	public static Map<Integer, String> getLists(Context context, EPerson eperson) throws SQLException
	{
		return rowsToMap(getListsRaw(context, eperson));
	}
	
	private static Map<Integer, String> rowsToMap(List<TableRow> rows)
	{
		Map<Integer,String> lists = new LinkedHashMap<Integer,String>();
		
		for (TableRow row : rows)
        {
			int list_id = row.getIntColumn("list_id");
			String list_name = row.getStringColumn("list_name");
			lists.put(list_id, list_name);
        }
        
        return lists;		
	}
	
	public static String checkList(Context context, EPerson eperson, int list_id) throws SQLException
	{
		String query = "SELECT list_name FROM lists WHERE eperson_id=" + eperson.getID() + " AND list_id=" + list_id;
		TableRow row = DatabaseManager.querySingle(context, query);		

		return (row == null)? null : row.getStringColumn("list_name");
	}
	
	public static String checkListShared(Context context, EPerson eperson, int list_id) throws SQLException
	{
		Integer epersonID = (eperson == null)? 0 : eperson.getID();
		String query = "SELECT list_name FROM lists WHERE (eperson_id=" + epersonID + "OR shared=true) AND list_id=" + list_id;
		TableRow row = DatabaseManager.querySingle(context, query);
		
		return (row == null)? null : row.getStringColumn("list_name");
	}
	
	public static EPerson getListOwner(Context context, int list_id) throws SQLException
	{
		String query = "SELECT eperson_id FROM lists WHERE list_id=" + list_id;
		TableRow row = DatabaseManager.querySingle(context, query);

		return (row == null)? null : EPerson.find(context, row.getIntColumn("eperson_id"));
	}

	public static String getListComment(Context context, int list_id) throws SQLException
	{
		String query = "SELECT list_comment FROM lists WHERE list_id=" + list_id;
		TableRow row = DatabaseManager.querySingle(context, query);

		return (row == null)? null : row.getStringColumn("list_comment");
	}

	public static void setListComment(Context context, int list_id, String comment) throws SQLException
	{
		TableRow row = DatabaseManager.find(context, "lists", list_id);

		if (row != null)
		{
			row.setColumn("list_comment", comment);
			DatabaseManager.update(context, row);
		}
	}

	public static void setListName(Context context, int list_id, String name) throws SQLException
	{
		TableRow row = DatabaseManager.find(context, "lists", list_id);

		if (row != null)
		{
			row.setColumn("list_name", name);
			DatabaseManager.update(context, row);
		}
	}

	public static int getListMax(Context context, int list_id) throws SQLException
	{
		String maxq = "SELECT COALESCE(MAX(ordernum),0) AS max FROM list_entries WHERE list_id=" + list_id;
		TableRow maxrow = DatabaseManager.querySingle(context, maxq);
		return maxrow.getIntColumn("max");		
	}
	
	public static Map<Integer,String> getListsForItem(Context context, EPerson eperson, int item_id) throws SQLException
	{
		String query = "SELECT DISTINCT list_id, list_name FROM lists NATURAL JOIN list_entries WHERE item_id=" + item_id + " AND eperson_id=" + eperson.getID() + " ORDER BY list_name";
		List<TableRow> rows = (List<TableRow>)DatabaseManager.query(context, query).toList();
		
		Map<Integer,String> result = new LinkedHashMap<Integer,String>();
		for (TableRow row : rows)
		{
			int list_id = row.getIntColumn("list_id");
			String list_name = row.getStringColumn("list_name");
			result.put(list_id, list_name);
		}
		
		return result;
	}
	
	public static boolean addItem(Context context, int list_id, int item_id) throws SQLException
	{
		EPerson eperson = context.getCurrentUser();
		boolean ok = checkList(context, eperson, list_id) != null;

		if (!ok) return false;
		
		int maxnum = getListMax(context, list_id);
		
		TableRow row = DatabaseManager.create(context, "list_entries");
		row.setColumn("list_id", list_id);
		row.setColumn("ordernum", maxnum+1);
		row.setColumn("item_id", item_id);
		DatabaseManager.update(context, row);
		
		return true;
	}
	
	public static boolean addItems(Context context, int list_id, List<Integer> item_ids) throws SQLException
	{
		EPerson eperson = context.getCurrentUser();
		boolean ok = checkList(context, eperson, list_id) != null;

		if (!ok) return false;
		
		int ordernum = getListMax(context, list_id)+1;
		
		for (Integer item_id : item_ids)
		{
			TableRow row = DatabaseManager.create(context, "list_entries");
			row.setColumn("list_id", list_id);
			row.setColumn("ordernum", ordernum);
			row.setColumn("item_id", item_id);
			DatabaseManager.update(context, row);
			
			ordernum++;
		}
		
		return true;
	}
	
	
	public static void swapItemOrder(Context context, TableRow row1, TableRow row2) throws SQLException
	{
		int idx1 = row1.getIntColumn("ordernum");
		int idx2 = row2.getIntColumn("ordernum");
		row1.setColumn("ordernum", idx2);
		row2.setColumn("ordernum", idx1);
		DatabaseManager.update(context, row1);
		DatabaseManager.update(context, row2);		
	}
	
	public static List<TableRow> getListItems(Context context, int list_id) throws SQLException
	{
		String query = "SELECT * FROM list_entries WHERE list_id=" + list_id + " ORDER BY ordernum";
    	return (List<TableRow>)DatabaseManager.queryTable(context, "list_entries", query).toList();
	}
	
	public static List<Integer> getListItemIDs(Context context, int list_id) throws SQLException
	{
		List<Integer> ids = new ArrayList<Integer>();
		for (TableRow row : getListItems(context,list_id))
		{
			ids.add(row.getIntColumn("item_id"));
		}
		return ids;
	}
	
	public static int createList(Context context, EPerson eperson, String name) throws SQLException
	{
		TableRow row = DatabaseManager.create(context, "lists");
		row.setColumn("eperson_id", eperson.getID());
		row.setColumn("list_name", name);
		row.setColumn("shared", false);
		row.setColumn("list_comment", "");
		DatabaseManager.update(context, row);

		return row.getIntColumn("list_id");
	}
	
	public static void deleteList(Context context, int list_id) throws SQLException
	{
		DatabaseManager.deleteByValue(context, "list_entries", "list_id", list_id);
		DatabaseManager.delete(context, "lists", list_id);
	}
	
	public static void copyList(Context context, int from_id, int to_id) throws SQLException
	{
		String query = "SELECT ordernum, item_id FROM list_entries WHERE list_id=" + from_id;
		List<TableRow> rows = (List<TableRow>)DatabaseManager.query(context, query).toList();

		for (TableRow oldrow : rows)
		{
			TableRow newrow = DatabaseManager.create(context, "list_entries");
			newrow.setColumn("list_id", to_id);
			newrow.setColumn("ordernum", oldrow.getIntColumn("ordernum"));
			newrow.setColumn("item_id", oldrow.getIntColumn("item_id"));
			DatabaseManager.update(context, newrow);
		}
	}

	public static void shareList(Context context, Integer list_id, boolean shared) throws SQLException 
	{
		TableRow row = DatabaseManager.find(context, "lists", list_id);
		row.setColumn("shared", shared);
		DatabaseManager.update(context, row);
	}
	
	public static void handle_item_delete(Context context, int item_id) throws SQLException
	{
    	DatabaseManager.deleteByValue(context, "list_entries", "item_id", item_id);
	}

	public static void handle_eperson_delete(Context context, int eperson_id) throws SQLException
	{
		String query = "SELECT list_id FROM lists WHERE eperson_id=" + eperson_id;
		List<TableRow> rows = (List<TableRow>)DatabaseManager.query(context, query).toList();
		
		for (TableRow row : rows)
		{
			deleteList(context, row.getIntColumn("list_id"));
        }        
	}

}
