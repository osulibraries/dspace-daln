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
var pageTracker = _gat._getTracker("UA-5946124-12");
pageTracker._trackPageview();
} catch(err) {}</script>

            </body>
        </html>
    </xsl:template>

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
			
			<!-- TRACK TITLE dc.title.none -->
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

			<!-- WORK TITLE dc.relation.ispartof -->
			<xsl:if test="dim:field[@element='relation' and @qualifier='ispartof']">
				<tr class="ds-table-row odd">
					<td><span class="bold">Work Title: </span></td>
					<td>
						<xsl:for-each select="dim:field[@element='relation' and @qualifier='ispartof']">
							<xsl:value-of select="./node()"/>
							<xsl:if test="count(following-sibling::dim:field[@element='relation' and @qualifier='ispartof']) != 0">
								<xsl:text>; </xsl:text>
							</xsl:if>
						</xsl:for-each>
					</td>
				</tr>
			</xsl:if>

			<!-- COMPOSER dc.contributor.[composer or arranger] -->
			<xsl:if test="dim:field[@element='contributor' and @qualifier='composer' or @qualifier='arranger']">
				<tr class="ds-table-row even">
					<td><span class="bold">Composer: </span></td>
					<td>
						<xsl:for-each select="dim:field[@element='contributor' and @qualifier='composer' or @qualifier='arranger']">
							<xsl:value-of select="./node()"/>
							<xsl:if test="count(following-sibling::dim:field[@element='contributor' and @qualifier='composer' or @qualifier='arranger']) != 0">
								<xsl:text>; </xsl:text>
							</xsl:if>
						</xsl:for-each>
					</td>
				</tr>
			</xsl:if>
			
			<!-- PERFORMER dc.contributor.[artist or conductor or choir or ensemble or orchestra] -->
			<xsl:if test="dim:field[@element='contributor' and @qualifier='artist' or @qualifier='conductor' or @qualifier='choir' or @qualifier='ensemble' or @qualifier='orchestra']">
				<tr class="ds-table-row odd">
					<td><span class="bold">Performer: </span></td>
					<td>
						<xsl:for-each select="dim:field[@element='contributor' and @qualifier='artist' or @qualifier='conductor' or @qualifier='choir' or @qualifier='ensemble' or @qualifier='orchestra']">
							<xsl:value-of select="./node()"/>
							<xsl:if test="count(following-sibling::dim:field[@element='contributor' and @qualifier='artist' or @qualifier='conductor' or @qualifier='choir' or @qualifier='ensemble' or @qualifier='orchestra']) != 0">
								<xsl:text>; </xsl:text>
							</xsl:if>
						</xsl:for-each>
					</td>
				</tr>
			</xsl:if>

			<!-- DATE OF COMPOSITION dc.date.created -->
            <xsl:if test="dim:field[@element='date' and @qualifier='created']">
				<tr class="ds-table-row even">
					<td><span class="bold"><i18n:text>xmlui.dri2xhtml.METS-1.0.item-date</i18n:text>:</span></td>
					<td>
						<xsl:for-each select="dim:field[@element='date' and @qualifier='created']">
							<!-- JRD 2/2009 Changed date substring to innclude more characters than default (10) iso8601 to allow for Text-based dates -->
							<xsl:copy-of select="substring(./node(),1)"/>
							<xsl:if test="count(following-sibling::dim:field[@element='date' and @qualifier='created']) != 0">
								<br/>
							</xsl:if>
						</xsl:for-each>
					</td>
				</tr>
            </xsl:if>

			<!-- STYLE (from the Naxos 'period' tag) dc.coverage.temporal -->
			<xsl:if test="dim:field[@element='coverage' and @qualifier='temporal']">
				<tr class="ds-table-row odd">
					<td><span class="bold">Style: </span></td>
					<td>
						<xsl:for-each select="dim:field[@element='coverage' and @qualifier='temporal']">
							<xsl:value-of select="./node()"/>
							<xsl:if test="count(following-sibling::dim:field[@element='coverage' and @qualifier='temporal']) != 0">
								<xsl:text>; </xsl:text>
							</xsl:if>
						</xsl:for-each>
					</td>
				</tr>
			</xsl:if>

			<!-- GENRE dc.type.subgenre -->
			<xsl:if test="dim:field[@element='type' and @qualifier='subgenre']">
				<tr class="ds-table-row even">
					<td><span class="bold">Genre: </span></td>
					<td>
						<xsl:for-each select="dim:field[@element='type' and @qualifier='subgenre']">
							<xsl:value-of select="./node()"/>
							<xsl:if test="count(following-sibling::dim:field[@element='type' and @qualifier='subgenre']) != 0">
								<xsl:text>; </xsl:text>
							</xsl:if>
						</xsl:for-each>
					</td>
				</tr>
			</xsl:if>

			<!-- TRACK DURATION dc.format.extent -->
			<xsl:if test="dim:field[@element='format' and @qualifier='extent']">
				<tr class="ds-table-row odd">
					<td><span class="bold">Track Duration: </span></td>
					<td>
						<xsl:for-each select="dim:field[@element='format' and @qualifier='extent']">
							<xsl:value-of select="./node()"/>
							<xsl:if test="count(following-sibling::dim:field[@element='format' and @qualifier='extent']) != 0">
								<xsl:text>; </xsl:text>
							</xsl:if>
						</xsl:for-each>
					</td>
				</tr>
			</xsl:if>

			<!-- ALBUM TITLE dc.relation.album -->
			<xsl:if test="dim:field[@element='relation' and @qualifier='album']">
				<tr class="ds-table-row even">
					<td><span class="bold">Album Title: </span></td>
					<td>
						<xsl:for-each select="dim:field[@element='relation' and @qualifier='album']">
							<xsl:value-of select="./node()"/>
							<xsl:if test="count(following-sibling::dim:field[@element='relation' and @qualifier='album']) != 0">
								<xsl:text>; </xsl:text>
							</xsl:if>
						</xsl:for-each>
					</td>
				</tr>
			</xsl:if>

			<!-- PUBLISHER/RECORD CO. dc.publisher.digital -->
			<xsl:if test="dim:field[@element='publisher' and @qualifier='digital']">
				<tr class="ds-table-row odd">
					<td><span class="bold">Publisher/Record Co.: </span></td>
					<td>
						<xsl:for-each select="dim:field[@element='publisher' and @qualifier='digital']">
							<xsl:value-of select="./node()"/>
							<xsl:if test="count(following-sibling::dim:field[@element='publisher' and @qualifier='digital']) != 0">
								<xsl:text>; </xsl:text>
							</xsl:if>
						</xsl:for-each>
					</td>
				</tr>
			</xsl:if>

			<!-- DATE OF RELEASE dc.date.issued -->
            <xsl:if test="dim:field[@element='date' and @qualifier='issued']">
				<tr class="ds-table-row even">
					<td><span class="bold">Date of Release: </span></td>
					<td>
						<xsl:for-each select="dim:field[@element='date' and @qualifier='issued']">
							<!-- JRD 2/2009 Changed date substring to innclude more characters than default (10) iso8601 to allow for Text-based dates -->
							<xsl:copy-of select="substring(./node(),1)"/>
							<xsl:if test="count(following-sibling::dim:field[@element='date' and @qualifier='issued']) != 0">
								<br/>
							</xsl:if>
						</xsl:for-each>
					</td>
				</tr>
            </xsl:if>

			<!-- ALBUM IDENTIFICATION dc.identifier.naxos -->
			<xsl:if test="dim:field[@element='identifier' and @qualifier='naxos']">
				<tr class="ds-table-row odd">
					<td><span class="bold">Album Identification: </span></td>
					<td>
						<xsl:for-each select="dim:field[@element='identifier' and @qualifier='naxos']">
							<xsl:value-of select="./node()"/>
							<xsl:if test="count(following-sibling::dim:field[@element='identifier' and @qualifier='naxos']) != 0">
								<xsl:text>; </xsl:text>
							</xsl:if>
						</xsl:for-each>
					</td>
				</tr>
			</xsl:if>

            <!-- xsl:if test="dim:field[@element='contributor'][@qualifier='author'] or dim:field[@element='creator'] or dim:field[@element='contributor']">
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
            </xsl:if> -->

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

            <!-- dc.identifier.uri -->
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

        </table>
    </xsl:template>









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

        <!-- Then we resolve the reference tag to an external mets object --> 
    <xsl:template match="dri:reference" mode="summaryList">
        <xsl:variable name="externalMetadataURL">
            <xsl:text>cocoon:/</xsl:text>
            <xsl:value-of select="@url"/>
            <!-- Since this is a summary only grab the descriptive metadata, and the thumbnails -->
            <xsl:text>?sections=dmdSec,fileSec&amp;fileGrpTypes=FILMSTRIPTHUMB,THUMBNAIL</xsl:text>
            <!-- An example of requesting a specific metadata standard (MODS and QDC crosswalks only work for items)->
            <xsl:if test="@type='DSpace Item'">
                <xsl:text>&amp;dmdTypes=DC</xsl:text>
            </xsl:if>-->
        </xsl:variable>
        <xsl:comment> External Metadata URL: <xsl:value-of select="$externalMetadataURL"/> </xsl:comment>
        <li>
            <xsl:attribute name="class">
                <xsl:text>ds-artifact-item </xsl:text>
                <xsl:choose>
                    <xsl:when test="position() mod 2 = 0">even</xsl:when>
                    <xsl:otherwise>odd</xsl:otherwise>
                </xsl:choose>
            </xsl:attribute>
		    <xsl:if test=".//dri:referenceSet">
	        	<!-- NB this has to start as open for noscript compatibility, the script will set all open to closed on load -->
	        	<xsl:attribute name="state">
         			<xsl:text>open</xsl:text>
	            </xsl:attribute>
	        </xsl:if>
            <span>
				<span class="bullet">
				    <xsl:if test=".//dri:referenceSet">
			    		<xsl:attribute name="onclick">
    		    		    <xsl:text>toggleState(this.parentNode.parentNode)</xsl:text>
            			</xsl:attribute>
					</xsl:if>
					&#160; <!-- Some weird thing is going on with empty elements incorporating following elements, so I have to put something here -->
				</span>
            	<xsl:apply-templates select="document($externalMetadataURL)" mode="summaryList"/>
            </span>
            <xsl:apply-templates />
        </li>
    </xsl:template>

</xsl:stylesheet>
