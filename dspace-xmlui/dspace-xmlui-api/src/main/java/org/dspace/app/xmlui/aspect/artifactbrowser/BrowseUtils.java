package org.dspace.app.xmlui.aspect.artifactbrowser;

import static org.dspace.app.xmlui.cocoon.AbstractDSpaceTransformer.generateURL;

import java.io.IOException;
import java.sql.SQLException;
import java.util.HashMap;
import java.util.Map;

import org.apache.cocoon.environment.ObjectModelHelper;
import org.apache.cocoon.environment.Request;
import org.dspace.app.xmlui.aspect.tagging.TagUtils;
import org.dspace.app.xmlui.utils.ContextUtil;
import org.dspace.app.xmlui.utils.HandleUtil;
import org.dspace.app.xmlui.utils.UIException;
import org.dspace.app.xmlui.wing.WingException;
import org.dspace.app.xmlui.wing.element.Division;
import org.dspace.app.xmlui.wing.element.PageMeta;
import org.dspace.browse.BrowseEngine;
import org.dspace.browse.BrowseException;
import org.dspace.browse.BrowseInfo;
import org.dspace.browse.BrowseItem;
import org.dspace.content.DSpaceObject;
import org.dspace.core.Context;
import org.dspace.handle.HandleManager;
import org.dspace.search.QueryArgs;
import org.dspace.search.QueryResults;

public class BrowseUtils {

    public static void generatePageMeta(PageMeta pageMeta, Map objectModel, String mode) throws SQLException, WingException {
    	generatePageMeta(pageMeta, objectModel, mode, null);
    }

    public static void generatePageMeta(PageMeta pageMeta, Map objectModel, String mode, String query) throws SQLException, WingException {

    	Request request = ObjectModelHelper.getRequest(objectModel);
		DSpaceObject dso = HandleUtil.obtainHandle(objectModel);
        String handle = dso != null? dso.getHandle() : "";
		
        pageMeta.addMetadata("mode").addContent(mode);

        Map<String,String> params = new HashMap<String,String>(request.getParameters());
        params.put("focusscope",handle);
        
        if (query != null)
        {
        	params.put("query", query);
        }

        pageMeta.addMetadata("parameters").addContent(generateURL("",params).substring(1));
    }
    
    public static void insertSearchLinks(Map objectModel, Division div) throws SQLException, WingException, IOException {
    	Request request = ObjectModelHelper.getRequest(objectModel);
        Map<String,String> reqparams = (Map<String,String>)request.getParameters();
        String mode      = reqparams.get("mode");
        
        if ("search".equals(mode) || "advanced-search".equals(mode) || "fancy-search".equals(mode)) 
        {
            Context context = ContextUtil.obtainContext(objectModel);
            DSpaceObject item = HandleUtil.obtainHandle(objectModel);
            String handle = reqparams.get("focusscope");            
            DSpaceObject dso = HandleManager.resolveToObject(context, handle);
            QueryResults results = generatePagingSearchResults(context, reqparams, handle);
            generatePagingSearchLinks(div, results, reqparams, item.getID(), handle);
        }
    }
    
    public static void insertBrowseLinks(Map objectModel, Division div) throws SQLException, WingException {
    	Request request = ObjectModelHelper.getRequest(objectModel);
    	Map<String,String> reqparams = (Map<String,String>)request.getParameters();
        String mode   = reqparams.get("mode");

        if ("browse".equals(mode)) {
            Context context = ContextUtil.obtainContext(objectModel);
            DSpaceObject item = HandleUtil.obtainHandle(objectModel);
            String handle = reqparams.get("focusscope");
            DSpaceObject dso = HandleManager.resolveToObject(context, handle);
            BrowseInfo browseInfo = generatePagingBrowseInfo(context, reqparams, dso, item.getID());
            generatePagingBrowseLinks(div, browseInfo, reqparams, handle, item.getID());

        }
    }

