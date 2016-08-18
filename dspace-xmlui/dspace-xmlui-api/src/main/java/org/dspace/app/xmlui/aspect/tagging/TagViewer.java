package org.dspace.app.xmlui.aspect.tagging;

import java.io.Serializable;
import java.sql.SQLException;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.Map;

import org.apache.cocoon.environment.ObjectModelHelper;
import org.apache.cocoon.environment.Request;
import org.apache.cocoon.util.HashUtil;
import org.apache.excalibur.source.SourceValidity;
import org.dspace.app.xmlui.cocoon.AbstractDSpaceTransformer;
import org.dspace.app.xmlui.utils.DSpaceValidity;
import org.dspace.app.xmlui.utils.HandleUtil;
import org.dspace.app.xmlui.wing.Message;
import org.dspace.app.xmlui.wing.WingException;
import org.dspace.app.xmlui.wing.element.Body;
import org.dspace.app.xmlui.wing.element.Division;
import org.dspace.app.xmlui.wing.element.Highlight;
import org.dspace.app.xmlui.wing.element.Para;
import org.dspace.app.xmlui.wing.element.TextArea;
import org.dspace.browse.BrowseItem;
import org.dspace.content.Collection;
import org.dspace.content.Community;
import org.dspace.content.DSpaceObject;
import org.dspace.content.Item;
import org.dspace.eperson.EPerson;

public class TagViewer extends AbstractDSpaceTransformer {

	private static final Message T_collection_byfreq = AbstractDSpaceTransformer.message("xmlui.Tagging.TaggingUI.collection_byfreq");
	private static final Message T_collection_alpha = AbstractDSpaceTransformer.message("xmlui.Tagging.TaggingUI.collection_alpha");
	private static final Message T_item_byfreq = AbstractDSpaceTransformer.message("xmlui.Tagging.TaggingUI.item_byfreq");
	private static final Message T_item_alpha = AbstractDSpaceTransformer.message("xmlui.Tagging.TaggingUI.item_alpha");
	private static final Message T_person_collection_byfreq = AbstractDSpaceTransformer.message("xmlui.Tagging.TaggingUI.person_collection_byfreq");
	private static final Message T_person_collection_alpha = AbstractDSpaceTransformer.message("xmlui.Tagging.TaggingUI.person_collection_alpha");
	private static final Message T_person_item_byfreq = AbstractDSpaceTransformer.message("xmlui.Tagging.TaggingUI.person_item_byfreq");
	private static final Message T_person_item_alpha = AbstractDSpaceTransformer.message("xmlui.Tagging.TaggingUI.person_item_alpha");
	private static final Message T_edit_tags = AbstractDSpaceTransformer.message("xmlui.Tagging.TaggingUI.edit_tags");
	private static final Message T_tags = AbstractDSpaceTransformer.message("xmlui.Tagging.TaggingUI.tags");

	private boolean isEnabled() 
	{
		return TagUtils.enable;
	}
	
	private Integer tagLimit()
	{
		return TagUtils.tagLimit;
	}
	
	private boolean useAlpha()
	{
		return TagUtils.useAlpha;
	}
	
	private boolean useSingle()
	{
		return TagUtils.useSingle;
	}
	
    /** Cached validity object */
    private SourceValidity validity;
    
    /**
     * Generate the unique caching key.
     * This key must be unique inside the space of this component.
     */
    public Serializable getKey() {
        try {
            DSpaceObject dso = HandleUtil.obtainHandle(objectModel);
            
            if (dso == null)
                return "0"; // no item, something is wrong
            
            return HashUtil.hash(dso.getHandle()+"tags");
        } 
        catch (SQLException sqle)
        {
            // Ignore all errors and just return that the component is not cachable.
            return "0";
        }
    }

    /**
     * Generate the cache validity object.
     * 
     * This validity object includes the community being viewed, all 
     * sub-communites (one level deep), all sub-collections, and 
     * recently submitted items.
     */
    public SourceValidity getValidity() 
    {
        if (this.validity == null)
    	{
	        try {
	            DSpaceObject dso = HandleUtil.obtainHandle(objectModel);
	            
	            DSpaceValidity validity = new DSpaceValidity();
	            validity.add(dso);
	            	            
	            for (Map.Entry<String, Integer> tagcount : TagUtils.getAllTags(objectModel).entrySet())
	            {
	            	validity.add(tagcount.getKey());
	            	validity.add(tagcount.getValue().toString());
	            }
	            for (Map.Entry<String, Integer> tagcount : TagUtils.getEPersonTags(objectModel).entrySet())
	            {
	            	validity.add(tagcount.getKey());
	            	validity.add(tagcount.getValue().toString());
	            }
	            
	            this.validity = validity.complete();
	        } 
	        catch (Exception e)
	        {
	            // Ignore all errors and invalidate the cache.
	        }

    	}
        return this.validity;
    }

