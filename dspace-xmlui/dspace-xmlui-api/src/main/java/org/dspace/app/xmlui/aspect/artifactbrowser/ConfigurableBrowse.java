/*
 * ConfigurableBrowse.java
 *
 * Version: $Revision: 4880 $
 *
 * Date: $Date: 2010-05-04 14:32:15 -0400 (Tue, 04 May 2010) $
 *
 * Copyright (c) 2002-2009, The DSpace Foundation.  All rights reserved.
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
 * - Neither the name of the DSpace Foundation nor the names of its
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

import static org.dspace.app.xmlui.aspect.artifactbrowser.BrowseUtils.getIntParameter;

import java.io.IOException;
import java.io.Serializable;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.HashSet;
import java.util.Locale;
import java.util.Map;
import java.util.Set;
import java.util.Vector;

import org.apache.cocoon.caching.CacheableProcessingComponent;
import org.apache.cocoon.environment.ObjectModelHelper;
import org.apache.cocoon.environment.Request;
import org.apache.cocoon.util.HashUtil;
import org.apache.excalibur.source.SourceValidity;
import org.apache.log4j.Logger;
import org.dspace.app.xmlui.aspect.lists.BrowseIndexList;
import org.dspace.app.xmlui.aspect.tagging.BrowseIndexTag;
import org.dspace.app.xmlui.cocoon.AbstractDSpaceTransformer;
import org.dspace.app.xmlui.utils.ContextUtil;
import org.dspace.app.xmlui.utils.DSpaceValidity;
import org.dspace.app.xmlui.utils.HandleUtil;
import org.dspace.app.xmlui.utils.UIException;
import org.dspace.app.xmlui.wing.Message;
import org.dspace.app.xmlui.wing.WingException;
import org.dspace.app.xmlui.wing.element.Body;
import org.dspace.app.xmlui.wing.element.Cell;
import org.dspace.app.xmlui.wing.element.CheckBox;
import org.dspace.app.xmlui.wing.element.Division;
import org.dspace.app.xmlui.wing.element.List;
import org.dspace.app.xmlui.wing.element.PageMeta;
import org.dspace.app.xmlui.wing.element.Para;
import org.dspace.app.xmlui.wing.element.ReferenceSet;
import org.dspace.app.xmlui.wing.element.Row;
import org.dspace.app.xmlui.wing.element.Select;
import org.dspace.app.xmlui.wing.element.Table;
import org.dspace.authorize.AuthorizeException;
import org.dspace.browse.BrowseEngine;
import org.dspace.browse.BrowseException;
import org.dspace.browse.BrowseIndex;
import org.dspace.browse.BrowseIndexItem;
import org.dspace.browse.BrowseIndexManager;
import org.dspace.browse.BrowseIndexMetadata;
import org.dspace.browse.BrowseInfo;
import org.dspace.browse.BrowseItem;
import org.dspace.browse.BrowserScope;
import org.dspace.content.Collection;
import org.dspace.content.Community;
import org.dspace.content.DCDate;
import org.dspace.content.DSpaceObject;
import org.dspace.content.authority.ChoiceAuthorityManager;
import org.dspace.core.ConfigurationManager;
import org.dspace.core.Context;
import org.dspace.core.LogManager;
import org.dspace.handle.HandleManager;
import org.dspace.search.QueryArgs;
import org.dspace.search.QueryFacet;
import org.dspace.search.QueryResults;
import org.dspace.sort.SortException;
import org.dspace.sort.SortOption;
import org.xml.sax.SAXException;

import edu.emory.mathcs.backport.java.util.Arrays;
import edu.emory.mathcs.backport.java.util.Collections;

/**
 * Implements all the browse functionality (browse by title, subject, authors,
 * etc.) The types of browse available are configurable by the implementor. See
 * dspace.cfg and documentation for instructions on how to configure.
 *
 * @author Graham Triggs
 */
