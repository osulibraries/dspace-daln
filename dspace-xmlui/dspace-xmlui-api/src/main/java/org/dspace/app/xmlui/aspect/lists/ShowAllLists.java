package org.dspace.app.xmlui.aspect.lists;

import java.io.IOException;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Comparator;
import java.util.List;
import java.util.Map;
import java.util.TreeMap;

import org.apache.cocoon.environment.ObjectModelHelper;
import org.apache.cocoon.environment.Request;
import org.dspace.app.xmlui.cocoon.AbstractDSpaceTransformer;
import org.dspace.app.xmlui.wing.Message;
import org.dspace.app.xmlui.wing.WingException;
import org.dspace.app.xmlui.wing.element.Body;
import org.dspace.app.xmlui.wing.element.Division;
import org.dspace.app.xmlui.wing.element.PageMeta;
import org.dspace.app.xmlui.wing.element.Row;
import org.dspace.app.xmlui.wing.element.Table;
import org.dspace.app.xmlui.wing.element.Text;
import org.dspace.authorize.AuthorizeException;
import org.dspace.eperson.EPerson;

import edu.emory.mathcs.backport.java.util.Collections;

public class ShowAllLists extends AbstractDSpaceTransformer {

    private static final Message T_dspace_home = message("xmlui.general.dspace_home");  
	private static final Message T_title = message("xmlui.Lists.ShowAllLists.title");
	private static final Message T_trail = message("xmlui.Lists.ShowAllLists.trail");
	private static final Message T_head = message("xmlui.Lists.ShowAllLists.head");
	private static final Message T_search_label = message("xmlui.Lists.ShowAllLists.search_label");
	private static final Message T_go = message("xmlui.Lists.ShowAllLists.go");
	private static final Message T_no_user = message("xmlui.Lists.ShowAllLists.no_user");
	private static final Message T_no_results = message("xmlui.Lists.ShowAllLists.no_results");
	private static final Message T_results = message("xmlui.Lists.ShowAllLists.results");

    @Override
    public void addPageMeta(PageMeta pageMeta) throws WingException, SQLException, IOException
    {
        pageMeta.addMetadata("title").addContent("Show All Lists"); // T_title
        
        pageMeta.addTrailLink(contextPath + "/", T_dspace_home);
		
        pageMeta.addTrail().addContent("Show All Lists"); // T_trail
    }

    // XXX this is a mere stopgap page and not meant for final production
    
    @Override
	public void addBody(Body body) throws WingException, SQLException, AuthorizeException {

        Request request = ObjectModelHelper.getRequest(objectModel);
        String query = URLDecode(request.getParameter("query"));    	
    	
        Division search = body.addDivision("show_lists","primary");
        search.setHead("All Shared Lists"); // T_head

        final Map<Integer,String> rawlists = ListUtils.getListsShared(context, null);
        
        // sort alphabetically.  Urf.
        Map<Integer,String> lists = new TreeMap<Integer,String>(new Comparator<Object>(){
			public int compare(Object o1, Object o2) {
				Integer k1 = (Integer)o1;
				Integer k2 = (Integer)o2;
				int res = rawlists.get(k1).compareTo(rawlists.get(k2));
				return (res == 0)? k1.compareTo(k2) : res;
			}        	
        });
        lists.putAll(rawlists);

        if (lists.size() == 0)
        {
        	search.addPara("No Shared Lists"); // T_no_lists
        }
        else
        {
        	Table listTable = search.addTable("all-lists-table", 1, 4);
    		Row row = listTable.addRow(Row.ROLE_HEADER);
    		row.addCell().addContent("List Name"); // T_header_list_name
    		row.addCell().addContent("Creator Name"); // T_header_creator_name
    		row.addCell().addContent("Description"); // T_header_description
    		row.addCell().addContent(" ");
        	for (Map.Entry<Integer, String> entry : lists.entrySet())
        	{
        		int list_id = entry.getKey();
        		String list_name = entry.getValue();
        		EPerson eperson = ListUtils.getListOwner(context, list_id);
        		String description = ListUtils.getListComment(context, list_id);
			int truncAt = description.indexOf(' ',100);
        		if (description.length() > 100 && truncAt != -1) {
        			description = description.substring(0,truncAt) + "...";        			
        		}
        		
        		row = listTable.addRow(Row.ROLE_DATA);
        		row.addCell().addXref("/lists/view-list/view" + "?list_id=" + list_id).addContent(list_name);
        		row.addCell().addXref("/lists/search-lists/view" + "?query=" + eperson.getEmail()).addContent(eperson.getFullName());
        		row.addCell().addContent(description);
        		row.addCell().addXref("/browse?type=list&list_id=" + list_id).addContent("(browse)");
        	}
        }
	}
	
}
