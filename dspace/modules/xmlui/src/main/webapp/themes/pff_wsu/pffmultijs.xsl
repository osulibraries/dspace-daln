<?xml version="1.0" encoding="UTF-8"?>

<!--

        pffmultijs.xsl

        Allows use of a drop-down chooser to select a different image
        to zoom in on with Zoomify image viewer.

        This approach requires that Javascript is enabled in the browser.

        This version has been customized to use the WSU theming.

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

	<xsl:import href="../WSU/template.xsl" />
	<xsl:output indent="yes" />


<!-- Below added for zoomify test KRG 2008-06-18 -->
<!-- An item rendered in the summaryView pattern. This is the default way to view a DSpace item in Manakin. 
     KRG 03/2008 Add ZOOM bundle for Zoomify images.
-->
    <xsl:template name="itemSummaryView-DIM">
			<!--	Call Zoom templates    -->
                        <xsl:apply-templates select="./mets:fileSec/mets:fileGrp[@USE='ZOOM']" />
                        
        <!-- Generate the info about the item from the metadata section -->
        <xsl:apply-templates select="./mets:dmdSec/mets:mdWrap[@OTHERMDTYPE='DIM']/mets:xmlData/dim:dim"
        mode="itemSummaryView-DIM"/>

        <!-- Generate the bitstream information from the file section -->
        <xsl:choose>
                <xsl:when test="not(./mets:fileSec/mets:fileGrp[@USE='CONTENT'])">
                <h2><i18n:text>xmlui.dri2xhtml.METS-1.0.item-files-head</i18n:text></h2>
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

        <!-- Generate the license information from the file section -->
        <xsl:apply-templates select="./mets:fileSec/mets:fileGrp[@USE='CC-LICENSE' or @USE='LICENSE']"/>


    </xsl:template>

 <!-- Generate PFF Zoomify  objects for images in the ZOOM bundle -->
    <!-- METS file ID will be in the form file_xxxx, where xxxx
        Is the DSPace bitstream ID.  The substring function is used to strip
        the 'file_' portion from the ID -->

    <xsl:template match="mets:fileGrp[@USE='ZOOM']">
      <div>
                <!-- KRG prototype test of getting file via bitstream id instead of relative path -->
<OBJECT  id="ZAS" codeBase="http://download.macromedia.com/pub/shockwave/cabs/flash/swflash.cab#version=6,0,0,0" height="395" width="590" align="center" classid="clsid:D27CDB6E-AE6D-11cf-96B8-444553540000">
<PARAM NAME="src" VALUE="/themes/pff_wsu/ZAS.swf" />
<PARAM NAME="quality" VALUE="high" />
<PARAM NAME="bgcolor" VALUE="#FFFFFF" />
<PARAM NAME="swliveconnect" VALUE="true" />
<PARAM NAME="FlashVars" VALUE="gDefaultLabelVisibility=1&#38;gServerIP=core.libraries.wright.edu&#38;gServerPort=80&#38;gByteHandlerPath=/ohiolink_zoom/dspacezoomifyServlet&#38;gImagePath={substring(mets:file[last()]/@ID,6)}.pff&#38;gMenuX=-1&#38;gPOIX=-1&#38;gLabelsX=-1&#38;gNavbarX=195&#38;gNavbarY=350&#38;gViewX=-1&#38;gConferenceX=-1&#38;gRulerX=200&#38;gSkipLogin=1" />
<EMBED name="ZAS" src="/themes/pff_wsu/ZAS.swf" FlashVars="gDefaultLabelVisibility=1&#38;gServerIP=core.libraries.wright.edu&#38;gServerPort=80&#38;gByteHandlerPath=/ohiolink_zoom/dspacezoomifyServlet&#38;gImagePath={substring(mets:file[last()]/@ID,6)}.pff&#38;gMenuX=-1&#38;gPOIX=-1&#38;gLabelsX=-1&#38;gNavbarX=195&#38;gNavbarY=350&#38;gViewX=-1&#38;gConferenceX=-1&#38;gRulerX=200&#38;gSkipLogin=1" quality="high" bgcolor="#ffffff" WIDTH="590" HEIGHT="395" TYPE="application/x-shockwave-flash" PLUGINSPAGE="http://www.macromedia.com/go/getflashplayer" swliveconnect="true"></EMBED>
</OBJECT>

