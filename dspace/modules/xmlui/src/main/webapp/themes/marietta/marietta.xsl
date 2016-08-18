<?xml version="1.0" encoding="UTF-8"?>

<!--
	marietta.xsl
	
	A Manakin theme for the Marietta College instance of the
	OhioLINK Digital Resource Commons.  The style for this 
	theme is largely taken from the web page that was at
	http://library.marietta.edu/.
	
	Many of the XSL templates were taken from the dri2xhtml
	theme and then modified to give the Marietta College 
	look.
	
	Date: 2008/01/02
	
	Keith R Gilbertson
	OhioLINK
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

	<xsl:import href="../ohiolink_common/ohiolink_common.xsl" />
	<xsl:output indent="yes" />

	<!--  The theme location variable calculates the URL to the theme directory. It's used for building 
		paths to images and other resources. -->
	<xsl:variable name="theme_location"
		select="concat(/dri:document/dri:meta/dri:pageMeta/dri:metadata[@element='contextPath'][not(@qualifier)],'/themes/',/dri:document/dri:meta/dri:pageMeta/dri:metadata[@element='theme'][@qualifier='path'])" />

	<xsl:template match="dri:document">
		<html>
			<!-- First of all, build the HTML head element -->
			<xsl:call-template name="buildHead" />
			<!-- Then proceed to the body -->
			<body>
				<div id="ds-main">
					<!--
						The header div, complete with title, subtitle, and trail breadcrumbs. The trail is
						built by applying a template over pageMeta's trail children. -->
					<xsl:call-template name="buildHeader" />

					<!-- special for marietta theme - added content, content_wrapper divs -->
					<div id="content_wrapper">
						<!-- topnav here  (marietta)-->
						<div id="topnav">
							<ul>
								<li>
									<a
										href="http://library.marietta.edu/locate/index.html">
										Locate Resources
									</a>
								</li>
								<li>
									<a
										href="http://library.marietta.edu/help/index.html">
										Need Help?
									</a>
								</li>
								<li>
									<a
										href="http://library.marietta.edu/services/index.html">
										Services and Forms
									</a>
								</li>
								<li>
									<a
										href="http://library.marietta.edu/about/index.html">
										About the Library
									</a>
								</li>
							</ul>
						</div><!-- topnav -->
						<div id="content">
							<p>.</p>
							<div id="breadcrumb">
								<a href="http://library.marietta.edu">
									Library Home
								</a>
								&gt;
								<a
									href="http://library.marietta.edu/locate/index.html">
									Locate Resources
								</a>
								<xsl:apply-templates
									select="/dri:document/dri:meta/dri:pageMeta/dri:trail" />
							</div>
							<!--
								Goes over the document tag's children elements: body, options, meta. The body template
								generates the ds-body div that contains all the content. The options template generates
								the ds-options div that contains the navigation and action options available to the
								user. The meta element is ignored since its contents are not processed directly, but
								instead referenced from the different points in the document. -->
							<xsl:apply-templates />
						</div><!-- content (marietta)-->
						<!-- The footer div -->
						<xsl:call-template name="buildFooter" />
					</div><!--content_wrapper (marietta) -->
				</div>
<!-- 1/2009 JRD Including Google Analytics JavaScript just before close of body tag. -->
				<script type="text/javascript">
