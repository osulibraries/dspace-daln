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
                    
                </div>
            <xsl:call-template name="buildFooter" />
<script type="text/javascript">var gaJsHost = (("https:" == document.location.protocol) ? "https://ssl." : "http://www."); document.write(unescape("%3Cscript src='" + gaJsHost + "google-analytics.com/ga.js' type='text/javascript'%3E%3C/script%3E"));</script>
        <script type="text/javascript">try { var pageTracker = _gat._getTracker("UA-5946124-19"); pageTracker._trackPageview(); } catch(err) {}</script>

            </body>
        </html>
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
            
			<!-- KSU link to KSU main over the KSU logo -->
			<div id="ksuLogo">
				<a target="Kent State University" href="http://www.kent.edu">
					<p>Kent State University</p>
				</a>
			</div>
			
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
			
			<!-- KSU link to KSU Libraries main over the "University Libraries" text in top header logo -->
			<div id="lmsLogo">
				<a title="Home" href="http://www.library.kent.edu/page/10000">
					<p>University Libraries</p>
				</a>
			</div>
			
			<!-- KSU's top navigation link list -->
			<div class="topnav">
				<ul>
					<li class="first"><a href="http://www.library.kent.edu/cleancrumbs.php" title="Home">Home</a></li>
					<li class="pipe">|</li>
					<li><a href="http://www.library.kent.edu/page/13977" title="Research">Research</a></li>
					<li class="pipe">|</li>
					<li><a href="http://www.library.kent.edu/page/13983" title="Services">Services</a></li>
					<li class="pipe">|</li>
					<li><a href="http://www.library.kent.edu/page/13980" title="About Us">About Us</a></li>
					<li class="pipe">|</li>
					<li><a href="http://www.library.kent.edu/page/10786" title="Help">Help</a></li>
					<li class="pipe">|</li>
					<li><a href="http://www.library.kent.edu/page/10006" title="Contact Us">Contact Us</a></li>
					<li class="pipe">|</li>
					<li><a href="http://www.library.kent.edu/page/5020" title="Search">Search</a></li>
					<li class="pipe">|</li>
					<li><a href="http://www.library.kent.edu/site_index.php" title="Site Index">Site Index</a></li>
					<li class="pipe">|</li>
					<li class="last"><a href="https://www.library.kent.edu/personal" title="Personal">Personal</a></li>
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

        </div>
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
			<!-- Add a greater-than character [>] after each breadcrumb link, except the last breadcrumb link -->
			<xsl:choose>
				<xsl:when test="position()=last()">
					<span>&#160;</span>
				</xsl:when>
				<xsl:otherwise>
					<span class="greater-than">&#62;</span>
				</xsl:otherwise>
			</xsl:choose>
        </li>
    </xsl:template>



    <!-- dri:options copied from structural.xsl
        The template to handle dri:options. Since it contains only dri:list tags (which carry the actual
        information), the only things than need to be done is creating the ds-options div and applying 
        the templates inside it. 
        
        In fact, the only bit of real work this template does is add the search box, which has to be 
        handled specially in that it is not actually included in the options div, and is instead built 
        from metadata available under pageMeta.
    -->
    <!-- TODO: figure out why i18n tags break the go button -->
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
                            <br/>
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
        </div>
    </xsl:template> <!-- End of dri:options -->
	

    <!-- Template for Simple Item Record view (copied from DIM-Handler.xsl):
	Generate the info about the item from the metadata section -->
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
            <xsl:if test="dim:field[@element='contributor'][@qualifier='author'] or dim:field[@element='creator'] or dim:field[@element='contributor']">
	            <tr class="ds-table-row odd">
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
            <xsl:if test="dim:field[@element='description' and @qualifier='abstract']">
	            <tr class="ds-table-row even">
	                <td><span class="bold"><i18n:text>xmlui.dri2xhtml.METS-1.0.item-abstract</i18n:text>:</span></td>
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
	            <tr class="ds-table-row odd">
	                <td><span class="bold"><i18n:text>xmlui.dri2xhtml.METS-1.0.item-description</i18n:text>:</span></td>
	                <td>
	                <xsl:if test="count(dim:field[@element='description' and not(@qualifier)]) &gt; 1 and not(count(dim:field[@element='description' and @qualifier='abstract']) &gt; 1)">
	                	<hr class="metadata-seperator"/>
	                </xsl:if>
	                <xsl:for-each select="dim:field[@element='description' and not(@qualifier)]">
		                <xsl:copy-of select="./node()"/>
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
			
			<!-- adding additional DC metadata field (relation.uri) to the default simple item view -->
			<xsl:if test="dim:field[@element='relation' and @qualifier='uri']">
				<tr class="ds-table-row even">
				
					<td><span class="bold">Transcript:</span></td>
					<td>
						<!-- <xsl:copy-of select="dim:field[@element='relation' and @qualifier='uri']/child::node()"/> -->
						<xsl:for-each select="dim:field[@element='relation' and @qualifier='uri']">
							<a>
								<xsl:attribute name="href">
									<xsl:copy-of select="./node()"/>
								</xsl:attribute>
								<xsl:copy-of select="./node()"/>
							</a>
							<xsl:if test="count(following-sibling::dim:field[@element='relation' and @qualifier='uri']) != 0">
								<br/>
							</xsl:if>
						</xsl:for-each>
					</td>
					
				</tr>
			</xsl:if>
			<!-- end additional DC metadata field (relation.uri) -->

            <xsl:if test="dim:field[@element='identifier' and @qualifier='uri']">
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
            </xsl:if>
        </table>
    </xsl:template><!-- end template for Simple Item Record view -->


     <!-- An example of an existing template copied from structural.xsl and overridden -->  
    <xsl:template name="buildFooter">
        <div id="ds-footer">
			<div class="ksu-footer-nav">
				<ul>
					<li class="first"><a title="Home" href="http://www.library.kent.edu/page/10000">Home</a></li>
					<li><a title="Research" href="http://www.library.kent.edu/page/13977">Research</a></li>
					<li><a title="Services" href="http://www.library.kent.edu/page/13983">Services</a></li>
					<li><a title="About Us" href="http://www.library.kent.edu/page/13980">About Us</a></li>
					<li><a title="Help" href="http://www.library.kent.edu/page/10854">Help</a></li>
					<li><a title="Contact Us" href="http://www.library.kent.edu/page/10006">Contact Us</a></li>
					<li><a title="Search" href="http://www.library.kent.edu/page/5020">Search</a></li>
					<li><a title="Site Index" href="http://www.library.kent.edu/site_index.php">Site Index</a></li>
					<li class="last"><a title="Personal" href="https://www.library.kent.edu/personal">Personal</a></li>
				</ul>
			</div>
			<div id="ksu-footerLegend">
				<p class="ksu-privacy"><a href="http://www.library.kent.edu/page/10108">Privacy Statement</a></p>
				<p>&#169;2003-2009 University Libraries</p>
			</div>
		</div>
    </xsl:template>
</xsl:stylesheet>
