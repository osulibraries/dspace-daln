
importClass(Packages.org.dspace.app.xmlui.utils.FlowscriptUtils);

importClass(Packages.org.dspace.app.xmlui.aspect.forms.CollectionFormsAction);
importClass(Packages.org.dspace.app.xmlui.aspect.forms.InputFormAction);
importClass(Packages.org.dspace.app.xmlui.aspect.forms.InputFormsAction);
importClass(Packages.org.dspace.app.xmlui.aspect.forms.ValueListsAction);
importClass(Packages.org.dspace.app.xmlui.aspect.forms.ValueListAction);


/* Preliminaries */

/**
 * Simple access method to access the current cocoon object model.
 */
function getObjectModel() 
{
  return FlowscriptUtils.getObjectModel(cocoon);
}

function doForm()
{
    var handle = cocoon.parameters["handle"];
    
    doCyclicForm();
    
    var returnPage = (handle == "")? "" : "handle/"+handle; 
	cocoon.sendPage(returnPage);
}

function doCyclicForm()
{ 
    var handle = cocoon.parameters["handle"];
    var form   = cocoon.parameters["form"];

	var pageBase = (handle == "")? "" : "handle/"+handle+"/";

    var action = getFormAction(form);
	action.initializeAction(getObjectModel()); // setup for initial form entry

    do {
    	var newform = cocoon.parameters["form"];
    	if (form != newform)
    	{
    		doCyclicForm(newform); // do other form, then return to this one with no action
    	}
    	else 
    	{
    		action.setupRequest(getObjectModel()); // setup the action from this request

    		action.checkRequest();
    		if (checkResult(action.getResult())) // proceed after check?
    			action.doRequest();

    		if (action.getResult().shouldReturn()) // should we show the page or go back to previous form
    			break;
    	}

    	// NB all the state needed to regenerate the page is encapsulated in the action
    	//    and none in the request
    	cocoon.request.setAttribute("action", action);
    	cocoon.sendPageAndWait(pageBase+"forms/"+form+"/form");
    }
    while (true);
}

// return true if we should proceed with action
function checkResult(result)
{
	if (result.isDenied())
	{
		cocoon.request.setAttribute("message", result.isDenied());
    	cocoon.sendPageAndWait("forms/not-authorized/form");
    	return false;
	}
	else if (result.needsConfirm())
	{
		cocoon.request.setAttribute("message", result.needsConfirm());
		var confirm = cocoon.sendPageAndWait("forms/confirm/form");
		return cocoon.request.get("confirm");
	}
	// TODO: other redirect options (may need to reference original handle)
	
	return true;
}

function getFormAction(form)
{
	if (form == "input-form")
	{
		return new InputFormAction();
	}
	else if (form == "input-forms")
	{
		return new InputFormsAction();
	}
	else if (form == "value-list")
	{
		return new ValueListAction();
	}
	else if (form == "value-lists")
	{
		return new ValueListsAction();
	}	
	else if (form == "collection-forms")
	{
		return new CollectionFormsAction();
	}
}

