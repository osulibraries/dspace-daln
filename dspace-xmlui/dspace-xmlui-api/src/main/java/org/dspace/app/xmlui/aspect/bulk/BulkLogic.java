package org.dspace.app.xmlui.aspect.bulk;

import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.IOException;
import java.io.PrintStream;
import java.net.URI;
import java.sql.SQLException;
import java.util.Collections;
import java.util.LinkedList;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpSession;

import org.apache.avalon.framework.logger.AbstractLogEnabled;
import org.apache.cocoon.environment.ObjectModelHelper;
import org.apache.cocoon.environment.Request;
import org.apache.cocoon.environment.SourceResolver;
import org.apache.cocoon.servlet.multipart.Part;
import org.apache.cocoon.servlet.multipart.PartOnDisk;
import org.apache.commons.io.FileUtils;
import org.apache.excalibur.source.Source;
import org.dspace.app.xmlui.utils.ContextUtil;
import org.dspace.app.xmlui.utils.HandleUtil;
import org.dspace.content.Collection;
import org.dspace.content.DSpaceObject;
import org.dspace.core.ConfigurationManager;
import org.dspace.core.Context;
import org.dspace.eperson.EPerson;

public class BulkLogic extends AbstractLogEnabled
{

    public SourceResolver resolver;
    
    public String mode = null;
    public boolean isAdd = false;
    public boolean isReplace = false;
    public boolean isDelete = false;
    
    public File baseDirectory = null;
    public File mapfiledir = null;
    public File uploaddir = null;
    
    public File bulkDirectory = null;
    public File mapFile = null;
    public boolean isResume = false;
    public boolean isTest = true;
    public boolean useWorkflow = true;
    public boolean useTemplate = false;

    public List<String> paramErrors = new LinkedList<String>();
    
    public boolean resultsDisplayed = false;
    
    // import context
    public ItemImport importer = null;
    public boolean importdone = true;
    
    public ByteArrayOutputStream output = null; // need to save the output somewhere
    public List<String> errmsgs = new LinkedList<String>();
    
    public BulkLogic(SourceResolver resolver) {
        this.resolver = resolver;
    }
    
    public void gatherParameters(Map objectModel) {
        
        Request request = ObjectModelHelper.getRequest(objectModel);

        // Mode
        mode = request.getParameter("mode");
        isAdd = "add".equals(mode);
        isReplace = "replace".equals(mode);
        isDelete = "delete".equals(mode);
            
        Source source = null;
        try {
            source = resolver.resolveURI("context://static/files/bulk");
            String uristr = source.getURI();
            URI uri = new URI(uristr);
            baseDirectory = new File(uri);
        }
        catch (Exception e) {
            e.printStackTrace();
        }
        finally {
            if (source != null) {
                resolver.release(source);
            }
        }
        
        // XXX this may not work for WAR deployed servlets
        //org.apache.cocoon.environment.Context context = ObjectModelHelper.getContext(objectModel);
        //String basestr = context.getRealPath("/");
        //baseDirectory = new File(basestr + "/static/files","bulk");

        mapfiledir = new File(baseDirectory,"mapfiles");
        
        String uploaddirstr = ConfigurationManager.getProperty("bulk.uploaddir");
        if (uploaddirstr != null) 
        {
        	uploaddir = new File(uploaddirstr);
        }
        else
        {
        	uploaddir = new File(baseDirectory,"uploads"); // default
        }
        
        // Other options
        String testparam = request.getParameter("test");
        isTest = "true".equals(testparam);
        
        String workflowparam = request.getParameter("workflow");
        useWorkflow = !"true".equals(workflowparam);
        
        String templateparam = request.getParameter("template");
        useTemplate = "true".equals(templateparam);

    }
    
    public void handleMapfile(Request request) {
        if (true) { // NB leave this here
            Part mappart = (Part)request.get("mapfile");
            if (mappart != null) {
                File mapFileTemp = ((PartOnDisk)mappart).getFile();
                try
                {
                    mapFile = new File(mapfiledir,mapFileTemp.getName()); 
                    FileUtils.copyFile(mapFileTemp, mapFile);
                }
                catch (IOException e)
                {
                    e.printStackTrace();
                }                                            
            }
        }
        if (isAdd) {
            if (mapFile != null) {
                isResume = true;
            }
            else {
                try
                {
                    mapFile = File.createTempFile("import", ".mapfile", mapfiledir);
                }
                catch (IOException e)
                {
                    e.printStackTrace();
                }                            
            }
        }
    }

    public void handleUpload(Request request) {
        if (!isDelete) {
            Part part = (Part)request.get("file");

            if (part != null) {
                File zipFile = ((PartOnDisk)part).getFile();            
                if (zipFile != null) {
                    bulkDirectory = doUnzip(zipFile);
                }
            }            
        }
        // XXX we need to show error on unzip failure
    }
    
    public void handleUploadDirectory(Map objectModel) {

        Request request = ObjectModelHelper.getRequest(objectModel);

        String uploadstr = request.getParameter("upload");
        
        // XXX should probably verify that subdir or zipfile actually exists

        if (uploadstr != null) {
            if (!uploadstr.endsWith(".zip")) {
                bulkDirectory = new File(uploaddir, new File(uploadstr).getName()); // NB slightly sanitize
            }
            else if (uploadstr != null) {
                File zipFile = new File(uploaddir, new File(uploadstr).getName()); // NB slightly sanitize
                bulkDirectory = doUnzip(zipFile);
            }
            // XXX we need to show error on unzip failure
        }
        
        if (request.getParameter("resume") != null) {
            isResume = true;
        }
    }
    
