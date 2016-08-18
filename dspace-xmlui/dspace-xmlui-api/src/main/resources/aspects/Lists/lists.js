
importClass(Packages.org.dspace.app.xmlui.utils.FlowscriptUtils);

importClass(Packages.org.dspace.app.xmlui.aspect.lists.EditListAction);
importClass(Packages.org.dspace.app.xmlui.aspect.lists.EditListsAction);


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
    doCyclicForm();
	cocoon.sendPage("");
}

function doCyclicForm()
{ 
    var form   = cocoon.parameters["form"];

	var pageBase = "";

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
    		{
        		action.refreshContext(getObjectModel()); // refresh the context (for the database connection)    			
    			action.doRequest();
    		}
    		
    		if (action.getResult().shouldReturn()) // should we show the page or go back to previous form
    			break;
    	}

    	// NB all the state needed to regenerate the page is encapsulated in the action
    	//    and none in the request
    	// However, we may need to update some of the state (not using the parameters, just the context)
		action.refreshContext(getObjectModel()); 	// XXX kludgy    			
    	cocoon.request.setAttribute("action", action);
    	cocoon.sendPageAndWait(pageBase+"lists/"+form+"/form");
    }
    while (true);
}

// return true if we should proceed with action
function checkResult(result)
{
	if (result.isDenied())
	{
		//cocoon.request.setAttribute("message", result.isDenied());
    	//cocoon.sendPageAndWait("lists/not-authorized/form");
    	return false;
	}
	else if (result.needsConfirm())
	{
		cocoon.request.setAttribute("message", result.needsConfirm());
		var confirm = cocoon.sendPageAndWait("lists/confirm/form");
		return cocoon.request.get("confirm");
	}
	// TODO: other redirect options (may need to reference original handle)
	
	return true;
}

function getFormAction(form)
{
	if (form == "lists")
	{
		return new EditListsAction();
	}
	else if (form == "list")
	{
		return new EditListAction();
	}
}
