<?xml version="1.0" encoding="UTF-8"?>

<!--
	bird_sounds.xsl
	
	A Manakin theme for the Borror Lab of Bioacoustics. 
	
	Date: 2008/09/10
	
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

	<xsl:import href="../DRC/template.xsl" />
        <xsl:import href="../mp3_embed/mp3_embed.xsl" />
        <xsl:import href="../fedsearch/fedsearch.xsl" />

   <!-- Generate the info about the item from the metadata section 
        Changed to display fields relevant to this collection
        Add  Borror Lab Logo
    KRG -->
    <xsl:template match="dim:dim" mode="itemSummaryView-DIM">
    <img src="/themes/bird_sounds/Borror.gif" style="float:right; clear:none;" /> 

    <table class="ds-includeSet-table" style="clear:none;" >
            <xsl:if test="dim:field[@element='ScientificName']">
              <tr class="ds-table-row odd">
                <td><span class="bold"><xsl:text>Scientific Name</xsl:text>:</span></td>
                <td><xsl:value-of select="dim:field[@element='ScientificName']"/></td> 
             </tr>
            </xsl:if>           
           <xsl:if test="dim:field[@element='Sex']">
              <tr class="ds-table-row even">
                <td><span class="bold"><xsl:text>Sex</xsl:text>:</span></td>
                <td><xsl:value-of select="dim:field[@element='Sex']"/></td>
             </tr>
            </xsl:if>

            <xsl:if test="dim:field[@element='coverage' and @qualifier='spatial']">
              <tr class="ds-table-row odd">
                <td><span class="bold"><xsl:text>Recording Location</xsl:text>:</span></td>
                <td><xsl:value-of select="dim:field[@element='coverage' and @qualifier='spatial']" /></td>
              </tr>
            </xsl:if>

            <xsl:if test="dim:field[@element='date' and @qualifier='created']">
                    <tr class="ds-table-row even">
                        <td><span class="bold"><xsl:text>Date Recorded</xsl:text>:</span></td>
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
           
            <xsl:if test="dim:field[@element='format' and @qualifier='extent']">
                    <tr class="ds-table-row odd">
                        <td><span class="bold"><xsl:text>Recording Length</xsl:text>:</span></td>
                        <td>
                                <xsl:for-each select="dim:field[@element='format' and @qualifier='extent']">
                                        <xsl:copy-of select="substring(.,1,string-length(.) -2 )"/>
                                        <xsl:text>:</xsl:text>
                                        <xsl:copy-of select="substring(.,string-length(.) - 1 )" />
                                <br/>
                                </xsl:for-each>
                        </td>
                    </tr>
            </xsl:if>
           
        </table>
    </xsl:template>


 <!-- Generate the bitstream information from the file section 
  Special template to generate table for extra html file -->
    <xsl:template match="mets:fileGrp[@USE='METADATA']">
        <xsl:param name="context"/>

        <h2><xsl:text>HTML Description</xsl:text></h2>
        <table class="ds-table file-list">
            <tr class="ds-table-header-row">
                <th><i18n:text>xmlui.dri2xhtml.METS-1.0.item-files-file</i18n:text></th>
                <th><i18n:text>xmlui.dri2xhtml.METS-1.0.item-files-size</i18n:text></th>
                <th><i18n:text>xmlui.dri2xhtml.METS-1.0.item-files-format</i18n:text></th>
                <th><xsl:text>View</xsl:text></th>
            </tr>
                <!-- If one exists and it's of text/html MIME type, only display the primary bitstream -->
                    <xsl:apply-templates select="mets:file">
                        <xsl:with-param name="context" select="$context"/>
                    </xsl:apply-templates>
        </table>
    </xsl:template>

  <!-- An item rendered in the detailView pattern, the "full item record" view of a DSpace item in Manakin.
   Added display for extra HTML file KRG
   -->
    <xsl:template name="itemDetailView-DIM">

        <!-- Output all of the metadata about the item from the metadata section -->
        <xsl:apply-templates select="mets:dmdSec/mets:mdWrap[@OTHERMDTYPE='DIM']/mets:xmlData/dim:dim"
            mode="itemDetailView-DIM" />
          
           <!-- below sort attempt not working  KRG  
           <xsl:sort select="dim:field/@mdschema" />
           <xsl:sort select="dim:field/@element" />
           <xsl:sort select="dim:field/@qualifier" />
           -->
            

                <!-- Generate the bitstream information from the file section -->
        <xsl:choose>
                <xsl:when test="not(./mets:fileSec/mets:fileGrp[@USE='CONTENT'])">
                <h2><xsl:text>Audio Files</xsl:text></h2>
                 <table class="ds-table file-list">
                    <tr class="ds-table-header-row">
                        <th><i18n:text>xmlui.dri2xhtml.METS-1.0.item-files-file</i18n:text></th>
                        <th><i18n:text>xmlui.dri2xhtml.METS-1.0.item-files-size</i18n:text></th>
                        <th><i18n:text>xmlui.dri2xhtml.METS-1.0.item-files-format</i18n:text></th>
                        <th><i18n:text>xmlui.dri2xhtml.METS-1.0.item-files-view</i18n:text></th>
                    </tr>
                    <tr>
                    <td colspan="4">
                        <p><i18n:text>xmlui.dri2xhtml.METS-1.0.item-no-files</i18n:text></p>
                        </td>
                        </tr>
                        </table>
                </xsl:when>
                <xsl:otherwise>
                        <xsl:apply-templates select="./mets:fileSec/mets:fileGrp[@USE='CONTENT']">
                            <xsl:with-param name="context" select="."/>
                            <xsl:with-param name="primaryBitstream" select="./mets:structMap[@TYPE='LOGICAL']/mets:div[@TYPE='DSpace Item']/mets:fptr/@FILEID"/>
                        </xsl:apply-templates>
                </xsl:otherwise>
        </xsl:choose>

         <!-- Add display for extra html file-->
        <xsl:apply-templates select="./mets:fileSec/mets:fileGrp[@USE='METADATA']">
            <xsl:with-param name="context" select="."/>
        </xsl:apply-templates>

 
        <!-- Generate the license information from the file section -->
        <xsl:apply-templates select="mets:fileSec/mets:fileGrp[@USE='CC-LICENSE' or @USE='LICENSE']" mode="itemSummaryView"/>

    </xsl:template>


    <!-- Generate the bitstream information from the file section 
     Changed View text to Listen - KRG
     Changed table header to Audio files --> 
     -->
    <xsl:template match="mets:fileGrp[@USE='CONTENT']">
        <xsl:param name="context"/>
        <xsl:param name="primaryBitstream" select="-1"/>

        <h2><xsl:text>Audio Files</xsl:text></h2>
        <table class="ds-table file-list">
            <tr class="ds-table-header-row">
                <th><i18n:text>xmlui.dri2xhtml.METS-1.0.item-files-file</i18n:text></th>
                <th><i18n:text>xmlui.dri2xhtml.METS-1.0.item-files-size</i18n:text></th>
                <th><i18n:text>xmlui.dri2xhtml.METS-1.0.item-files-format</i18n:text></th>
                <th><xsl:text>Listen</xsl:text></th>
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

  <!-- Build a single row in the bitsreams table of the item view page
   Changed view text to open KRG  -->
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
                        mets:file[@GROUP_ID=current()/@GROUP_ID]">
                        <a class="image-link">
                            <xsl:attribute name="href">
                                <xsl:value-of select="mets:FLocat[@LOCTYPE='URL']/@xlink:href"/>
                            </xsl:attribute>
                            <img alt="Thumbnail">
                                <xsl:attribute name="src">
                                    <xsl:value-of select="$context/mets:fileSec/mets:fileGrp[@USE='THUMBNAIL']/
                                        mets:file[@GROUP_ID=current()/@GROUP_ID]/mets:FLocat[@LOCTYPE='URL']/@xlink:href"/>
                                </xsl:attribute>
                            </img>
                        </a>
                    </xsl:when>
                    <xsl:otherwise>
                        <a>
                            <xsl:attribute name="href">
                                <xsl:value-of select="mets:FLocat[@LOCTYPE='URL']/@xlink:href"/>
                            </xsl:attribute>
                            <xsl:text>Open</xsl:text>
                        </a>
                    </xsl:otherwise>
                </xsl:choose>
            </td>
        </tr>
    </xsl:template>

</xsl:stylesheet>
