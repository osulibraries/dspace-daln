<?xml version="1.0" encoding="UTF-8"?>

<!--
  carousel.xsl

  This theme is a combination of the prototype jquery carousel
  theme (modified to use bitstreams in the 'CAROUSEL' bundle
  and the prototype zoomify theme.

  This theme requires ohiolink_common, DRC, and pff_drc themes

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
    
    <xsl:import href="../ohiolink_common/ohiolink_common.xsl"/>
    <xsl:import href="../pff_drc/pffmultijs.xsl" />
    <xsl:output indent="yes"/>
    
  
    <!-- The HTML head element contains references to CSS as well as embedded JavaScript code. Most of this 
        information is either user-provided bits of post-processing (as in the case of the JavaScript), or 
        references to stylesheets pulled directly from the pageMeta element. -->
    <xsl:template name="buildHead">
        <head>
            <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
            <!-- Add stylsheets -->
            <xsl:for-each select="/dri:document/dri:meta/dri:pageMeta/dri:metadata[@element='stylesheet']">
                <link rel="stylesheet" type="text/css">
                    <xsl:attribute name="media">
                        <xsl:value-of select="@qualifier"/>
                    </xsl:attribute>
                    <xsl:attribute name="href">
                        <xsl:value-of select="/dri:document/dri:meta/dri:pageMeta/dri:metadata[@element='contextPath'][not(@qualifier)]"/>
                        <xsl:text>/themes/</xsl:text>
                        <xsl:value-of select="/dri:document/dri:meta/dri:pageMeta/dri:metadata[@element='theme'][@qualifier='path']"/>
                        <xsl:text>/</xsl:text>
                        <xsl:value-of select="."/>
                    </xsl:attribute>
                </link>
            </xsl:for-each>
            
            <!-- Add syndication feeds -->
            <xsl:for-each select="/dri:document/dri:meta/dri:pageMeta/dri:metadata[@element='feed']">
                <link rel="alternate" type="application">
                    <xsl:attribute name="type">
                        <xsl:text>application/</xsl:text>
                        <xsl:value-of select="@qualifier"/>
                    </xsl:attribute>
                    <xsl:attribute name="href">
                        <xsl:value-of select="."/>
                    </xsl:attribute>
                </link>
            </xsl:for-each>
            

            <!-- The following javascript removes the default text of empty text areas when they are focused on or submitted -->
            <!-- There is also javascript to disable submitting a form when the 'enter' key is pressed. -->
			<script type="text/javascript">
				//Clear default text of emty text areas on focus
				function tFocus(element)
				{
					if (element.value == '<i18n:text>xmlui.dri2xhtml.default.textarea.value</i18n:text>'){element.value='';}
				}
				//Clear default text of emty text areas on submit
				function tSubmit(form)
				{
					var defaultedElements = document.getElementsByTagName("textarea");
					for (var i=0; i != defaultedElements.length; i++){
						if (defaultedElements[i].value == '<i18n:text>xmlui.dri2xhtml.default.textarea.value</i18n:text>'){
							defaultedElements[i].value='';}}
				}
				//Disable pressing 'enter' key to submit a form (otherwise pressing 'enter' causes a submission to start over)
				function disableEnterKey(e)
				{
				     var key;
				
				     if(window.event)
				          key = window.event.keyCode;     //Internet Explorer
				     else
				          key = e.which;     //Firefox and Netscape
				
				     if(key == 13)  //if "Enter" pressed, then disable!
				          return false;
				     else
				          return true;
				}
            </script>
            
            <!-- Add javascript  -->
            <xsl:for-each select="/dri:document/dri:meta/dri:pageMeta/dri:metadata[@element='javascript']">
                <script type="text/javascript">
                    <xsl:attribute name="src">
                        <xsl:value-of select="/dri:document/dri:meta/dri:pageMeta/dri:metadata[@element='contextPath'][not(@qualifier)]"/>
                        <xsl:text>/themes/</xsl:text>
                        <xsl:value-of select="/dri:document/dri:meta/dri:pageMeta/dri:metadata[@element='theme'][@qualifier='path']"/>
                        <xsl:text>/</xsl:text>
                        <xsl:value-of select="."/>
                    </xsl:attribute>
                    &#160;
                </script>
            </xsl:for-each>

<script type="text/javascript">
jQuery(document).ready(function() {
    jQuery('#mycarousel').jcarousel({
        // Configuration goes here
    });
});
</script>


            <!-- Add the title in -->
            <xsl:variable name="page_title" select="/dri:document/dri:meta/dri:pageMeta/dri:metadata[@element='title']" />
            <title>
                <xsl:choose>
                	<xsl:when test="not($page_title)">
                		<xsl:text>  </xsl:text>
                	</xsl:when>
                	<xsl:otherwise>
                		<xsl:copy-of select="$page_title/node()" />
                	</xsl:otherwise>
                </xsl:choose>
            </title>
        </head>
    </xsl:template>


 <!-- Generate PFF Zoomify  objects for images in the ZOOM bundle -->
    <!-- METS file ID will be in the form file_xxxx, where xxxx
        Is the DSPace bitstream ID.  The substring function is used to strip
        the 'file_' portion from the ID -->

    <xsl:template match="mets:fileGrp[@USE='ZOOM']">
      <div>
                <!-- KRG prototype test of getting file via bitstream id instead of relative path -->
<OBJECT  id="ZAS" codeBase="http://download.macromedia.com/pub/shockwave/cabs/flash/swflash.cab#version=6,0,0,0" height="395" width="590" align="center" classid="clsid:D27CDB6E-AE6D-11cf-96B8-444553540000">
<PARAM NAME="src" VALUE="/themes/pff_drc/ZAS.swf" />
<PARAM NAME="quality" VALUE="high" />
<PARAM NAME="bgcolor" VALUE="#FFFFFF" />
<PARAM NAME="swliveconnect" VALUE="true" />
<PARAM NAME="FlashVars" VALUE="gDefaultLabelVisibility=1&#38;gServerIP=drc.ohiolink.edu&#38;gServerPort=80&#38;gByteHandlerPath=/ohiolink_zoom/dspacezoomifyServlet&#38;gImagePath={substring(mets:file[last()]/@ID,6)}.pff&#38;gMenuX=-1&#38;gPOIX=-1&#38;gLabelsX=-1&#38;gNavbarX=195&#38;gNavbarY=350&#38;gViewX=-1&#38;gConferenceX=-1&#38;gRulerX=200&#38;gSkipLogin=1" />
<EMBED name="ZAS" src="/themes/pff_drc/ZAS.swf" FlashVars="gDefaultLabelVisibility=1&#38;gServerIP=drc.ohiolink.edu&#38;gServerPort=80&#38;gByteHandlerPath=/ohiolink_zoom/dspacezoomifyServlet&#38;gImagePath={substring(mets:file[last()]/@ID,6)}.pff&#38;gMenuX=-1&#38;gPOIX=-1&#38;gLabelsX=-1&#38;gNavbarX=195&#38;gNavbarY=350&#38;gViewX=-1&#38;gConferenceX=-1&#38;gRulerX=200&#38;gSkipLogin=1" quality="high" bgcolor="#ffffff" WIDTH="590" HEIGHT="395" TYPE="application/x-shockwave-flash" PLUGINSPAGE="http://www.macromedia.com/go/getflashplayer" swliveconnect="true"></EMBED>
</OBJECT>

<!-- 
     Include a jquery carousel as an image-chooser,
     but only if there is more than one image in this item
-->
<xsl:if test="count(mets:file) > 1">
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
          flash.LoadMovie(0, "/themes/pff_drc/dummy.swf");
        }
        flash.LoadMovie(0, "/themes/pff_drc/ZAS.swf");
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
        flash.SetVariable("gServerIP", "drc.ohiolink.edu");
        flash.SetVariable("gByteHandlerPath", "/ohiolink_zoom/dspacezoomifyServlet");
        flash.SetVariable("gImagePath", pffFilename);

  }
  </script>
