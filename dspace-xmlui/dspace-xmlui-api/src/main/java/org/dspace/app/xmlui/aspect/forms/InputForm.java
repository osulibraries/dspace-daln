package org.dspace.app.xmlui.aspect.forms;

import java.sql.SQLException;

import org.apache.cocoon.environment.ObjectModelHelper;
import org.apache.cocoon.environment.Request;
import org.dspace.app.util.DCInput;
import org.dspace.app.util.DCInputSet;
import org.dspace.app.xmlui.utils.HandleUtil;
import org.dspace.app.xmlui.wing.Message;
import org.dspace.app.xmlui.wing.WingException;
import org.dspace.app.xmlui.wing.element.Body;
import org.dspace.app.xmlui.wing.element.Cell;
import org.dspace.app.xmlui.wing.element.CheckBox;
import org.dspace.app.xmlui.wing.element.Division;
import org.dspace.app.xmlui.wing.element.Highlight;
import org.dspace.app.xmlui.wing.element.Item;
import org.dspace.app.xmlui.wing.element.List;
import org.dspace.app.xmlui.wing.element.PageMeta;
import org.dspace.app.xmlui.wing.element.Para;
import org.dspace.app.xmlui.wing.element.Row;
import org.dspace.app.xmlui.wing.element.Select;
import org.dspace.app.xmlui.wing.element.Table;
import org.dspace.app.xmlui.wing.element.Text;
import org.dspace.content.DSpaceObject;

public class InputForm extends BaseForm {

    private static final Message T_dspace_home = message("xmlui.general.dspace_home");
    private static final Message T_title = message("xmlui.Forms.InputForm.title");
    private static final Message T_head = message("xmlui.Forms.InputForm.head");
    private static final Message T_save = message("xmlui.Forms.InputForm.save");
    private static final Message T_return = message("xmlui.Forms.InputForm.return");
    private static final Message T_pages = message("xmlui.Forms.InputForm.pages");
    private static final Message T_page = message("xmlui.Forms.InputForm.page");
    private static final Message T_page_edit = message("xmlui.Forms.InputForm.page_edit");
    private static final Message T_page_move_up = message("xmlui.Forms.InputForm.page_move_up");
    private static final Message T_page_move_down = message("xmlui.Forms.InputForm.page_move_down");
    private static final Message T_page_delete = message("xmlui.Forms.InputForm.page_delete");
    private static final Message T_page_add = message("xmlui.Forms.InputForm.page_add");
    private static final Message T_fields = message("xmlui.Forms.InputForm.fields");
    private static final Message T_field_edit = message("xmlui.Forms.InputForm.field_edit");
    private static final Message T_field_move_up = message("xmlui.Forms.InputForm.field_move_up");
    private static final Message T_field_move_down = message("xmlui.Forms.InputForm.field_move_down");
    private static final Message T_field_page_up = message("xmlui.Forms.InputForm.field_page_up");
    private static final Message T_field_page_down = message("xmlui.Forms.InputForm.field_page_down");
    private static final Message T_field_delete = message("xmlui.Forms.InputForm.field_delete");
    private static final Message T_field_add = message("xmlui.Forms.InputForm.field_add");
    private static final Message T_new_field = message("xmlui.Forms.InputForm.new_field");
    private static final Message T_edit_field = message("xmlui.Forms.InputForm.edit_field");
    private static final Message T_tag_element = message("xmlui.Forms.InputForm.tag_element");
    private static final Message T_tag_label = message("xmlui.Forms.InputForm.tag_label");
    private static final Message T_tag_hint = message("xmlui.Forms.InputForm.tag_hint");
    private static final Message T_tag_required = message("xmlui.Forms.InputForm.tag_required");
    private static final Message T_tag_input_type = message("xmlui.Forms.InputForm.tag_input_type");
    private static final Message T_tag_value_list = message("xmlui.Forms.InputForm.tag_value_list");
    private static final Message T_help_value_list = message("xmlui.Forms.InputForm.help_value_list");
    private static final Message T_edit_value_lists = message("xmlui.Forms.InputForm.edit_value_lists");
    private static final Message T_tag_repeatable = message("xmlui.Forms.InputForm.tag_repeatable");
    private static final Message T_tag_visibility = message("xmlui.Forms.InputForm.tag_visibility");
    private static final Message T_vis_workflow = message("xmlui.Forms.InputForm.vis_workflow");
    private static final Message T_vis_submission = message("xmlui.Forms.InputForm.vis_submission");
    private static final Message T_tag_readonly = message("xmlui.Forms.InputForm.tag_readonly");
    private static final Message T_tag_vocabulary = message("xmlui.Forms.InputForm.tag_vocabulary");
    private static final Message T_tag_closed = message("xmlui.Forms.InputForm.tag_closed");
    private static final Message T_save_field = message("xmlui.Forms.InputForm.save_field");
    private static final Message T_cancel = message("xmlui.Forms.InputForm.cancel");
	
