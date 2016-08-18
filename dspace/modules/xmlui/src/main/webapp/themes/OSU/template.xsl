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
    
    <xsl:import href="../dri2xhtml.xsl" />
    <xsl:output indent="yes"/>
    
    <!-- The HTML head element contains references to CSS as well as embedded JavaScript code. Most of this 
        information is either user-provided bits of post-processing (as in the case of the JavaScript), or 
        references to stylesheets pulled directly from the pageMeta element. -->
    <xsl:template name="buildHead">
        <head>
            <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>

            <!-- JRD 9/09/07 Adding highlighter.css, wsurollover.js for WSU header replication -->
			<script type="text/javascript">
					<xsl:attribute name="src">
                        <xsl:value-of select="/dri:document/dri:meta/dri:pageMeta/dri:metadata[@element='contextPath'][not(@qualifier)]"/>
                        <xsl:text>/themes/</xsl:text>
                        <xsl:value-of select="/dri:document/dri:meta/dri:pageMeta/dri:metadata[@element='theme'][@qualifier='path']"/>
                        <xsl:text>/lib/wsurollover.js</xsl:text>
                    </xsl:attribute>
                    <xsl:text> </xsl:text>
            </script>
            <!-- JRD 9/5/07 Adding javascript calls and css calls for using the lightbox.js v2 file -->
			<script type="text/javascript">
					<xsl:attribute name="src">
                        <xsl:value-of select="/dri:document/dri:meta/dri:pageMeta/dri:metadata[@element='contextPath'][not(@qualifier)]"/>
                        <xsl:text>/themes/</xsl:text>
                        <xsl:value-of select="/dri:document/dri:meta/dri:pageMeta/dri:metadata[@element='theme'][@qualifier='path']"/>
                        <xsl:text>/lib/prototype.js</xsl:text>
                    </xsl:attribute>
                    <xsl:text> </xsl:text>
            </script>
			<script type="text/javascript">
					<xsl:attribute name="src">
                        <xsl:value-of select="/dri:document/dri:meta/dri:pageMeta/dri:metadata[@element='contextPath'][not(@qualifier)]"/>
                        <xsl:text>/themes/</xsl:text>
                        <xsl:value-of select="/dri:document/dri:meta/dri:pageMeta/dri:metadata[@element='theme'][@qualifier='path']"/>
                        <xsl:text>/lib/scriptaculous.js?load=effects</xsl:text>
                    </xsl:attribute>
                    <xsl:text> </xsl:text>
            </script>
			<script type="text/javascript">
					<xsl:attribute name="src">
                        <xsl:value-of select="/dri:document/dri:meta/dri:pageMeta/dri:metadata[@element='contextPath'][not(@qualifier)]"/>
                        <xsl:text>/themes/</xsl:text>
                        <xsl:value-of select="/dri:document/dri:meta/dri:pageMeta/dri:metadata[@element='theme'][@qualifier='path']"/>
                        <xsl:text>/lib/lightbox.js</xsl:text>
                    </xsl:attribute>
                    <xsl:text> </xsl:text>
            </script>		
            <link rel="stylesheet" type="text/css">
                    <xsl:attribute name="media">
                        <xsl:value-of select="@qualifier"/>
                    </xsl:attribute>
                    <xsl:attribute name="href">
                        <xsl:value-of select="/dri:document/dri:meta/dri:pageMeta/dri:metadata[@element='contextPath'][not(@qualifier)]"/>
                        <xsl:text>/themes/</xsl:text>
                        <xsl:value-of select="/dri:document/dri:meta/dri:pageMeta/dri:metadata[@element='theme'][@qualifier='path']"/>
                        <xsl:text>/lib/lightbox.css</xsl:text>
                    </xsl:attribute>
            </link>
            <!-- JRD 9/09/07 Adding highlighter.css, wsurollover.js for WSU header replication -->
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
            
            <!-- the following javascript removes the default text of empty text areas when they are focused on or submitted -->
            <script type="text/javascript">
                function tFocus(element){if (element.value == '<i18n:text>xmlui.dri2xhtml.default.textarea.value</i18n:text>'){element.value='';}}
                function tSubmit(form){var defaultedElements = document.getElementsByTagName("textarea");
                for (var i=0; i != defaultedElements.length; i++){
                if (defaultedElements[i].value == '<i18n:text>xmlui.dri2xhtml.default.textarea.value</i18n:text>'){
                defaultedElements[i].value='';}}}
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
<!-- CSS2 Style sheets -->


