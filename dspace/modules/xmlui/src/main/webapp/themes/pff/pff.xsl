<?xml version="1.0" encoding="UTF-8"?>

<!--
  pff.xsl

  Practice work for the pff zoomify image tiler.

-->

<!--
   OhioLINK test 
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
    
    <xsl:import href="../dri2xhtml.xsl"/>
    <xsl:output indent="yes"/>
    
    

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
<OBJECT id="ZAS" codeBase="http://download.macromedia.com/pub/shockwave/cabs/flash/swflash.cab#version=6,0,0,0" height="395" width="590" align="center" classid="clsid:D27CDB6E-AE6D-11cf-96B8-444553540000">
<PARAM NAME="src" VALUE="/themes/pff/ZAS.swf" />
<PARAM NAME="quality" VALUE="high" />
<PARAM NAME="bgcolor" VALUE="#FFFFFF" />
<PARAM NAME="FlashVars" VALUE="gDefaultLabelVisibility=1&#38;gServerIP=drcdev.ohiolink.edu&#38;gServerPort=80&#38;gByteHandlerPath=/jspui/dspacezoomifyServlet&#38;gImagePath={substring(mets:file/@ID,6)}.pff&#38;gMenuX=-1&#38;gPOIX=-1&#38;gLabelsX=-1&#38;gNavbarX=195&#38;gNavbarY=350&#38;gViewX=-1&#38;gConferenceX=-1&#38;gRulerX=200&#38;gSkipLogin=1" />
<EMBED src="/themes/pff/ZAS.swf" FlashVars="gDefaultLabelVisibility=1&#38;gServerIP=drcdev.ohiolink.edu&#38;gServerPort=80&#38;gByteHandlerPath=/jspui/dspacezoomifyServlet&#38;gImagePath={substring(mets:file/@ID,6)}.pff&#38;gMenuX=-1&#38;gPOIX=-1&#38;gLabelsX=-1&#38;gNavbarX=195&#38;gNavbarY=350&#38;gViewX=-1&#38;gConferenceX=-1&#38;gRulerX=200&#38;gSkipLogin=1" quality="high" bgcolor="#ffffff" WIDTH="590" HEIGHT="395" TYPE="application/x-shockwave-flash" PLUGINSPAGE="http://www.macromedia.com/go/getflashplayer"></EMBED>
</OBJECT>
 
    </div> 
    </xsl:template>


 
</xsl:stylesheet>
