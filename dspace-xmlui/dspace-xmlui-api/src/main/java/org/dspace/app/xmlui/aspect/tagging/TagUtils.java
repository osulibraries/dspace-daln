package org.dspace.app.xmlui.aspect.tagging;

import java.sql.SQLException;
import java.util.HashSet;
import java.util.Map;
import java.util.Set;
import java.util.TreeMap;

import org.dspace.app.xmlui.utils.ContextUtil;
import org.dspace.app.xmlui.utils.HandleUtil;
import org.dspace.content.DSpaceObject;
import org.dspace.core.ConfigurationManager;
import org.dspace.core.Context;
import org.dspace.eperson.EPerson;

import edu.emory.mathcs.backport.java.util.Arrays;

public class TagUtils {
	
	// configuration (stand-ins for now)
	public static boolean useAlpha = false;
	public static boolean useSingle = true;
	public static Integer tagLimit = 10;
	
    public static boolean enable = ConfigurationManager.getBooleanProperty("tags.enable", false);
	    
	public static Map<String,Integer> getTags(Context context, DSpaceObject focus, EPerson eperson, boolean useAlpha) throws SQLException
	{
		Map<String,Integer> counts = TagManager.getTagCounts(context, focus, eperson);
		return useAlpha? counts : new TreeMap<String,Integer>(counts);
	}

	public static String unparseTags(Map<String, Integer> tags, boolean useSingle) 
	{
		String s = "";
		boolean isFirst = true;
		for (String tag : tags.keySet())
		{
			if (!isFirst)
			{
				s += useSingle? " " : ",";
			}
			isFirst = false;
			s += tag;
		}
		return s;
	}
	
	public static Set<String> parseTags(String tagsRaw, boolean useSingle) {
		String[] tags = tagsRaw.split(useSingle? "\\s+" : ",\\s*");
		return new HashSet<String>(Arrays.asList(tags));		
	}

	// for caching purposes, until we abolish caching
	public static Map<String,Integer> getAllTags(Map objectModel) throws SQLException {
        Context context = ContextUtil.obtainContext(objectModel);
        DSpaceObject dso = HandleUtil.obtainHandle(objectModel);
        return getTags(context, dso, null, useAlpha);
	}

	// for caching purposes, until we abolish caching
	public static Map<String,Integer> getEPersonTags(Map objectModel) throws SQLException {
        Context context = ContextUtil.obtainContext(objectModel);
        EPerson eperson = context.getCurrentUser();
        DSpaceObject dso = HandleUtil.obtainHandle(objectModel);
        return getTags(context, dso, eperson, useAlpha);
	}


}
