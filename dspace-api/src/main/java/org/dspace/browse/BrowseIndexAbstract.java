/*
 * BrowseIndex.java
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
package org.dspace.browse;

import java.io.IOException;
import java.util.ArrayList;
import java.util.StringTokenizer;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import org.dspace.core.ConfigurationManager;
import org.dspace.core.Context;
import org.dspace.sort.SortException;

/**
 * This class holds all the information about a specifically configured 
 * BrowseIndex.  It is responsible for parsing the configuration, understanding
 * about what sort options are available, and what the names of the database
 * tables that hold all the information are actually called.
 * 
 * @author Richard Jones
 */
public abstract class BrowseIndexAbstract extends BrowseIndexBase
{
	BrowseIndexAbstract(int number, String name, String displayType, String defaultOrder, String tableBaseName)
    {
		super(number,name,displayType,defaultOrder,tableBaseName);
    }
    
    /**
	 * @return Returns the datatype.
	 */
	public abstract String getDataType();
	
	/**
	 * Get the name of the sequence that will be used in the given circumnstances
	 * 
	 * @param isDistinct	is a distinct table
	 * @param isMap			is a map table
	 * @return				the name of the sequence
	 */
    public String getSequenceName(boolean isDistinct, boolean isMap)
    {
        if (isDistinct || isMap)
            return getSequenceName(number, isDistinct, isMap);
        
        return getSequenceName(tableBaseName, isDistinct, isMap);
    }
    
    /**
     * Get the name of the sequence that will be used in the given circumstances
     * 
     * @param number		the index configuration number
     * @param isDistinct	is a distinct table
     * @param isMap			is a map table
     * @return				the name of the sequence
     */
    public static String getSequenceName(int number, boolean isDistinct, boolean isMap)
    {
        return getSequenceName(makeTableBaseName(number), isDistinct, isMap);
    }
    
    /**
     * Generate a sequence name from the given base
     * @param baseName
     * @param isDistinct
     * @param isMap
     * @return
     */
    private static String getSequenceName(String baseName, boolean isDistinct, boolean isMap)
    {
        if (isDistinct)
        {
            baseName = baseName + "_dis";
        }
        else if (isMap)
        {
            baseName = baseName + "_dmap";
        }
        
        baseName = baseName + "_seq";
        
        return baseName;
    }
    
    /**
     * Get the name of the table for the given set of circumstances
     * This is provided solely for cleaning the database, where you are
     * trying to create table names that may not be reflected in the current index
     * 
     * @param number		the index configuration number
     * @param isCommunity	whether this is a community constrained index (view)
     * @param isCollection	whether this is a collection constrainted index (view)
     * @param isDistinct	whether this is a distinct table
     * @param isMap			whether this is a distinct map table
     * @return				the name of the table
     * @deprecated 1.5
     */
    public static String getTableName(int number, boolean isCommunity, boolean isCollection, boolean isDistinct, boolean isMap)
    {
        return getTableName(makeTableBaseName(number), isCommunity, isCollection, isDistinct, isMap);
    }
    
    /**
     * Generate a table name from the given base
     * @param baseName
     * @param isCommunity
     * @param isCollection
     * @param isDistinct
     * @param isMap
     * @return
     */
    private static String getTableName(String baseName, boolean isCommunity, boolean isCollection, boolean isDistinct, boolean isMap)
    {
    	// isDistinct is meaningless in relation to isCommunity and isCollection
    	// so we bounce that back first, ignoring other arguments
    	if (isDistinct)
    	{
    		return baseName + "_dis";
    	}
    	
    	// isCommunity and isCollection are mutually exclusive
    	if (isCommunity)
    	{
    		baseName = baseName + "_com"; 
    	}
    	else if (isCollection)
    	{
    		baseName = baseName + "_col";
    	}
    	
    	// isMap is additive to isCommunity and isCollection
    	if (isMap)
    	{
    		baseName = baseName + "_dmap";
    	}
    	
    	return baseName;
    }
    
    /**
     * Get the name of the table in the given circumstances
     * 
     * @param isCommunity	whether this is a community constrained index (view)
     * @param isCollection	whether this is a collection constrainted index (view)
     * @param isDistinct	whether this is a distinct table
     * @param isMap			whether this is a distinct map table
     * @return				the name of the table
     * @deprecated 1.5
     */
    public String getTableName(boolean isCommunity, boolean isCollection, boolean isDistinct, boolean isMap)
    {
        if (isDistinct || isMap)
            return getTableName(number, isCommunity, isCollection, isDistinct, isMap);
        
        return getTableName(tableBaseName, isCommunity, isCollection, isDistinct, isMap);
    }
    
