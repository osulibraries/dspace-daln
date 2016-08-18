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
import org.dspace.app.xmlui.wing.element.Para;
import org.dspace.content.DSpaceObject;

public class Confirm extends AbstractDSpaceTransformer {

    private static final Message T_dspace_home = message("xmlui.general.dspace_home");  
    private static final Message T_title = message("xmlui.Forms.Confirm.title");
    private static final Message T_head = message("xmlui.Forms.Confirm.head");
    private static final Message T_confirm = message("xmlui.Forms.Confirm.confirm");
    private static final Message T_cancel = message("xmlui.Forms.Confirm.cancel");

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
        Object message = request.getAttribute("message");
        
        Division div = body.addDivision("form-confirm", "primary");
        div.setHead(T_head);

        String submitURL = contextPath + "/forms/confirm";
        
        Division formdiv = div.addInteractiveDivision("form-confirm-form", submitURL, Division.METHOD_POST, null);

        formdiv.addHidden("continue").setValue(knot.getId());

        Para para = formdiv.addPara();

        if (message instanceof Message) { // XXX temporary, eventually always message
        	para.addContent((Message)message);
        }
        else
        {
        	para.addContent((String)message);
        }
        
        Para buttons = formdiv.addPara();
        
        buttons.addButton("confirm").setValue(T_confirm);
        buttons.addButton("cancel").setValue(T_cancel);
	}

}
