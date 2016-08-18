package org.dspace.app.xmlui.aspect.forms;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;
import java.util.Vector;

import org.apache.cocoon.environment.ObjectModelHelper;
import org.apache.cocoon.environment.Request;
import org.dspace.app.xmlui.utils.UIException;
import org.dspace.app.xmlui.wing.Message;

public class ValueListAction extends BaseInputFormsAction {

	private static final Message T_duplicate = message("xmlui.Forms.ValueListAction.duplicate");
	
	static class Pair
	{
		public String storage;
		public String display;
		
		public Pair(String display, String storage) {
			this.storage = storage;
			this.display = display;
		}
	}

	private String name;
	
	private Vector<Pair> valueList;
	private Vector<Pair> errorList;
	
    public ValueListAction()
    {    	
    }
    
    public Vector<Pair> getValueList()
    {
    	return hasErrors()? errorList : valueList;
    }
    
    public String getName()
    {
    	return name;
    }

	public void initializeAction(Map objectModel) throws SQLException, UIException
	{
		Request request = ObjectModelHelper.getRequest(objectModel);

		name = request.getParameter("base");
        assertCondition(name != null, "Malformed value list edit request: No name provided");

        // create local copy        
		valueList = new Vector<Pair>();
		List<String> pairs;
		synchronized (getInputsReader())
		{
			// double check against race condition
			assertCondition(getInputsReader().hasValueList(name), "Value list '" + name + "' does not exist");
			pairs = getInputsReader().getPairs(name);
		}
		for (int i = 0; i < pairs.size(); i += 2)
		{
			valueList.add(new Pair(pairs.get(i), pairs.get(i+1)));
		}
	}

	// NB there is no simple, practical way to prevent concurrent editing of value lists
	//    (although the edits are atomic and isolated)
	//    to do so seems overkill
	public void handleActions() throws FormException, UIException, SQLException
	{
		if (getParameter("cancel") != null)
		{
			getResult().doReturn();
			return;
		}
		if (getParameter("base") != null)
		{
			// this is the first pass through, so perform no action
			return;
		}

		createLocalState();
				
		// exit on errors
		checkErrors();
		
		doActions();

		updateSharedState();
		
		// and save to disk
		saveForm();
	}

	private void createLocalState()
	{
		// populate temporary list and check for duplicates
		Vector<Pair> list = new Vector<Pair>(valueList);
		int numPairs = valueList.size();
		for (int i = 0; i < numPairs; i++)
		{
			if (getParameter("pairremove"+i) != null) // don't bother checking if we are just going to delete it
				continue;
			
			String display = getRequiredParameter("pairdisplay"+i);
			String storage = getRequiredParameter("pairstorage"+i);
			Pair pair = new Pair(display, storage);
			list.set(i, pair);

			// check for duplicates
			for (int j = 0; j < i; j++)
			{
				Pair other = list.get(j);
				if (pair.display.equals(other.display))
				{
					getResult().addError("pairdisplay"+i,T_duplicate);
					getResult().addError("pairdisplay"+j,T_duplicate);
				}
				if (pair.storage.equals(other.storage))
				{
					getResult().addError("pairstorage"+i,T_duplicate);
					getResult().addError("pairstorage"+j,T_duplicate);					
				}				
			}
		}

		// update appropriate state
		if (hasErrors())
		{
			errorList = list;
		}
		else
		{
			valueList = list;
		}
	}
	
	private void doActions()
	{
		// then perform actions on list
		if (getParameter("pairadd") != null)
		{
			valueList.add(new Pair("",""));
			return;
		}

		int numPairs = valueList.size();
		// I did not want to do it this way,
		// but because IE doesn't process Buttons correctly, I'm forced to
		for (int i = 0; i < numPairs; i++)
		{
			if (getParameter("pairup"+i) != null)
			{
				Pair pair = valueList.remove(i);
				valueList.add(i-1,pair);
				return;
			}
			if (getParameter("pairdown"+i) != null)
			{
				Pair pair = valueList.remove(i);
				valueList.add(i+1,pair);
				return;
			}
			if (getParameter("pairremove"+i) != null)
			{
				valueList.remove(i);
				return;
			}
		}
		// NB the save button works by virtue of not being anything else
		//    because anything else drops through and saves no matter what 
	}
	
	private void updateSharedState()
	{
		// translate to external format
		Vector<String> pairs = new Vector<String>();
		for (Pair pair : valueList)
		{
			pairs.add(pair.display);
			pairs.add(pair.storage);
		}

		// update shared state
		getInputsReader().addValuePairs(name, "", pairs);
	}
	
}

