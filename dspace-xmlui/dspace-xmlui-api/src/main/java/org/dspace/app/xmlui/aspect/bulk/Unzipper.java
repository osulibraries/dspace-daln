package org.dspace.app.xmlui.aspect.bulk;

import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.util.Enumeration;
import java.util.zip.ZipEntry;
import java.util.zip.ZipException;
import java.util.zip.ZipFile;

public class Unzipper
{
    private File zipsource;
    
    public Unzipper(File zipsource)
    {
        this.zipsource = zipsource;
    }
    
    public void unzipTo(File destination) throws ZipException, IOException 
    {
        ZipFile source = new ZipFile(zipsource);
        
        try 
        {
            for (Enumeration<? extends ZipEntry> entries = source.entries(); entries.hasMoreElements(); ) 
            {   
                ZipEntry entry = entries.nextElement();
                unzipEntry(entry, source, destination);
            }
        }
        finally
        {
            source.close();
        }
    }

    public void unzipEntry(ZipEntry entry, ZipFile source, File dir) throws IOException
    {
        String name = entry.getName();
        File destination = new File(dir, name);        
        
        if (entry.isDirectory()) 
        {
            destination.mkdir();
        }
        else 
        {
            InputStream is = source.getInputStream(entry);
            
            File parent = destination.getParentFile();
            parent.mkdirs();
            
            OutputStream os = new FileOutputStream(destination);
         
            try {
                // seriously???
                byte[] buf = new byte[8192]; // XXX or whatever
                while (true) {
                    int length = is.read(buf);
                    if (length < 0) {
                        break;
                    }
                    os.write(buf,0,length);
                }
            }
            finally
            {
                os.close();
            }
        }
        // XXX swallow errors and keep on truckin'?
        
        // XXX check directory and file existence
        
        // XXX set time
        
        // XXX check size and CRC        
    }
}
