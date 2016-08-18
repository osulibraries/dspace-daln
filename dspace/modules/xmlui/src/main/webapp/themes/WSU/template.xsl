<?xml version="1.0" encoding="UTF-8"?>

<!--
  template.xsl

-->

<!--
    DSpace 1.5 xmlui theme for WSU CORE system on the OhioLINK
    Digital Resource Commons. 

    Customizations:
    
    - Clickable subject fields in full item record
    - Clickable identifier.other URLs in full item recrod
    - Label contributor.artist as Artist in short item record
    - Display creation dates (instead of submission date) in short item record
	- Transform dc.date.created to "January 10, 1900" -Jeff C. April 2010
    - Display MP3 player widget for MP3 files in short item record
    - Lightbox style viewing of images when clicking on image thumbnails in short item record
    - Display Repository field in short item record
    - Manakin 1.1 style "Preview" row in short item record (but only when thumbnail available)
    - Lightbox of full-size image in Manakin 1.1 Preview
    - Google analytics code
    - Allow use of licenses named other than "license.txt"
    - Display multiple licenses in an item, when available
    - Allow HTML in abstract/description fields on item summary, item detail pages
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
        xmlns:dcterms="http://purl.org/dc/terms/"
        xmlns="http://www.w3.org/1999/xhtml"
	exclude-result-prefixes="i18n dri mets xlink xsl dim xhtml mods dc dcterms">
    
    <xsl:import href="../ohiolink_common/ohiolink_common.xsl"/>
   <!-- <xsl:output indent="yes"/> -->
 
    <!-- Global variables -->
    
    <!-- 
        Context path provides easy access to the context-path parameter. This is 
        used when building urls back to the site, they all must include the 
        context-path paramater. 
    -->
    <xsl:variable name="context-path" select="/dri:document/dri:meta/dri:pageMeta/dri:metadata[@element='contextPath'][not(@qualifier)]"/>
    
    <!--
        Theme path represents the full path back to theme. This is usefull for 
        accessing static resources such as images or javascript files. Simply 
        prepend this variable and then add the file name, thus 
        {$theme-path}/images/myimage.jpg will result in the full path from the 
        HTTP root down to myimage.jpg. The theme path is composed of the 
        "[context-path]/themes/[theme-dir]/". 
    -->
    <xsl:variable name="theme-path" select="concat($context-path,'/themes/',/dri:document/dri:meta/dri:pageMeta/dri:metadata[@element='theme'][@qualifier='path'])"/>

    <!-- 
    This style sheet will be written in several stages:
        1. Establish all the templates that catch all the elements
        2. Finish implementing the XHTML output within the templates
        3. Figure out the special case stuff as well as the small details
        4. Clean up the code
    
    Currently in stage 3...
        
    Last modified on: 3/15/2006
    -->
    
    <!-- This stylesheet's purpose is to translate a DRI document to an HTML one, a task which it accomplishes
        through interative application of templates to select elements. While effort has been made to
        annotate all templates to make this stylesheet self-documenting, not all elements are used (and 
        therefore described) here, and those that are may not be used to their full capacity. For this reason,
        you should consult the DRI Schema Reference manual if you intend to customize this file for your needs.
    -->
        
    <!--
        The starting point of any XSL processing is matching the root element. In DRI the root element is document, 
        which contains a version attribute and three top level elements: body, options, meta (in that order). 
        
        This template creates the html document, giving it a head and body. A title and the CSS style reference
        are placed in the html head, while the body is further split into several divs. The top-level div
        directly under html body is called "ds-main". It is further subdivided into:
            "ds-header"  - the header div containing title, subtitle, trail and other front matter
            "ds-body"    - the div containing all the content of the page; built from the contents of dri:body
            "ds-options" - the div with all the navigation and actions; built from the contents of dri:options
            "ds-footer"  - optional footer div, containing misc information
        
        The order in which the top level divisions appear may have some impact on the design of CSS and the 
        final appearance of the DSpace page. While the layout of the DRI schema does favor the above div 
        arrangement, nothing is preventing the designer from changing them around or adding new ones by 
        overriding the dri:document template.   
    -->
    <xsl:template match="dri:document">
        <html>
            <!-- First of all, build the HTML head element -->
            <xsl:call-template name="buildHead"/>
            <!-- Then proceed to the body -->
            <body style="background-color:white;margin-top:0px;margin-left:0px;margin-bottom:0px;margin-right:0px;"  >

                <div id="ds-main">
                    <!-- 
                        The header div, complete with title, subtitle, trail and other junk. The trail is 
                        built by applying a template over pageMeta's trail children. -->
                    <xsl:call-template name="buildHeader"/>
                    
                    <!-- 
                        Goes over the document tag's children elements: body, options, meta. The body template
                        generates the ds-body div that contains all the content. The options template generates
                        the ds-options div that contains the navigation and action options available to the 
                        user. The meta element is ignored since its contents are not processed directly, but 
                        instead referenced from the different points in the document. -->
<!-- JRD 9/11/07 Adding Left-side nav. -->
<table border="0" cellpadding="0" cellspacing="0" width="100%">
<tbody><tr><td style="background-color:#00523a;width:149px;"  height="100%" valign="top" >
<table border="0" cellpadding="0" cellspacing="0" height="100%" width="149px">
        <tbody><tr><td style="background-color:#00523a;" valign="top"><img src="/themes/WSU/lib/spacer.gif" height="10" width="6" /><br />
