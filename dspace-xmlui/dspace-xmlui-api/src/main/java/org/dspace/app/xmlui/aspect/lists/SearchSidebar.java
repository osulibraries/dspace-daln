package org.dspace.app.xmlui.aspect.lists;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.Map;

import org.apache.cocoon.environment.ObjectModelHelper;
import org.apache.cocoon.environment.Request;
import org.dspace.app.xmlui.cocoon.AbstractDSpaceTransformer;
import org.dspace.app.xmlui.utils.HandleUtil;
import org.dspace.app.xmlui.wing.Message;
import org.dspace.app.xmlui.wing.WingException;
import org.dspace.app.xmlui.wing.element.Body;
import org.dspace.app.xmlui.wing.element.Division;
import org.dspace.app.xmlui.wing.element.Para;
import org.dspace.app.xmlui.wing.element.Select;
import org.dspace.content.DSpaceObject;

public class SearchSidebar extends AbstractDSpaceTransformer {

	private static final Message T_head = message("xmlui.Lists.SearchSidebar.head");
	private static final Message T_add = message("xmlui.Lists.SearchSidebar.add");
	private static final Message T_create = message("xmlui.Lists.SearchSidebar.create");
	private static final Message T_button = message("xmlui.Lists.SearchSidebar.button");

	@Override
	public void addBody(Body body) throws WingException, SQLException
	{
		Division sidebar = body.addDivision("sidebar","sidebar");
		
		Request request = ObjectModelHelper.getRequest(objectModel);
		String uri = request.getRequestURI();
		Map<String,String> params = new HashMap<String,String>(request.getParameters());
		
		DSpaceObject scope = HandleUtil.obtainHandle(objectModel);
		String handle = (scope==null)? "" : scope.getHandle();
		
		String searchType = uri.substring(uri.lastIndexOf('/')+1); // XXX brittle

		if (eperson != null)
		{
			Division div = sidebar.addDivision("build-list","tag");

			String searchURL = contextPath + "/lists/build/action";

			Division listsdiv = div.addDivision("lists");
			listsdiv.setHead(T_head);
			
			Message status = (Message)request.getSession().getAttribute(ListUtils.STATUS_ATTR);
			if (status != null)
			{
				listsdiv.addPara().addHighlight("error").addContent(status);
				request.getSession().setAttribute(ListUtils.STATUS_ATTR, null);
			}
			
			Division builddiv = listsdiv.addInteractiveDivision("build-list-form", searchURL, Division.METHOD_POST);
			
			for (Map.Entry<String, String> entry : params.entrySet())
			{
				builddiv.addHidden(entry.getKey()).setValue(entry.getValue());
			}
			
			builddiv.addHidden("search_scope").setValue(handle);
			builddiv.addHidden("search_type").setValue(searchType);
			builddiv.addHidden("effective_query").setValue((String)request.getAttribute("effectiveQuery"));
						
			Para para = builddiv.addPara();
			para.addContent(T_add);
			Select lists = para.addSelect("list_id");
			lists.addOption("","(Select a list)"); // XXX i18n
			for (Map.Entry<Integer, String> entry : ListUtils.getLists(context, eperson).entrySet())
			{
				lists.addOption(entry.getKey(), entry.getValue());			
			}
			
			Para para2 = builddiv.addPara();
			para2.addContent(T_create);
			para2.addText("list_name");
			
			builddiv.addPara().addButton("list_build").setValue(T_button);		
		}
	}

}
