package org.dspace.app.xmlui.aspect.deposit;

import java.sql.SQLException;
import java.util.List;

import org.apache.cocoon.environment.ObjectModelHelper;
import org.apache.cocoon.environment.Request;
import org.apache.cocoon.servlet.multipart.Part;
import org.dspace.app.xmlui.cocoon.AbstractDSpaceTransformer;
import org.dspace.app.xmlui.utils.ContextUtil;
import org.dspace.app.xmlui.wing.Message;
import org.dspace.app.xmlui.wing.WingException;
import org.dspace.app.xmlui.wing.element.Body;
import org.dspace.app.xmlui.wing.element.Division;
import org.dspace.app.xmlui.wing.element.File;
import org.dspace.app.xmlui.wing.element.PageMeta;
import org.dspace.app.xmlui.wing.element.Para;
import org.dspace.app.xmlui.wing.element.Row;
import org.dspace.app.xmlui.wing.element.Select;
import org.dspace.app.xmlui.wing.element.Table;
import org.dspace.content.Collection;
import org.dspace.core.Context;

public class Deposit extends AbstractDSpaceTransformer {

    private static final Message T_dspace_home = message("xmlui.general.dspace_home");
    private static final Message T_title = message("xmlui.Deposit.Deposit.title");
    private static final Message T_head = message("xmlui.Deposit.Deposit.head");
    private static final Message T_no_collections = message("xmlui.Deposit.Deposit.no_collections");
    private static final Message T_contact = message("xmlui.Deposit.Deposit.contact");
    private static final Message T_deposit = message("xmlui.Deposit.Deposit.deposit");
    private static final Message T_depositing = message("xmlui.Deposit.Deposit.depositing");
    private static final Message T_new_file = message("xmlui.Deposit.Deposit.new_file");
    private static final Message T_upload = message("xmlui.Deposit.Deposit.upload");
    private static final Message T_files = message("xmlui.Deposit.Deposit.files");
    private static final Message T_remove = message("xmlui.Deposit.Deposit.remove");
    private static final Message T_submit_all = message("xmlui.Deposit.Deposit.submit_all");
    private static final Message T_rights_head = message("xmlui.Deposit.Deposit.rights_head");
    private static final Message T_rights = message("xmlui.Deposit.Deposit.rights");

	public void addPageMeta(PageMeta pageMeta) throws WingException {
		pageMeta.addMetadata("title").addContent(T_title);
		
		pageMeta.addTrailLink(contextPath + "/",T_dspace_home);
		pageMeta.addTrail().addContent(T_title);
	}
	
	public void addBody(Body body) throws WingException, SQLException {

		Context context = ContextUtil.obtainContext(objectModel);
		Request request = ObjectModelHelper.getRequest(objectModel);

        DepositLogic logic = (DepositLogic)request.getAttribute("logic");
        
        String submitURL = contextPath + "deposit";
        
        Division div = body.addDivision("deposit", "primary");
        div.setHead(T_head);
        
        Division formdiv = div.addInteractiveDivision("deposit-form", submitURL, Division.METHOD_MULTIPART);
        formdiv.addHidden("continue").setValue(knot.getId());
        
        Collection collection = logic.getCollection();
        if (collection == null)
        {
        	List<Collection> collections = logic.getValidCollections(context);
        	
        	if (collections.isEmpty())
        	{
        		formdiv.addPara().addContent(T_no_collections);
        		formdiv.addPara().addContent(T_contact);
        		return;
        	}
        	
            Para collpara = formdiv.addPara();
        	collpara.addContent(T_deposit);
        	Select select = collpara.addSelect("collection");
        	
        	for (Collection coll : collections)
        	{
        		select.addOption(coll.getID(), coll.getName());
        	}
        	
        }
        else 
        {
            Para collpara = formdiv.addPara();
        	collpara.addContent(T_depositing.parameterize(collection.getName()));
        }

        Para newpara = formdiv.addPara();
        newpara.addContent(T_new_file);
        newpara.addFile("file","deposit"); 
        newpara.addButton("upload").setValue(T_upload);
        
    	int numSubmissions = logic.getNumSubmissions(); 
    	if (numSubmissions > 0)
    	{
    		Table uploadtable = formdiv.addTable("upload-table", 1, 4);
    		uploadtable.setHead(T_files);
    		for (int i = 0; i < numSubmissions; i++)
    		{
    			Part part = logic.getSubmission(i);
    			Row row = uploadtable.addRow(Row.ROLE_DATA);
    			row.addCell().addContent(part.getFileName());
    			row.addCell().addContent(part.getMimeType());
    			row.addCell().addContent(part.getSize());
    			row.addCell().addButton("remove"+i,"link").setValue(T_remove);
    		}
    	}
    	
		formdiv.addPara().addButton("submit").setValue(T_submit_all);
		
		Para rightsPara = formdiv.addPara();
		rightsPara.addHighlight("bold").addContent(T_rights_head);
		rightsPara.addContent(T_rights);
	}

}
