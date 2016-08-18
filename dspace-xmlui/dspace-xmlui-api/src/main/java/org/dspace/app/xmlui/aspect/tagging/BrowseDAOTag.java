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
package org.dspace.app.xmlui.aspect.tagging;

import static org.dspace.app.xmlui.aspect.artifactbrowser.BrowseUtils.getIntParameter;

import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import org.dspace.browse.BrowseDAOPostgres;
import org.dspace.browse.BrowseException;
import org.dspace.core.Context;
import org.dspace.core.LogManager;
import org.dspace.eperson.EPerson;
import org.dspace.storage.rdbms.DatabaseManager;
import org.dspace.storage.rdbms.TableRow;
import org.dspace.storage.rdbms.TableRowIterator;

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
public class BrowseDAOTag extends BrowseDAOPostgres
{
    final static String EPERSON = "eperson";
	
	protected int eperson = -1;

    public BrowseDAOTag(Context context) throws BrowseException
    {
    	super(context);
    }

    /* (non-Javadoc)
	 * @see org.dspace.browse.BrowseDAO#doDistinctOffsetQuery(java.lang.String, java.lang.String, java.lang.String)
	 */
	public int doDistinctOffsetQuery(String column, String value, boolean isAscending)
	throws BrowseException
	{
		TableRowIterator tri = null;

		try
		{
			List paramsList = new ArrayList();
			StringBuffer queryBuf = new StringBuffer();

			column = "tag_name";
			
			queryBuf.append("COUNT(DISTINCT ").append(column).append(") AS offset ");

			buildSelectStatementDistinct(queryBuf, paramsList);
			if (isAscending)
			{
				queryBuf.append(" WHERE ").append(column).append("<?");
				paramsList.add(value);
			}
			else
			{
				queryBuf.append(" WHERE ").append(column).append(">?");
				paramsList.add(value + Character.MAX_VALUE);
			}

			if (containerTable != null && tableMap != null)
			{
				queryBuf.append(" AND ").append("mappings.item_id=");
				queryBuf.append(table).append(".item_id");
			}

			tri = DatabaseManager.query(context, queryBuf.toString(), paramsList.toArray());

			TableRow row;
			if (tri.hasNext())
			{
				row = tri.next();
				return (int)row.getLongColumn("offset");
			}
			else
			{
				return 0;
			}
		}
		catch (SQLException e)
		{
			throw new BrowseException(e);
		}
		finally
		{
			if (tri != null)
			{
				tri.close();
			}
		}
	}

	/* (non-Javadoc)
	 * @see org.dspace.browse.BrowseDAO#doValueQuery()
	 */
	public List doValueQuery()
	throws BrowseException
	{
		String query = getQuery();
		Object[] params = getQueryParams();
		log.debug(LogManager.getHeader(context, "executing_value_query", "query=" + query));

		TableRowIterator tri = null;

		try
		{
			// now run the query
			tri = DatabaseManager.query(context, query, params);

			// go over the query results and process
			List results = new ArrayList();
			while (tri.hasNext())
			{
				TableRow row = tri.next();
				String valueResult = row.getStringColumn("tag_name");
				results.add(new String[]{valueResult,null});
			}

			return results;
		}
		catch (SQLException e)
		{
			log.error("caught exception: ", e);
			throw new BrowseException(e);
		}
		finally
		{
			if (tri != null)
			{
				tri.close();
			}
		}
	}

	/* (non-Javadoc)
	 * @see org.dspace.browse.BrowseDAO#setFocusField(java.lang.String)
	 */
	public void setJumpToField(String focusField)
	{
		this.focusField = "sort_value".equals(focusField)? "tag_name" : focusField; // XXX foo
		this.rebuildQuery = true;
	}

	/* (non-Javadoc)
	 * @see org.dspace.browse.BrowseDAO#setOrderField(java.lang.String)
	 */
	public void setOrderField(String orderField)
	{
		this.orderField = "sort_value".equals(orderField)? "tag_name" : orderField; // XXX foo
		this.rebuildQuery = true;
	}

	/* (non-Javadoc)
	 * @see org.dspace.browse.BrowseDAO#setValueField(java.lang.String)
	 */
	public void setFilterValueField(String valueField)
	{
		//this.valueField = valueField;
		this.valueField = "tag_name";
		this.rebuildQuery = true;
	}

	/**
	 * Build the clauses required for the view used in focused or scoped queries.
	 *
	 * @param queryBuf
	 * @param params
	 */
	protected void buildFocusedSelectClauses(StringBuffer queryBuf, List params)
	{
		if (tableMap != null && tableDis != null)
		{
			if (!tableMap.equals(tableDis)) // XXX foo
			{
				queryBuf.append(tableMap).append(".distinct_id=").append(tableDis).append(".distinct_id");
				queryBuf.append(" AND ");
			}
			
			if (eperson != -1)
			{
				queryBuf.append(tableMap).append(".eperson_id=?");
				queryBuf.append(" AND ");
				params.add(eperson);
			}
			
			queryBuf.append(tableDis).append(".").append(valueField);

			if (valuePartial)
			{
				queryBuf.append(" LIKE ? ");

				if (valueField.startsWith("sort_"))
				{
					params.add("%" + utils.truncateSortValue(value) + "%");
				}
				else
				{
					params.add("%" + utils.truncateValue(value) + "%");
				}
			}
			else
			{
				queryBuf.append("=? ");

				if (valueField.startsWith("sort_"))
				{
					params.add(utils.truncateSortValue(value));
				}
				else
				{
					params.add(utils.truncateValue(value));
				}
			}
		}

		if (containerTable != null && containerIDField != null && containerID != -1)
		{
			if (tableMap != null)
			{
				if (tableDis != null)
					queryBuf.append(" AND ");

				queryBuf.append(tableMap).append(".item_id=")
				.append(containerTable).append(".item_id AND ");
			}

			queryBuf.append(containerTable).append(".").append(containerIDField);
            if (excludeContainer)
            {
            	queryBuf.append("!=? ");            	
            }
            else
            {
            	queryBuf.append("=? ");
            }

			params.add(new Integer(containerID));
		}
	}