<div style="margin-left: 12px; margin-right: 12px;">
  <p style="margin-top:6px;margin-left:1px;line-height:12px;"><a class="subnav" href="/" style="font-size:13px;">CORE Home</a><br/>
    <br/>
  </p><p style="margin-top:6px;margin-left:1px;line-height:12px;"><a class="subnav" href="/contribute.html" style="font-size:13px;">How to Contribute</a><br/>
    <br/>
    <a class="subnav" href="/content.html" style="font-size:13px;">Content Guidelines</a><br/>
    <br/>
    <a class="subnav" href="/rights.html" style="font-size:12px;">Rights &amp; Responsibilities</a><br/><br/><a class="subnav" href="/faq.html" style="font-size:13px;">FAQ</a><br/>
    <br/>                 
    <a class="subnav" style="font-size:13px;line-height:7px;" href="mailto:digital@www.libraries.wright.edu">Contact Digital Services</a><br/>
    <br/>
    <a class="subnav" style="font-size:13px;" href="http://drc.ohiolink.edu/">OhioLINK Digital Resource Commons</a>
    <br/>
    <br/>
    <br/>
    <br/>
    
  </p>
</div>
		</td></tr>
        <tr valign="bottom">
        <td style="background-color:#00523a;" height="100%" valign="bottom"><img src="/themes/WSU/lib/biplane.gif" name="biplane" alt="First flight of the Wright Brothers" /></td></tr>
		</tbody></table>
</td><td>




				<!-- JRD 9/17/07 Adding breadcrumb trail	-->            
				<ul id="ds-trail">
                <xsl:apply-templates select="/dri:document/dri:meta/dri:pageMeta/dri:trail"/>
            </ul>
		<xsl:apply-templates />
		
		
	</td></tr></tbody></table>
                    <!-- 
                        The footer div, dropping whatever extra information is needed on the page. It will
                        most likely be something similar in structure to the currently given example. -->
                    <xsl:call-template name="buildFooter"/>
                    
                </div>
<!-- JRD 10/15/08 Adding Google Analytics -->
<script type="text/javascript">
var gaJsHost = (("https:" == document.location.protocol) ? "https://ssl." : "http://www.");
document.write(unescape("%3Cscript src='" + gaJsHost + "google-analytics.com/ga.js' type='text/javascript'%3E%3C/script%3E"));
</script>
<script type="text/javascript">
var pageTracker_WSU = _gat._getTracker("UA-3788629-3");
pageTracker_WSU._trackPageview();
</script>
<script type="text/javascript">
var pageTracker_OhioLINK = _gat._getTracker("UA-5946124-2");
pageTracker_OhioLINK._trackPageview();
</script>

            </body>
        </html>
    </xsl:template>

    <!-- The HTML head element contains references to CSS as well as embedded JavaScript code. Most of this 
        information is either user-provided bits of post-processing (as in the case of the JavaScript), or 
        references to stylesheets pulled directly from the pageMeta element. -->
    <xsl:template name="buildHead">
        <head>
            <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>

            <!-- JRD 9/5/07 Adding javascript calls and css calls for using the lightbox.js v2 file -->
            
            <!-- KRG 10/12/2007 Moving css and js calls for lightbox to sitemap, experimenting with lightbox_plus -->
            <!-- Add stylesheets  from sitemap.xmap -->
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
            
            <!-- Add javascript  from sitemap.xmap-->
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
 
            <!-- JRD 9/09/07 Adding highlighter.css for WSU header replication -->
			<link rel="stylesheet" type="text/css">
                    <xsl:attribute name="media">
                        <xsl:value-of select="@qualifier"/>
                    </xsl:attribute>
                    <xsl:attribute name="href">
                        <xsl:value-of select="/dri:document/dri:meta/dri:pageMeta/dri:metadata[@element='contextPath'][not(@qualifier)]"/>
                        <xsl:text>/themes/</xsl:text>
                        <xsl:value-of select="/dri:document/dri:meta/dri:pageMeta/dri:metadata[@element='theme'][@qualifier='path']"/>
                        <xsl:text>/lib/highlighter.css</xsl:text>
                    </xsl:attribute>
            </link>
            <!-- JRD 9/09/07 Adding wsustyle.css for WSU header replication -->
			<link rel="stylesheet" type="text/css">
                    <xsl:attribute name="media">
                        <xsl:value-of select="@qualifier"/>
                    </xsl:attribute>
                    <xsl:attribute name="href">
                        <xsl:value-of select="/dri:document/dri:meta/dri:pageMeta/dri:metadata[@element='contextPath'][not(@qualifier)]"/>
                        <xsl:text>/themes/</xsl:text>
                        <xsl:value-of select="/dri:document/dri:meta/dri:pageMeta/dri:metadata[@element='theme'][@qualifier='path']"/>
                        <xsl:text>/lib/wsustyle.css</xsl:text>
                    </xsl:attribute>
            </link>
            
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
            
            <!-- the following javascript removes the default text of empty text areas when they are focused on or submitted -->
            <script type="text/javascript">
                function tFocus(element){if (element.value == '<i18n:text>xmlui.dri2xhtml.default.textarea.value</i18n:text>'){element.value='';}}
                function tSubmit(form){var defaultedElements = document.getElementsByTagName("textarea");
                for (var i=0; i != defaultedElements.length; i++){
                if (defaultedElements[i].value == '<i18n:text>xmlui.dri2xhtml.default.textarea.value</i18n:text>'){
                defaultedElements[i].value='';}}}
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








    <!-- The header (distinct from the HTML head element) contains the title, subtitle, login box and various 
        placeholders for header images -->
    <xsl:template name="buildHeader">
		<div id="ds-header">
