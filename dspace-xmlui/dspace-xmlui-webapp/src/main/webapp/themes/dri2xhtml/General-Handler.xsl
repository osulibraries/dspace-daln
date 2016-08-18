<?xml version="1.0" encoding="UTF-8"?>

<!-- REVISION HISTORY  (Search for the following text to find the revisions) -->
<!-- HLU_090319 Suppress Original License listing if CC-LICENSE present, change "Original License" to "Deed of Gift" -->

<!--
  DS-METS-1.0.xsl

  Version: $Revision: 1.2 $
 
  Date: $Date: 2007/06/27 22:54:52 $
 
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
    Author: Alexey Maslov
    Description: This stylesheet contains templates to perform tasks associated with metadata visualization
        that are common to all handlers. This includes things like bitstream display and thumbnails.
    Version: Manakin-1.1 and up (basically, those version making use of the Virtual Object Store)
-->    

<xsl:stylesheet 
    xmlns:dri="http://di.tamu.edu/DRI/1.0/"
    xmlns:i18n="http://apache.org/cocoon/i18n/2.1"
    xmlns:mets="http://www.loc.gov/METS/"
    xmlns:xlink="http://www.w3.org/TR/xlink/"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0"
    xmlns="http://www.w3.org/1999/xhtml"
    exclude-result-prefixes="i18n dri mets xlink xsl">
    
    <xsl:output indent="yes"/>
    

    
    
    <!-- Generate the thunbnail, if present, from the file section -->
    <xsl:template match="mets:fileSec" mode="artifact-preview">
        <xsl:if test="mets:fileGrp[@USE='THUMBNAIL']">
            <div class="artifact-preview">
                <a href="{ancestor::mets:METS/@OBJID}">
                    <img alt="Thumbnail">
                        <xsl:attribute name="src">
                            <xsl:value-of select="mets:fileGrp[@USE='THUMBNAIL']/mets:file/mets:FLocat[@LOCTYPE='URL']/@xlink:href" />
                        </xsl:attribute>
                    </img>
                </a>
            </div>
        </xsl:if>
    </xsl:template>
    
    
    
    <!-- Generate the bitstream information from the file section -->
    <xsl:template match="mets:fileGrp[@USE='CONTENT']">
        <xsl:param name="context"/>
        <xsl:param name="primaryBitstream" select="-1"/>
        
        <h2><i18n:text>xmlui.dri2xhtml.METS-1.0.item-files-head</i18n:text></h2>
        <table class="ds-table file-list">
            <tr class="ds-table-header-row">
                <th><i18n:text>xmlui.dri2xhtml.METS-1.0.item-files-file</i18n:text></th>
                <th><i18n:text>xmlui.dri2xhtml.METS-1.0.item-files-size</i18n:text></th>
                <th><i18n:text>xmlui.dri2xhtml.METS-1.0.item-files-format</i18n:text></th>
                <th><i18n:text>xmlui.dri2xhtml.METS-1.0.item-files-view</i18n:text></th>
            </tr>
            <xsl:choose>
                <!-- If one exists and it's of text/html MIME type, only display the primary bitstream -->
                <xsl:when test="mets:file[@ID=$primaryBitstream]/@MIMETYPE='text/html'">
                    <xsl:apply-templates select="mets:file[@ID=$primaryBitstream]">
                        <xsl:with-param name="context" select="$context"/>
                    </xsl:apply-templates>
                </xsl:when>
                <!-- Otherwise, iterate over and display all of them -->
                <xsl:otherwise>
                    <xsl:apply-templates select="mets:file">
                     	<xsl:sort data-type="number" select="boolean(./@ID=$primaryBitstream)" order="descending" />
                        <xsl:sort select="mets:FLocat[@LOCTYPE='URL']/@xlink:title"/> 
                        <xsl:with-param name="context" select="$context"/>
                    </xsl:apply-templates>
                </xsl:otherwise>
            </xsl:choose>
        </table>
    </xsl:template>   
    
    
    <!-- Build a single row in the bitsreams table of the item view page -->
    <xsl:template match="mets:file">
        <xsl:param name="context" select="."/>
        <tr>
            <xsl:attribute name="class">
                <xsl:text>ds-table-row </xsl:text>
                <xsl:if test="(position() mod 2 = 0)">even </xsl:if>
                <xsl:if test="(position() mod 2 = 1)">odd </xsl:if>
            </xsl:attribute>
            <td>
                <a>
                    <xsl:attribute name="href">
                        <xsl:value-of select="mets:FLocat[@LOCTYPE='URL']/@xlink:href"/>
                    </xsl:attribute>
                    <xsl:attribute name="title">
                        <xsl:value-of select="mets:FLocat[@LOCTYPE='URL']/@xlink:title"/>
                    </xsl:attribute>
                    <xsl:choose>
                        <xsl:when test="string-length(mets:FLocat[@LOCTYPE='URL']/@xlink:title) > 50">
                            <xsl:variable name="title_length" select="string-length(mets:FLocat[@LOCTYPE='URL']/@xlink:title)"/>
                            <xsl:value-of select="substring(mets:FLocat[@LOCTYPE='URL']/@xlink:title,1,15)"/>
                            <xsl:text> ... </xsl:text>
                            <xsl:value-of select="substring(mets:FLocat[@LOCTYPE='URL']/@xlink:title,$title_length - 25,$title_length)"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="mets:FLocat[@LOCTYPE='URL']/@xlink:title"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </a>
            </td>
            <!-- File size always comes in bytes and thus needs conversion --> 
            <td>
                <xsl:choose>
                    <xsl:when test="@SIZE &lt; 1000">
                        <xsl:value-of select="@SIZE"/>
                        <i18n:text>xmlui.dri2xhtml.METS-1.0.size-bytes</i18n:text>
                    </xsl:when>
                    <xsl:when test="@SIZE &lt; 1000000">
                        <xsl:value-of select="substring(string(@SIZE div 1000),1,5)"/>
                        <i18n:text>xmlui.dri2xhtml.METS-1.0.size-kilobytes</i18n:text>
                    </xsl:when>
                    <xsl:when test="@SIZE &lt; 1000000000">
                        <xsl:value-of select="substring(string(@SIZE div 1000000),1,5)"/>
                        <i18n:text>xmlui.dri2xhtml.METS-1.0.size-megabytes</i18n:text>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="substring(string(@SIZE div 1000000000),1,5)"/>
                        <i18n:text>xmlui.dri2xhtml.METS-1.0.size-gigabytes</i18n:text>
                    </xsl:otherwise>
                </xsl:choose>
            </td>
            <!-- Currently format carries forward the mime type. In the original DSpace, this 
                would get resolved to an application via the Bitstream Registry, but we are
                constrained by the capabilities of METS and can't really pass that info through. -->
            <td><xsl:value-of select="substring-before(@MIMETYPE,'/')"/>
                <xsl:text>/</xsl:text>
                <xsl:value-of select="substring-after(@MIMETYPE,'/')"/>
            </td>
            <td>
                <xsl:choose>
                    <xsl:when test="$context/mets:fileSec/mets:fileGrp[@USE='THUMBNAIL']/
                        mets:file[@GROUPID=current()/@GROUPID]">
                        <a class="image-link">
                            <xsl:attribute name="href">
                                <xsl:value-of select="mets:FLocat[@LOCTYPE='URL']/@xlink:href"/>
                            </xsl:attribute>
                            <img alt="Thumbnail">
                                <xsl:attribute name="src">
                                    <xsl:value-of select="$context/mets:fileSec/mets:fileGrp[@USE='THUMBNAIL']/
                                        mets:file[@GROUPID=current()/@GROUPID]/mets:FLocat[@LOCTYPE='URL']/@xlink:href"/>
                                </xsl:attribute>
                            </img>
                        </a>
                    </xsl:when>
                    <xsl:otherwise>
                        <a>
                            <xsl:attribute name="href">
                                <xsl:value-of select="mets:FLocat[@LOCTYPE='URL']/@xlink:href"/>
                            </xsl:attribute>
                            <i18n:text>xmlui.dri2xhtml.METS-1.0.item-files-viewOpen</i18n:text>
                        </a>
                    </xsl:otherwise>
                </xsl:choose>                        
            </td>
        </tr>
    </xsl:template>
    
    
    <!-- Generate the license information from the file section -->
    <!-- HLU_090319 Suppress Original License listing if CC-LICENSE present, change "Original License" to "Deed of Gift" -->
    <!-- Match to CC-LICENSE or LICENSE; if CC-LICENCE, simply provide link to CC-License; if LICENSE, test for presence -->
    <!-- of CC-LICENSE and, if present, do nothing; otherwise, provide link for Deed of Gift.                            -->
    
    <xsl:template match="mets:fileGrp[@USE='CC-LICENSE' or @USE='LICENSE']">
        <xsl:if test="@USE='CC-LICENSE'">
            <div class="license-info">
                <h3><i18n:text>xmlui.dri2xhtml.METS-1.0.license-text</i18n:text></h3>
                 <p>This item is available for use/reuse/remix according to the terms of the Creative
                    Common's license listed below. Clicking on the link below will display a URL you
                    can follow to view the terms of the license. Typically, Creative Commons
                    licenses require that you acknowledge the original creator. They may also
                    stipulate other restrictions on reuse.
                </p>
               <ul>
                    <li><a href="{mets:file/mets:FLocat[@xlink:title='license_url']/@xlink:href}">Creative Commons</a></li>
                </ul>
            </div>
        </xsl:if>
        <xsl:if test="@USE='LICENSE'">
            <xsl:choose>
                <xsl:when test="../mets:fileGrp[@USE='CC-LICENSE']"/>
                <xsl:otherwise>
                    <div class="license-info">
                        <h3><i18n:text>xmlui.dri2xhtml.METS-1.0.license-text</i18n:text></h3>
                        <p>If no Creative Commons license notice appears in the description
                            of this narrative, it is covered by a deed of gift and is available for use/reuse/remix as long as the DALN and the
                            original creator(s) are acknowledged, along with information allowing
                            end users to access the original narrative. Citations should include the
                            full name of the Digital Archive of Literacy Narratives, the name of the
                            original composer (or “anonymous,” if applicable) the title of the
                            narrative, and the DALN URL for the narrative (e.g.,
                            http://daln.osu.edu/handle/2374.DALN/151).</p>
                        <ul>
                            <li><a href="{mets:file/mets:FLocat[@xlink:title='license.txt']/@xlink:href}">Deed of Gift</a></li>  
                        </ul>
                    </div>
                </xsl:otherwise>    
            </xsl:choose>
        </xsl:if>
    </xsl:template>
    
    
    <!-- Generate the logo, if present, from the file section -->
    <xsl:template match="mets:fileGrp[@USE='LOGO']">
        <div class="ds-logo-wrapper">
            <img src="{mets:file/mets:FLocat[@LOCTYPE='URL']/@xlink:href}" class="logo">
                <xsl:attribute name="alt">xmlui.dri2xhtml.METS-1.0.collection-logo-alt</xsl:attribute>
                <xsl:attribute name="attr" namespace="http://apache.org/cocoon/i18n/2.1">alt</xsl:attribute>
            </img>
        </div>
    </xsl:template>
    
    
</xsl:stylesheet>
