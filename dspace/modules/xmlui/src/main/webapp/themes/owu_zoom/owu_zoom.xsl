<?xml version="1.0" encoding="UTF-8"?>

<!--

        pffmultijs.xsl

        Allows use of a drop-down chooser to select a different image
        to zoom in on with Zoomify image viewer.

        This approach requires that Javascript is enabled in the browser.

	Keith R Gilbertson
	OhioLINK
-->

<xsl:stylesheet xmlns:i18n="http://apache.org/cocoon/i18n/2.1"
	xmlns:dri="http://di.tamu.edu/DRI/1.0/"
	xmlns:mets="http://www.loc.gov/METS/"
	xmlns:xlink="http://www.w3.org/TR/xlink/"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0"
	xmlns:dim="http://www.dspace.org/xmlns/dspace/dim"
	xmlns:xhtml="http://www.w3.org/1999/xhtml"
	xmlns:mods="http://www.loc.gov/mods/v3"
	xmlns:dc="http://purl.org/dc/elements/1.1/"
	xmlns="http://www.w3.org/1999/xhtml"
	exclude-result-prefixes="i18n dri mets xlink xsl dim xhtml mods dc">

	<xsl:import href="../OWU/owu.xsl" />
	<xsl:output indent="yes" />


<!-- Below added for zoomify test KRG 2008-06-18 -->
<!-- An item rendered in the summaryView pattern. This is the default way to view a DSpace item in Manakin. 
     KRG 03/2008 Add ZOOM bundle for Zoomify images.
-->
    <xsl:template name="itemSummaryView-DIM">
			<!--	Call Zoom templates    -->
                        <xsl:apply-templates select="./mets:fileSec/mets:fileGrp[@USE='ZOOM']" />
                        
        <!-- Generate the info about the item from the metadata section -->
        <xsl:apply-templates select="./mets:dmdSec/mets:mdWrap[@OTHERMDTYPE='DIM']/mets:xmlData/dim:dim"
        mode="itemSummaryView-DIM"/>

        <!-- Generate the bitstream information from the file section -->
        <xsl:choose>
                <xsl:when test="not(./mets:fileSec/mets:fileGrp[@USE='CONTENT'])">
                <h2><i18n:text>xmlui.dri2xhtml.METS-1.0.item-files-head</i18n:text></h2>
                 <table class="ds-table file-list">
                    <tr class="ds-table-header-row">
                        <th><i18n:text>xmlui.dri2xhtml.METS-1.0.item-files-file</i18n:text></th>
                        <th><i18n:text>xmlui.dri2xhtml.METS-1.0.item-files-size</i18n:text></th>
                        <th><i18n:text>xmlui.dri2xhtml.METS-1.0.item-files-format</i18n:text></th>
                        <th><i18n:text>xmlui.dri2xhtml.METS-1.0.item-files-view</i18n:text></th>
                    </tr>
                    <tr>
                    <td colspan="4">
                        <p><i18n:text>xmlui.dri2xhtml.METS-1.0.item-no-files</i18n:text></p>
                        </td>
                        </tr>
                        </table>
                </xsl:when>
                <xsl:otherwise>
                        <xsl:apply-templates select="./mets:fileSec/mets:fileGrp[@USE='CONTENT']">
                            <xsl:with-param name="context" select="."/>
                            <xsl:with-param name="primaryBitstream" select="./mets:structMap[@TYPE='LOGICAL']/mets:div[@TYPE='DSpace Item']/mets:fptr/@FILEID"/>
                        </xsl:apply-templates>
                </xsl:otherwise>
        </xsl:choose>

        <!-- Generate the license information from the file section -->
        <xsl:apply-templates select="./mets:fileSec/mets:fileGrp[@USE='CC-LICENSE' or @USE='LICENSE']"/>


    </xsl:template>

 <!-- Generate PFF Zoomify  objects for images in the ZOOM bundle -->
    <!-- METS file ID will be in the form file_xxxx, where xxxx
        Is the DSPace bitstream ID.  The substring function is used to strip
        the 'file_' portion from the ID -->

    <xsl:template match="mets:fileGrp[@USE='ZOOM']">
      <div>
                <!-- KRG prototype test of getting file via bitstream id instead of relative path -->
