<?xml version="1.0" encoding="UTF-8"?>

<!--

Theme for Rutherford Hayes Center.


Customized with test social media widget from AddThis.com.

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

      <!-- 
        The summaryView display type; used to generate a near-complete view of the item involved. It is currently
        not applicable to communities and collections. 
    -->
    <xsl:template match="mets:METS[mets:dmdSec/mets:mdWrap[@OTHERMDTYPE='DIM']]" mode="summaryView">
        <xsl:choose>
            <xsl:when test="@LABEL='DSpace Item'">
                <!-- AddThis Button BEGIN -->
<a href="http://www.addthis.com/bookmark.php?v=250" onmouseover="return addthis_open(this, '', '[URL]', '[TITLE]')" onmouseout="addthis_close()" onclick="return addthis_sendto()"><img src="http://s7.addthis.com/static/btn/lg-share-en.gif" width="125" height="16" alt="Bookmark and Share" style="border:0; float:right;"/></a><script type="text/javascript" src="http://s7.addthis.com/js/250/addthis_widget.js?pub=xa-4a39535a0ebbaa6b">.</script>
<!-- AddThis Button END -->

                <xsl:call-template name="itemSummaryView-DIM"/>
            </xsl:when>
            <xsl:when test="@LABEL='DSpace Collection'">
                <xsl:call-template name="collectionSummaryView-DIM"/>
            </xsl:when>
            <xsl:when test="@LABEL='DSpace Community'">
                <xsl:call-template name="communitySummaryView-DIM"/>
            </xsl:when>
            <xsl:otherwise>
                <i18n:text>xmlui.dri2xhtml.METS-1.0.non-conformant</i18n:text>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
</xsl:stylesheet>
