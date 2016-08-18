<xsl:stylesheet
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    version="1.0">
    
    <!-- match the whole TEI document (i.e. '/') 
      and process the tags inside-->
    <xsl:template match="/">
        <html>
            <xsl:apply-templates/>
        </html>
    </xsl:template>
    
    <!-- but ignore the <teiHeader> 
      (only process the <text> element) -->
    <xsl:template match="TEI.2">
       <xsl:apply-templates select="text"/>
     </xsl:template>

 <!-- and do the <front> and <body> separately -->
    <xsl:template match="text">
        <!-- put front matter here -->
        <xsl:apply-templates select="front"/>
        <!-- body matter here -->
        <xsl:apply-templates select="body"/>
    </xsl:template>

   <!-- add template for paragraphs, divs, and headers -->
    <xsl:template match="p">
        <p><xsl:apply-templates/></p>
    </xsl:template>
    
    <xsl:template match="div">
        <div>
           <h2><xsl:value-of select="head"/></h2>
           <xsl:apply-templates/>
        </div>
    </xsl:template>
	
	<xsl:template match="head">
		<p class="tei-head">
			<xsl:apply-templates/>	
		</p>
	</xsl:template>
	
    <!-- lg -->
    <xsl:template match="lg">
    	<ul class="tei-lg">
    		<xsl:apply-templates/>
    	</ul>
    </xsl:template>
	
	<xsl:template match="l">
		<li class="tei-l">
			<xsl:apply-templates/>
		</li>
	</xsl:template>

<!-- output  lists -->
    <xsl:template match="list">
        <xsl:choose>
            <xsl:when test="@type='ordered'">
                <ol class="tei-list"><xsl:apply-templates/></ol>
            </xsl:when>
            <xsl:when test="@type='unordered'"> 
            	<ul class="tei-list"><xsl:apply-templates/></ul>
            </xsl:when>
            <xsl:when test="@type='gloss'">
                <dl><xsl:apply-templates/></dl>
            </xsl:when>
        </xsl:choose>
    </xsl:template>
    
    <!-- list items are simple -->
    <xsl:template match="item">
        <li class="tei-item"><xsl:apply-templates/></li>
    </xsl:template>
	
	<!-- del -->
	<xsl:template match="del">
		<span class="tei-del"><xsl:apply-templates/></span>
	</xsl:template>
	
	<!-- supplied -->
	<xsl:template match="supplied">
		<span class="tei-supplied"><xsl:apply-templates/></span>
	</xsl:template>

</xsl:stylesheet>
