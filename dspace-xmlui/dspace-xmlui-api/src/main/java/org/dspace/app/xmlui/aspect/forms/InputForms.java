package org.dspace.app.xmlui.aspect.forms;

import java.sql.SQLException;
import java.util.Map;
import java.util.Set;

import org.apache.cocoon.environment.ObjectModelHelper;
import org.apache.cocoon.environment.Request;
import org.dspace.app.xmlui.cocoon.AbstractDSpaceTransformer;
import org.dspace.app.xmlui.utils.HandleUtil;
import org.dspace.app.xmlui.wing.Message;
import org.dspace.app.xmlui.wing.WingException;
import org.dspace.app.xmlui.wing.element.Body;
import org.dspace.app.xmlui.wing.element.Cell;
import org.dspace.app.xmlui.wing.element.Division;
import org.dspace.app.xmlui.wing.element.Highlight;
import org.dspace.app.xmlui.wing.element.PageMeta;
import org.dspace.app.xmlui.wing.element.Para;
import org.dspace.app.xmlui.wing.element.Row;
import org.dspace.app.xmlui.wing.element.Select;
import org.dspace.app.xmlui.wing.element.Table;
import org.dspace.app.xmlui.wing.element.Text;
import org.dspace.content.DSpaceObject;

public class InputForms extends BaseForm {

    private static final Message T_dspace_home = message("xmlui.general.dspace_home");  
	private static final Message T_title = message("xmlui.Forms.InputForms.title");
	private static final Message T_head = message("xmlui.Forms.InputForms.head");
	private static final Message T_return = message("xmlui.Forms.InputForms.return");
	private static final Message T_add_new_form = message("xmlui.Forms.InputForms.add");
	private static final Message T_create_form = message("xmlui.Forms.InputForms.create");
	private static final Message T_from_scratch = message("xmlui.Forms.InputForms.from_scratch");
	private static final Message T_or = message("xmlui.Forms.InputForms.or");
	private static final Message T_based_on = message("xmlui.Forms.InputForms.based_on");
	private static final Message T_input_forms = message("xmlui.Forms.InputForms.input_forms");
	private static final Message T_edit = message("xmlui.Forms.InputForms.edit");
	private static final Message T_default = message("xmlui.Forms.InputForms.default");
	private static final Message T_make_default = message("xmlui.Forms.InputForms.make_default");
	private static final Message T_delete = message("xmlui.Forms.InputForms.delete");

    @Override
	public void addPageMeta(PageMeta pageMeta) throws SQLException, WingException {
        DSpaceObject dso = HandleUtil.obtainHandle(objectModel);

        pageMeta.addMetadata("title").addContent(T_title);

		pageMeta.addTrailLink(contextPath + "/",T_dspace_home);
		HandleUtil.buildHandleTrail(dso,pageMeta,contextPath);
		pageMeta.addTrail().addContent(T_title);
	}

	@Override
	public void addBody(Body body) throws SQLException, WingException {

		Request request = ObjectModelHelper.getRequest(objectModel);

        InputFormsAction action = (InputFormsAction)request.getAttribute("action");
        Set<String> inputForms = action.getInputFormNames();
        String defaultForm = action.getDefaultForm();             
        
        String submitURL = contextPath + "/forms/input-forms";

        errors = action.getErrors();
        
        Division div = body.addDivision("edit-input-forms-page", "primary");
        div.setHead(T_head);

        Division formdiv = div.addInteractiveDivision("edit-input-forms-form", submitURL, Division.METHOD_POST, null);
        //formdiv.setHead("");
        formdiv.addHidden("continue").setValue(knot.getId());

        Para formpara = formdiv.addPara();
        formpara.addButton("cancel").setValue(T_return);

        maybeErrorHeading(formdiv);
        
        // new lists
        Division adddiv = formdiv.addDivision("add-input-forms-form", "secondary");
        adddiv.setHead(T_add_new_form);

        Para newpara = adddiv.addPara();
        newpara.addContent(T_create_form);
        newpara.addContent(" ");
        Text name = newpara.addText("name");
        name.setValue(action.getParameter("name"));
        maybeError(newpara, "name");
        
        Para newpara2 = adddiv.addPara();
        newpara2.addButton("new").setValue(T_from_scratch);
        newpara2.addContent(" ");
        newpara2.addContent(T_or);
        newpara2.addContent(" ");
        newpara2.addButton("copy").setValue(T_based_on);
        Select base = newpara2.addSelect("base");
        String basedOn = action.getParameter("base");
        for (String formName : inputForms)
        {
        	base.addOption(formName.equals(basedOn), formName, formName);
        }
        maybeError(newpara2, "base");

        // edit forms
        if (!inputForms.isEmpty())
        {
        	Division formsdiv = formdiv.addDivision("edit-input-forms","secondary");
	        formsdiv.setHead(T_input_forms);
	        
	        String formURL = contextPath + "/forms/input-form" + "?continue=" + knot.getId();
	                
	        Table formtable = formsdiv.addTable("edit-input-forms-table", 1, 4);
	
	        for (String formName : inputForms)
	        {
	        	String encodedName = URLEncode(formName);
	        	Row row = formtable.addRow(Row.ROLE_DATA);        	
	        	
	        	boolean isDefault = formName.equals(defaultForm);
	        	
	        	Cell namecell = row.addCell();
	        	if (isDefault)
	        	{
	        		namecell.addHighlight("bold").addContent(formName);
	        	}
	        	else
	        	{
	        		namecell.addContent(formName);
	        	}
	        	
	        	row.addCell().addXref(formURL + "&base=" + encodedName).addContent(T_edit);
	        	
	        	Cell defaultCell = row.addCell();
	        	if (isDefault)
	        	{
	        		Highlight hi = defaultCell.addHighlight("bold");
	        		hi.addContent("\u00a0 ");
	        		hi.addContent(T_default);
	        	}
	        	else
	        	{
	        		defaultCell.addButton("default"+encodedName,"link").setValue(T_make_default);
	        	}
	        	row.addCell().addButton("remove"+encodedName,"link").setValue(T_delete);
	        }
        }

	}
    
}
