
importClass(Packages.org.dspace.app.xmlui.utils.FlowscriptUtils);
importClass(Packages.org.dspace.app.xmlui.utils.ContextUtil);
importClass(Packages.org.dspace.app.xmlui.utils.HandleUtil);

importClass(Packages.org.dspace.app.xmlui.aspect.bulk.BulkLogic);

importClass(Packages.org.dspace.authorize.AuthorizeManager);
importClass(Packages.org.dspace.core.Constants);
importClass(Packages.org.dspace.content.Collection);

/* Preliminaries */

/**
 * Simple access method to access the current cocoon object model.
 */
function getObjectModel() 
{
  return FlowscriptUtils.getObjectModel(cocoon);
}

function getDSContext()
{
	return ContextUtil.obtainContext(getObjectModel());
}

function doBulk()
{
    var handle = cocoon.parameters["handle"];
    if (handle == null) {
    	handle = cocoon.request.get("handle");
    }

    if (!AuthorizeManager.authorizeActionBoolean(getDSContext(), HandleUtil.obtainHandle(getObjectModel()), Constants.ADD)) {
        cocoon.sendPage("handle/"+handle);
        return;
    }
    
    var paramOK = true;
    
    try {
    var resolver = cocoon.getComponent(Packages.org.apache.cocoon.environment.SourceResolver.ROLE);
    var logic = new BulkLogic(resolver);

    // I believe that in sober moments of reflection this code will make me want to cry
    // NB I tried rewriting it as an FSM, but it's not really much better that way.
    
    retry:
    do {
    	// NB there may be something here in the future, so don't fuse these loops
    	query:
    	do {
    		cocoon.request.setAttribute("logic", logic); // not redundant
    		cocoon.sendPageAndWait("handle/"+handle+"/bulk/getParameters");

    		logic.gatherParameters(getObjectModel());

    		if (!logic.isDelete) {
        		cocoon.request.setAttribute("logic", logic); // not redundant
    			cocoon.sendPageAndWait("handle/"+handle+"/bulk/selectUpload");
    		
        		logic.handleUploadDirectory(getObjectModel());        		
    		}
    		
    		if (!logic.isAdd || logic.isResume) {
    			cocoon.request.setAttribute("logic", logic); // not redundant
    			cocoon.sendPageAndWait("handle/"+handle+"/bulk/selectMapfile");

        		logic.handleMapfileSelection(getObjectModel());
        		
    		} else {
    			logic.generateMapfile(getObjectModel());
    		}
    			
    		paramOK = logic.checkParameters();

    		if (paramOK) { // I'm going to burn in control structure hell for this
    			break query;
    		}
    		
    		cocoon.request.setAttribute("logic", logic); // not redundant
    		cocoon.sendPageAndWait("handle/"+handle+"/bulk/paramError");
    	}
    	while (true);

    	proceed:
    	do {
    		logic.doImport(getObjectModel());
    		
    		logic.resultsDisplayed = false;
    		
    		progress:
    		do {

    			var cont = cocoon.createWebContinuation(); 
    			// return here on noscript refresh

    			if (logic.importdone) {
    				break progress;
    			}
    			
    			cocoon.request.setAttribute("logic", logic); // not redundant
    			cocoon.sendPageAndWait("handle/"+handle+"/bulk/displayResults", {cont:cont.id});

    			if (cocoon.request.get("submit-cancel")) {
    				logic.importer.cancelled = true;
    			}

    		}
    		while (true);
    		
    		if (!logic.resultsDisplayed) {
    			cocoon.request.setAttribute("logic", logic); // not redundant
    			cocoon.sendPageAndWait("handle/"+handle+"/bulk/displayResultsDone");
    		}

			if (cocoon.request.get("submit-proceed")) {
				logic.isTest = false;
				continue proceed;
    		}
			else if (cocoon.request.get("submit-retry")) {
				continue retry;
    		}
			else if (cocoon.request.get("submit-continue")) {
				break retry;
    		}
			break retry;
    	}
    	while (true);
    }
    while (true);

    }
    finally {
    	cocoon.releaseComponent(resolver);
    }
    
    cocoon.sendPage("handle/"+handle);

}
 