public class ConfigurableBrowse extends AbstractDSpaceTransformer implements
        CacheableProcessingComponent
{
    private final static Logger log = Logger.getLogger(ConfigurableBrowse.class);

    /**
     * Static Messages for common text
     */
    private final static Message T_dspace_home = message("xmlui.general.dspace_home");

    private final static Message T_go = message("xmlui.general.go");

    private final static Message T_update = message("xmlui.general.update");

    private final static Message T_choose_month = message("xmlui.ArtifactBrowser.ConfigurableBrowse.general.choose_month");

    private final static Message T_choose_year = message("xmlui.ArtifactBrowser.ConfigurableBrowse.general.choose_year");

    private final static Message T_jump_year = message("xmlui.ArtifactBrowser.ConfigurableBrowse.general.jump_year");

    private final static Message T_jump_year_help = message("xmlui.ArtifactBrowser.ConfigurableBrowse.general.jump_year_help");

    private final static Message T_jump_select = message("xmlui.ArtifactBrowser.ConfigurableBrowse.general.jump_select");

    private final static Message T_starts_with = message("xmlui.ArtifactBrowser.ConfigurableBrowse.general.starts_with");

    private final static Message T_starts_with_help = message("xmlui.ArtifactBrowser.ConfigurableBrowse.general.starts_with_help");

    private final static Message T_sort_by = message("xmlui.ArtifactBrowser.ConfigurableBrowse.general.sort_by");

    private final static Message T_order = message("xmlui.ArtifactBrowser.ConfigurableBrowse.general.order");

    private final static Message T_no_results= message("xmlui.ArtifactBrowser.ConfigurableBrowse.general.no_results");

    private final static Message T_rpp = message("xmlui.ArtifactBrowser.ConfigurableBrowse.general.rpp");

    private final static Message T_etal = message("xmlui.ArtifactBrowser.ConfigurableBrowse.general.etal");

    private final static Message T_etal_all = message("xmlui.ArtifactBrowser.ConfigurableBrowse.etal.all");

    private final static Message T_order_asc = message("xmlui.ArtifactBrowser.ConfigurableBrowse.order.asc");

    private final static Message T_order_desc = message("xmlui.ArtifactBrowser.ConfigurableBrowse.order.desc");

    private final static String BROWSE_URL_BASE = "browse";

    // TODO ultimately it would be nice to invalidate this cache when incremental reindexing takes place
    // this is a map from: handle (or "") -> index name -> years
    private static Map<String, HashMap<String, Vector<Integer>>> yearCache = 
    	new HashMap<String, HashMap<String, Vector<Integer>>>();

    // natural increments for smoothing of years in date browse drop down
    private static final int[] YEAR_ROUNDING = new int[] { 1000, 500, 200, 100, 50, 20, 10, 5, 2 };
    
    // maximum number of entries in date browse drop down
	private static int maxYears = 19; // TODO: candidate for parameterization

    /** The options for results per page */
    private static final int[] RESULTS_PER_PAGE_PROGRESSION = {5,10,20,40,60,80,100};
    
    /** Cached validity object */
    private SourceValidity validity;

    /** Cached UI parameters, results and messages */
    private BrowseParams userParams;

    private BrowseInfo browseInfo;

    private Message titleMessage = null;
    private Message trailMessage = null;

    private static String remoteCommunityHandle = ConfigurationManager.getProperty("federated-browse.handle");
    
    public Serializable getKey()
    {
        try
        {
            BrowseParams params = getUserParams();
            
            String key = params.getKey();
            
            if (key != null)
            {
                DSpaceObject dso = HandleUtil.obtainHandle(objectModel);
                if (dso != null)
                    key += "-" + dso.getHandle();

                return HashUtil.hash(key);
            }
        }
        catch (Exception e)
        {
            // Ignore all errors and just don't cache.
        }
        
        return "0";
    }

    public SourceValidity getValidity()
    {
        if (validity == null)
        {
            try
            {
                DSpaceValidity validity = new DSpaceValidity();
                DSpaceObject dso = HandleUtil.obtainHandle(objectModel);

                if (dso != null)
                    validity.add(dso);
                
                BrowseInfo info = getBrowseInfo();
                
                // Are we browsing items, or unique metadata?
                if (isItemBrowse(info))
                {
                    // Add the browse items to the validity
                    for (BrowseItem item : (java.util.List<BrowseItem>) info.getResults())
                    {
                        validity.add(item);
                    }
                }
                else
                {
                    // Add the metadata to the validity
                    for (String[] singleEntry : browseInfo.getStringResults())
                    {
                        validity.add(singleEntry[0]+"#"+singleEntry[1]);
                    }
                }

                this.validity =  validity.complete();
            }
            catch (Exception e)
            {
                // Just ignore all errors and return an invalid cache.
            }
            
            log.info(LogManager.getHeader(context, "browse", this.validity.toString()));
        }
        
        return this.validity;
    }

    /**
     * Add Page metadata.
     */
    public void addPageMeta(PageMeta pageMeta) throws SAXException, WingException, UIException,
            SQLException, IOException, AuthorizeException
    {
        BrowseInfo info = getBrowseInfo();

        // Get the name of the index
        String type = info.getBrowseIndex().getName();
        
        pageMeta.addMetadata("title").addContent(getTitleMessage(info));

        BrowseUtils.generatePageMeta(pageMeta, objectModel, "browse");

        DSpaceObject dso = HandleUtil.obtainHandle(objectModel);

        pageMeta.addTrailLink(contextPath + "/", T_dspace_home);
        if (dso != null)
            HandleUtil.buildHandleTrail(dso, pageMeta, contextPath);

        pageMeta.addTrail().addContent(getTrailMessage(info));
    }

    /**
     * Add the browse-title division.
     */
    public void addBody(Body body) throws SAXException, WingException, UIException, SQLException,
            IOException, AuthorizeException
    {
    	Division sidebar = body.addDivision("sidebar", "sidebar");

    	BrowseParams params = getUserParams();
        BrowseInfo info = getBrowseInfo();

        String type = info.getBrowseIndex().getName();

        // The division including the navigation links
        Division superdiv = body.addDivision("browse-page");
        BrowseUtils.insertSecondLevelBrowseLinks(objectModel, info, superdiv);

        // Build the DRI Body
        Division div = superdiv.addDivision("browse-by-" + type, "primary");

        div.setHead(getTitleMessage(info));

        // Build the internal navigation (jump lists)
        addBrowseJumpNavigation(div, info, params);
        
        // Build the sort and display controls
        addBrowseControls(div, info, params);

        // This div will hold the browsing results
        Division results = div.addDivision("browse-by-" + type + "-results", "primary");

        // If there are items to browse, add the pagination
        int itemsTotal = info.getTotal();
        if (itemsTotal > 0) 
        {
            //results.setSimplePagination(itemsTotal, firstItemIndex, lastItemIndex, previousPage, nextPage)
            results.setSimplePagination(itemsTotal, browseInfo.getOverallPosition() + 1,
                    browseInfo.getOverallPosition() + browseInfo.getResultCount(), getPreviousPageURL(
                            params, info), getNextPageURL(params, info));

            // Reference all the browsed items
            ReferenceSet referenceSet = results.addReferenceSet("browse-by-" + type,
                    ReferenceSet.TYPE_SUMMARY_LIST, type, null);

            // Are we browsing items, or unique metadata?
            if (isItemBrowse(info))
            {
                // Add the items to the browse results
                for (BrowseItem item : (java.util.List<BrowseItem>) info.getResults())
                {
                    referenceSet.addReference(item);
                }
            }
            else    // browsing a list of unique metadata entries
            {
                // Create a table for the results
                Table singleTable = results.addTable("browse-by-" + type + "-results",
                        browseInfo.getResultCount() + 1, 1);
            
                // Add the column heading
                singleTable.addRow(Row.ROLE_HEADER).addCell().addContent(
                        message("xmlui.ArtifactBrowser.ConfigurableBrowse." + type + ".column_heading"));

                // Iterate each result
                for (String[] singleEntry : browseInfo.getStringResults())
                {
                	Request request = ObjectModelHelper.getRequest(objectModel);

                	// Create a Map of the query parameters for the link
                    Map<String, String> queryParams = BrowseUtils.encodeSecondLevelParameters(request.getParameters());
                    queryParams.put(BrowseParams.TYPE, URLEncode(type));
                    if (singleEntry[1] != null)
                    {
                        queryParams.put(BrowseParams.FILTER_VALUE[1], URLEncode(
                            singleEntry[1]));
                    }
                    else
                    {
                        queryParams.put(BrowseParams.FILTER_VALUE[0], URLEncode(
                            singleEntry[0]));
                    }

                    // Create an entry in the table, and a linked entry
                    Cell cell = singleTable.addRow().addCell();
                    cell.addXref(super.generateURL(BROWSE_URL_BASE, queryParams),
                          singleEntry[0]);
                }  
            }
        }
        else 
        {
            results.addPara(T_no_results);
        }
    }

    /**
     * Recycle
     */
    public void recycle()
    {
        this.validity = null;
        this.userParams = null;
        this.browseInfo = null;
        this.titleMessage = null;
        this.trailMessage = null;
        super.recycle();
    }

    /**
     * Makes the jump-list navigation for the results
     *
     * @param div
     * @param info
     * @param params
     * @throws WingException
     */
    private void addBrowseJumpNavigation(Division div, BrowseInfo info, BrowseParams params)
            throws WingException, SQLException
    {
        // Get the name of the index
        String type = info.getBrowseIndex().getName();

        // Prepare a Map of query parameters required for all links
        Map<String, String> queryParamsGET = new HashMap<String, String>();
        queryParamsGET.putAll(BrowseUtils.getSecondLevelParameters(objectModel));
        queryParamsGET.putAll(params.getCommonParametersEncoded());
        queryParamsGET.putAll(params.getControlParameters());

        Map<String, String> queryParamsPOST = new HashMap<String, String>();
        queryParamsPOST.putAll(BrowseUtils.getSecondLevelParameters(objectModel));
        queryParamsPOST.putAll(params.getCommonParameters());
        queryParamsPOST.putAll(params.getControlParameters());

        // Navigation aid (really this is a poor version of pagination)
        Division jump = div.addInteractiveDivision("browse-navigation", BROWSE_URL_BASE,
                Division.METHOD_POST, "secondary navigation");

        // Add all the query parameters as hidden fields on the form
        for (String key : queryParamsPOST.keySet())
            jump.addHidden(key).setValue(queryParamsPOST.get(key));

        // If this is a date based browse, render the date navigation
        if (isSortedByDate(info))
        {
            Para jumpForm = jump.addPara();

            // Create a select list to choose a month
            jumpForm.addContent(T_jump_select);
            Select month = jumpForm.addSelect(BrowseParams.MONTH);
            month.addOption(false, "-1", T_choose_month);
            for (int i = 1; i <= 12; i++)
            {
                month.addOption(false, String.valueOf(i), DCDate.getMonthName(i, Locale
                        .getDefault()));
            }

            // Create a select list to choose a year
            Select year = jumpForm.addSelect(BrowseParams.YEAR);
            year.addOption(false, "-1", T_choose_year);
            populateYears(year, params.scope);

            // Create a free text entry box for the year
            jumpForm = jump.addPara();
            jumpForm.addContent(T_jump_year);
            jumpForm.addText(BrowseParams.STARTS_WITH).setHelp(T_jump_year_help);
            
            jumpForm.addButton("submit").setValue(T_go);
        }
        else
        {
            // Create a clickable list of the alphabet
            List jumpList = jump.addList("jump-list", List.TYPE_SIMPLE, "alphabet");
            
            // browse params for each letter are all the query params
            // WITHOUT the second-stage browse value, and add STARTS_WITH. // Or not.
            Map<String, String> letterQuery = new HashMap<String, String>(queryParamsGET);
            /*
            for (String valueKey : BrowseParams.FILTER_VALUE)
            {
                letterQuery.remove(valueKey);
            }
            */
            letterQuery.put(BrowseParams.STARTS_WITH, "0");
            jumpList.addItemXref(super.generateURL(BROWSE_URL_BASE, letterQuery), "0-9");
            
            for (char c = 'A'; c <= 'Z'; c++)
            {
                letterQuery.put(BrowseParams.STARTS_WITH, Character.toString(c));
                jumpList.addItemXref(super.generateURL(BROWSE_URL_BASE, letterQuery), Character
                        .toString(c));
            }

            // Create a free text field for the initial characters
            Para jumpForm = jump.addPara();
            jumpForm.addContent(T_starts_with);
            jumpForm.addText(BrowseParams.STARTS_WITH).setHelp(T_starts_with_help);
            
            jumpForm.addButton("submit").setValue(T_go);
        }
    }

    private void populateYears(Select year, BrowserScope scope) throws WingException, SQLException
    {
    	Context context = ContextUtil.obtainContext(objectModel);
    	DSpaceObject dso = HandleUtil.obtainHandle(objectModel);

    	String handle = (dso == null)? "" : dso.getHandle();

    	HashMap<String, Vector<Integer>> collectionCache = yearCache.get(handle);
    	if (collectionCache == null)
    	{
    		collectionCache = new HashMap<String, Vector<Integer>>();
    		yearCache.put(handle, collectionCache);
    	}
    	
    	try {
    		String indexName = scope.getSortOption().getName();
	    	Vector<Integer> years = collectionCache.get(indexName);
	
	    	//if (years == null) // populate cache
	    	//{
	    		years = new Vector<Integer>();
	    		try 
	    		{        	
	    			String facetName = indexName;
	    			if (!facetName.endsWith(".year"))
	    			{
	    				facetName += ".year";
	    			}
	
	    			QueryArgs queryArgs = new QueryArgs();
	    			// add facets
	    			java.util.List<QueryFacet> facets = new ArrayList<QueryFacet>();
	    			QueryFacet facet = new QueryFacet(facetName);
	    			facets.add(facet);
	    			queryArgs.setFacets(facets);
	
	    			// search everything, just to fill the facet
	    			QueryResults queryResults = AbstractSearch.reallyPerformSearch(
	    					context, queryArgs, "*", dso, 1, 1, 0, 0, "ASC"); // XXX "*" is a terrible hack 
	
	    			Vector<String> allYears = new Vector<String>(facet.getItems());
	    			Collections.sort(allYears);
	    			Collections.reverse(allYears);
	
	    			if (!allYears.isEmpty())
	    			{
	    				int count = allYears.size();
	    				float stride = (float)(count-1) / (float)(maxYears-1);
	    				for (int n = 0; n < maxYears; n += 1)
	    				{
	    					int i = Math.round(n*stride);
	    					try 
	    					{
	    						years.add(Integer.valueOf(allYears.get(i)));
	    					}
	    					catch (NumberFormatException e)
	    					{
	    					}
	    				}
	    			}
	
	    			// smooth
	    			int numYears = years.size();
	    			if (numYears > 2 && allYears.size() > maxYears)
	    			{
	    				for (int i = 1; i < numYears-1; i++)
	    				{
	    					int diff = years.get(i-1) - years.get(i+1);
	    					int rounding = 1;
	    					for (int span : YEAR_ROUNDING)
	    					{
	    						if (diff > span * 2)
	    						{
	    							rounding = span;
	    							break;
	    						}
	    					}
	    					int y = years.get(i);
	    					y = rounding*((y+rounding/2)/rounding); // rounding to nearest n
	    					years.set(i, y);
	    				}
	    			}
	    		}
	    		catch (IOException e)
	    		{
	    			throw new UIException("Unable to construct browse date range", e);
	    		}
	    		finally {
	    			collectionCache.put(indexName, years);
	    		}
	    	//}

	    	for (Integer y : years)
	    	{
	    		String yearstr = String.valueOf(y);
	    		year.addOption(false, yearstr, yearstr);
	    	}
    	}
    	catch (BrowseException e)
    	{    		
    	}
    }
    
    /**
     * Add the controls to changing sorting and display options.
     *
     * @param div
     * @param info
     * @param params
     * @throws WingException
     */
    private void addBrowseControls(Division div, BrowseInfo info, BrowseParams params)
            throws WingException
    {
        // Prepare a Map of query parameters required for all links
        Map<String, String> queryParams = new HashMap<String, String>();

        queryParams.putAll(BrowseUtils.getSecondLevelParameters(objectModel));
        queryParams.putAll(params.getCommonParameters());
        queryParams.put(BrowseParams.OFFSET, URLEncode(String.valueOf(info.getOffset())));

        Division controls = div.addInteractiveDivision("browse-controls", BROWSE_URL_BASE,
                Division.METHOD_POST, "browse controls");

        // Add all the query parameters as hidden fields on the form
        for (String key : queryParams.keySet())
            controls.addHidden(key).setValue(queryParams.get(key));

        Para controlsForm = controls.addPara();

        // If we are browsing a list of items
        if (isItemBrowse(info) && info.isSecondLevel())  
        {
            try
            {
                // Create a drop down of the different sort columns available
                Set<SortOption> sortOptions = SortOption.getSortOptions();
                
                // Only generate the list if we have multiple columns
                if (sortOptions.size() > 1)
                {
                    controlsForm.addContent(T_sort_by);
                    Select sortSelect = controlsForm.addSelect(BrowseParams.SORT_BY);
    
                    for (SortOption so : sortOptions)
                    {
                        if (so.isVisible())
                        {
                            sortSelect.addOption(so.equals(info.getSortOption()), so.getNumber(),
                                    message("xmlui.ArtifactBrowser.ConfigurableBrowse.sort_by." + so.getName()));
                        }
                    }
                }
            }
            catch (SortException se)
            {
                throw new WingException("Unable to get sort options", se);
            }
        }

        // Create a control to changing ascending / descending order
        controlsForm.addContent(T_order);
        Select orderSelect = controlsForm.addSelect(BrowseParams.ORDER);
        orderSelect.addOption("ASC".equals(params.scope.getOrder()), "ASC", T_order_asc);
        orderSelect.addOption("DESC".equals(params.scope.getOrder()), "DESC", T_order_desc);

        // Create a control for the number of records to display
        controlsForm.addContent(T_rpp);
        Select rppSelect = controlsForm.addSelect(BrowseParams.RESULTS_PER_PAGE);
        
        for (int i : RESULTS_PER_PAGE_PROGRESSION)
        {
            rppSelect.addOption((i == info.getResultsPerPage()), i, Integer.toString(i));
 
        }
        
        // XXX this should only appear on global browse, with federation enabled.
        controlsForm.addContent("Content Source: "); // XXX i18n
        Select restrict = controlsForm.addSelect(BrowseParams.RESTRICT);
        restrict.addOption(!params.scope.getExcludeContainer(), "false", "All Content"); // XXX i18n
        restrict.addOption(params.scope.getExcludeContainer(), "true", "Local Content Only"); // XXX i18n

        // Create a control for the number of authors per item to display
        // FIXME This is currently disabled, as the supporting functionality
        // is not currently present in xmlui
        //if (isItemBrowse(info))
        //{
        //    controlsForm.addContent(T_etal);
        //    Select etalSelect = controlsForm.addSelect(BrowseParams.ETAL);
        //
        //    etalSelect.addOption((info.getEtAl() < 0), 0, T_etal_all);
        //    etalSelect.addOption(1 == info.getEtAl(), 1, Integer.toString(1));
        //
        //    for (int i = 5; i <= 50; i += 5)
        //    {
        //        etalSelect.addOption(i == info.getEtAl(), i, Integer.toString(i));
        //    }
        //}

        controlsForm.addButton("update").setValue(T_update);
    }

    /**
     * The URL query string of of the previous page.
     *
     * Note: the query string does not start with a "?" or "&" those need to be
     * added as appropriate by the caller.
     */
    private String getPreviousPageURL(BrowseParams params, BrowseInfo info) throws SQLException,
            UIException
    {
        // Don't create a previous page link if this is the first page
        if (info.isFirst())
            return null;

        Map<String, String> parameters = new HashMap<String, String>();
        parameters.putAll(BrowseUtils.getSecondLevelParameters(objectModel));
        parameters.putAll(params.getCommonParametersEncoded());
        parameters.putAll(params.getControlParameters());

        if (info.hasPrevPage())
        {
            parameters.put(BrowseParams.OFFSET, URLEncode(String.valueOf(info.getPrevOffset())));
        }

        return super.generateURL(BROWSE_URL_BASE, parameters);

    }

    /**
     * The URL query string of of the next page.
     *
     * Note: the query string does not start with a "?" or "&" those need to be
     * added as appropriate by the caller.
     */
    private String getNextPageURL(BrowseParams params, BrowseInfo info) throws SQLException,
            UIException
    {
        // Don't create a next page link if this is the last page
        if (info.isLast())
            return null;

        Map<String, String> parameters = new HashMap<String, String>();
        parameters.putAll(BrowseUtils.getSecondLevelParameters(objectModel));
        parameters.putAll(params.getCommonParametersEncoded());
        parameters.putAll(params.getControlParameters());

        if (info.hasNextPage())
        {
            parameters.put(BrowseParams.OFFSET, URLEncode(String.valueOf(info.getNextOffset())));
        }

        return super.generateURL(BROWSE_URL_BASE, parameters);
    }

    /**
     * Get the query parameters supplied to the browse.
     *
     * @return
     * @throws SQLException
     * @throws UIException
     */
    private BrowseParams getUserParams() throws SQLException, UIException
    {
        if (this.userParams != null)
            return this.userParams;

        Context context = ContextUtil.obtainContext(objectModel);
        Request request = ObjectModelHelper.getRequest(objectModel);
        DSpaceObject dso = HandleUtil.obtainHandle(objectModel);
        
        Map<String,String> reqparams = (Map<String,String>)request.getParameters();
        
        BrowseParams params = createUserParams(context, reqparams, dso);
        
        this.userParams = params;
        return params;
    }

    // Code re-use, bitchez!
    public static BrowseParams createUserParams(Context context, Map<String,String> reqparams, DSpaceObject dso) throws SQLException, UIException
    {
        BrowseParams params = new BrowseParams();

        params.month = reqparams.get(BrowseParams.MONTH);
        params.year = reqparams.get(BrowseParams.YEAR);
        params.etAl = getIntParameter(reqparams,BrowseParams.ETAL);

        params.scope = new BrowserScope(context);

        // Are we in a community or collection?
        if (dso instanceof Community)
            params.scope.setCommunity((Community) dso);
        if (dso instanceof Collection)
            params.scope.setCollection((Collection) dso);

        if ("true".equals(reqparams.get("restrict")))
        {        	
        	String excludeContainer = remoteCommunityHandle;
         	DSpaceObject container = HandleManager.resolveToObject(context, excludeContainer);
            if (container instanceof Community)
                params.scope.setCommunity((Community)container);
            if (container instanceof Collection)
                params.scope.setCollection((Collection)container);
        	params.scope.setExcludeContainer(true);            
        }
        
        try
        {
            String type   = reqparams.get(BrowseParams.TYPE);
            int    sortBy = getIntParameter(reqparams,BrowseParams.SORT_BY);
            
            BrowseIndex bi = BrowseIndexManager.getBrowseIndex(type);
            if (bi == null)
            {
                throw new BrowseException("There is no browse index of the type: " + type);
            }
            
            // If we don't have a sort column
            if (sortBy == -1)
            {
                // Get the default one
                SortOption so = bi.getSortOption();
                if (so != null)
                {
                    sortBy = so.getNumber();
                }
            }
            else if (!bi.isIndexBrowse() && !BrowseIndexManager.isInternalIndex(bi))
            {
                try
                {
                    // If a default sort option is specified by the index, but it isn't
                    // the same as sort option requested, attempt to find an index that
                    // is configured to use that sort by default
                    // This is so that we can then highlight the correct option in the navigation
                    SortOption bso = bi.getSortOption();
                    SortOption so = SortOption.getSortOption(sortBy);
                    if ( bso != null && bso != so)
                    {
                        BrowseIndex newBi = BrowseIndexManager.getBrowseIndex(so);
                        if (newBi != null)
                        {
                            bi   = newBi;
                            type = bi.getName();
                        }
                    }
                }
                catch (SortException se)
                {
                    throw new UIException("Unable to get sort options", se);
                }
            }
            
            params.scope.setBrowseIndex(bi);
            params.scope.setSortBy(sortBy);
            
            params.scope.setJumpToItem(getIntParameter(reqparams, BrowseParams.JUMPTO_ITEM));
            params.scope.setOrder(reqparams.get(BrowseParams.ORDER));
            int offset = getIntParameter(reqparams, BrowseParams.OFFSET);
            params.scope.setOffset(offset > 0 ? offset : 0);
            params.scope.setResultsPerPage(getIntParameter(reqparams, BrowseParams.RESULTS_PER_PAGE));
            params.scope.setStartsWith(URLDecode(reqparams.get(BrowseParams.STARTS_WITH)));
            String filterValue = reqparams.get(BrowseParams.FILTER_VALUE[0]);
            if (filterValue == null)
            {
                filterValue = reqparams.get(BrowseParams.FILTER_VALUE[1]);
                params.scope.setAuthorityValue(filterValue);
            }
            
            params.scope.setFilterValue(filterValue);
            params.scope.setJumpToValue(URLDecode(reqparams.get(BrowseParams.JUMPTO_VALUE)));
            params.scope.setJumpToValueLang(URLDecode(reqparams.get(BrowseParams.JUMPTO_VALUE_LANG)));
            params.scope.setFilterValueLang(URLDecode(reqparams.get(BrowseParams.FILTER_VALUE_LANG)));

            // additional, browse-specific, uninterpreted parameters
            params.scope.setParameters(BrowseParams.filterParameters(reqparams));
            
            // Filtering to a value implies this is a second level browse
            if (params.scope.getFilterValue() != null)
                params.scope.setBrowseLevel(1);

            // if year and perhaps month have been selected, we translate these
            // into "startsWith"
            // if startsWith has already been defined then it is overwritten
            if (params.year != null && !"".equals(params.year) && !"-1".equals(params.year)
            		&& URLDecode(reqparams.get(BrowseParams.STARTS_WITH)).isEmpty())
            {
                String startsWith = params.year;
                if ((params.month != null) && !"-1".equals(params.month)
                        && !"".equals(params.month))
                {
                    // subtract 1 from the month, so the match works
                    // appropriately
                    if ("ASC".equals(params.scope.getOrder()))
                    {
                        params.month = Integer.toString((Integer.parseInt(params.month) - 1));
                    }

                    // They've selected a month as well
                    if (params.month.length() == 1)
                    {
                        // Ensure double-digit month number
                        params.month = "0" + params.month;
                    }

                    startsWith = params.year + "-" + params.month;

                    if ("ASC".equals(params.scope.getOrder()))
                    {
                        startsWith = startsWith + "-32";
                    }
                }

                params.scope.setStartsWith(startsWith);
            }
        }
        catch (BrowseException bex)
        {
            throw new UIException("Unable to create browse parameters", bex);
        }

        return params;
    }

    /**
     * Get the results of the browse. If the results haven't been generated yet,
     * then this will perform the browse.
     *
     * @return
     * @throws SQLException
     * @throws UIException
     */
    private BrowseInfo getBrowseInfo() throws SQLException, UIException
    {
        if (this.browseInfo != null)
            return this.browseInfo;

        Context context = ContextUtil.obtainContext(objectModel);

        // Get the parameters we will use for the browse
        // (this includes a browse scope)
        BrowseParams params = getUserParams();

        try
        {
            // Create a new browse engine, and perform the browse
            BrowseEngine be = new BrowseEngine(context);
            this.browseInfo = be.browse(params.scope);

            // figure out the setting for author list truncation
            if (params.etAl < 0)
            {
                // there is no limit, or the UI says to use the default
                int etAl = ConfigurationManager.getIntProperty("webui.browse.author-limit");
                if (etAl != 0)
                {
                    this.browseInfo.setEtAl(etAl);
                }

            }
            else if (params.etAl == 0) // 0 is the user setting for unlimited
            {
                this.browseInfo.setEtAl(-1); // but -1 is the application
                // setting for unlimited
            }
            else
            // if the user has set a limit
            {
                this.browseInfo.setEtAl(params.etAl);
            }
        }
        catch (BrowseException bex)
        {
            throw new UIException("Unable to process browse", bex);
        }

        return this.browseInfo;
    }

    /**
     * Is this a browse on a list of items, or unique metadata values?
     *
     * @param info
     * @return
     */
    private boolean isItemBrowse(BrowseInfo info)
    {
        return !info.getBrowseIndex().isIndexBrowse() || info.isSecondLevel();
    }
    
    /**
     * Is this browse sorted by date?
     * @param info
     * @return
     */
    private boolean isSortedByDate(BrowseInfo info)
    {
        return info.getSortOption().isDate() ||
            (info.getBrowseIndex().isDate() && info.getSortOption().isDefault());
    }

    private Message getTitleMessage(BrowseInfo info) throws UIException, SQLException
    {
        if (titleMessage == null)
        {
            BrowseIndex bix = info.getBrowseIndex();

            // For a second level browse (ie. items for author),
            // get the value we are focussing on (ie. author).
            // (empty string if none).
            String value = "";
            if (info.hasValue())
            {
                if (bix instanceof BrowseIndexMetadata && ((BrowseIndexMetadata)bix).isAuthorityIndex())
                {
                    ChoiceAuthorityManager cm = ChoiceAuthorityManager.getManager();
                    String fk = cm.makeFieldKey(((BrowseIndexMetadata)bix).getMetadata(0));
                    value = "\""+cm.getLabel(fk, info.getValue(), null)+"\"";
                }
                else
                    value = "\"" + info.getValue() + "\"";
            }

            // Get the name of any scoping element (collection / community)
            String scopeName = "";
            
            if (info.getBrowseContainer() != null)
                scopeName = info.getBrowseContainer().getName();
            else
                scopeName = "";
            
            if (bix instanceof BrowseIndexMetadata)
            {
                titleMessage = message("xmlui.ArtifactBrowser.ConfigurableBrowse.title.metadata." + bix.getName())
                        .parameterize(scopeName, value);
            }
            else if (bix instanceof BrowseIndexItem)
            {
            	if (info.getSortOption() != null)
            	{
            		titleMessage = message("xmlui.ArtifactBrowser.ConfigurableBrowse.title.item." + info.getSortOption().getName())
            		.parameterize(scopeName, value);
            	}
            	else
            	{
            		titleMessage = message("xmlui.ArtifactBrowser.ConfigurableBrowse.title.item." + bix.getSortOption().getName())
            		.parameterize(scopeName, value);
            	}
            }
            else if (bix instanceof BrowseExtension)
            {
            	titleMessage = ((BrowseExtension)bix).getTitleMessage(getUserParams().scope, scopeName, value);
            }
        }
        
        return titleMessage;
    }

    private Message getTrailMessage(BrowseInfo info) throws UIException, SQLException
    {
        if (trailMessage == null)
        {
            BrowseIndex bix = info.getBrowseIndex();

            // Get the name of any scoping element (collection / community)
            String scopeName = "";
            
            if (info.getBrowseContainer() != null)
                scopeName = info.getBrowseContainer().getName();
            else
                scopeName = "";

            if (bix instanceof BrowseIndexMetadata)
            {
                trailMessage = message("xmlui.ArtifactBrowser.ConfigurableBrowse.trail.metadata." + bix.getName())
                        .parameterize(scopeName);
            }
            else if (bix instanceof BrowseIndexItem)
            {
            	if (info.getSortOption() != null)
            	{
            		trailMessage = message("xmlui.ArtifactBrowser.ConfigurableBrowse.trail.item." + info.getSortOption().getName())
            		.parameterize(scopeName);
            	}
            	else
            	{
            		trailMessage = message("xmlui.ArtifactBrowser.ConfigurableBrowse.trail.item." + bix.getSortOption().getName())
            		.parameterize(scopeName);
            	}
            }
            else if (bix instanceof BrowseExtension)
            {
            	trailMessage = ((BrowseExtension)bix).getTrailMessage(getUserParams().scope, scopeName);
            }
        }
        
        return trailMessage;
    }
}

