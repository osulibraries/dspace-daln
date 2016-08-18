package org.dspace.app.xmlui.aspect.lists;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.Map;

import org.apache.cocoon.environment.ObjectModelHelper;
import org.apache.cocoon.environment.Request;
import org.dspace.app.xmlui.aspect.artifactbrowser.BrowseUtils;
import org.dspace.app.xmlui.cocoon.AbstractDSpaceTransformer;
import org.dspace.app.xmlui.wing.Message;
import org.dspace.app.xmlui.wing.WingException;
import org.dspace.app.xmlui.wing.element.Body;
import org.dspace.app.xmlui.wing.element.Division;
import org.dspace.app.xmlui.wing.element.Para;

public class BrowseSidebar extends AbstractDSpaceTransformer {

	private static final Message T_head = message("xmlui.Lists.BrowseSidebar.head");
	
	@Override
	public void addBody(Body body) throws WingException, SQLException
	{
		Division sidebar = body.addDivision("sidebar","sidebar");
		
		Request request = ObjectModelHelper.getRequest(objectModel);
		Map<String,String> params = new HashMap<String,String>(request.getParameters());
		
		String type = params.get("type");
		Integer list_id = BrowseUtils.getIntParameter(params, "list_id", -1);
		
		if ("list".equals(type) && list_id != -1)
		{			
			String comment = ListUtils.getListComment(context, list_id);
			
			if (comment != null && !comment.isEmpty())
			{
				Division browsediv = sidebar.addDivision("list-description","tag");
				Division div = browsediv.addDivision("inner");

				div.setHead(T_head);

				Para para = div.addPara();
				para.addContent(comment);
			}
		}
	}

}
