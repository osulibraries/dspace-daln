package org.dspace.app.xmlui.aspect.tagging;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.HashSet;
import java.util.Map;
import java.util.Set;

import javax.servlet.http.HttpServletResponse;

import org.apache.avalon.framework.parameters.Parameters;
import org.apache.cocoon.acting.AbstractAction;
import org.apache.cocoon.environment.ObjectModelHelper;
import org.apache.cocoon.environment.Redirector;
import org.apache.cocoon.environment.Request;
import org.apache.cocoon.environment.SourceResolver;
import org.apache.cocoon.environment.http.HttpEnvironment;
import org.dspace.app.xmlui.cocoon.AbstractDSpaceTransformer;
import org.dspace.app.xmlui.utils.ContextUtil;
import org.dspace.app.xmlui.utils.HandleUtil;
import org.dspace.app.xmlui.utils.UIException;
import org.dspace.app.xmlui.wing.WingException;
import org.dspace.content.DSpaceObject;
import org.dspace.content.Item;
import org.dspace.core.Context;
import org.dspace.eperson.EPerson;

public class TagAction extends AbstractAction {

	public Map act(Redirector redirector, SourceResolver resolver,
			Map objectModel, String source, Parameters parameters)
			throws Exception 
	{
		if (TagUtils.enable)
		{
			Context context = ContextUtil.obtainContext(objectModel);

			HttpServletResponse response = (HttpServletResponse)objectModel.get(HttpEnvironment.HTTP_RESPONSE_OBJECT);
			
			Request request = ObjectModelHelper.getRequest(objectModel);
			Map<String,String> params = new HashMap<String,String>(request.getParameters());

			DSpaceObject dso = HandleUtil.obtainHandle(objectModel);

			EPerson eperson = context.getCurrentUser();

	        String contextPath = request.getContextPath();
	        if (contextPath == null)
	        	contextPath = "/";

			boolean isItem = dso instanceof Item;
			boolean canEdit = eperson != null && isItem;

			if (canEdit)
			{
				Item item = (Item)dso;
				String newTagsRaw = params.get("tags_edit");
				if (newTagsRaw != null)
				{
					Set<String> newTags = TagUtils.parseTags(AbstractDSpaceTransformer.URLDecode(newTagsRaw), TagUtils.useSingle);
					Set<String> oldTags = TagUtils.getTags(context, item, eperson, false).keySet();

					Set<String> toAdd = new HashSet<String>(newTags);
					toAdd.removeAll(oldTags);
					Set<String> toRemove = new HashSet<String>(oldTags);
					toRemove.removeAll(newTags);

					for (String tag_name : toAdd)
					{
						TagManager.add(context, eperson, item, tag_name);
					}
					for (String tag_name : toRemove)
					{
						TagManager.delete(context, eperson, item, tag_name);			
					}
				}

				params.remove("tags_edit");
				params.remove("edit_tags");

				String url = AbstractDSpaceTransformer.generateURL(contextPath + "/handle/" + dso.getHandle(), params);

				response.sendRedirect(url);
			}
		}

		return new HashMap();
	}

}
