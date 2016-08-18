package org.dspace.browse;

import org.dspace.core.Context;
import org.dspace.sort.SortException;
import org.dspace.sort.SortOption;

public interface BrowseIndex {

	public String getName();
	
	public String getDataType();

	public String getDisplayType();

	public String getTableName();
	
    public String getDefaultOrder();
	
	public SortOption getSortOption();
	
	public SortOption getSortOptionDefault() throws SortException;
	
    public String getSortField(boolean isSecondLevel) throws BrowseException;

    public boolean isDate();

    public String getDistinctTableName();

	public String getMapTableName();

	public String getTableName(boolean distinct, boolean inCommunity, boolean inCollection);
	
	// true if this is an metadata-index-type browse index, rather than a full item browse type 
	public boolean isIndexBrowse();
	
	public BrowseDAO getBrowseDAO(Context context, String db) throws BrowseException;
	
	public boolean isHidden(); // hide this in list of browse types
	
}