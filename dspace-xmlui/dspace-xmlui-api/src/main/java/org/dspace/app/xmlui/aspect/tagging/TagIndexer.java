package org.dspace.app.xmlui.aspect.tagging;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import org.apache.lucene.document.Document;
import org.apache.lucene.document.Field;
import org.dspace.content.Item;
import org.dspace.core.Context;
import org.dspace.eperson.EPerson;
import org.dspace.search.SearchExtension;

public class TagIndexer implements SearchExtension {

	public TagIndexer() {}
	
	public void indexItem(Context context, Item item, Document doc) throws SQLException {

    	Map<EPerson, List<String>> tagmap = TagManager.getTagsForItem(context, item);
    	for (Map.Entry<EPerson, List<String>> entry : tagmap.entrySet())
    	{
    		EPerson eperson = entry.getKey();
			doc.add(new Field("tag_user", String.valueOf(eperson.getID()), Field.Store.YES, Field.Index.UN_TOKENIZED));
    		for (String tag : entry.getValue())
    		{
    			doc.add(new Field("tag_tag", tag, Field.Store.YES, Field.Index.UN_TOKENIZED));
    			doc.add(new Field("tag_utag", String.valueOf(eperson.getID()) + "#" + tag, Field.Store.NO, Field.Index.UN_TOKENIZED));        			
    		}        		
    	}    	
	}

}
