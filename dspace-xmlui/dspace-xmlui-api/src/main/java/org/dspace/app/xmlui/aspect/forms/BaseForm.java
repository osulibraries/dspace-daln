package org.dspace.app.xmlui.aspect.forms;

import java.util.HashMap;
import java.util.Map;

import org.dspace.app.xmlui.cocoon.AbstractDSpaceTransformer;
import org.dspace.app.xmlui.wing.Message;
import org.dspace.app.xmlui.wing.WingException;
import org.dspace.app.xmlui.wing.element.Division;
import org.dspace.app.xmlui.wing.element.Highlight;
import org.dspace.app.xmlui.wing.element.RichTextContainer;

/**
 * A base class for form display.
 * 
 * Contains some convenience methods for error display.
 * 
 * @author james
 *
 */
public class BaseForm extends AbstractDSpaceTransformer { 
	
	private static final Message T_error = message("xmlui.Forms.BaseForm.error");
	/**
	 * A place to stash errors retrieved from the action
	 */
	protected Map<String,Object> errors = new HashMap<String,Object>();
	
	/*
	protected void addMiniForm(RichTextContainer container, String name, String submitURL, String linkText, boolean asLink, Object... nameValuePairs) throws WingException
	{
		Division div = container.addInteractiveDivision(name, submitURL, Division.METHOD_POST, "miniform");
		div.addHidden("continue").setValue(knot.getId());
		for (int i = 0; i < nameValuePairs.length; i += 2)
		{
			div.addHidden((String)nameValuePairs[i]).setValue(nameValuePairs[i+1].toString());
		}
		div.addPara().addButton("dummy",asLink? "link": "").setValue(linkText);		
	}
    
	protected void addMiniForm(RichTextContainer container, String name, String submitURL, Message linkText, boolean asLink, Object... nameValuePairs) throws WingException
	{
		Division div = container.addInteractiveDivision(name, submitURL, Division.METHOD_POST, "miniform");
		div.addHidden("continue").setValue(knot.getId());
		for (int i = 0; i < nameValuePairs.length; i += 2)
		{
			div.addHidden((String)nameValuePairs[i]).setValue(nameValuePairs[i+1].toString());
		}
		div.addPara().addButton("dummy",asLink? "link": "").setValue(linkText);		
	}
	*/
	
	/**
	 * Add an error tag to a form item.
	 * 
	 * @param item the item to tag with an error message.
	 * @param control 
	 * @throws WingException
	 */
	protected void maybeError(RichTextContainer item, String control)
		throws WingException
	{
		if (errors != null && errors.containsKey(control))
		{
			Highlight hi = item.addHighlight("error");
			hi.addContent("* ");
			Object error = errors.get(control);
			if (error instanceof String) {
				hi.addContent((String)error);
			}
			else if (error instanceof Message)
			{
				hi.addContent((Message)error);
			}
		}
	}
	
	/**
	 * Add a generic top-level error warning to a form.
	 * 
	 * @param div the division in which to insert the message.
	 * @throws WingException
	 */
	protected void maybeErrorHeading(Division div) throws WingException
	{
        if (!errors.isEmpty())
        {
        	Highlight hi = div.addPara().addHighlight("error");
        	hi.addContent("* ");
        	hi.addContent(T_error);
        }
		
	}

}
