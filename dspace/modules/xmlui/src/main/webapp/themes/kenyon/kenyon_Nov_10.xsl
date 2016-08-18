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

			<a href="http://www.kenyon.edu" title="Kenyon College Home Page" id="kenyonhome">
				<span class="hide">Logo link to Kenyon home page</span>
	  		</a>
                
                 	<a href="http://lbis.kenyon.edu/contact" id="contact">Contact Us </a>

        <div id="search">
			 <form name="helpline" method="post" action="http://lbis.kenyon.edu/searchlbis">
                        <input type="text" name="as_q" size="24" maxlength="256" value="" />
                        <input class="button" value="Search LBIS" type="submit" />
                 	 </form>
        </div>
        

        <div id='site-name'>
        	<h1>&#160;</h1>
		<strong>&#160;</strong>
        </div>
        
        </div> <!-- /name-and-slogan -->

      </div> 


	
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
			</div>
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
</div> <!-- header -->
</div> <!-- page -->
</xsl:template>


     <!-- An example of an existing template copied from structural.xsl and overridden -->  
<xsl:template name="buildFooter">
         	<div id="ds-footer">
        	&#169; 2008. LBIS, <a href="http://wwww.kenyon.edu">Kenyon College</a>, 103 College Drive, Gambier, OH 43022-			9624. Tel: 740/427-5186. Fax: 740/427-5272.
        	</div>
</xsl:template>


    
</xsl:stylesheet>