/*
 * Helper class to track browse parameters
 */
class BrowseParams
{
    String month;

    String year;

    int etAl;

    BrowserScope scope;

    final static String MONTH = "month";

    final static String YEAR = "year";

    final static String ETAL = "etal";

    final static String TYPE = "type";

    final static String JUMPTO_ITEM = "focus";

    final static String JUMPTO_VALUE = "vfocus";

    final static String JUMPTO_VALUE_LANG = "vfocus_lang";

    final static String ORDER = "order";

    final static String OFFSET = "offset";

    final static String RESULTS_PER_PAGE = "rpp";

    final static String SORT_BY = "sort_by";

    final static String STARTS_WITH = "starts_with";

    final static String[] FILTER_VALUE = new String[]{"value","authority"};

    final static String FILTER_VALUE_LANG = "value_lang";
    
    final static String RESTRICT = "restrict";
    
    // XXX hacky (plus apparent eclipse bug in varargs, unless I drastically misunderstand)
    final static java.util.List<String> knownParams = 
    	Arrays.asList(new String[] {MONTH, YEAR, ETAL, TYPE, JUMPTO_ITEM, JUMPTO_VALUE, JUMPTO_VALUE_LANG,
    			ORDER, OFFSET, RESULTS_PER_PAGE, SORT_BY, STARTS_WITH, 
    			FILTER_VALUE[0], FILTER_VALUE[1], FILTER_VALUE_LANG, RESTRICT});    