    public void handleMapfileSelection(Map objectModel) {

        Request request = ObjectModelHelper.getRequest(objectModel);

        String mapfilestr = request.getParameter("mapfile");
        
        if (mapfilestr != null) {
            // XXX should probably verify that mapfile actually exists        
            mapFile = new File(mapfiledir, new File(mapfilestr).getName()); // NB slightly sanitize
        }
    }
    
    public void generateMapfile(Map objectModel) {
        if (bulkDirectory != null) {
            mapFile = new File(mapfiledir, bulkDirectory.getName()+".mapfile");
        }
    }
    
    // true if ok, false if errors
    public boolean checkParameters() {
        paramErrors.clear();
        // none of these should happen under normal circumstances, once we get fancier control flow.
        if (!isAdd && !isReplace && !isDelete) {
            paramErrors.add("xmlui.Bulk.ParamError.mode");
        }
        if (isAdd && bulkDirectory == null) {
            paramErrors.add("xmlui.Bulk.ParamError.add");
        }
        if (isResume && mapFile == null) {
            paramErrors.add("xmlui.Bulk.ParamError.resume");
        }
        if (isReplace && (bulkDirectory == null || mapFile == null)) {
            paramErrors.add("xmlui.Bulk.ParamError.replace");
        }
        if (isDelete && mapFile == null) {
            paramErrors.add("xmlui.Bulk.ParamError.delete");
        }
        
        // XXX check that handle is a collection 
        // XXX check permissions on zip file contents
        
        return paramErrors.isEmpty();
    }
    
    
    // XXX I don't yet have a good, systematic idea of what should take place
    // outside the runnable, in the runnable, and in the called function
    public synchronized void doImport(final Map objectModel) throws SQLException {
        // XXX stop currently running import and clean up old thread
        
        Request request = ObjectModelHelper.getRequest(objectModel);
        HttpSession session = request.getSession();
        session.setAttribute("BulkLogic", BulkLogic.this); // XXX allow multiple imports???

        // NB this needs to be created outside the runnable, so it is sure to be available to the AJAX callback
        importer = new ItemImport(); 
        importdone = false;

        Context context = ContextUtil.obtainContext(objectModel);
        // NB this needs to occur outside of the runnable, to insure the integrity of the context    
        final EPerson eperson = context.getCurrentUser(); 

        // NB this needs to occur outside of the runnable, to insure the integrity of the collection's context    
        DSpaceObject dso = HandleUtil.obtainHandle(objectModel);
        Collection collection = (Collection)dso;
        final int collectionID = collection.getID();

        Runnable imp = new Runnable() {
            public void run() {
                try
                {
                    Context context = new Context();
                    context.setCurrentUser(eperson);

                    // reacquire collection in current context from ID
                    Collection collection = Collection.find(context, collectionID);
                    
                    reallyDoImport(context, collection);
                }
                catch (SQLException e1)
                {
                    e1.printStackTrace();
                } 
            }
        };
        //imp.run();
        new Thread(imp).start();
    }
    
    public void reallyDoImport(Context context, Collection collection) {

        errmsgs.clear();
        output = new ByteArrayOutputStream();
        
        PrintStream stdout = System.out;
        try
        {
            Collection[] collections = new Collection[] { collection };

            importer.isTest      = isTest;
            importer.useWorkflow = useWorkflow;
            importer.isResume    = isResume;
        
            System.setOut(new PrintStream(output)); // capture full output
            
            if (isAdd) {
                errmsgs = importer.addItems(context, collections, bulkDirectory.getAbsolutePath(), 
                                            mapFile.getAbsolutePath(), useTemplate);
            }
            else if (isReplace) {
                errmsgs = importer.replaceItems(context, collections, bulkDirectory.getAbsolutePath(), 
                        mapFile.getAbsolutePath(), useTemplate);
            }
            else if (isDelete) {
                errmsgs = importer.deleteItems(context, mapFile.getAbsolutePath());
            }

            context.complete();
        }
        catch (Exception e)
        {
            e.printStackTrace();
            System.out.println(e);
            errmsgs.add(e.getMessage());
            context.abort();
        }

        if (importer.mapOut != null) {
            importer.mapOut.close();
        }
        System.setOut(stdout);
        importdone = true;

    }
    
    protected int countDirectories() {
        String[] dircontents = bulkDirectory.list(ItemImport.directoryFilter);
        return dircontents.length;
    }
     
    protected int countMapFileEntries() {
        Map mapcontents = Collections.emptyMap();
        try
        {
            mapcontents = ItemImport.readMapFile(mapFile.getAbsolutePath());
        }
        catch (Exception e)
        {
            e.printStackTrace();
        }
        return mapcontents.size();
    }

    //XXX allow user to pick name (or use zip file name?)
    protected File doUnzip(File zipFile) {

        //getLogger().debug("Uploaded file = " + zipFile.getAbsolutePath());

        // unzip file
        Unzipper unzipper = new Unzipper(zipFile);

        File bulkdir = null;
        
        // generate temporary directory using standard super-kludge // XXX check permissions
        try
        {
            String zipstr = zipFile.getAbsolutePath();
            if (zipstr.endsWith(".zip")) {
                zipstr = zipstr.substring(0, zipstr.length()-4);
            }
            File temp = new File(zipstr);
            temp.mkdir();

            unzipper.unzipTo(temp);
            
            bulkdir = temp;
        }
        catch (IOException e)
        {
            e.printStackTrace();
        }
        return bulkdir;
    }   

    
}
