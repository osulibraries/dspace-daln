package org.dspace.app.xmlui.aspect.artifactbrowser;

import java.sql.SQLException;

import org.dspace.app.xmlui.wing.Message;
import org.dspace.browse.BrowserScope;

public interface BrowseExtension {

	public Message getTitleMessage(BrowserScope scope, String scopeName, String value) throws SQLException;
	public Message getTrailMessage(BrowserScope scope, String scopeName) throws SQLException;
	
}