<!-- JRD 9/09/07 Adding WSU Header information, table-based design. --> 
<div id="WSU-header"><table border="0" cellpadding="0" cellspacing="0" width="100%" height="80">
<tbody><tr><td valign="top"> 
	<table border="0" cellpadding="0" cellspacing="0" width="100%">
    <tbody><tr><td style="width:148px;"><a href="http://www.wright.edu/" ><img src="/themes/WSU/lib/b_wsulogo.gif" name="b_wsulogo" alt="Wright State University" border="0" height="80" width="148" /></a></td>
	<td align="right" style="background-image:url('/themes/WSU/lib/bg_banner_quicklinks.jpg')" valign="bottom" width="100%">
		<table border="0" cellpadding="0" cellspacing="0" width="100%">
		<tbody><tr><td style="text-align:left;" valign="bottom"><a href="http://www.libraries.wright.edu/index.html"><img src="/themes/WSU/lib/spacer_002.gif" name="home_spacer" alt="University Libraries" border="0" height="45" width="350" /></a></td>
		<td align="right" valign="bottom"><a href="http://www.libraries.wright.edu/services/ask/"><img src="/themes/WSU/lib/b_askalib_trans.gif" name="b_askalib_trans" alt="Ask a Librarian" border="0" height="80" width="153" /></a></td></tr>
		</tbody></table></td></tr></tbody></table></td></tr>
<tr><td valign="top">
	<table border="0" cellpadding="0" cellspacing="0" width="100%">
    <tbody><tr><td style="background-image:url('/themes/WSU/lib/bg_searchcat.gif');width:100%;background-repeat:repeat-x;" ><img src="/themes/WSU/lib/spacer.gif" height="18" width="1" /></td>
	<td><a href="http://www.libraries.wright.edu/services/ask/"><img src="/themes/WSU/lib/b_askalib_bot.gif" name="b_askalib_bot" alt="Ask a Librarian" border="0" height="18" width="149" /></a></td></tr></tbody></table></td></tr>
<tr height="2"><td valign="top" height="2"><img src="/themes/WSU/lib/spacer.gif" height="2" width="1" /></td></tr>

<tr><td valign="top"><img src="/themes/WSU/lib/spacer.gif" height="2" width="1" /></td></tr></tbody></table>
		</div></div>
	</xsl:template>
    
    
	
	
    <!-- 
        The trail is built one link at a time. Each link is given the ds-trail-link class, with the first and
        the last links given an additional descriptor. 
    --> 
    <xsl:template match="dri:trail">
        <li>
            <xsl:attribute name="class">
                <xsl:text>ds-trail-link </xsl:text>
                <xsl:if test="position()=1">
                    <xsl:text>first-link</xsl:text>
                </xsl:if>
                <xsl:if test="position()=last()">
                    <xsl:text>last-link</xsl:text>
                </xsl:if>
            </xsl:attribute>
            <!-- Determine whether we are dealing with a link or plain text trail link -->
            <xsl:choose>
                <xsl:when test="./@target">
                    <a>
                        <xsl:attribute name="href">
                            <xsl:value-of select="./@target"/>
                        </xsl:attribute>
                        <xsl:apply-templates />
                    </a>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:apply-templates />
                </xsl:otherwise>
            </xsl:choose>
        </li>
    </xsl:template>
	
	
	

    
    <!-- An example of an existing template copied from structural.xsl and overridden -->  
    <xsl:template name="buildFooter">
        <div id="ds-footer">
<table border="0" cellpadding="0" cellspacing="0" width="100%">	
<tbody><tr  style="background-color:#16264b;"> <td colspan="3" valign="top"><img src="/themes/WSU/lib/spacer.gif" height="8" width="1" /></td></tr>
<tr style="background-color:#9eda74;" valign="top"> <td colspan="3"> 
	<table border="0" cellpadding="6" cellspacing="0">
	<tbody><tr><td style="height:30px;"><a href="http://www.libraries.wright.edu/about/contact/" class="blacklink">Contact Us</a> 
	<a href="http://www.libraries.wright.edu/services/help/" class="blacklink">Need Help?</a>
	<a href="http://www.google.com/u/wsul" class="blacklink">Site Search</a></td></tr>
