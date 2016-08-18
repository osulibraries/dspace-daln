<?xml version="1.0" encoding="UTF-8"?>

<!--
  template.xsl

  Version: $Revision: 1.7 $
 
  Date: $Date: 2006/07/27 22:54:52 $
 
  Copyright (c) 2002-2005, Hewlett-Packard Company and Massachusetts
  Institute of Technology.  All rights reserved.
 
  Redistribution and use in source and binary forms, with or without
  modification, are permitted provided that the following conditions are
  met:
 
  - Redistributions of source code must retain the above copyright
  notice, this list of conditions and the following disclaimer.
 
  - Redistributions in binary form must reproduce the above copyright
  notice, this list of conditions and the following disclaimer in the
  documentation and/or other materials provided with the distribution.
 
  - Neither the name of the Hewlett-Packard Company nor the name of the
  Massachusetts Institute of Technology nor the names of their
  contributors may be used to endorse or promote products derived from
  this software without specific prior written permission.
 
  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
  ``AS IS'' AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
  LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
  A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
  HOLDERS OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT,
  INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING,
  BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS
  OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
  ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR
  TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE
  USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH
  DAMAGE.
-->

<!--
    TODO: Describe this XSL file    
    Author: Alexey Maslov
    
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
    <xsl:output indent="yes"/>




<!-- 1/2009 JRD Overriding main HTML page generation. Including Google Analytics JavaScript just before close of body tag. -->
    <xsl:template match="dri:document">
        <html>
            <!-- First of all, build the HTML head element -->
            <xsl:call-template name="buildHead"/>
            <!-- Then proceed to the body -->
            <body>
                
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
                    <xsl:apply-templates />

                    <!-- 
                        The footer div, dropping whatever extra information is needed on the page. It will
                        most likely be something similar in structure to the currently given example. -->
                    <xsl:call-template name="buildFooter"/>
                    
                </div>
				
				<script type="text/javascript">
var gaJsHost = (("https:" == document.location.protocol) ? "https://ssl." : "http://www.");
document.write(unescape("%3Cscript src='" + gaJsHost + "google-analytics.com/ga.js' type='text/javascript'%3E%3C/script%3E"));
</script>
<script type="text/javascript">
try {
var pageTracker = _gat._getTracker("UA-5946124-8");
pageTracker._trackPageview();
} catch(err) {}</script>

            </body>
        </html>
    </xsl:template>






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
            <!-- Add javascipt  -->
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

			<!-- JRD 10/01/2008 a snippet of Javascript to activate equal column lengths via jquery and the dimensions plugin. One of two. -->
<script type="text/javascript">
jQuery.fn.equalizeCols = function(){
  var height = 0;
  return this.css("height","auto").each(function(){
    height = Math.max( height, jQuery(this).outerHeight() );
  }).css("height", height);

}; 
</script>
<!-- JRD 10/01/2008 a snippet of Javascript to activate equal column lengths via jquery and the dimensions plugin. One of two. -->
<script type="text/javascript">
runOnLoad(function(){
   $("#ds-body, #ds-options").equalizeCols();
 });
