/*
 * FancySearch adapted from AdvancedSearch
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
import java.text.ParsePosition;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.Map;
import java.util.TimeZone;

import org.apache.cocoon.caching.CacheableProcessingComponent;
import org.apache.cocoon.environment.ObjectModelHelper;
import org.apache.cocoon.environment.Request;
import org.apache.commons.lang.StringUtils;
import org.apache.lucene.document.DateTools;
import org.apache.oro.text.perl.Perl5Util;
import org.dspace.app.xmlui.utils.HandleUtil;
import org.dspace.app.xmlui.utils.UIException;
import org.dspace.app.xmlui.wing.Message;
import org.dspace.app.xmlui.wing.WingException;
import org.dspace.app.xmlui.wing.element.Body;
import org.dspace.app.xmlui.wing.element.Cell;
import org.dspace.app.xmlui.wing.element.Division;
import org.dspace.app.xmlui.wing.element.List;
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
import org.xml.sax.SAXException;

/**
 * Preform an advanced search of the repository. The user is presented with
 * three search parameters, that may be ORed, ANDed, NOTed together.
 * 
 * At the present time only three fields are displayed however if the theme
 * whishes to expand this they can by setting the num_search_fields to the
 * desired number of search fields. Also the theme can change the number of
 * results per the page by setting results_per_page
 * 
 * FIXME: The list of what fields are search should come from a configurable
 * place. Possibily the sitemap configuration.
 * 
 * @author Scott Phillips
 */
public class FancySearch extends AbstractSearch implements CacheableProcessingComponent
{
    /** Language string used: */
    private static final Message T_title =
        message("xmlui.ArtifactBrowser.AdvancedSearch.title");
    
    private static final Message T_dspace_home =
        message("xmlui.general.dspace_home");
    
    private static final Message T_trail = 
        message("xmlui.ArtifactBrowser.AdvancedSearch.trail");
    
    private static final Message T_head = 
        message("xmlui.ArtifactBrowser.AdvancedSearch.head");
    
    private static final Message T_search_scope = 
        message("xmlui.ArtifactBrowser.AdvancedSearch.search_scope");
    
    private static final Message T_search_scope_help = 
        message("xmlui.ArtifactBrowser.AdvancedSearch.search_scope_help");
    
    private static final Message T_conjunction = 
        message("xmlui.ArtifactBrowser.AdvancedSearch.conjunction");
    
    private static final Message T_search_type =
        message("xmlui.ArtifactBrowser.AdvancedSearch.search_type");
    
    private static final Message T_search_for = 
        message("xmlui.ArtifactBrowser.AdvancedSearch.search_for");
    
    private static final Message T_search_from =
    	message("xmlui.ArtifactBrowser.AdvancedSearch.search_from");
        
    private static final Message T_search_upto =
    	message("xmlui.ArtifactBrowser.AdvancedSearch.search_upto");
        
    private static final Message T_add_field =
    	message("xmlui.ArtifactBrowser.AdvancedSearch.search_add_field");
        
    private static final Message T_add_range =
    	message("xmlui.ArtifactBrowser.AdvancedSearch.search_add_range");
        
    private static final Message T_go = 
        message("xmlui.general.go");

    private static final Message T_and = 
        message("xmlui.ArtifactBrowser.AdvancedSearch.and");
    
    private static final Message T_or = 
        message("xmlui.ArtifactBrowser.AdvancedSearch.or");
    
    private static final Message T_not = 
        message("xmlui.ArtifactBrowser.AdvancedSearch.not");
    
    private static Map<String,String> typeFields;
    private static Map<String,Message> searchTypes;
    
    /** A cache of extracted search fields */
    private ArrayList<SearchField> fields;
    private ArrayList<SearchField> ranges; // range queries
    
    
    // It would be nice if we could just leverage the DSIndexer code
    {
        typeFields = new LinkedHashMap<String,String>();
        searchTypes = new LinkedHashMap<String, Message>();
        
        int i = 1;
        String sindex = ConfigurationManager.getProperty("search.index." + i);
        while(sindex != null)
        {
            String[] parts = sindex.split(":");
            String fieldtype = parts[0];
            String fieldformat = "text"; // default
            if (parts.length > 2) 
            {
                fieldformat = parts[2];
            }
            typeFields.put(fieldtype, fieldformat);
            searchTypes.put(fieldtype, message("xmlui.ArtifactBrowser.AdvancedSearch.type_" + fieldtype));
            
            sindex = ConfigurationManager.getProperty("search.index." + ++i);
        }
        
        typeFields.put("itemsource", "text");
        searchTypes.put("itemsource", message("xmlui.ArtifactBrowser.AdvancedSearch.type_itemsource"));
        
        if (ConfigurationManager.getBooleanProperty("search.tags", false))
        {
        	typeFields.put("tag_tag","text");
        	searchTypes.put("tag_tag", message("xmlui.ArtifactBrowser.AdvancedSearch.type_tag_tag"));

        	typeFields.put("tag_utag", "utag");
        	searchTypes.put("tag_utag", message("xmlui.ArtifactBrowser.AdvancedSearch.type_tag_utag"));
        }
    }

