/*
 * DCInputsReader.java
 *
 * Version: $Revision: 4365 $
 *
 * Date: $Date: 2009-10-05 19:52:42 -0400 (Mon, 05 Oct 2009) $
 *
 * Copyright (c) 2002-2005, Hewlett-Packard Company and Massachusetts
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

package org.dspace.app.util;

import java.io.File;
import java.util.HashMap;
import java.util.Iterator;
import java.util.LinkedHashMap;
import java.util.LinkedHashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.Vector;

import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.parsers.FactoryConfigurationError;
import javax.xml.transform.OutputKeys;
import javax.xml.transform.Transformer;
import javax.xml.transform.TransformerFactory;
import javax.xml.transform.dom.DOMSource;
import javax.xml.transform.stream.StreamResult;

import org.apache.log4j.Logger;
import org.dspace.content.MetadataSchema;
import org.dspace.core.ConfigurationManager;
import org.w3c.dom.DOMImplementation;
import org.w3c.dom.Document;
import org.w3c.dom.DocumentType;
import org.w3c.dom.Element;
import org.w3c.dom.NamedNodeMap;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;
import org.w3c.dom.bootstrap.DOMImplementationRegistry;
import org.xml.sax.SAXException;

/**
 * Submission form generator for DSpace. Reads and parses the installation
 * form definitions file, input-forms.xml, from the configuration directory.
 * A forms definition details the page and field layout of the metadata
 * collection pages used by the submission process. Each forms definition
 * starts with a unique name that gets associated with that form set.
 *
 * The file also specifies which collections use which form sets. At a
 * minimum, the definitions file must define a default mapping from the
 * placeholder collection #0 to the distinguished form 'default'. Any
 * collections that use a custom form set are listed paired with the name
 * of the form set they use.
 *
 * The definitions file also may contain sets of value pairs. Each value pair
 * will contain one string that the user reads, and a paired string that will
 * supply the value stored in the database if its sibling display value gets
 * selected from a choice list.
 *
 * @author  Brian S. Hughes
 * @version $Revision: 4365 $
 */

public class DCInputsReader
{
    /**
     * The ID of the default collection. Will never be the ID of a named
     * collection
     */
    public static final String DEFAULT_COLLECTION = "default";

    /** Name of the form definition XML file  */
    static final String FORM_DEF_FILE = "input-forms.xml";

    /** Keyname for storing dropdown value-pair set name */
    public static final String PAIR_TYPE_NAME = "value-pairs-name";

    /** log4j logger */
    private static Logger log = Logger.getLogger(DCInputsReader.class);

    /** The fully qualified pathname of the form definition XML file */
    private String defsFile = ConfigurationManager.getProperty("dspace.dir")
            + File.separator + "config" + File.separator + FORM_DEF_FILE;

    /**
     * Reference to the collections to forms map, computed from the forms
     * definition file
     */
    private HashMap<String,String> whichForms = null;

    /**
     * Reference to the forms definitions map, computed from the forms
     * definition file
     */
    private HashMap<String,Vector<Vector<Map<String,String>>>> formDefns  = null;

    /**
     * Reference to the forms which allow, disallow or mandate files to be
     * uploaded.
     */
    private HashMap formFileUploadDefns = null;

    /**
     * Reference to the value-pairs map, computed from the forms defition file
     */
    private HashMap<String,List<String>> valuePairs = null;    // Holds display/storage pairs
    
    // removed cache due to synchronization issues

    private DCInputsReaderException exceptionState = null;
    
    /**
     * Parse an XML encoded submission forms template file, and create a hashmap
     * containing all the form information. This hashmap will contain three top
     * level structures: a map between collections and forms, the definition for
     * each page of each form, and lists of pairs of values that populate
     * selection boxes.
     */

    private DCInputsReader()
    {
        buildInputs(defsFile);
    }

    // NB a little tricky because the constructor of the shared instance can potentially 
    // throw exceptions and we want to relay that back to the potential clients of this class somehow
    private static final DCInputsReader INSTANCE = new DCInputsReader();
    
    public static DCInputsReader getInstance() throws DCInputsReaderException
    {
    	if (INSTANCE.exceptionState != null)
    		throw INSTANCE.exceptionState;
    	return INSTANCE;
    }

