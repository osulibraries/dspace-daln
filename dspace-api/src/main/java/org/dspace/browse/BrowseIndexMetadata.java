package org.dspace.browse;

import java.io.IOException;
import java.util.regex.Matcher;

import org.dspace.sort.SortException;
import org.dspace.sort.SortOption;


public class BrowseIndexMetadata extends BrowseIndexAbstract {

    /** the value of the metadata, as specified in the config */
    private String metadataAll;

    /** the metadata fields, as an array */
    private String[] metadata;

    /** the datatype of the index, as specified in the config */
    private String datatype;
    
    /** a three part array of the metadata bits (e.g. dc.contributor.author) */
    private String[][] mdBits;
    
    public static BrowseIndexMetadata createBrowseIndex(int number, Matcher matcher)
    {
        String name = matcher.group(1);
        String displayType = matcher.group(2);
		String metadataAll = matcher.group(3);
		String datatype = matcher.group(4);
		String[] metadata = null;

		if (metadataAll != null)
			metadata = metadataAll.split(",");
		if (metadata != null && metadata.length > 0
				&& datatype != null && !datatype.equals(""))
		{
            String defaultOrder = SortOption.ASCENDING;
			// If an optional ordering configuration is supplied,
			// set the defaultOrder appropriately (asc or desc)
			if (matcher.groupCount() > 4)
			{
				String order = matcher.group(5);
				if (SortOption.DESCENDING.equalsIgnoreCase(order))
					defaultOrder = SortOption.DESCENDING;
			}
			
			String tableBaseName = BrowseIndexManager.getItemBrowseIndex().getTableBaseName();
			
			return new BrowseIndexMetadata(number, name, displayType, defaultOrder, tableBaseName, 
										   metadataAll, metadata, datatype);
		}
		else
		{
			return null;
		}
    }
    
    BrowseIndexMetadata(int number, String name, String displayType, String defaultOrder, String tableBaseName, 
    					String metadataAll, String[] metadata, String datatype)
	{
    	super(number, name, displayType, defaultOrder, tableBaseName);

    	this.metadataAll = metadataAll;
        this.metadata = metadata;
        this.datatype = datatype;
	}
	
    
    /**
	 * @return Returns the datatype.
	 */
	public String getDataType()
	{
		return datatype;
	}

    /**
     * @return Returns the number of metadata fields for this index
     */
    public int getMetadataCount()
    {
    	return metadata.length;
    }

	/**
	 * @return Returns the metadata.
	 */
	public String getMetadata()
	{
        return metadataAll;
	}

    public String getMetadata(int idx)
    {
        return metadata[idx];
    }

    /**
	 * @return Returns the mdBits.
	 */
	public String[] getMdBits(int idx)
	{
		return mdBits[idx];
	}

	/**
	 * Populate the internal array containing the bits of metadata, for
	 * ease of use later
	 */
	public void generateMdBits()
    {
    	try
    	{
    		mdBits = new String[metadata.length][];
    		for (int i = 0; i < metadata.length; i++)
    		{
    			mdBits[i] = interpretField(metadata[i], null);
    		}
        }
    	catch(IOException e)
    	{
    		// it's not obvious what we really ought to do here
    		//log.error("caught exception: ", e);
    	}
    }
    
    public String getSortField(boolean isSecondLevel) throws BrowseException
    {
        if (!isSecondLevel)
        {
            return "sort_value";
        }
        else
        {
            return "sort_1";  // Use the first sort column
        }
    }

	public SortOption getSortOptionDefault()
	{
        String type = ("date".equals(datatype) ? "date" : "text");
        SortOption sortOption = null;
		try {
			sortOption = new SortOption(0, getName(), getMetadata(0), type);
		} catch (SortException e) {
		}
        return sortOption;
	}

	public boolean isIndexBrowse()
	{
		return true;
	}
	
	/**
	 * Is the browse index authority value?
	 *
	 * @return true if authority, false if not
	 */
	public boolean isAuthorityIndex() {
	    return "metadataAuthority".equals(displayType);
	}

}
