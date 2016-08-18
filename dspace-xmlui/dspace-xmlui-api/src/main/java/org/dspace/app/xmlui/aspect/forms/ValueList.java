package org.dspace.app.xmlui.aspect.forms;

import java.sql.SQLException;
import java.util.Vector;

import org.apache.cocoon.environment.ObjectModelHelper;
import org.apache.cocoon.environment.Request;
import org.dspace.app.xmlui.aspect.forms.ValueListAction.Pair;
import org.dspace.app.xmlui.utils.HandleUtil;
import org.dspace.app.xmlui.wing.Message;
import org.dspace.app.xmlui.wing.WingException;
import org.dspace.app.xmlui.wing.element.Body;
import org.dspace.app.xmlui.wing.element.Cell;
import org.dspace.app.xmlui.wing.element.Division;
import org.dspace.app.xmlui.wing.element.PageMeta;
import org.dspace.app.xmlui.wing.element.Para;
import org.dspace.app.xmlui.wing.element.Row;
import org.dspace.app.xmlui.wing.element.Table;
import org.dspace.content.DSpaceObject;

public class ValueList extends BaseForm {

    private static final Message T_dspace_home = message("xmlui.general.dspace_home");
    private static final Message T_title = message("xmlui.Forms.ValueList.title");
    private static final Message T_head = message("xmlui.Forms.ValueList.head");
    private static final Message T_save = message("xmlui.Forms.ValueList.save");
    private static final Message T_return = message("xmlui.Forms.ValueList.return");
    private static final Message T_display = message("xmlui.Forms.ValueList.display");
    private static final Message T_uid = message("xmlui.Forms.ValueList.uid");
    private static final Message T_move_up = message("xmlui.Forms.ValueList.move_up");
    private static final Message T_move_down = message("xmlui.Forms.ValueList.move_down");
    private static final Message T_delete = message("xmlui.Forms.ValueList.delete");
    private static final Message T_add = message("xmlui.Forms.ValueList.add");

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

        ValueListAction action = (ValueListAction)request.getAttribute("action");
        Vector<Pair> valueList = action.getValueList();
        
        String submitURL = contextPath + "/forms/value-list";

        errors = action.getErrors();
        
        Division div = body.addDivision("edit-value-lists-page", "primary");
        div.setHead(T_head);

        Division formdiv = div.addInteractiveDivision("edit-value-lists-form", submitURL, Division.METHOD_POST, null);
        formdiv.setHead("\"" + action.getName() + "\"");

        formdiv.addHidden("continue").setValue(knot.getId());
        
        Para formpara = formdiv.addPara();
        formpara.addButton("save").setValue(T_save);
        formpara.addButton("cancel").setValue(T_return);

        maybeErrorHeading(formdiv);

    	Table pairtable = formdiv.addTable("edit-value-list-table", 1, 5);

    	Row header = pairtable.addRow(Row.ROLE_HEADER);
    	header.addCell().addContent(T_display);
    	header.addCell().addContent(T_uid);
    	header.addCell();
    	header.addCell();
    	header.addCell();
    	
        int numpairs = valueList.size();
        for (int i = 0; i < numpairs; i++)
        {
        	Row row = pairtable.addRow(Row.ROLE_DATA);

    		Cell cell1 = row.addCell();
        	cell1.addText("pairdisplay"+i).setValue(valueList.get(i).display); 
        	maybeError(cell1, "pairdisplay"+i);

        	Cell cell2 = row.addCell();
        	cell2.addText("pairstorage"+i).setValue(valueList.get(i).storage);
        	maybeError(cell2, "pairstorage"+i);

        	Cell upcell = row.addCell();
        	if (i > 0)
        	{
        		upcell.addButton("pairup"+i, "link").setValue(T_move_up);
        	}
        	
        	Cell downcell = row.addCell();
        	if (i < numpairs-1)
        	{
        		downcell.addButton("pairdown"+i, "link").setValue(T_move_down);
        	}

        	row.addCell().addButton("pairremove"+i, "link").setValue(T_delete);
        }
        formdiv.addPara().addButton("pairadd").setValue(T_add);

	}
    
}