<!-- 
     Include a drop-down selector menu as an image-chooser,
     but only if there is more than one image in this item
-->
<xsl:if test="count(mets:file) > 1">
  <script type="text/javascript" >

  /* below function copied from
  www.permadi.com
  */
  <xsl:text disable-output-escaping="yes">
  function getFlashMovieObject(movieName)
  {
    if (window.document[movieName]) 
    {
        return window.document[movieName];
    }
    if (navigator.appName.indexOf("Microsoft Internet")==-1)
    {
      if (document.embeds &amp;&amp; document.embeds[movieName])
        return document.embeds[movieName]; 
    }
    else // if (navigator.appName.indexOf("Microsoft Internet")!=-1)
    {
      return document.getElementById(movieName);
    }
  }
  </xsl:text>
  function switchZoomImage(pffFilename)
  {
 
        var flash = getFlashMovieObject("ZAS");
        /* detect IE and workaround bug in activex implementation of flash player 
           ActiveX flash will not Load a movie into layer 0 if it is the same
           as the currently loaded movie
        */
      
        if (document.all) /* detect IE */
        {
          flash.LoadMovie(0, "/themes/pff_wsu/dummy.swf");  
        }
        flash.LoadMovie(0, "/themes/pff_wsu/ZAS.swf");
        flash.SetVariable("gDefaultLabelVisibility", 1);
        flash.SetVariable("gServerPort", 80);
        flash.SetVariable("gMenuX", -1);
        flash.SetVariable("gPOIX", -1);
        flash.SetVariable("gLabelsX", -1);
        flash.SetVariable("gNavBarX", 195);
        flash.SetVariable("gNavBarY", 350);
        flash.SetVariable("gViewX", -1);
        flash.SetVariable("gConferenceX", -1);
        flash.SetVariable("gRulerX", 200);
        flash.SetVariable("gSkipLogin", 1); 
        flash.SetVariable("gServerIP", "core.libraries.wright.edu");
        flash.SetVariable("gByteHandlerPath", "/ohiolink_zoom/dspacezoomifyServlet");
        flash.SetVariable("gImagePath", pffFilename);

  }
  </script> 
  <form name="zoomimagechooser">
    <fieldset>
    <label for="imagename" accesskey="S">Select file to view</label>
    <select name="imagename" onChange="switchZoomImage( document.zoomimagechooser.imagename.options[document.zoomimagechooser.imagename.selectedIndex].value)" >
      <xsl:for-each select="mets:file">
      <xsl:sort select="mets:FLocat/@xlink:title" />
       <option value="{substring(@ID,6)}.pff" /><xsl:value-of select="substring(mets:FLocat/@xlink:title, 0, string-length(mets:FLocat/@xlink:title)-3)" />
      </xsl:for-each>
    </select>
    </fieldset>
  </form>
