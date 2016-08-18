<?xml version="1.0" encoding="UTF-8"?>

<!--
    TT.xsl
    
    Version: $Revision: 1.1 $
    
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
    xmlns:mods="http://www.loc.gov/mods/v3"
    xmlns:dc="http://purl.org/dc/elements/1.1/"
    xmlns:dcterms="http://purl.org/dc/terms/"
    xmlns:dim="http://www.dspace.org/xmlns/dspace/dim" 
    xmlns:xlink="http://www.w3.org/TR/xlink/"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
    
    <xsl:import href="../dri2xhtml.xsl"/>
    <xsl:output indent="yes"/>
    
    
    <!-- Right now this theme is not functional and is instead a place to store the code snippets from
        what used to be the pioneer model and its application to tabular summaryView of items. Since we
        are going to a full list model for everything else, the pioneer is being pulled from both the
        structural.xsl and the three metadata handlers (DIM, MODS, QDC).  
        
        This theme will be model's resting place. It will override structural.xsl to include a plug
        to the "pioneer" object, and it will also override the metadata handlers to provide the table
        layout (like in the original DSpace). As such it will serve as a good example of theme extensions
        while providing people with a feature they are likely to want. -->
    
    
     <!-- First off, we declare global variables to point to object and repository metadata directly. -->
    <xsl:variable name="objects" select="/dri:document/dri:meta/dri:objectMeta"/>
    <xsl:variable name="repository" select="/dri:document/dri:meta/dri:repositoryMeta"/>
    
    <!-- Summarylist case. This template just like the ones for the other three cases applies templates to
        the "pioneer" object (the first object in the set) that figures out what to do. --> 
    <xsl:template match="dri:includeSet[@type = 'summaryList']" priority="2">
        <xsl:apply-templates select="dri:head"/>
        <xsl:apply-templates select="$objects/dri:object[@objectIdentifier= current()/dri:objectInclude[1]/@objectSource]" mode="summaryListPioneer">
            <xsl:with-param name="contents" select="*[not(name()='head')]"/>
        </xsl:apply-templates>            
    </xsl:template>
    
    
    
    
    
    <!-- MODS -->
    
    <!-- The pioneer object is resolved from an objectInclude by the template above and its template is applied
        with the summaryListPioneer mode. Since an object generally has only one profile associated with it, 
        templates that handle other profiles can simply be added to the mix without having to override 
        anything. -->
    <!-- So this particular match statement matches all the objects in the repository that conform to the DSpace
        METS profile, as matched for in the key. Another way to say the same thing would be:
    <xsl:template match="dri:object[mets:METS[@PROFILE='DSPACE METS SIP Profile 1.0' or @PROFILE=
        'DSPACE METS SIP Profile 1.0 (with DRI Community / Collection additions)']]" mode="summaryListPioneer">-->
    <xsl:template match="key('DSMets1.0-all', 'all')" mode="summaryListPioneer">
    <!--<xsl:template match="dri:object[count(key('DSMets1.0', @objectIdentifier))>0]" mode="summaryListPioneer">-->
        <xsl:param name="contents"/>
        <!-- Check to determine is the case we are dealing with is an item list, which should be displayed as a
            table, or a some other case which should be handled generically via list paradigm. -->
        <xsl:choose>
            <!-- Check to see if the number of sibling tags is equal to the number of sibling tags that refer to 
                an object that has a specific METS profile and is a DSpace item according to it. If anything at
                all fails, then the case is not matched and we roll over to the next one. Right now, the only
                choices for the summaryList are the table setup and other (the list model). If you want to add
                cases, or change how the summaryList item case is handled, you should overide this template.-->
            <xsl:when test="count($contents) = count( key('DSMets1.0-all', 'all')[@objectIdentifier = $contents/@objectSource]
                [mets:METS/mets:structMap/mets:div[@TYPE='DSpace Item']] )">
            <!-- <xsl:when test="count($contents) = 
                count($objects/dri:object[@objectIdentifier = $contents/@objectSource][mets:METS[@PROFILE='DSPACE METS SIP Profile 1.0'
                or @PROFILE='DSPACE METS SIP Profile 1.0 (with DRI Community / Collection additions)']/mets:structMap/mets:div[@TYPE='DSpace Item']])">-->
                <table class="ds-includeSet-table"> 
                    <tr class="ds-table-header-row">
                        <th><i18n:text>xmlui.dri2xhtml.pioneer.preview</i18n:text></th>
                        <th><i18n:text>xmlui.dri2xhtml.pioneer.date</i18n:text></th>
                        <th><i18n:text>xmlui.dri2xhtml.pioneer.title</i18n:text></th>
                        <th><i18n:text>xmlui.dri2xhtml.pioneer.author</i18n:text></th>
                    </tr>
                    <!--<xsl:apply-templates select="$objects/dri:object[@objectIdentifier= $contents/@objectSource]" mode="itemSummaryListTable"/>-->
                    <xsl:apply-templates select="$contents" mode="itemSummaryListTable"/>
                </table>
            </xsl:when>
            <xsl:otherwise>
                <ul class="ds-includeSet-list">
                    <xsl:apply-templates select="$contents" mode="summaryList"/>
                </ul>
            </xsl:otherwise>
        </xsl:choose>        
    </xsl:template>
    
    <!-- If the pioneer of a summaryList resolves its siblings and verifies they are all DSpace items (or, if
        the template was overidden, fulfills whatever new requirements) it applies their templates with a 
        special mode. The objectInclude's that match this mode already "know" they are items in a summary list and 
        thus turn themselves into table rows. If you plan on overriding the structural handing of items in 
        summary lists this is the other template you need to override. -->
    <xsl:template match="dri:objectInclude[key('DSMets1.0', @objectSource)]" mode="itemSummaryListTable">
        <tr>
            <xsl:attribute name="class">
                <xsl:text>ds-table-row </xsl:text>
                <xsl:if test="(position() mod 2 = 0)">even </xsl:if>
                <xsl:if test="(position() mod 2 = 1)">odd </xsl:if>
            </xsl:attribute>
            <xsl:apply-templates select="key('DSMets1.0', @objectSource)" mode="itemSummaryListTable"/>
            <xsl:apply-templates />
        </tr>
    </xsl:template>
    
    <!-- The template that does the actual processing of the object. In the case of the item table, this 
        template the "pioneer" one are closely tied (since one sets the columns and headers that the other has
        to use), which means you will most likely need to override both templates when making changes. --> 
    <xsl:template match="key('DSMets1.0-all', 'all')" mode="itemSummaryListTable">
        <xsl:variable name="data" select="mets:METS/mets:dmdSec/mets:mdWrap/mets:xmlData/mods:mods"/>
        <td class="first-cell">
            <xsl:choose>
                <xsl:when test="mets:METS/mets:fileSec/mets:fileGrp[@USE='THUMBNAIL']">
                    <a class="image-link">
                        <!-- The long way, the shorter way, and the simple way to reference an item... 
                            <xsl:attribute name="href"><xsl:value-of select=".//mets:file[@ID = current()/mets:div/mets:fptr/@FILEID]/mets:FLocat[@LOCTYPE='URL']/@xlink:href"/></xsl:attribute>
                            <xsl:attribute name="href"><xsl:value-of select="./@url"/></xsl:attribute> -->
                        <xsl:attribute name="href"><xsl:value-of select="@url"/></xsl:attribute>
                        <img alt="Thumbnail">
                            <xsl:attribute name="src">
                                <xsl:value-of select="mets:METS/mets:fileSec/mets:fileGrp[@USE='THUMBNAIL']/
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
        <td>
            <xsl:copy-of select="substring($data/mods:originInfo/mods:dateIssued[@encoding='iso8601']/child::node(),1,10)"/>
        </td>
        <td>
            <a>
                <xsl:attribute name="href"><xsl:value-of select="@url"/></xsl:attribute>
                <xsl:choose>
                    <xsl:when test="$data/mods:titleInfo/mods:title">
                        <xsl:copy-of select="$data/mods:titleInfo/mods:title[1]/child::node()"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <i18n:text>xmlui.dri2xhtml.METS-1.0.no-title</i18n:text>
                    </xsl:otherwise>
                </xsl:choose>
            </a>
        </td>
        <td>
            <xsl:copy-of select="$data/mods:name[mods:role/mods:roleTerm/text()='author']/mods:namePart/child::node()"/>
        </td>
    </xsl:template>
    
    
    
    
    <!-- DIM -->
    
    <!-- The pioneer object is resolved from an objectInclude by the template above and its template is applied
        with the summaryListPioneer mode. Since an object generally has only one profile associated with it, 
        templates that handle other profiles can simply be added to the mix without having to override 
        anything. -->
    <!-- So this particular match statement matches all the objects in the repository that conform to the DSpace
        METS profile, as matched for in the key. Another way to say the same thing would be:
    <xsl:template match="dri:object[mets:METS[@PROFILE='DSPACE METS SIP Profile 1.0' or @PROFILE=
        'DSPACE METS SIP Profile 1.0 (with DRI Community / Collection additions)']]" mode="summaryListPioneer">-->
    <xsl:template match="key('DSMets1.0-DIM-all', 'all')" mode="summaryListPioneer">
    <!--<xsl:template match="dri:object[count(key('DSMets1.0-DIM', @objectIdentifier))>0]" mode="summaryListPioneer">-->
        <xsl:param name="contents"/>
        <!-- Check to determine is the case we are dealing with is an item list, which should be displayed as a
            table, or a some other case which should be handled generically via list paradigm. -->
        <xsl:choose>
            <!-- Check to see if the number of sibling tags is equal to the number of sibling tags that refer to 
                an object that has a specific METS profile and is a DSpace item according to it. If anything at
                all fails, then the case is not matched and we roll over to the next one. Right now, the only
                choices for the summaryList are the table setup and other (the list model). If you want to add
                cases, or change how the summaryList item case is handled, you should overide this template.-->
            <xsl:when test="count($contents) = count( key('DSMets1.0-DIM-all', 'all')[@objectIdentifier = $contents/@objectSource]
                [mets:METS/mets:structMap/mets:div[@TYPE='DSpace Item']] )">
            <!-- <xsl:when test="count($contents) = 
                count($objects/dri:object[@objectIdentifier = $contents/@objectSource][mets:METS[@PROFILE='DSPACE METS SIP Profile 1.0'
                or @PROFILE='DSPACE METS SIP Profile 1.0 (with DRI Community / Collection additions)']/mets:structMap/mets:div[@TYPE='DSpace Item']])">-->
                <table class="ds-includeSet-table"> 
                    <tr class="ds-table-header-row">
                        <th><i18n:text>xmlui.dri2xhtml.pioneer.preview</i18n:text></th>
                        <th><i18n:text>xmlui.dri2xhtml.pioneer.date</i18n:text></th>
                        <th><i18n:text>xmlui.dri2xhtml.pioneer.title</i18n:text></th>
                        <th><i18n:text>xmlui.dri2xhtml.pioneer.author</i18n:text></th>
                    </tr>
                    <!--<xsl:apply-templates select="$objects/dri:object[@objectIdentifier= $contents/@objectSource]" mode="itemSummaryListTable"/>-->
                    <xsl:apply-templates select="$contents" mode="itemSummaryListTable"/>
                </table>
            </xsl:when>
            <xsl:otherwise>
                <ul class="ds-includeSet-list">
                    <xsl:apply-templates select="$contents" mode="summaryList"/>
                </ul>
            </xsl:otherwise>
        </xsl:choose>        
    </xsl:template>
    
    <!-- If the pioneer of a summaryList resolves its siblings and verifies they are all DSpace items (or, if
        the template was overidden, fulfills whatever new requirements) it applies their templates with a 
        special mode. objectIncludes that match this mode already "know" they are items in a summary list and 
        thus turn themselves into table rows. If you plan on overriding the structural handing of items in 
        summary lists this is the other template you need to override. -->
    <xsl:template match="dri:objectInclude[key('DSMets1.0-DIM', @objectSource)]" mode="itemSummaryListTable">
        <tr>
            <xsl:attribute name="class">
                <xsl:text>ds-table-row </xsl:text>
                <xsl:if test="(position() mod 2 = 0)">even </xsl:if>
                <xsl:if test="(position() mod 2 = 1)">odd </xsl:if>
            </xsl:attribute>
            <xsl:apply-templates select="key('DSMets1.0-DIM', @objectSource)" mode="itemSummaryListTable"/>
            <xsl:apply-templates />
        </tr>
    </xsl:template>
    
    <!-- The template that does the actual processing of the object. In the case of the item table, this 
        template the "pioneer" one are closely tied (since one sets the columns and headers that the other has
        to use), which means you will most likely need to override both templates when making changes. --> 
    <xsl:template match="key('DSMets1.0-DIM-all', 'all')" mode="itemSummaryListTable">
        <xsl:variable name="data" select="mets:METS/mets:dmdSec/mets:mdWrap/mets:xmlData/dim:dim"/>
        <td class="first-cell">
            <xsl:choose>
                <xsl:when test="mets:METS/mets:fileSec/mets:fileGrp[@USE='THUMBNAIL']">
                    <a class="image-link">
                        <!-- The long way, the shorter way, and the simple way to reference an item... 
                            <xsl:attribute name="href"><xsl:value-of select=".//mets:file[@ID = current()/mets:div/mets:fptr/@FILEID]/mets:FLocat[@LOCTYPE='URL']/@xlink:href"/></xsl:attribute>
                            <xsl:attribute name="href"><xsl:value-of select="./@url"/></xsl:attribute> -->
                        <xsl:attribute name="href"><xsl:value-of select="@url"/></xsl:attribute>
                        <img alt="Thumbnail">
                            <xsl:attribute name="src">
                                <xsl:value-of select="mets:METS/mets:fileSec/mets:fileGrp[@USE='THUMBNAIL']/
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
        <td>
            <xsl:copy-of select="substring($data/dim:field[@element='date' and @qualifier='issued']/child::node(),1,10)"/>
        </td>
        <td>
            <a>
                <xsl:attribute name="href"><xsl:value-of select="@url"/></xsl:attribute>
                <xsl:choose>
                    <xsl:when test="$data/dim:field[@element='title']">
                        <xsl:copy-of select="$data/dim:field[@element='title'][1]/child::node()"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <i18n:text>xmlui.dri2xhtml.METS-1.0.no-title</i18n:text>
                    </xsl:otherwise>
                </xsl:choose>
            </a>
        </td>
        <td>
            <xsl:copy-of select="$data/dim:field[@element='contributor'][1]/child::node()"/>
        </td>
    </xsl:template>
    
    
    
    
    <!-- QDC -->
    
    <!-- The pioneer object is resolved from an objectInclude by the template above and its template is applied
        with the summaryListPioneer mode. Since an object generally has only one profile associated with it, 
        templates that handle other profiles can simply be added to the mix without having to override 
        anything. -->
    <!-- So this particular match statement matches all the objects in the repository that conform to the DSpace
        METS profile, as matched for in the key. Another way to say the same thing would be:
    <xsl:template match="dri:object[mets:METS[@PROFILE='DSPACE METS SIP Profile 1.0' or @PROFILE=
        'DSPACE METS SIP Profile 1.0 (with DRI Community / Collection additions)']]" mode="summaryListPioneer">-->
    <xsl:template match="key('DSMets1.0-QDC-all', 'all')" mode="summaryListPioneer">
    <!--<xsl:template match="dri:object[count(key('DSMets1.0-QDC', @objectIdentifier))>0]" mode="summaryListPioneer">-->
        <xsl:param name="contents"/>
        <!-- Check to determine is the case we are dealing with is an item list, which should be displayed as a
            table, or a some other case which should be handled generically via list paradigm. -->
        <xsl:choose>
            <!-- Check to see if the number of sibling tags is equal to the number of sibling tags that refer to 
                an object that has a specific METS profile and is a DSpace item according to it. If anything at
                all fails, then the case is not matched and we roll over to the next one. Right now, the only
                choices for the summaryList are the table setup and other (the list model). If you want to add
                cases, or change how the summaryList item case is handled, you should overide this template.-->
            <xsl:when test="count($contents) = count( key('DSMets1.0-QDC-all', 'all')[@objectIdentifier = $contents/@objectSource]
                [mets:METS/mets:structMap/mets:div[@TYPE='DSpace Item']] )">
            <!-- <xsl:when test="count($contents) = 
                count($objects/dri:object[@objectIdentifier = $contents/@objectSource][mets:METS[@PROFILE='DSPACE METS SIP Profile 1.0'
                or @PROFILE='DSPACE METS SIP Profile 1.0 (with DRI Community / Collection additions)']/mets:structMap/mets:div[@TYPE='DSpace Item']])">-->
                <table class="ds-includeSet-table"> 
                    <tr class="ds-table-header-row">
                        <th><i18n:text>xmlui.dri2xhtml.pioneer.preview</i18n:text></th>
                        <th><i18n:text>xmlui.dri2xhtml.pioneer.date</i18n:text></th>
                        <th><i18n:text>xmlui.dri2xhtml.pioneer.title</i18n:text></th>
                        <th><i18n:text>xmlui.dri2xhtml.pioneer.author</i18n:text></th>
                    </tr>
                    <!--<xsl:apply-templates select="$objects/dri:object[@objectIdentifier= $contents/@objectSource]" mode="itemSummaryListTable"/>-->
                    <xsl:apply-templates select="$contents" mode="itemSummaryListTable"/>
                </table>
            </xsl:when>
            <xsl:otherwise>
                <ul class="ds-includeSet-list">
                    <xsl:apply-templates select="$contents" mode="summaryList"/>
                </ul>
            </xsl:otherwise>
        </xsl:choose>        
    </xsl:template>
    
    <!-- If the pioneer of a summaryList resolves its siblings and verifies they are all DSpace items (or, if
        the template was overidden, fulfills whatever new requirements) it applies their templates with a 
        special mode. objectIncludes that match this mode already "know" they are items in a summary list and 
        thus turn themselves into table rows. If you plan on overriding the structural handing of items in 
        summary lists this is the other template you need to override. -->
    <xsl:template match="dri:objectInclude[key('DSMets1.0-QDC', @objectSource)]" mode="itemSummaryListTable">
        <tr>
            <xsl:attribute name="class">
                <xsl:text>ds-table-row </xsl:text>
                <xsl:if test="(position() mod 2 = 0)">even </xsl:if>
                <xsl:if test="(position() mod 2 = 1)">odd </xsl:if>
            </xsl:attribute>
            <xsl:apply-templates select="key('DSMets1.0-QDC', @objectSource)" mode="itemSummaryListTable"/>
            <xsl:apply-templates />
        </tr>
    </xsl:template>
    
    <!-- The template that does the actual processing of the object. In the case of the item table, this 
        template the "pioneer" one are closely tied (since one sets the columns and headers that the other has
        to use), which means you will most likely need to override both templates when making changes. --> 
    <xsl:template match="key('DSMets1.0-QDC-all', 'all')" mode="itemSummaryListTable">
        <xsl:variable name="data" select="mets:METS/mets:dmdSec/mets:mdWrap/mets:xmlData/dcterms:qualifieddc"/>
        <td class="first-cell">
            <xsl:choose>
                <xsl:when test="mets:METS/mets:fileSec/mets:fileGrp[@USE='THUMBNAIL']">
                    <a class="image-link">
                        <!-- The long way, the shorter way, and the simple way to reference an item... 
                            <xsl:attribute name="href"><xsl:value-of select=".//mets:file[@ID = current()/mets:div/mets:fptr/@FILEID]/mets:FLocat[@LOCTYPE='URL']/@xlink:href"/></xsl:attribute>
                            <xsl:attribute name="href"><xsl:value-of select="./@url"/></xsl:attribute> -->
                        <xsl:attribute name="href"><xsl:value-of select="@url"/></xsl:attribute>
                        <img alt="Thumbnail">
                            <xsl:attribute name="src">
                                <xsl:value-of select="mets:METS/mets:fileSec/mets:fileGrp[@USE='THUMBNAIL']/
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
        <td>
            <xsl:copy-of select="substring($data/dcterms:issued/child::node(),1,10)"/>
        </td>
        <td>
            <a>
                <xsl:attribute name="href"><xsl:value-of select="@url"/></xsl:attribute>
                <xsl:choose>
                    <xsl:when test="$data/dc:title">
                        <xsl:copy-of select="$data/dc:title[1]/child::node()"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <i18n:text>xmlui.dri2xhtml.METS-1.0.no-title</i18n:text>
                    </xsl:otherwise>
                </xsl:choose>
            </a>
        </td>
        <td>
            <xsl:copy-of select="$data/dc:contributor[1]/child::node()"/>
        </td>
    </xsl:template>
    
    
    
    
    
    
</xsl:stylesheet>