    /**
     * Get the name of the table in the given circumstances.  This is the same as calling
     * 
     * <code>
     * getTableName(isCommunity, isCollection, false, false);
     * </code>
     * 
     * @param isCommunity	whether this is a community constrained index (view)
     * @param isCollection	whether this is a collection constrainted index (view)
     * @return				the name of the table
     * @deprecated 1.5
     */
    public String getTableName(boolean isCommunity, boolean isCollection)
    {
        return getTableName(isCommunity, isCollection, false, false);
    }
    
    /**
     * Get the default index table name.  This is the same as calling
     * 
     * <code>
     * getTableName(false, false, false, false);
     * </code>
     * 
     * @return
     */
    public String getTableName()
    {
        return getTableName(false, false, false, false);
    }
    
    /**
     * Get the table name for the given set of circumstances
     * 
     * This is the same as calling:
     * 
     * <code>
     * getTableName(isCommunity, isCollection, isDistinct, false);
     * </code>
     * 
     * @param isDistinct	is this a distinct table
     * @param isCommunity
     * @param isCollection
     * @return
     * @deprecated 1.5
     */
    public String getTableName(boolean isDistinct, boolean isCommunity, boolean isCollection)
    {
    	return getTableName(isCommunity, isCollection, isDistinct, false);
    }
    
    /**
     * Get the default name of the distinct map table.  This is the same as calling
     * 
     * <code>
     * getTableName(false, false, false, true);
     * </code>
     * 
     * @return
     */
    public String getMapTableName()
    {
    	return getTableName(false, false, false, true);
    }
    
    /**
     * Get the default name of the distinct table.  This is the same as calling
     *
     * <code>
     * getTableName(false, false, true, false);
     * </code>
     *
     * @return
     */
    public String getDistinctTableName()
    {
    	return getTableName(false, false, true, false);
    }

    /**
     * Get the name of the colum that is used to store the default value column
     * 
     * @return	the name of the value column
     */
    public String getValueColumn()
    {
        if (!isDate())
        {
            return "sort_text_value";
        }
        else
        {
            return "text_value";
        }
    }
    
    /**
     * Get the name of the primary key index column
     * 
     * @return	the name of the primary key index column
     */
    public String getIndexColumn()
    {
        return "id";
    }
    
    /**
     * Is this browse index type for a title?
     * 
     * @return	true if title type, false if not
     */
//    public boolean isTitle()
//    {
//        return "title".equals(getDataType());
//    }
    
    /**
     * Is the browse index type for a plain text type?
     * 
     * @return	true if plain text type, false if not
     */
//    public boolean isText()
//    {
//        return "text".equals(getDataType());
//    }
    
    /**
     * Get the field for sorting associated with this index
     * @return
     * @throws BrowseException
     */
    public abstract String getSortField(boolean isSecondLevel) throws BrowseException;

    /**
     * Take a string representation of a metadata field, and return it as an array.
     * This is just a convenient utility method to basically break the metadata 
     * representation up by its delimiter (.), and stick it in an array, inserting
     * the value of the init parameter when there is no metadata field part.
     * 
     * @param mfield	the string representation of the metadata
     * @param init	the default value of the array elements
     * @return	a three element array with schema, element and qualifier respectively
     */
    public String[] interpretField(String mfield, String init)
    	throws IOException
    {
    	StringTokenizer sta = new StringTokenizer(mfield, ".");
    	String[] field = {init, init, init};
    	
    	int i = 0;
    	while (sta.hasMoreTokens())
    	{
    		field[i++] = sta.nextToken();
    	}
    	
    	// error checks to make sure we have at least a schema and qualifier for both
    	if (field[0] == null || field[1] == null)
    	{
    		throw new IOException("at least a schema and element be " +
    				"specified in configuration.  You supplied: " + mfield);
    	}
    	
    	return field;
    }


    /**
     * Generate a base table name
     * @param number
     * @return
     */
    private static String makeTableBaseName(int number)
    {
        return "bi_" + Integer.toString(number);
    }

	public BrowseDAO getBrowseDAO(Context context, String db) throws BrowseException
	{
		if ("postgres".equals(db))
		{
			return new BrowseDAOPostgres(context);
		}
		else if ("oracle".equals(db))
		{
            return new BrowseDAOOracle(context);
		}
		else
		{
			throw new BrowseException("The configuration for db.name is either invalid, or contains an unrecognised database");
		}
	}

	public boolean isHidden()
	{
		return false;
	}
	
}
