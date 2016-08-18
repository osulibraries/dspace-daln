package org.dspace.app.xmlui.aspect.artifactbrowser;

import java.io.BufferedReader;
import java.io.FileNotFoundException;
import java.io.FileReader;
import java.io.IOException;
import java.sql.SQLException;
import java.util.Collections;
import java.util.HashSet;
import java.util.Set;
import java.util.Vector;

import org.dspace.app.xmlui.cocoon.AbstractDSpaceTransformer;
import org.dspace.app.xmlui.utils.UIException;
import org.dspace.app.xmlui.wing.Message;
import org.dspace.app.xmlui.wing.WingException;
import org.dspace.app.xmlui.wing.element.Body;
import org.dspace.app.xmlui.wing.element.Division;
import org.dspace.app.xmlui.wing.element.ReferenceSet;
import org.dspace.authorize.AuthorizeException;
import org.dspace.content.DSpaceObject;
import org.dspace.core.ConfigurationManager;
import org.dspace.handle.HandleManager;
import org.xml.sax.SAXException;

public class Featured extends AbstractDSpaceTransformer {
	
	private static final Message T_featured_head = 
        message("xmlui.ArtifactBrowser.Featured.featured_head");

    public void addBody(Body body) throws IOException, WingException
    {
        int featuredCount = ConfigurationManager.getIntProperty("featured.count");
        String featuredType = ConfigurationManager.getProperty("featured.type");

        if (featuredCount == 0)
        	return;
        
        String dspacedir = ConfigurationManager.getProperty("dspace.dir");
        
        String featuredfile = dspacedir + "/config/featured.txt";

        BufferedReader reader = new BufferedReader(new FileReader(featuredfile));

        Vector<String> handles = new Vector<String>();

        String line;
        while ((line = reader.readLine()) != null)
        {
        	if (!line.isEmpty()) {
        		handles.add(line);
        	}
        }

        if (handles.isEmpty())
        	return;

    	Division sidebar = body.addDivision("sidebar", "sidebar");

    	Division superdiv = sidebar.addDivision("featured-outer", "featured");
        Division featured = superdiv.addDivision("featured-inner");
        featured.setHead(T_featured_head);

        ReferenceSet rs = featured.addReferenceSet("featured-set", "featured");

        // reduce to at most the number of featured collections actually listed
        featuredCount = Math.min(featuredCount, handles.size());

        Vector<String> selected = new Vector<String>(); // selected handles
        
        if ("random".equals(featuredType)) {
        	// create a random subset of size featuredCount of integers [0,handles.size())
        	Collections.shuffle(handles);

        	for (int idx = 0; idx < featuredCount; idx++)
        	{
        		selected.add(handles.get(idx));
        	}
        }
        else // static
        {
        	for (int idx = 0; idx < featuredCount; idx++)
        	{
        		selected.add(handles.get(idx));
        	}
        }

        // build a referenceSet with the corresponding handles
        for (String handle : selected)
        {
        	try {
        		DSpaceObject dso = HandleManager.resolveToObject(context, handle);
        		rs.addReference(dso);
        	}
        	catch (Exception e) // just ignore anything hinky
        	{
        	}
        }
        
    }

}