    // XXX i18n
    protected static final Object[][] inputTypes = new Object[][]{
    	{message("xmlui.Forms.InputForm.input_name"), "name"},
    	{message("xmlui.Forms.InputForm.input_date"), "date"},
    	{message("xmlui.Forms.InputForm.input_series"), "series"},
    	{message("xmlui.Forms.InputForm.input_onebox"), "onebox"},
    	{message("xmlui.Forms.InputForm.input_textarea"), "textarea"},
    	{message("xmlui.Forms.InputForm.input_dropdown"), "dropdown"},
    	{message("xmlui.Forms.InputForm.input_list"), "list"},
    	{message("xmlui.Forms.InputForm.input_qualdrop"), "qualdrop_value"}, // used for identifiers
    };
    
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

        InputFormAction action = (InputFormAction)request.getAttribute("action");
        errors = action.getErrors();

    	Integer pageedit = action.getCurrentPage();
    	Integer fieldedit = action.getCurrentField(); // -1 = new field        	
        
        DCInputSet inputSet = action.getInputSet();        
        String submitURL = contextPath + "/forms/input-form";

        // main form
        Division div = body.addDivision("edit-input-form", "primary");
        div.setHead(T_head);

        // top-level naming and saving form
        Division formdiv = div.addInteractiveDivision("edit-input-form-form", submitURL, Division.METHOD_POST, null);
        formdiv.setHead("\"" + inputSet.getFormName() + "\"");

        formdiv.addHidden("continue").setValue(knot.getId());
        if (pageedit != null)
        	formdiv.addHidden("curpage").setValue(pageedit);
        if (fieldedit != null)
        	formdiv.addHidden("curfield").setValue(fieldedit);
        
