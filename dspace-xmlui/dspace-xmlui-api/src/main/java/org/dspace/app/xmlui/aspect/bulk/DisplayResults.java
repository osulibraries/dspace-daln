package org.dspace.app.xmlui.aspect.bulk;

import java.sql.SQLException;

import org.apache.cocoon.environment.ObjectModelHelper;
import org.apache.cocoon.environment.Request;
import org.dspace.app.xmlui.cocoon.AbstractDSpaceTransformer;
import org.dspace.app.xmlui.utils.HandleUtil;
import org.dspace.app.xmlui.wing.Message;
import org.dspace.app.xmlui.wing.WingException;
import org.dspace.app.xmlui.wing.element.Body;
import org.dspace.app.xmlui.wing.element.Division;
import org.dspace.app.xmlui.wing.element.PageMeta;
import org.dspace.app.xmlui.wing.element.Para;
import org.dspace.content.Collection;
import org.dspace.content.DSpaceObject;

public class DisplayResults extends AbstractDSpaceTransformer
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
        Request request = ObjectModelHelper.getRequest(objectModel);
        BulkLogic logic = (BulkLogic)request.getAttribute("logic");

        DSpaceObject dso = HandleUtil.obtainHandle(objectModel);
        Collection collection = (Collection)dso; // XXX check
        
        String submitURL  = contextPath + "/handle/" + collection.getHandle() + "/bulk";
        String mapfileURL = contextPath + "/static/files/bulk/mapfiles/" + logic.mapFile.getName();
        
        boolean ok = logic.errmsgs.isEmpty();
        boolean done = logic.importdone;
        boolean test = logic.isTest;

        //String rawoutput = new String(logic.output.toByteArray());
        
        Message resultCount = message("xmlui.Bulk.DisplayResults.result_count");
        resultCount = resultCount.parameterize(String.valueOf(logic.importer.count), String.valueOf(logic.importer.total));

        // XXX this is subject to a race condition...
        // is should really be dependent on whether displayResults of displayResultsDone is called
        // perhaps by a parameter
        if (!done) { // display progress
            Message message = null;
            if (logic.isAdd) {
                message = (logic.isResume)? message("xmlui.Bulk.DisplayResults.resuming") : 
                							message("xmlui.Bulk.DisplayResults.adding");
            }
            else if (logic.isReplace) {
                message = message("xmlui.Bulk.DisplayResults.replacing");
            }
            else if (logic.isDelete) {
                message = message("xmlui.Bulk.DisplayResults.deleting");
            }
            
            Message header = test? message("xmlui.Bulk.DisplayResults.testing") : 
            					   message("xmlui.Bulk.DisplayResults.processing");

            Division div = body.addDivision("bulk-import-results");
            div.setHead(header);

            Para p = div.addPara();
            p.addContent("\u00a0"); // placeholder for final status
            Division flat = div.addDivision("results","flat");
            flat.addPara().addContent(message);
            flat.addDivision("progress").addPara().addContent(resultCount);
            for (String line : logic.errmsgs) {
                div.addPara().addContent(line);
            }
            
            div.addPara().addContent(message("xmlui.Bulk.DisplayResults.wait"));

            Division submit = body.addInteractiveDivision("bulk-import-form", submitURL, Division.METHOD_POST,"");
            submit.addPara().addButton("submit-cancel").setValue(message("xmlui.Bulk.DisplayResults.cancel"));
            submit.addHidden("continue").setValue(knot.getId());
            
        }
        else { // display results
            Message message = null;
            if (logic.isAdd) {
                message = (logic.isResume)? message("xmlui.Bulk.DisplayResults.resumed") : 
                							message("xmlui.Bulk.DisplayResults.added");
            }
            else if (logic.isReplace) {
                message = message("xmlui.Bulk.DisplayResults.replaced");
            }
            else if (logic.isDelete) {
                message = message("xmlui.Bulk.DisplayResults.deleted");
            }

            Message header = test? message("xmlui.Bulk.DisplayResults.tested") : 
				                   message("xmlui.Bulk.DisplayResults.processed");
            
        	logic.resultsDisplayed = true;
        	
            Message statustoken = null;
            if (logic.importer.cancelled) {
                statustoken = message("xmlui.Bulk.DisplayResults.cancelled");
            }
            else if (ok) {
                statustoken = message("xmlui.Bulk.DisplayResults.succeeded");
            }
            else {
                statustoken = message("xmlui.Bulk.DisplayResults.failed");
            }
            
            Message status = null;
            if (logic.isTest) {
            	status = message("xmlui.Bulk.DisplayResults.bulk_import_test");
            }
            else {
            	status = message("xmlui.Bulk.DisplayResults.bulk_import");
            }

            Division div = body.addDivision("bulk-import-results");
            div.setHead(header);

            Para p = div.addPara();
            p.addHighlight("bold").addContent(status);
            p.addHighlight("bold").addContent(statustoken);
            Division flat = div.addDivision("results","flat");
            flat.addPara().addContent(message);
            flat.addDivision("done").addPara().addContent(resultCount);
            for (String line : logic.errmsgs) {
                div.addPara().addContent(line);
            }

            if (!test) {
                Division mapfilediv = body.addInteractiveDivision("download-mapfile", mapfileURL, Division.METHOD_GET,"");
                mapfilediv.addPara().addButton("submit").setValue(message("xmlui.Bulk.DisplayResults.download_mapfile"));                    
            }

            Division submit = body.addInteractiveDivision("bulk-import-form", submitURL, Division.METHOD_POST, "");

            if (!ok) {
                submit.addPara().addButton("submit-retry").setValue(message("xmlui.Bulk.DisplayResults.retry"));
            }

            if (test) {
                submit.addPara().addButton("submit-proceed").setValue(message("xmlui.Bulk.DisplayResults.proceed"));
            }

            submit.addPara().addButton("submit-continue").setValue(message("xmlui.Bulk.DisplayResults.return"));            

            submit.addHidden("continue").setValue(knot.getId());                                 
        }
        
    }
    
}
