package org.dspace.app.xmlui.aspect.deposit;

import java.io.IOException;
import java.io.InputStream;
import java.sql.SQLException;
import java.util.List;
import java.util.Map;
import java.util.Vector;

import org.apache.cocoon.environment.ObjectModelHelper;
import org.apache.cocoon.environment.Request;
import org.apache.cocoon.servlet.multipart.Part;
import org.dspace.app.xmlui.utils.ContextUtil;
import org.dspace.authorize.AuthorizeException;
import org.dspace.authorize.AuthorizeManager;
import org.dspace.content.Bitstream;
import org.dspace.content.Collection;
import org.dspace.content.FormatIdentifier;
import org.dspace.content.Item;
import org.dspace.content.WorkspaceItem;
import org.dspace.core.Constants;
import org.dspace.core.Context;
import org.dspace.workflow.WorkflowManager;

public class DepositLogic {

	private Collection collection = null;
	
	private Vector<Part> submissions = new Vector<Part>();
	
	
	public Collection getCollection() {
		return collection;
	}

	public int getNumSubmissions()
	{
		return submissions.size();
	}
	
	public Part getSubmission(int n) 
	{
		return submissions.get(n);
	}


	public List<Collection> getValidCollections(Context context) throws SQLException
	{
		List<Collection> collections = new Vector<Collection>();
    	for (Collection coll : Collection.findAll(context))
    	{
    		// XXX is there a better way to do this?
    		if (AuthorizeManager.authorizeActionBoolean(context, coll, Constants.ADD, true))
    		{
    			collections.add(coll);
    		}
    	}
    	return collections;
	}
	
	public boolean processDepositForm(Map objectModel) throws SQLException, AuthorizeException, IOException
	{
		Context context = ContextUtil.obtainContext(objectModel);
		Request request = ObjectModelHelper.getRequest(objectModel);
		
		if (request.getParameter("collection") != null)
		{
			// XXX check authorization ...
			int id = Integer.valueOf(request.getParameter("collection"));
			collection = Collection.find(context, id);
		}
		
		if (request.getParameter("submit") != null)
		{
			getUpload(request); // get a final upload, just in case
			doDeposit(objectModel);
			return true;
		}
		if (request.getParameter("upload") != null)
		{
			getUpload(request);
			return false;
		}

		int num = getNumSubmissions();
		for (int i = 0; i < num; i++)
		{
			if (request.getParameter("remove"+i) != null)
			{
				submissions.remove(i);
				return false;
			}
		}

		return false;
	}
	
	private void getUpload(Request request)
	{
		Part part = (Part)request.get("file");
		if (part != null)
		{
			part.setDisposeWithRequest(false);
			submissions.add(part);
		}		
	}

	private void doDeposit(Map objectModel) throws SQLException, AuthorizeException, IOException
	{
		Context context = ContextUtil.obtainContext(objectModel);
		collection = Collection.find(context, collection.getID()); // refresh collection with new DB connection
		
		for (Part part : submissions)
		{
			WorkspaceItem wsItem = WorkspaceItem.create(context, collection, true);
			Item item = wsItem.getItem();
			InputStream is = part.getInputStream();
            Bitstream b = item.createSingleBitstream(is, "ORIGINAL");
            b.setName(part.getFileName());
            b.setFormat(FormatIdentifier.guessFormat(context, b));
            b.update();
            item.update();
			
			WorkflowManager.start(context, wsItem);
			
			context.commit();
			part.dispose();
		}		
	}

}
