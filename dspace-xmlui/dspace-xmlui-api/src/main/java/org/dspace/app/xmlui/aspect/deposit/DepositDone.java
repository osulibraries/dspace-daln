package org.dspace.app.xmlui.aspect.deposit;

import java.sql.SQLException;

import org.apache.cocoon.environment.ObjectModelHelper;
import org.apache.cocoon.environment.Request;
import org.dspace.app.xmlui.cocoon.AbstractDSpaceTransformer;
import org.dspace.app.xmlui.utils.ContextUtil;
import org.dspace.app.xmlui.wing.Message;
import org.dspace.app.xmlui.wing.WingException;
import org.dspace.app.xmlui.wing.element.Body;
import org.dspace.app.xmlui.wing.element.Division;
import org.dspace.app.xmlui.wing.element.PageMeta;
import org.dspace.app.xmlui.wing.element.Para;
import org.dspace.core.Context;

public class DepositDone extends AbstractDSpaceTransformer {

    private static final Message T_dspace_home = message("xmlui.general.dspace_home");
    private static final Message T_title = message("xmlui.Deposit.DepositDone.title");
    private static final Message T_head = message("xmlui.Deposit.DepositDone.head");
    private static final Message T_deposited = message("xmlui.Deposit.DepositDone.deposited");
    private static final Message T_done = message("xmlui.Deposit.DepositDone.done");
    private static final Message T_more = message("xmlui.Deposit.DepositDone.more");

	public void addPageMeta(PageMeta pageMeta) throws WingException {
		pageMeta.addMetadata("title").addContent(T_title);
		
		pageMeta.addTrailLink(contextPath + "/",T_dspace_home);
		pageMeta.addTrail().addContent(T_title);
	}
	
	public void addBody(Body body) throws WingException, SQLException {

		Context context = ContextUtil.obtainContext(objectModel);
		Request request = ObjectModelHelper.getRequest(objectModel);

        DepositLogic logic = (DepositLogic)request.getAttribute("logic");
        
        String submitURL = contextPath + "deposit";
        
        Division div = body.addDivision("deposit-done", "primary");
        div.setHead(T_head);
        
        Division formdiv = div.addInteractiveDivision("deposit-done-form", submitURL, Division.METHOD_POST);
        formdiv.addHidden("continue").setValue(knot.getId());
        
        formdiv.addPara().addContent(T_deposited.parameterize(logic.getNumSubmissions()));
        
        Para buttons = formdiv.addPara();
        buttons.addButton("submit-done").setValue(T_done);
        buttons.addButton("submit-continue").setValue(T_more);
	}
}
