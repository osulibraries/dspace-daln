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

<xsl:stylesheet 
	xmlns:i18n="http://apache.org/cocoon/i18n/2.1"
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
    
    <!-- 2010-06-21 MF - copying Global variables from WSU theme -->
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
	<!-- MF end copy-->

	<xsl:template match="dri:document">
 	<html>
	 <!--  First of all, build the HTML head element --> 
  		<xsl:call-template name="buildHead" /> 
	 	<!--  Then proceed to the body --> 
			<body>
 				<div id="ds-main">
	 			<!--  
                        The header div, complete with title, subtitle, trail and other junk. The trail is 
                        built by applying a template over pageMeta's trail children. 
  				--> 
  					<xsl:call-template name="buildHeader" /> 
 					<!--  
                        Goes over the document tag's children elements: body, options, meta. The body template
                        generates the ds-body div that contains all the content. The options template generates
                        the ds-options div that contains the navigation and action options available to the 
                        user. The meta element is ignored since its contents are not processed directly, but 
                        instead referenced from the different points in the document. 
 					--> 
  					<xsl:apply-templates /> 
 					<!--  
                        The footer div, dropping whatever extra information is needed on the page. It will
                        most likely be something similar in structure to the currently given example. 
  					--> 
  					<xsl:call-template name="buildFooter" /> 
  				</div>
  				<!-- 2010-06-21 MF per note in WSU theme, following is for Google Analytics -->
  				<script type="text/javascript">var gaJsHost = (("https:" == document.location.protocol) ? "https://ssl." : "http://www."); document.write(unescape("%3Cscript src='" + gaJsHost + "google-analytics.com/ga.js' type='text/javascript'%3E%3C/script%3E"));</script> 
  				<script type="text/javascript">try { var pageTracker = _gat._getTracker("UA-5946124-16"); pageTracker._trackPageview(); } catch(err) {}</script> 
  			</body>
  		</html>
  	</xsl:template>


    <!-- The header (distinct from the HTML head element) contains the title, subtitle, login box and various
        placeholders for header images -->

     <xsl:template name="buildHeader">
	 
	 	<div id="header-section">
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
   	 			<div id="header"> 
   					<div id="logo-title">
             			<a href="http://lbis.kenyon.edu" title="Home" rel="home">
                  			<img src="{$theme-path}/lib/images/zen_lbis_logo.gif" alt="Home" id="logo" />
                		</a>
						<div id="contactus">
							<span id="contactus1"><a href="http://lbis.kenyon.edu/contact">Contact Us</a></span>
							<ul><li class="contact1st"><a href="http://lbis.kenyon.edu/contact/phone">Phone</a></li>
							&#160;&#160;&#160;|<li><a href="http://lbis.kenyon.edu/contact/im">Chat</a></li>
							&#160;&#160;&#160;|<li><a href="http://lbis.kenyon.edu/contact/email">Email</a></li></ul>
						</div>
 						<div id="search">
			 				<form name="helpline" method="post" action="http://lbis.kenyon.edu/searchlbis">
                        		<input type="text" name="as_q" size="24" maxlength="256" value="" />
                        		<input class="button" value="Search LBIS" type="submit" />
                 	 		</form>
        				</div>
						<a href="http://www.kenyon.edu" title="Kenyon College Home Page" id="kenyonhome">
                            <span class="hide">Logo link to Kenyon home page</span>
                		</a>
        				<div id='site-name'>
        					<h1>&#160;</h1>
							<strong>&#160;</strong>
        				</div>
        			</div> <!-- /logo-title -->
        		</div> <!-- header -->
				<div id="navigation" class="menu withprimary ">
                	<div id="primary" class="clear-block">
						<ul class="nice-menu nice-menu-down" id="nice-menu-0">
		  					<xsl:variable name="lbiskenyon" value="http://lbis.kenyon.edu" as="xs:string" />
							<li id="menu-820" class="menuparent menu-path-node-355"><a href="http://lbis.kenyon.edu/research" title="Research">Research</a>
							<ul>
								<li id="menu-821" class="menu-path-consort.library.denison.edu-"><a href="http://consort.library.denison.edu/" title="CONSORT Library Catalog">CONSORT Catalog</a></li>
								<li id="menu-822" class="menu-path-node-1326"><a href="http://lbis.kenyon.edu/alldb" title="Databases and Indexes">Databases A-Z</a></li>
								<li id="menu-823" class="menu-path-node-391"><a href="http://lbis.kenyon.edu/govdocs" title="Government Documents">Government Documents</a></li>
								<li id="menu-824" class="menu-path-node-390"><a href="http://lbis.kenyon.edu/infodesk" title="Information Desk">Information Desk</a></li>
								<li id="menu-825" class="menu-path-node-425"><a href="http://lbis.kenyon.edu/research/primary" title="Primary Source Databases and Collections">Primary Sources</a></li>
								<li id="menu-826" class="menu-path-node-180"><a href="http://lbis.kenyon.edu/quicksearch" title="Search for Articlesw">QuickSearch</a></li>
								<li id="menu-827" class="menu-path-node-455"><a href="http://lbis.kenyon.edu/research/reference" title="Reference and Research Resources">Reference Resources</a></li>
								<li id="menu-828" class="menuparent menu-path-node-762"><a href="http://lbis.kenyon.edu/research/guides" title="Research Guides by Subject and Course">Research Guides</a></li>
								<li id="menu-829" class="menu-path-node-916"><a href="http://lbis.kenyon.edu/research/writecite" title="Writing and Citing">Writing and Citing</a></li>
							</ul>
							</li>
							<li id="menu-830" class="menuparent menu-path-node-31"><a href="http://lbis.kenyon.edu/technology" title="Technology">Technology</a>
							<ul>
								<li id="menu-831" class="menuparent menu-path-node-885"><a href="http://lbis.kenyon.edu/helpline/connect" title="Get Connected">Get Connected</a></li>
								<li id="menu-832" class="menu-path-node-886"><a href="http://lbis.kenyon.edu/helpline/communicate" title="Communicate">Communicate</a></li>
								<li id="menu-833" class="menuparent menu-path-node-971"><a href="http://lbis.kenyon.edu/helpline/equipment" title="Equipment and Facilities">Equipment and Facilities</a></li>
								<li id="menu-834" class="menuparent menu-path-node-1008"><a href="http://lbis.kenyon.edu/helpline/secure" title="Be Secure">Be Secure</a></li>
								<li id="menu-835" class="menuparent menu-path-node-1012"><a href="http://lbis.kenyon.edu/helpline/help" title="Help and Support">Help and Support</a></li>
								<li id="menu-836" class="menuparent menu-path-node-932"><a href="http://lbis.kenyon.edu/email" title="Email Help">Email Help</a></li> 
								<li id="menu-837" class="menu-path-node-599"><a href="http://lbis.kenyon.edu/moodleinfo" title="Moodle Help">Moodle Help</a></li>
								<li id="menu-838" class="menuparent menu-path-node-28"><a href="http://lbis.kenyon.edu/printing" title="Printing">Printing</a></li>
								<li id="menu-839" class="menu-path-node-867"><a href="http://lbis.kenyon.edu/snap" title="Student Network Access (SNAP)">Student Network Access (SNAP)</a></li>
								<li id="menu-840" class="menu-path-www.kenyon.edu-phonebook.xml"><a href="http://www.kenyon.edu/phonebook.xml" title="Telephones">Telephones</a></li>
							</ul>
							</li>
							<li id="menu-841" class="menuparent menu-path-node-906"><a href="http://lbis.kenyon.edu/services" title="Services">Services</a>
							<ul>
								<li id="menu-842" class="menuparent menu-path-node-34"><a href="http://lbis.kenyon.edu/faculty" title="Faculty and Staff Services">Faculty and Staff Services</a></li>
								<li id="menu-843" class="menuparent menu-path-node-35"><a href="http://lbis.kenyon.edu/students" title="Student Services">Student Services</a></li>
								<li id="menu-844" class="menuparent menu-path-node-418"><a href="http://lbis.kenyon.edu/visitors" title="Visitor Services">Visitor Services</a></li>
								<li id="menu-845" class="menu-path-node-447"><a href="http://lbis.kenyon.edu/circ" title="Circulation">Circulation</a></li>
								<li id="menu-846" class="menu-path-node-387"><a href="http://lbis.kenyon.edu/reserves" title="Course Reserves and ERes">Course Reserves and ERes</a></li>
								<li id="menu-847" class="menu-path-node-390"><a href="http://lbis.kenyon.edu/infodesk" title="Information Desk">Information Desk</a></li>
								<li id="menu-848" class="menu-path-node-164"><a href="http://lbis.kenyon.edu/ill" title="Interlibrary Loan">Interlibrary Loan</a></li>
								<li id="menu-849" class="menu-path-node-316"><a href="http://lbis.kenyon.edu/multimedia" title="Multimedia Collections">Multimedia Collections</a></li>
								<li id="menu-860" class="menu-path-node-882"><a href="http://lbis.kenyon.edu/writingcenter" title="Writing Center">Writing Center</a></li>
								<li id="menu-850" class="menu-path-https--consort.library.denison.edu-patroninfo~S6"><a href="https://consort.library.denison.edu/patroninfo~S6" title="Check your library record">My CONSORT</a></li>
							</ul>
							</li>
							<li id="menu-852" class="menuparent menu-path-node-417"><a href="http://lbis.kenyon.edu/places" title="Facilities">Facilities</a>
							<ul>
								<li id="menu-854" class="menuparent menu-path-node-42"><a href="http://lbis.kenyon.edu/carrels" title="Carrels">Carrels</a></li>
								<li id="menu-853" class="menuparent menu-path-node-884"><a href="http://lbis.kenyon.edu/classroom" title="Classrooms">Classrooms</a></li>
								<li id="menu-855" class="menu-path-node-26"><a href="http://lbis.kenyon.edu/labs" title="Computing Labs">Computing Labs</a></li>
								<li id="menu-857" class="menu-path-node-7"><a href="http://lbis.kenyon.edu/floorplans" title="Find your way around the library.">Library Floor Plans</a></li>
								<li id="menu-856" class="menu-path-node-784"><a href="http://lbis.kenyon.edu/medialab" title="Multimedia Lab">Multimedia Lab</a></li>
								<li id="menu-858" class="menu-path-node-783"><a href="http://lbis.kenyon.edu/rcc" title="Remote Collaboration (RCC)">Remote Collaboration (RCC)</a></li>
								<li id="menu-859" class="menu-path-node-319"><a href="http://lbis.kenyon.edu/sca" title="Special Collections and Archives">Special Collections and Archives</a></li>
							</ul>
							</li>
							<li id="menu-861" class="menuparent menu-path-node-2"><a href="http://lbis.kenyon.edu/about" title="Information about Library and Information Services">About LBIS</a>
							<ul>
								<li id="menu-862" class="menu-path-node-364"><a href="http://lbis.kenyon.edu/about/collectionservices" title="Collection Services">Collection Services</a></li>
								<li id="menu-863" class="menuparent menu-path-node-653"><a href="http://lbis.kenyon.edu/about/documents" title="Documents">Documents</a></li>
								<li id="menu-864" class="menu-path-node-9"><a href="http://lbis.kenyon.edu/employment" title="LBIS Employment Opportunities">Employment</a></li>
								<li id="menu-865" class="menu-path-node-6"><a href="http://lbis.kenyon.edu/hours" title="Olin and Chalmers Library Hours">Hours</a></li>
								<li id="menu-866" class="menu-path-node-8"><a href="http://lbis.kenyon.edu/policies" title="Documents regarding LBIS policies">Policies</a></li>
								<li id="menu-867" class="menu-path-node-1106"><a href="http://lbis.kenyon.edu/associations" title="Professional Associations">Professional Associations</a></li>
								<li id="menu-868" class="menu-path-node-5"><a href="http://lbis.kenyon.edu/directories" title="LBIS Staff Information">Staff Directories</a></li>
								<li id="menu-869" class="menuparent menu-path-news"><a href="http://lbis.kenyon.edu/news" title="LBIS News">News</a></li>
							</ul>
							</li>
						</ul>
					</div> <!-- end primary -->
				</div>	<!-- end navigation -->
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
                    	</div> <!-- end user box -->
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
			</div> <!-- end ds-header -->
		</div> <!-- page -->
	</xsl:template> <!-- end build header -->


     <!-- An example of an existing template copied from structural.xsl and overridden --> 
    <!-- 2010-05-05 MF - changed date in footer (from 2008 to 2010) to make sure theme gets picked up -->    
	<xsl:template name="buildFooter">
		<div id="ds-footer">
        	&#169; 2010. LBIS, <a href="http://wwww.kenyon.edu">Kenyon College</a>, 103 College Drive, Gambier, OH 43022-			9624. Tel: 740/427-5186. Fax: 740/427-5272.
        </div>
	</xsl:template>

    <xsl:template name="itemSummaryView-DIM">
        <!-- 2010-05-06 MF copied from WSU mp3 logic - if there are flv files in this item, embed a player (or two) on the page
            Uses the neolao player found at http://flv-player.net/ -->
        <!-- 2010-06-17 MF comment out for Art History Slides 
        <xsl:if test="./mets:fileSec/mets:fileGrp[@USE='CONTENT']/mets:file[@MIMETYPE='video/x-flv']">
            <hr/>
            <h2>View</h2>
            <table>
                <xsl:for-each select="./mets:fileSec/mets:fileGrp[@USE='CONTENT']/mets:file[@MIMETYPE='video/x-flv']">
                    <tr>
                        <th>
                            <xsl:value-of select="./mets:FLocat[@LOCTYPE='URL']/@xlink:title" />
                        </th>
                    </tr>
                    <tr>
                        <td>
                            <object type="application/x-shockwave-flash" data="/themes/kenyon/player_flv_maxi.swf" width="480" height="385">
                                <param name="movie" value="/themes/kenyon/player_flv_maxi.swf" />
                                <param name="allowFullScreen" value="true" />
                                <param name="FlashVars" value="flv={mets:FLocat/@xlink:href}&amp;width=480&amp;height=385&amp;showstop=1&amp;showvolume=1&amp;showtime=1&amp;showfullscreen=1&amp;bgcolor1=9999ff&amp;bgcolor2=cacafc&amp;playercolor=333333&amp;showplayer=always&amp;showiconplay=1&amp;iconplaycolor=ffffff" />
                            </object>
                        </td>
                    </tr>
                </xsl:for-each>
            </table>
            <hr/>
            <br />
        </xsl:if>
        -->
        
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
    
      <!-- 2010-05-28 MF - this is the one I need for the list view -->
