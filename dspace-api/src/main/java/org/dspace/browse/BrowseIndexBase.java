package org.dspace.browse;

import org.dspace.sort.SortOption;

public abstract class BrowseIndexBase implements BrowseIndex {

	/** used for single metadata browse tables for generating the table name */
	protected int number;
	/** the name of the browse index, as specified in the config */
	protected String name;
	/** the display type of the metadata, as specified in the config */
	protected String displayType;
	/** base name for tables, sequences */
	protected String tableBaseName;
	/** default order (asc / desc) for this index */
	protected String defaultOrder = SortOption.ASCENDING;

	protected BrowseIndexBase(int number, String name, String displayType, String defaultOrder, String tableBaseName)
    {
    	this.number = number;
    	this.name = name;
    	this.displayType = displayType;
    	this.defaultOrder = defaultOrder;
    	this.tableBaseName = tableBaseName;
    }
    
	/**
	 * @return Default order for this index, null if not specified
	 */
	public String getDefaultOrder() {
	    return defaultOrder;
	}

	/**
	 * @return Returns the displayType.
	 */
	public String getDisplayType() {
	    return displayType;
	}

	/**
	 * @return Returns the name.
	 */
	public String getName() {
		return name;
	}

	public String getTableBaseName() {
		return tableBaseName;
	}

	public SortOption getSortOption()
	{
		return null;
	}

    /**
     * Is the browse index type for a date?
     * 
     * @return	true if date type, false if not
     */
    public boolean isDate()
    {
        return "date".equals(getDataType());
    }
    
}