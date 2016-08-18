package org.dspace.app.xmlui.aspect.bulk;

import java.sql.SQLException;

import org.dspace.app.xmlui.cocoon.AbstractDSpaceTransformer;
import org.dspace.app.xmlui.utils.HandleUtil;
import org.dspace.app.xmlui.wing.Message;
import org.dspace.app.xmlui.wing.WingException;
import org.dspace.app.xmlui.wing.element.Body;
import org.dspace.app.xmlui.wing.element.CheckBox;
import org.dspace.app.xmlui.wing.element.Division;
import org.dspace.app.xmlui.wing.element.List;
import org.dspace.app.xmlui.wing.element.PageMeta;
import org.dspace.app.xmlui.wing.element.Radio;
import org.dspace.content.Collection;
import org.dspace.content.DSpaceObject;

public class GetParameters extends AbstractDSpaceTransformer
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
        DSpaceObject dso = HandleUtil.obtainHandle(objectModel);
        Collection collection = (Collection)dso; // XXX check
        
        String submitURL = contextPath + "/handle/"+collection.getHandle()+"/bulk";

        
        Division div = body.addInteractiveDivision("bulk-import-form", submitURL, Division.METHOD_MULTIPART, null);
        div.setHead(message("xmlui.Bulk.GetParameters.head"));
        
        List form = div.addList("bulk-import-form", List.TYPE_FORM);
        form.setHead(message("xmlui.Bulk.GetParameters.form_head"));
        
        Radio mode = form.addItem().addRadio("mode");
        mode.setLabel(message("xmlui.Bulk.GetParameters.mode"));
        
        mode.addOption(true,"add",message("xmlui.Bulk.GetParameters.add"));
        //mode.addOption("replace",message("xmlui.Bulk.GetParameters.replace"));
        mode.addOption("delete",message("xmlui.Bulk.GetParameters.delete"));
        
        CheckBox test = form.addItem().addCheckBox("test");
        test.setLabel(message("xmlui.Bulk.GetParameters.test"));
        test.setHelp(message("xmlui.Bulk.GetParameters.test_help"));
        test.addOption(true,"true");
        
        CheckBox workflow = form.addItem().addCheckBox("workflow");
        workflow.setLabel(message("xmlui.Bulk.GetParameters.workflow"));
        workflow.setHelp(message("xmlui.Bulk.GetParameters.workflow_help"));
        workflow.addOption(true,"true");
        
        CheckBox template = form.addItem().addCheckBox("template");
        template.setLabel(message("xmlui.Bulk.GetParameters.template"));
        template.setHelp(message("xmlui.Bulk.GetParameters.template_help"));
        template.addOption("true");
        
        form.addItem().addButton("submit").setValue(message("xmlui.Bulk.GetParameters.proceed"));
        
        div.addHidden("continue").setValue(knot.getId()); 
    }
}