	/**
	 * Build the table list for the view used in focused or scoped queries.
	 *
	 * @param queryBuf
	 */
	protected void buildFocusedSelectTables(StringBuffer queryBuf)
	{
		if (containerTable != null)
		{
			queryBuf.append(containerTable);
		}

		if (tableMap != null)
		{
			if (containerTable != null)
				queryBuf.append(", ");

			queryBuf.append(tableMap);

			if (tableDis != null && !tableDis.equals(tableMap)) // XXX foo
				queryBuf.append(", ").append(tableDis);
		}
	}

	/**
	 * Build a clause for counting results.  Will return something of the form:
	 *
	 * <code>
	 * COUNT( [value 1], [value 2] ) AS number
	 * </code>
	 *
	 * @return  the count clause
	 */
	protected boolean buildSelectListCount(StringBuffer queryBuf)
	{
		if (countValues != null && countValues.length > 0)
		{
			queryBuf.append(" COUNT(");
			if (isDistinct()) // XXX first level
			{
				queryBuf.append("DISTINCT tag_name");
			}
			else {
				if ("*".equals(countValues[0]))
				{
					queryBuf.append(countValues[0]);
				}
				else
				{
					queryBuf.append(table).append(".").append(countValues[0]);
				}

				for (int i = 1; i < countValues.length; i++)
				{
					queryBuf.append(", ");
					if ("*".equals(countValues[i]))
					{
						queryBuf.append(countValues[i]);
					}
					else
					{
						queryBuf.append(table).append(".").append(countValues[i]);
					}
				}
			}

			queryBuf.append(") AS num");
			return true;
		}

		return false;
	}

	/**
	 * Prepare the list of values to be selected on.  Will return something of the form:
	 *
	 * <code>
	 * [value 1], [value 2]
	 * </code>
	 *
	 * @return  the select value list
	 */
	protected boolean buildSelectListValues(StringBuffer queryBuf)
	{
		if (isDistinct())
		{
			queryBuf.append(table).append(".").append("tag_name");
			return true;
		}
		else
		{
			if (selectValues != null && selectValues.length > 0)
			{
				queryBuf.append(table).append(".").append(selectValues[0]);
				for (int i = 1; i < selectValues.length; i++)
				{
					queryBuf.append(", ");
					queryBuf.append(table).append(".").append(selectValues[i]);
				}
	
				return true;
			}
		}

		return false;
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
			queryBuf.append(", (SELECT DISTINCT ");
			queryBuf.append(containerTable != null ? containerTable : tableMap).append(".item_id");
			queryBuf.append(" FROM ");
			buildFocusedSelectTables(queryBuf);
			queryBuf.append(" WHERE ");
			buildFocusedSelectClauses(queryBuf, params);
			queryBuf.append(") mappings");
		}
		queryBuf.append(" ");
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
	protected void buildSelectStatementDistinct(StringBuffer queryBuf, List params) throws BrowseException
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
		if (isDistinct())
		{
			queryBuf.insert(0, "SELECT DISTINCT ");
		}
		else {
			queryBuf.insert(0, "SELECT ");
		}
		
		// Then append the table
		queryBuf.append(" FROM ");
		queryBuf.append(table);
		if (containerTable != null && tableMap != null)
		{
			queryBuf.append(", (SELECT DISTINCT ").append(tableMap).append(".item_id ");
			queryBuf.append(" FROM ");
			buildFocusedSelectTables(queryBuf);
			queryBuf.append(" WHERE ");
			buildFocusedSelectClauses(queryBuf, params);
			queryBuf.append(") mappings");
		}
		queryBuf.append(" ");
	}

	/**
	 * Get a sub-query to obtain the ids for a distinct browse within a given
	 * constraint.  This will produce something of the form:
	 *
	 * <code>
	 * id IN (SELECT distinct_id FROM [container table] WHERE [container field] = [container id])
	 * </code>
	 *
	 * This is for use inside the overall WHERE clause only
	 *
	 * @return  the sub-query
	 */
	protected void buildWhereClauseDistinctConstraints(StringBuffer queryBuf, List params)
	{
		// add the constraint to community or collection if necessary
		// and desired
		if (containerIDField != null && containerID != -1 && containerTable != null)
		{
			buildWhereClauseOpInsert(queryBuf);
			queryBuf.append(" ").append(table).append(".item_id=mappings.item_id ");
		}
	}

	public void setParameters(Map<String, String> params) {
        int reqpersonid = getIntParameter(params, BrowseDAOTag.EPERSON);
        EPerson curEPerson = context.getCurrentUser();
        eperson = (curEPerson != null)? curEPerson.getID() : -1;
        
        // security check (for now requested epersonid must match current epersonid
        if (eperson != reqpersonid)
        {
        	eperson = -1;
        }
	}	
	
}
