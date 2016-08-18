<?xml version="1.0" encoding="UTF-8"?>

<!--
  structural.xsl

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
	xmlns:js="javascript:code"
	xmlns="http://www.w3.org/1999/xhtml"
	exclude-result-prefixes="mets xlink xsl dim xhtml mods dc">
   
        <xsl:import href="../dri2xhtml.xsl"/> 
        <xsl:output indent="yes"/>



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
<xsl:call-template name="test_bkgrnd" />                                  
-->                <!--
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


	<script type="text/javaScript">
        if (getURL())
        {

                var bb = document.getElementById("ds-body");
                bb.style.backgroundImage='url(' + "http://digitalspace.xavier.edu/themes/xavier/images/background.jpg" + ')';
                bb.style.backgroundRepeat =  "no-repeat";
        	var artifact_li = [];
        	artifact_li = getElementsByClass(document,'ds-artifact-item','*');
        	for (i=0; i != artifact_li.length; i++)
        	{
                 	artifact_li[i].style.backgroundColor="transparent";
        	}
       	}
       	else
       	{
               	document.bgColor = "white";
       	}

	</script>
 </div>

<!-- script for google analytics -->
        <script type="text/javascript">var gaJsHost = (("https:" == document.location.protocol) ? "https://ssl." : "http://www."); document.write(unescape("%3Cscript src='" + gaJsHost + "google-analytics.com/ga.js' type='text/javascript'%3E%3C/script%3E"));</script>
        <script type="text/javascript">try { var pageTracker = _gat._getTracker("UA-5946124-17"); pageTracker._trackPageview(); } catch(err) {}</script>
            </body>
        </html>
</xsl:template>


    
<!-- DP: removed search area on home page--> 
<xsl:template match="dri:div[@n='front-page-search']" priority="4">
</xsl:template>

<!-- The HTML head element contains references to CSS as well as embedded JavaScript code. Most of this
        information is either user-provided bits of post-processing (as in the case of the JavaScript), or
        references to stylesheets pulled directly from the pageMeta element. -->
    <xsl:template name="buildHead">
        <head>
            <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
           <!--  Add stylsheets 
	     custom_css -->

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

                       
<!--
The following javascript returns all html elements that have a specific class name. This function is used to remove the light blue shades of background color of the Community list on the Home page only.  
--> 

	<script type="text/javascript">
		function getElementsByClass(node,searchClass,tag)
		{
			var classElements = new Array();
			var els = node.getElementsByTagName(tag);
			var pattern = new RegExp("\\b" + searchClass + "\\b");
			var j = 0;
			for (i = 0;  i != els.length; i++)
        		{
        			if ( pattern.test(els[i].className) )
                		{
         	       			classElements[j] = els[i];
                       			j++;
                		}
        		}
        		return classElements;
		}

<!--
This javascript checks the URL of teh current page. This function is used to apply a background image on the Home page and other static pages(About, Contacts, etc.) only and apply a white background to the other pages. 
-->
		function getURL()
		{

			if (document.URL=="http://digitalspace.xavier.edu/")
        		{
        			return true;
        		}
        		else
        		{
                		return false;
        		}
		}

            <!-- The following javascript removes the default text of empty text areas when they are focused on or submitted -->
            <!-- There is also javascript to disable submitting a form when the 'enter' key is pressed. -->
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

<!--
The following javascript helps in keeping the height of two columns equal. This is used in the next script to dynamically make the ds-options and ds-body columns of equal height. 
-->

<script type="text/javascript" >
jQuery.fn.equalizeCols = function(){
  var height = 0;
  return this.css("height","auto").each(function(){
    height = Math.max( height, jQuery(this).outerHeight() );
  }).css("height", height);

};
</script>

<script type="text/javascript">
runOnLoad(function(){
   $("#ds-body, #ds-options").equalizeCols();
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

	
    <xsl:template name="buildHeader">
     <div id="ds-header">
		<h1 class="pagetitle">
            	<xsl:choose>
            		<!-- protectiotion against an empty page title -->
            		<xsl:when test="not(/dri:document/dri:meta/dri:pageMeta/dri:metadata[@element='title'])">
            			<xsl:text> </xsl:text>
            		</xsl:when>
            		<xsl:otherwise>
            			<xsl:copy-of select="/dri:document/dri:meta/dri:pageMeta/dri:metadata[@element='title']/node()"/>
            		</xsl:otherwise>
            	</xsl:choose>
            		
         </h1>

        <h2 class="static-pagetitle"><i18n:text>xmlui.dri2xhtml.structural.head-subtitle</i18n:text></h2>
		
		<div id = "header">  
	
			<a>
                <xsl:attribute name="href">
                    <xsl:value-of select="/dri:document/dri:meta/dri:pageMeta/dri:metadata[@element='contextPath'][not(@qualifier)]"/>/
                </xsl:attribute>
                <span id="ds-header-logo">&#160;</span>
            </a>	
		
		  <div id="xavierhome">
				<a href="http://www.xavier.edu" title="Xavier Home"><h1>Xavier Home</h1></a>
				
		  </div>
			
			
		</div>
	
		<div id="ds-navigation">
			<ul id="menu-items">
				<li> <a href="/">HOME</a></li>
				<li> <a href="themes/xavier/files/about.html">ABOUT</a></li>
				<li> <a href="/themes/xavier/files/contributing.html">HOW TO CONTRIBUTE</a></li>
				<li> <a href="themes/xavier/files/rights.html">RIGHTS &amp; RESPONSIBILITIES</a></li>
				<li> <a href="/themes/xavier/files/faqs.html">FAQs</a></li>
				<li> <a href="/themes/xavier/files/contacts.html">CONTACTS</a></li>
				<li> <a href="http://www.xavier.edu/library">UNIVERSITY LIBRARY</a></li>
			</ul>
		</div>
	
			
		<ul id="ds-trail">
            	<xsl:choose>
	            	<xsl:when test="count(/dri:document/dri:meta/dri:pageMeta/dri:trail) = 0">
	                	<li class="ds-trail-link first-link"> - </li>
	                </xsl:when>
	                <xsl:otherwise>
	                	<xsl:apply-templates select="/dri:document/dri:meta/dri:pageMeta/dri:trail"/>
	                </xsl:otherwise>
                </xsl:choose>
        	</ul>
		
		
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
            </xsl:choose>

   </div> 
</xsl:template> 
	
    <!-- Like the header, the footer contains various miscellanious text, links, and image placeholders -->
    <xsl:template name="buildFooter">
        <div id="ds-footer">
			
			
		<div id="footer-separator">foo</div>
				
		<p>
	        <a href="http://www.xavier.edu">Xavier University</a> : 
		<a href="http://www.xavier.edu/library">University Library</a> :
		<a href="http://www.xavier.edu/cm/">Office of Content 
Management</a> : 3800 Victory Parkway, Cincinnati, OH 45207
		</p>
        </div>
    </xsl:template>
    
</xsl:stylesheet>