    /**
     * Add Page metadata.
     * @throws IOException 
     */
    public void addPageMeta(PageMeta pageMeta) throws WingException, SQLException, IOException
    {
        Request request = ObjectModelHelper.getRequest(objectModel);

        pageMeta.addMetadata("title").addContent(T_title);
        
        BrowseUtils.generatePageMeta(pageMeta, objectModel, generateBaseURL(), getEffectiveQuery());
        
		DSpaceObject dso = HandleUtil.obtainHandle(objectModel);

		pageMeta.addTrailLink(contextPath + "/", T_dspace_home);
        if ((dso instanceof Collection) || (dso instanceof Community))
        {
	        HandleUtil.buildHandleTrail(dso,pageMeta,contextPath);
		} 
		
        pageMeta.addTrail().addContent(T_trail);
    }
    
    /**
     * Add the body
     */
    public void addBody(Body body) throws SAXException, WingException,
            UIException, SQLException, IOException, AuthorizeException
    {    	
    	getQuery(); // need to prime some fields, might as well do it here

    	Division sidebar = body.addDivision("sidebar", "sidebar");

    	Request request = ObjectModelHelper.getRequest(objectModel);

        // Build the DRI Body
        Division search = body.addDivision("fancy-search","primary");
        search.setHead(T_head);
        Division query = search.addInteractiveDivision("search-query",
                generateBaseURL(),Division.METHOD_POST,"secondary search");
        
        query.addPara(null, "invisible").addButton("submit").setValue(T_go); // so that pressing return does the right thing
        
        // Use these fields to change the number of search fields, or change the results per page.
        query.addHidden("results_per_page").setValue(getParameterRpp());
        
        List queryList = query.addList("search-query",List.TYPE_FORM);
        
        if (variableScope())
        {
            Select scope = queryList.addItem().addSelect("scope");
            scope.setLabel(T_search_scope);
            scope.setHelp(T_search_scope_help);
            buildScopeList(scope);
        }
                
        // standard fields
        query.addHidden("num_search_field").setValue(fields.size());

        Table queryTable = query.addTable("search-query", 4, 4); // XXX rows apparently does not have to be pre-computed
        Row header = queryTable.addRow(Row.ROLE_HEADER);
        header.addCellContent(T_conjunction);
        header.addCellContent(T_search_type);
        header.addCellContent(T_search_for);
        header.addCellContent("");
        
        buildFields(query, queryTable, fields);

        //range fields
        query.addHidden("num_range_field").setValue(ranges.size());

        Table rangeTable = query.addTable("range-query", 4, 5); // XXX rows apparently does not have to be pre-computed
        Row rheader = rangeTable.addRow(Row.ROLE_HEADER);
        rheader.addCellContent(T_conjunction);
        rheader.addCellContent(T_search_type);
        rheader.addCellContent(T_search_from);
        rheader.addCellContent(T_search_upto);
        rheader.addCellContent("");

        buildFields(query, rangeTable, ranges);
        
        // rest of the controls
        buildSearchControls(query);

        query.addPara(null, "button-list").addButton("submit").setValue(T_go);
        
        // Add the result division
        buildSearchResultsDivision(search, sidebar);

    }

    protected void buildFields(Division div, Table table, ArrayList<SearchField> fields) throws WingException {
        for (SearchField field : fields) { 
            if (field.getIndex() <= fields.size()) // always true for now 
            {
                Row row = table.addRow(Row.ROLE_DATA);
                field.buildRow(row, field.getIndex() == fields.size());
            }
            else
            {
                field.buildHidden(div);
            }
        }
    }


