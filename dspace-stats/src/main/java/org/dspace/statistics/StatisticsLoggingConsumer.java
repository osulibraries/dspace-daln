/**
 * $Id: StatisticsLoggingConsumer.java 4440 2009-10-10 19:03:27Z mdiggory $
 * $URL: http://scm.dspace.org/svn/repo/dspace/tags/dspace-1.6.2/dspace-stats/src/main/java/org/dspace/statistics/StatisticsLoggingConsumer.java $
 * *************************************************************************
 * Copyright (c) 2002-2009, DuraSpace.  All rights reserved
 * Licensed under the DuraSpace Foundation License.
 *
 * A copy of the DuraSpace License has been included in this
 * distribution and is available at: http://scm.dspace.org/svn/repo/licenses/LICENSE.txt
 */
package org.dspace.statistics;

import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;

import org.dspace.content.Collection;
import org.dspace.content.Community;
import org.dspace.content.Item;
import org.dspace.core.Constants;
import org.dspace.core.Context;
import org.dspace.event.Consumer;
import org.dspace.event.Event;

/**
 * StatisticsLogging Consumer for SolrLogger which captures Create, Update
 * and Delete Events on DSpace Objects.
 *
 * All usage-events will be updated to capture changes to e.g.
 * the owning collection
 *
 * @author kevinvandevelde at atmire.com
 * @author ben at atmrie.com
 */
public class StatisticsLoggingConsumer implements Consumer
{

    private Set<String> toRemoveQueries = null;

    public void initialize() throws Exception
    {

    }

    // TODO: checkout whether moving of collections, communities and bitstreams works
    // TODO: use async threaded consumer as this might require some processing time
    // TODO: we might be able to improve the performance: changing the collection will trigger 4 update commands
    public void consume(Context ctx, Event event) throws Exception
    {
        if (toRemoveQueries == null)
        {
            toRemoveQueries = new HashSet<String>();
        }

        int dsoId = event.getSubjectID();
        int dsoType = event.getSubjectType();
        int eventType = event.getEventType();

        // Check if we are deleting something
        if (eventType == Event.DELETE)
        {
            // First make sure we delete everything for this dso
            String query = "id:" + dsoId + " AND type:" + dsoType;
            toRemoveQueries.add(query);
        }
        else if (eventType == Event.MODIFY && dsoType == Constants.ITEM)
        {
            // We have a modified item check for a withdraw/reinstate
        }
        else if (eventType == Event.MODIFY_METADATA
                && event.getSubjectType() == Constants.ITEM)
        {
            Item item = Item.find(ctx, event.getSubjectID());

            String updateQuery = "id:" + item.getID() + " AND type:"
                    + item.getType();
            Map<String, List<String>> indexedValues = SolrLogger.queryField(
                    updateQuery, null, null);

            // Get all the metadata
            Map metadataStorageInfo = SolrLogger.getMetadataStorageInfo();
            List<String> storageFieldList = new ArrayList<String>();
            List<List<Object>> storageValuesList = new ArrayList<List<Object>>();

            for (Object storageField : metadataStorageInfo.keySet())
            {
                String[] metadataFieldInfo = String.valueOf(
                        metadataStorageInfo.get(storageField)).split("\\.");

                List<Object> values = new ArrayList<Object>();
                List<Object> valuesLow = new ArrayList<Object>();
                for (int i = 0; i < item.getMetadata(metadataFieldInfo[0],
                        metadataFieldInfo[1], metadataFieldInfo[2], Item.ANY).length; i++)
                {
                    values.add(item.getMetadata(metadataFieldInfo[0],
                            metadataFieldInfo[1], metadataFieldInfo[2],
                            Item.ANY)[i].value);
                    
                    valuesLow.add(item.getMetadata(metadataFieldInfo[0],
                            metadataFieldInfo[1], metadataFieldInfo[2],
                            Item.ANY)[i].value.toLowerCase());
                }

                List<String> indexedVals = indexedValues.get("" + storageField);

                boolean update = true;
                if (values.containsAll(indexedVals)
                        && values.size() == indexedVals.size())
                    update = false;

                if (update)
                {
                    storageFieldList.add((String) storageField);
                    storageFieldList.add(storageField + "_search");
                    storageValuesList.add(values);
                    storageValuesList.add(valuesLow);
                }
            }

            SolrLogger.update(updateQuery, "replace", storageFieldList,
                    storageValuesList);

        }

        if (eventType == Event.ADD && dsoType == Constants.COLLECTION
                && event.getObject(ctx) instanceof Item)
        {
            // We are mapping a new item make sure that the owning collection is
            // updated
            Item newItem = (Item) event.getObject(ctx);
            String updateQuery = "id: " + newItem.getID() + " AND type:"
                    + newItem.getType();

            List<String> fieldNames = new ArrayList<String>();
            List<List<Object>> valuesList = new ArrayList<List<Object>>();
            fieldNames.add("owningColl");
            fieldNames.add("owningComm");

            List<Object> valsList = new ArrayList<Object>();
            valsList.add(dsoId);
            valuesList.add(valsList);

            valsList = new ArrayList<Object>();
            valsList.addAll(findOwningCommunities(ctx, dsoId));
            valuesList.add(valsList);

            // Now make sure we also update the communities
            SolrLogger.update(updateQuery, "addOne", fieldNames, valuesList);

        }
        else if (eventType == Event.REMOVE && dsoType == Constants.COLLECTION
                && event.getObject(ctx) instanceof Item)
        {
            // Unmapping items
            Item newItem = (Item) event.getObject(ctx);
            String updateQuery = "id: " + newItem.getID() + " AND type:"
                    + newItem.getType();

            List<String> fieldNames = new ArrayList<String>();
            List<List<Object>> valuesList = new ArrayList<List<Object>>();
            fieldNames.add("owningColl");
            fieldNames.add("owningComm");

            List<Object> valsList = new ArrayList<Object>();
            valsList.add(dsoId);
            valuesList.add(valsList);

            valsList = new ArrayList<Object>();
            valsList.addAll(findOwningCommunities(ctx, dsoId));
            valuesList.add(valsList);

            SolrLogger.update(updateQuery, "remOne", fieldNames, valuesList);
        }
    }

    private List<Object> findOwningCommunities(Context context, int collId)
            throws SQLException
    {
        Collection coll = Collection.find(context, collId);

        List<Object> owningComms = new ArrayList<Object>();
        for (int i = 0; i < coll.getCommunities().length; i++)
        {
            Community community = coll.getCommunities()[i];
            findComms(community, owningComms);
        }

        return owningComms;
    }

    private void findComms(Community comm, List<Object> parentComms)
            throws SQLException
    {
        if (comm == null)
            return;
        if (!parentComms.contains(comm.getID()))
            parentComms.add(comm.getID());
        findComms(comm.getParentCommunity(), parentComms);
    }

    public void end(Context ctx) throws Exception
    {
        if (toRemoveQueries != null)
        {
            for (String query : toRemoveQueries)
            {
                SolrLogger.removeIndex(query);
            }
        }
        // clean out toRemoveQueries
        toRemoveQueries = null;
    }

    public void finish(Context ctx) throws Exception
    {
    }

}
