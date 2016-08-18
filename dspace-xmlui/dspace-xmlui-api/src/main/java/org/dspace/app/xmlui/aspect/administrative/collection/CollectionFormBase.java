package org.dspace.app.xmlui.aspect.administrative.collection;

import java.util.LinkedHashMap;
import java.util.Map;

import org.dspace.app.xmlui.cocoon.AbstractDSpaceTransformer;
import org.dspace.app.xmlui.wing.Message;
import org.dspace.app.xmlui.wing.WingException;
import org.dspace.app.xmlui.wing.element.Division;
import org.dspace.app.xmlui.wing.element.List;

public abstract class CollectionFormBase extends AbstractDSpaceTransformer {

	protected static final Message T_dspace_home = message("xmlui.general.dspace_home");
	
	protected static final Message T_collection_trail = message("xmlui.administrative.collection.general.collection_trail");

	protected static final Message T_main_head = message("xmlui.administrative.collection.EditCollectionMetadataForm.main_head");
	
	protected static final Message T_options_metadata = message("xmlui.administrative.collection.general.options_metadata");	
	protected static final Message T_options_roles = message("xmlui.administrative.collection.general.options_roles");
	protected static final Message T_options_harvest = message("xmlui.administrative.collection.GeneralCollectionHarvestingForm.options_harvest");
	protected static final Message T_options_workflow = message("xmlui.administrative.collection.general.options_workflow");

	protected static Map<Message,String> tabs;
	{
		tabs = new LinkedHashMap<Message,String>();
		tabs.put(T_options_metadata,"submit_metadata");
		tabs.put(T_options_roles, "submit_roles");
		tabs.put(T_options_harvest, "submit_harvesting");
		tabs.put(T_options_workflow, "submit_workflow");
	}
	
	protected String getBaseURL()
	{
		return contextPath + "/admin/collection?administrative-continue=" + knot.getId();
	}
	
	protected void addTabs(Division main, Message currentTab) throws WingException
	{		
	    List options = main.addList("options", List.TYPE_SIMPLE, "horizontal");
	    String baseURL = getBaseURL();
	    for (Map.Entry<Message, String> tab : tabs.entrySet())
	    {
	    	if (tab.getKey() == currentTab)
	    	{
	    	    options.addItem().addHighlight("bold").addXref(baseURL+"&"+tab.getValue(),tab.getKey());   		
	    	}
	    	else
	    	{
	    	    options.addItem().addXref(baseURL+"&"+tab.getValue(),tab.getKey());	    		
	    	}
	    }
	}
	
	
}
