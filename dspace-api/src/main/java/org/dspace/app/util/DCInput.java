/*
 * DCInput.java
 *
 * Version: $Revision: 3823 $
 *
 * Date: $Date: 2009-05-19 14:09:05 -0400 (Tue, 19 May 2009) $
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

import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.Vector;

import org.dspace.content.MetadataSchema;

/**
 * Class representing a line in an input form.
 * 
 * @author Brian S. Hughes, based on work by Jenny Toves, OCLC
 * @version
 */
public class DCInput
{
    /** the DC element name */
    private String dcElement = null;

    /** the DC qualifier, if any */
    private String dcQualifier = null;

    /** the DC namespace schema */
    private String dcSchema = null;

    /** a label describing input */
    private String label = null;

    /** the input type */
    private String inputType = null;

    /** is input required? */
    private boolean required = false;

    /** if required, text to display when missing */
    private String warning = null;

    /** is input repeatable? */
    private boolean repeatable = false;

    /** 'hint' text to display */
    private String hint = null;

    /** if input list-controlled, name of list */
    private String valueListName = null;

    /** if input list-controlled, the list itself */
    private List<String> valueList = null;

    /** if non-null, visibility scope restriction */
    private String visibility = null;
    
    /** if non-null, readonly out of the visibility scope */
    private String readOnly = null;

    /** the name of the controlled vocabulary to use */
    private String vocabulary = null;

    /** is the entry closed to vocabulary terms? */
    private boolean closedVocabulary = false;

    /** 
     * The scope of the input sets, this restricts hidden metadata fields from 
     * view during workflow processing. 
     */
    public static String WORKFLOW_SCOPE = "workflow";

    /** 
     * The scope of the input sets, this restricts hidden metadata fields from 
     * view by the end user during submission. 
     */
    public static String SUBMISSION_SCOPE = "submit";
    
    /**
     * Class constructor for creating a DCInput object based on the contents of
     * a HashMap
     * 
     * @param row
     *            the corresponding row in the table
     */
    public DCInput(Map<String,String> fieldMap, Map<String,List<String>> listMap)
    {
        dcElement = fieldMap.get("dc-element");
        dcQualifier = fieldMap.get("dc-qualifier");

        // Default the schema to dublin core
        dcSchema = fieldMap.get("dc-schema");
        if (dcSchema == null)
        {
            dcSchema = MetadataSchema.DC_SCHEMA;
        }

        String repStr = fieldMap.get("repeatable");
        repeatable = "true".equalsIgnoreCase(repStr)
                || "yes".equalsIgnoreCase(repStr);
        label = fieldMap.get("label");
        inputType = fieldMap.get("input-type");
        // these types are list-controlled
        if ("dropdown".equals(inputType) || "qualdrop_value".equals(inputType)
                || "list".equals(inputType))
        {
            valueListName = fieldMap.get("value-pairs-name");
            valueList = listMap.get(valueListName);
        }
        hint = fieldMap.get("hint");
        warning = fieldMap.get("required");
        required = (warning != null && warning.length() > 0);
        visibility = fieldMap.get("visibility");
        readOnly = fieldMap.get("readonly");
        vocabulary = fieldMap.get("vocabulary");
        String closedVocabularyStr = fieldMap.get("closedVocabulary");
        closedVocabulary = "true".equalsIgnoreCase(closedVocabularyStr)
                            || "yes".equalsIgnoreCase(closedVocabularyStr);
    }

    public DCInput(DCInput o)
    {
    	dcElement = o.dcElement;
    	dcQualifier = o.dcQualifier;
    	dcSchema = o.dcSchema;
    	repeatable = o.repeatable;
    	label = o.label;
    	inputType = o.inputType;
    	valueListName = o.valueListName;
    	valueList = (o.valueList != null)? new Vector<String>(o.valueList) : null;
    	hint = o.hint;
    	warning = o.warning;
    	visibility = o.visibility;
    	readOnly = o.readOnly;
    	vocabulary = o.vocabulary;
    	closedVocabulary = o.closedVocabulary;
    }
    
    public Map<String,String> toMap()
    {
    	Map<String,String> fieldMap = new LinkedHashMap<String,String>();
    	fieldMap.put("dc-element", dcElement);
    	if (dcQualifier != null) fieldMap.put("dc-qualifier", dcQualifier);
    	if (dcSchema != null) fieldMap.put("dc-schema", dcSchema);
    	if (repeatable) fieldMap.put("repeatable", "yes");
    	fieldMap.put("label", label);
    	fieldMap.put("input-type", inputType);
    	if (valueListName != null) fieldMap.put("value-pairs-name", valueListName); //??? consistency constraint
    	if (hint != null) fieldMap.put("hint", hint);
    	if (warning != null) fieldMap.put("required", warning);
    	if (visibility != null) fieldMap.put("visibility", visibility);
    	if (readOnly != null) fieldMap.put("readonly", readOnly);
    	if (vocabulary != null) fieldMap.put("vocabulary", vocabulary);
    	if (closedVocabulary) fieldMap.put("closedVocabulary", "yes");
    	return fieldMap;
    }
    
    public String getName()
    {
    	String schema = getSchema();
    	String element = getElement();
    	String qualifier = getQualifier();
    	return ((schema != null)? (schema + ".") : "") +
    	       element +
    	       ((qualifier != null)? ("." + qualifier) : "");    	
    }
    