    static Map<String, String> filterParameters(Map<String,String> params)
    {
    	Map<String,String> newparams = new HashMap<String,String>(params);
    	newparams.keySet().removeAll(knownParams);
    	return newparams;
    }
    
    /*
     * Creates a map of the browse options common to all pages (type / value /
     * value language)
     */
    Map<String, String> getCommonParameters() throws UIException
    {
        Map<String, String> paramMap = new HashMap<String, String>();

        paramMap.put(BrowseParams.TYPE, scope.getBrowseIndex().getName());

        if (scope.getFilterValue() != null)
        {
            paramMap.put(scope.getAuthorityValue() != null?
                    BrowseParams.FILTER_VALUE[1]:BrowseParams.FILTER_VALUE[0], scope.getFilterValue());
        }

        if (scope.getFilterValueLang() != null)
        {
            paramMap.put(BrowseParams.FILTER_VALUE_LANG, scope.getFilterValueLang());
        }

        paramMap.putAll(scope.getParameters());

        return paramMap;
    }

    Map<String, String> getCommonParametersEncoded() throws UIException
    {
        Map<String, String> paramMap = getCommonParameters();
        Map<String, String> encodedParamMap = new HashMap<String, String>();

        for (String key: paramMap.keySet())
        {
            encodedParamMap.put(key, AbstractDSpaceTransformer.URLEncode(paramMap.get(key)));
        }

        return encodedParamMap;
    }


