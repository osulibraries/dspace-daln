/*
 * SimpleSearch.java
 *
 * Version: $Revision: 3705 $
 *
 * Date: $Date: 2009-04-11 13:02:24 -0400 (Sat, 11 Apr 2009) $
 *
 * Copyright (c) 2002, Hewlett-Packard Company and Massachusetts
 * Institute of Technology.  All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions are
 * met:
 *
 * - Redistributions of source code must retain the above copyright
 * notice, this list of conditions and the following disclaimer.
 *
 * - Redistributions in binary form must reproduce the above copyright
 * notice, this list of conditions and the following disclaimer in the
 * documentation and/or other materials provided with the distribution.
 *
 * - Neither the name of the Hewlett-Packard Company nor the name of the
 * Massachusetts Institute of Technology nor the names of their
 * contributors may be used to endorse or promote products derived from
 * this software without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
 * ``AS IS'' AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
 * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
 * A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
 * HOLDERS OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT,
 * INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING,
 * BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS
 * OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
 * ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR
 * TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE
 * USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH
 * DAMAGE.
 */
package org.dspace.app.xmlui.aspect.artifactbrowser;

import java.io.IOException;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.cocoon.environment.ObjectModelHelper;
import org.apache.cocoon.environment.Request;
import org.dspace.app.xmlui.cocoon.AbstractDSpaceTransformer;
import org.dspace.app.xmlui.utils.ContextUtil;
import org.dspace.app.xmlui.utils.HandleUtil;
import org.dspace.app.xmlui.utils.UIException;
import org.dspace.app.xmlui.wing.Message;
import org.dspace.app.xmlui.wing.WingException;
import org.dspace.app.xmlui.wing.element.Body;
import org.dspace.app.xmlui.wing.element.Cell;
import org.dspace.app.xmlui.wing.element.Division;
import org.dspace.app.xmlui.wing.element.PageMeta;
import org.dspace.app.xmlui.wing.element.Row;
import org.dspace.app.xmlui.wing.element.Select;
import org.dspace.app.xmlui.wing.element.Table;
import org.dspace.app.xmlui.wing.element.Text;
import org.dspace.authorize.AuthorizeException;
import org.dspace.content.Collection;
import org.dspace.content.Community;
import org.dspace.content.DSpaceObject;
import org.dspace.core.ConfigurationManager;
import org.dspace.core.Context;
import org.dspace.search.QueryArgs;
import org.dspace.search.QueryFacet;
import org.dspace.search.QueryResults;
import org.xml.sax.SAXException;

import edu.emory.mathcs.backport.java.util.Collections;

/**
 * Preform a simple search of the repository. The user provides a simple one
 * field query (the url parameter is named query) and the results are processed.
 * 
 * @author Scott Phillips
 */
public class ShowFacet extends AbstractDSpaceTransformer
{
    /** Language Strings */
    private static final Message T_title =
        message("xmlui.ArtifactBrowser.ShowFacet.title");
    
    private static final Message T_dspace_home =
        message("xmlui.general.dspace_home");
    
    private static final Message T_trail =
        message("xmlui.ArtifactBrowser.ShowFacet.trail");
    
    private static final Message T_head = 
        message("xmlui.ArtifactBrowser.ShowFacet.head");
    
    private static final Message T_result_query = 
        message("xmlui.ArtifactBrowser.AbstractSearch.result_query");

    private static int numColumns = 3;
    {
    	numColumns = ConfigurationManager.getIntProperty("facet.columns",3);
    }
    
    /**
     * Add Page metadata.
     * @throws IOException 
     */
    public void addPageMeta(PageMeta pageMeta) throws WingException, SQLException, IOException
    {
        pageMeta.addMetadata("title").addContent(T_title);
        
        pageMeta.addTrailLink(contextPath + "/", T_dspace_home);
		
		DSpaceObject dso = HandleUtil.obtainHandle(objectModel);
        if ((dso instanceof Collection) || (dso instanceof Community))
        {
	        HandleUtil.buildHandleTrail(dso,pageMeta,contextPath);
		} 
		
        pageMeta.addTrail().addContent(T_trail);
    }
    
    /**
     * build the DRI page representing the body of the search query. This
     * provides a widget to generate a new query and list of search results if
     * present.
     */
    public void addBody(Body body) throws SAXException, WingException,
            UIException, SQLException, IOException, AuthorizeException
    {
        Context context = ContextUtil.obtainContext(objectModel);
		DSpaceObject dso = HandleUtil.obtainHandle(objectModel);        
        Request request = ObjectModelHelper.getRequest(objectModel);
    	
        Map<String,String> params = new HashMap<String,String>(request.getParameters());
        String query = request.getParameter("effectivequery");
        String facetField = request.getParameter("facet");
        String mode = request.getParameter("mode");
        
        Message facetName = AbstractSearch.getFacetName(facetField);

        // perform query
        QueryArgs queryArgs = new QueryArgs();
        QueryFacet facet = new QueryFacet(facetField);

        List<QueryFacet> facets = Collections.singletonList(facet);
        queryArgs.setFacets(facets);
        
        QueryResults queryResults = AbstractSearch.reallyPerformSearch(
        		context, queryArgs, query, dso, 1, 1, 0, 0, "DESC");
        
        // Build the DRI Body
        Division search = body.addDivision("show-facet","primary");
        search.setHead(T_head);
        
        int hitCount = queryResults.getHitCount();
        search.addPara().addContent(T_result_query.parameterize(query,hitCount));

        Division div = search.addDivision("facet","secondary");
        div.setHead(facetName);

        // XXX could this formatting be off-loaded to XSL?
    	List<String> items = facet.getItems();
    	int numItems = items.size();
    	int numRows = ((numItems-1) / numColumns)+1;
    	
    	int i = 0;
    	for (int c = 0; c < numColumns; c++)
    	{
    		Table table = div.addTable("facet-results", 1, 1, "tiny narrow");

    		for (int r = 0; r < numRows && i < numItems; r++, i++)
    		{
    			String item = items.get(i);
    			Cell cell = table.addRow(Row.ROLE_DATA).addCell();
    			String facetURL = AbstractSearch.generateFacetURL(mode, params, facetField, item);
    			cell.addXref(facetURL, item);
    			cell.addContent(" (" + facet.getCount(item) + ")");
    		}
    	}
    }
    
}
