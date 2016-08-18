
importClass(Packages.org.dspace.app.xmlui.utils.FlowscriptUtils);
importClass(Packages.org.dspace.app.xmlui.utils.ContextUtil);

importClass(Packages.org.dspace.app.xmlui.aspect.deposit.DepositLogic);

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

function doDeposit()
{
    retry:
    do {
        var logic = new DepositLogic();

    	more:
    	do {
    		cocoon.request.setAttribute("logic", logic);
    		cocoon.sendPageAndWait("deposit/start");
    		
    		if (logic.processDepositForm(getObjectModel()))
    			break more;
    	}
    	while (true);
		
		cocoon.request.setAttribute("logic", logic); // not redundant
		cocoon.sendPageAndWait("deposit/done");

		if (cocoon.request.get("submit-continue")) {
			continue retry;
		}
		else if (cocoon.request.get("submit-done")) {
			break retry;
		}
		break retry;

    }
    while (true);

    cocoon.sendPage("");

}
 