    /**
     * Is this DCInput for display in the given scope? The scope should be
     * either "workflow" or "submit", as per the input forms definition. If the
     * internal visibility is set to "null" then this will always return true.
     * 
     * @param scope
     *            String identifying the scope that this input's visibility
     *            should be tested for
     * 
     * @return whether the input should be displayed or not
     */
    public boolean isVisible(String scope)
    {
        return (visibility == null || visibility.equals(scope));
    }
    
    /**
     * Is this DCInput for display in readonly mode in the given scope? 
     * If the scope differ from which in visibility field then we use the out attribute
     * of the visibility element. Possible values are: hidden (default) and readonly.
     * If the DCInput is visible in the scope then this methods must return false
     * 
     * @param scope
     *            String identifying the scope that this input's readonly visibility
     *            should be tested for
     * 
     * @return whether the input should be displayed in a readonly way or fully hidden
     */
    public boolean isReadOnly(String scope)
    {
        if (isVisible(scope))
        {
            return false;
        }
        else
        {
            return readOnly != null && readOnly.equalsIgnoreCase("readonly");
        }
    }

    public boolean isMarkedReadOnly()
    {
    	return readOnly != null && readOnly.equalsIgnoreCase("readonly");
    }

    /**
     * Get the repeatable flag for this row
     * 
     * @return the repeatable flag
     */
    public boolean isRepeatable()
    {
        return repeatable;
    }

    /**
     * Alternate way of calling isRepeatable()
     * 
     * @return the repeatable flag
     */
    public boolean getRepeatable()
    {
        return isRepeatable();
    }

    /**
     * Get the input type for this row
     * 
     * @return the input type
     */
    public String getInputType()
    {
        return inputType;
    }

    /**
     * Get the DC element for this form row.
     * 
     * @return the DC element
     */
    public String getElement()
    {
        return dcElement;
    }

    /**
     * Get the DC namespace prefix for this form row.
     * 
     * @return the DC namespace prefix
     */
    public String getSchema()
    {
        return dcSchema;
    }

    /**
     * Get the warning string for a missing required field, formatted for an
     * HTML table.
     * 
     * @return the string prompt if required field was ignored
     */
    public String getWarning()
    {
        return warning;
    }

    /**
     * Is there a required string for this form row?
     * 
     * @return true if a required string is set
     */
    public boolean isRequired()
    {
        return required;
    }

    /**
     * Get the DC qualifier for this form row.
     * 
     * @return the DC qualifier
     */
    public String getQualifier()
    {
        return dcQualifier;
    }

    /**
     * Get the hint for this form row, formatted for an HTML table
     * 
     * @return the hints
     */
    public String getHints()
    {
        return hint;
    }

    /**
     * Get the label for this form row.
     * 
     * @return the label
     */
    public String getLabel()
    {
        return label;
    }

    /**
     * Get the name of the pairs type
     * 
     * @return the pairs type name
     */
    public String getPairsType()
    {
        return valueListName;
    }

    /**
     * Get the name of the pairs type
     * 
     * @return the pairs type name
     */
    public List<String> getPairs()
    {
        return valueList;
    }

    /**
     * Get the name of the controlled vocabulary that is associated with this
     * field
     * 
     * @return the name of associated the vocabulary
     */
    public String getVocabulary()
    {
        return vocabulary;
    }

    /**
     * Set the name of the controlled vocabulary that is associated with this
     * field
     * 
     * @param vocabulary
     *            the name of the vocabulary
     */
    public void setVocabulary(String vocabulary)
    {
        this.vocabulary = vocabulary;
    }

    /**
     * Gets the display string that corresponds to the passed storage string in
     * a particular display-storage pair set.
     * 
     * @param allPairs
     *            HashMap of all display-storage pair sets
     * @param pairTypeName
     *            Name of display-storage pair set to search
     * @param storageString
     *            the string that gets stored
     * 
     * @return the displayed string whose selection causes storageString to be
     *         stored, null if no match
     */
    public String getDisplayString(String pairTypeName, String storedString)
    {
        if (valueList != null)
        {
            for (int i = 0; i < valueList.size(); i += 2)
            {
                if ((valueList.get(i + 1)).equals(storedString))
                {
                    return valueList.get(i);
                }
            }
        }
        return null;
    }

    /**
     * Gets the stored string that corresponds to the passed display string in a
     * particular display-storage pair set.
     * 
     * @param allPairs
     *            HashMap of all display-storage pair sets
     * @param pairTypeName
     *            Name of display-storage pair set to search
     * @param displayString
     *            the string that gets displayed
     * 
     * @return the string that gets stored when displayString gets selected,
     *         null if no match
     */
    public String getStoredString(String pairTypeName, String displayedString)
    {
        if (valueList != null)
        {
            for (int i = 0; i < valueList.size(); i += 2)
            {
                if ((valueList.get(i)).equals(displayedString))
                {
                    return valueList.get(i + 1);
                }
            }
        }
        return null;
    }

	/**
	 * The closed attribute of the vocabulary tag for this field as set in 
	 * input-forms.xml
	 * 
	 * <code> 
	 * <field>
	 *     .....
	 *     <vocabulary closed="true">nsrc</vocabulary>
	 * </field>
	 * </code>
	 * @return the closedVocabulary flags: true if the entry should be restricted 
	 *         only to vocabulary terms, false otherwise
	 */
	public boolean isClosedVocabulary() {
		return closedVocabulary;
	}

	public static boolean requiresValues(String inputType)
	{
		return (("dropdown".equals(inputType) || "qualdrop_value".equals(inputType)
            || "list".equals(inputType)));
	}
	
}
