package org.dspace.app.xmlui.aspect.deposit;

import java.io.IOException;
import java.sql.SQLException;

import org.dspace.app.xmlui.cocoon.AbstractDSpaceTransformer;
import org.dspace.app.xmlui.utils.UIException;
import org.dspace.app.xmlui.wing.Message;
import org.dspace.app.xmlui.wing.WingException;
import org.dspace.app.xmlui.wing.element.List;
import org.dspace.app.xmlui.wing.element.Options;
import org.dspace.authorize.AuthorizeException;
import org.xml.sax.SAXException;

public class Navigation extends AbstractDSpaceTransformer {

	private static final Message T_option = message("xmlui.Deposit.option");
	
	public void addOptions(Options options) throws SAXException, WingException,
	UIException, SQLException, IOException, AuthorizeException
	{
		// Basic navigation skeleton
		options.addList("browse");
		List account = options.addList("account");
		options.addList("context");
		options.addList("administrative");

    	account.addItemXref(contextPath+"/deposit",T_option);

	}

}