    /**
     * Recycle
     */
    public void recycle() 
    {
        this.fields = null;
        this.ranges = null;
        super.recycle();
    }
    
        
    protected Map<String,String> generateParameters(Map<String, String> parameters)
            throws UIException
    {
        Request request = ObjectModelHelper.getRequest(objectModel);
        
        parameters.put("num_search_field", String.valueOf(fields.size()));
        parameters.put("num_range_field", String.valueOf(ranges.size()));

        String resultsPerPage = request.getParameter("results_per_page");
        if (resultsPerPage != null)
        	parameters.put("results_per_page", resultsPerPage);
        
        String scope = request.getParameter("scope");
        if (scope != null)
        	parameters.put("scope", scope);
        
        for (SearchField searchField : getSearchFields(request))
        {
            searchField.addParameters(parameters);
        }
        
        for (SearchField searchField : getRangeFields(request))
        {
            searchField.addParameters(parameters);
        }
        
        if (parameters.get("page") == null)
        	parameters.put("page", String.valueOf(getParameterPage()));
        
        if (parameters.get("rpp") == null)
        	parameters.put("rpp", String.valueOf(getParameterRpp()));
        
        if (parameters.get("sort_by") == null)
        	parameters.put("sort_by", String.valueOf(getParameterSortBy()));
        
        if (parameters.get("order") == null)
        	parameters.put("order",getParameterOrder());
        
        if (parameters.get("etal") == null)
        	parameters.put("etal",String.valueOf(getParameterEtAl()));
        
        return parameters;
    }

    /**
     * Generate a URL for this search page which includes all the 
     * search parameters along with the added parameters.
     * 
     * @param parameters URL parameters to be included in the generated url.
     */
    protected String generateBaseURL()
    {
        return "fancy-search";
    }

    /**
     * Determine the search query for this search page.
     * 
     * @return the query.
     */
    protected String getQuery(boolean fuzzy) throws UIException
    {
        Request request = ObjectModelHelper.getRequest(objectModel);   
        return buildQuery(getSearchFields(request), getRangeFields(request), fuzzy);
    }
    
    
    /**
     * Given a list of search fields buld a lucene search query string.
     * 
     * @param fields The search fields
     * @return A string
     */
    private String buildQuery(ArrayList<SearchField> fields, ArrayList<SearchField> ranges, boolean fuzzy)
    {
    	Perl5Util util = new Perl5Util();
    	
    	String query = "";
    	
    	// Loop through the fields building the search query as we go.
    	for (SearchField field : fields)
    	{	
    	    query += field.buildQuery(util, !query.isEmpty(), fuzzy);
    	}
    	
        for (SearchField field : ranges)
        {   
            query += field.buildQuery(util, !query.isEmpty(), fuzzy);
        }

        if (query.length() == 0)
    		return "";
    	else
    		return "("+query+")";
    }

   
    /**
     * Get a list of search fields from the request object
     * and parse them into a linear array of fileds. The field's
     * index is preserved, so if it comes in as index 17 it will 
     * be outputted as field 17.
     * 
     * @param request The http request object
     * @return Array of search fields
     * @throws UIException 
     */
    public ArrayList<SearchField> getSearchFields(Request request) throws UIException
	{
    	if (this.fields != null)
    		return this.fields;
    	
    	// Get how many fields to search
	    int numSearchField;
	    try {
	    	String numSearchFieldStr = request.getParameter("num_search_field");
	    	numSearchField = Integer.valueOf(numSearchFieldStr);
	    } 
	    catch (NumberFormatException nfe)
	    {
	    	numSearchField = 0;
	    }
	    	
    	// Iterate over all the possible fields and add each one to the list of fields.
		ArrayList<SearchField> fields = new ArrayList<SearchField>();
		for (int i = 1; i <= numSearchField; i++)
		{
		    fields.add(new SingleSearchField(request, i));		        
		}
		
        String add = request.getParameter("add");
        if (add != null || numSearchField == 0) {
            numSearchField++;
            String addfield = request.getParameter("addfield");
            String addquery = request.getParameter("addquery");
            if (addfield != null && addquery != null)
            {
            	fields.add(new SingleSearchField(numSearchField, "AND", addfield, "\"" + addquery + "\""));
            }
            else
            {
            	fields.add(new SingleSearchField(request, numSearchField));
            }
        }
        
		this.fields = fields;
		
		return this.fields;
	}
    
