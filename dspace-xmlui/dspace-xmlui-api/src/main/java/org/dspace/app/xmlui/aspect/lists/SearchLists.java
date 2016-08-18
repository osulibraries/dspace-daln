package org.dspace.app.xmlui.aspect.lists;

import java.io.IOException;
import java.sql.SQLException;
import java.util.Map;

import org.apache.cocoon.environment.ObjectModelHelper;
import org.apache.cocoon.environment.Request;
import org.dspace.app.xmlui.cocoon.AbstractDSpaceTransformer;
import org.dspace.app.xmlui.wing.Message;
import org.dspace.app.xmlui.wing.WingException;
import org.dspace.app.xmlui.wing.element.Body;
import org.dspace.app.xmlui.wing.element.Division;
import org.dspace.app.xmlui.wing.element.List;
import org.dspace.app.xmlui.wing.element.PageMeta;
import org.dspace.app.xmlui.wing.element.Row;
import org.dspace.app.xmlui.wing.element.Table;
import org.dspace.app.xmlui.wing.element.Text;
import org.dspace.authorize.AuthorizeException;
import org.dspace.eperson.EPerson;

public class SearchLists extends AbstractDSpaceTransformer {

    private static final Message T_dspace_home = message("xmlui.general.dspace_home");  
	private static final Message T_title = message("xmlui.Lists.SearchLists.title");
	private static final Message T_trail = message("xmlui.Lists.SearchLists.trail");
	private static final Message T_head = message("xmlui.Lists.SearchLists.head");
	private static final Message T_search_label = message("xmlui.Lists.SearchLists.search_label");
	private static final Message T_go = message("xmlui.Lists.SearchLists.go");
	private static final Message T_no_user = message("xmlui.Lists.SearchLists.no_user");
	private static final Message T_no_results = message("xmlui.Lists.SearchLists.no_results");
	private static final Message T_results = message("xmlui.Lists.SearchLists.results");

    @Override
    public void addPageMeta(PageMeta pageMeta) throws WingException, SQLException, IOException
    {
        pageMeta.addMetadata("title").addContent(T_title);
        
        pageMeta.addTrailLink(contextPath + "/", T_dspace_home);
		
        pageMeta.addTrail().addContent(T_trail);
    }

    @Override
	public void addBody(Body body) throws WingException, SQLException, AuthorizeException {

        Request request = ObjectModelHelper.getRequest(objectModel);
        String query = URLDecode(request.getParameter("query"));    	
    	
        Division search = body.addDivision("search","primary");
        search.setHead(T_head);
        Division querydiv = search.addInteractiveDivision("list-query", "/lists/search-lists/view", 
        		Division.METHOD_GET,"secondary search");

        List queryList = querydiv.addList("search-query",List.TYPE_FORM);

        Text text = queryList.addItem().addText("query");
        text.setLabel(T_search_label);
        text.setValue(query);

        querydiv.addPara(null, "button-list").addButton("submit").setValue(T_go);

        if (query != null && query.length() > 0)
        {
    		Division results = search.addDivision("search-results","primary");

    		EPerson eperson = EPerson.findByEmail(context, query);
        	
        	if (eperson == null)
        	{
    			results.addPara(T_no_user.parameterize(query));        		
        	}
        	else 
        	{
        		Map<Integer,String> lists = ListUtils.getListsShared(context, eperson);

        		if (lists.size() == 0)
        		{
        			results.addPara(T_no_results.parameterize(query));
        		}
        		else
        		{
        			results.setHead(T_results.parameterize(query));

        			Table listTable = results.addTable("result-table", 1, 2);
        			for (Map.Entry<Integer, String> entry : lists.entrySet())
        			{
        				Row row = listTable.addRow(Row.ROLE_DATA);
        				row.addCell().addXref("/lists/view-list/view" + "?list_id=" + entry.getKey()).addContent(entry.getValue());
        				row.addCell().addXref("/browse?type=list&list_id=" + entry.getKey()).addContent("(browse)");
        			}
        		}
        	}
        }
	}
	
}
