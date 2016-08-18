/*
 * BrowseDAOPostgres.java
 *
 * Version: $Revision: 4365 $
 *
 * Date: $Date: 2009-10-05 19:52:42 -0400 (Mon, 05 Oct 2009) $
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
package org.dspace.app.xmlui.aspect.lists;

import static org.dspace.app.xmlui.aspect.artifactbrowser.BrowseUtils.getIntParameter;

import java.util.List;
import java.util.Map;

import org.dspace.browse.BrowseDAOPostgres;
import org.dspace.browse.BrowseException;
import org.dspace.core.Context;

/**
 * This class is the PostgreSQL driver class for reading information from the
 * Browse tables.  It implements the BrowseDAO interface, and also has a
 * constructor of the form:
 *
 * BrowseDAOPostgres(Context context)
 *
 * As required by BrowseDAOFactory.  This class should only ever be loaded by
 * that Factory object.
 *
 * @author Richard Jones
 * @author Graham Triggs
 */
public class BrowseDAOList extends BrowseDAOPostgres
{
    public BrowseDAOList(Context context) throws BrowseException
    {
    	super(context);
    }


    /**
     * Get the clause to perform search result ordering.  This will
     * return something of the form:
     *
     * <code>
     * ORDER BY [order field] (ASC | DESC)
     * </code>
     *
     * @return  the ORDER BY clause
     */
    protected void buildOrderBy(StringBuffer queryBuf)
    {
        if (orderField != null)
        {
            queryBuf.append(" ORDER BY ");
            //queryBuf.append(orderField);
            queryBuf.append("mappings.ordernum"); // XXX
            if (isAscending())
            {
                queryBuf.append(" ASC ");
            }
            else
            {
                queryBuf.append(" DESC ");
            }
        }
    }


    /**
     * Prepare the select clause using the pre-prepared arguments.  This will produce something
     * of the form:
     *
     * <code>
     * SELECT [arguments] FROM [table]
     * </code>
     *
     * @param queryBuf  the string value obtained from distinctClause, countClause or selectValues
     * @return  the SELECT part of the query
     */
    protected void buildSelectStatement(StringBuffer queryBuf, List params) throws BrowseException
    {
        if (queryBuf.length() == 0)
        {
            throw new BrowseException("No arguments for SELECT statement");
        }

        if (table == null || "".equals(table))
        {
            throw new BrowseException("No table for SELECT statement");
        }

        // queryBuf already contains what we are selecting,
        // so insert the statement at the beginning
        queryBuf.insert(0, "SELECT ");

        // Then append the table
        queryBuf.append(" FROM ");
        queryBuf.append(table);
        if (containerTable != null || (value != null && valueField != null && tableDis != null && tableMap != null))
        {
            queryBuf.append(", (SELECT " + (containerTable != null ? "" : "DISTINCT "));
            //queryBuf.append(containerTable != null ? containerTable : tableMap).append(".item_id");
            queryBuf.append(containerTable != null ? containerTable : tableMap).append(".*");
            queryBuf.append(" FROM ");
            buildFocusedSelectTables(queryBuf);
            queryBuf.append(" WHERE ");
            buildFocusedSelectClauses(queryBuf, params);
            queryBuf.append(") mappings");
        }
        queryBuf.append(" ");
    }

	public void setParameters(Map<String, String> params) {
        int list_id = getIntParameter(params, "list_id");

        containerTable = "list_entries";
        containerIDField = "list_id";
        containerID = list_id;
        
        tableDis = "list_entries"; // XXX just to fool it into doing stuff
        
        // XXX do security check ???
	}	
	
}
