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
    
    <xsl:import href="../dri2xhtml.xsl"/>
    <xsl:output indent="yes"/>
    
    
    
<!-- 1/2009 JRD Overriding main HTML page generation. Including Google Analytics JavaScript just before close of body tag. -->
    <xsl:template match="dri:document">
        <html>
            <!-- First of all, build the HTML head element -->
            <xsl:call-template name="buildHead"/>
            <!-- Then proceed to the body -->
            <xsl:choose>
              <xsl:when test="/dri:document/dri:meta/dri:pageMeta/dri:metadata[@element='framing'][@qualifier='popup']">
                <xsl:apply-templates select="dri:body/*"/>
                <!-- add setup JS code if this is a choices lookup page -->
                <xsl:if test="dri:body/dri:div[@n='lookup']">
                  <xsl:call-template name="choiceLookupPopUpSetup"/>
                </xsl:if>
              </xsl:when>
              <xsl:otherwise>
            <body>
                
                <div id="ds-main">
                    <!-- 
                        The header div, complete with title, subtitle, trail and other junk. The trail is 
                        built by applying a template over pageMeta's trail children. -->
                    <xsl:call-template name="buildHeader"/>
                    
                    <xsl:for-each select="/dri:document/dri:options">
	                    <xsl:call-template name="menu"/>
    				</xsl:for-each>
                    
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
            </body>
              </xsl:otherwise>
            </xsl:choose>
        </html>
    </xsl:template>




    <!-- An example of an existing template copied from structural.xsl and overridden -->  
    <xsl:template name="buildFooter">
        <div id="ds-footer">
            <!-- Lynna Cekova: no footer for now This footer has had its text and links changed. This change should override the existing template.
            <div id="ds-footer-links">
                <a>
                    <xsl:attribute name="href">
                        <xsl:value-of select="/dri:document/dri:meta/dri:pageMeta/dri:metadata[@element='contextPath'][not(@qualifier)]"/>
                        <xsl:text>/contact</xsl:text>
                    </xsl:attribute>
                    <i18n:text>xmlui.dri2xhtml.structural.contact-link</i18n:text>
                </a>
                <xsl:text> | </xsl:text>
                <a>
                    <xsl:attribute name="href">
                        <xsl:value-of select="/dri:document/dri:meta/dri:pageMeta/dri:metadata[@element='contextPath'][not(@qualifier)]"/>
                        <xsl:text>/feedback</xsl:text>
                    </xsl:attribute>
                    <i18n:text>xmlui.dri2xhtml.structural.feedback-link</i18n:text>
                </a>
            </div> -->
            <a>
                <xsl:attribute name="href">
                    <xsl:value-of select="/dri:document/dri:meta/dri:pageMeta/dri:metadata[@element='contextPath'][not(@qualifier)]"/>
                    <xsl:text>/htmlmap</xsl:text>
                </xsl:attribute>
            </a>
        </div>
    </xsl:template>


   <!-- the below template has been modified to use the DRC Unicorn Search KRG 2008 -->   
    <!--
        The template to handle dri:options. Since it contains only dri:list tags (which carry the actual
        information), the only things than need to be done is creating the ds-options div and applying
        the templates inside it.

        In fact, the only bit of real work this template does is add the search box, which has to be
        handled specially in that it is not actually included in the options div, and is instead built
        from metadata available under pageMeta.
    -->
    <!-- TODO: figure out why i18n tags break the go button -->
    <xsl:template name="menu-item">
    	<xsl:choose>
    	<xsl:when test="count(*) > 0">
	    	<li>
		    	<a class="drop" href="#"><xsl:copy-of select="dri:head"/></a>
		    	<ul>
					<xsl:for-each select="dri:list | dri:item">
						<xsl:choose>
							<xsl:when test="self::dri:list">
								<xsl:call-template name="menu-item" />
							</xsl:when>
							<xsl:when test="self::dri:item">
								<li>
									<xsl:apply-templates select="./dri:xref" />
								</li>
							</xsl:when>
							<xsl:otherwise>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:for-each>
    			</ul>
	    	</li>
    	</xsl:when>
    	<xsl:otherwise></xsl:otherwise>
    	</xsl:choose>
    </xsl:template>

	<xsl:template name="menu">
    	<div id="ds-menu" class="rounded">
    		<ul class="toplevel">
    			<li>
    				<a class="drop" href="#"><i18n:text>xmlui.dri2xhtml.structural.search</i18n:text></a>
    				<ul>
    					<li>
			                <a>
    			                <xsl:attribute name="href">
        			                <xsl:value-of select="/dri:document/dri:meta/dri:pageMeta/dri:metadata[@element='search'][@qualifier='simpleURL']"/>
            	    		    </xsl:attribute>
                    			<i18n:text>xmlui.dri2xhtml.structural.search-simple</i18n:text>
                			</a>
                		</li>
    					<li>
			                <a>
    			                <xsl:attribute name="href">
        			                <xsl:value-of select="/dri:document/dri:meta/dri:pageMeta/dri:metadata[@element='search'][@qualifier='advancedURL']"/>
            	    		    </xsl:attribute>
                    			<i18n:text>xmlui.dri2xhtml.structural.search-advanced</i18n:text>
                			</a>
                		</li>
                	</ul>
    			</li>
				<xsl:for-each select="dri:list">
					<xsl:call-template name="menu-item"/>
				</xsl:for-each>
				<li id="ds-about">
					<a href="http://drc.ohiolink.edu/bitstream/handle/2374.OX/30656/faq.htm">About</a>
				</li>
			</ul>
		</div>
	</xsl:template>
    
    <xsl:template match="dri:options">
    <!--
        <div id="ds-options" class="rounded">
            <h2 id="ds-search-option-head" class="ds-option-set-head"><i18n:text>xmlui.dri2xhtml.structural.search</i18n:text></h2>
            <div id="ds-search-option" class="ds-option-set">
                <form id="ds-search-form" method="post">
                    <xsl:attribute name="action">
                        <xsl:value-of select="/dri:document/dri:meta/dri:pageMeta/dri:metadata[@element='search'][@qualifier='simpleURL']"/>
                    </xsl:attribute>
                    <fieldset>
                        <input class="ds-text-field " type="text" name="query">
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
                                    <xsl:when test="/dri:document/dri:meta/dri:pageMeta/dri:metadata[@element='focus'][@qualifier='containerType']/text() = 'type:community'">
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
                <a>
                    <xsl:attribute name="href">
                        <xsl:value-of select="/dri:document/dri:meta/dri:pageMeta/dri:metadata[@element='search'][@qualifier='advancedURL']"/>
                    </xsl:attribute>
                    <i18n:text>xmlui.dri2xhtml.structural.search-advanced</i18n:text>
                </a>
            </div>
        </div>
        -->
    </xsl:template>

    <!-- The HTML head element contains references to CSS as well as embedded JavaScript code. Most of this
        information is either user-provided bits of post-processing (as in the case of the JavaScript), or
        references to stylesheets pulled directly from the pageMeta element. 
     
     KRG 2009-01-16 Overriding template to provide a favorite icon to browser.
     The icon won't display on some pages that are using other themes, but that's okay for now - 
     it will display on the main page.
    -->
    <xsl:template name="buildHead">
        <head>
            <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
            <!-- add a favorite icon -->
            <link rel="shortcut icon" href="/favicon.ico" type="image/x-icon" />
            <meta name="Generator">
              <xsl:attribute name="content">
                <xsl:text>DSpace</xsl:text>
                <xsl:if test="/dri:document/dri:meta/dri:pageMeta/dri:metadata[@element='dspace'][@qualifier='version']">
                  <xsl:text> </xsl:text>
                  <xsl:value-of select="/dri:document/dri:meta/dri:pageMeta/dri:metadata[@element='dspace'][@qualifier='version']"/>
                </xsl:if>
              </xsl:attribute>
            </meta>
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

            <!--  Add OpenSearch auto-discovery link -->
            <xsl:if test="/dri:document/dri:meta/dri:pageMeta/dri:metadata[@element='opensearch'][@qualifier='shortName']">
                <link rel="search" type="application/opensearchdescription+xml">
                    <xsl:attribute name="href">
                        <xsl:value-of select="/dri:document/dri:meta/dri:pageMeta/dri:metadata[@element='request'][@qualifier='scheme']"/>
                        <xsl:text>://</xsl:text>
                        <xsl:value-of select="/dri:document/dri:meta/dri:pageMeta/dri:metadata[@element='request'][@qualifier='serverName']"/>
                        <xsl:text>:</xsl:text>
                        <xsl:value-of select="/dri:document/dri:meta/dri:pageMeta/dri:metadata[@element='request'][@qualifier='serverPort']"/>
                        <xsl:value-of select="$context-path"/>
                        <xsl:text>/</xsl:text>
                        <xsl:value-of select="/dri:document/dri:meta/dri:pageMeta/dri:metadata[@element='opensearch'][@qualifier='context']"/>
                        <xsl:text>description.xml</xsl:text>
                    </xsl:attribute>
                    <xsl:attribute name="title" >
                        <xsl:value-of select="/dri:document/dri:meta/dri:pageMeta/dri:metadata[@element='opensearch'][@qualifier='shortName']"/>
                    </xsl:attribute>
                </link>
            </xsl:if>
            
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

            <!-- Add theme javascipt  -->
            <xsl:for-each select="/dri:document/dri:meta/dri:pageMeta/dri:metadata[@element='javascript'][not(@qualifier)]">
                <script type="text/javascript">
                    <xsl:attribute name="src">
                        <xsl:value-of select="/dri:document/dri:meta/dri:pageMeta/dri:metadata[@element='contextPath'][not(@qualifier)]"/>
                        <xsl:text>/themes/</xsl:text>
                        <xsl:value-of select="/dri:document/dri:meta/dri:pageMeta/dri:metadata[@element='theme'][@qualifier='path']"/>
                        <xsl:text>/</xsl:text>
                        <xsl:value-of select="."/>
                    </xsl:attribute>&#160;</script>
            </xsl:for-each>
            
            <!-- add "shared" javascript from static, path is relative to webapp root-->
            <xsl:for-each select="/dri:document/dri:meta/dri:pageMeta/dri:metadata[@element='javascript'][@qualifier='static']">
                <script type="text/javascript">
                    <xsl:attribute name="src">
                        <xsl:value-of select="/dri:document/dri:meta/dri:pageMeta/dri:metadata[@element='contextPath'][not(@qualifier)]"/>
                        <xsl:text>/</xsl:text>
                        <xsl:value-of select="."/>
                    </xsl:attribute>&#160;</script>
            </xsl:for-each>
            
            <!-- add noscript meta refresh tag -->
            <xsl:for-each select="/dri:document/dri:meta/dri:pageMeta/dri:metadata[@element='refresh'][@qualifier='noscript']">
       			<noscript>
        			<meta http-equiv="refresh">
                		<xsl:attribute name="content">
                    		<xsl:value-of select="."/>
                		</xsl:attribute>
            		</meta>
        		</noscript>
            </xsl:for-each>
            
            <!-- Add a google analytics script if the key is present -->
            <xsl:if test="/dri:document/dri:meta/dri:pageMeta/dri:metadata[@element='google'][@qualifier='analytics']">
                                <script type="text/javascript">
                                        <xsl:text>var gaJsHost = (("https:" == document.location.protocol) ? "https://ssl." : "http://www.");</xsl:text>
                                        <xsl:text>document.write(unescape("%3Cscript src='" + gaJsHost + "google-analytics.com/ga.js' type='text/javascript'%3E%3C/script%3E"));</xsl:text>
                                </script>

                                <script type="text/javascript">
                                        <xsl:text>try {</xsl:text>
                                                <xsl:text>var pageTracker = _gat._getTracker("</xsl:text><xsl:value-of select="/dri:document/dri:meta/dri:pageMeta/dri:metadata[@element='google'][@qualifier='analytics']"/><xsl:text>");</xsl:text>
                                                <xsl:text>pageTracker._trackPageview();</xsl:text>
                                        <xsl:text>} catch(err) {}</xsl:text>
                                </script>
            </xsl:if>
            
            
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

            <xsl:if test="/dri:document/dri:meta/dri:pageMeta/dri:metadata[@element='xhtml_head_item']">
                <xsl:value-of select="/dri:document/dri:meta/dri:pageMeta/dri:metadata[@element='xhtml_head_item']"
                              disable-output-escaping="yes"/>
            </xsl:if>

        </head>
    </xsl:template>

	
	
	
    <!-- The header (distinct from the HTML head element) contains the title, subtitle, login box and various 
        placeholders for header images -->
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