    private void buildInputs(String fileName)
    {
    	try {
	        whichForms = new LinkedHashMap<String,String>();
	        formDefns  = new LinkedHashMap<String,Vector<Vector<Map<String,String>>>>();
	        valuePairs = new LinkedHashMap<String,List<String>>();
	
	        String uri = "file:" + new File(fileName).getAbsolutePath();
	
	        try
	        {
	                DocumentBuilderFactory factory = DocumentBuilderFactory.newInstance();
	                factory.setValidating(false);
	                factory.setIgnoringComments(true);
	                factory.setIgnoringElementContentWhitespace(true);
	                
	                DocumentBuilder db = factory.newDocumentBuilder();
	                Document doc = db.parse(uri);
	                doNodes(doc);
	                checkValues();
	        }
	        catch (FactoryConfigurationError fe)
	        {
	                throw new DCInputsReaderException("Cannot create Submission form parser",fe);
	        }
	        catch (Exception e)
	        {
	                throw new DCInputsReaderException("Error creating submission forms: "+e);
	        }
    	}
    	catch (DCInputsReaderException e)
    	{
            log.debug("input forms: could not construct input from " + fileName, e);    		
    		exceptionState = e;
    	}
    }
    
    public synchronized void buildOutputs() throws DCInputsReaderException
    {
    	buildOutputs(defsFile);
    }

    private void buildOutputs(String fileName) throws DCInputsReaderException
    {
        try {
        	// yikes!
	        DOMImplementationRegistry registry = DOMImplementationRegistry.newInstance();
	        DOMImplementation domImpl = registry.getDOMImplementation("XML 3.0");
	
	        Document document = rebuildNodes(domImpl);
	
	        TransformerFactory tFactory = TransformerFactory.newInstance();
	        Transformer transformer = tFactory.newTransformer();
	
	        DOMSource source = new DOMSource(document);
	        transformer.setOutputProperty(OutputKeys.INDENT, "yes");
	        // XXX include doctype ???
	        StreamResult result = new StreamResult(new File(fileName));
	        transformer.transform(source, result); 
    	}
    	catch (Exception e)
    	{
            log.debug("input forms: could not construct output to " + fileName, e);
            throw new DCInputsReaderException(e);
    	}
    }
   
    public boolean hasValueList(String name)
    {
    	return valuePairs.containsKey(name);
    }
    
    public synchronized Set<String> getValueListNames()
    {
    	return new LinkedHashSet<String>(valuePairs.keySet());
    }

    public synchronized List<String> getPairs(String name)
    {
        return new Vector<String>(valuePairs.get(name));
    }

    // Yikes!
    // Used to determine whether a value list is used in any form and can be safely deleted
    public synchronized Set<String> isValueListUsed(String name)
    {
    	Set<String> result = new LinkedHashSet<String>();
    	for (Map.Entry<String, Vector<Vector<Map<String,String>>>> form : formDefns.entrySet())
    	{
    		String formName = form.getKey();
    		for (Vector<Map<String,String>> fields : form.getValue())
    		{
    			for (Map<String,String> map : fields)
    			{
    				for (Map.Entry<String, String> entry : map.entrySet())
    				{
    					if (entry.getKey().equals(PAIR_TYPE_NAME) &&
    							entry.getValue().equals(name))
    						result.add(formName);
    				}
    			}    			
    		}    		
    	}
    	return result;
    }
    
    public synchronized Set<String> isInputFormUsed(String name)
    {
    	Set<String> result = new LinkedHashSet<String>();
    	for (Map.Entry<String,String> entry : whichForms.entrySet())
    	{
    		if (entry.getValue().equals(name))
    			result.add(entry.getKey());    		
    	}
    	return result;		    	
    }
    
    /**
     * Returns the set of DC inputs used for a particular collection, or the
     * default set if no inputs defined for the collection
     *
     * @param collectionHandle
     *            collection's unique Handle
     * @return DC input set
     * @throws DCInputsReaderException
     *             if no default set defined
     */
    public synchronized DCInputSet getInputs(String collectionHandle)
                throws DCInputsReaderException
    {
        String formName = whichForms.get(collectionHandle);
        if (formName == null)
        {
                formName = whichForms.get(DEFAULT_COLLECTION);
        }
        if (formName == null)
        {
                throw new DCInputsReaderException("No form designated as default");
        }
        return getInputsByName(formName);
    }
    
