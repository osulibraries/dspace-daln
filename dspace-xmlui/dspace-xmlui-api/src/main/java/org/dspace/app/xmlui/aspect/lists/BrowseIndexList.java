package org.dspace.app.xmlui.aspect.lists;

import static org.dspace.app.xmlui.aspect.artifactbrowser.BrowseUtils.getIntParameter;

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
import org.dspace.eperson.EPerson;
import org.dspace.sort.SortException;
import org.dspace.sort.SortOption;

public class BrowseIndexList extends BrowseIndexBase implements BrowseExtension {

    public static BrowseIndexList createBrowseIndex(int number, Matcher matcher) throws SortException
    {
        String name = matcher.group(1);
        String displayType = matcher.group(2);

        String defaultOrder = SortOption.ASCENDING;

		String tableBaseName = BrowseIndexManager.getItemBrowseIndex().getTableBaseName();

		return new BrowseIndexList(number, name, displayType, defaultOrder, tableBaseName);
    }     
        
        
    BrowseIndexList(int number, String name, String displayType, String defaultOrder, String tableBaseName) {
		super(number, name, displayType, defaultOrder, tableBaseName);
	}

	public String getDataType() {
		return "text";
	}

	public String getDistinctTableName() {
		return "list_entries"; // XXX is this used?
	}

	public String getMapTableName() {
		return "list_entries"; // XXX is this used?
	}

	public String getTableName() {
		return tableBaseName;
	}

	public String getTableName(boolean distinct, boolean inCommunity, boolean inCollection) {
		return getTableName();
	}

	public String getSortField(boolean isSecondLevel) throws BrowseException {
    	return "sort_1"; // XXX temporary
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
		return false;
	}


	public BrowseDAO getBrowseDAO(Context context, String db) throws BrowseException {
		return new BrowseDAOList(context);		
	}

	public boolean isHidden()
	{
		return true;
	}
	
	public Message getTitleMessage(BrowserScope scope, String scopeName, String value) throws SQLException
	{
		int list_id = getIntParameter(scope.getParameters(), "list_id");
		Context context = scope.getContext();
		EPerson eperson = context.getCurrentUser();
		String list_name = ListUtils.checkListShared(context, eperson, list_id);
		EPerson list_owner = ListUtils.getListOwner(context, list_id);
		
		return AbstractWingTransformer.message("xmlui.ArtifactBrowser.ConfigurableBrowse.title.item.list")
				.parameterize(list_owner.getEmail(), list_name);            	
	}

	public Message getTrailMessage(BrowserScope scope, String scopeName) throws SQLException
	{
		return AbstractWingTransformer.message("xmlui.ArtifactBrowser.ConfigurableBrowse.trail.item.list");            	
	}

}