<!-- Generate the info about the item from the metadata section -->
    <xsl:template match="dim:dim" mode="itemSummaryList-DIM"> 
        <xsl:variable name="itemWithdrawn" select="@withdrawn" />
        <div class="artifact-description">
            <div class="artifact-title">
                <xsl:element name="a">
                    <xsl:attribute name="href">
                        <xsl:choose>
                            <xsl:when test="$itemWithdrawn">
                                <xsl:value-of select="ancestor::mets:METS/@OBJEDIT" />
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:value-of select="ancestor::mets:METS/@OBJID" />
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:attribute>
                    <xsl:choose>
                        <xsl:when test="dim:field[@element='title']">
                            <xsl:value-of select="dim:field[@element='title'][1]/node()"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <i18n:text>xmlui.dri2xhtml.METS-1.0.no-title</i18n:text>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:element>
            </div>
            <div class="artifact-info">
                <span class="author">
                    <xsl:choose>
                        <xsl:when test="dim:field[@element='contributor'][@qualifier='creator']">
                            <xsl:for-each select="dim:field[@element='contributor'][@qualifier='creator']">
                                <xsl:copy-of select="node()"/>
                                <xsl:if test="count(following-sibling::dim:field[@element='contributor'][@qualifier='creator']) != 0">
                                    <xsl:text>; </xsl:text>
                                </xsl:if>
                            </xsl:for-each>
                        </xsl:when>
		      			<xsl:when test="dim:field[@element='contributor'][@qualifier='photographer']">
                            <xsl:for-each select="dim:field[@element='contributor'][@qualifier='photographer']">
                                <xsl:copy-of select="node()"/>
                                <xsl:if test="count(following-sibling::dim:field[@element='contributor'][@qualifier='photographer']) != 0">
                                    <xsl:text>; </xsl:text>
                                </xsl:if>
                            </xsl:for-each>
                        </xsl:when>
                        <!-- <xsl:when test="dim:field[@element='contributor']">
                            <xsl:for-each select="dim:field[@element='contributor']">
                                <xsl:copy-of select="node()"/>
                                <xsl:if test="count(following-sibling::dim:field[@element='contributor']) != 0">
                                    <xsl:text>; </xsl:text>
                                </xsl:if>
                            </xsl:for-each>
                        </xsl:when> -->
                        <xsl:otherwise>
                            <i18n:text>xmlui.dri2xhtml.METS-1.0.no-author</i18n:text>
                        </xsl:otherwise>
                    </xsl:choose>
                </span>
                <xsl:text> </xsl:text>
                <xsl:if test="dim:field[@element='date' and @qualifier='created'] or dim:field[@element='date' and @qualifier='dateSubmitted'] or dim:field[@element='publisher']">
	                <span class="publisher-date">
	                    <xsl:text>(</xsl:text>
	                    <xsl:if test="dim:field[@element='publisher']">
	                        <span class="publisher">
	                            <xsl:copy-of select="dim:field[@element='publisher']/node()"/>
	                        </span>
	                        <xsl:text>, </xsl:text>
	                    </xsl:if>
	                    <span class="date">
							<xsl:choose>
								<xsl:when test="dim:field[@element='date' and @qualifier='created']">
	                        			<xsl:value-of select="substring(dim:field[@element='date' and @qualifier='created']/node(),1,10)"/>
								</xsl:when>
								<!-- 2010-05-29 MF - for thesis papers --> 					
								<xsl:when test="dim:field[@element='date' and @qualifier='dateSubmitted']">
	                        			<xsl:value-of select="substring(dim:field[@element='date' and @qualifier='dateSubmitted']/node(),1,10)"/>
								</xsl:when>
							</xsl:choose>
	                    </span>
	                    <xsl:text>)</xsl:text>
	                </span>
                </xsl:if>
                
            </div>
        </div>
    </xsl:template>

    <!-- 2010-05-04 MF - this is the one I need for the item record -->
    <!-- 2010-05-04 MF - do I need a call function above to specifically call it before I call "applytemplates"?" 2010-05-06 No, per JD-->
    <xsl:template match="dim:dim" mode="itemSummaryView-DIM">
        
        <table class="ds-includeSet-table">
			<!-- 2010-06-21 MF trying uncomment again with enabled flags in config file - still didn't work-->
			<!-- 2010-06-17 MF uncommenting section to see what happens - didn't work - all items say No preview available 
            <tr class="ds-table-row odd">
                <td><span class="bold"><i18n:text>xmlui.dri2xhtml.METS-1.0.item-preview</i18n:text>:</span></td>
                <td>
                	<xsl:choose>
                		<xsl:when test="mets:fileSec/mets:fileGrp[@USE='THUMBNAIL']">
                			<a class="image-link">
                				<xsl:attribute name="href"><xsl:value-of select="@OBJID"/></xsl:attribute>
                				<img alt="Thumbnail">
                					<xsl:attribute name="src">
                						<xsl:value-of select="mets:fileSec/mets:fileGrp[@USE='THUMBNAIL']/mets:file/mets:FLocat[@LOCTYPE='URL']/@xlink:href"/>
                					</xsl:attribute>
                				</img>
                			</a>
                		</xsl:when>
                		<xsl:otherwise>
                			<i18n:text>xmlui.dri2xhtml.METS-1.0.no-preview</i18n:text>
                		</xsl:otherwise>
                	</xsl:choose>
                </td>
            </tr>
            -->
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
					<!-- 2010-06-01 MF - changing to Artist for label -->                    
					<!-- 2010-05-04 MF - (from WSU) if the contributor.creator field is present, label this field as Creator (for ARHS and CW).
                        Otherwise, use the default label (Author)
                    -->
                    <xsl:choose>
                        <xsl:when test="dim:field[@element='contributor'][@qualifier='creator']">
                            <td><span class="bold"><xsl:text>Artist</xsl:text>:</span></td>
                        </xsl:when>
                        <xsl:when test="dim:field[@element='contributor'][@qualifier='photographer']">
                            <td><span class="bold"><xsl:text>Photographer</xsl:text>:</span></td>
                        </xsl:when>
                        <!-- 2010-06-17 MF - don't want it do anything if nothing's there 
                        <xsl:otherwise>
                            <td><span class="bold"><i18n:text>xmlui.dri2xhtml.METS-1.0.item-author</i18n:text>:</span></td>
                        </xsl:otherwise>
                        -->
                    </xsl:choose>
                    
                    <td>
                        <xsl:choose>
                            <xsl:when test="dim:field[@element='contributor'][@qualifier='creator']">
                                <xsl:for-each select="dim:field[@element='contributor'][@qualifier='creator']">
                                    <xsl:copy-of select="node()"/>
                                </xsl:for-each>                             
                            </xsl:when>
							<xsl:when test="dim:field[@element='contributor'][@qualifier='photographer']">
                                <xsl:for-each select="dim:field[@element='contributor'][@qualifier='photographer']">
                                    <xsl:copy-of select="node()"/>
                                    <xsl:if test="count(following-sibling::dim:field[@element='contributor'][@qualifier='photographer']) != 0">
                                        <xsl:text>; </xsl:text>
                                    </xsl:if>
                                </xsl:for-each>
                            </xsl:when>
                            <!-- 2010-05-04 MF - Comment out using contributor when author not present to see if fixes problem
                                <xsl:when test="dim:field[@element='contributor']">
                                <xsl:for-each select="dim:field[@element='contributor']">
                                <xsl:copy-of select="node()"/>
                                <xsl:if test="count(following-sibling::dim:field[@element='contributor']) != 0">
                                <xsl:text>; </xsl:text>
                                </xsl:if>
                                </xsl:for-each>
                                </xsl:when>
                                MF - end comment out -->
                            <xsl:otherwise>
                                <i18n:text>xmlui.dri2xhtml.METS-1.0.no-author</i18n:text>
                            </xsl:otherwise>
                        </xsl:choose>
                    <!-- 2010-06-17 try adding culture, role and dates here before closing cell-->
                    	<xsl:text> (</xsl:text>
                    	<xsl:if test="dim:field[@element='contributor' and @qualifier='creatorCulture']">
               		  		<xsl:for-each select="dim:field[@element='contributor'][@qualifier='creatorCulture']">
                        		<xsl:copy-of select="./node()"/>
                            	<xsl:if test="count(following-sibling::dim:field[@element='contributor'][@qualifier='creatorCulture']) != 0">
                              		<xsl:text>-</xsl:text>
                            	</xsl:if>
                        	</xsl:for-each>
		            	</xsl:if>
		            	<xsl:text> </xsl:text>
		            	<xsl:if test="dim:field[@element='contributor' and @qualifier='creatorRole']">
               		  		<xsl:for-each select="dim:field[@element='contributor'][@qualifier='creatorRole']">
                        		<xsl:copy-of select="./node()"/>                          
                            	<xsl:if test="count(following-sibling::dim:field[@element='contributor'][@qualifier='creatorRole']) != 0">
                              		<xsl:text>, </xsl:text>
                            	</xsl:if>
                            	<xsl:if test="count(following-sibling::dim:field[@element='contributor'][@qualifier='creatorRole']) = 1">
                              		<xsl:text> and </xsl:text>
                            	</xsl:if>
                        	</xsl:for-each>
		            	</xsl:if>
		            	<xsl:text>, </xsl:text>
		            	<xsl:if test="dim:field[@element='contributor' and @qualifier='creatorDates']">
               		  		<xsl:for-each select="dim:field[@element='contributor'][@qualifier='creatorDates']">
                        		<xsl:copy-of select="./node()"/>
                            	<xsl:if test="count(following-sibling::dim:field[@element='contributor'][@qualifier='creatorDates']) != 0">
                              		<xsl:text>, </xsl:text>
                            	</xsl:if>
                        	</xsl:for-each>
		            	</xsl:if>
		            	<xsl:text>)</xsl:text>
                    </td>
                </tr>
            </xsl:if>
            <!-- 2010-06-17 MF - don't want description for slides -->
            <!--
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
            -->
            
            <xsl:if test="dim:field[@element='date' and @qualifier='created']">
                <tr class="ds-table-row even">
                    <td><span class="bold"><i18n:text>xmlui.dri2xhtml.METS-1.0.item-date</i18n:text>:</span></td>
                    <td>
                        <xsl:for-each select="dim:field[@element='date' and @qualifier='created']">
                            <xsl:copy-of select="substring(./node(),1,10)"/>
                            <xsl:if test="count(following-sibling::dim:field[@element='date' and @qualifier='created']) != 0">
                                <br/>
                            </xsl:if>
                        </xsl:for-each>
                    </td>
                </tr>
            </xsl:if>
            <!-- 2010-06-17 MF try to add coverage temporal -->
            <xsl:if test="dim:field[@element='coverage' and @qualifier='temporal']">
            	<tr class="ds-table-row odd">
            		<td><span class="bold">Period:</span></td>
            		<td>
            		  	<xsl:for-each select="dim:field[@element='coverage'][@qualifier='temporal']">
                        	<xsl:copy-of select="./node()"/>
                            <xsl:if test="count(following-sibling::dim:field[@element='coverage'][@qualifier='temporal']) != 0">
                              	<xsl:text>; </xsl:text>
                            </xsl:if>
                        </xsl:for-each>
                    </td>
            	</tr>
            </xsl:if>
            <!-- 2010-06-17 MF try to add coverage spatial -->
            <xsl:if test="dim:field[@element='coverage' and @qualifier='spatial']">
            	<tr class="ds-table-row even">
            		<td><span class="bold">Location:</span></td>
            		<td>
            		  	<xsl:for-each select="dim:field[@element='coverage'][@qualifier='spatial']">
                        	<xsl:copy-of select="./node()"/>
                            <xsl:if test="count(following-sibling::dim:field[@element='coverage'][@qualifier='spatial']) != 0">
                              	<xsl:text>; </xsl:text>
                            </xsl:if>
                        </xsl:for-each>
                    </td>
            	</tr>
            </xsl:if>
            <!-- 2010-06-17 MF - move handle to bottom -->
            <xsl:if test="dim:field[@element='identifier' and @qualifier='uri']">
                <tr class="ds-table-row odd">
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
            
        </table>
    </xsl:template>
    
    
</xsl:stylesheet>
