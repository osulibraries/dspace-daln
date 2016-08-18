package org.dspace.app.xmlui.aspect.forms;

import java.sql.SQLException;

import org.apache.cocoon.environment.ObjectModelHelper;
import org.apache.cocoon.environment.Request;
import org.dspace.app.xmlui.cocoon.AbstractDSpaceTransformer;
import org.dspace.app.xmlui.utils.HandleUtil;
import org.dspace.app.xmlui.wing.Message;
import org.dspace.app.xmlui.wing.WingException;
import org.dspace.app.xmlui.wing.element.Body;
import org.dspace.app.xmlui.wing.element.Division;
import org.dspace.app.xmlui.wing.element.PageMeta;
import org.dspace.content.DSpaceObject;

public class OtherForms extends AbstractDSpaceTransformer {

    private static final Message T_dspace_home = message("xmlui.general.dspace_home");
    private static final Message T_title = message("xmlui.Forms.OtherForms.title");
    private static final Message T_head = message("xmlui.Forms.OtherForms.head");
    private static final Message T_edit_input_forms = message("xmlui.Forms.OtherForms.edit_input_forms");
    private static final Message T_edit_value_lists = message("xmlui.Forms.OtherForms.edit_value_lists");
	
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

        Division div = body.addDivision("other-forms-form", null);
        div.setHead(T_head);

        div.addPara().addXref(contextPath + "/forms/input-forms", T_edit_input_forms);
        div.addPara().addXref(contextPath + "/forms/value-lists", T_edit_value_lists);        
	}

}