</script> 
<!-- JRD 10/06/2008 a snippet of Javascript to activate jQuery version of Lightbox. -->
<script type="text/javascript">
$(function() {
	// Use this example, or...
	$("a[@rel*='lightbox']").lightBox(); 
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

    <!-- The header (distinct from the HTML head element) contains the title, subtitle, login box and various 
        placeholders for header images -->
	<!-- JRD 3/26/2008 Overriding default header, adding BGSU table cells -->
	<!-- JRD 9/1/08 Fixing BGSU Header tables -->
    <xsl:template name="buildHeader">
        <div id="ds-header">
<table width="600" cellspacing="0" cellpadding="0" border="0">
<tbody>
<tr id="bgsu_links">
<td  valign="top"><a href="http://www.bgsu.edu/"><img width="122" vspace="0" hspace="0" height="44" border="0" alt="BGSU" src="http://www.bgsu.edu/images/logo.gif"/></a></td>

<td>
	<table width="750" height="3" cellpadding="0" cellspacing="0" border="0">
	<tbody>
	<tr>
    <td valign="top" height="14" bgcolor="#000000" align="right">
	</td>
	</tr>
    </tbody>
	</table>

    
	<table width="600" cellspacing="0" cellpadding="0" border="0">
    <tbody><tr align="right">
    <td><a href="http://www.bgsu.edu"><img border="0" alt="Home" src="http://www.bgsu.edu/images/bgsu/img22518t.gif"/></a></td><td><a href="http://www.bgsu.edu/academics/"><img border="0" alt="Academics" src="http://www.bgsu.edu/images/bgsu/img22519t.gif"/></a></td><td><a href="http://www.bgsu.edu/offices/admissions"><img border="0" alt="Admissions" src="http://www.bgsu.edu/images/bgsu/img22520t.gif"/></a></td><td><a href="http://www.bgsu.edu/cultural_arts"><img border="0" alt="The Arts" src="http://www.bgsu.edu/images/bgsu/img22521t.gif"/></a></td><td><a href="http://bgsufalcons.ocsn.com/"><img border="0" alt="Athletics" src="http://www.bgsu.edu/images/bgsu/img22522t.gif"/></a></td><td><a href="http://www.bgsu.edu/colleges/library"><img border="0" alt="Libraries" src="http://www.bgsu.edu/images/bgsu/img22523t.gif" /></a></td><td><a href="http://www.bgsu.edu/offices/"><img border="0" alt="Offices" src="http://www.bgsu.edu/images/bgsu/img22524t.gif"/></a></td></tr></tbody></table>

</td>
</tr>



<tr><td colspan="2">



<!-- JRD 3/26/2008 Removing Manakin Header logo
			   <a>
                <xsl:attribute name="href">
                    <xsl:text>http://drcdev.ohiolink.edu/</xsl:text>
                </xsl:attribute>
                <span id="ds-header-logo">&#160;</span>
            </a>
			-->
            <h1><xsl:copy-of select="/dri:document/dri:meta/dri:pageMeta/dri:metadata[@element='title']/node()"/></h1>
            <h2><i18n:text>xmlui.dri2xhtml.structural.head-subtitle</i18n:text></h2>
            <ul id="ds-trail">
                <xsl:apply-templates select="/dri:document/dri:meta/dri:pageMeta/dri:trail"/>
            </ul>
                     <!-- JRD 9/2008 Commenting out the Login User Box
           <xsl:choose>
                <xsl:when test="/dri:document/dri:meta/dri:userMeta/@authenticated = 'yes'">
					<div id="ds-user-box">
                        <p>
                            <a>
                                <xsl:attribute name="href">
                                    <xsl:value-of select="/dri:document/dri:meta/dri:userMeta/
                                        dri:metadata[@element='identifier' and @qualifier='url']"/>
                                </xsl:attribute>
                                <i18n:text>xmlui.dri2xhtml.structural.profile</i18n:text>
                                <xsl:value-of select="/dri:document/dri:meta/dri:userMeta/
                                    dri:metadata[@element='identifier' and @qualifier='firstName']"/>
                                <xsl:text> </xsl:text>
                                <xsl:value-of select="/dri:document/dri:meta/dri:userMeta/
                                    dri:metadata[@element='identifier' and @qualifier='lastName']"/>
                            </a>
                            <xsl:text> | </xsl:text>
                            <a>
                                <xsl:attribute name="href">
                                    <xsl:value-of select="/dri:document/dri:meta/dri:userMeta/
                                        dri:metadata[@element='identifier' and @qualifier='logoutURL']"/>
                                </xsl:attribute>
                                <i18n:text>xmlui.dri2xhtml.structural.logout</i18n:text>
                            </a>
                        </p>
                    </div>
                </xsl:when>
                <xsl:otherwise>
                    <div id="ds-user-box">
                        <p>
                            <a>
                                <xsl:attribute name="href">
                                    <xsl:value-of select="/dri:document/dri:meta/dri:userMeta/
                                        dri:metadata[@element='identifier' and @qualifier='loginURL']"/>
                                </xsl:attribute>
                                <i18n:text>xmlui.dri2xhtml.structural.login</i18n:text>
                            </a>
                        </p>
                    </div>
                </xsl:otherwise>
            </xsl:choose>
			 -->
</td></tr>
</tbody>
</table>
            
        </div>
    </xsl:template>


    <!-- JRD 2-09 Overriding Options Generation to include a link back to OhioLINK DRC -->
    <xsl:template match="dri:options">
        <div id="ds-options">
            <h3 id="ds-search-option-head" class="ds-option-set-head"><i18n:text>xmlui.dri2xhtml.structural.search</i18n:text></h3>
            <div id="ds-search-option" class="ds-option-set">
                <!-- The form, complete with a text box and a button, all built from attributes referenced
                    from under pageMeta. -->
                <form id="ds-search-form" method="post">
                    <xsl:attribute name="action">
                        <xsl:value-of select="/dri:document/dri:meta/dri:pageMeta/dri:metadata[@element='search'][@qualifier='simpleURL']"/>
                    </xsl:attribute>
                    <fieldset>
                        <input class="ds-text-field " type="text">
                            <xsl:attribute name="name">
                                <xsl:value-of select="/dri:document/dri:meta/dri:pageMeta/dri:metadata[@element='search'][@qualifier='queryField']"/>
                            </xsl:attribute>                        
                        </input>
                        <input class="ds-button-field " name="submit" type="submit" i18n:attr="value" value="xmlui.general.go" >
                            <xsl:attribute name="onclick">
                                <xsl:text>
                                    var radio = document.getElementById(&quot;ds-search-form-scope-container&quot;);
                                    if (radio != undefined &amp;&amp; radio.checked)
                                    {
                                    var form = document.getElementById(&quot;ds-search-form&quot;);
                                    form.action=
                                </xsl:text>
                                <xsl:text>&quot;</xsl:text>
                                <xsl:value-of select="/dri:document/dri:meta/dri:pageMeta/dri:metadata[@element='contextPath']"/>
                                <xsl:text>/handle/&quot; + radio.value + &quot;/search&quot; ; </xsl:text>
                                <xsl:text>
                                    } 
                                </xsl:text>
                            </xsl:attribute>
                        </input>
                        <xsl:if test="/dri:document/dri:meta/dri:pageMeta/dri:metadata[@element='focus'][@qualifier='container']">
                            <label>
                                <input id="ds-search-form-scope-all" type="radio" name="scope" value="" checked="checked"/>
                                <i18n:text>xmlui.dri2xhtml.structural.search</i18n:text>
                            </label>
                            <br/>
                            <label>
                                <input id="ds-search-form-scope-container" type="radio" name="scope">
                                    <xsl:attribute name="value">
                                        <xsl:value-of select="substring-after(/dri:document/dri:meta/dri:pageMeta/dri:metadata[@element='focus'][@qualifier='container'],':')"/>
                                    </xsl:attribute>       
                                </input> 
                                <xsl:choose>
									<xsl:when test="/dri:document/dri:body//dri:div/dri:referenceSet[@type='detailView' and @n='community-view']">
										<i18n:text>xmlui.dri2xhtml.structural.search-in-community</i18n:text>
									</xsl:when>   
									<xsl:otherwise>
										<i18n:text>xmlui.dri2xhtml.structural.search-in-collection</i18n:text>
									</xsl:otherwise>
									                      
                                </xsl:choose>
                            </label>
                        </xsl:if>
                    </fieldset>
                </form>
                <!-- The "Advanced search" link, to be perched underneath the search box -->
                <a>
                    <xsl:attribute name="href">
                        <xsl:value-of select="/dri:document/dri:meta/dri:pageMeta/dri:metadata[@element='search'][@qualifier='advancedURL']"/>
                    </xsl:attribute>
                    <i18n:text>xmlui.dri2xhtml.structural.search-advanced</i18n:text>
                </a>
            </div>            
            
            <!-- Once the search box is built, the other parts of the options are added -->
            <xsl:apply-templates />
    <!-- JRD 2-09 Link back to OhioLINK DRC -->
<h3><a href="http://drc.ohiolink.edu/" class="ds-option-set">Ohio Digital Resource Commons</a></h3>
<br /><br />
        </div>
    </xsl:template>
	
	
	
	
	

<!-- Generate the info about the item from the metadata section -->
<!-- Lynna, June 30, 2008: copied this from ../dri2xhthml/DIM-Handler.xsl because of custom metadata display -->
<!-- Keith, September 26 2008:  Additional edits as requested by BGSU -->
    <xsl:template match="dim:dim" mode="itemSummaryView-DIM">
        <table class="ds-includeSet-table">
            <!--
            <tr class="ds-table-row odd">
                <td><span class="bold"><i18n:text>xmlui.dri2xhtml.METS-1.0.item-preview</i18n:text>:</span></td>
                <td>
                    <xsl:choose>
                        <xsl:when test="mets:fileSec/mets:fileGrp[@USE='THUMBNAIL']">
                            <a class="image-link">
                                <xsl:attribute name="href"><xsl:value-of select="@OBJID"/></xsl:attribute>
                                <img alt="Thumbnail">
                                    <xsl:attribute name="src">
                                        <xsl:value-of select="mets:fileSec/mets:fileGrp[@USE='THUMBNAIL']/
                                            mets:file/mets:FLocat[@LOCTYPE='URL']/@xlink:href"/>
                                    </xsl:attribute>
                                </img>
                            </a>
                        </xsl:when>
                        <xsl:otherwise>
                            <i18n:text>xmlui.dri2xhtml.METS-1.0.no-preview</i18n:text>
                        </xsl:otherwise>
                    </xsl:choose>
                </td>
            </tr>-->
            <tr class="ds-table-row even">
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
             <tr class="ds-table-row odd">
                <td><span class="bold"><xsl:text>Alternative Title</xsl:text>: </span></td>
                <td>
                    <xsl:choose>
                        <xsl:when test="count(dim:field[@element='title'][@qualifier='alternative']) &gt; 1">
                            <xsl:for-each select="dim:field[@element='title'][@qualifier='alternative']">
                            	<xsl:value-of select="./node()"/>
                            	<xsl:if test="count(following-sibling::dim:field[@element='title'][@qualifer='alternative']) != 0">
	                                    <xsl:text>; </xsl:text><br/>
	                                </xsl:if>
                            </xsl:for-each>
                        </xsl:when>
                         <xsl:when test="count(dim:field[@element='title'][@qualifier='alternative']) = 1">
                            <xsl:value-of select="dim:field[@element='title'][@qualifier='alternative'][1]/node()"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:text>No Alternative Title</xsl:text>
                        </xsl:otherwise>
                    </xsl:choose>
                </td>
            </tr> 
            
            <xsl:if test="dim:field[@element='contributor'][@qualifier='author'] or dim:field[@element='creator'] or dim:field[@element='contributor']">
	            <tr class="ds-table-row even">
	                <td><span class="bold"><i18n:text>xmlui.dri2xhtml.METS-1.0.item-author</i18n:text>:</span></td>
	                <td>
	                    <xsl:choose>
	                        <xsl:when test="dim:field[@element='contributor'][@qualifier='author']">
	                            <xsl:for-each select="dim:field[@element='contributor'][@qualifier='author']">
	                                <xsl:copy-of select="node()"/>
	                                <xsl:if test="count(following-sibling::dim:field[@element='contributor'][@qualifier='author']) != 0">
	                                    <xsl:text>; </xsl:text>
	                                </xsl:if>
	                            </xsl:for-each>
	                        </xsl:when>
	                        <xsl:when test="dim:field[@element='creator']">
	                            <xsl:for-each select="dim:field[@element='creator']">
	                                <xsl:copy-of select="node()"/>
	                                <xsl:if test="count(following-sibling::dim:field[@element='creator']) != 0">
	                                    <xsl:text>; </xsl:text>
	                                </xsl:if>
	                            </xsl:for-each>
	                        </xsl:when>
	                        <xsl:when test="dim:field[@element='contributor']">
	                            <xsl:for-each select="dim:field[@element='contributor']">
	                                <xsl:copy-of select="node()"/>
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
	      <tr class="ds-table-row odd">
                <td><span class="bold"><xsl:text>Series Title</xsl:text>: </span></td>
                <td>
                    <xsl:choose>
                        <xsl:when test="count(dim:field[@element='relation'][@qualifier='ispartofseries']) &gt; 1">
                            <xsl:for-each select="dim:field[@element='relation'][@qualifier='ispartofseries']">
                            	<xsl:value-of select="./node()"/>
                            	<xsl:if test="count(following-sibling::dim:field[@element='relation'][@qualifer='ispartofseries']) != 0">
	                                    <xsl:text>; </xsl:text><br/>
	                                </xsl:if>
                            </xsl:for-each>
                        </xsl:when>
                         <xsl:when test="count(dim:field[@element='relation'][@qualifier='ispartofseries']) = 1">
                            <xsl:value-of select="dim:field[@element='relation'][@qualifier='ispartofseries'][1]/node()"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:text>No Series</xsl:text>
                        </xsl:otherwise>
                    </xsl:choose>
                </td>
            </tr> 
              <tr class="ds-table-row even">
                <td><span class="bold">Date:</span></td>
                <td>
                   <xsl:for-each select="dim:field[@element='date' and @qualifier='created']/child::node()">
                   <xsl:copy-of select="."/><br/>
                   </xsl:for-each>
                </td>
              </tr>
              <tr class="ds-table-row odd">
                <td><span class="bold">Vol/Issue or Other Identifier:</span></td>
                <td>
                   <xsl:for-each select="dim:field[@element='identifier' and @qualifier='other']/child::node()">
                   <xsl:copy-of select="."/><br/>
                   </xsl:for-each>
                </td>
              </tr>
<tr class="ds-table-row even">
                <td><span class="bold">Publisher:</span></td>
                <td>
                   <xsl:for-each select="dim:field[@element='publisher']/child::node()">
                   <xsl:copy-of select="."/><br/>
                   </xsl:for-each>
                </td>
              </tr>
            <xsl:if test="dim:field[@element='description' and @qualifier='abstract']">
	            <tr class="ds-table-row odd">
	                <td><span class="bold"><xsl:text>Summary</xsl:text>:</span></td>
	                <td>
	                <xsl:if test="count(dim:field[@element='description' and @qualifier='abstract']) &gt; 1">
	                	<hr class="metadata-seperator"/>
	                </xsl:if>
	                <xsl:for-each select="dim:field[@element='description' and @qualifier='abstract']">
		                <xsl:copy-of select="./node()"/>
		                <xsl:if test="count(following-sibling::dim:field[@element='description' and @qualifier='abstract']) != 0">
	                    	<hr class="metadata-seperator"/>
	                    </xsl:if>
	              	</xsl:for-each>
	              	<xsl:if test="count(dim:field[@element='description' and @qualifier='abstract']) &gt; 1">
	                	<hr class="metadata-seperator"/>
	                </xsl:if>
	                </td>
	            </tr>
            </xsl:if>
            <xsl:if test="dim:field[@element='description' and not(@qualifier)]">
	            <tr class="ds-table-row even">
	                <td><span class="bold"><i18n:text>xmlui.dri2xhtml.METS-1.0.item-description</i18n:text>:</span></td>
	                <td>
	                <xsl:if test="count(dim:field[@element='description' and not(@qualifier)]) &gt; 1 and not(count(dim:field[@element='description' and @qualifier='abstract']) &gt; 1)">
	                	<hr class="metadata-seperator"/>
	                </xsl:if>
	                <xsl:for-each select="dim:field[@element='description' and not(@qualifier)]">
		                <xsl:value-of select="./node()" disable-output-escaping="yes" /><!-- Allow HTML formatting in this field -->
		                <xsl:if test="count(following-sibling::dim:field[@element='description' and not(@qualifier)]) != 0">
	                    	<hr class="metadata-seperator"/>
	                    </xsl:if>
	               	</xsl:for-each>
	               	<xsl:if test="count(dim:field[@element='description' and not(@qualifier)]) &gt; 1">
	                	<hr class="metadata-seperator"/>
	                </xsl:if>
	                </td>
	            </tr>
            </xsl:if>
            <tr class="ds-table-row odd">
                <td><span class="bold"><xsl:text>Subject</xsl:text>: </span></td>
                <td>
                    <xsl:choose>
                        <xsl:when test="count(dim:field[@element='subject'][@qualifier='lcsh']) &gt; 1">
                            <xsl:for-each select="dim:field[@element='subject'][@qualifier='lcsh']">
                            	<xsl:value-of select="./node()"/>
                            	<xsl:if test="count(following-sibling::dim:field[@element='subject'][@qualifier='lcsh']) != 0">
	                                 <xsl:text>; </xsl:text><br/>
	                                </xsl:if>
                            </xsl:for-each>
                        </xsl:when>
                         <xsl:when test="count(dim:field[@element='subject'][@qualifier='lcsh']) = 0">
                            <xsl:value-of select="dim:field[@element='subject'][@qualifier='lcsh'][1]/node()"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:text>No Assigned Subjects</xsl:text>
                        </xsl:otherwise>
                    </xsl:choose>
                </td>
            </tr> 
              <xsl:if test="dim:field[@element='coverage' and @qualifier='spatial']">
              <tr class="ds-table-row even">
                <td><span class="bold">Coverage Spatial:</span></td>
                <td>
                   <xsl:for-each select="dim:field[@element='coverage' and @qualifier='spatial']/child::node()">
                   <xsl:copy-of select="."/><br/>
                   </xsl:for-each>
                </td>
              </tr>
           </xsl:if>  
           <xsl:if test="dim:field[@element='coverage' and @qualifier='temporal']">
              <tr class="ds-table-row odd">
                <td><span class="bold">Coverage Temporal:</span></td>
                <td>
                   <xsl:for-each select="dim:field[@element='coverage' and @qualifier='temporal']/child::node()">
                   <xsl:copy-of select="."/><br/>
                   </xsl:for-each>
                </td>
              </tr>
           </xsl:if>
           <tr class="ds-table-row even">
                <td><span class="bold"><xsl:text>Type</xsl:text>: </span></td>
                <td>
                    <xsl:choose>
                        <xsl:when test="count(dim:field[@element='type']) &gt; 1">
                            <xsl:for-each select="dim:field[@element='type']">
                            	<xsl:value-of select="./node()"/>
                            	<xsl:if test="count(following-sibling::dim:field[@element='type']) != 0">
	                                 <xsl:text>; </xsl:text><br/>
	                                </xsl:if>
                            </xsl:for-each>
                        </xsl:when>
                         <xsl:when test="count(dim:field[@element='type']) = 0">
                            <xsl:value-of select="dim:field[@element='type'][1]/node()"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:text>Unknown Type</xsl:text>
                        </xsl:otherwise>
                    </xsl:choose>
                </td>
            </tr> 
            <tr class="ds-table-row odd">
                <td><span class="bold"><xsl:text>Language</xsl:text>: </span></td>
                <td>
                    <xsl:choose>
                        <xsl:when test="count(dim:field[@element='language'][@qualifier='iso']) &gt; 1">
                            <xsl:for-each select="dim:field[@element='language'][@qualifier='iso']">
                            	<xsl:value-of select="./node()"/>
                            	<xsl:if test="count(following-sibling::dim:field[@element='language'][@qualifier='iso']) != 0">
	                                 <xsl:text>; </xsl:text><br/>
	                                </xsl:if>
                            </xsl:for-each>
                        </xsl:when>
                         <xsl:when test="count(dim:field[@element='language'][@qualifier='iso']) = 0">
                            <xsl:value-of select="dim:field[@element='language'][@qualifier='iso'][1]/node()"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:text>Language Not Specified</xsl:text>
                        </xsl:otherwise>
                    </xsl:choose>
                </td>
            </tr> 

            <xsl:if test="dim:field[@element='identifier' and @qualifier='uri']">
	            <tr class="ds-table-row even">
	                <td><span class="bold"><xsl:text>Persistent URI</xsl:text>:</span></td>
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
            
          	<!-- JRD 7/2008 Edits for BGSU Nickel Weeklies
	
          
          <xsl:if test="dim:field[@element='relation' and not(@qualifier)]">
              <tr class="ds-table-row">
                <td><span class="bold">Place of publication:</span></td>
                <td>
                   <xsl:for-each select="dim:field[@element='relation' and not(@qualifier)]/child::node()">
                   <xsl:copy-of select="."/><br/>
                   </xsl:for-each>
                </td>
              </tr>
           </xsl:if>
            <xsl:if test="dim:field[@element='type' and not(@qualifier)]">
              <tr class="ds-table-row">
                <td><span class="bold">Type:</span></td>
                <td>
                   <xsl:for-each select="dim:field[@element='type' and not(@qualifier)]/child::node()">
                   <xsl:copy-of select="."/><br/>
                   </xsl:for-each>
                </td>
              </tr>
           </xsl:if>
           <xsl:if test="dim:field[@element='publisher' and @qualifier='digital']">
              <tr class="ds-table-row">
                <td><span class="bold">Digital Publisher:</span></td>
                <td>
                   <xsl:for-each select="dim:field[@element='publisher' and @qualifier='digital']/child::node()">
                   <xsl:copy-of select="."/><br/>
                   </xsl:for-each>
                </td>
              </tr>
           </xsl:if>
           <xsl:if test="dim:field[@element='repository' and @qualifier='name']">
              <tr class="ds-table-row">
                <td><span class="bold">Repository Name:</span></td>
                <td>
                   <xsl:for-each select="dim:field[@element='repository' and @qualifier='name']/child::node()">
                   <xsl:copy-of select="."/><br/>
                   </xsl:for-each>
                </td>
              </tr>
           </xsl:if>
           <xsl:if test="dim:field[@element='contributor' and @qualifier='institution']">
              <tr class="ds-table-row">
                <td><span class="bold">Contributing Institution:</span></td>
                <td>
                   <xsl:for-each select="dim:field[@element='contributor' and @qualifier='institution']/child::node()">
                   <xsl:copy-of select="."/><br/>
                   </xsl:for-each>
                </td>
              </tr>
           </xsl:if>
            -->
            <!-- Lynna, June 30, 2008: field removed upon Wendy Watkins's request
              <xsl:if test="dim:field[@element='date' and @qualifier='issued']">
	            <tr class="ds-table-row odd">
	                <td><span class="bold"><i18n:text>xmlui.dri2xhtml.METS-1.0.item-date</i18n:text>:</span></td>
	                <td>
		                <xsl:for-each select="dim:field[@element='date' and @qualifier='issued']">
		                	<xsl:copy-of select="substring(./node(),1,10)"/>
		                	 <xsl:if test="count(following-sibling::dim:field[@element='date' and @qualifier='issued']) != 0">
	                    	<br/>
	                    </xsl:if>
		                </xsl:for-each>
	                </td>
	            </tr> 
            </xsl:if> -->
        </table>
    </xsl:template>
    
    
    <!-- An example of an existing template copied from structural.xsl and overridden -->  
    <xsl:template name="buildFooter">
        <div id="ds-footer">
               <table xmlns:fo="http://www.w3.org/1999/XSL/Format" border="0" cellpadding="0" cellspacing="0" height="22" width="100%">
                  <tbody><tr align="left" valign="top">
                     <td align="center" height="22" width="10"><img alt="Spacer" src="/themes/BGSU/lib/images/spacer.gif" border="0" height="22" hspace="0" vspace="0" width="10" /></td>
                     <td class="footer" align="right" height="22">
                        <div align="center"><font color="#a49b8e"><font color="#a49b8e">University&#160;Libraries&#160;&#160;|&#160;&#160;<a href="http://www.bgsu.edu/colleges/library/page45203.html">Contact&#160;Us&#160;at&#160;the&#160;University&#160;Libraries</a>&#160;&#160;|&#160;&#160;<a href="http://www.bgsu.edu/colleges/library/page41793.html">Libraries&#160;Site&#160;Map</a></font></font></div>
                     </td>
                  </tr>
               </tbody></table>
			   
			   
			   
               <table xmlns:fo="http://www.w3.org/1999/XSL/Format" border="0" cellpadding="0" cellspacing="0" height="22" width="100%">
                  <tbody><tr align="left" valign="top">
                     <td align="center" height="22" width="10"><img alt="Spacer" src="/themes/BGSU/lib/images/spacer.gif" border="0" height="22" hspace="0" vspace="0" width="10" /></td>
                     <td class="footer" align="right" height="22">
                        <div align="center"><font color="#a49b8e"><font color="#a49b8e">Bowling&#160;Green&#160;State&#160;University&#160;&#160;| &#160;Bowling&#160;Green,&#160;OH&#160;43403-0001&#160;&#160;| &#160;<a href="http://www.bgsu.edu/scripts/contact.html">Contact&#160;Us</a>&#160;&#160;|&#160;&#160;<a href="http://www.bgsu.edu/map/">Campus Map</a>&#160;&#160;| &#160;<a href="http://www.bgsu.edu/sitemap.html">Site&#160;Map</a>&#160;&#160;|&#160;&#160;<a href="http://www.oit.ohio.gov/IGD/policy/pdfs_policy/ITP-F.3.pdf">Accessibility Policy</a> (<a href="http://www.adobe.com/products/acrobat/">PDF Reader</a>)
                                 								</font></font></div>
                     </td>
                  </tr>
               </tbody></table>
			   </div>
    </xsl:template>

<!-- Build a single row in the bitsreams table of the item view page 
Overriding to restore lightbox functionality.
09/30/2008 KRG
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
                <xsl:choose>
                    <xsl:when test="$context/mets:fileSec/mets:fileGrp[@USE='THUMBNAIL']/
                        mets:file[@GROUP_ID=current()/@GROUP_ID]">
                        <a class="image-link" rel="lightbox" title="{mets:FLocat[@LOCTYPE='URL']/@xlink:title}">
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

	
	
	
	<!-- 1/2009 JRD Overriding default Thumbnail HREF generation to use lightbox instead. -->
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
	
</xsl:stylesheet>
