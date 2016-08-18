package org.dspace.app.xmlui.aspect.tagging;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.LinkedHashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.SortedMap;
import java.util.SortedSet;
import java.util.TreeMap;
import java.util.TreeSet;
import java.util.Vector;

import org.apache.log4j.Logger;
import org.dspace.content.Collection;
import org.dspace.content.Community;
import org.dspace.content.DSpaceObject;
import org.dspace.content.Item;
import org.dspace.core.Context;
import org.dspace.eperson.EPerson;
import org.dspace.search.DSIndexer;
import org.dspace.storage.rdbms.DatabaseManager;
import org.dspace.storage.rdbms.TableRow;
import org.dspace.storage.rdbms.TableRowIterator;

public class TagManager {

    /** log4j category */
    private static Logger log = Logger.getLogger(Item.class);

    // still todo
    // tag -> item (for browse)
    // handle eperson delete event (implement consumer)
    // handle item delete event (implement consumer)

    // eperson and focus can be null
    public static Set<Item> getItemsByTag(Context context, String tag_name, EPerson eperson, DSpaceObject focus) throws SQLException
    {
    	String query = "SELECT DISTINCT item_id FROM eperson_item2tag";
    	String where = " WHERE tag_name=?";
    	if (focus == null)
    	{
    	}
    	else if (focus instanceof Collection)
    	{
    		query += " NATURAL JOIN collection2item";
    		where += " AND collection2item.collection_id=" + ((Collection)focus).getID();
    	}
    	else if (focus instanceof Community)
    	{
    		query += " NATURAL JOIN community2item";
    		where += " AND community2item.community_id=" + ((Community)focus).getID();    			
    	}
    	if (eperson != null)
    	{
    		where += " AND eperson_id=" + eperson.getID();
    	}
    	
    	LinkedHashSet<Item> result = new LinkedHashSet<Item>();
    	TableRowIterator tri = DatabaseManager.query(context, query+where, tag_name);
        try
        {
            while (tri.hasNext())
            {
                TableRow row = tri.next();
                int item_id = row.getIntColumn("item_id");
                Item item = Item.find(context, item_id);
                result.add(item);
            }
        }
        finally
        {
            if (tri != null)
                tri.close();
        }

    	return result;    	
    }

    public static Map<EPerson, List<String>> getTagsForItem(Context context, DSpaceObject dso) throws SQLException
    {
    	String query = "SELECT eperson_id, tag_name FROM eperson_item2tag WHERE item_id=" + ((Item)dso).getID();

    	Map<EPerson, List<String>> result = new HashMap<EPerson,List<String>>();
    	TableRowIterator tri = DatabaseManager.query(context, query);
        try
        {
            while (tri.hasNext())
            {
                TableRow row = tri.next();
                int eperson_id = row.getIntColumn("eperson_id");
                EPerson eperson = EPerson.find(context, eperson_id);
                String tag_name = row.getStringColumn("tag_name");
                List<String> tags = result.get(eperson);
                if (tags == null)
                	tags = new Vector<String>();
                tags.add(tag_name);
                result.put(eperson, tags);
            }
        }
        finally
        {
            if (tri != null)
                tri.close();
        }

    	return result;    	    	    	
    }
    
    public static Map<String, Integer> getTagCounts(Context context, DSpaceObject dso, EPerson eperson) throws SQLException
    {
    	String query = "SELECT tag_name, COUNT(*) AS count FROM eperson_item2tag";
    	String group = " GROUP BY tag_name";
    	String where = "";
    	String conj = " WHERE ";
    	if (dso instanceof Collection)
    	{
    		query += " NATURAL JOIN collection2item";
    		where += conj + "collection2item.collection_id=" + ((Collection)dso).getID();
    		conj = " AND ";
    	}
    	else if (dso instanceof Community)
    	{
    		query += " NATURAL JOIN community2item";
    		where += conj + "community2item.community_id=" + ((Community)dso).getID();    			
    		conj = " AND ";
    	}
    	else if (dso instanceof Item)
    	{
    		where += conj + "item_id=" + ((Item)dso).getID();
    		conj = " AND ";
    	}
    	if (eperson != null)
    	{
    		where += conj + "eperson_id=" + eperson.getID();
    		conj = " AND ";
    	}
    	String order = " ORDER BY count, tag_name";
    	
    	LinkedHashMap<String,Integer> result = new LinkedHashMap<String,Integer>();
    	TableRowIterator tri = DatabaseManager.query(context, query+where+group+order);
        try
        {
            while (tri.hasNext())
            {
                TableRow row = tri.next();
                String tag_name = row.getStringColumn("tag_name");
                int count = (int)row.getLongColumn("count");
                result.put(tag_name, count);
            }
        }
        finally
        {
            if (tri != null)
                tri.close();
        }

    	return result;    	    	
    }
    
    
    private static TableRow getRow(Context context, EPerson eperson, Item item, String tag_name) throws SQLException
    {
    	int eperson_id = eperson.getID();
    	int item_id = item.getID();
    	TableRow row = DatabaseManager.querySingleTable(context, "eperson_item2tag",
    			"SELECT * FROM eperson_item2tag WHERE eperson_id="+eperson_id+
    			" AND item_id="+item_id+" AND tag_name=?", tag_name);
    	return row;
    }
    
    public static void add(Context context, EPerson eperson, Item item, String tag_name) throws SQLException
    {
    	int eperson_id = eperson.getID();
    	int item_id = item.getID();
    	TableRow row = getRow(context, eperson, item, tag_name);
    	if (row == null)
    	{
    		row = DatabaseManager.create(context, "eperson_item2tag");
    		row.setColumn("eperson_id", eperson_id);
    		row.setColumn("item_id", item_id);
    		row.setColumn("tag_name", tag_name);    		
    		DatabaseManager.update(context, row);
    	}    	
    	DSIndexer.indexContent(context, item, true);
    }
    
    public static void delete(Context context, EPerson eperson, Item item, String tag_name) throws SQLException
    {
    	TableRow row = getRow(context, eperson, item, tag_name);
    	if (row != null)
    	{
    		DatabaseManager.delete(context, row);
    	}    	
    	DSIndexer.indexContent(context, item, true);
    }
    
    static void handle_item_delete(Context context, int item_id) throws SQLException
    {
    	DatabaseManager.deleteByValue(context, "eperson_item2tag", "item_id", item_id);
    }
    
    static void handle_eperson_delete(Context context, int eperson_id) throws SQLException
    {
    	DatabaseManager.deleteByValue(context, "eperson_item2tag", "eperson_id", eperson_id);    	
    }
    
}
