package org.dspace.app.xmlui.aspect.bulk;

import java.io.IOException;

import javax.servlet.http.HttpSession;

import org.apache.cocoon.ProcessingException;
import org.apache.cocoon.environment.ObjectModelHelper;
import org.apache.cocoon.environment.Request;
import org.apache.cocoon.environment.Response;
import org.apache.cocoon.generation.AbstractGenerator;
import org.xml.sax.SAXException;
import org.xml.sax.helpers.AttributesImpl;

public class ProgressGenerator extends AbstractGenerator {

    public void generate() throws IOException, SAXException, ProcessingException
    {
        Request request = ObjectModelHelper.getRequest(objectModel);
        HttpSession session = request.getSession();

        Response response = ObjectModelHelper.getResponse(objectModel);
        
        BulkLogic logic = (BulkLogic)session.getAttribute("BulkLogic");

        // XXX it is not clear that there is any straightforward way to internationalize this
        
        String str = "" + logic.importer.count + " of " + logic.importer.total + " items";

        AttributesImpl attrs = new AttributesImpl();
        attrs.addAttribute("", "", "", "class", "ds-paragraph"); // XXX this doesn't seem to work
        
        contentHandler.startDocument();

        contentHandler.startElement("", "", "p", attrs);        
        contentHandler.characters(str.toCharArray(), 0, str.length());
        contentHandler.endElement("", "", "p");

        contentHandler.endDocument();
        
        if (logic.importdone) {
            response.setHeader("X-Progress-Done", "true");
        }
    }

}