    public boolean hasMapEntry(String collectionHandle)
    {
    	return whichForms.containsKey(collectionHandle);
    }
    
    public String getMapEntry(String collectionHandle)
    {
    	return whichForms.get(collectionHandle);
    }
    
    public synchronized void addMapEntry(String collectionHandle, String formName) // or modify
    {
    	whichForms.put(collectionHandle, formName);
    }
    
    public synchronized void removeMapEntry(String collectionHandle)
    {
    	whichForms.remove(collectionHandle);
    }
    
    public synchronized DCInput newField(Map<String, String> fieldMap)
    {
    	return new DCInput(fieldMap, valuePairs);
    }

    public synchronized Set<String> getInputSetNames()
    {
    	return new LinkedHashSet<String>(formDefns.keySet());
    }
    
    public synchronized DCInputSet getInputsByName(String formName) throws DCInputsReaderException
    {
    	// NB as an alternative to the caching stuff that was here before,
    	// we could always just construct DCInputSets directly when the file is loaded, no?
        Vector<Vector<Map<String,String>>> pages = formDefns.get(formName);
        if ( pages == null )
        {
                throw new DCInputsReaderException("Missing the " + formName  + " form");
        }
        return new DCInputSet(formName, pages, valuePairs);
    }
    
    public boolean hasInputSet(String name)
    {
    	return formDefns.containsKey(name);
    }
    
    public synchronized void addInputSet(DCInputSet inputSet) // or modify
    {
    	formDefns.put(inputSet.getFormName(), inputSet.toVec());
    }
    
    public synchronized void removeInputSet(String formName)
    {
    	formDefns.remove(formName);
    }
    
    public synchronized void addValuePairs(String valuePairsName, String dcTerm, List<String> pairs) // or modify
    {
    	valuePairs.put(valuePairsName, pairs);
    }
    
    public synchronized void removeValuePairs(String valuePairsName)
    {
    	valuePairs.remove(valuePairsName);
    }
    
    /**
     * Return the number of pages the inputs span for a desginated collection
     * @param  collectionHandle   collection's unique Handle
     * @return number of pages of input
     * @throws DCInputsReaderException if no default set defined
     */
    public int getNumberInputPages(String collectionHandle)
        throws DCInputsReaderException
    {
        return getInputs(collectionHandle).getNumberPages();
    }
    
    /**
     * Process the top level child nodes in the passed top-level node. These
     * should correspond to the collection-form maps, the form definitions, and
     * the display/storage word pairs.
     */
    private void doNodes(Node n)
                throws SAXException, DCInputsReaderException
    {
        if (n == null)
        {
                return;
        }
        Node e = getElement(n);
        NodeList nl = e.getChildNodes();
        int len = nl.getLength();
        boolean foundMap  = false;
        boolean foundDefs = false;
        for (int i = 0; i < len; i++)
        {
                Node nd = nl.item(i);
                if ((nd == null) || isEmptyTextNode(nd))
                {
                        continue;
                }
                String tagName = nd.getNodeName();
                if (tagName.equals("form-map"))
                {
                        processMap(nd);
                        foundMap = true;
                }
                else if (tagName.equals("form-definitions"))
                {
                        processDefinition(nd);
                        foundDefs = true;
                }
                else if (tagName.equals("form-value-pairs"))
                {
                        processValuePairs(nd);
                }
                // Ignore unknown nodes
        }
        if (!foundMap)
        {
                throw new DCInputsReaderException("No collection to form map found");
        }
        if (!foundDefs)
        {
                throw new DCInputsReaderException("No form definition found");
        }
    }
    
    private Document rebuildNodes(DOMImplementation domImpl)
    {
    	DocumentType docType = domImpl.createDocumentType("input-forms", null, "input-forms.dtd");
    	Document doc = domImpl.createDocument(null, "input-forms", docType);
    	doc.setXmlVersion("1.0");
    	
    	Element inputForms = doc.getDocumentElement();
    	inputForms.appendChild(rebuildMap(doc));
    	inputForms.appendChild(rebuildDefinition(doc));
    	inputForms.appendChild(rebuildValuePairs(doc));
    	
    	return doc;
    }

