package org.dspace.app.xmlui.aspect.federated;

import java.net.MalformedURLException;
import java.net.URL;
import java.sql.SQLException;

import org.apache.lucene.document.Document;
import org.apache.lucene.document.Field;
import org.dspace.content.Item;
import org.dspace.core.Context;
import org.dspace.harvest.HarvestedCollection;
import org.dspace.search.SearchExtension;

public class SourceIndexer implements SearchExtension {

	public SourceIndexer() {}
	
	public void indexItem(Context context, Item item, Document doc) throws SQLException {
		
		int collectionID = item.getOwningCollection().getID();
		HarvestedCollection collection = HarvestedCollection.find(context, collectionID);
		if (collection != null)
		{
			String source = collection.getOaiSource();
			try {
				URL sourceURL = new URL(source);
				String domainname = sourceURL.getHost();
				String host = domainname.substring(0,domainname.indexOf('.'));
				doc.add(new Field("itemsource", host, Field.Store.YES, Field.Index.UN_TOKENIZED));
			} catch (MalformedURLException e) {
				e.printStackTrace();
			}
		}
		else
		{
			doc.add(new Field("itemsource", "drcolk", Field.Store.YES, Field.Index.UN_TOKENIZED));
		}
	}
}