<!-- <link rel="stylesheet" type="text/css" media="screen" href="highgrove_files/stylesheet_002.css" />
<link rel="stylesheet" type="text/css" media="all, screen" href="highgrove_files/stylesheet.css" /> -->
    <style type="text/css">
		
		  /***************************************
		  Generic OSU styles
		  *****************************************/
		
			@import url(css/body.css);
			@import url(http://library.osu.edu/css/navbar.css);
			@import url(http://library.osu.edu/css/masthead.css);
			@import url(http://library.osu.edu/css/menu_pulldown.css);
			@import url(http://library.osu.edu/css/footer.css);
		
		  /***************************************
		  Custom CSS for library content
		  *****************************************/
	  
	  		@import url(http://library.osu.edu/css/library.css);
	  		@import url(http://library.osu.edu/css/tabs.css);
			ul#mainMenu li { behavior: url(hover.htc); }

		
	</style>
	
	
	<style type="text/css">
.dvhdr1 {
            background:#6fbcdb;
            font-family:arial;
            font-size:11px;
            border:1px solid #65a8c3;
          	color:#fff;
			padding:4px;
			width:150px;
         }
		 
.dvbdy1 {
            background:#c8e3ee;
            font-family:arial;
			color: #4f5b5f;
            font-size:10px;
            border-left:1px solid #65a8c3;
            border-right:1px solid #65a8c3;
            border-bottom:1px solid #65a8c3;
			padding:4px;
			width:150px;
         }
		 
#footer {footer.css (line 1)
border-top:2px solid #CCCCCC;
padding-top:12px;
width:100%;
}
</style>



<!-- JC 2-18-2009 John, please insert Dspace breadcrum here -->



<div id="lholder">
<!-- OSU navbar -->
<!-- Masthead -->
<div id="masthead">
	<h1 id="masttitle">
		<a href="http://www.osu.edu/" title="The Ohio State University">The Ohio State University</a>
	</h1>
	<h2 id="masturl">
		<a href="http://www.osu.edu/" title="The Ohio State University">www.osu.edu</a>
	</h2>
			<form id="mastnavigation" action="http://google.service.ohio-state.edu/search" method="get" name="gs">
				<ol>
					<li>
						<a href="http://www.osu.edu/help.php" title="Help">Help</a>
					</li>
					<li>
						<a href="http://www.osu.edu/map/" title="Campus Map">Campus map</a>
					</li>
					<li>
						<a href="http://www.osu.edu/findpeople.php" title="Find people">Find people</a>
					</li>
					<li>
						<a href="https://webmail.osu.edu/" title="Webmail">Webmail</a>
					</li>
					<li>
						<div class="label">
					<label for="search">
						Search Ohio State's website
					</label>
				</div>
				<input class="textfield" name="q" size="14" maxlength="256" value="Search" onfocus="this.value='';" accesskey="s" tabindex="1" type="text" /> 
				<input name="submit" src="/themes/OSU/osu_files/go_button.gif" accesskey="return" tabindex="2" alt="Submit" type="image" />
				<input value="date:D:L:d1" name="sort" type="hidden" />
				<input value="xml_no_dtd" name="output" type="hidden" />
				<input value="UTF-8" name="ie" type="hidden" />
				<input value="UTF-8" name="oe" type="hidden" />
				<input value="default_frontend" name="client" type="hidden" />
				<input value="default_frontend" name="proxystylesheet" type="hidden" />
				<input value="default_collection" name="site" type="hidden" />
				<input name="as_dt" value="i" type="hidden" />
					</li>
				</ol>
			</form>
	<br class="clearall" />
</div>
<div class="hr"><hr /></div>
<!-- End masthead -->

<!-- Logo and title -->
		<div id="title">
			<img src="/themes/OSU/osu_files/osu_logo.png" alt="Ohio State University logo" height="70" width="74" />
			<img src="/themes/OSU/osu_files/libraries.gif" alt="University Libraries" height="26" width="191" />
			<img src="/themes/OSU/osu_files/img_arrow.gif" />
          <img src="/themes/OSU/osu_files/img_catalog.gif" alt="Library Catalog" height="26" width="175" />

			<br class="clearall" />
		</div>
<!-- End Logo and title -->

<!-- Pull down menu -->

<!-- menu: rounded corners - top -->
<div id="cornertop">
	<img src="/themes/OSU/osu_files/corner_ul.png" alt="" height="4" width="4" />
	<div class="rightcorner">
		<img src="/themes/OSU/osu_files/corner_ur.png" alt="" height="4" width="4" />				
	</div>
</div>
<!-- menu: pull-down lists -->
<div id="menulist">

	<ul id="mainMenu">
		<li class="no_menu"><a href="http://library.osu.edu/">OSUL Home</a></li>
		
		<li><a href="http://library.osu.edu/find/">Find</a>
			<ul>
				<li><a href="http://library.osu.edu/find/">Find Books</a></li>
				<li><a href="http://library.ohio-state.edu/screens/databases.html">Find Articles</a></li>
				<li><a href="http://nf4hr2ve4v.search.serialssolutions.com/">Find Online Journals</a></li>
				<li><a href="http://reserves.lib.ohio-state.edu/current/Eres/eres2001.php">Ereserves(FAQ)</a></li>
				<li><a href="http://library.ohio-state.edu/search/r">Reserves by Course</a></li>
				<li><a href="http://library.ohio-state.edu/search/p">Reserves by Prof</a></li>
				<li><a href="http://library.osu.edu/sites/thegateway/">Gateway to Information</a></li>
				<li><a href="http://library.osu.edu/find/sitesearch.php">Site Search</a></li>
				<li><a href="http://library.osu.edu/find/www.php">WWW Resources</a></li>
			</ul>

		</li>
	
		<li><a href="http://library.osu.edu/borrow/">Borrow</a>
			<ul>
				<li><a href="http://library.ohio-state.edu/search">OSU Library Catalog</a></li>
				<li><a href="https://library.ohio-state.edu/patroninfo/">My Record</a></li>
				<li><a href="http://library.osu.edu/find/catalogs.php">Other Catalogs</a></li>
				<li><a href="https://www.illiad.osu.edu/illiad/osu/logon.html">Interlibrary Services</a></li>
				<li><a href="http://library.osu.edu/sites/circulation/circservpol.php">Services/Policies</a></li>
			</ul>
		</li>

		
		<li><a href="http://library.osu.edu/sites/about/">About OSUL</a>
			<ul>
				<li><a href="http://library.osu.edu/sites/about/">General Info</a></li>
				<li><a href="http://library.osu.edu/sites/about/units.php">Library Units</a></li>
				<li><a href="http://library.osu.edu/phones/phones.php">Staff Directory</a></li>
				<li><a href="http://library.osu.edu/sites/libinfo/disability.php">Disability Services</a></li>
				<li><a href="http://library.osu.edu/sites/staff/diversity/">Diversity</a></li>
				<li><a href="http://library.osu.edu/sites/about/faculty.php">Services for Faculty</a></li>
				<li><a href="http://library.osu.edu/sites/friends/">Friends</a></li>
				<li><a href="http://library.osu.edu/sites/hr/joboppspub.php">Jobs</a></li>
				<li><a href="http://library.osu.edu/sites/about/changes.php">Service Changes</a></li> 
			</ul>
		</li>
		<li><a href="http://library.osu.edu/libs/">Libraries</a>
			<ul>
				<li><a href="http://library.osu.edu/sites/collections/">Subject Specialists</a></li>
				<li><a href="http://library.osu.edu/libs/">All Libraries</a></li>
				<li><a href="http://library.osu.edu/sites/libinfo/hours.php">Hours</a></li>
				<li><a href="http://library.osu.edu/sites/libinfo/Lib_Loc_Map.php">Map</a></li>
				<li><a href="http://library.osu.edu/phones/addresses.php">Contact Info</a></li>
				<li><a href="http://library.osu.edu/sites/dlib/">Digital Projects</a></li>
				<li><a href="http://library.osu.edu/sites/exhibits/">Digital Exhibits</a></li>
			</ul>
		</li>
		<li><a href="http://library.osu.edu/sites/learn/">Learn</a>
			<ul>
				<li><a href="http://library.osu.edu/sites/learn/">Instruction Services</a></li>
				<li><a href="http://liblearn.osu.edu/">net.TUTOR</a></li>
				<li><a href="http://liblearn.osu.edu/">Online Courses</a></li>
			</ul>
		</li>
		
		<li class="no_menu">
		<a href="http://proxy.lib.ohio-state.edu/login?url=http://library.osu.edu/">Off-campus Sign-in</a>
		
		<noscript>
		<a href="http://proxy.lib.ohio-state.edu/login">Off-campus Sign-in</a>
		</noscript>

		</li>
		<li class="no_menu"><a href="https://library.ohio-state.edu/patroninfo/">My Record</a>
		</li>
		<li class="last"><a href="http://library.osu.edu/help/">Help</a>
			<ul>
				<li><a href="http://library.osu.edu/help/">Ask a Question</a></li>
				<li><a href="http://library.osu.edu/sites/guides/index.php">Guides/Publications</a></li>
				<li><a href="http://library.osu.edu/help/faq.php">How Do I?</a></li>
				<li><a href="http://library.osu.edu/help/refservice.php">Reference Services</a></li>
				<li><a href="http://library.osu.edu/help/forms.php">Requests/Forms</a></li>
			</ul>
		</li>
		
	</ul>
	<br style="clear: both;" />
</div>
<!-- menu: rounded corners - bottoms -->
<div id="cornerbottom">
	<img src="/themes/OSU/osu_files/corner_ll.png" alt="" height="4" width="4" />
	<div class="rightcorner">
	<img src="/themes/OSU/osu_files/corner_lr.png" alt="" height="4" width="4" />				
	</div>
</div>



		</div></div>
	</xsl:template>
	
	
	
    <!-- An example of an existing template copied from structural.xsl and overridden -->  
    <xsl:template name="buildFooter">
        <div id="ds-footer"> 
 		<!-- page footer -->
		<div id="footer">
			<p><strong>&#169; 2007, The Ohio State University Libraries.</strong></p> 
<p>
1858 Neil Avenue Mall<br />
Columbus, OH<br />
43210-1286
</p>

<p>
Telephone: (614) 292-6154
</p>

<p>
Problems/Comments to <a href="">Web Master</a>
</p>

<p>
If you have difficulty accessing any portions of this site due to
incompatibility with adaptive technology or need the information in an
alternative format, please contact <a href="">Larry Allen</a>.
</p>
 
  		</div>
        </div> 
    </xsl:template>
	
    
</xsl:stylesheet>