    public static void insertSecondLevelBrowseLinks(Map objectModel, BrowseInfo info, Division div) throws SQLException, WingException {
    	Request request = ObjectModelHelper.getRequest(objectModel);
    	Map<String,String> reqparams = decodeSecondLevelParameters(request.getParameters());

        if (info.isSecondLevel()) {
            Context context = ContextUtil.obtainContext(objectModel);
            DSpaceObject dso = HandleUtil.obtainHandle(objectModel);
            String handle = (dso == null)? "" : dso.getHandle();
            String value = request.getParameter("value");
            BrowseInfo browseInfo = generatePagingBrowseInfo(context, reqparams, dso, value);
            generatePagingBrowseLinks(div, browseInfo, reqparams, handle, value);

        }
    }

    public static Integer getIntParameter(Map<String,String> reqparams, String key) {
    	return getIntParameter(reqparams, key, -1);
    }

    public static Integer getIntParameter(Map<String,String> reqparams, String key, int def) {
        try {
            return Integer.parseInt(reqparams.get(key).trim());
        }
        catch (Exception e)
        {
            return def;
        }        
    }
    
    private static QueryResults generatePagingSearchResults(Context context, Map<String,String> reqparams, String handle) 
            throws SQLException, IOException, UIException {

        QueryArgs queryArgs = new QueryArgs();    	
        String query = reqparams.get("query");
        DSpaceObject scope = HandleManager.resolveToObject(context, handle);        
        int page = getIntParameter(reqparams, "page", 1);        
        int pageSize = getIntParameter(reqparams, "rpp", 10);        
        int start = ((page - 1) * pageSize) - 1; // adjust to incorporate before & after
        int sortBy = getIntParameter(reqparams, "sort_by", 0);
        String order = reqparams.get("order");
        if (order == null)
        {
        	order = "DESC";
        }

        return AbstractSearch.reallyPerformSearch(
        		context, queryArgs, query, scope, page, pageSize+2, start, sortBy, order);
    }
    
    private static void generatePagingSearchLinks(Division div, QueryResults qResults, Map<String,String> reqparams, int itemID, String handle) {

        int page = getIntParameter(reqparams, "page", 1);        
        int pagesize = getIntParameter(reqparams, "rpp", 10);
        
        // find total number of results
        int count = qResults.getHitCount();
        
        // find our location in the results
        int rawIndex = qResults.getHitIds().indexOf(itemID);
        // NB returned index for first page doesn't need to be adjusted, but all others do
        int localindex = (page > 1)? rawIndex-1 : rawIndex;
        int index = ((page-1)*pagesize)+localindex;

        // find prev and next links // may need to adjust page numbers
        String prevlink = null;
        if (index != 0) {
            int previndex = index-1;
            int prevpage  = (previndex / pagesize)+1;
            String prevhandle = (String)qResults.getHitHandles().get(rawIndex-1);
            Map<String,String> params = new HashMap<String,String>(reqparams);
            params.put("page", String.valueOf(prevpage));
            prevlink = "/handle/" + generateURL(prevhandle, params);
        }

        String nextlink = null;
        if (index != count-1) {
            int nextindex = index+1;
            int nextpage  = (nextindex / pagesize)+1;
            String nexthandle = (String)qResults.getHitHandles().get(rawIndex+1);
            Map<String,String> params = new HashMap<String,String>(reqparams);
            params.put("page", String.valueOf(nextpage));
            nextlink = "/handle/" + generateURL(nexthandle, params);
        }
        
        // create back link  (can only go to a page #)
        String backlink = "/" + reqparams.get("mode");
        if (!handle.isEmpty()) {
            backlink = "/handle/" + handle + backlink;
        }
        Map<String,String> params = new HashMap<String,String>(reqparams);
        params.remove("focusscope");
        params.remove("mode");
        String backurl = generateURL(backlink, params);
        
        // not accounting for difference in collections and items
        div.setSinglePagination(count, index + 1, prevlink, nextlink, "Search", backurl);
        
    }

