/*
 * DCType.java
 *
 * Version: $Revision: 3733 $
 *
 * Date: $Date: 2009-04-23 23:52:11 -0400 (Thu, 23 Apr 2009) $
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
package org.dspace.administer;

import java.io.IOException;
import java.sql.SQLException;

import org.apache.log4j.Logger;
import org.dspace.authorize.AuthorizeException;
import org.dspace.content.MetadataField;
import org.dspace.content.MetadataSchema;
import org.dspace.content.NonUniqueMetadataException;
import org.dspace.core.Context;

/**
 * Class representing a particular Dublin Core metadata type, with various
 * utility methods. In general, only used for manipulating the registry of
 * Dublin Core types in the system, so most users will not need this.
 * 
 * <p>
 * The DCType implementation has been deprecated, please use MetadataManager,
 * MetadataSchema and MetadataField instead. For backward compatibility the this
 * implementation has been updated to transparently call the new classes.
 * </p>
 *
 * @author Robert Tansley
 * @author Martin Hald
 * @version $Revision: 3733 $
 * @deprecated
 */
public class DCType
{
    /** log4j logger */
    private static Logger log = Logger.getLogger(DCType.class);

    /** Our context */
    private Context ourContext;

    /** The matching metadata field */
    private MetadataField field = new MetadataField();

    /**
     * Create a DCType from an existing metadata field.
     *
     * @param context
     * @param field
     * @deprecated
     */
    public DCType(Context context, MetadataField field)
    {
        this.ourContext = context;
        this.field = field;
    }

    /**
     * Default constructor.
     * 
     * @param context
     * @deprecated
     */
    public DCType(Context context)
    {
        this.ourContext = context;
    }

    /**
     * Utility method for quick access to an element and qualifier given the
     * type ID.
     * 
     * @param context
     *            context, in case DC types need to be read in from DB
     * @param id
     *            the DC type ID
     * @return a two-String array, string 0 is the element, string 1 is the
     *         qualifier
     * @deprecated
     */
    public static String[] quickFind(Context context, int id)
            throws SQLException
    {
        MetadataField field = MetadataField.find(context, id);

        String[] result = new String[2];

        if (field == null)
        {
        return result;
    }
        else
        {
            result[0] = field.getElement();
            result[1] = field.getQualifier();
            return result;
        }
    }

    /**
     * Get a metadata field from the database.
     * 
     * @param context
     *            DSpace context object
     * @param id
     *            ID of the dublin core type
     * 
     * @return the metadata field, or null if the ID is invalid.
     * @deprecated
     */
    public static DCType find(Context context, int id) throws SQLException
    {
        MetadataField field = MetadataField.find(context, id);
        return new DCType(context, field);
    }

    /**
     * Find a given Dublin Core type. Returns <code>null</code> if the Dublin
     * Core type doesn't exist.
     * 
     * @param context
     *            the DSpace context to use
     * @param element
     *            the element to find
     * @param qualifier
     *            the qualifier, or <code>null</code> to find an unqualified
     *            type
     * 
     * @return the Dublin Core type, or <code>null</code> if there isn't a
     *         corresponding type in the registry
     * @throws AuthorizeException
     * @deprecated
     */
    public static DCType findByElement(Context context, String element,
            String qualifier) throws SQLException, AuthorizeException
    {
        MetadataField field = MetadataField.findByElement(context,
                MetadataSchema.DC_SCHEMA_ID, element, qualifier);

        if (field == null)
        {
            return null;
        }
        else
        {
            return new DCType(context, field);
        }
    }

    /**
     * Retrieve all Dublin Core types from the registry
     * 
     * @return an array of all the Dublin Core types
     * @deprecated
     */
    public static DCType[] findAll(Context context) throws SQLException
    {

        MetadataField field[] = MetadataField.findAll(context);
        DCType[] typeArray = new DCType[field.length];

        for (int ii = 0; ii < field.length; ii++)
        {
            typeArray[ii] = new DCType(context, field[ii]);
        }

        // Return the array
        return typeArray;
    }

    /**
     * Create a new Dublin Core type
     * 
     * @param context
     *            DSpace context object
     * @return the newly created DCType
     * @throws NonUniqueMetadataException
     * @throws IOException
     * @deprecated
     */
    public static DCType create(Context context) throws SQLException,
            AuthorizeException, IOException, NonUniqueMetadataException
        {
        MetadataField field = new MetadataField();
        field.setSchemaID(MetadataSchema.DC_SCHEMA_ID);
        field.create(context);
        return new DCType(context, field);
    }

    /**
     * Delete this DC type. This won't work if there are any DC values in the
     * database of this type - they need to be updated first. An
     * <code>SQLException</code> (referential integrity violation) will be
     * thrown in this case.
     * @deprecated
     */
    public void delete() throws SQLException, AuthorizeException
    {
        field.delete(ourContext);
    }

    /**
     * Get the internal identifier of this metadata field
     * 
     * @return the internal identifier
     */
    public int getID()
    {
        return field.getFieldID();
    }

    /**
     * Get the DC element
     * 
     * @return the element
     */
    public String getElement()
    {
        return field.getElement();
    }

    /**
     * Set the DC element
     * 
     * @param s
     *            the new element
     */
    public void setElement(String s)
    {
        field.setElement(s);
    }

    /**
     * Get the DC qualifier, if any.
     * 
     * @return the DC qualifier, or <code>null</code> if this is an
     *         unqualified element
     */
    public String getQualifier()
    {
        return field.getQualifier();
    }

    /**
     * Set the DC qualifier
     * 
     * @param s
     *            the DC qualifier, or <code>null</code> if this is an
     *            unqualified element
     */
    public void setQualifier(String s)
    {
        field.setQualifier(s);
    }

    /**
     * Get the scope note - information about the DC type and its use
     * 
     * @return the scope note
     */
    public String getScopeNote()
    {
        return field.getScopeNote();
    }

    /**
     * Set the scope note
     * 
     * @param s
     *            the new scope note
     */
    public void setScopeNote(String s)
    {
        field.setScopeNote(s);
    }

    /**
     * Update the dublin core registry
     *
     * @throws IOException
     * @throws NonUniqueMetadataException
     * @deprecated
     */
    public void update() throws SQLException, AuthorizeException,
            NonUniqueMetadataException, IOException
        {
        field.update(ourContext);
    }
}