    /**
     * Process the form-map section of the XML file.
     * Each element looks like:
     *   <name-map collection-handle="hdl" form-name="name" />
     * Extract the collection handle and form name, put name in hashmap keyed
     * by the collection handle.
     */
    private void processMap(Node e)
        throws SAXException
    {
        NodeList nl = e.getChildNodes();
        int len = nl.getLength();
        for (int i = 0; i < len; i++)
        {
                Node nd = nl.item(i);
                if (nd.getNodeName().equals("name-map"))
                {
                        String id = getAttribute(nd, "collection-handle");
                        String value = getAttribute(nd, "form-name");
                        String content = getValue(nd);
                        if (id == null)
                        {
                                throw new SAXException("name-map element is missing collection-handle attribute");
                        }
                        if (value == null)
                        {
                                throw new SAXException("name-map element is missing form-name attribute");
                        }
                        if (content != null && content.length() > 0)
                        {
                                throw new SAXException("name-map element has content, it should be empty.");
                        }
                        whichForms.put(id, value);
                }  // ignore any child node that isn't a "name-map"
        }
    }

    private Node rebuildMap(Document doc)
    {
    	Element formMap = doc.createElement("form-map");
    	
    	for (Map.Entry<String, String> entry : whichForms.entrySet())
    	{
    		Element nameMap = doc.createElement("name-map");
    		formMap.appendChild(nameMap);
    		nameMap.setAttribute("collection-handle", entry.getKey());
    		nameMap.setAttribute("form-name", entry.getValue());    		
    	}
    	return formMap;
    }
    
    /**
     * Process the form-definitions section of the XML file. Each element is
     * formed thusly: <form name="formname">...pages...</form> Each pages
     * subsection is formed: <page number="#"> ...fields... </page> Each field
     * is formed from: dc-element, dc-qualifier, label, hint, input-type name,
     * required text, and repeatable flag.
     */
    private void processDefinition(Node e)
        throws SAXException, DCInputsReaderException
    {
        int numForms = 0;
        NodeList nl = e.getChildNodes();
        int len = nl.getLength();
        for (int i = 0; i < len; i++)
        {
                Node nd = nl.item(i);
                // process each form definition
                if (nd.getNodeName().equals("form"))
                {
                        numForms++;
                        String formName = getAttribute(nd, "name");
                        if (formName == null)
                        {
                                throw new SAXException("form element has no name attribute");
                        }
                        Vector<Vector<Map<String,String>>> pages = new Vector<Vector<Map<String,String>>>(); // the form contains pages
                        formDefns.put(formName, pages);
                        NodeList pl = nd.getChildNodes();
                        int lenpg = pl.getLength();
                        for (int j = 0; j < lenpg; j++)
                        {
                                Node npg = pl.item(j);
                                // process each page definition
                                if (npg.getNodeName().equals("page"))
                                {
                                        String pgNum = getAttribute(npg, "number");
                                        if (pgNum == null)
                                        {
                                                throw new SAXException("Form " + formName + " has no identified pages");
                                        }
                                        Vector<Map<String,String>> page = new Vector<Map<String,String>>();
                                        pages.add(page);
                                        NodeList flds = npg.getChildNodes();
                                        int lenflds = flds.getLength();
                                        for (int k = 0; k < lenflds; k++)
                                        {
                                                Node nfld = flds.item(k);
                                                if ( nfld.getNodeName().equals("field") )
                                                {
                                                        // process each field definition
                                                        HashMap<String,String> field = new LinkedHashMap<String,String>();
                                                        page.add(field);
                                                        processPageParts(formName, pgNum, nfld, field);
                                                        String error = checkForDups(formName, field, pages);
                                                        if (error != null)
                                                        {
                                                                throw new SAXException(error);
                                                        }
                                                }
                                        }
                                } // ignore any child that is not a 'page'
                        }
                        // sanity check number of pages
                        if (pages.size() < 1)
                        {
                                throw new DCInputsReaderException("Form " + formName + " has no pages");
                        }
                }
        }
        if (numForms == 0)
        {
                throw new DCInputsReaderException("No form definition found");
        }
    }
    
