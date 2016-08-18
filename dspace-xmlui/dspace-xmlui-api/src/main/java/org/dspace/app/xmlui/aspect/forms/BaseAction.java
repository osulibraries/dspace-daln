package org.dspace.app.xmlui.aspect.forms;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.Map;

import org.apache.cocoon.environment.ObjectModelHelper;
import org.dspace.app.xmlui.cocoon.AbstractDSpaceTransformer;
import org.dspace.app.xmlui.utils.ContextUtil;
import org.dspace.app.xmlui.utils.HandleUtil;
import org.dspace.app.xmlui.utils.UIException;
import org.dspace.app.xmlui.wing.AbstractWingTransformer;
import org.dspace.app.xmlui.wing.Message;
import org.dspace.content.DSpaceObject;
import org.dspace.core.Context;

/**
 * A base class for form handling.
 * 
 * Provides a basic framework, some convenience methods,
 * and an interface used by the javascript form handling code.
 * 
 * @author james
 *
 */
public abstract class BaseAction {

	private static final Message T_required = message("xmlui.Forms.BaseAction.required");

	/* the context from the request */
	private Context context;
	
	/* a copy of the request parameters
	 * NB: does not account for multiple-valued parameters
	 */
	private Map<String,String> params;
	
	/* the object corresponding to the handle in the request URL, if any, otherwise null */
    private DSpaceObject dso;

    /* how to handle the request, used by the javascript form handler */
    private FormResult result;
	
	/** 
	 * Default constructor.  
	 * Does nothing.
	 */
	protected BaseAction()
	{
	}
	

	/**
	 * Get the request context.
	 * 
	 * @return the result context.
	 */
	protected Context getContext() {
		return context;
	}

	/**
	 * Get the class's (modifiable) copy of the request parameters.
	 * 
	 * NB Does not deal with multiple-valued parameters.
	 * 
	 * @return the copy of the request parameters
	 */
	protected Map<String,String> getParams() {
		return params;
	}

	/**
	 * Get the object corresponding to the handle in the request's URL, if any
	 * 
	 * @return the DSpaceObject or null if not applicable.
	 */
	protected DSpaceObject getDSO() {
		return dso;
	}
    
	/** 
	 * Get the object telling how to handle this request.
	 * 
	 * @return the FormResult object stating how to handle the request.
	 */
	public FormResult getResult()
	{
		return result;
	}
	
    /**
     * Gets the errors resulting from form processing.
     * 
     * The map keys generally refer to form field names, and the values are either a String or Message
     * to be displayed in the resulting page.
     * 
     * @return the accumulated errors in this form, or an empty Map if none.
     */
    public Map<String, Object> getErrors() 
    {
		return getResult().getErrors();
	}
    
    /**
     * Return the request parameter corresponding to <code>param</code>.
     * 
     * @param param the request parameter to return
     * @return the specified request parameter
     */
    public String getParameter(String param)
    {
    	return params.get(param);
    }

    /**
     * Return the request parameter corresponding to <code>param</code>, 
     * adding an error message to the result if not present.
     * 
     * @param param the request parameter to return
     * @return the specified request parameter
     */
    protected String getRequiredParameter(String param)
    {
    	String value = getParams().get(param);
    	assertRequired(param, value);
    	return value;
    }
    
    /**
     * Return the request parameter corresponding to <code>param</code> as an Integer,
     * or null if not present or not an Integer.
     * 
     * @param param the request parameter to return
     * @return the specified request parameter
     */
    public Integer getIntParameter(String param) {
        try {
            return Integer.parseInt(getParameter(param).trim());
        }
        catch (Exception e)
        {
            return null;
        }
    }

    /**
     * Make any first time initialization of the form state.
     * 
     * This is called only the first time a form representing a given piece of state is requested during the same editing session.
     * This refers to state that is persistent across multiple edits of a given form.
     * This may involve the creating and caching of local copies of the state to be edited.
     * 
     * @param objectModel the request state
     * @throws SQLException
     * @throws UIException
     */
    public void initializeAction(Map objectModel) throws SQLException, UIException
    {
    	context = ContextUtil.obtainContext(objectModel);
		params = new HashMap<String,String>(ObjectModelHelper.getRequest(objectModel).getParameters());
    }
        
    public void refreshContext(Map objectModel) throws SQLException
    {
    	context = ContextUtil.obtainContext(objectModel);    	
    }
    
    /**
     * Setup the generic state for form processing from the request.
     * Called each time a request is handled.
     * 
     * @param objectModel the request state
     * @throws SQLException
     * @throws UIException
     */
    public void setupRequest(Map objectModel) throws SQLException, UIException
    {
    	context = ContextUtil.obtainContext(objectModel);
		params = new HashMap<String,String>(ObjectModelHelper.getRequest(objectModel).getParameters());
        dso = HandleUtil.obtainHandle(objectModel);
        result = new FormResult();
    }

