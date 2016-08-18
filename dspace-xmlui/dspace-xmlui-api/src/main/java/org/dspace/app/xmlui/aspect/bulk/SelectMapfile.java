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

public class SelectMapfile extends AbstractDSpaceTransformer
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
        File[] mapfiles = logic.mapfiledir.listFiles(new FileFilter() {
            public boolean accept(File f) {
                return f.isFile() && f.getName().endsWith(".mapfile");
            }
        });
         
        // Generate response
        Division div = body.addInteractiveDivision("select-mapfile", submitURL, Division.METHOD_POST, null);
        div.setHead(message("xmlui.Bulk.SelectMapfile.head"));
        
        List form = div.addList("select-mapfile", List.TYPE_FORM);
        form.setHead(message("xmlui.Bulk.SelectMapfile.form_head"));
        
        // XXX if retrying, set the appropriate button
        Radio file = form.addItem().addRadio("mapfile");

        for (File mapfile : mapfiles) {
            file.addOption(mapfile.getName(),mapfile.getName());
        }

        Item button = form.addItem();
        button.addButton("submit").setValue(message("xmlui.Bulk.SelectMapfile.proceed"));
        
        div.addHidden("continue").setValue(knot.getId()); 
        
    }

}
