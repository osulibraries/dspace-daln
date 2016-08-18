package org.dspace.app.xmlui.aspect.forms;

import java.util.LinkedHashMap;
import java.util.Map;

/**
 * Encapsulates the disposition of a form handling request.
 * 
 * Possible outcomes of form processing include:
 * <ol>
 * <li> Continue processing the form (show the form again). </li>
 * <li> Return to a previous page. </li>
 * <li> Deny authorization to view page. </li>
 * <li> Deny authorization to perform action. </li>
 * <li> Ask for confirmation of an action. </li>
 * <li> Redirect to another page (not yet implemented). 
 * This could include continuing to another form in a series of forms.</li>
 * </ol>
 * 
 * Also includes a list of errors encountered while processing the form, keyed
 * to form fields, to display back to the user.
 * 
 * @author james
 *
 */
public class FormResult {

	// by default continue with no errors, etc. 
	
	private Map<String,Object> errors = new LinkedHashMap<String,Object>();
	//private String redirect = null; // not yet implemented
	private Object confirm = null;
	private Object denied = null;
	private boolean doReturn = false;
	
	/**
	 * Construct a new result which, by default, is set to 'continue processing'.
	 */
	public FormResult() {}
	
	/**
	 * Are there an errors associated with this result.
	 * 
	 * @return <code>true</code> if there are associated errors.
	 */
	public boolean hasErrors() {
		return !errors.isEmpty();
	}
	
	/**
	 * Return the errors associated with this result.
	 * 
	 * The errors map from an arbitrary key name (but generally form field names)
	 * to either a <code>String</code> or <code>Message</code>.
	 * 
	 * @return
	 */
	public Map<String, Object> getErrors() {
		return errors;
	}
	
	// NB another possible way to do a multi-page form, would be
	// creating a MultiPageFormAction and MultiPageForm (or something),
	// and keying on a 'page' parameter or something like that.
	/*
	public String needsRedirect() {
		return redirect;
	}
	*/
	
	/**
	 * A message to be displayed if the form action needs confirmation.
	 * 
	 * @return null if confirmation is not needed,
	 * otherwise a <code>String</code> or <code>Message</code> to be displayed
	 * on the confirmation page.
	 */
	public Object needsConfirm() {
		return confirm;
	}
	
	/**
	 * A message to be displayed if the form processing denies the action.
	 * 
	 * If <code>shouldReturn()</code> is set, then the entire page view
	 * is denied, otherwise just the given action is denied, and the
	 * user can return to the page.
	 * 
	 * @return null if the page is not denied,
	 * otherwise a <code>String</code> or <code>Message</code> to be displayed
	 * on the resulting page.
	 */
	public Object isDenied() {
		return denied;
	}
	
	/**
	 * Indicated whether form processing should continue or not.
	 * 
	 * If <code>false</code>, form processing will continue by redisplaying
	 * the current form, otherwise return the user to a previous page.
	 * 
	 * @return false if form processing should continue
	 */
	public boolean shouldReturn() {
		return doReturn;
	}
	
	/**
	 * Add a new error to the current set of errors.
	 * 
	 * @param field the field that the error is keyed to.
	 * @param message the error message to display (a <code>String</code> or <code>Message</code>).
	 * @return
	 */
	public FormResult addError(String field, Object message)
	{
		errors.put(field, message);
		return this;
	}
	
	/*
	public FormResult redirect(String url)
	{
		redirect = url;
		return this;
	}
	*/
	
	/**
	 * Set result to 'needs confirmation'.
	 * 
	 * @param message the confirmation message to display (a <code>String</code> or <code>Message</code>).
	 * @return
	 */
	public FormResult needsConfirm(Object message)
	{
		confirm = message;
		return this;
	}
	
	/**
	 * Set result to 'deny action'.
	 * 
	 * @param message the denial message to display (a <code>String</code> or <code>Message</code>).
	 * @return
	 */
	public FormResult denyAction(Object message)
	{
		if (denied == null) // don't override a previous denial (could have been a denyPage)
		{
			denied = message;
			doReturn = false;
		}
		return this;
	}
	
	/**
	 * Set result to 'deny page'.
	 * 
	 * @param message the denial message to display (a <code>String</code> or <code>Message</code>).
	 * @return
	 */
	public FormResult denyPage(Object message)
	{
		denied = message;
		doReturn = true;
		return this;
	}
	
	/**
	 * Set result to 'return from form processing'.
	 * 
	 * @return
	 */
	public FormResult doReturn()
	{
		doReturn = true;
		return this;
	}
	
}