    private static BrowseInfo generatePagingBrowseInfo(Context context, Map<String,String> reqparams, DSpaceObject dso, int itemID) 
    		throws UIException, SQLException {
        try 
        {        	
        	BrowseEngine browseEngine = new BrowseEngine(context);

        	BrowseParams browseParams = ConfigurableBrowse.createUserParams(context, reqparams, dso);

        	BrowseInfo info = browseEngine.browse(browseParams.scope);

        	int index = getItemIndex(info, itemID);
        	int offset = info.getOffset() + index;

        	// redo the query, with offset off-by one to get prev, current, and next items
        	browseParams.scope.setOffset(Math.max(offset-1,0));
        	browseParams.scope.setJumpToItem(-1);
        	browseParams.scope.setJumpToValue(null);
        	browseParams.scope.setStartsWith(null);
        	browseParams.scope.setResultsPerPage(3);
        	
        	info = browseEngine.browse(browseParams.scope);

        	return info;
        }
        catch (BrowseException bex)
        {
            throw new UIException("Unable to process browse paging", bex);
        }
    }
    
    private static void generatePagingBrowseLinks(Division div, BrowseInfo info, Map<String,String> reqparams, String handle, int itemID) 
    	throws UIException {

    	int total = info.getTotal();
    	int offset = info.getOffset();
    	
    	int count = info.getResultCount();
    	int index = getItemIndex(info, itemID);
    	int newoffset = offset+index;

    	String backlink = "/browse";
    	if (!handle.isEmpty()) {
    		backlink = "/handle/" + handle + backlink;
    	}
    	
        Map<String,String> baseparams = new HashMap<String,String>(reqparams);
        baseparams.remove("focus");
        baseparams.remove("vfocus");
        baseparams.remove("starts_with");

    	String prevlink = null;
    	if (index != 0) 
    	{
    		String itemHandle = getItemHandleAt(info,index-1);
            Map<String,String> params = new HashMap<String,String>(baseparams);
            params.put("offset", String.valueOf(newoffset-1));
    		prevlink = "/handle/" + generateURL(itemHandle, params);
    	}

    	String nextlink = null;
    	if (index != count-1)
    	{
    		String itemHandle = getItemHandleAt(info,index+1);
            Map<String,String> params = new HashMap<String,String>(baseparams);
            params.put("offset", String.valueOf(newoffset+1));
    		nextlink = "/handle/" + generateURL(itemHandle, params);
    	}

    	Map<String,String> params = new HashMap<String,String>(baseparams);
    	params.put("offset", String.valueOf(newoffset));
    	params.remove("focusscope");
    	params.remove("mode");
    	String backurl = generateURL(backlink, params);

    	div.setSinglePagination(total, newoffset + 1, prevlink, nextlink, "Browse", backurl);
    }

    private static BrowseInfo generatePagingBrowseInfo(Context context, Map<String,String> reqparams, DSpaceObject dso, String value) 
    throws UIException, SQLException {
    	try 
    	{

    		BrowseEngine browseEngine = new BrowseEngine(context);

    		BrowseParams browseParams = ConfigurableBrowse.createUserParams(context, reqparams, dso);
    		browseParams.scope.setJumpToValue(value);

    		BrowseInfo info = browseEngine.browse(browseParams.scope);

    		int index = getValueIndex(info, value);
    		int offset = info.getOffset() + index;

    		// redo the query, with offset off-by one to get prev, current, and next items
    		browseParams.scope.setOffset(Math.max(offset-1,0));
    		browseParams.scope.setJumpToItem(-1);
    		browseParams.scope.setJumpToValue(null);
    		browseParams.scope.setStartsWith(null);
    		browseParams.scope.setResultsPerPage(3);

    		info = browseEngine.browse(browseParams.scope);

    		return info;
    	}
    	catch (BrowseException bex)
    	{
    		throw new UIException("Unable to process browse paging", bex);
    	}
    }