<!-- JRD 8/2009 Adding OhioLINK-specific branding -->			
			
		 <table id="ds-banner" class="rounded">
		 <tr>
		 <td id="left-logo">
		 	<a href="http://www.ohiolink.edu/"><img src="/themes/DRC/images/terminal-41x41.gif" alt="Ohio Library and Information Network" height="52" width="48" /></a>
         	<a href="http://drc.ohiolink.edu/"><img src="/themes/DRC/images/drc-header.gif" alt="Digital Resource Commons" height="52" width="220" /></a>
		 </td>
		 <td id="center-logo">
			 <a href="http://drc.ohiolink.edu/"><img src="/themes/DRC/images/drc-1.gif" alt="Digital Resource Commons" height="80" width="320" /></a>
		 </td>
		 <td id="right-links">
			 <ul id="banner_links">
			 	<li><a href="http://www.ohiolink.edu/contact.php?form=drc">Contact a Librarian</a></li>
			 </ul>
		 </td>
		 </tr>
		 </table>
            
         <div id="ds-trail" class="rounded">
				<div id="ds-search"> 
					<i18n:text>xmlui.dri2xhtml.structural.search</i18n:text>
					<form id="ds-search-form" method="post">
                	    <xsl:attribute name="action">
                    	    <xsl:value-of select="/dri:document/dri:meta/dri:pageMeta/dri:metadata[@element='search'][@qualifier='simpleURL']"/>
                    	</xsl:attribute>
                    	<fieldset>
                        	<input class="ds-text-field " type="text" name="query">
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
	                    </fieldset>
    	            </form>
    	        </div>				
            <ul>
            	<xsl:choose>
	            	<xsl:when test="count(/dri:document/dri:meta/dri:pageMeta/dri:trail) = 0">
	                	<li class="ds-trail-link first-link"> - </li>
	                </xsl:when>
	                <xsl:otherwise>
	                	<xsl:apply-templates select="/dri:document/dri:meta/dri:pageMeta/dri:trail"/>
	                </xsl:otherwise>
                </xsl:choose>
            </ul>
         </div>  
            
            
        </div>
    </xsl:template>
    
    <!--
        The template to handle the dri:body element. It simply creates the ds-body div and applies
        templates of the body's child elements (which consists entirely of dri:div tags).
    -->
    <xsl:template match="dri:body">
      <div id="ds-container">
	    <xsl:apply-templates select="*[@rend='sidebar']"/>
        <div id="ds-body" class="rounded">
            <xsl:if test="/dri:document/dri:meta/dri:pageMeta/dri:metadata[@element='alert'][@qualifier='message']">
                <div id="ds-system-wide-alert">
                    <p>
                        <xsl:copy-of select="/dri:document/dri:meta/dri:pageMeta/dri:metadata[@element='alert'][@qualifier='message']/node()"/>
                    </p>
                </div>
            </xsl:if>
            <xsl:apply-templates select="*[@rend!='sidebar' or not(@rend)]"/>
        </div>
      </div>
    </xsl:template>

	    <!-- The first (and most complex) case of the header tag is the one used for divisions. Since divisions can
        nest freely, their headers should reflect that. Thus, the type of HTML h tag produced depends on how
        many divisions the header tag is nested inside of. 

        This template was customized by OhioLINK to make the text size smaller.  In the themes already created at OhioLINK,
        the font sizes for headers were set (smaller) by the css style sheets instead of dynamically via XSL.
        When the fonts displayed in the browser using the dynamic resize code in the XSL, they displayed too large for 
        the rest of the design.
   -->
    <!-- The font-sizing variable is the result of a linear function applied to the character count of the heading text -->
    <xsl:template match="dri:div/dri:head" priority="3">
    <xsl:variable name="head_count" select="count(ancestor::dri:div)"/>
        <!-- with the help of the font-sizing variable, the font-size of our header text is made continuously variable based on the character count -->
        <xsl:variable name="font-sizing" select="300 - $head_count * 60 - string-length(current())"></xsl:variable>
        <xsl:element name="h{$head_count}">
            <xsl:call-template name="standardAttributes">
                <xsl:with-param name="class">ds-div-head</xsl:with-param>
            </xsl:call-template>
            <xsl:apply-templates />
        </xsl:element>
    </xsl:template>
	