    /**
     * Get a list of range fields from the request object
     * and parse them into a linear array of fileds. The field's
     * index is preserved, so if it comes in as index 17 it will 
     * be outputted as field 17.
     * 
     * @param request The http request object
     * @return Array of search fields
     * @throws UIException 
     */
    public ArrayList<SearchField> getRangeFields(Request request) throws UIException
    {
        if (this.ranges != null)
            return this.ranges;
        
        // Get how many fields to search
        int numSearchField;
        try {
            String numSearchFieldStr = request.getParameter("num_range_field");
            numSearchField = Integer.valueOf(numSearchFieldStr);
        } 
        catch (NumberFormatException nfe)
        {
            numSearchField = 0;
        }
            
        // Iterate over all the possible fields and add each one to the list of fields.
        ArrayList<SearchField> fields = new ArrayList<SearchField>();
        for (int i = 1; i <= numSearchField; i++)
        {
            fields.add(new RangeSearchField(request, i));
        }
        
        String add = request.getParameter("addrange");
        if (add != null || numSearchField == 0) {
            numSearchField++;
            fields.add(new RangeSearchField(request, numSearchField));
        }

        this.ranges = fields;
        
        return this.ranges;
    }

    private static abstract class SearchField {

        /** What index the search field is, typicaly there are just three - but the theme may exand this number */
        protected int index;
        
        /** The field to search, ANY if none specified */
        protected String field;
        
        /** the conjunction: either "AND" or "OR" */
        protected String conjunction;
        
        public SearchField(Request request, int i) 
        {
            this.index = i;
            field = parseField(request);
            conjunction = parseConjunction(request);
        }
        
        public SearchField(int i, String conjunction, String field) 
        {
        	this.index = i;
        	this.conjunction = conjunction;
        	this.field = field;
        }
        
        public int    getIndex() { return this.index;}
        public String getField() { return this.field;}
        public String getConjunction() { return this.conjunction;} 

        public String parseField(Request request) {
            String field = trim(request.getParameter(getFieldFieldName(index)));
            if (field == null)
                field = "ANY";
            return field;
        }
        
        public String parseConjunction(Request request) {
            String conjunction = trim(request.getParameter(getConjunctionFieldName(index)));
            if (conjunction == null)
                conjunction = "AND";
            return conjunction;
        }
        
        public static String trim(String s) {
            if (s != null)
            {
                s = s.trim();
                if (s.length() == 0)
                    s = null;
            }
            return s;
        }
        
        public abstract String getConjunctionFieldName(int index);

        public abstract String getFieldFieldName(int index);

        // Must override
        public void addParameters(Map<String,String> parameters)
        {
            parameters.put(getConjunctionFieldName(index), conjunction);
            parameters.put(getFieldFieldName(index), field);
        }

        // Must override
        public void buildHidden(Division query) throws WingException
        {
            query.addHidden(getConjunctionFieldName(index)).setValue(conjunction);
            query.addHidden(getFieldFieldName(index)).setValue(field);
        }

        public void buildBaseRow(Row row, boolean conj) throws WingException {
            if (conj)
            {
                buildConjunctionField(row.addCell());
            }
            else
            {
                row.addCell();
            }
            buildTypeField(row.addCell());
        }        
        
        public abstract void buildRow(Row row, boolean last) throws WingException;
        
        public abstract String buildQuery(Perl5Util util, boolean conj, boolean fuzzy);

        /**
         * Build a conjunction field in the given for the given cell. A 
         * conjunction consists of logical the operators AND, OR, NOT.
         *
         * @param row The current row
         * @param cell The current cell
         */
        private void buildConjunctionField(Cell cell) throws WingException
        {
            Select select = cell.addSelect(getConjunctionFieldName(index));

            select.addOption("AND".equals(conjunction), "AND").addContent(T_and);
            select.addOption("OR".equals(conjunction), "OR").addContent(T_or);
            select.addOption("NOT".equals(conjunction), "NOT").addContent(T_not);
        }

        /**
         * Build a list of all the indexable fields in the given cell.
         * 
         * FIXME: This needs to use the dspace.cfg data
         * 
         * @param row The current row
         * @param cell The current cell
         */
        private void buildTypeField(Cell cell) throws WingException
        {
            Select select = cell.addSelect(getFieldFieldName(index));

            // Special case ANY
            select.addOption((field == null), "ANY").addContent(
                    message("xmlui.ArtifactBrowser.AdvancedSearch.type_ANY"));

            for (String key : searchTypes.keySet())
            {
            	String current = StringUtils.substringBefore(field,".");
                select.addOption(key.equals(current), key).addContent(
                        searchTypes.get(key));
            }
        }

    }
    
    /**
     * A private record keeping class to relate the various 
     * components of a search field together.
     */
    private static class SingleSearchField extends SearchField {
    	
