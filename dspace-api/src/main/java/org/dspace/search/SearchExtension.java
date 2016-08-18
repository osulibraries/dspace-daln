package org.dspace.search;

import java.sql.SQLException;

import org.apache.lucene.document.Document;
import org.dspace.content.Item;
import org.dspace.core.Context;

public interface SearchExtension {

	public void indexItem(Context context, Item item, Document doc) throws SQLException;
	
}