    private static void generatePagingBrowseLinks(Division div, BrowseInfo info, Map<String,String> reqparams, String handle, String value) 
    		throws UIException {
    	int total = info.getTotal();
    	int offset = info.getOffset();

    	int count = info.getResultCount();
    	int index = getValueIndex(info, value);
    	int newoffset = offset+index;

        Map<String,String> baseparams = new HashMap<String,String>(reqparams);
        baseparams.remove("focus");
        baseparams.remove("vfocus");
        baseparams.remove("starts_with");

    	String backlink = "/browse";
    	if (!handle.isEmpty()) {
    		backlink = "/handle/" + handle + backlink;
    	}

    	String prevlink = null;
    	if (index != 0) 
    	{
    		String val = getValueAt(info, index-1);
    		Map<String,String> params = encodeSecondLevelParameters(baseparams);
    		params.put("value", val);
    		prevlink = generateURL(backlink, params);
    	}

    	String nextlink = null;
    	if (index != count-1)
    	{
    		String val = getValueAt(info, index+1);
    		Map<String,String> params = encodeSecondLevelParameters(baseparams);
    		params.put("value", val);
    		nextlink = generateURL(backlink,params);
    	}

    	Map<String,String> params = new HashMap<String,String>(baseparams);
    	params.put("offset", String.valueOf(newoffset));
    	params.remove("focusscope");
    	params.remove("mode");
    	String backurl = generateURL(backlink, params);

    	div.setSinglePagination(total, newoffset + 1, prevlink, nextlink, "Browse", backurl);
    }

    public static Map<String,String> encodeSecondLevelParameters(Map reqparams) {
        Map<String, String> resultParams = new HashMap<String, String>();
        for (Map.Entry<String,String> entry : ((Map<String, String>)reqparams).entrySet()) {
        	resultParams.put("z"+entry.getKey(), entry.getValue());        	
        }
        resultParams.put("type", (String)reqparams.get("type"));
        if (reqparams.containsKey("eperson"))
        {
        	resultParams.put("eperson", (String)reqparams.get("eperson"));
        }
        return resultParams;
    }

    public static Map<String,String> decodeSecondLevelParameters(Map reqparams) {
        Map<String, String> resultParams = new HashMap<String, String>();
        for (Map.Entry<String,String> entry : ((Map<String, String>)reqparams).entrySet()) {
        	String key = entry.getKey();
        	if (key.charAt(0) == 'z') {
        		resultParams.put(key.substring(1), entry.getValue());
        	}
        }
        resultParams.put("type", (String)reqparams.get("type"));
        if (reqparams.containsKey("eperson"))
        {
        	resultParams.put("eperson", (String)reqparams.get("eperson"));
        }
        return resultParams;
    }

    public static Map<String,String> getSecondLevelParameters(Map objectModel) {
    	Request request = ObjectModelHelper.getRequest(objectModel);
    	Map<String,String> reqparams = (Map<String,String>)request.getParameters(); 
        Map<String, String> resultParams = new HashMap<String, String>();
        for (Map.Entry<String,String> entry : ((Map<String, String>)reqparams).entrySet()) {
        	String key = entry.getKey();
        	if (key.charAt(0) == 'z') {
        		resultParams.put(key, entry.getValue());
        	}
        }
        return resultParams;
    }

	// find item in results as they stand
	// NB this could cause issues if the item appears more than once in the same page
	//    in particular, it will always go to the first appearance of the item.
    private static int getItemIndex(BrowseInfo info, int itemID) {
    	BrowseItem[] results = info.getBrowseItemResults();
    	int count = results.length;
    	int index = -1;
    	for (int i = 0; i < count; i++) 
    	{
    		if (results[i].getID() == itemID)
    		{
    			index = i;
    			break;
    		}
    	}
    	return index;
    }

    private static int getValueIndex(BrowseInfo info, String value) {
    	String[][] results = info.getStringResults();
    	int count = results.length;
    	int index = -1;
    	for (int i = 0; i < count; i++) 
    	{
    		if (results[i][0].equals(value))
    		{
    			index = i;
    			break;
    		}
    	}
    	return index;
    }

    private static String getItemHandleAt(BrowseInfo info, int index) {
    	BrowseItem[] results = info.getBrowseItemResults();
    	BrowseItem item = results[index];
    	return item.getHandle();
    }

    private static String getValueAt(BrowseInfo info, int index) {
    	String[][] results = info.getStringResults();
    	String[] value = results[index];
    	return value[0];
    }

}
