package org.dspace.app.xmlui.aspect.lists;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.Map;

import org.apache.cocoon.environment.ObjectModelHelper;
import org.apache.cocoon.environment.Request;
import org.dspace.app.xmlui.cocoon.AbstractDSpaceTransformer;
import org.dspace.app.xmlui.utils.HandleUtil;
import org.dspace.app.xmlui.wing.Message;
import org.dspace.app.xmlui.wing.WingException;
import org.dspace.app.xmlui.wing.element.Body;
import org.dspace.app.xmlui.wing.element.Division;
import org.dspace.app.xmlui.wing.element.List;
import org.dspace.app.xmlui.wing.element.Para;
import org.dspace.app.xmlui.wing.element.Select;
import org.dspace.content.DSpaceObject;
import org.dspace.content.Item;

public class ItemSidebar extends AbstractDSpaceTransformer {

	private static final Message T_head = message("xmlui.Lists.ItemSidebar.head");
	private static final Message T_button = message("xmlui.Lists.ItemSidebar.button");
	private static final Message T_cur_head = message("xmlui.Lists.ItemSidebar.cur_head");

	@Override
	public void addBody(Body body) throws WingException, SQLException
	{
		Division sidebar = body.addDivision("sidebar","sidebar");
		
		Request request = ObjectModelHelper.getRequest(objectModel);
		Map<String,String> params = new HashMap<String,String>(request.getParameters());

		DSpaceObject dso = HandleUtil.obtainHandle(objectModel);

		if (dso instanceof Item && eperson != null)
		{
			Division div = sidebar.addDivision("item-lists","tag");

			showListsForm(div, (Item)dso, params);

			showLists(div, (Item)dso);
		}
	}

	private void showLists(Division div, Item item) throws SQLException, WingException
	{
		Map<Integer,String> lists = ListUtils.getListsForItem(context, eperson, item.getID());

		String editURL = contextPath + "/lists/list";
		
		if (lists.size() != 0)
		{
			//Division listsdiv = div.addDivision("curlists");
			List listsdiv = div.addList("curlists",List.TYPE_SIMPLE);
			listsdiv.setHead(T_cur_head);

			for (Map.Entry<Integer, String> entry : lists.entrySet())
			{
				listsdiv.addItem().addXref(editURL + "?base=" + entry.getKey(), entry.getValue());			
			}
		}
	}
	
	private void showListsForm(Division div, Item item, Map<String, String> params) throws WingException, SQLException
	{
		Request request = ObjectModelHelper.getRequest(objectModel);

		String editURL = contextPath + "/lists/item/action";
		
		Division listsdiv = div.addDivision("lists");
		listsdiv.setHead(T_head);
		
		Message status = (Message)request.getSession().getAttribute(ListUtils.STATUS_ATTR);
		if (status != null)
		{
			listsdiv.addPara().addHighlight("error").addContent(status);
			request.getSession().setAttribute(ListUtils.STATUS_ATTR, null);
		}

		Division editdiv = listsdiv.addInteractiveDivision("edit-lists", editURL, Division.METHOD_POST);
		
		editdiv.addHidden("item_id").setValue(item.getID());
		
		for (Map.Entry<String, String> entry : params.entrySet())
		{
			editdiv.addHidden(entry.getKey()).setValue(entry.getValue());
		}
		
		Para para = editdiv.addPara();
		Select lists = para.addSelect("list_id");		
		for (Map.Entry<Integer, String> entry : ListUtils.getLists(context, eperson).entrySet())
		{
			lists.addOption(entry.getKey(), entry.getValue());			
		}
		
		editdiv.addPara().addButton("add").setValue(T_button);		
	}

}
