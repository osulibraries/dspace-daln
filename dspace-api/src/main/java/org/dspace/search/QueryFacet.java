package org.dspace.search;

import java.util.ArrayList;
import java.util.Collections;
import java.util.Comparator;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class QueryFacet {

	private String field; //query field
	
	private Map<String,Integer> counts; // value, count
	
	private List<String> orderedCounts = null; // values by count
	
	public QueryFacet(String field) 
	{
		this.field = field;
		counts = new HashMap<String,Integer>();
	}
	
	public String getField()
	{
		return field;
	}
	
	public void addItem(String item) 
	{
		Integer count = counts.get(item);
		if (count == null) {
			count = 0;
		}
		counts.put(item, count+1);
	}
	
	public Integer getCount(String item)
	{
		return counts.get(item);
	}
	
	public List<String> getItems() 
	{
		if (orderedCounts != null)
			return orderedCounts;
		
		orderedCounts = new ArrayList<String>(counts.keySet());
		
		Collections.sort(orderedCounts, new Comparator<String>() {
			public int compare(String o1, String o2) 
			{
				int result = getCount(o2) - getCount(o1); // descending order
				if (result == 0)
				{
					result = o1.compareTo(o2); // lexicographic ordering
				}
				return result;
			}
		});
		
		return orderedCounts;
	}
	
}