        createSaveForm(formdiv, action);
        if (pageedit != null && fieldedit != null)
        {
        	createFieldForm(formdiv, action);
        }
        createPageTable(formdiv, action);
        if (pageedit != null)
        {
        	createFieldTable(formdiv, action);
        }
	}
	
	private Division createSaveForm(Division div, InputFormAction action) throws WingException
	{
        Para formpara = div.addPara();
        formpara.addButton("save").setValue(T_save);
        formpara.addButton("cancel").setValue(T_return);
        
        return div;
	}
	
	private void createPageTable(Division div, InputFormAction action) throws WingException
	{
        DCInputSet inputSet = action.getInputSet();        
        Integer pageedit = action.getCurrentPage();

        int numpages = inputSet.getNumberPages();

        // edit pages
        Division pagesdiv = div.addDivision("edit-input-form-pages","secondary");
        pagesdiv.setHead(T_pages);
        
        if (numpages > 0)
        {
        	Table pagetable = pagesdiv.addTable("edit-input-form-pages-table", 1, 5);
        	for (int i = 0; i < numpages; i++)
        	{
        		Row row = pagetable.addRow(Row.ROLE_DATA);

        		Cell pagecell = row.addCell();
        		if (pageedit != null && i == pageedit) {
        			pagecell.addHighlight("bold").addContent(T_page.parameterize(i+1));
        		}
        		else
        		{
        			pagecell.addContent(T_page.parameterize(i+1));
        		}

        		row.addCell().addButton("pageedit"+i, "link").setValue(T_page_edit);

        		Cell upcell = row.addCell();
        		if (i > 0)
        		{
        			upcell.addButton("pageup"+i, "link").setValue(T_page_move_up);
        		}

        		Cell downcell = row.addCell();
        		if (i < numpages-1)
        		{
        			downcell.addButton("pagedown"+i, "link").setValue(T_page_move_down);
        		}

        		Cell removecell = row.addCell();
        		if (numpages > 1) // can't delete last page
        		{
        			removecell.addButton("pageremove"+i, "link").setValue(T_page_delete);
        		}
        	}
        }
        pagesdiv.addPara().addButton("pageadd").setValue(T_page_add);
	}

	private void createFieldTable(Division div, InputFormAction action) throws WingException
	{
        // edit fields
        DCInputSet inputSet = action.getInputSet();
        Integer pageedit = action.getCurrentPage();
        Integer fieldedit = action.getCurrentField();

        int numpages = inputSet.getNumberPages();
        int numfields = inputSet.getNumFields(pageedit);

    	Division fieldsdiv = div.addDivision("edit-input-form-fields","secondary");
        fieldsdiv.setHead(T_fields.parameterize(pageedit+1));
     
        if (numfields > 0)
        {
	        Table fieldstable = fieldsdiv.addTable("edit-input-form-fields-table", 1, 7);
	        for (int i = 0; i < numfields; i++)
	        {
	        	DCInput field = inputSet.getField(pageedit, i);
	        	String schema = field.getSchema();
	        	String element = field.getElement();
	        	String qualifier = field.getQualifier();
	        	String fieldname = ((schema != null)? (schema + ".") : "") +
	        						element +
	        						((qualifier != null)? ("." + qualifier) : "");
	        	
	        	Row row = fieldstable.addRow(Row.ROLE_DATA);
	        	
	        	Cell fieldcell = row.addCell(); 
	        	if (fieldedit != null && i == fieldedit)
	        	{
	        		fieldcell.addHighlight("bold").addContent(fieldname);	        		
	        	}
	        	else
	        	{
	        		fieldcell.addContent(fieldname);
	        	}
	
	        	row.addCell().addButton("fieldedit"+i,"link").setValue(T_field_edit);
	        	
	        	Cell upcell = row.addCell();
	        	if (i > 0)
	        	{
	        		upcell.addButton("fieldup"+i,"link").setValue(T_field_move_up);
	        	}
	        	
	        	Cell downcell = row.addCell();
	        	if (i < numfields-1)
	        	{
	        		downcell.addButton("fielddown"+i,"link").setValue(T_field_move_down);
	        	}
	        	
	        	Cell prevcell = row.addCell();
	        	if (pageedit > 0)
	        	{        		
	        		prevcell.addButton("fieldprev"+i,"link").setValue(T_field_page_up);
	        	}
	        	
	        	Cell nextcell = row.addCell();
	        	if (pageedit < numpages-1)
	        	{
	        		nextcell.addButton("fieldnext"+i,"link").setValue(T_field_page_down);
	        	}
	
	        	row.addCell().addButton("fieldremove"+i,"link").setValue(T_field_delete);
	        }
        }
        fieldsdiv.addPara().addButton("fieldadd").setValue(T_field_add);
	}
	
	private void createFieldForm(Division div, InputFormAction action) throws WingException
	{
    	DCInput field = action.getEditField();

        Division fielddiv = div.addDivision("edit-field-form", "secondary");
        fielddiv.setHead(field == null? T_new_field : T_edit_field.parameterize(field.getName()));

        maybeErrorHeading(fielddiv);

        List list = fielddiv.addList("field-list",List.TYPE_FORM);

        // XXX add hints
        
        // element
        list.addLabel(T_tag_element);
        Item dc = list.addItem();
        Text schema = dc.addText("dc-schema");
        schema.setSize(5);
        if (field != null) schema.setValue(field.getSchema()); else schema.setValue("dc");
        dc.addContent(" . ");
        Text element = dc.addText("dc-element");
        element.setSize(15);
        if (field != null) element.setValue(field.getElement());
        element.setRequired();
        maybeError(dc, "dc-element");
        dc.addContent(" . ");
        Text qualifier = dc.addText("dc-qualifier");
        qualifier.setSize(15);
        if (field != null) qualifier.setValue(field.getQualifier());
        maybeError(dc, "name");

        // everything else
        list.addLabel(T_tag_label);
        Item labelitem = list.addItem();
        Text label = labelitem.addText("label");
        label.setSize(30);
        label.setRequired();
        if (field != null) label.setValue(field.getLabel());
        maybeError(labelitem, "label");
        
        Text hint = list.addItem().addText("hint");
        hint.setLabel(T_tag_hint);
        hint.setSize(50);
        if (field != null) hint.setValue(field.getHints());
        
        Text warning = list.addItem().addText("required");
        warning.setLabel(T_tag_required);
        warning.setSize(50);
        if (field != null) warning.setValue(field.getWarning());
                    
        // XXX still have to handle authority controlled fields
        list.addLabel(T_tag_input_type);
        Item typeitem = list.addItem();
        Select inputType = typeitem.addSelect("input-type");
        inputType.setRequired();
        maybeError(typeitem, "input-type");
        String it = (field != null)? field.getInputType() : "";
        for (Object[] option : inputTypes)
        {
        	inputType.addOption(option[1].equals(it), (String)option[1], (Message)option[0]);
        }
        
        list.addLabel(T_tag_value_list);
        Item values = list.addItem();
        Select valueList = values.addSelect("value-pairs-name");
        valueList.setHelp(T_help_value_list);
        String vl = (field != null)? field.getPairsType() : "";
        for (String valueListName : action.getValueListNames())
        {
        	valueList.addOption(valueListName.equals(vl), valueListName, valueListName);
        }
        String vlURL = contextPath + "/forms/value-lists" + "?" + "continue=" + knot.getId();
        values.addXref(vlURL, T_edit_value_lists);
        
        CheckBox repeatable = list.addItem().addCheckBox("repeatable");
        repeatable.setLabel(T_tag_repeatable);
        repeatable.addOption((field != null) && field.isRepeatable(), "true");  

        CheckBox visibility = list.addItem().addCheckBox("visibility");
        visibility.setLabel(T_tag_visibility); // XXX actually editability
        visibility.addOption((field != null) && field.isVisible(DCInput.WORKFLOW_SCOPE), 
        		DCInput.WORKFLOW_SCOPE, T_vis_workflow);
        visibility.addOption((field != null) && field.isVisible(DCInput.SUBMISSION_SCOPE), 
        		DCInput.SUBMISSION_SCOPE, T_vis_submission);
        
        CheckBox readOnly = list.addItem().addCheckBox("readonly");
        readOnly.setLabel(T_tag_readonly); // XXX when invisible
        readOnly.addOption((field != null) && field.isMarkedReadOnly(), "readonly");  

        list.addLabel(T_tag_vocabulary);
        Item vocabulary = list.addItem();
        Text vocab = vocabulary.addText("vocabulary");
        if (field != null) vocab.setValue(field.getVocabulary());
        CheckBox closed = vocabulary.addCheckBox("closedVocabulary");
        closed.addOption((field != null) && field.isClosedVocabulary(), "true", T_tag_closed);

        Item buttons = list.addItem();
        buttons.addButton("savefield").setValue(T_save_field);
        buttons.addButton("cancelfield").setValue(T_cancel);
    }
                

}
