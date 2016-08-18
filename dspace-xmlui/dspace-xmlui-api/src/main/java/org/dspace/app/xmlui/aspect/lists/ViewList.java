package org.dspace.app.xmlui.aspect.lists;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import org.apache.cocoon.environment.ObjectModelHelper;
import org.apache.cocoon.environment.Request;
import org.dspace.app.xmlui.aspect.forms.BaseForm;
import org.dspace.app.xmlui.wing.Message;
import org.dspace.app.xmlui.wing.WingException;
import org.dspace.app.xmlui.wing.element.Body;
import org.dspace.app.xmlui.wing.element.Cell;
import org.dspace.app.xmlui.wing.element.Division;
import org.dspace.app.xmlui.wing.element.PageMeta;
import org.dspace.app.xmlui.wing.element.Para;
import org.dspace.app.xmlui.wing.element.ReferenceSet;
import org.dspace.app.xmlui.wing.element.Row;
import org.dspace.app.xmlui.wing.element.Table;
import org.dspace.content.Item;
import org.dspace.eperson.EPerson;

// read-only view of list

public class ViewList extends BaseForm {

    private static final Message T_dspace_home = message("xmlui.general.dspace_home");
    private static final Message T_title = message("xmlui.Lists.ViewList.title");
    private static final Message T_head = message("xmlui.Lists.ViewList.head");

    @Override
	public void addPageMeta(PageMeta pageMeta) throws SQLException, WingException {
        pageMeta.addMetadata("title").addContent(T_title);

		pageMeta.addTrailLink(contextPath + "/",T_dspace_home);
		pageMeta.addTrail().addContent(T_title);
	}

	@Override
	public void addBody(Body body) throws SQLException, WingException {

		Request request = ObjectModelHelper.getRequest(objectModel);
		
		Integer list_id = getIntParameter(request.getParameters(), "list_id", -1);
		
		String list_name = ListUtils.checkListShared(context, context.getCurrentUser(), list_id);
		
		if (list_name == null)
			return; // XXX crap out (unauthorized)
		
		EPerson eperson = ListUtils.getListOwner(context, list_id);		
        List<Integer> list = ListUtils.getListItemIDs(context, list_id);
        
        String submitURL = contextPath + "/lists/view-list";

        Division div = body.addDivision("view-list-page", "primary");
        div.setHead(T_head.parameterize(eperson.getEmail(),list_name));

        int numentries = list.size();

        if (numentries > 0)
        {
        	ReferenceSet refset = div.addReferenceSet("list-view", ReferenceSet.TYPE_SUMMARY_LIST);

        	for (Integer item_id : list)
        	{
        		Item item = Item.find(context, item_id);
        		refset.addReference(item);
        	}
        }
	}
    
    public static Integer getIntParameter(Map<String,String> reqparams, String key, int def) {
        try {
            return Integer.parseInt(reqparams.get(key).trim());
        }
        catch (Exception e)
        {
            return def;
        }        
    }    

}