    	/** The query string to search for */
    	private String query;
    	
        public SingleSearchField(Request request, int i) throws UIException 
        {
            super(request, i);
            this.query = trim(URLDecode(request.getParameter("query"+i)));
        }
        
        public SingleSearchField(int index, String conjunction, String field, String query) throws UIException
        {
        	super(index, conjunction, field);
        	this.query = URLDecode(query);
        }

    	public String getQuery() { return this.query;}

        @Override
        public String getConjunctionFieldName(int index)
        {
            return "conjunction" + index;
        }

        @Override
        public String getFieldFieldName(int index)
        {
            return "field" + index;
        }

        public void addParameters(Map<String,String> parameters)
        {
        	if (query != null) 
        	{
        		super.addParameters(parameters);
        		parameters.put("query"+index, query);
        	}
        }
        
        public void buildHidden(Division div) throws WingException
        {
            super.buildHidden(div);
            div.addHidden("query"+index).setValue(query);
        }

        public void buildRow(Row row, boolean last) throws WingException {
            buildBaseRow(row, index != 1);
            buildQueryField(row.addCell());
            
            if (last)
            {
                row.addCell().addButton("add").setValue(T_add_field);
            }
            else
            {
            	row.addCell();
            }
        }

        /**
         * Build the query field for the given cell.
         * 
         * @param row The current row.
         * @param cell The current cell.
         */
        private void buildQueryField(Cell cell) throws WingException
        {
            Text text = cell.addText("query" + index);
            if (query != null)
                text.setValue(query);
        }

        public String buildQuery(Perl5Util util, boolean conj, boolean fuzzy)
        {
            String q = "";
            // if the field is empty, then skip it and try a later one.
            if (query == null)
                return q;
            
            if (conj)
                q += " " + conjunction + " ";
            
            // Two cases, one if a specific search field is specified or if 
            // ANY is given then just a general search is performed.
            if ("ANY".equals(field))
            {
                // No field specified, 
                q += "(" + (fuzzy? fuzzify(query) : query) + ")";
            }
            else if ("date".equals(typeFields.get(field)))
            {
                q += buildDateQuery(util);
            }
            else
            {   
            	String subquery = query;
            	if ("utag".equals(typeFields.get(field)))
            	{
            		subquery = "#" + subquery;
            	}
            			
                // Specific search field specified, add the field specific field.

                // Replace singe quote's with double quotes (only if they match)
                // Yuck.
                subquery = util.substitute("s/\'(.*)\'/\"$1\"/g", subquery);
             
                subquery = fuzzy? fuzzify(subquery) : subquery;
                
                // ... then seperate each word and re-specify the search field.
                subquery = fieldify(subquery, field);
                
                // Put the subquery into the general query
                q += "("+subquery+")";
            }
            return q;
        }

        private String buildDateQuery(Perl5Util util)
        {
            String datequery = util.substitute("s/\"(.*)\"/$1/g", query);

            Date date = DateHelper.toDate(datequery, false);

            if (date == null)
                return "";

            String datestr;
            String fieldstr;

            if (datequery.length() == 4)
            {
                datestr = DateTools.dateToString(date, DateTools.Resolution.YEAR);
                fieldstr = field + ".year";
            }
            else
            {
                datestr = DateTools.dateToString(date, DateTools.Resolution.DAY);
                fieldstr = field;
            }

            return "("+fieldstr+":"+datestr+")";
        }

    }
    
    /**
     * A private record keeping class to relate the various 
     * components of a search field together.
     */
    private static class RangeSearchField extends SearchField {
        
        /** The query string to search for to begin the range*/
        private String startquery;
        
        /** The query string to search for to end the range*/
        private String endquery;

        // let's just assume inclusive ranges for now
        public RangeSearchField(Request request, int i) throws UIException {
            super(request, i);
            this.startquery = trim(URLDecode(request.getParameter("rstartquery"+i)));
            this.endquery = trim(URLDecode(request.getParameter("rendquery"+i)));
        }        

        public String getStart() { return this.startquery;}
        public String getEnd()   { return this.endquery;}

        @Override
        public String getConjunctionFieldName(int index)
        {
            return "rconjunction" + index;
        }

        @Override
        public String getFieldFieldName(int index)
        {
            return "rfield" + index;
        }

        public void addParameters(Map<String,String> parameters)
        {
        	if (startquery != null && endquery != null)
        	{
        		super.addParameters(parameters);
        		parameters.put("rstartquery" + index, startquery);
        		parameters.put("rendquery" + index, endquery);
        	}
        }