var gaJsHost = (("https:" == document.location.protocol) ? "https://ssl." : "http://www.");
document.write(unescape("%3Cscript src='" + gaJsHost + "google-analytics.com/ga.js' type='text/javascript'%3E%3C/script%3E"));
</script>
<script type="text/javascript">
try {
var pageTracker = _gat._getTracker("UA-5946124-3");
pageTracker._trackPageview();
} catch(err) {}</script>

			</body>
		</html>
	</xsl:template>

	<!-- The header (distinct from the HTML head element) contains the title, subtitle and various
		header images 
		Modified for ask a librarian and imagemap (marietta) -->
	<xsl:template name="buildHeader">
		<div id="ds-header">
			<div id="ask">
				<h1>Ask a Librarian</h1>
				<ul>
					<li>
                                                <a
                                                        href="http://library.marietta.edu/help/ask/index.html">
                                                        <img
                                                                src="{$theme_location}/images/ask/keyboard.gif" alt="keyboard"/>
                                                </a>
                                        </li>
                                        <li>
                                                <a
                                                        href="http://library.marietta.edu/help/ask/index.html">
                                                        IM
                                                </a>
                                        </li>
                                        <li>
                                                <a href="mailto:MCLibraryInfo@marietta.edu">
                                                <img 
                                                             src="{$theme_location}/images/ask/envelope.gif" />
                                                </a>
                                        </li> 
                                        <li>
                                                <a href="mailto:MCLibraryInfo@marietta.edu">
                                                        EMAIL
                                                </a>
                                        </li>
                                        <li>
						<a href="http://academic.knowitnow.org/">
							<img
								src="{$theme_location}/images/ask/word_balloon.gif" alt="word balloon"/>
						</a>
					</li>
					<li>
						<a href="http://academic.knowitnow.org/">CHAT</a>
					</li>
					<li>
						<a
							href="http://library.marietta.edu/help/ask/index.html">
							<img
								src="{$theme_location}/images/ask/phone.gif" alt="740-376-4543"  />
						</a>
					</li>
					<li>
						<a
							href="http://library.marietta.edu/help/ask/index.html">PHONE</a>
					</li>
				</ul>
			</div><!-- ask a librarian -->

			<div id="wordmark_secondary">
				<a href="#">
					<img src="{$theme_location}/images/header.gif"
						 usemap="#Map" alt="Marietta College Library" />
				</a>
				<map name="Map" id="Map">
					<area alt="Marietta College Home" shape="rect"
						coords="27,8,276,46" href="http://www.marietta.edu" />
					<area alt="Marietta College Library" shape="rect"
						coords="275,9,377,45" href="http://library.marietta.edu" />
				</map>
			</div>

		</div>
	</xsl:template>

	<!-- Like the header, the footer contains various miscellaneous text, links, and image placeholders -->
	<xsl:template name="buildFooter">
		<div id="clear" />
		<div id="footer">
			<ul>
				<li>
					<a
						href="http://library.marietta.edu/locate/index.html">
						Locate Resources
					</a>
				</li>
				<li>
					<a
						href="http://library.marietta.edu/help/index.html">
						Need Help?
					</a>
				</li>
				<li>
					<a
						href="http://library.marietta.edu/services/index.html">
						Services and Forms
					</a>
				</li>
				<li>
					<a
						href="http://library.marietta.edu/about/index.html">
						About the Library
					</a>
				</li>
			</ul>
		</div>

		<div id="footer_mod">
			<ul>
				<li>
					© Marietta College 1998 - 2008
					<br />
					Last modified: Today
				</li>
				<li>
					<!-- This javascript function is employed by marietta as a spam guard -->
					<script type="text/javascript">
						maddress ('library','marietta.edu','Email the Library')
					</script>
				</li>
			</ul>
		</div>
	</xsl:template>

	<!--
		The trail is built one link at a time. 
		It has been modified to blend in with the regular Marietta Library breadcrumb.
	-->
	<xsl:template match="dri:trail">
		<!-- Determine whether we are dealing with a link or plain text trail link -->
		<xsl:choose>
			<xsl:when test="./@target">
				<a>
					<xsl:attribute name="href">
                            <xsl:value-of select="./@target" />
                        </xsl:attribute>
					&gt;
					<xsl:apply-templates />
				</a>
			</xsl:when>
			<xsl:otherwise>
				&gt;
				<xsl:apply-templates />
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

<!-- Generate the info about the item from the metadata section -->
<!-- JRD, July, 2008: copied  from ../dri2xhthml/DIM-Handler.xsl because of custom metadata display -->
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
           <xsl:if test="dim:field[@element='date' and @qualifier='created']">
              <tr class="ds-table-row">
                <td><span class="bold">Date:</span></td>
                <td>
                   <xsl:for-each select="dim:field[@element='date' and @qualifier='created']/child::node()">
                   <xsl:copy-of select="."/><br/>
                   </xsl:for-each>
                </td>
              </tr>
           </xsl:if>
        </table>
    </xsl:template>

 <!-- An item rendered in the summaryList pattern. Commonly encountered in various browse-by pages
        and search results. -->
    <xsl:template name="itemSummaryList-DIM">
        <!-- Generate the info about the item from the metadata section -->
        <xsl:apply-templates select="./mets:dmdSec/mets:mdWrap[@OTHERMDTYPE='DIM']/mets:xmlData/dim:dim"
            mode="itemSummaryList-DIM"/>
        <!-- Generate the thunbnail, if present, from the file section -->
        <xsl:apply-templates select="./mets:fileSec" mode="artifact-preview"/>
    </xsl:template>

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
                        <xsl:when test="dim:field[@element='contributor'][@qualifier='author']">
                            <xsl:for-each select="dim:field[@element='contributor'][@qualifier='author']">
                                <xsl:copy-of select="./node()"/>
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
                </span>
                <xsl:text> </xsl:text>
                <xsl:if test="dim:field[@element='date' and @qualifier='issued'] or dim:field[@element='publisher']">
                        <span class="publisher-date">
                            <xsl:text>(</xsl:text>
                            <xsl:if test="dim:field[@element='publisher']">
                                <span class="publisher">
                                    <xsl:copy-of select="dim:field[@element='publisher']/node()"/>
                                </span>
                                <xsl:text>, </xsl:text>
                            </xsl:if>
                            <span class="date">
                                <xsl:value-of select="substring(dim:field[@element='date' and @qualifier='issued']/node(),1,10)"/>
                            </span>
                            <xsl:text>)</xsl:text>
                        </span>
                </xsl:if>
            </div>
            <xsl:if test="dim:field[@element='date' and @qualifier='created']">
              <span class="datecreated">
                Created Date: <xsl:value-of select="dim:field[@element='date' and @qualifier='created']" />
              </span>
            </xsl:if>
        </div>
    </xsl:template>

</xsl:stylesheet>