    /**
     * Check for possible alternative dispositions for form processing.
     * This includes denying the request, asking for confirmation, etc., but not in general,
     * checking for errors, which generally occurs in <code>doRequest()</code>.
     * 
     * Set the result state (from <code>getResult()</code>) as appropriate.
     * 
     * @throws SQLException
     * @throws UIException
     */
    public void checkRequest() throws SQLException, UIException
    {
    }
    
    /**
     * Handle the request.
     * This is just an error handling wrapper for <code>handleActions()</code>.
     * 
     * @throws SQLException
     * @throws UIException
     */
    public void doRequest() throws SQLException, UIException
    {
    	try {
    		handleActions();
    	}
    	catch (FormException e) {}
    }
    
    /**
     * Process the request.
     * 
     * Check for errors, determine if the action will actually be performed,
     * return from processing the form or continue, etc. 
     * 
     * @throws SQLException
     * @throws UIException
     * @throws FormException to escape
     */
    protected abstract void handleActions() throws SQLException, UIException, FormException;
    
    
    /**
     * urldecode a string.
     * 
     * Utility function.
     * 
     * @param encodedString
     * @return
     * @throws UIException
     */
    public static String URLDecode(String encodedString) throws UIException
    {
    	return AbstractDSpaceTransformer.URLDecode(encodedString);
    }
    
    /**
     * urlencode a string.
     * 
     * Utility function.
     * 
     * @param unencodedString
     * @return
     * @throws UIException
     */
    public static String URLEncode(String unencodedString) throws UIException
    {
    	return AbstractDSpaceTransformer.URLEncode(unencodedString);
    }
    
    public static Message message(String key)
    {
    	return AbstractWingTransformer.message(key);
    }

        
    // for ease of debugging from javascript
    public void debug(String page)
    {
    	System.err.println(page);
    }

    /**
     * Check for serious internal errors that we a basically helpless against by asserting a condition.
     * 
     * This includes malformed requests, things cause by race conditions, etc. and results in throwing
     * an exception, rather than following the standard form error handling protocol.
     * 
     * @param condition the proposition to assert
     * @param msg the error message if the assertion fails
     * @throws UIException if the assertion fails
     */
    protected void assertCondition(boolean condition, String msg) throws UIException
    {
    	if (!condition)
    		throw new UIException(msg);
    }
    
    /**
     * Check that a condition is true or attach an error message.
     * 
     * If the assertion fails, add a corresponding message, normally keyed to a form field, to the
     * accumulated errors.
     * 
     * @param field the field to associate with the potential error
     * @param condition the condition to assert
     * @param msg the error message if the assertion fails
     */
    protected void assertField(String field, boolean condition, String msg)
    {
    	if (!condition)
    		getResult().addError(field, msg);
    }
    
    /**
     * Check that a condition is true or attach an error message.
     * 
     * If the assertion fails, add a corresponding message, normally keyed to a form field, to the
     * accumulated errors.
     * 
     * @param field the field to associate with the potential error
     * @param condition the condition to assert
     * @param msg the error message if the assertion fails
     */
    protected void assertField(String field, boolean condition, Message msg)
    {
    	if (!condition)
    		getResult().addError(field, msg);
    }

    // XXX i18n
    /**
     * Check that a given parameter value is non-null and non-empty or attach an error message.
     * 
     * If the assertion fails, add a default message, normally keyed to a form field, to the
     * accumulated errors.
     * 
     * @param field the field to associate with the potential error
     */
    protected void assertRequired(String field, String value)
    {
    	assertField(field, value != null && !value.isEmpty(), T_required);
    }
    
    /**
     * Check that a given parameter value is non-null and non-empty or attach an error message.
     * 
     * If the assertion fails, add a default message, keyed to the parameter, to the
     * accumulated errors.
     * 
     * @param field the field to associate with the potential error
     */
    protected void assertRequiredParameter(String field)
    {
    	assertRequired(field, getParameter(field));
    }

    /**
     * Are there any errors so far as a result of processing this form request
     * 
     * @return true if there are any errors attached to this form.
     */
    protected boolean hasErrors()
    {
    	return getResult().hasErrors();
    }
    
    /**
     * If there are any errors then throw an exception.
     * 
     * Used for early exit from action handling.
     * 
     * @throws FormException if there are any errors.
     */
    protected void checkErrors() throws FormException
    {
    	if (hasErrors())
    		exitHandler();
    }

    /**
     * Return from form handling.
     * 
     * Used to exit early from nested action handlers.
     * 
     * @throws FormException
     */
    protected void exitHandler() throws FormException
    {
    	throw new FormException();
    }
    
}
