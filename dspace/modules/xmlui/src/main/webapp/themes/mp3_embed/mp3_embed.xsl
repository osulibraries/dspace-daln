<?xml version="1.0" encoding="UTF-8"?>

<!--
  mp3_enbed.xsl

  Theme for embedding mp3 players into summary view for items containing mp3 files.
-->

<!--
   OhioLINK mp3 embed theme. 
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
    
    <xsl:import href="../dri2xhtml.xsl"/>

    <!-- importing federated search templates in this theme.
         
         Required so that "search DRC" action from Kent State Oral Histories
         uses federated search.

         Currently only OhioLINK themes on main DRC incorporate
         the MP3 embed theme. This import may need to be undone later
         if themes which do not use federated search but use MP3 embed are added
         later. 
    -->
    <xsl:import href="../fedsearch/fedsearch.xsl" />
    <xsl:output indent="yes"/>
    
    

<!-- An item rendered in the summaryView pattern. This is the default way to view a DSpace item in Manakin. 
     KRG 2008-10-29 Check for the audio/mpeg filetype, and if found, embed the movie in the itemSummary page
     using the mp3 player tool. 
-->
 <xsl:template name="itemSummaryView-DIM">
   <!-- if there are mp3 files in this item, embed a player (or two) on the page
          Uses the neolao player found at http://flash-mp3-player.net
     -->
    <xsl:if test="./mets:fileSec/mets:fileGrp[@USE='CONTENT']/mets:file[@MIMETYPE='audio/mpeg']">
      <hr/>
      <h2>Listen</h2>
      <table>
        <xsl:for-each select="./mets:fileSec/mets:fileGrp[@USE='CONTENT']/mets:file[@MIMETYPE='audio/mpeg']">
        <tr>
          <th>
            <xsl:value-of select="./mets:FLocat[@LOCTYPE='URL']/@xlink:title" />
          </th>
        </tr>
        <tr>
          <td>
            <object type="application/x-shockwave-flash" data="/themes/mp3_embed/lib/player_mp3_maxi.swf" width="200" height="20">
              <param name="movie" value="/themes/mp3_embed/lib/player_mp3_maxi.swf" />
              <param name="FlashVars" value="mp3={./mets:FLocat[@LOCTYPE='URL']/@xlink:href}&amp;showvolume=1" />
            </object>
          </td>
        </tr>
        </xsl:for-each>
      </table>
      <hr/>
      <br />
    </xsl:if>

        <!-- Generate the info about the item from the metadata section -->
        <xsl:apply-templates select="./mets:dmdSec/mets:mdWrap[@OTHERMDTYPE='DIM']/mets:xmlData/dim:dim"
        mode="itemSummaryView-DIM"/>

        <!-- Generate the bitstream information from the file section -->
        <xsl:choose>
                <xsl:when test="not(./mets:fileSec/mets:fileGrp[@USE='CONTENT'])">
                <h2><xsl:text>Audio Files</xsl:text></h2>
                 <table class="ds-table file-list">
                    <tr class="ds-table-header-row">
                        <th><i18n:text>xmlui.dri2xhtml.METS-1.0.item-files-file</i18n:text></th>
                        <th><i18n:text>xmlui.dri2xhtml.METS-1.0.item-files-size</i18n:text></th>
                        <th><i18n:text>xmlui.dri2xhtml.METS-1.0.item-files-format</i18n:text></th>
                        <th><xsl:text>Listen</xsl:text></th>
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
                            <xsl:with-param name="primaryBitstream" select="./mets:structMap[@TYPE='LOGICAL']/mets:div[@TYPE='DSpace Item']/mets:fptr/@FILEID
"/>
                        </xsl:apply-templates>
                </xsl:otherwise>
        </xsl:choose>

        <!-- Add display for extra html file-->
        <xsl:apply-templates select="./mets:fileSec/mets:fileGrp[@USE='METADATA']">
            <xsl:with-param name="context" select="."/>
        </xsl:apply-templates>

        <!-- Generate the license information from the file section -->
        <xsl:apply-templates select="./mets:fileSec/mets:fileGrp[@USE='CC-LICENSE' or @USE='LICENSE']"/>

    </xsl:template>
 
 
</xsl:stylesheet>
