/*
 * DCInputSet.java
 *
 * Version: $Revision: 3734 $
 *
 * Date: $Date: 2009-04-24 00:00:19 -0400 (Fri, 24 Apr 2009) $
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

package org.dspace.app.util;

import java.util.ArrayList;
import java.util.List;
import java.util.Vector;
import java.util.Map;

/**
 * Class representing all DC inputs required for a submission, organized into pages
 *
 * @author Brian S. Hughes, based on work by Jenny Toves, OCLC
 * @version $Revision: 3734 $
 */

public class DCInputSet
{
	/** name of the input set  */
	private String formName = null; 
	/** the inputs ordered by page and row position */
	private Vector<Vector<DCInput>> inputPages = null;
	
	/** constructor */
	public DCInputSet(String formName, Vector<Vector<Map<String,String>>> pages, Map<String,List<String>> listMap)
	{
		this.formName = formName;
		inputPages = new Vector<Vector<DCInput>>();
		for (Vector<Map<String,String>> page : pages)
		{
			Vector<DCInput> inputPage = new Vector<DCInput>();
			inputPages.add(inputPage);
			for (Map<String,String> field : page)
			{
				inputPage.add(new DCInput(field, listMap));
			}
		}
	}
	
	public DCInputSet(String formName)
	{
		this.formName = formName;
		this.inputPages = new Vector<Vector<DCInput>>();
	}
	
	public DCInputSet(DCInputSet o, String formName)
	{
		this.formName = formName;
		inputPages = new Vector<Vector<DCInput>>();
		for (Vector<DCInput> page : o.inputPages)
		{
			Vector<DCInput> inputPage = new Vector<DCInput>();
			inputPages.add(inputPage);
			for (DCInput field : page)
			{
				inputPage.add(new DCInput(field));
			}
		}
	}
	
	public Vector<Vector<Map<String,String>>> toVec()
	{
		Vector<Vector<Map<String,String>>> pages = new Vector<Vector<Map<String,String>>>();
		for (Vector<DCInput> page : inputPages)
		{
			Vector<Map<String,String>> fields = new Vector<Map<String,String>>();
			pages.add(fields);
			for (DCInput field : page)
			{
				Map<String,String> fieldMap = field.toMap();
				fields.add(fieldMap);				
			}
		}
		return pages;
	}
	
	/**
	 * Return the name of the form that defines this input set
	 * @return formName 	the name of the form
	 */
	public String getFormName()
	{
		return formName;
	}
	
	/**
	 * Return the number of pages in this  input set
	 * @return number of pages
	 */
	public int getNumberPages()
	{
		return inputPages.size();
	}
	
    /**
     * Get all the rows for a page from the form definition
     *
     * @param  pageNum	desired page within set
     * @param  addTitleAlternative flag to add the additional title row
     * @param  addPublishedBefore  flag to add the additional published info
     *
     * @return  an array containing the page's displayable rows
     */
	
	public DCInput[] getPageRows(int pageNum, boolean addTitleAlternative,
		      					 boolean addPublishedBefore)
	{
		List<DCInput> filteredInputs = new ArrayList<DCInput>();
		if ( pageNum < inputPages.size() )
		{
			for (DCInput input : inputPages.get(pageNum))
			{
				if (doField(input, addTitleAlternative, addPublishedBefore))
				{
					filteredInputs.add(input);
				}
			}
		}

		// Convert list into an array
		DCInput[] inputArray = new DCInput[filteredInputs.size()];
		return filteredInputs.toArray(inputArray);
	}
	
	public void addPage()
	{
		inputPages.add(new Vector<DCInput>());
	}
	
	public void removePage(int n)
	{
		inputPages.remove(n);
	}
	
	public void movePage(int src, int dest)
	{
		Vector<DCInput> page = inputPages.remove(src);
		inputPages.add(dest, page);
	}
	
	// XXX not sure this is useful
	public void setPage(int n, Vector<DCInput> fields)
	{
		inputPages.set(n, fields);
	}
	
	public int getNumFields(int page)
	{
		return inputPages.get(page).size();
	}
	
	public Vector<DCInput> getFields(int page)
	{
		return inputPages.get(page);
	}
	
	public DCInput getField(int page, int n)
	{
		return inputPages.get(page).get(n);
	}
	
	public void setField(int page, int n, DCInput field)
	{
		inputPages.get(page).set(n, field);
	}

	public void addField(int page, DCInput field)
	{
		inputPages.get(page).add(field);
	}
	
	public DCInput removeField(int page, int n)
	{
		return inputPages.get(page).remove(n);
	}
	
	public void moveField(int page, int src, int dest)
	{
		DCInput field = inputPages.get(page).remove(src);
		inputPages.get(page).add(dest, field);
	}
	
    /**
     * Does this set of inputs include an alternate title field?
     *
     * @return true if the current set has an alternate title field
     */
    public boolean isDefinedMultTitles()
    {
    	return isFieldPresent("title.alternative");
    }
    
    /**
     * Does this set of inputs include the previously published fields?
     *
     * @return true if the current set has all the prev. published fields
     */
    public boolean isDefinedPubBefore()
    {
    	return ( isFieldPresent("date.issued") && 
    			 isFieldPresent("identifier.citation") &&
				 isFieldPresent("publisher.null") );
    }
    
    /**
     * Does the current input set define the named field?
     * Scan through every field in every page of the input set
     *
     * @return true if the current set has the named field
     */
    public boolean isFieldPresent(String fieldName)
    {
    	for (Vector<DCInput> pageInputs : inputPages)
	    {
    		for (DCInput field : pageInputs)
    		{
    			String fullName = field.getElement() + "." + 
				              	  field.getQualifier();
    			if (fullName.equals(fieldName))
    			{
    				return true;
    			}
    		}
	    }
    	return false;
    }
	
    private static boolean doField(DCInput dcf, boolean addTitleAlternative, 
		    					   boolean addPublishedBefore)
    {
    	String rowName = dcf.getElement() + "." + dcf.getQualifier();
    	if ( rowName.equals("title.alternative") && ! addTitleAlternative )
    	{
    		return false;
    	}
    	if (rowName.equals("date.issued") && ! addPublishedBefore )
    	{
    		return false;
    	}
    	if (rowName.equals("publisher.null") && ! addPublishedBefore )
    	{
    		return false;
    	}
    	if (rowName.equals("identifier.citation") && ! addPublishedBefore )
    	{
    		return false;
    	}

    	return true;
    }
}