        public void buildHidden(Division div) throws WingException
        {
            super.buildHidden(div);
            div.addHidden("rstartquery"+index).setValue(startquery);
            div.addHidden("rendquery"+index).setValue(endquery);
        }

        public void buildRow(Row row, boolean last) throws WingException {
            buildBaseRow(row, true);
            buildStartField(row.addCell());
            buildEndField(row.addCell());
            if (last)
            {
                row.addCell().addButton("addrange").setValue(T_add_range);
            }
            else
            {
            	row.addCell();
            }
        }

        private void buildStartField(Cell cell) throws WingException
        {
            Text text = cell.addText("rstartquery" + index, "narrow");
            if (startquery != null)
                text.setValue(startquery);
        }            

        private void buildEndField(Cell cell) throws WingException
        {
            Text text = cell.addText("rendquery" + index, "narrow");
            if (endquery != null)
                text.setValue(endquery);            
        }

        @Override
        public String buildQuery(Perl5Util util, boolean conj, boolean fuzzy)
        {
            String q = "";
            // if the field is empty, then skip it and try a later one.
            if (startquery == null || endquery == null)
                return q;
            
            if (conj)
                q += " " + conjunction + " ";

            if ("date".equals(typeFields.get(field)))
            {
                q += buildDateQuery(util);
            }
            else
            {
                String range = "[" + startquery + " TO " + endquery + "]";

                // Two cases, one if a specific search field is specified or if 
                // ANY is given then just a general search is performed.
                if ("ANY".equals(field))
                {
                    // No field specified, 
                    q += "(" + range + ")";
                }
                else
                {   
                    // Put the subquery into the general query
                    q += "("+field+":"+range+")";
                }
            }
            return q;
        }

        private String buildDateQuery(Perl5Util util)
        {
            // should deal with rounding start date and end date differently
            Date startdate = DateHelper.toDate(startquery, false);
            Date enddate = DateHelper.toDate(endquery, true);

            if (startdate == null || enddate == null)
                return "";
            
            String startstr;
            String endstr;
            String fieldstr;
            if (startquery.length() == 4 && endquery.length() == 4)
            {
                startstr = DateTools.dateToString(startdate, DateTools.Resolution.YEAR);
                endstr   = DateTools.dateToString(enddate, DateTools.Resolution.YEAR);
                fieldstr = field + ".year";
            }
            else
            {
                startstr = DateTools.dateToString(startdate, DateTools.Resolution.DAY);
                endstr   = DateTools.dateToString(enddate, DateTools.Resolution.DAY);
                fieldstr = field;
            }

            String range = "[" + startstr + " TO " + endstr + "]";

            return "("+fieldstr+":"+range+")";
        }
        
    }

    public static class DateHelper
    {
        private static ArrayList<SimpleDateFormat> formats = getDateFormats();
        
        private static String[] getDefaultFormats() {
            return new String[] {
                "yyyy",
                "yyyyMM",
                "yyyy-MM",
                "yyyyMMdd",
                "yyyy MMM",
                "yyyy-MM-dd",
                "yyyy MMM dd",
                "yyyy-MM-dd'T'HH:mm:ss'Z'",
                "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"       
            };
        }
            
        private static ArrayList<SimpleDateFormat> getDateFormats() {
            ArrayList<SimpleDateFormat> formats = new ArrayList<SimpleDateFormat>();
            int i = 1;
            while (true) {
                String format = ConfigurationManager.getProperty("date.format." + i);
                if (format == null)
                    break;
                formats.add(new SimpleDateFormat(format));
                ++i;
            }
            if (formats.isEmpty()) { // nothing in the configuration file, go to default
                for (String format : getDefaultFormats())
                {
                    formats.add(new SimpleDateFormat(format));                    
                }
            }
            
            return formats;
        }
        
        // TODO rounding not implemented
        public static Date toDate(String t, boolean roundup) {
            int bestn = 0;
            Date bestDate = null;
            
            for (SimpleDateFormat df : formats)
            {
                ParsePosition pos = new ParsePosition(0);
                
                // Parse the date
                df.setCalendar(Calendar.getInstance(TimeZone.getTimeZone("UTC")));
                df.setLenient(false);
                Date date = df.parse(t,pos);
                int n = pos.getIndex();
                if (bestn < n)
                {
                    bestn = n;
                    bestDate = date;
                }
            }
            return bestDate;
                        
        }
               
    }
}