<OBJECT  id="ZAS" codeBase="http://download.macromedia.com/pub/shockwave/cabs/flash/swflash.cab#version=6,0,0,0" height="395" width="590" align="center" classid="clsid:D27CDB6E-AE6D-11cf-96B8-444553540000">
<PARAM NAME="src" VALUE="/themes/owu_zoommulti/ZAS.swf" />
<PARAM NAME="quality" VALUE="high" />
<PARAM NAME="bgcolor" VALUE="#FFFFFF" />
<PARAM NAME="swliveconnect" VALUE="true" />
<PARAM NAME="FlashVars" VALUE="gDefaultLabelVisibility=1&#38;gServerIP=drc.owu.edu&#38;gServerPort=80&#38;gByteHandlerPath=/ohiolink_zoom/dspacezoomifyServlet&#38;gImagePath={substring(mets:file[last()]/@ID,6)}.pff&#38;gMenuX=-1&#38;gPOIX=-1&#38;gLabelsX=-1&#38;gNavbarX=195&#38;gNavbarY=350&#38;gViewX=-1&#38;gConferenceX=-1&#38;gRulerX=200&#38;gSkipLogin=1" />
<EMBED name="ZAS" src="/themes/owu_zoommulti/ZAS.swf" FlashVars="gDefaultLabelVisibility=1&#38;gServerIP=drc.owu.edu&#38;gServerPort=80&#38;gByteHandlerPath=/ohiolink_zoom/dspacezoomifyServlet&#38;gImagePath={substring(mets:file[last()]/@ID,6)}.pff&#38;gMenuX=-1&#38;gPOIX=-1&#38;gLabelsX=-1&#38;gNavbarX=195&#38;gNavbarY=350&#38;gViewX=-1&#38;gConferenceX=-1&#38;gRulerX=200&#38;gSkipLogin=1" quality="high" bgcolor="#ffffff" WIDTH="590" HEIGHT="395" TYPE="application/x-shockwave-flash" PLUGINSPAGE="http://www.macromedia.com/go/getflashplayer" swliveconnect="true"></EMBED>
</OBJECT>
<script type="text/javascript" >

/* below function copied from
www.permadi.com
*/
<xsl:text disable-output-escaping="yes">
function getFlashMovieObject(movieName)
{
  if (window.document[movieName]) 
  {
      return window.document[movieName];
  }
  if (navigator.appName.indexOf("Microsoft Internet")==-1)
  {
    if (document.embeds &amp;&amp; document.embeds[movieName])
      return document.embeds[movieName]; 
  }
  else // if (navigator.appName.indexOf("Microsoft Internet")!=-1)
  {
    return document.getElementById(movieName);
  }
}
</xsl:text>
function switchZoomImage(pffFilename)
{
 
      var flash = getFlashMovieObject("ZAS");
      /* detect IE and workaround bug in activex implementation of flash player 
         ActiveX flash will not Load a movie into layer 0 if it is the same
         as the currently loaded movie
      */
      
      if (document.all) /* detect IE */
      {
        flash.LoadMovie(0, "/themes/owu_zoommulti/dummy.swf");  
      }
      flash.LoadMovie(0, "/themes/owu_zoommulti/ZAS.swf");
      flash.SetVariable("gDefaultLabelVisibility", 1);
      flash.SetVariable("gServerPort", 80);
      flash.SetVariable("gMenuX", -1);
      flash.SetVariable("gPOIX", -1);
      flash.SetVariable("gLabelsX", -1);
      flash.SetVariable("gNavBarX", 195);
      flash.SetVariable("gNavBarY", 350);
      flash.SetVariable("gViewX", -1);
      flash.SetVariable("gConferenceX", -1);
      flash.SetVariable("gRulerX", 200);
      flash.SetVariable("gSkipLogin", 1); 
      flash.SetVariable("gServerIP", "drc.owu.edu");
      flash.SetVariable("gByteHandlerPath", "/ohiolink_zoom/dspacezoomifyServlet");
      flash.SetVariable("gImagePath", pffFilename);

}
</script> 
<form name="zoomimagechooser">
  <fieldset>
  <label for="imagename" accesskey="S">Select file to view</label>
  <select name="imagename" onChange="switchZoomImage( document.zoomimagechooser.imagename.options[document.zoomimagechooser.imagename.selectedIndex].value)" >
    <xsl:for-each select="mets:file">
    <xsl:sort select="mets:FLocat/@xlink:title" />
     <option value="{substring(@ID,6)}.pff" /><xsl:value-of select="substring(mets:FLocat/@xlink:title, 0, string-length(mets:FLocat/@xlink:title)-3)" />
    </xsl:for-each>
  </select>
  </fieldset>
</form>

</div>
    </xsl:template>



</xsl:stylesheet>