    /*
     * Creates a Map of the browse control options (sort by / ordering / results
     * per page / authors per item)
     */
    Map<String, String> getControlParameters() throws UIException
    {
        Map<String, String> paramMap = new HashMap<String, String>();

        paramMap.put(BrowseParams.SORT_BY, Integer.toString(this.scope.getSortBy()));
        paramMap
                .put(BrowseParams.ORDER, AbstractDSpaceTransformer.URLEncode(this.scope.getOrder()));
        paramMap.put(BrowseParams.RESULTS_PER_PAGE, Integer
                .toString(this.scope.getResultsPerPage()));
        paramMap.put(BrowseParams.ETAL, Integer.toString(this.etAl));
        paramMap.put(BrowseParams.RESTRICT, Boolean.toString(this.scope.getExcludeContainer()));

        return paramMap;
    }
    
    String getKey()
    {
        try
        {
            String key = "";
            
            key += "-" + scope.getBrowseIndex().getName();
            key += "-" + scope.getBrowseLevel();
            key += "-" + scope.getStartsWith();
            key += "-" + scope.getOrder();
            key += "-" + scope.getResultsPerPage();
            key += "-" + scope.getSortBy();
            key += "-" + scope.getSortOption().getNumber();
            key += "-" + scope.getOffset();
            key += "-" + scope.getJumpToItem();
            key += "-" + scope.getFilterValue();
            key += "-" + scope.getFilterValueLang();
            key += "-" + scope.getJumpToValue();
            key += "-" + scope.getJumpToValueLang();
            key += "-" + scope.getExcludeContainer();
            for (String val : scope.getParameters().values())
            {
            	key += "-" + val;
            }
            key += "-" + etAl;
    
            return key;
        }
        catch (Exception e)
        {
            return null; // ignore exception and return no key
        }
    }
};