    private Node rebuildDefinition(Document doc)
    {
    	Element formDefinitions = doc.createElement("form-definitions");
    	for (Map.Entry<String, Vector<Vector<Map<String,String>>>> entry : formDefns.entrySet())
    	{
    		Element form = doc.createElement("form");
    		formDefinitions.appendChild(form);
    		form.setAttribute("name", entry.getKey());
    	
    		Vector<Vector<Map<String,String>>> formDefn = entry.getValue();
    		for (int pageNumber = 0; pageNumber < formDefn.size(); pageNumber++)
    		{
    			Element page = doc.createElement("page");
    			form.appendChild(page);
    			page.setAttribute("number", String.valueOf(pageNumber+1)); // XXX not actually reconstructible

    			for (Map<String, String> fieldMap : formDefn.get(pageNumber))
    			{
    				Node field = rebuildPageParts(doc, fieldMap);
    				page.appendChild(field);    			
    			}
    		}
    	}
    	return formDefinitions;
    }

    /**
     * Process parts of a field
     * At the end, make sure that input-types 'qualdrop_value' and
     * 'twobox' are marked repeatable. Complain if dc-element, label,
     * or input-type are missing.
     */
    private void processPageParts(String formName, String page, Node n, HashMap<String,String> field)
        throws SAXException
    {
        NodeList nl = n.getChildNodes();
        int len = nl.getLength();
        for (int i = 0; i < len; i++)
        {
                Node nd = nl.item(i);
                if ( ! isEmptyTextNode(nd) )
                {
                        String tagName = nd.getNodeName();
                        String value   = getValue(nd);
                        field.put(tagName, value);
                        if (tagName.equals("input-type"))
                        {
                    if (value.equals("dropdown")
                            || value.equals("qualdrop_value")
                            || value.equals("list"))
                                {
                                        String pairTypeName = getAttribute(nd, PAIR_TYPE_NAME);
                                        if (pairTypeName == null)
                                        {
                                                throw new SAXException("Form " + formName + ", field " +
                                                                                                field.get("dc-element") +
                                                                                                        "." + field.get("dc-qualifier") +
                                                                                                " has no name attribute");
                                        }
                                        else
                                        {
                                                field.put(PAIR_TYPE_NAME, pairTypeName);
                                        }
                                }
                        }
                        else if (tagName.equals("vocabulary"))
                        {
                                String closedVocabularyString = getAttribute(nd, "closed");
                            field.put("closedVocabulary", closedVocabularyString);
                        }
                }
        }
        String missing = null;
        if (field.get("dc-element") == null)
        {
                missing = "dc-element";
        }
        if (field.get("label") == null)
        {
                missing = "label";
        }
        if (field.get("input-type") == null)
        {
                missing = "input-type";
        }
        if ( missing != null )
        {
                String msg = "Required field " + missing + " missing on page " + page + " of form " + formName;
                throw new SAXException(msg);
        }
        String type = field.get("input-type");
        if (type.equals("twobox") || type.equals("qualdrop_value"))
        {
                String rpt = field.get("repeatable");
                if ((rpt == null) ||
                                ((!rpt.equalsIgnoreCase("yes")) &&
                                                (!rpt.equalsIgnoreCase("true"))))
                {
                        String msg = "The field \'"+field.get("label")+"\' must be repeatable";
                        throw new SAXException(msg);
                }
        }
    }
    
    private Node rebuildPageParts(Document doc, Map<String,String> fieldMap)
    {
    	Element field = doc.createElement("field");
    	for (Map.Entry<String, String> entry : fieldMap.entrySet())
    	{
    		String key = entry.getKey();
			String value = entry.getValue();
    		if (!PAIR_TYPE_NAME.equals(key)) {
    			Element n = doc.createElement(key);
    			field.appendChild(n);
    			n.setTextContent(value);
    			if ("input-type".equals(key) &&
    				(value.equals("dropdown") || value.equals("qualdrop_value") || value.equals("list")))
    			{
    				n.setAttribute(PAIR_TYPE_NAME, fieldMap.get(PAIR_TYPE_NAME));    				
    			}
    		}
    	}
    	return field;
    }

