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
import org.dspace.app.xmlui.wing.element.List;
import org.dspace.app.xmlui.wing.element.PageMeta;
import org.dspace.content.Collection;
import org.dspace.content.DSpaceObject;

public class ParamError extends AbstractDSpaceTransformer
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
        
        String submitURL = contextPath + "/handle/"+collection.getHandle()+"/bulk";
                
        Division div = body.addInteractiveDivision("bulk-param-error", submitURL, Division.METHOD_POST, null);
        div.setHead(message("xmlui.Bulk.ParamError.head"));
        
        if (logic != null) {
            for (String err : logic.paramErrors) {
               div.addPara().addContent(message(err));
            }
        }
        
        List form = div.addList("bulk-param-error-form", List.TYPE_FORM);

        form.addItem().addButton("submit").setValue(message("xmlui.Bulk.ParamError.retry"));
        
        div.addHidden("continue").setValue(knot.getId()); 
    }
}
