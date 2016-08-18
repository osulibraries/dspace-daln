<?xml version="1.0" encoding="UTF-8"?>

<!--
  uc.xsl

   Manakin XMLUI theme for University of Cincinnati.

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
var pageTracker = _gat._getTracker("UA-5946124-6");
pageTracker._trackPageview();
} catch(err) {}</script>

            </body>
        </html>
    </xsl:template>


    
    <xsl:template name="buildFooter">
        <div id="ds-footer">
            <div id="ds-footer-links">
                <ul>
                  <li>
                    <a href="/feedback.html">
                    Feedback &amp; Contact Info
                    </a>
                  </li>
                  <li>
                    <a href="/fairuse.html">
                    Fair Use &amp; Copyright
                    </a>
                  </li>
                  <li>
                    <a href="/submit.html">
                       How to Submit Materials
                    </a>
                  </li>
                  <li>
                    <a href="http://drc.ohiolink.edu/">
                       OhioLINK DRC
                    </a>
                  </li>

                 </ul>
               </div>
          </div>
    </xsl:template>

   <!-- The header (distinct from the HTML head element) contains the title, subtitle, login box and various
        placeholders for header images -->
   <!-- 08/01/2008 KRG Updated to include image map links to University of Cincinnati pages -->
    <xsl:template name="buildHeader">
        <div id="ds-header">
           <map id="uc_home_top_bar" name="uc_home_top_bar">
           <area shape="rect" alt="About the DRC" coords="93,89,213,113" href="/about.html" title="About the DRC" />
           <area shape="rect" alt="UC Digital Projects" coords="305,85,478,114" href="http://digitalprojects.libraries.uc.edu/" title="UC Digital Projects" />
           <area shape="rect" alt="UC Libraries" coords="552,83,671,112" href="http://www.uc.edu/libraries/" title="UC Libraries" />
           <area shape="rect" alt="University of Cincinnati" coords="7,6,217,82" href="http://www.uc.edu/" title="University of Cincinnati" />
           <area shape="rect" alt="Digital Resource Commons" coords="413,2,719,51" href="/" title="Digital Resource Commons" />
           <area shape="default" nohref="nohref" alt="" />
</map>

           <img usemap="#uc_home_top_bar" style="border:none;width:760px;height:125px;" alt="University of Cincinnati Digital Resource Commons" >
           <xsl:attribute name="src">
              /themes/UC/images/uc_home_top_bar.jpg
           </xsl:attribute>
         </img>
            <h1 class="pagetitle">
                <xsl:choose>
                        <!-- protection against an empty page title -->
                        <xsl:when test="not(/dri:document/dri:meta/dri:pageMeta/dri:metadata[@element='title'])">
                                <xsl:text> </xsl:text>
                        </xsl:when>
                        <xsl:otherwise>
                                <xsl:copy-of select="/dri:document/dri:meta/dri:pageMeta/dri:metadata[@element='title']/node()"/>
                        </xsl:otherwise>
                </xsl:choose>

            </h1>
            <h2 class="static-pagetitle"><i18n:text>xmlui.dri2xhtml.structural.head-subtitle</i18n:text></h2>


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

        </div>
    </xsl:template>


    <!-- The first (and most complex) case of the header tag is the one used for divisions. Since divisions can
        nest freely, their headers should reflect that. Thus, the type of HTML h tag produced depends on how
        many divisions the header tag is nested inside of.

        This template has been overridden at UC request so that the font-size attribute is no longer included.
        This template was also changed to force the "Search the DRC" and "Communities in DRC" headings to h2 per UC request. 
   -->
    <!-- The font-sizing variable is the result of a linear function applied to the character count of the heading text -->
    <xsl:template match="dri:div/dri:head" priority="3">
    <xsl:variable name="head_count" select="count(ancestor::dri:div)"/>
        <span style="display:none;"><xsl:copy-of select="preceding-sibling::dri:div" />hi</span>
        <xsl:choose>
          <xsl:when test="ancestor::dri:div[1]/@id='aspect.artifactbrowser.FrontPageSearch.div.front-page-search'">
          <xsl:element name="h2">
            <xsl:call-template name="standardAttributes">
                    <xsl:with-param name="class">ds-div-head</xsl:with-param>
                </xsl:call-template>
                <xsl:apply-templates />
            </xsl:element>
          </xsl:when>
          <!-- misspelling of "community" below is intentional to match misspelling in DRI XML -->
          <xsl:when test="ancestor::dri:div[1]/@id='aspect.artifactbrowser.CommunityBrowser.div.comunity-browser'">
          <xsl:element name="h2">
            <xsl:call-template name="standardAttributes">
                    <xsl:with-param name="class">ds-div-head</xsl:with-param>
                </xsl:call-template>
                <xsl:apply-templates />
            </xsl:element>
          </xsl:when>
          <xsl:otherwise>
            <xsl:element name="h{$head_count}">
              <xsl:call-template name="standardAttributes">
                    <xsl:with-param name="class">ds-div-head</xsl:with-param>
                </xsl:call-template>
                <xsl:apply-templates />
            </xsl:element>
          </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