    /**
     * Check that this is the only field with the name dc-element.dc-qualifier
     * If there is a duplicate, return an error message, else return null;
     */
    private String checkForDups(String formName, HashMap<String,String> field, Vector<Vector<Map<String,String>>> pages)
    {
        int matches = 0;
        String err = null;
        String schema = field.get("dc-schema");
        String elem = field.get("dc-element");
        String qual = field.get("dc-qualifier");
        if ((schema == null) || (schema.equals("")))
        {
            schema = MetadataSchema.DC_SCHEMA;
        }
        String schemaTest;
        
        for (int i = 0; i < pages.size(); i++)
        {
            Vector<Map<String,String>> pg = pages.get(i);
            for (int j = 0; j < pg.size(); j++)
            {
                Map<String,String> fld = pg.get(j);
                if ((fld.get("dc-schema") == null) ||
                    (fld.get("dc-schema").equals("")))
                {
                    schemaTest = MetadataSchema.DC_SCHEMA;
                }
                else
                {
                    schemaTest = fld.get("dc-schema");
                }
                
                // Are the schema and element the same? If so, check the qualifier
                if (((fld.get("dc-element")).equals(elem)) &&
                    (schemaTest.equals(schema)))
                {
                    String ql = fld.get("dc-qualifier");
                    if (qual != null)
                    {
                        if ((ql != null) && ql.equals(qual))
                        {
                            matches++;
                        }
                    }
                    else if (ql == null)
                    {
                        matches++;
                    }
                }
            }
        }
        if (matches > 1)
        {
            err = "Duplicate field " + schema + "." + elem + "." + qual + " detected in form " + formName;
        }
        
        return err;
    }


    /**
     * Process the form-value-pairs section of the XML file.
     *  Each element is formed thusly:
     *      <value-pairs name="..." dc-term="...">
     *          <pair>
     *            <display>displayed name-</display>
     *            <storage>stored name</storage>
     *          </pair>
     * For each value-pairs element, create a new vector, and extract all
     * the pairs contained within it. Put the display and storage values,
     * respectively, in the next slots in the vector. Store the vector
     * in the passed in hashmap.
     */
    private void processValuePairs(Node e)
                throws SAXException
    {
        NodeList nl = e.getChildNodes();
        int len = nl.getLength();
        for (int i = 0; i < len; i++)
        {
                Node nd = nl.item(i);
                    String tagName = nd.getNodeName();

                    // process each value-pairs set
                    if (tagName.equals("value-pairs"))
                    {
                        String pairsName = getAttribute(nd, PAIR_TYPE_NAME);
                        String dcTerm = getAttribute(nd, "dc-term");
                        if (pairsName == null)
                        {
                                String errString =
                                        "Missing name attribute for value-pairs for DC term " + dcTerm;
                                throw new SAXException(errString);

                        }
                        Vector<String> pairs = new Vector<String>();
                        valuePairs.put(pairsName, pairs);
                        NodeList cl = nd.getChildNodes();
                        int lench = cl.getLength();
                        for (int j = 0; j < lench; j++)
                        {
                                Node nch = cl.item(j);
                                String display = null;
                                String storage = null;

                                if (nch.getNodeName().equals("pair"))
                                {
                                        NodeList pl = nch.getChildNodes();
                                        int plen = pl.getLength();
                                        for (int k = 0; k < plen; k++)
                                        {
                                                Node vn= pl.item(k);
                                                String vName = vn.getNodeName();
                                                if (vName.equals("displayed-value"))
                                                {
                                                        display = getValue(vn);
                                                }
                                                else if (vName.equals("stored-value"))
                                                {
                                                        storage = getValue(vn);
                                                        if (storage == null)
                                                        {
                                                                storage = "";
                                                        }
                                                } // ignore any children that aren't 'display' or 'storage'
                                        }
                                        pairs.add(display);
                                        pairs.add(storage);
                                } // ignore any children that aren't a 'pair'
                        }
                    } // ignore any children that aren't a 'value-pair'
        }
    }