</xsl:if> 
</div>
</xsl:template>


    <!-- Generate the info about the item from the metadata section -->
    <!-- Overridden here (pff_wsu) to move the description under the zoom field, and to 
         display only Photographer and Date information in the ItemSummary
         View 
    -->
    <xsl:template match="dim:dim" mode="itemSummaryView-DIM">
      <p>
       <xsl:if test="dim:field[@element='description' and not(@qualifier)]"> <!-- dc.description -->
                        
                        <xsl:for-each select="dim:field[@element='description' and not(@qualifier)]">
                                <xsl:value-of select="." disable-output-escaping="yes" /> <!-- Allow HTML in this field -->
                        </xsl:for-each>
       </xsl:if>
      </p>
      <hr />
      <table class="ds-includeSet-table">
			<!-- dc.contributor.author or dc.creator or dc.contributor -->
            <xsl:if test="dim:field[@element='contributor'][@qualifier='author'] or dim:field[@element='creator'] or dim:field[@element='contributor']">
              <tr class="ds-table-row odd">
                <td><span class="bold"><i18n:text>Photographer</i18n:text>:</span></td>
                <td>
                    <xsl:choose>
                        <xsl:when test="dim:field[@element='contributor'][@qualifier='artist']">
                            <xsl:for-each select="dim:field[@element='contributor'][@qualifier='artist']">
                                <xsl:copy-of select="."/>
                                <xsl:if test="count(following-sibling::dim:field[@element='contributor'][@qualifier='artist']) != 0">
                                    <xsl:text>; </xsl:text>
                                </xsl:if>
                            </xsl:for-each>
                        </xsl:when>
                        <xsl:when test="dim:field[@element='contributor'][@qualifier='author']">
                            <xsl:for-each select="dim:field[@element='contributor'][@qualifier='author']">
                                <xsl:copy-of select="."/>
                                <xsl:if test="count(following-sibling::dim:field[@element='contributor'][@qualifier='author']) != 0">
                                    <xsl:text>; </xsl:text>
                                </xsl:if>
                            </xsl:for-each>
                        </xsl:when>
                        <xsl:when test="dim:field[@element='creator']">
                            <xsl:for-each select="dim:field[@element='creator']">
                                <xsl:copy-of select="."/>
                                <xsl:if test="count(following-sibling::dim:field[@element='creator']) != 0">
                                    <xsl:text>; </xsl:text>
                                </xsl:if>
                            </xsl:for-each>
                        </xsl:when>
                        <xsl:when test="dim:field[@element='contributor']">
                            <xsl:copy-of select="dim:field[@element='contributor'][1]" />
                        </xsl:when>
                        <xsl:otherwise>
                            <i18n:text>xmlui.dri2xhtml.METS-1.0.no-author</i18n:text>
                        </xsl:otherwise>
                    </xsl:choose>
                </td>
              </tr>
            </xsl:if>

			<xsl:if test="dim:field[@element='description' and @qualifier='abstract']"> <!-- dc.description.abstract -->
                <tr class="ds-table-row even">
                    <td><span class="bold"><i18n:text>xmlui.dri2xhtml.METS-1.0.item-abstract</i18n:text>:</span></td>
                    <td>
						<xsl:for-each select="dim:field[@element='description' and @qualifier='abstract']">
                            <xsl:value-of select="." disable-output-escaping="yes" /> <!-- Allow HTML in this field -->
                        </xsl:for-each>
                    </td>
                </tr>
            </xsl:if>

            <!-- original, unmodified dc.date.created without date display transformation getting applied. -->
			<!-- xsl:if test="dim:field[@element='date' and @qualifier='created']">
				<tr class="ds-table-row odd">
					<td><span class="bold"><i18n:text>xmlui.dri2xhtml.METS-1.0.item-date</i18n:text>:</span></td>
                    <td>
						<xsl:for-each select="dim:field[@element='date' and @qualifier='created']">
							<xsl:copy-of select="."/>
                            <xsl:if test="count(following-sibling::dim:field[@element='date' and @qualifier='created']) != 0">
								<br/>
                            </xsl:if>
                        </xsl:for-each>
                    </td>
                </tr>
            </xsl:if> -->
			
			<!-- ***dc.date.created with display transformation*** -->
	<!-- The following modifies the original date transformation code written by Keith G. The following transforms dates
	in the format of YYYY, YYYYMM, YYYYMMDD, YYYY-MM, or YYYY-MM-DD into 1900, January 1900, or January 01, 1900.  This also
	modifies date spans in the format of 1900-01-01-1900-02-01 to display as "January 01, 1900 - February 01, 1900". Any other
	date formats go untouched and display as-is.  Jeff C. April 14, 2010.  -->

	<xsl:if test="dim:field[@element='date' and @qualifier='created']"> <!-- dc.date.created -->
    <tr class="ds-table-row odd">

    <td><span class="bold"><i18n:text>xmlui.dri2xhtml.METS-1.0.item-date</i18n:text>:</span></td>

    <td>
		<xsl:variable name="adate" select="dim:field[@element='date' and @qualifier='created']" />
		<xsl:variable name="firstdatechar" select="substring($adate, 1, 1)" />
		<xsl:variable name="lastdatechar" select="substring($adate, string-length($adate))" />
		<xsl:variable name="newdate" />

		<xsl:choose>
			<xsl:when test="translate($firstdatechar,'0123456789','') = '' and translate($lastdatechar,'0123456789','') = ''">
			<!-- This assumes that when the first and last characters of the date string are both numeric
			(0,1,2,3,4,5,6,7,8, or 9) that this must be a formatted date string of either YYYY, YYYYMM, YYYYMMDD, YYYY-MM or
			YYYY-MM-DD and so we proceed to translate to a user-readable format, such as January 1, 1900. -Jeff. -->

				<xsl:choose>
					<xsl:when test="contains($adate, '-')"><!-- get rid of any dashes in the date string if there are any -->
						<xsl:variable name="newdate" select="translate($adate, '-', '')" />

						<xsl:choose>
							<xsl:when test="string-length($newdate) = 4"><!-- when it's just the year: YYYY -->
								<xsl:value-of select="$newdate" />
							</xsl:when>

							<xsl:when test="string-length($newdate) = 6"><!-- when it's just the year and month: YYYYMM -->
								<xsl:variable name="year" select="substring($newdate,1,4)" />
								<xsl:variable name="month" select="substring($newdate,5,2)" />
								<xsl:choose><!-- print the name of the month -->
									<xsl:when test="$month='01'">January</xsl:when>
									<xsl:when test="$month='02'">February</xsl:when>
									<xsl:when test="$month='03'">March</xsl:when>
									<xsl:when test="$month='04'">April</xsl:when>
									<xsl:when test="$month='05'">May</xsl:when>
									<xsl:when test="$month='06'">June</xsl:when>
									<xsl:when test="$month='07'">July</xsl:when>
									<xsl:when test="$month='08'">August</xsl:when>
									<xsl:when test="$month='09'">September</xsl:when>
									<xsl:when test="$month='10'">October</xsl:when>
									<xsl:when test="$month='11'">November</xsl:when>
									<xsl:when test="$month='12'">December</xsl:when>
								</xsl:choose>
								<xsl:text> </xsl:text><!-- print a single space -->
								<xsl:value-of select="$year" /><!-- print the year -->
							</xsl:when>

							<xsl:when test="string-length($newdate) = 8"><!-- when it's the full date: YYYYMMDD -->
								<xsl:variable name="year2" select="substring($newdate,1,4)" />
								<xsl:variable name="month2" select="substring($newdate,5,2)" />
								<xsl:variable name="day" select="substring($newdate,7,2)" />
								<xsl:choose><!-- print the name of the month -->
									<xsl:when test="$month2='01'">January</xsl:when>
									<xsl:when test="$month2='02'">February</xsl:when>
									<xsl:when test="$month2='03'">March</xsl:when>
									<xsl:when test="$month2='04'">April</xsl:when>
									<xsl:when test="$month2='05'">May</xsl:when>
									<xsl:when test="$month2='06'">June</xsl:when>
									<xsl:when test="$month2='07'">July</xsl:when>
									<xsl:when test="$month2='08'">August</xsl:when>
									<xsl:when test="$month2='09'">September</xsl:when>
									<xsl:when test="$month2='10'">October</xsl:when>
									<xsl:when test="$month2='11'">November</xsl:when>
									<xsl:when test="$month2='12'">December</xsl:when>
								</xsl:choose>
								<xsl:text> </xsl:text><!-- print a single space -->
								<xsl:if test="$day != '00'"><!-- print the day if it is not all zeros -->
									<xsl:value-of select="format-number($day,'##')" />
									<xsl:text>, </xsl:text><!-- follow the day printed with a comma and space -->
								</xsl:if>
								<xsl:value-of select="$year2" /><!-- print the year -->
							</xsl:when>
							
							<xsl:when test="string-length($newdate) = 16"><!-- when given a date span: YYYYMMDDYYYYMMDD -->
								<xsl:variable name="yearfrom" select="substring($newdate,1,4)" />
								<xsl:variable name="yearto" select="substring($newdate,9,4)" />
								<xsl:variable name="monthfrom" select="substring($newdate,5,2)" />
								<xsl:variable name="monthto" select="substring($newdate,13,2)" />
								<xsl:variable name="dayfrom" select="substring($newdate,7,2)" />
								<xsl:variable name="dayto" select="substring($newdate,15,2)" />
								<xsl:choose><!-- print the name of the 'from' month -->
									<xsl:when test="$monthfrom='01'">January</xsl:when>
									<xsl:when test="$monthfrom='02'">February</xsl:when>
									<xsl:when test="$monthfrom='03'">March</xsl:when>
									<xsl:when test="$monthfrom='04'">April</xsl:when>
									<xsl:when test="$monthfrom='05'">May</xsl:when>
									<xsl:when test="$monthfrom='06'">June</xsl:when>
									<xsl:when test="$monthfrom='07'">July</xsl:when>
									<xsl:when test="$monthfrom='08'">August</xsl:when>
									<xsl:when test="$monthfrom='09'">September</xsl:when>
									<xsl:when test="$monthfrom='10'">October</xsl:when>
									<xsl:when test="$monthfrom='11'">November</xsl:when>
									<xsl:when test="$monthfrom='12'">December</xsl:when>
								</xsl:choose>
								<xsl:text> </xsl:text><!-- print a single space -->
								<xsl:if test="$dayfrom != '00'"><!-- print the 'from' day if it is not all zeros -->
									<xsl:value-of select="format-number($dayfrom,'##')" />
									<xsl:text>, </xsl:text><!-- follow the 'from' day printed with a comma and space -->
								</xsl:if>
								<xsl:value-of select="$yearfrom" /><!-- print the 'from' year -->

								<xsl:text> - </xsl:text><!-- print a space, dash, space to separate the 'from' and 'to' dates -->

								<xsl:choose><!-- print the name of the 'to' month -->
									<xsl:when test="$monthto='01'">January</xsl:when>
									<xsl:when test="$monthto='02'">February</xsl:when>
									<xsl:when test="$monthto='03'">March</xsl:when>
									<xsl:when test="$monthto='04'">April</xsl:when>
									<xsl:when test="$monthto='05'">May</xsl:when>
									<xsl:when test="$monthto='06'">June</xsl:when>
									<xsl:when test="$monthto='07'">July</xsl:when>
									<xsl:when test="$monthto='08'">August</xsl:when>
									<xsl:when test="$monthto='09'">September</xsl:when>
									<xsl:when test="$monthto='10'">October</xsl:when>
									<xsl:when test="$monthto='11'">November</xsl:when>
									<xsl:when test="$monthto='12'">December</xsl:when>
								</xsl:choose>
								<xsl:text> </xsl:text><!-- print a single space -->
								<xsl:if test="$dayto != '00'"><!-- print the 'to' day if it is not all zeros -->
									<xsl:value-of select="format-number($dayto,'##')" />
									<xsl:text>, </xsl:text><!-- follow the 'to' day printed with a comma and space -->
								</xsl:if>
								<xsl:value-of select="$yearto" /><!-- print the 'to' year -->
							</xsl:when>

							<!-- Otherwise, this assumes that it must be an unknown date format starting and ending with digits
							[0-9], so pass through unformatted -->
							<xsl:otherwise>
								<xsl:copy-of select="./dim:field[@element='date' and @qualifier='created']/child::node()"/>
							</xsl:otherwise>
						</xsl:choose>

					</xsl:when>

					<xsl:otherwise><!-- otherwise if NO dashes in date string to begin with -->
						<xsl:variable name="newdate" select="$adate" />
						
						<xsl:choose>
							<xsl:when test="string-length($newdate) = 4"><!-- when it's just the year: YYYY -->
								<xsl:value-of select="$newdate" />
							</xsl:when>

							<xsl:when test="string-length($newdate) = 6"><!-- when it's just the year and month: YYYYMM -->
								<xsl:variable name="year" select="substring($newdate,1,4)" />
								<xsl:variable name="month" select="substring($newdate,5,2)" />
								<xsl:choose><!-- print the name of the month -->
									<xsl:when test="$month='01'">January</xsl:when>
									<xsl:when test="$month='02'">February</xsl:when>
									<xsl:when test="$month='03'">March</xsl:when>
									<xsl:when test="$month='04'">April</xsl:when>
									<xsl:when test="$month='05'">May</xsl:when>
									<xsl:when test="$month='06'">June</xsl:when>
									<xsl:when test="$month='07'">July</xsl:when>
									<xsl:when test="$month='08'">August</xsl:when>
									<xsl:when test="$month='09'">September</xsl:when>
									<xsl:when test="$month='10'">October</xsl:when>
									<xsl:when test="$month='11'">November</xsl:when>
									<xsl:when test="$month='12'">December</xsl:when>
								</xsl:choose>
								<xsl:text> </xsl:text><!-- print a single space -->
								<xsl:value-of select="$year" /><!-- print the year -->
							</xsl:when>

							<xsl:when test="string-length($newdate) = 8"><!-- when it's the full date: YYYYMMDD -->
								<xsl:variable name="year2" select="substring($newdate,1,4)" />
								<xsl:variable name="month2" select="substring($newdate,5,2)" />
								<xsl:variable name="day" select="substring($newdate,7,2)" />
								<xsl:choose><!-- print the name of the month -->
									<xsl:when test="$month2='01'">January</xsl:when>
									<xsl:when test="$month2='02'">February</xsl:when>
									<xsl:when test="$month2='03'">March</xsl:when>
									<xsl:when test="$month2='04'">April</xsl:when>
									<xsl:when test="$month2='05'">May</xsl:when>
									<xsl:when test="$month2='06'">June</xsl:when>
									<xsl:when test="$month2='07'">July</xsl:when>
									<xsl:when test="$month2='08'">August</xsl:when>
									<xsl:when test="$month2='09'">September</xsl:when>
									<xsl:when test="$month2='10'">October</xsl:when>
									<xsl:when test="$month2='11'">November</xsl:when>
									<xsl:when test="$month2='12'">December</xsl:when>
								</xsl:choose>
								<xsl:text> </xsl:text><!-- print a single space -->
								<xsl:if test="$day != '00'"><!-- print the day if it is not all zeros -->
									<xsl:value-of select="format-number($day,'##')" />
									<xsl:text>, </xsl:text><!-- follow the day printed with a comma and space -->
								</xsl:if>
								<xsl:value-of select="$year2" /><!-- print the year -->
							</xsl:when>

							<!-- Otherwise, this assumes that it must be an unknown date format starting and ending with digits
							[0-9], so pass through unformatted -->
							<xsl:otherwise>
								<xsl:copy-of select="./dim:field[@element='date' and @qualifier='created']/child::node()"/>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:otherwise>
				</xsl:choose>

			</xsl:when>
				
			<!-- Otherwise, this must be an unknown date format starting and/or ending with non-digits [0-9],
			so pass through unformatted -->
			<xsl:otherwise>
				<xsl:copy-of select="./dim:field[@element='date' and @qualifier='created']/child::node()"/>
			</xsl:otherwise>
				
		</xsl:choose>


		<xsl:if test="count(following-sibling::dim:field[@element='date' and @qualifier='created']) != 0">
			<br/>
        </xsl:if>
    </td>
    </tr>
	</xsl:if> <!-- end dc.date.created -->

      </table>
    </xsl:template>



</xsl:stylesheet>
