package org.dspace.app.xmlui.aspect.forms;

import java.sql.SQLException;

import org.apache.cocoon.environment.ObjectModelHelper;
import org.apache.cocoon.environment.Request;
import org.dspace.app.xmlui.utils.HandleUtil;
import org.dspace.app.xmlui.wing.Message;
import org.dspace.app.xmlui.wing.WingException;
import org.dspace.app.xmlui.wing.element.Body;
import org.dspace.app.xmlui.wing.element.Division;
import org.dspace.app.xmlui.wing.element.Item;
import org.dspace.app.xmlui.wing.element.List;
import org.dspace.app.xmlui.wing.element.PageMeta;
import org.dspace.app.xmlui.wing.element.Select;
import org.dspace.content.Collection;
import org.dspace.content.DSpaceObject;

public class CollectionForms extends BaseForm {

    private static final Message T_dspace_home = message("xmlui.general.dspace_home");
    private static final Message T_title = message("xmlui.Forms.CollectionForms.title");
    private static final Message T_head = message("xmlui.Forms.CollectionForms.head");
    private static final Message T_input_form = message("xmlui.Forms.CollectionForms.input_form");
    private static final Message T_use = message("xmlui.Forms.CollectionForms.use");
    private static final Message T_revert = message("xmlui.Forms.CollectionForms.revert");
    private static final Message T_edit = message("xmlui.Forms.CollectionForms.edit");
	
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

        DSpaceObject dso = HandleUtil.obtainHandle(objectModel);
        Collection collection = (Collection)dso; // XXX check
        
        CollectionFormsAction action = (CollectionFormsAction)request.getAttribute("action");

        String submitURL = contextPath + "/handle/"+collection.getHandle()+"/forms/collection-forms";

        Division div = body.addInteractiveDivision("choose-forms-form", submitURL, Division.METHOD_POST, null);
        div.setHead(T_head);

        div.addHidden("continue").setValue(knot.getId());

        List list = div.addList("choose-forms-list");
        
        list.addLabel(T_input_form);
        Item inputitem = list.addItem();
                
        Select baseinput = inputitem.addSelect("baseinput");
        String inputFormName = action.getInputFormsAction().getInputFormName(dso.getHandle());
        for (String form : action.getInputFormsAction().getInputFormNames())
        {
        	baseinput.addOption(form.equals(inputFormName), form, form);
        }
        inputitem.addButton("useinput").setValue(T_use);
        inputitem.addButton("revertinput").setValue(T_revert);

        String inputURL = contextPath + "/forms/input-forms" + "?continue=" + knot.getId();
        inputitem.addXref(inputURL).addContent(T_edit);
	}
    
}