<ul class="jcarousel-skin-ie7" id="mycarousel">
<xsl:for-each select="/mets:METS/mets:fileSec/mets:fileGrp[@USE='CAROUSEL']/mets:file" >
<xsl:sort select="mets:FLocat/@xlink:title" />
  <xsl:variable name="thisfilename" select="./mets:FLocat/@xlink:title" />
  <xsl:variable name="basefilename" select="substring($thisfilename, 0, string-length($thisfilename) -3 )" />
  <xsl:variable name="pfffilename" select="concat($basefilename, '.pff')" /> 
  <xsl:variable name="pffid" select="substring(/mets:METS/mets:fileSec/mets:fileGrp[@USE='ZOOM']/mets:file[mets:FLocat/@xlink:title=$pfffilename]/@ID, 6)" /> 
  <li jcarouselindex="2" class="jcarousel-item jcarousel-item-horizontal jcarousel-item-2 jcarousel-item-2-horizontal">
    <img src="{./mets:FLocat[@LOCTYPE='URL']/@xlink:href}" alt="{$basefilename}" border="0" width="110" height="130" onClick="switchZoomImage('{$pffid}.pff');" />
  </li>
</xsl:for-each>

 </ul>
</xsl:if>
</div>
</xsl:template>
 
  <!-- Build a single row in the bitsreams table of the item view page 
      This template  has been overridden so that thumbnails are not displayed
      here.  The page takes too long to load for items with many bitstreams,
      which is what the zoomisel theme was designed for...
   -->
    <xsl:template match="mets:file">
        <xsl:param name="context" select="."/>
        <tr>
            <xsl:attribute name="class">
                <xsl:text>ds-table-row </xsl:text>
                <xsl:if test="(position() mod 2 = 0)">even </xsl:if>
                <xsl:if test="(position() mod 2 = 1)">odd </xsl:if>
            </xsl:attribute>
            <td>
                <a>
                    <xsl:attribute name="href">
                        <xsl:value-of select="mets:FLocat[@LOCTYPE='URL']/@xlink:href"/>
                    </xsl:attribute>
                    <xsl:attribute name="title">
                        <xsl:value-of select="mets:FLocat[@LOCTYPE='URL']/@xlink:title"/>
                    </xsl:attribute>
                    <xsl:choose>
                        <xsl:when test="string-length(mets:FLocat[@LOCTYPE='URL']/@xlink:title) > 50">
                            <xsl:variable name="title_length" select="string-length(mets:FLocat[@LOCTYPE='URL']/@xlink:title)"/>
                            <xsl:value-of select="substring(mets:FLocat[@LOCTYPE='URL']/@xlink:title,1,15)"/>
                            <xsl:text> ... </xsl:text>
                            <xsl:value-of select="substring(mets:FLocat[@LOCTYPE='URL']/@xlink:title,$title_length - 25,$title_length)"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="mets:FLocat[@LOCTYPE='URL']/@xlink:title"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </a>
            </td>
            <!-- File size always comes in bytes and thus needs conversion -->
            <td>
                <xsl:choose>
                    <xsl:when test="@SIZE &lt; 1000">
                        <xsl:value-of select="@SIZE"/>
                        <i18n:text>xmlui.dri2xhtml.METS-1.0.size-bytes</i18n:text>
                    </xsl:when>
                    <xsl:when test="@SIZE &lt; 1000000">
                        <xsl:value-of select="substring(string(@SIZE div 1000),1,5)"/>
                        <i18n:text>xmlui.dri2xhtml.METS-1.0.size-kilobytes</i18n:text>
                    </xsl:when>
                    <xsl:when test="@SIZE &lt; 1000000000">
                        <xsl:value-of select="substring(string(@SIZE div 1000000),1,5)"/>
                        <i18n:text>xmlui.dri2xhtml.METS-1.0.size-megabytes</i18n:text>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="substring(string(@SIZE div 1000000000),1,5)"/>
                        <i18n:text>xmlui.dri2xhtml.METS-1.0.size-gigabytes</i18n:text>
                    </xsl:otherwise>
                </xsl:choose>
            </td>
            <!-- Currently format carries forward the mime type. In the original DSpace, this 
                would get resolved to an application via the Bitstream Registry, but we are
                constrained by the capabilities of METS and can't really pass that info through. -->
            <td><xsl:value-of select="substring-before(@MIMETYPE,'/')"/>
                <xsl:text>/</xsl:text>
               <xsl:value-of select="substring-after(@MIMETYPE,'/')"/>
            </td>
            <td>
                        <a>
                            <xsl:attribute name="href">
                                <xsl:value-of select="mets:FLocat[@LOCTYPE='URL']/@xlink:href"/>
                            </xsl:attribute>
                            <i18n:text>xmlui.dri2xhtml.METS-1.0.item-files-viewOpen</i18n:text>
                        </a>
            </td>
        </tr>
    </xsl:template>


</xsl:stylesheet>
