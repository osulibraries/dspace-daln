package org.dspace.app.xmlui.aspect.forms;

import java.sql.SQLException;
import java.util.Map;
import java.util.Set;

import org.apache.cocoon.environment.ObjectModelHelper;
import org.apache.cocoon.environment.Request;
import org.dspace.app.xmlui.cocoon.AbstractDSpaceTransformer;
import org.dspace.app.xmlui.utils.HandleUtil;
import org.dspace.app.xmlui.wing.Message;
import org.dspace.app.xmlui.wing.WingException;
import org.dspace.app.xmlui.wing.element.Body;
import org.dspace.app.xmlui.wing.element.Division;
import org.dspace.app.xmlui.wing.element.PageMeta;
import org.dspace.app.xmlui.wing.element.Para;
import org.dspace.app.xmlui.wing.element.RichTextContainer;
import org.dspace.app.xmlui.wing.element.Row;
import org.dspace.app.xmlui.wing.element.Select;
import org.dspace.app.xmlui.wing.element.Table;
import org.dspace.app.xmlui.wing.element.Text;
import org.dspace.content.DSpaceObject;

public class ValueLists extends BaseForm {

    private static final Message T_dspace_home = message("xmlui.general.dspace_home");  
	private static final Message T_title = message("xmlui.Forms.ValueLists.title");
	private static final Message T_head = message("xmlui.Forms.ValueLists.head");
	private static final Message T_return = message("xmlui.Forms.ValueLists.return");
	private static final Message T_add_new = message("xmlui.Forms.ValueLists.add");
	private static final Message T_create = message("xmlui.Forms.ValueLists.create");
	private static final Message T_from_scratch = message("xmlui.Forms.ValueLists.from_scratch");
	private static final Message T_or = message("xmlui.Forms.ValueLists.or");
	private static final Message T_based_on = message("xmlui.Forms.ValueLists.based_on");
	private static final Message T_list_head = message("xmlui.Forms.ValueLists.list_head");
	private static final Message T_edit = message("xmlui.Forms.ValueLists.edit");
	private static final Message T_delete = message("xmlui.Forms.ValueLists.delete");

    @Override
	public void addPageMeta(PageMeta pageMeta) throws SQLException, WingException {
        DSpaceObject dso = HandleUtil.obtainHandle(objectModel);

        pageMeta.addMetadata("title").addContent(T_title);

		pageMeta.addTrailLink(contextPath + "/",T_dspace_home);
		HandleUtil.buildHandleTrail(dso,pageMeta,contextPath);
		pageMeta.addTrail().addContent(T_title);
	}

	@Override
	public void addBody(Body body) throws SQLException, WingException {

		Request request = ObjectModelHelper.getRequest(objectModel);

        ValueListsAction action = (ValueListsAction)request.getAttribute("action");
        Set<String> valueLists = action.getValueListNames();
        
        String submitURL = contextPath + "/forms/value-lists";

        errors = action.getErrors();
        
        Division div = body.addDivision("edit-value-lists-page", "primary");
        div.setHead(T_head);

        Division formdiv = div.addInteractiveDivision("edit-value-lists-form", submitURL, Division.METHOD_POST, null);
        //formdiv.setHead("");
        formdiv.addHidden("continue").setValue(knot.getId());
        
        Para formpara = formdiv.addPara();
        formpara.addButton("cancel").setValue(T_return);

        maybeErrorHeading(formdiv);

        // new lists
        Division newdiv = formdiv.addDivision("new-value-lists","secondary");
        newdiv.setHead(T_add_new);
        
        Para newpara = newdiv.addPara();
        newpara.addContent(T_create);
        newpara.addContent(" ");
        Text name = newpara.addText("name");
        name.setValue(action.getParameter("name"));
        maybeError(newpara, "name");
        
        Para newpara2 = newdiv.addPara();
        newpara2.addButton("new").setValue(T_from_scratch);
        newpara2.addContent(" ");
        newpara2.addContent(T_or);
        newpara2.addContent(" ");
        newpara2.addButton("copy").setValue(T_based_on);
        Select base = newpara2.addSelect("base");
        String basedOn = action.getParameter("base");
        for (String listName : valueLists)
        {
        	base.addOption(listName.equals(basedOn),listName, listName);
        }
        maybeError(newpara2, "base");

    	// edit lists
        if (!valueLists.isEmpty())
        {
        	Division listsdiv = formdiv.addDivision("edit-value-lists","secondary");
        	listsdiv.setHead(T_list_head);

        	String listURL = contextPath + "/forms/value-list" + "?continue=" + knot.getId();

        	Table listtable = listsdiv.addTable("edit-value-lists-table", 1, 3);

        	for (String listName : valueLists)
        	{
        		String encodedName = URLEncode(listName);
        		Row row = listtable.addRow(Row.ROLE_DATA);
        		row.addCell().addContent(listName);
        		row.addCell().addXref(listURL + "&base=" + encodedName).addContent(T_edit);
        		row.addCell().addButton("remove"+encodedName,"link").setValue(T_delete);
        	}
        }

	}
	
}
