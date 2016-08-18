package org.dspace.app.xmlui.aspect.lists;

import java.sql.SQLException;
import java.util.Map;

import org.apache.cocoon.environment.ObjectModelHelper;
import org.apache.cocoon.environment.Request;
import org.dspace.app.xmlui.aspect.forms.BaseForm;
import org.dspace.app.xmlui.wing.Message;
import org.dspace.app.xmlui.wing.WingException;
import org.dspace.app.xmlui.wing.element.Body;
import org.dspace.app.xmlui.wing.element.Division;
import org.dspace.app.xmlui.wing.element.PageMeta;
import org.dspace.app.xmlui.wing.element.Para;
import org.dspace.app.xmlui.wing.element.Row;
import org.dspace.app.xmlui.wing.element.Select;
import org.dspace.app.xmlui.wing.element.Table;
import org.dspace.app.xmlui.wing.element.Text;

public class EditLists extends BaseForm {

    private static final Message T_dspace_home = message("xmlui.general.dspace_home");  
	private static final Message T_title = message("xmlui.Lists.EditLists.title");
	private static final Message T_head = message("xmlui.Lists.EditLists.head");
	private static final Message T_return = message("xmlui.Lists.EditLists.return");
	private static final Message T_add_new = message("xmlui.Lists.EditLists.add");
	private static final Message T_create = message("xmlui.Lists.EditLists.create");
	private static final Message T_from_scratch = message("xmlui.Lists.EditLists.from_scratch");
	private static final Message T_or = message("xmlui.Lists.EditLists.or");
	private static final Message T_based_on = message("xmlui.Lists.EditLists.based_on");
	private static final Message T_list_head = message("xmlui.Lists.EditLists.list_head");
	private static final Message T_edit = message("xmlui.Lists.EditLists.edit");
	private static final Message T_delete = message("xmlui.Lists.EditLists.delete");
	private static final Message T_share = message("xmlui.Lists.EditLists.share");
	private static final Message T_unshare = message("xmlui.Lists.EditLists.unshare");

	@Override
	public void addPageMeta(PageMeta pageMeta) throws SQLException, WingException {
        pageMeta.addMetadata("title").addContent(T_title);

		pageMeta.addTrailLink(contextPath + "/",T_dspace_home);
		pageMeta.addTrail().addContent(T_title);
	}

	@Override
	public void addBody(Body body) throws SQLException, WingException {

		Request request = ObjectModelHelper.getRequest(objectModel);

        EditListsAction action = (EditListsAction)request.getAttribute("action");
        Map<Integer,String> lists = action.getLists();
        
        String submitURL = contextPath + "/lists/lists";

        errors = action.getErrors();
        
        Division div = body.addDivision("edit-value-lists-page", "primary");
        div.setHead(T_head);

        Division formdiv = div.addInteractiveDivision("edit-lists-form", submitURL, Division.METHOD_POST, null);
        //formdiv.setHead("");
        formdiv.addHidden("continue").setValue(knot.getId());
        
        Para formpara = formdiv.addPara();
        formpara.addButton("cancel").setValue(T_return);

        maybeErrorHeading(formdiv);

        // new lists
        Division newdiv = formdiv.addDivision("new-list","secondary");
        newdiv.setHead(T_add_new);
        
        Para newpara = newdiv.addPara();
        newpara.addContent(T_create);
        newpara.addContent(" ");
        Text name = newpara.addText("name");
        name.setValue(action.getParameter("name"));
        maybeError(newpara, "name");
        
        Para newpara2 = newdiv.addPara();
        newpara2.addButton("new").setValue(T_from_scratch);
        if (lists.size() > 0)
        {
        	newpara2.addContent(" ");
        	newpara2.addContent(T_or);
        	newpara2.addContent(" ");
        	newpara2.addButton("copy").setValue(T_based_on);
        	Select base = newpara2.addSelect("base");
        	Integer basedOn = action.getIntParameter("base");
        	for (Map.Entry<Integer, String> list : lists.entrySet())
        	{
        		base.addOption(list.getKey() == basedOn, list.getKey(), list.getValue());
        	}
        	maybeError(newpara2, "base");
        }

    	// edit lists
        if (!lists.isEmpty())
        {
        	Division listsdiv = formdiv.addDivision("edit-lists","secondary");
        	listsdiv.setHead(T_list_head);

        	String listURL = contextPath + "/lists/list" + "?continue=" + knot.getId();

        	Table listtable = listsdiv.addTable("edit-lists-table", 1, 3);

        	for (Map.Entry<Integer, String> list : lists.entrySet())
        	{
        		Row row = listtable.addRow(Row.ROLE_DATA);
        		row.addCell().addContent(list.getValue());
        		row.addCell().addXref(listURL + "&base=" + list.getKey()).addContent(T_edit);
        		row.addCell().addButton("remove"+list.getKey(),"link").setValue(T_delete);
        		if (action.isShared(list.getKey()))
        		{
            		row.addCell().addButton("unshare"+list.getKey(),"link").setValue(T_unshare);        			
        		}
        		else
        		{
            		row.addCell().addButton("share"+list.getKey(),"link").setValue(T_share);        			
        		}
        	}
        }

	}
	
}