    @Override
	public void addBody(Body body) throws WingException, SQLException {

		if (isEnabled())
		{
			Request request = ObjectModelHelper.getRequest(objectModel);
			Map<String,String> params = new HashMap<String,String>(request.getParameters());

			DSpaceObject dso = HandleUtil.obtainHandle(objectModel);

			boolean isItem = dso instanceof Item;
			boolean canEdit = eperson != null && isItem;

			String handleURL = contextPath + ((dso == null)? "" : "/handle/" + dso.getHandle());

			Division sidebar = body.addDivision("sidebar","sidebar");

			Division div = sidebar.addDivision("item-tags","tag");

			Map<String,Integer> alltags = TagUtils.getTags(context, dso, null, useAlpha());
			showTags(div, alltags, getMessage(false, isItem, useAlpha()), handleURL, params, isItem, null);

			if (eperson != null)
			{
				Map<String,Integer> epersontags = TagUtils.getTags(context, dso, eperson, useAlpha());        
				showTags(div, epersontags, getMessage(true, isItem, useAlpha()), handleURL, params, isItem, eperson);
				if (canEdit)
				{
					showTagForm(div, epersontags, handleURL, params, useSingle());
				}
			}
		}
	}
	
	private void showTags(Division div, Map<String, Integer> tags, Message message, 
			String fullurl, Map<String,String> params, boolean isItem, EPerson eperson) throws WingException {
		
		boolean showCounts = !isItem || eperson == null;
		String stemURL = isItem? contextPath : fullurl;
		String allURL = stemURL + "/browse?type=tag" + (eperson != null? ("&eperson="+eperson.getID()) : ""); // if we can manager to insert an browse all (my) tags link
		String tagURL = allURL + (eperson != null? ("&zeperson="+eperson.getID()) : "") + "&ztype=tag&value=";
		
		Division tagsdiv = div.addDivision("tags-"+message.getKey()); // to uniquify
		tagsdiv.setHead(message);
		Para para = tagsdiv.addPara();
		
		int limit = ("all".equals(params.get("show_tags")))? -1 : tagLimit();
		
		int numtags = tags.size();
		if (numtags == 0)
		{
			para.addHighlight("italic").addContent("no tags");
		}
		else
		{
			int n = 0;
			for (Map.Entry<String,Integer> entry : tags.entrySet())
			{
				if (n != 0)
					para.addContent(", ");
				if (n == limit)
					break;
				n++;

				para.addXref(tagURL+entry.getKey(),entry.getKey()); // eventually hyperlink
				if (showCounts)
				{
					para.addContent(" ("+entry.getValue()+")");
				}
			}

			if (limit == -1 && numtags > limit) // show less
			{
				Map<String,String> showparams = new LinkedHashMap<String,String>(params);
				showparams.remove("show_tags");
				String showURL = generateURL(fullurl, showparams);
				
				Highlight hi = para.addHighlight("italic");
				hi.addContent(" (");
				hi.addXref(showURL, "show less");
				hi.addContent(")");
			}
			else if (numtags > n) // show more
			{
				Map<String,String> showparams = new LinkedHashMap<String,String>(params);
				showparams.put("show_tags","all");
				String showURL = generateURL(fullurl, showparams);

				Highlight hi = para.addHighlight("italic");
				hi.addContent(" ... (");
				hi.addXref(showURL, "show more");
				hi.addContent(")");
			}
		}
	}

	private void showTagForm(Division div, Map<String, Integer> tags, String url, Map<String, String> params, boolean useSingle) throws WingException {
		Division editdiv = div.addInteractiveDivision("edit-tags", url + "/edit-tags", Division.METHOD_POST);
		editdiv.setHead(T_edit_tags);
		
		for (Map.Entry<String, String> entry : params.entrySet())
		{
			editdiv.addHidden(entry.getKey()).setValue(entry.getValue());
		}
		
		TextArea textarea = editdiv.addPara().addTextArea("tags_edit");
		textarea.setValue(TagUtils.unparseTags(tags, useSingle));
		editdiv.addPara().addButton("edit_tags").setValue("Update Tags");
	}

	private static Message getMessage(boolean eperson, boolean isItem, boolean useAlpha) {
		int flags = (eperson? 4 : 0) + (isItem? 2 : 0) + (useAlpha? 1 : 0);
		switch (flags)
		{
		case 0: return T_collection_byfreq;
		case 1: return T_collection_alpha;
		case 2: return T_item_byfreq;
		case 3: return T_item_alpha;
		case 4: return T_person_collection_byfreq;
		case 5: return T_person_collection_alpha;
		case 6: return T_person_item_byfreq;
		case 7: return T_person_item_alpha;
		default: return null;
		}
	}

    public void recycle()
    {
        // Clear out our item's cache.
        this.validity = null;
        super.recycle();
    }

}