<!-- KRG 2008-12-12
     The next two templates have been modified to display the filmstrip thumbnail in search and browse results
-->
 <!-- Generate the thumbnail or  filmstrip thumbnail, if present, from the file section -->
    <xsl:template match="mets:fileSec" mode="artifact-preview">
        <xsl:if test="mets:fileGrp[@USE='FILMSTRIPTHUMB']">
            <div>
                <a href="{ancestor::mets:METS/@OBJID}">
                    <img alt="Filmstrip Thumbnail">
                        <xsl:attribute name="src">
                            <xsl:value-of select="mets:fileGrp[@USE='FILMSTRIPTHUMB']/mets:file/mets:FLocat[@LOCTYPE='URL']/@xlink:href" />
                        </xsl:attribute>
                    </img>
                </a>
            </div>
        </xsl:if>
        <xsl:if test="mets:fileGrp[@USE='THUMBNAIL']">
            <div class="artifact-preview">
                <a href="{ancestor::mets:METS/@OBJID}">
                    <img alt="Thumbnail">
                        <xsl:attribute name="src">
                            <xsl:value-of select="mets:fileGrp[@USE='THUMBNAIL']/mets:file
/mets:FLocat[@LOCTYPE='URL']/@xlink:href" />
                        </xsl:attribute>
                    </img>
                </a>
            </div>
        </xsl:if>
    </xsl:template>


     <!-- Resolve the reference tag to an external mets object -->
    <xsl:template match="dri:reference" mode="summaryList">
        <xsl:variable name="externalMetadataURL">
            <xsl:text>cocoon:/</xsl:text>
            <xsl:value-of select="@url"/>
            <!-- Since this is a summary only grab the descriptive metadata, and the filmstrip thumbnails or regular thumbnails -->
            <xsl:text>?sections=dmdSec,fileSec&amp;fileGrpTypes=FILMSTRIPTHUMB,THUMBNAIL</xsl:text>
        </xsl:variable>
		<xsl:variable name="pagemeta" select="/dri:document/dri:meta/dri:pageMeta"/>
        <xsl:comment> External Metadata URL: <xsl:value-of select="$externalMetadataURL"/> </xsl:comment>
        <li>
            <xsl:attribute name="class">
                <xsl:text>ds-artifact-item </xsl:text>
                <xsl:choose>
                    <xsl:when test="position() mod 2 = 0">even</xsl:when>
                    <xsl:otherwise>odd</xsl:otherwise>
                </xsl:choose>
            </xsl:attribute>
            <xsl:apply-templates select="document($externalMetadataURL)/*" mode="summaryList">
	            <xsl:with-param name="pagemeta" select="$pagemeta"/>	    
			</xsl:apply-templates>
            <xsl:apply-templates />
        </li>
    </xsl:template>
	
</xsl:stylesheet>