<!-- KRG 10/09/2008 Creating this template so that the Ohio Digital Resource
Commons text displays below the special infobox created by Linda Newman -->
  <!-- Special case for divs tagged as "news" -->
    <xsl:template match="dri:div[@n='news']" priority="3">
        <div>
            <xsl:call-template name="standardAttributes" />
            <xsl:apply-templates select="*[not(name()='head')]"/>
        </div>
        <xsl:apply-templates select="dri:head" />
    </xsl:template>

  <!--
        The template to handle dri:options. Since it contains only dri:list tags (which carry the actual
        information), the only things than need to be done is creating the ds-options div and applying
        the templates inside it.

        In fact, the only bit of real work this template does is add the search box, which has to be
        handled specially in that it is not actually included in the options div, and is instead built
        from metadata available under pageMeta.
  
        KRG 2009-01-16 template overridden to give option to search entire DRC federation
    -->
    <!-- TODO: figure out why i18n tags break the go button -->
    <xsl:template match="dri:options">
        <div id="ds-options">
            <h3 id="ds-search-option-head" class="ds-option-set-head"><i18n:text>xmlui.dri2xhtml.structural.search</i18n:text></h3>
            <div id="ds-search-option" class="ds-option-set">
                <!-- The form, complete with a text box and a button, all built from attributes referenced
                    from under pageMeta. -->

                <!-- UC DRC -->
                UC DRC:
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
                               <xsl:text>Search UC DRC</xsl:text>
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
               
                 <!-- The "Advanced search" link, to be perched underneath the search box ( may be currently hidden in UC DRC via stylesheet) -->
                <a>
                    <xsl:attribute name="href">
                        <xsl:value-of select="/dri:document/dri:meta/dri:pageMeta/dri:metadata[@element='search'][@qualifier='advancedURL']"/>
                    </xsl:attribute>
                    <i18n:text>xmlui.dri2xhtml.structural.search-advanced</i18n:text>
                </a>

                OhioLINK DRC:
                <!-- assigning the same ID to both search forms may be problematic -->
                <form id="ds-search-form" method="get" action="http://drc.ohiolink.edu/drc_search/index.php/search/results" >
                  <fieldset>
                    <input class="ds-text-field" type="text" name="query" />
                    <input class="ds-button-field" name="submit" type="submit" i18n:attr="value" value="xmlui.general.go" />
                  </fieldset>
                </form>
            </div>

            <!-- Once the search box is built, the other parts of the options are added -->
            <xsl:apply-templates />
        </div>
    </xsl:template>



<!-- The template below ignores the form built in FrontPageSearch.java and
     displays the standard front page search form, but adds an additional advanced
     Search Link and Federated OhioLINK DRC search form.
-->
<xsl:template match="dri:div[@n='front-page-search']">
  <h2 class="ds-div-head">Search the UC DRC</h2>
  <form id="aspect_artifactbrowser_FrontPageSearch_div_front-page-search" 
        class="ds-interactive-div primary" action="/search" method="get" onsubmit="javascript:tSubmit(this);">
    <p class="ds-paragraph">
    
    <input id="aspect_artifactbrowser_FrontPageSearch_field_query" class="ds-text-field"
           name="query" value="" type="text" />
    <input id="aspect_artifactbrowser_FrontPageSearch_field_submit" class="ds-button-field" name="submit" value="Go" type="submit" />
    </p>
    
    <p class="ds-paragraph">
    <a href="/advanced-search" class="">Advanced Search</a>
    </p>
  </form>

  <h2 class="ds-div-head">Search the OhioLINK DRC</h2>
    <form method="get" id="ds-search-form-federated" action="http://drc.ohiolink.edu/drc_search/index.php/search/results">
      <p class="ds-paragraph">
        <input id="aspect_artifactbrowser_FrontPageSearch_field_query-federated" class="ds-text-field" name="query" value="" type="text" />
        <input id="aspect_artifactbrowser_FrontPageSearch_field_submit-federated" class="ds-button-field" name="submit" value="Go" type="submit" />
      </p>
   </form>
   
   <br />
</xsl:template>




        <!-- The template below was copied from ohiolink_common.xsl and is
             overridden to allow HTML formatting in the  description field
        -->
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
            <xsl:if test="dim:field[@element='description' and not(@qualifier)]">
                    <tr class="ds-table-row even">
                        <td><span class="bold"><i18n:text>xmlui.dri2xhtml.METS-1.0.item-description</i18n:text>:</span></td>
                        <td>
 <xsl:if test="count(dim:field[@element='description' and not(@qualifier)]) &gt; 1 and not(count(dim:field[@element='description' and @qualifier='abstract']) &gt; 1)">
                                <hr class="metadata-seperator"/>
                        </xsl:if>
                        <xsl:for-each select="dim:field[@element='description' and not(@qualifier)]">
                                <xsl:value-of select="." disable-output-escaping="yes" /> <!-- Allow HTML in this field -->
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
                        <!-- JRD 10/15/2008 Changed default display from Date:Issued to Date:Created -->
                        <!-- JRD 2/2009 Changed date substring to innclude more characters than default (10) iso8601 to allow for Text-based dates -->
            <xsl:if test="dim:field[@element='date' and @qualifier='created']">
                    <tr class="ds-table-row even">
                        <td><span class="bold"><i18n:text>xmlui.dri2xhtml.METS-1.0.item-date</i18n:text>:</span></td>
                        <td>
                                <xsl:for-each select="dim:field[@element='date' and @qualifier='created']">
                                        <xsl:copy-of select="substring(./node(),1)"/>
                                         <xsl:if test="count(following-sibling::dim:field[@element='date' and @qualifier='created']) != 0">
                                <br/>
                            </xsl:if>
                                </xsl:for-each>
                        </td>
                    </tr>
            </xsl:if>
        </table>
    </xsl:template>


    <!-- This template overridden to allow 
         HTML formatting in description fields
    -->
    <xsl:template match="dim:field" mode="itemDetailView-DIM">
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
            <xsl:choose>
              <xsl:when test="./@element='description'">
                <td><xsl:value-of select="./node()" disable-output-escaping="yes" /></td>
              </xsl:when>
              <xsl:otherwise>
                <td><xsl:copy-of select="./node()"/></td>
              </xsl:otherwise>
            </xsl:choose>
            <td><xsl:value-of select="./@language"/></td>
        </tr>
    </xsl:template>


</xsl:stylesheet>
