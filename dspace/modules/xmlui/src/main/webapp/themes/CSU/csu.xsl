<?xml version="1.0" encoding="UTF-8"?>

<!--
  csu.xsl

  This file contains XSL templates for a custom DSpace Manakin/XMLUI 
  theme for Cleveland State University Library.

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
    <xsl:output  indent="yes"/>

   <!-- KRG overriding the below buildHead template to use 
   stylesheets hosted at CSU, as well as to add a shortcut icon -->   
    <!-- The HTML head element contains references to CSS as well as embedded JavaScript code. Most of this
        information is either user-provided bits of post-processing (as in the case of the JavaScript), or
        references to stylesheets pulled directly from the pageMeta element. -->
    <xsl:template name="buildHead">
        <head>
            <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>

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

            <!-- Add stylesheets -->
            <link rel="stylesheet" href="http://library.csuohio.edu/inc/css/styles_general.css" type="text/css" />
            <link rel="stylesheet" href="http://library.csuohio.edu/inc/css/styles_hybrid.css" type="text/css" />
            <link rel="stylesheet" href="http://library.csuohio.edu/library.css" type="text/css" />
            <link href="http://library.csuohio.edu/drcstyles.css" rel="stylesheet" type="text/css" />

            <!-- add stylesheets for specific browsers -->
            <!-- Add stylsheets -->
            <xsl:for-each select="/dri:document/dri:meta/dri:pageMeta/dri:metadata[@element='stylesheet']">
                <link rel="stylesheet" type="text/css">
                    <xsl:attribute name="href">
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

            <!-- Add Cleveland State Favorite Icon -->
            <link href="http://library.csuohio.edu/favicon.ico" rel="shortcut icon" />

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

            <!-- Add javascript  -->
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
        </head>
    </xsl:template>


 
       <!-- KRG overriding this template to replace standard DSPace
            ds-main div with csu ulibhomecontainer div -->
       <xsl:template match="dri:document">
        <html>
            <!-- First of all, build the HTML head element -->
            <xsl:call-template name="buildHead"/>
            <!-- Then proceed to the body -->
            <body>

                <div class="ulibhomecontainer">
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
                    <xsl:apply-templates select="dri:body" />

                    <!--
                        The footer div, dropping whatever extra information is needed on the page. It will
                        most likely be something similar in structure to the currently given example. --> 
                   <!-- <xsl:call-template name="buildFooter"/> -->
                   <xsl:call-template name="buildCSUFooter" />
                </div>
            </body>
        </html>
    </xsl:template>


   <!-- KRG overriding the template below to replace standard DSpace headers with CSU style
        headers -->
    <xsl:template name="buildHeader">
        
          <div id="skip"><a href="#content">Skip to Main Content</a></div>
          <div class="nav">
		<div class="nav_left"><a href="http://library.csuohio.edu">
                <img height="85" width="475" alt="Library" src="http://library.csuohio.edu/graphics/hybrid/head_left_Library.gif"/>
                </a>
                </div>
          <div class="nav_right">
	 	  <form id="atomz" name="atomz" method="get" action="http://search.atomz.com/search/"><label for="sp-q"><xsl:comment>empty div</xsl:comment> </label>
		    <div class="search_area"><input type="text" onfocus="if(this.value=='Search Library Website')this.value='';" maxlength="100" class="search_field" value="Search Library Website" size="10" name="sp-q" id="sp-q"/></div>
		  <input type="image" alt="Go" class="float_left" src="http://library.csuohio.edu/graphics/hybrid/head_go.gif" name="imageField"/>
                  <input type="hidden" value="000610c8-sp00000003" name="sp-a"/>
         </form>
		  <img height="85" width="17" alt=" " class="float_left" src="http://library.csuohio.edu/graphics/hybrid/head_right.gif"/>
		  <div class="nav_rightright"><a href="http://www.csuohio.edu">
                  <img height="31" width="224" border="0" class="nav_logo" alt="Cleveland State University" 
                   src="http://library.csuohio.edu/graphics/global/CSU_navright.gif"/></a><br/>
		  <a title="CSU Home" class="nav_csuhome" href="http://www.csuohio.edu"><xsl:comment>empty anchor</xsl:comment></a>
                  <a title="myCSU" class="nav_my_csu" href="http://mycsu.csuohio.edu"><xsl:comment>empty anchor</xsl:comment></a>
                 </div>
          </div>
	  </div>
          
          <div class="clearfloats" ><xsl:comment>empty div</xsl:comment></div>
          <a name="content" id="content"/>
  </xsl:template>
   
    <!--
       KRG Overriding the below template to wrap ds-body div with CSU divs
    -->
    <xsl:template match="dri:body">
     <div class="expanding_body">
        <div class="top"><div class="left_ulcorner"><xsl:comment>empty div</xsl:comment></div><div class="top_right"><xsl:comment>empty div</xsl:comment></div><div class="left_urcorner"><xsl:comment>empty div</xsl:comment></div></div>
        <div class="middle">
          <div class="mid_wrap">
            <div class="left_side">
           
             <!-- DRC Code for breadcrumbs -->
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
               <!--end of DRC breadcrumbs -->
                <h2 class="ulibheading2">The Digital Resource Commons @ CSU</h2>
                <div class="left_inner">
                  <div class="copy">
                    <div id="ds-body">
                      <xsl:if test="/dri:document/dri:meta/dri:pageMeta/dri:metadata[@element='alert'][@qualifier='message']">
                          <div id="ds-system-wide-alert">
                              <p>
                                  <xsl:copy-of select="/dri:document/dri:meta/dri:pageMeta/dri:metadata[@element='alert'][@qualifier='message']/node()"/>
                              </p>
                          </div>
                      </xsl:if>
                       <xsl:apply-templates />
                    </div> <!-- ds-body -->
                    <xsl:apply-templates select="/dri:document/dri:options" />
                    <div class="ulibclear"><xsl:comment>empty div</xsl:comment></div>
                    <xsl:call-template name="buildFooter" />
                  </div> <!-- copy -->
                </div> <!-- left inner -->
            </div> <!-- left_side -->
          </div> <!-- mid_wrap -->
          <div class="right_side">
	    <div class="right_inner">
	       <a href="http://www.csuohio.edu/engagedlearning/"><img height="22" width="144" border="0" alt="engaged learning" src="http://library.csuohio.edu/graphics/global/rightside_engagedlearning.gif"/></a>
	  <ul>
		<li><a href="http://library.csuohio.edu/">Library Home</a><a href="index.html"/></li>
	  </ul>
      <ul>
        <li><a href="http://library.csuohio.edu/research/index.html">Research Help</a></li>
        <li><a href="http://library.csuohio.edu/services/index.html">Services for You</a></li>
        <li><a href="http://library.csuohio.edu/information/index.html">About the Library</a></li>
        <li><a href="http://library.csuohio.edu/ims/index.html">Integrated Media Systems &amp; Services</a></li>
        <li><a href="http://www.clevelandmemory.org/">Cleveland Memory</a></li>
      </ul>
      <ul>
        <li><a href="information/hours.html">Hours</a></li>
        <li><a href="http://library.csuohio.edu/information/contact.html">Contact Us</a></li>
        <li><a href="http://library.csuohio.edu/information/directions.html">Directions</a></li>
        <li><a href="http://library.csuohio.edu/services/ask/index.html">Ask a Librarian</a></li>
        <li><a href="http://scholar.csuohio.edu/patroninfo">My Account</a></li>
        <li><a href="http://library.csuohio.edu/services/remote.html">Off-Campus Access</a></li>
        <li><a href="http://www.law.csuohio.edu/lawlibrary/">Law Library</a></li>
        <li><a href="https://elearning.csuohio.edu/webct/entryPageIns.dowebct">Blackboard</a></li>
      </ul>
      <div class="ulibaddress">
