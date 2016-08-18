package org.dspace.app.xmlui.aspect.lists;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletResponse;

import org.apache.avalon.framework.parameters.Parameters;
import org.apache.cocoon.acting.AbstractAction;
import org.apache.cocoon.environment.ObjectModelHelper;
import org.apache.cocoon.environment.Redirector;
import org.apache.cocoon.environment.Request;
import org.apache.cocoon.environment.SourceResolver;
import org.apache.cocoon.environment.http.HttpEnvironment;
import org.dspace.app.xmlui.aspect.artifactbrowser.AbstractSearch;
import org.dspace.app.xmlui.aspect.artifactbrowser.BrowseUtils;
import org.dspace.app.xmlui.cocoon.AbstractDSpaceTransformer;
import org.dspace.app.xmlui.utils.ContextUtil;
import org.dspace.app.xmlui.wing.AbstractWingTransformer;
import org.dspace.app.xmlui.wing.Message;
import org.dspace.content.DSpaceObject;
import org.dspace.core.Constants;
import org.dspace.core.Context;
import org.dspace.eperson.EPerson;
import org.dspace.handle.HandleManager;
import org.dspace.search.QueryArgs;
import org.dspace.search.QueryResults;

public class SearchSidebarAction extends AbstractAction {

	private static final Message T_status = AbstractWingTransformer.message("xmlui.Lists.SearchSidebarAction.status");	
	
	public Map act(Redirector redirector, SourceResolver resolver,
			Map objectModel, String source, Parameters parameters)
			throws Exception 
	{
		Context context = ContextUtil.obtainContext(objectModel);

		HttpServletResponse response = (HttpServletResponse)objectModel.get(HttpEnvironment.HTTP_RESPONSE_OBJECT);
		
		Request request = ObjectModelHelper.getRequest(objectModel);
		Map<String,String> params = new HashMap<String,String>(request.getParameters());

		EPerson eperson = context.getCurrentUser();

        String contextPath = request.getContextPath();
        if (contextPath == null)
        	contextPath = "";
        
        String handle = params.get("search_scope");
		DSpaceObject scope = HandleManager.resolveToObject(context, handle);
        
		String scopeurl = (scope==null)? "/" : "/handle/"+scope+"/";
		String searchurl = params.get("search_type");
		
        Integer list_id = BrowseUtils.getIntParameter(params, "list_id", -1);
        String list_name = params.get("list_name"); // explicit name should override dropdown
        
        if (eperson != null)
        {
        	// NB not checking for uniqueness.  If you create a duplicate name, that's your problem
        	if (list_name != null)
        	{
        		list_id = ListUtils.createList(context, eperson, list_name);
        	}
        	else if (list_id != -1)
        	{
        		list_name = ListUtils.checkList(context, eperson, list_id);
        	}

        	if (list_id != -1 && list_name != null)
        	{
        		QueryArgs queryArgs = new QueryArgs();    	
        		String query = params.get("effective_query");
        		int page = BrowseUtils.getIntParameter(params, "page", 1);        
        		int pageSize = BrowseUtils.getIntParameter(params, "rpp", 10);        
        		int start = (page - 1) * pageSize;
        		int sortBy = BrowseUtils.getIntParameter(params, "sort_by", 0);
        		String order = params.get("order");
        		if (order == null)
        		{
        			order = "DESC";
        		}

        		QueryResults results = AbstractSearch.reallyPerformSearch(
        				context, queryArgs, query, scope, page, pageSize, start, sortBy, order);

        		int numHits = results.getHitIds().size();
        		List<Integer> item_ids = new ArrayList<Integer>();
        		for (int i = 0; i < numHits; i++)
        		{
        			if ((Integer)results.getHitTypes().get(i) == Constants.ITEM)
        			{
        				item_ids.add((Integer)results.getHitIds().get(i));
        			}
        		}

        		ListUtils.addItems(context, list_id, item_ids);

        		request.getSession().setAttribute(ListUtils.STATUS_ATTR, T_status.parameterize(numHits, list_name));

        	}
        }

        params.remove("search_scope");
        params.remove("search_type");
        params.remove("list_id");
        params.remove("list_name");
        params.remove("list_build");
        params.remove("effective_query");
        
        String url = AbstractDSpaceTransformer.generateURL(contextPath + scopeurl + searchurl, params);
        response.sendRedirect(url);			
		
		return new HashMap();
	}

}
