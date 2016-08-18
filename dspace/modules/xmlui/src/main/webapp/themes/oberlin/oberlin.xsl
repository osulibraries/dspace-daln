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
    Contains templates for generation of the Oberlin College DRC page.
 
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
    <xsl:output indent="no"/>
    
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
<!--
KRG 10/07/2008 overriding  to produce Oberlin specified HTML 
-->


-->
    <xsl:template match="dri:document">
        <html>
            <!-- First of all, build the HTML head element -->
            <xsl:call-template name="buildHead"/>
            <!-- Then proceed to the body -->
            <body>

                <div id="wrapper">
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
                    <div id="content" style="clear: both;">
                    <!-- trail will go here KRG -->
                     <p> 
                       <a href="http://www.oberlin.edu/library"> Library Home </a> » 
                                <xsl:apply-templates select="/dri:document/dri:meta/dri:pageMeta/dri:trail"/>
                     </p>

                      <br />
                      <div id="ds-main">
                        <xsl:apply-templates />
                      </div>
                    </div>
                    <!--
                        The footer div, dropping whatever extra information is needed on the page. It will
                        most likely be something similar in structure to the currently given example. -->
                    <xsl:call-template name="buildFooter"/>

                </div>
  
               <!-- Google Analytics code - experimental - trying to track usage of this site with two GA profiles, OhioLINK
                    and Oberlin College --> 
              <script type="text/javascript">
                 var gaJsHost = (("https:" == document.location.protocol) ? "https://ssl." : "http://www.");
                 document.write(unescape("%3Cscript src='" + gaJsHost + "google-analytics.com/ga.js' type='text/javascript'%3E%3C/script%3E"));
              </script>
              <script type="text/javascript">
                 var pageTrackerOberlin = _gat._getTracker("UA-1055570-1");
                 pageTrackerOberlin._trackPageview();
              </script>
              <script type="text/javascript">
                 var pageTrackerOhioLINK = _gat._getTracker("UA-5946124-4");
                 pageTrackerOhioLINK._trackPageview();
              </script> 
            </body>
        </html>
    </xsl:template>
  
  <!-- The HTML head element contains references to CSS as well as embedded JavaScript code. Most of this
        information is either user-provided bits of post-processing (as in the case of the JavaScript), or
        references to stylesheets pulled directly from the pageMeta element. 
        KRG 10/07/2008 Overriding to add page included styles provided by Oberlin.
   -->
    <xsl:template name="buildHead">
        <head>
            <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>

             <link rel="stylesheet" type="text/css" href="http://www.oberlin.edu/library/styles/oberlin_drc_style.css" />

       


<xsl:text disable-output-escaping="yes">

&lt;!--[if IE]&gt;

                &lt;link rel="stylesheet" media="all" type="text/css" href="http://www.oberlin.edu/library/styles/oberlin_drc_style_ie.css" /&gt;

&lt;![endif]--&gt;
</xsl:text>
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

         <!-- Oberlin specified page included styles -->
        <!-- Branch-specific -->
        <style type="text/css">
	    #header{ background: #903 url(http://www.oberlin.edu/library/images/frontbanner/books6.gif) top left;
			 padding-bottom: 0;}
	a:link{ display: inline;}
       </style>
       
       </head>
    </xsl:template>
 
    <!-- The header (distinct from the HTML head element) contains the title, subtitle, login box and various
        placeholders for header images 
     KRG 10/07/2008 overriding with oberlin provided header code
     -->
    <xsl:template name="buildHeader">
  <div id="top">
	<div id="header">
		<span id="logo">Oberlin College Library</span>
		<div id="pipe">
			<ul>
				<li class="active"><a title="Library home page" href="http://www.oberlin.edu/library/">Home</a></li>
				<li><a title="Art Library home page" href="http://www.oberlin.edu/library/art/">Art</a></li>
				<li><a title="Conservatory Library home page" href="http://www.oberlin.edu/library/con/">Conservatory</a></li>
				<li><a title="Science Library home page" href="http://www.oberlin.edu/library/science/">Science</a></li>
				<li><a href="http://www.oberlin.edu/acommons">The Academic Commons</a></li>
			</ul>
		</div>
	</div>
