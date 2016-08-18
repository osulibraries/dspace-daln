package org.dspace.browse;

import java.util.regex.Matcher;

import org.dspace.sort.SortException;
import org.dspace.sort.SortOption;

public class BrowseIndexItem extends BrowseIndexAbstract {

    /** the SortOption for this index (only valid for item indexes) */
    protected SortOption sortOption;

    public static BrowseIndexItem createBrowseIndex(int number, Matcher matcher) throws SortException
    {
        String name = matcher.group(1);
        String displayType = matcher.group(2);
		String sortName = matcher.group(3);

		SortOption sortOption = null;
		for (SortOption so : SortOption.getSortOptions())
		{
			if (so.getName().equals(sortName))
				sortOption = so;
		}

		if (sortOption != null)
		{
            String defaultOrder = SortOption.ASCENDING;
			// If an optional ordering configuration is supplied,
			// set the defaultOrder appropriately (asc or desc)
			if (matcher.groupCount() > 3)
			{
				String order = matcher.group(4);
				if (SortOption.DESCENDING.equalsIgnoreCase(order))
					defaultOrder = SortOption.DESCENDING;
			}

			String tableBaseName = BrowseIndexManager.getItemBrowseIndex().getTableBaseName();

			return new BrowseIndexItem(number, name, displayType, defaultOrder, tableBaseName, sortOption);
		}
		else
		{
			return null;
		}
    }
    
    BrowseIndexItem(int number, String name, String displayType, String defaultOrder, String tableBaseName, 
			SortOption sortOption)
	{
    	super(number, name, displayType, defaultOrder, tableBaseName);

    	this.sortOption = sortOption;
	}

	public String getDataType()
	{
		return sortOption.getType();
	}

	/**
	 * Get the SortOption associated with this index.
	 */
	public SortOption getSortOption()
	{
	    return sortOption;
	}
	
    public String getSortField(boolean isSecondLevel) throws BrowseException
    {
    	return "sort_" + sortOption.getNumber();
    }

	public SortOption getSortOptionDefault() throws SortException
	{
        // Get the sort option from the index
        SortOption so = getSortOption();

        if (so == null)
        {
            // No sort option, so default to the first one defined in the config
            for (SortOption sod : SortOption.getSortOptions())
            {
                so = sod;
                break;
            }
        }
        
        return so;
	}

	public boolean isIndexBrowse()
	{
		return false;
	}

}
