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
    <xsl:import href="../fedsearch/fedsearch.xsl" />

    <xsl:output indent="yes"/>
    
    <!-- Generate the info about the item from the metadata section 
         This template was customized for OhioLINK because OhioLINK
         does not use the description.abstract field, which caused
         two rows next to each other in the table to be the same color.
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
			            <xsl:if test="dim:field[@element='rights' and @qualifier='uri']">
	            <tr class="ds-table-row odd">
	                <td><span class="bold"><i18n:text>xmlui.dri2xhtml.METS-1.0.copyright</i18n:text>:</span></td>
	                <td>
	                	<xsl:for-each select="dim:field[@element='rights' and @qualifier='uri']">
		                    <a>
		                        <xsl:attribute name="href">
		                            <xsl:copy-of select="./node()"/>
		                        </xsl:attribute>
		                        <xsl:copy-of select="./node()"/>
		                    </a>
		                    <xsl:if test="count(following-sibling::dim:field[@element='rights' and @qualifier='uri']) != 0">
		                    	<br/>
		                    </xsl:if>
	                    </xsl:for-each>
	                </td>
	            </tr>
            </xsl:if>

        </table>
    </xsl:template>
    

    
</xsl:stylesheet>