</div>  
   <div id="searchqlinks">
	<div id="obissearch">
		<form action="http://obis.oberlin.edu/search/a?a" method="post">
			<input type="hidden" value="D" name="SORT"/>
			<span style="margin-bottom: 0pt; padding-bottom: 0pt;">
				<a style="display: inline; background-color: transparent; font-family: sans-serif; color: rgb(255, 255, 255) ! important;" title="OBIS: Catalog of the Oberlin Library" href="http://obis.oberlin.edu/">Search OBIS</a>
			</span>
			<select name="searchtype">
				<option value="t" selected="selected">TITLE</option>
				<option value="a">AUTHOR</option>
				<option value="d">SUBJECT</option>
				<option value="X">KEYWORD</option>
				<option value="c">LC Call #</option>
				<option value="m">Dewey Decimal #</option>
				<option value="g">Govt Doc #</option>
                <option value="i">ISBN/ISSN</option>
                <option value="o">Worldcat/OCLC #</option>
                <option value="l">Local Call#</option>


			</select>
			<input type="text" size="20" name="searcharg"/> <input type="submit" value="Search"/>
		</form>
	</div><!-- obissearch -->

	<div id="qlinks">
		<form action="" name="form1">
			<select onchange="MM_jumpMenu('parent',this,1)" name="QuickLinks">
				<option selected="selected" value="">Quick Links</option>
				<option value=""> </option>
				<option value="http://obis.oberlin.edu/">OBIS</option>
				<option value="http://olc1.ohiolink.edu/search/">OhioLINK Catalog</option>
				<option value="http://newfirstsearch.oclc.org/dbname=WorldCat;done=referer;FSIP">WorldCat</option>
				<option value="http://venus.cc.oberlin.edu:2048/login?url=http://www.jstor.org/">JSTOR</option>
				<option value="http://journals.ohiolink.edu/">Electronic Journal Center (EJC)</option>
				<option value=""> </option>
				 <option value="http://www.ohiolink.edu/resources/dblist.php?by=alpha&amp;search=a">Databases A to Z</option>
				<option value="http://www.ohiolink.edu/resources.cgi?by=subject">Databases by Subject</option>
				<option value=""> </option>
				<option value="http://eres.cc.oberlin.edu/">ERes</option>
				<option value="http://illiad.lib.oberlin.edu/illiad/logon.html">ILLiad/Interlibrary Loan</option>
				<option value="http://oncampus.oberlin.edu/">Blackboard</option>
				<option value="http://venus.cc.oberlin.edu:2048/login?url=https://www.refworks.com/Refworks/">RefWorks</option>
				<option value="http://obis.oberlin.edu/patroninfo">Your library record</option>
			</select>
		</form>
		<br style="clear: both; height: 0pt;"/>
	</div><!-- qlinks -->
	<br class="clear"/>
</div>




    </xsl:template>
 
    <!-- KRG 10/07/2008 Overriding to use Oberlin provided HTML for the footer area of the page -->  
    <xsl:template name="buildFooter">
    <div class="clear" id="bottom">
	<div id="footerlinks">
		<ul class="dsfooter">
			<li><a title="Digital Commons Home" href="http://www.oberlin.edu/library/DRC/default.html">Digital Commons Home</a></li>
			<li><a title="How to contribute" href="http://www.oberlin.edu/library/DRC/contribute.html">How to Contribute</a></li>
			<li><a title="OhioDRC" href="http://drc.ohiolink.edu/">OhioLINK Digital Resource Commons</a></li>
		</ul>
        </div>

	<div class="searchsite" id="lastupdated">
		Last updated:<br/>

<!-- Last Updated Date -->

October 06, 2008
<!-- Branch-specific -->
	</div>

	<div id="googlesearch" style="padding: 0pt; text-align: center; margin-bottom: 0pt;" class="centered small searchsite">
		<form method="get" action="http://www.google.com/search">
			<input type="hidden" value="www.oberlin.edu/library/" name="sitesearch"/>
			<input type="text" size="20" name="q"/>  <input type="submit" name="submit" value="Search Library Web Site"/><br/>
			<span style="font-size: 0.7em;">Powered by <span class="blue">G</span><span class="red">o</span><span class="yellow">o</span><span class="blue">g</span><span class="green">l</span><span class="red">e</span></span>
		</form>
	</div>

	<div id="footer">
		<a title="Oberlin College Library main page" href="http://www.oberlin.edu/library/">Oberlin College Library</a>
		<br/>
  148 West College Street · Oberlin, OH 44074-1545<br/>
		<a href="http://www.oberlin.edu/" id="oo">Oberlin Online</a>
		<a href="http://www.oberlin.edu/archive/" id="oa">Oberlin Archives</a>
		tel (440) 775-8285 · fax (440) 775-6586<br/>
		Library.Webmaster@oberlin.edu · ©

		2008
		Oberlin College Library
	</div><!-- footer -->
</div>
    </xsl:template>

 <!--
        The trail is built one link at a time. Each link is given the ds-trail-link class, with the first and
        the last links given an additional descriptor.
        KRG 10/07/2008 Overriding to match Oberlin College Library trail.
    -->
    <xsl:template match="dri:trail">
        <span>
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
        </span> <xsl:if test="not( position()=last())">»</xsl:if>  
     </xsl:template>

    
</xsl:stylesheet>
