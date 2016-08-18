package org.dspace.app.xmlui.aspect.bulk;

import java.io.File;
import java.io.FileFilter;
import java.sql.SQLException;

import org.apache.cocoon.environment.ObjectModelHelper;
import org.apache.cocoon.environment.Request;
import org.dspace.app.xmlui.cocoon.AbstractDSpaceTransformer;
import org.dspace.app.xmlui.utils.HandleUtil;
import org.dspace.app.xmlui.wing.Message;
import org.dspace.app.xmlui.wing.WingException;
import org.dspace.app.xmlui.wing.element.Body;
import org.dspace.app.xmlui.wing.element.Division;
import org.dspace.app.xmlui.wing.element.Item;
import org.dspace.app.xmlui.wing.element.List;
import org.dspace.app.xmlui.wing.element.PageMeta;
import org.dspace.app.xmlui.wing.element.Radio;
import org.dspace.content.Collection;
import org.dspace.content.DSpaceObject;

public class SelectUpload extends AbstractDSpaceTransformer
{    
    protected static final Message T_dspace_home = message("xmlui.general.dspace_home");  
    protected static final Message T_bulk_import = message("xmlui.Bulk.import");  
	
	public void addPageMeta(PageMeta pageMeta) throws SQLException, WingException
	{
        DSpaceObject dso = HandleUtil.obtainHandle(objectModel);

        pageMeta.addMetadata("title").addContent(T_bulk_import);

		pageMeta.addTrailLink(contextPath + "/",T_dspace_home);
		HandleUtil.buildHandleTrail(dso,pageMeta,contextPath);
		pageMeta.addTrail().addContent(T_bulk_import);
	}

    public void addBody(Body body) throws SQLException, WingException 
    {
        // Boilerplate
        Request request = ObjectModelHelper.getRequest(objectModel);
        BulkLogic logic = (BulkLogic)request.getAttribute("logic");

        DSpaceObject dso = HandleUtil.obtainHandle(objectModel);
        Collection collection = (Collection)dso; // XXX check
        
        String submitURL  = contextPath + "/handle/" + collection.getHandle() + "/bulk";
        
        // Find appropriate files
        File[] subdirs = logic.uploaddir.listFiles(new FileFilter() {
            public boolean accept(File f) { return f.isDirectory(); }
        });
            
        File[] zipfiles = logic.uploaddir.listFiles(new FileFilter() {
           public boolean accept(File f) {
               return f.isFile() && f.getName().endsWith(".zip");
           }
        });

        // Generate response
        Division div = body.addInteractiveDivision("select-bulk-upload", submitURL, Division.METHOD_POST, null);
        div.setHead(message("xmlui.Bulk.SelectUpload.head"));
        
        List form = div.addList("select-bulk-upload", List.TYPE_FORM);
        form.setHead(message("xmlui.Bulk.SelectUpload.form_head"));

        // XXX if retrying, set the appropriate button        
        Radio upload = form.addItem().addRadio("upload");        
        upload.setRequired();
        
        for (File subdir : subdirs) {
            upload.addOption(subdir.getName(),subdir.getName());
        }
        
        for (File zipfile : zipfiles) {
            upload.addOption(zipfile.getName(),zipfile.getName());
        }

        Item buttons = form.addItem();
        if (logic.isAdd) {
            buttons.addButton("submit").setValue(message("xmlui.Bulk.SelectUpload.new"));
            buttons.addButton("resume").setValue(message("xmlui.Bulk.SelectUpload.resume"));
        }
        else {
            buttons.addButton("submit").setValue(message("xmlui.Bulk.SelectUpload.proceed"));
        }
        
        div.addHidden("continue").setValue(knot.getId()); 

    }

}
