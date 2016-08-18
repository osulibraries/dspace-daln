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

				<!-- 
                    The header div, complete with title, subtitle, trail and other junk. The trail is 
                    built by applying a template over pageMeta's trail children. -->
				<xsl:call-template name="buildHeader"/>
                
                <div id="ds-main">

                    <!-- 
                        Goes over the document tag's children elements: body, options, meta. The body template
                        generates the ds-body div that contains all the content. The options template generates
                        the ds-options div that contains the navigation and action options available to the 
                        user. The meta element is ignored since its contents are not processed directly, but 
                        instead referenced from the different points in the document. -->
                    <xsl:apply-templates />

				</div>

				<!-- 
                    The footer div, dropping whatever extra information is needed on the page. It will
                    most likely be something similar in structure to the currently given example. -->
                <xsl:call-template name="buildFooter"/>
				
				<script type="text/javascript">
				var gaJsHost = (("https:" == document.location.protocol) ? "https://ssl." : "http://www.");
				document.write(unescape("%3Cscript src='" + gaJsHost + "google-analytics.com/ga.js' type='text/javascript'%3E%3C/script%3E"));
				</script>
				<script type="text/javascript">
				try {
					var pageTracker = _gat._getTracker("UA-5946124-12");
					pageTracker._trackPageview();
				} catch(err) {}
				</script>

            </body>
        </html>
    </xsl:template>

    <!-- buildHeader override -->
	<!-- The header (distinct from the HTML head element) contains the title, subtitle, login box and various 
        placeholders for header images -->
    <xsl:template name="buildHeader">
        <div id="ds-header">
			<div id="wsu-banner-head">
				<div id="wsu-banner-head-container">
					<ul id="wsu-top-left-nav">
						<li class="wrightstate">
							<a href="http://www.wright.edu/"></a>
						</li>
						<li class="wsumenu-core">
							<p>wsumenu_core_active.gif</p>
						</li>
						<li class="wsu-library">
							<a href="http://libraries.wright.edu/"></a>
						</li>
					</ul>
					<ul id="wsu-top-right-nav">
						<li class="wsu-contact">
							<a href="http://libraries.wright.edu/help/contact/"></a>
						</li>
					</ul>
				</div>
			</div>

			<div id="wsu-header-logos">

				<a>
					<xsl:attribute name="href">
						<xsl:value-of select="/dri:document/dri:meta/dri:pageMeta/dri:metadata[@element='contextPath'][not(@qualifier)]"/>/
					</xsl:attribute>
					<span id="ds-header-logo">&#160;</span>
				</a>
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

				<div id="wsu-libraries">
					<a href="http://libraries.wright.edu/"><p>University Libraries</p></a>
				</div>

			</div>
            
            <div id="wsu-trail">
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

            <xsl:choose> <!-- ds-user-box -->
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
            
        </div>
    </xsl:template><!-- end buildHeader override -->

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

    <!-- ds-options override -->
	<!-- 
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
			
			<h3 class="ds-option-set-head">About</h3>
			<div id="wsu-about" class="ds-option-set">
				<ul class="ds-simple-list">
					<li><a href="">How to Contribute</a></li>
					<li><a href="">Content Guidelines</a></li>
					<li><a href="">Rights &#38; Responsibilities</a></li>
					<li><a href="">FAQ</a></li>
					<li><a href="">Contact Digital Services</a></li>
				</ul>
			</div>

            <!-- Once the search box is built, the other parts of the options are added -->
            <xsl:apply-templates />

        </div>
    </xsl:template><!-- end ds-options override -->

	<!-- override HTML h tag variable font sizing function -->

	<!-- The first (and most complex) case of the header tag is the one used for divisions. Since divisions can 
        nest freely, their headers should reflect that. Thus, the type of HTML h tag produced depends on how
        many divisions the header tag is nested inside of. -->
    <!-- The font-sizing variable is the result of a linear function applied to the character count of the heading text -->
    <xsl:template match="dri:div/dri:head" priority="3">
        <xsl:variable name="head_count" select="count(ancestor::dri:div)"/>
        <!-- with the help of the font-sizing variable, the font-size of our header text is made continuously variable based on the character count -->
        <xsl:variable name="font-sizing" select="365 - $head_count * 80 - string-length(current())"></xsl:variable>
        <xsl:element name="h{$head_count}">
            <!-- in case the chosen size is less than 120%, don't let it go below. Shrinking stops at 120% -->
            <!-- xsl:choose>
                <xsl:when test="$font-sizing &lt; 120">
                    <xsl:attribute name="style">font-size: 120%;</xsl:attribute>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:attribute name="style">font-size: <xsl:value-of select="$font-sizing"/>%;</xsl:attribute>
                </xsl:otherwise>
            </xsl:choose> -->
            <xsl:call-template name="standardAttributes">
                <xsl:with-param name="class">ds-div-head</xsl:with-param>
            </xsl:call-template>            
            <xsl:apply-templates />
        </xsl:element>
    </xsl:template>

    <!-- buildFooter override -->
	<!-- Like the header, the footer contains various miscellanious text, links, and image placeholders -->
    <xsl:template name="buildFooter">
        <div id="ds-footer">
			<p>3640 Colonel Glenn Highway, Dayton, Ohio 45435. Phone: 937.775.3927</p>
        </div>
    </xsl:template><!-- end buildFooter override -->













<!-- KRG Hide browse by issue date until fix can be found- interface to jump to point in index is broken -->
<!--
<xsl:template match="dri:options/dri:list[@id='aspect.artifactbrowser.Navigation.list.browse']/dri:list/dri:item/dri:xref[@target='/browse?type=dateissued']">
</xsl:template>
-->

<!-- KRG temporary hide provenance information - demo for DRMC -->
    <!-- xsl:template match="dim:field" mode="itemDetailView-DIM">
    <xsl:if test="not(@element='description' and @qualifier='provenance')">
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
            <td><xsl:copy-of select="./node()"/></td>
            <td><xsl:value-of select="./@language"/></td>
        </tr>
    </xsl:if>
    </xsl:template> -->

</xsl:stylesheet>