</tbody></table></td></tr>
<tr style="background-color:#000000;"><td colspan="3" align="right" valign="top"> 
<table border="0" align="right" cellpadding="8" cellspacing="0">
<tbody><tr><td><div class="gray" style="text-align:right;">
<a href="http://www.wright.edu/web/copyright.html" class="gray">Copyright Information</a> &#169; 2003 | <a href="http://www.wright.edu/web/access/" class="gray">Accessibility Information</a><br />
Last updated Mon. Aug-21-06, 11:12<br />
Please send comments to the <a href="mailto:webmaster@www.libraries.wright.edu" class="gray">Web Team</a>.
</div></td></tr></tbody></table></td></tr></tbody></table>
        </div>
    </xsl:template>

    
    
   
        <!--
        Display an overview of an item, this is used on the /handle/xxxx/yyyy pages for items. This
        template will summarize an item's metdata, pulling out important fields such as title,
        author, abstract, description, uri, and date. Then below this the item's files and license
        will be listed.

        To change what fields are listed, and how they are displayed, implement this method inside
        the theme's XSL.
     -->
    <xsl:template name="itemSummaryView-DIM">
        <xsl:variable name="data" select="./mets:METS/mets:dmdSec/mets:mdWrap/mets:xmlData/dim:dim"/>
        <xsl:variable name="context" select="."/>
        
        <!-- if there are mp3 files in this item, embed a player (or two) on the page
          Uses the neolao player found at http://flash-mp3-player.net   
         -->
        <xsl:if test="./mets:fileSec/mets:fileGrp[@USE='CONTENT']/mets:file[@MIMETYPE='audio/mpeg']">
          <hr/>
          <h2>Listen</h2>
          <table>
            <xsl:for-each select="./mets:fileSec/mets:fileGrp[@USE='CONTENT']/mets:file[@MIMETYPE='audio/mpeg']">
            <tr>
              <th>
                <xsl:value-of select="./mets:FLocat[@LOCTYPE='URL']/@xlink:title" />
              </th>
            </tr>
            <tr>
              <td>
                <object type="application/x-shockwave-flash" data="/themes/WSU/player_mp3_maxi.swf" width="200" height="20">
                  <param name="movie" value="/themes/WSU/player_mp3_maxi.swf" />
                  <param name="FlashVars" value="mp3={./mets:FLocat[@LOCTYPE='URL']/@xlink:href}&amp;showvolume=1&amp;bgcolor1=00523A&amp;bgcolor2=82C455" />
                </object>
              </td>
            </tr>
            </xsl:for-each>
          </table>
          <hr/>
          <br />
      </xsl:if>


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
 
        <xsl:if test="./mets:fileSec/mets:fileGrp[@USE='CC-LICENSE' or @USE='LICENSE']">
            <div class="license-info">
                <p><i18n:text>xmlui.dri2xhtml.METS-1.0.license-text</i18n:text></p>
                <ul>
                    <xsl:if test="./mets:fileSec/mets:fileGrp[@USE='CC-LICENSE']">
                        <li>
                        <a href="{./mets:fileSec/mets:fileGrp[@USE='CC-LICENSE']/mets:file/
                            mets:FLocat[@xlink:title='license_text']/@xlink:href}">
                        <img alt="Creative Commons" src="{$theme-path}/lib/images/cc-somerights.gif" />                    
                        </a>
                        </li>
                    </xsl:if>
                    <xsl:if test="./mets:fileSec/mets:fileGrp[@USE='LICENSE']">
                        <xsl:for-each select="./mets:fileSec/mets:fileGrp[@USE='LICENSE']/mets:file">
                        <li><a href="{./mets:FLocat[@LOCTYPE='URL']/@xlink:href}"><xsl:value-of select="./mets:FLocat[@LOCTYPE='URL']/@xlink:title" /></a></li>
                        </xsl:for-each>
                    </xsl:if>
                </ul>
            </div>
        </xsl:if>
    </xsl:template>


    <!-- Generate the info about the item from the metadata section -->
    <xsl:template match="dim:dim" mode="itemSummaryView-DIM">
        <table class="ds-includeSet-table">
           <xsl:if test="/mets:METS/mets:fileSec/mets:fileGrp[@USE='THUMBNAIL']"> <!-- Preview Thumbnail -->
            <tr class="ds-table-row odd">
                <td><span class="bold"><i18n:text>xmlui.dri2xhtml.METS-1.0.item-preview</i18n:text>:</span></td>
                <td>
                        <xsl:variable name="thumbcandidate" select="/mets:METS/mets:fileSec/mets:fileGrp[@USE='CONTENT']
                                            /mets:file[@MIMETYPE='image/jpeg'][last()]" />
                             <a class="image-link" rel="lightbox">
                               <xsl:attribute name="href">
                                  <xsl:value-of select="$thumbcandidate/mets:FLocat[@LOCTYPE='URL']/@xlink:href"/>
                               </xsl:attribute>
                                <img alt="Thumbnail">
                                    <xsl:attribute name="src">
                                        <xsl:value-of select="/mets:METS/mets:fileSec/mets:fileGrp[@USE='THUMBNAIL']
                                             /mets:file[@GROUP_ID=($thumbcandidate/@GROUP_ID)]
                                             /mets:FLocat[@LOCTYPE='URL']/@xlink:href"/>
                                    </xsl:attribute>
                                </img>
                            </a>
                </td>
            </tr>
            </xsl:if>

            <tr class="ds-table-row even"> <!-- dc.title -->
                <td><span class="bold"><i18n:text>xmlui.dri2xhtml.METS-1.0.item-title</i18n:text>: </span></td>
                <td>
                    <xsl:choose>
                        <xsl:when test="count(dim:field[@element='title'][not(@qualifier)]) &gt; 1">
                            <xsl:for-each select="dim:field[@element='title'][not(@qualifier)]">
                                <xsl:value-of select="./node()"/>
                                <xsl:if test="count(following-sibling::dim:field[@element='title'][not(@qualifier)]) != 0">
                                            <xsl:text>; </xsl:text><br/>
                                        </xsl:if>
                            </xsl:for-each>
                        </xsl:when>
                         <xsl:when test="count(dim:field[@element='title'][not(@qualifier)]) = 1">
                            <xsl:value-of select="dim:field[@element='title'][not(@qualifier)][1]/node()"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <i18n:text>xmlui.dri2xhtml.METS-1.0.no-title</i18n:text>
                        </xsl:otherwise>
                    </xsl:choose>
                </td>
            </tr>

            <!-- dc.contributor.author, dc.creator, dc.contributor -->
			<xsl:if test="dim:field[@element='contributor'][@qualifier='author'] or dim:field[@element='creator'] or dim:field[@element='contributor']">
                    <tr class="ds-table-row odd">
                         <!-- if the contributor.artist field is present, label this field as Artist (for Stein Galleries).
                 Otherwise, use the default label (Author)
             -->
             <xsl:choose>
               <xsl:when test="dim:field[@element='contributor'][@qualifier='artist']">
                  <td><span class="bold"><xsl:text>Artist</xsl:text>:</span></td>
               </xsl:when>
              <xsl:otherwise>
                 <td><span class="bold"><i18n:text>xmlui.dri2xhtml.METS-1.0.item-author</i18n:text>:</span></td>
               </xsl:otherwise>
              </xsl:choose>
                 <td>
                                        <xsl:choose>
                        <xsl:when test="dim:field[@element='contributor'][@qualifier='artist']">
                            <xsl:for-each select="dim:field[@element='contributor'][@qualifier='artist']">
                                <xsl:copy-of select="."/>
                                <xsl:if test="count(following-sibling::dim:field[@element='contributor'][@qualifier='artist']) != 0">
                                    <xsl:text>; </xsl:text>
                                </xsl:if>
                            </xsl:for-each>
                        </xsl:when>

                        <xsl:when test="dim:field[@element='contributor'][@qualifier='author']">
                            <xsl:for-each select="dim:field[@element='contributor'][@qualifier='author']">
                                <xsl:copy-of select="."/>
                                <xsl:if test="count(following-sibling::dim:field[@element='contributor'][@qualifier='author']) != 0">
                                    <xsl:text>; </xsl:text>
                                </xsl:if>
                            </xsl:for-each>
                        </xsl:when>
                        <xsl:when test="dim:field[@element='creator']">
                            <xsl:for-each select="dim:field[@element='creator']">
                                <xsl:copy-of select="."/>
                                <xsl:if test="count(following-sibling::dim:field[@element='creator']) != 0">
                                    <xsl:text>; </xsl:text>
                                </xsl:if>
                            </xsl:for-each>
                        </xsl:when>
                        <xsl:when test="dim:field[@element='contributor']">
                            <xsl:for-each select="dim:field[@element='contributor']">
                                <xsl:copy-of select="."/>
                                <xsl:if test="count(following-sibling::dim:field[@element='contributor']) != 0">
                                    <xsl:text>; </xsl:text>
                                </xsl:if>
                            </xsl:for-each>
                        </xsl:when>
                        <xsl:otherwise>
                            <i18n:text>xmlui.dri2xhtml.METS-1.0.no-author</i18n:text>
                        </xsl:otherwise>
                    </xsl:choose>
                </td>
                    </tr>
            </xsl:if>

			<xsl:if test="dim:field[@element='description' and @qualifier='abstract']"> <!-- dc.description.abstract -->
                    <tr class="ds-table-row even">
                        <td><span class="bold"><i18n:text>xmlui.dri2xhtml.METS-1.0.item-abstract</i18n:text>:</span></td>
                        <td>
                        <xsl:for-each select="dim:field[@element='description' and @qualifier='abstract']">
                                <xsl:value-of select="." disable-output-escaping="yes" /> <!-- Allow HTML in this field -->
                        </xsl:for-each>
                        </td>
                    </tr>
            </xsl:if>

			<xsl:if test="dim:field[@element='description' and not(@qualifier)]"> <!-- dc.description -->
                    <tr class="ds-table-row odd">
                        <td><span class="bold"><i18n:text>xmlui.dri2xhtml.METS-1.0.item-description</i18n:text>:</span></td>
                        <td>
                        <xsl:for-each select="dim:field[@element='description' and not(@qualifier)]">
                                <xsl:value-of select="." disable-output-escaping="yes" /> <!-- Allow HTML in this field -->
                        </xsl:for-each>
                        </td>
                    </tr>
            </xsl:if>

            <xsl:if test="dim:field[@element='identifier' and @qualifier='uri']"> <!-- identifier.uri -->
                    <tr class="ds-table-row even">
                        <td><span class="bold"><i18n:text>xmlui.dri2xhtml.METS-1.0.item-uri</i18n:text>:</span></td>
                        <td>
                                <xsl:for-each select="dim:field[@element='identifier' and @qualifier='uri']">
                                    <a>
                                        <xsl:attribute name="href">
                                            <xsl:copy-of select="./node()"/>
                                        </xsl:attribute>
                                        <xsl:copy-of select="./node()"/>
                                    </a>
                                    <xsl:if test="count(following-sibling::dim:field[@element='identifier' and @qualifier='uri']) != 0">
                                        <br/>
                                    </xsl:if>
                            </xsl:for-each>
                        </td>
                    </tr>
            </xsl:if>

            <!-- original, unmodified dc.date.created without date display transformation getting applied. -->
			<!-- xsl:if test="dim:field[@element='date' and @qualifier='created']">
                <tr class="ds-table-row odd">
                        <td><span class="bold"><i18n:text>xmlui.dri2xhtml.METS-1.0.item-date</i18n:text>:</span></td>
                        <td>
                            <xsl:for-each select="dim:field[@element='date' and @qualifier='created']">
                                <xsl:copy-of select="."/>
                                <xsl:if test="count(following-sibling::dim:field[@element='date' and @qualifier='created']) != 0">
									<br/>
								</xsl:if>
                            </xsl:for-each>
                        </td>
                </tr>
            </xsl:if> -->
			
			<!-- ***dc.date.created with display transformation*** -->
	<!-- The following modifies the original date transformation code written by Keith G. The following transforms dates
	in the format of YYYY, YYYYMM, YYYYMMDD, YYYY-MM, or YYYY-MM-DD into 1900, January 1900, or January 01, 1900.  This also
	modifies date spans in the format of 1900-01-01-1900-02-01 to display as "January 01, 1900 - February 01, 1900". Any other
	date formats go untouched and display as-is.  Jeff C. April 14, 2010.  -->

	<xsl:if test="dim:field[@element='date' and @qualifier='created']"> <!-- dc.date.created -->
    <tr class="ds-table-row odd">

    <td><span class="bold"><i18n:text>xmlui.dri2xhtml.METS-1.0.item-date</i18n:text>:</span></td>

    <td>
		<xsl:variable name="adate" select="dim:field[@element='date' and @qualifier='created']" />
		<xsl:variable name="firstdatechar" select="substring($adate, 1, 1)" />
		<xsl:variable name="lastdatechar" select="substring($adate, string-length($adate))" />
		<xsl:variable name="newdate" />

		<xsl:choose>
			<xsl:when test="translate($firstdatechar,'0123456789','') = '' and translate($lastdatechar,'0123456789','') = ''">
			<!-- This assumes that when the first and last characters of the date string are both numeric
			(0,1,2,3,4,5,6,7,8, or 9) that this must be a formatted date string of either YYYY, YYYYMM, YYYYMMDD, YYYY-MM or
			YYYY-MM-DD and so we proceed to translate to a user-readable format, such as January 1, 1900. -Jeff. -->

				<xsl:choose>
					<xsl:when test="contains($adate, '-')"><!-- get rid of any dashes in the date string if there are any -->
						<xsl:variable name="newdate" select="translate($adate, '-', '')" />

						<xsl:choose>
							<xsl:when test="string-length($newdate) = 4"><!-- when it's just the year: YYYY -->
								<xsl:value-of select="$newdate" />
							</xsl:when>

							<xsl:when test="string-length($newdate) = 6"><!-- when it's just the year and month: YYYYMM -->
								<xsl:variable name="year" select="substring($newdate,1,4)" />
								<xsl:variable name="month" select="substring($newdate,5,2)" />
								<xsl:choose><!-- print the name of the month -->
									<xsl:when test="$month='01'">January</xsl:when>
									<xsl:when test="$month='02'">February</xsl:when>
									<xsl:when test="$month='03'">March</xsl:when>
									<xsl:when test="$month='04'">April</xsl:when>
									<xsl:when test="$month='05'">May</xsl:when>
									<xsl:when test="$month='06'">June</xsl:when>
									<xsl:when test="$month='07'">July</xsl:when>
									<xsl:when test="$month='08'">August</xsl:when>
									<xsl:when test="$month='09'">September</xsl:when>
									<xsl:when test="$month='10'">October</xsl:when>
									<xsl:when test="$month='11'">November</xsl:when>
									<xsl:when test="$month='12'">December</xsl:when>
								</xsl:choose>
								<xsl:text> </xsl:text><!-- print a single space -->
								<xsl:value-of select="$year" /><!-- print the year -->
							</xsl:when>

							<xsl:when test="string-length($newdate) = 8"><!-- when it's the full date: YYYYMMDD -->
								<xsl:variable name="year2" select="substring($newdate,1,4)" />
								<xsl:variable name="month2" select="substring($newdate,5,2)" />
								<xsl:variable name="day" select="substring($newdate,7,2)" />
								<xsl:choose><!-- print the name of the month -->
									<xsl:when test="$month2='01'">January</xsl:when>
									<xsl:when test="$month2='02'">February</xsl:when>
									<xsl:when test="$month2='03'">March</xsl:when>
									<xsl:when test="$month2='04'">April</xsl:when>
									<xsl:when test="$month2='05'">May</xsl:when>
									<xsl:when test="$month2='06'">June</xsl:when>
									<xsl:when test="$month2='07'">July</xsl:when>
									<xsl:when test="$month2='08'">August</xsl:when>
									<xsl:when test="$month2='09'">September</xsl:when>
									<xsl:when test="$month2='10'">October</xsl:when>
									<xsl:when test="$month2='11'">November</xsl:when>
									<xsl:when test="$month2='12'">December</xsl:when>
								</xsl:choose>
								<xsl:text> </xsl:text><!-- print a single space -->
								<xsl:if test="$day != '00'"><!-- print the day if it is not all zeros -->
									<xsl:value-of select="format-number($day,'##')" />
									<xsl:text>, </xsl:text><!-- follow the day printed with a comma and space -->
								</xsl:if>
								<xsl:value-of select="$year2" /><!-- print the year -->
							</xsl:when>
							
							<xsl:when test="string-length($newdate) = 16"><!-- when given a date span: YYYYMMDDYYYYMMDD -->
								<xsl:variable name="yearfrom" select="substring($newdate,1,4)" />
								<xsl:variable name="yearto" select="substring($newdate,9,4)" />
								<xsl:variable name="monthfrom" select="substring($newdate,5,2)" />
								<xsl:variable name="monthto" select="substring($newdate,13,2)" />
								<xsl:variable name="dayfrom" select="substring($newdate,7,2)" />
								<xsl:variable name="dayto" select="substring($newdate,15,2)" />
								<xsl:choose><!-- print the name of the 'from' month -->
									<xsl:when test="$monthfrom='01'">January</xsl:when>
									<xsl:when test="$monthfrom='02'">February</xsl:when>
									<xsl:when test="$monthfrom='03'">March</xsl:when>
									<xsl:when test="$monthfrom='04'">April</xsl:when>
									<xsl:when test="$monthfrom='05'">May</xsl:when>
									<xsl:when test="$monthfrom='06'">June</xsl:when>
									<xsl:when test="$monthfrom='07'">July</xsl:when>
									<xsl:when test="$monthfrom='08'">August</xsl:when>
									<xsl:when test="$monthfrom='09'">September</xsl:when>
									<xsl:when test="$monthfrom='10'">October</xsl:when>
									<xsl:when test="$monthfrom='11'">November</xsl:when>
									<xsl:when test="$monthfrom='12'">December</xsl:when>
								</xsl:choose>
								<xsl:text> </xsl:text><!-- print a single space -->
								<xsl:if test="$dayfrom != '00'"><!-- print the 'from' day if it is not all zeros -->
									<xsl:value-of select="format-number($dayfrom,'##')" />
									<xsl:text>, </xsl:text><!-- follow the 'from' day printed with a comma and space -->
								</xsl:if>
								<xsl:value-of select="$yearfrom" /><!-- print the 'from' year -->

								<xsl:text> - </xsl:text><!-- print a space, dash, space to separate the 'from' and 'to' dates -->

								<xsl:choose><!-- print the name of the 'to' month -->
									<xsl:when test="$monthto='01'">January</xsl:when>
									<xsl:when test="$monthto='02'">February</xsl:when>
									<xsl:when test="$monthto='03'">March</xsl:when>
									<xsl:when test="$monthto='04'">April</xsl:when>
									<xsl:when test="$monthto='05'">May</xsl:when>
									<xsl:when test="$monthto='06'">June</xsl:when>
									<xsl:when test="$monthto='07'">July</xsl:when>
									<xsl:when test="$monthto='08'">August</xsl:when>
									<xsl:when test="$monthto='09'">September</xsl:when>
									<xsl:when test="$monthto='10'">October</xsl:when>
									<xsl:when test="$monthto='11'">November</xsl:when>
									<xsl:when test="$monthto='12'">December</xsl:when>
								</xsl:choose>
								<xsl:text> </xsl:text><!-- print a single space -->
								<xsl:if test="$dayto != '00'"><!-- print the 'to' day if it is not all zeros -->
									<xsl:value-of select="format-number($dayto,'##')" />
									<xsl:text>, </xsl:text><!-- follow the 'to' day printed with a comma and space -->
								</xsl:if>
								<xsl:value-of select="$yearto" /><!-- print the 'to' year -->
							</xsl:when>

							<!-- Otherwise, this assumes that it must be an unknown date format starting and ending with digits
							[0-9], so pass through unformatted -->
							<xsl:otherwise>
								<xsl:copy-of select="./dim:field[@element='date' and @qualifier='created']/child::node()"/>
							</xsl:otherwise>
						</xsl:choose>

					</xsl:when>

					<xsl:otherwise><!-- otherwise if NO dashes in date string to begin with -->
						<xsl:variable name="newdate" select="$adate" />
						
						<xsl:choose>
							<xsl:when test="string-length($newdate) = 4"><!-- when it's just the year: YYYY -->
								<xsl:value-of select="$newdate" />
							</xsl:when>

							<xsl:when test="string-length($newdate) = 6"><!-- when it's just the year and month: YYYYMM -->
								<xsl:variable name="year" select="substring($newdate,1,4)" />
								<xsl:variable name="month" select="substring($newdate,5,2)" />
								<xsl:choose><!-- print the name of the month -->
									<xsl:when test="$month='01'">January</xsl:when>
									<xsl:when test="$month='02'">February</xsl:when>
									<xsl:when test="$month='03'">March</xsl:when>
									<xsl:when test="$month='04'">April</xsl:when>
									<xsl:when test="$month='05'">May</xsl:when>
									<xsl:when test="$month='06'">June</xsl:when>
									<xsl:when test="$month='07'">July</xsl:when>
									<xsl:when test="$month='08'">August</xsl:when>
									<xsl:when test="$month='09'">September</xsl:when>
									<xsl:when test="$month='10'">October</xsl:when>
									<xsl:when test="$month='11'">November</xsl:when>
									<xsl:when test="$month='12'">December</xsl:when>
								</xsl:choose>
								<xsl:text> </xsl:text><!-- print a single space -->
								<xsl:value-of select="$year" /><!-- print the year -->
							</xsl:when>

							<xsl:when test="string-length($newdate) = 8"><!-- when it's the full date: YYYYMMDD -->
								<xsl:variable name="year2" select="substring($newdate,1,4)" />
								<xsl:variable name="month2" select="substring($newdate,5,2)" />
								<xsl:variable name="day" select="substring($newdate,7,2)" />
								<xsl:choose><!-- print the name of the month -->
									<xsl:when test="$month2='01'">January</xsl:when>
									<xsl:when test="$month2='02'">February</xsl:when>
									<xsl:when test="$month2='03'">March</xsl:when>
									<xsl:when test="$month2='04'">April</xsl:when>
									<xsl:when test="$month2='05'">May</xsl:when>
									<xsl:when test="$month2='06'">June</xsl:when>
									<xsl:when test="$month2='07'">July</xsl:when>
									<xsl:when test="$month2='08'">August</xsl:when>
									<xsl:when test="$month2='09'">September</xsl:when>
									<xsl:when test="$month2='10'">October</xsl:when>
									<xsl:when test="$month2='11'">November</xsl:when>
									<xsl:when test="$month2='12'">December</xsl:when>
								</xsl:choose>
								<xsl:text> </xsl:text><!-- print a single space -->
								<xsl:if test="$day != '00'"><!-- print the day if it is not all zeros -->
									<xsl:value-of select="format-number($day,'##')" />
									<xsl:text>, </xsl:text><!-- follow the day printed with a comma and space -->
								</xsl:if>
								<xsl:value-of select="$year2" /><!-- print the year -->
							</xsl:when>

							<!-- Otherwise, this assumes that it must be an unknown date format starting and ending with digits
							[0-9], so pass through unformatted -->
							<xsl:otherwise>
								<xsl:copy-of select="./dim:field[@element='date' and @qualifier='created']/child::node()"/>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:otherwise>
				</xsl:choose>

			</xsl:when>
				
			<!-- Otherwise, this must be an unknown date format starting and/or ending with non-digits [0-9],
			so pass through unformatted -->
			<xsl:otherwise>
				<xsl:copy-of select="./dim:field[@element='date' and @qualifier='created']/child::node()"/>
			</xsl:otherwise>
				
		</xsl:choose>


		<xsl:if test="count(following-sibling::dim:field[@element='date' and @qualifier='created']) != 0">
			<br/>
        </xsl:if>
    </td>
    </tr>
	</xsl:if> <!-- end dc.date.created -->


            <xsl:if test="dim:field[@element='contributor' and @qualifier='repository']"> <!-- contributor.repository -->
                <tr class="ds-table-row even">
                    <td><span class="bold">Repository:</span></td>
                    <td><xsl:copy-of select="dim:field[@element='contributor' and @qualifier='repository']/child::node()"/></td>
				</tr>
			</xsl:if>

        </table>
    </xsl:template>

     <!-- Build a single row in the bitsreams table of the item view page -->
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
  <xsl:choose>
                    <xsl:when test="$context/mets:fileSec/mets:fileGrp[@USE='THUMBNAIL']/
                        mets:file[@GROUP_ID=current()/@GROUP_ID]">
                        <a class="image-link" rel="lightbox">
                            <xsl:attribute name="href">
                                <xsl:value-of select="mets:FLocat[@LOCTYPE='URL']/@xlink:href"/>
                            </xsl:attribute>
                            <img alt="Thumbnail">
                                <xsl:attribute name="src">
                                    <xsl:value-of select="$context/mets:fileSec/mets:fileGrp[@USE='THUMBNAIL']/
                                        mets:file[@GROUP_ID=current()/@GROUP_ID]/mets:FLocat[@LOCTYPE='URL']/@xlink:href"/>
                                </xsl:attribute>
                            </img>
                        </a>
                    </xsl:when>
                    <xsl:otherwise>
                        <a>
                            <xsl:attribute name="href">
                                <xsl:value-of select="mets:FLocat[@LOCTYPE='URL']/@xlink:href"/>
                            </xsl:attribute>
                            <i18n:text>xmlui.dri2xhtml.METS-1.0.item-files-viewOpen</i18n:text>
                        </a>
                    </xsl:otherwise>
                </xsl:choose>
            </td>
        </tr>
    </xsl:template>

    <!-- modified to make subject fields clickable 
         and URLs in dc.identifier.other clickable,
         and to display html in certain fields
    -->
    <xsl:template match="dim:field" mode="itemDetailView-DIM">
        <tr>
            <xsl:attribute name="class">
                <xsl:text>ds-table-row </xsl:text>
                <xsl:if test="(position() div 2 mod 2 = 0)">even </xsl:if>
                <xsl:if test="(position() div 2 mod 2 = 1)">odd </xsl:if>
            </xsl:attribute>
            <td>
                <xsl:value-of select="./@mdschema"/>
                <xsl:text>.</xsl:text>
                <xsl:value-of select="./@element"/>
                <xsl:if test="./@qualifier">
                    <xsl:text>.</xsl:text>
                    <xsl:value-of select="./@qualifier"/>
                </xsl:if>
            </td>

            <xsl:variable name="link" select="./child::node()" />
            <xsl:choose>
              <xsl:when test="(./@element='subject')">
                <td>
                  <a>
                  <xsl:attribute name="href">
                    <xsl:value-of select="concat($context-path,'/browse?value=')" />
                    <xsl:copy-of select="./child::node()" />&amp;type=subject
                  </xsl:attribute>
                     <xsl:copy-of select="./child::node()" />
                   </a>
                  </td>
              </xsl:when>
              <xsl:when test="(./@element='identifier') and (./@qualifier='other') and (contains($link,'http://'))">
                <td><a>
                  <xsl:attribute name="href">
                      <xsl:copy-of select="./child::node()" />
                  </xsl:attribute>
                       <xsl:copy-of select="./child::node()"/>
                 </a></td>
               </xsl:when>
               <xsl:when test="(./@element='description')">
                  <td><xsl:value-of select="./node()" disable-output-escaping="yes" /></td>
               </xsl:when> 
              <xsl:otherwise>
                <td><xsl:copy-of select="./node()"/></td>
              </xsl:otherwise>
            </xsl:choose>
            <td><xsl:value-of select="./@language"/></td>
        </tr>
    </xsl:template>


 <!-- The first (and most complex) case of the header tag is the one used for divisions. Since divisions can
        nest freely, their headers should reflect that. Thus, the type of HTML h tag produced depends on how
        many divisions the header tag is nested inside of. -->
    <xsl:template match="dri:div/dri:head" priority="3">
        <xsl:variable name="head_count" select="count(ancestor::dri:div)"/>
        <xsl:element name="h{$head_count}">
            <xsl:call-template name="standardAttributes">
                <xsl:with-param name="class">ds-div-head</xsl:with-param>
            </xsl:call-template>
            <xsl:apply-templates />
        </xsl:element>
    </xsl:template>


</xsl:stylesheet>