    private Node rebuildValuePairs(Document doc)
    {
    	Element formValuePairs = doc.createElement("form-value-pairs");
    	for (Map.Entry<String, List<String>> entry : valuePairs.entrySet())
    	{
    		Element valuePairs = doc.createElement("value-pairs");
    		formValuePairs.appendChild(valuePairs);
    		valuePairs.setAttribute("value-pairs-name", entry.getKey());
    		valuePairs.setAttribute("dc-term", ""); // XXX not reconstructible
    		
    		List<String> values = entry.getValue();
    		for (int i = 0; i < values.size(); i+=2)
    		{
    			Element pair = doc.createElement("pair");
    			valuePairs.appendChild(pair);

    			Element displayedValue = doc.createElement("displayed-value");
    			pair.appendChild(displayedValue);
    			displayedValue.setTextContent(values.get(i));
    			
    			Element storedValue = doc.createElement("stored-value");
    			pair.appendChild(storedValue);
    			storedValue.setTextContent(values.get(i+1));
    		}
    	}
    	return formValuePairs;    	
    }    

    /**
     * Check that all referenced value-pairs are present
     * and field is consistent
     *
     * Throws DCInputsReaderException if detects a missing value-pair.
     */

    private void checkValues()
                throws DCInputsReaderException
    {
        // Step through every field of every page of every form
        Iterator<String> ki = formDefns.keySet().iterator();
        while (ki.hasNext())
        {
                String idName = ki.next();
                Vector<Vector<Map<String,String>>> pages = formDefns.get(idName);
                for (int i = 0; i < pages.size(); i++)
                {
                        Vector<Map<String,String>> page = pages.get(i);
                        for (int j = 0; j < page.size(); j++)
                        {
                                Map<String,String> fld = page.get(j);
                                // verify reference in certain input types
                                String type = fld.get("input-type");
                    if (type.equals("dropdown")
                            || type.equals("qualdrop_value")
                            || type.equals("list"))
                                {
                                        String pairsName = fld.get(PAIR_TYPE_NAME);
                                        List<String> v = valuePairs.get(pairsName);
                                        if (v == null)
                                        {
                                                String errString = "Cannot find value pairs for " + pairsName;
                                                throw new DCInputsReaderException(errString);
                                        }
                                }
                                // if visibility restricted, make sure field is not required
                                String visibility = fld.get("visibility");
                                if (visibility != null && visibility.length() > 0 )
                                {
                                        String required = fld.get("required");
                                        if (required != null && required.length() > 0)
                                        {
                                                String errString = "Field '" + fld.get("label") +
                                                                        "' is required but invisible";
                                                throw new DCInputsReaderException(errString);
                                        }
                                }
                        }
                }
        }
    }
    
    private Node getElement(Node nd)
    {
        NodeList nl = nd.getChildNodes();
        int len = nl.getLength();
        for (int i = 0; i < len; i++)
        {
            Node n = nl.item(i);
            if (n.getNodeType() == Node.ELEMENT_NODE)
            {
                return n;
            }
        }
        return null;
     }

    private boolean isEmptyTextNode(Node nd)
    {
        boolean isEmpty = false;
        if (nd.getNodeType() == Node.TEXT_NODE)
        {
                String text = nd.getNodeValue().trim();
                if (text.length() == 0)
                {
                        isEmpty = true;
                }
        }
        return isEmpty;
    }

    /**
     * Returns the value of the node's attribute named <name>
     */
    private String getAttribute(Node e, String name)
    {
        NamedNodeMap attrs = e.getAttributes();
        int len = attrs.getLength();
        if (len > 0)
        {
                int i;
                for (i = 0; i < len; i++)
                {
                        Node attr = attrs.item(i);
                        if (name.equals(attr.getNodeName()))
                        {
                                return attr.getNodeValue().trim();
                        }
                }
        }
        //no such attribute
        return null;
    }

    /**
     * Returns the value found in the Text node (if any) in the
     * node list that's passed in.
     */
    private String getValue(Node nd)
    {
        NodeList nl = nd.getChildNodes();
        int len = nl.getLength();
        for (int i = 0; i < len; i++)
        {
                Node n = nl.item(i);
                short type = n.getNodeType();
                if (type == Node.TEXT_NODE)
                {
                        return n.getNodeValue().trim();
                }
        }
        // Didn't find a text node
        return null;
    }
}
