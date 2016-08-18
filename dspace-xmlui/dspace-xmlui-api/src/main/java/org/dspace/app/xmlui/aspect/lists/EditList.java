package org.dspace.app.xmlui.aspect.lists;

import java.sql.SQLException;
import java.util.List;

import org.apache.cocoon.environment.ObjectModelHelper;
import org.apache.cocoon.environment.Request;
import org.dspace.app.xmlui.aspect.forms.BaseForm;
import org.dspace.app.xmlui.wing.Message;
import org.dspace.app.xmlui.wing.WingException;
import org.dspace.app.xmlui.wing.element.Body;
import org.dspace.app.xmlui.wing.element.Cell;
import org.dspace.app.xmlui.wing.element.Division;
import org.dspace.app.xmlui.wing.element.PageMeta;
import org.dspace.app.xmlui.wing.element.Para;
import org.dspace.app.xmlui.wing.element.ReferenceSet;
import org.dspace.app.xmlui.wing.element.Row;
import org.dspace.app.xmlui.wing.element.Table;
import org.dspace.app.xmlui.wing.element.TextArea;
import org.dspace.content.Item;

public class EditList extends BaseForm {

    private static final Message T_dspace_home = message("xmlui.general.dspace_home");
    private static final Message T_title = message("xmlui.Lists.EditList.title");
    private static final Message T_head = message("xmlui.Lists.EditList.head");
    private static final Message T_save = message("xmlui.Lists.EditList.save");
    private static final Message T_return = message("xmlui.Lists.EditList.return");
    private static final Message T_move_up = message("xmlui.Lists.EditList.move_up");
    private static final Message T_move_down = message("xmlui.Lists.EditList.move_down");
    private static final Message T_delete = message("xmlui.Lists.EditList.delete");
    private static final Message T_rename = message("xmlui.Lists.EditList.rename");

    @Override
	public void addPageMeta(PageMeta pageMeta) throws SQLException, WingException {
        pageMeta.addMetadata("title").addContent(T_title);

		pageMeta.addTrailLink(contextPath + "/",T_dspace_home);
		pageMeta.addTrail().addContent(T_title);
	}

	@Override
	public void addBody(Body body) throws SQLException, WingException {

		Request request = ObjectModelHelper.getRequest(objectModel);

        EditListAction action = (EditListAction)request.getAttribute("action");
        List<Integer> list = action.getList(); // item-ids
        
        String submitURL = contextPath + "/lists/list";

        errors = action.getErrors();

        boolean isRename = request.getParameter("rename") != null;

        Division div = body.addDivision("edit-list-page", "primary");
        div.setHead(T_head);

        Division formdiv = div.addInteractiveDivision("edit-list-form", submitURL, Division.METHOD_POST, null);
        if (isRename)
        {
        	formdiv.addPara().addText("list-name").setValue(action.getName());
        }
        else
        {
        	formdiv.setHead("\"" + action.getName() + "\"");        	
        }

        formdiv.addHidden("continue").setValue(knot.getId());        
        
        Para formpara = formdiv.addPara();
        formpara.addButton("save").setValue(T_save);
        formpara.addButton("cancel").setValue(T_return);
        if (!isRename)
        {
        	formpara.addButton("rename").setValue(T_rename);
        }

        maybeErrorHeading(formdiv);

        formdiv.addPara().addContent("Description");
        Para commentpara = formdiv.addPara();
        TextArea comment = commentpara.addTextArea("list-comment"); 
        comment.setValue(action.getComment());        
        
        int numentries = list.size();
        if (numentries > 0)
        {
        	Table pairtable = formdiv.addTable("edit-list-table", 1, 4);

        	int i = 0;
        	for (Integer item_id : list)
        	{
        		Item item = Item.find(context, item_id);

        		Row row = pairtable.addRow(Row.ROLE_DATA);

        		Cell cell1 = row.addCell();
        		ReferenceSet refset = cell1.addReferenceSet("list-ref" + i, ReferenceSet.TYPE_SUMMARY_LIST, null, null);
        		refset.addReference(item);

        		Cell upcell = row.addCell();
        		if (i > 0)
        		{
        			upcell.addButton("itemup"+i, "link").setValue(T_move_up);
        		}

        		Cell downcell = row.addCell();
        		if (i < numentries-1)
        		{
        			downcell.addButton("itemdown"+i, "link").setValue(T_move_down);
        		}

        		row.addCell().addButton("itemremove"+i, "link").setValue(T_delete);

        		i++;
        	}
        }
	}
    
}