<p>Cleveland State University Library<br/>
      <em>We bring people &amp; information together.</em><br/> 
(216) 687-5300<br/>
Rhodes Tower <br/>
2121 Euclid Avenue<br/>
Cleveland, Ohio 44115-2214</p></div>
				  <br/><br/>

     <div class="contact_info">This site contains files that require the free <a target="_blank" href="http://www.adobe.com/products/acrobat/readstep2.html">Adobe Reader</a> to view.</div>
					<br/><br/>

				</div>
		  </div><!-- right_side -->
        </div> <!-- middle -->
        <div class="bottom"><div class="left_llcorner"><xsl:comment>empty div</xsl:comment></div><div class="bottom_right"><xsl:comment>empty div</xsl:comment></div><div class="left_lrcorner"><xsl:comment>empty div</xsl:comment></div></div>
      </div> <!-- expanding_body -->
      <div class="clearfloats" ><xsl:comment>empty div</xsl:comment></div>
    </xsl:template>


  
       <!-- KRG Usinng the template below to 
            build CSU style footers --> 
       <xsl:template name="buildCSUFooter">
         <div class="footer">
		<p class="footer1">© 2008 Cleveland State University | 2121 Euclid Avenue, Cleveland, OH 44115-2214 | 216.687.2000</p>
                <p class="footer2">
                  <a href="http://www.csuohio.edu/offices/affirmativeaction/statement.html">Affirmative Action</a> | <a href="http://www.csuohio.edu/offices/hrd/employment.html">Employment</a></p>
	</div>
       </xsl:template>
       
       <xsl:template name="buildFooter">
         <div id="ds-footer" > 
           <div id="ds-footer-links">
             <a href="/contact">Contact Us</a> | <a href="/feedback">Send Feedback</a> | <a href="http://drc.ohiolink.edu/">Ohio DRC</a>
           </div>
         </div>
           
       </xsl:template>
 
</xsl:stylesheet>
