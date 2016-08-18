package org.dspace.app.xmlui.aspect.tagging;

import java.sql.SQLException;
import java.util.regex.Matcher;

import org.dspace.app.xmlui.aspect.artifactbrowser.BrowseExtension;
import org.dspace.app.xmlui.wing.AbstractWingTransformer;
import org.dspace.app.xmlui.wing.Message;
import org.dspace.browse.BrowseDAO;
import org.dspace.browse.BrowseException;
import org.dspace.browse.BrowseIndexBase;
import org.dspace.browse.BrowseIndexManager;
import org.dspace.browse.BrowserScope;
import org.dspace.core.Context;
import org.dspace.sort.SortException;
import org.dspace.sort.SortOption;

public class BrowseIndexTag extends BrowseIndexBase implements BrowseExtension {

    public static BrowseIndexTag createBrowseIndex(int number, Matcher matcher) throws SortException
    {
        String name = matcher.group(1);
        String displayType = matcher.group(2);

        String defaultOrder = SortOption.ASCENDING;
        if (matcher.groupCount() > 2)
		{
			String order = matcher.group(3);
			if (SortOption.DESCENDING.equalsIgnoreCase(order))
				defaultOrder = SortOption.DESCENDING;
		}

		String tableBaseName = BrowseIndexManager.getItemBrowseIndex().getTableBaseName();

		return new BrowseIndexTag(number, name, displayType, defaultOrder, tableBaseName);
    }     
        
        
    BrowseIndexTag(int number, String name, String displayType, String defaultOrder, String tableBaseName) {
		super(number, name, displayType, defaultOrder, tableBaseName);
	}

	public String getDataType() {
		return "text";
	}

	public String getDistinctTableName() {
		return "eperson_item2tag"; // XXX is this used?
	}

	public String getMapTableName() {
		return "eperson_item2tag"; // XXX is this used?
	}

	public String getTableName() {
		return tableBaseName;
	}

	public String getTableName(boolean distinct, boolean inCommunity, boolean inCollection) {
		return getTableName();
	}

	public String getSortField(boolean isSecondLevel) throws BrowseException {
        if (!isSecondLevel)
        {
            return "tag_name";
        }
        else
        {
            return "sort_1";  // Use the first sort column
        }
	}

	public SortOption getSortOptionDefault()
	{
        SortOption sortOption = null;
		try {
			sortOption = new SortOption(0, getName(), "dc.foo.bar", "text");
		} catch (SortException e) {
		}
        return sortOption;
	}

	public boolean isIndexBrowse()
	{
		return true;
	}


	public BrowseDAO getBrowseDAO(Context context, String db) throws BrowseException {
		return new BrowseDAOTag(context);		
	}

	public boolean isHidden()
	{
		return false;
	}

	public Message getTitleMessage(BrowserScope scope, String scopeName, String value) throws SQLException
	{
    	boolean mytags = scope.getParameters().containsKey("eperson"); // XXX not quite accurate
    	if (mytags)
    	{
    		Message titleMessage = AbstractWingTransformer.message("xmlui.ArtifactBrowser.ConfigurableBrowse.title.metadata.my_tag")
    		    .parameterize(scopeName, value);
    		return titleMessage;
    	}
    	else
    	{
    		Message titleMessage = AbstractWingTransformer.message("xmlui.ArtifactBrowser.ConfigurableBrowse.title.metadata.tag")
		    	.parameterize(scopeName, value);            		
    		return titleMessage;
    	}
	}
	
	public Message getTrailMessage(BrowserScope scope, String scopeName) throws SQLException
	{
    	boolean mytags = scope.getParameters().containsKey("eperson"); // XXX not quite accurate
    	if (mytags)
    	{
    		return AbstractWingTransformer.message("xmlui.ArtifactBrowser.ConfigurableBrowse.trail.metadata.my_tag")
    		    .parameterize(scopeName);
    	}
    	else
    	{
    		return AbstractWingTransformer.message("xmlui.ArtifactBrowser.ConfigurableBrowse.trail.metadata.tag")
		    	.parameterize(scopeName);            		
    	}
	}
}
