package org.dspace.app.xmlui.aspect.lists;

import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpServletResponse;

import org.apache.avalon.framework.parameters.Parameters;
import org.apache.cocoon.acting.AbstractAction;
import org.apache.cocoon.environment.ObjectModelHelper;
import org.apache.cocoon.environment.Redirector;
import org.apache.cocoon.environment.Request;
import org.apache.cocoon.environment.SourceResolver;
import org.apache.cocoon.environment.http.HttpEnvironment;
import org.dspace.app.xmlui.aspect.artifactbrowser.BrowseUtils;
import org.dspace.app.xmlui.cocoon.AbstractDSpaceTransformer;
import org.dspace.app.xmlui.utils.ContextUtil;
import org.dspace.app.xmlui.wing.AbstractWingTransformer;
import org.dspace.app.xmlui.wing.Message;
import org.dspace.content.Item;
import org.dspace.core.Context;
import org.dspace.eperson.EPerson;

public class ItemSidebarAction extends AbstractAction {

	private static final Message T_status = AbstractWingTransformer.message("xmlui.Lists.ItemSidebarAction.status");	

	public Map act(Redirector redirector, SourceResolver resolver,
			Map objectModel, String source, Parameters parameters)
			throws Exception 
	{
		Context context = ContextUtil.obtainContext(objectModel);

		HttpServletResponse response = (HttpServletResponse)objectModel.get(HttpEnvironment.HTTP_RESPONSE_OBJECT);
		
		Request request = ObjectModelHelper.getRequest(objectModel);
		Map<String,String> params = new HashMap<String,String>(request.getParameters());

		EPerson eperson = context.getCurrentUser();

		Integer item_id = BrowseUtils.getIntParameter(params, "item_id");
		Item item = Item.find(context, item_id);

		Integer list_id = BrowseUtils.getIntParameter(params, "list_id");

		String contextPath = request.getContextPath();
        if (contextPath == null)
        	contextPath = "";
        String itemPath = "/handle/" + item.getHandle(); // XXX this could fail

		if (list_id != null && item != null && eperson != null)
		{
	    	String list_name = ListUtils.checkList(context, eperson, list_id); // check access

	    	// XXX some sort of diagnostic???
	    	
	    	if (list_name != null)
	    	{
	    		ListUtils.addItem(context, list_id, item.getID());
	    		request.getSession().setAttribute(ListUtils.STATUS_ATTR, T_status.parameterize(list_name));
	    	}
		}

		params.remove("list_id");
		params.remove("item_id");
		params.remove("add");

		String url = AbstractDSpaceTransformer.generateURL(contextPath + itemPath, params);
		response.sendRedirect(url);
		
		return new HashMap();
	}

}
