<?xml version="1.0" encoding="UTF-8"?>

<!--
  template.xsl

-->

<!--
   Special date formatting.  Translate bulldog style dates
   into usable dates.  For WSU collections. 
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
        xmlns:dcterms="http://purl.org/dc/terms/"
        xmlns="http://www.w3.org/1999/xhtml"
	exclude-result-prefixes="i18n dri mets xlink xsl dim xhtml mods dc dcterms">
    
    <xsl:import href="../WSU/template.xsl"/>
   <!-- <xsl:output indent="yes"/> -->
 

   
    <!-- Generate the info about the item from the metadata section 
     Modified to display creation date and format in user friendly manner
     Expects dates in format YYYY, YYYYMM, or YYYYMMDD.
     Dates that do not begin with a number are passed through unchanged.
     Dates that begin with a number are formatted in user readable style, such as December 17, 1903.
    -->
    <xsl:template match="dim:dim" mode="itemSummaryView-DIM">
    <table class="ds-includeSet-table">

            <tr class="ds-table-row odd"> <!-- Preview Thumbnail -->
                <td><span class="bold"><i18n:text>xmlui.dri2xhtml.METS-1.0.item-preview</i18n:text>:</span></td>
                <td>
                    <xsl:choose>
                        <xsl:when test="/mets:METS/mets:fileSec/mets:fileGrp[@USE='THUMBNAIL']">
                        <xsl:variable name="thumbcandidate" select="/mets:METS/mets:fileSec/mets:fileGrp[@USE='CONTENT']
                                            /mets:file[@MIMETYPE='image/jpeg'][last()]" />
                             <a class="image-link" rel="lightbox">
                               <xsl:attribute name="href">
                                  <xsl:value-of select="$thumbcandidate/mets:FLocat[@LOCTYPE='URL']/@xlink:href"/>
                               </xsl:attribute>
                                <img alt="Thumbnail">
                                    <xsl:attribute name="src">
                                        <xsl:value-of select="/mets:METS/mets:fileSec/mets:fileGrp[@USE='THUMBNAIL']
                                             /mets:file[@GROUP_ID=($thumbcandidate/@GROUP_ID)]
                                             /mets:FLocat[@LOCTYPE='URL']/@xlink:href"/>
                                    </xsl:attribute>
                                </img>
                            </a>
                        </xsl:when>
                        <xsl:otherwise>
                            <i18n:text>xmlui.dri2xhtml.METS-1.0.no-preview</i18n:text>
                        </xsl:otherwise>
                    </xsl:choose>
                </td>
            </tr>
            <tr class="ds-table-row even"> <!-- dc.title -->
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
             <!-- if the contributor.artist field is present, label this field as Artist (for Stein Galleries).
                  Otherwise, use the default label (Author) -->
             <xsl:choose>
               <xsl:when test="dim:field[@element='contributor'][@qualifier='artist']">
                  <td><span class="bold"><xsl:text>Artist</xsl:text>:</span></td>
               </xsl:when>
              <xsl:otherwise>
                 <td><span class="bold"><i18n:text>xmlui.dri2xhtml.METS-1.0.item-author</i18n:text>:</span></td>
              </xsl:otherwise>
             </xsl:choose>
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
                            <xsl:for-each select="dim:field[@element='contributor']">
                                <xsl:copy-of select="."/>
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

			<xsl:if test="dim:field[@element='description' and @qualifier='abstract']"> <!-- dc.description.abstract -->
                    <tr class="ds-table-row even">
                        <td><span class="bold"><i18n:text>xmlui.dri2xhtml.METS-1.0.item-abstract</i18n:text>:</span></td>
                        <td>
                        <xsl:for-each select="dim:field[@element='description' and @qualifier='abstract']">
                                <xsl:copy-of select="./node()"/>
                        </xsl:for-each>
                        </td>
                    </tr>
            </xsl:if>

			<xsl:if test="dim:field[@element='description' and not(@qualifier)]"> <!-- dc.description -->
                    <tr class="ds-table-row odd">
                        <td><span class="bold"><i18n:text>xmlui.dri2xhtml.METS-1.0.item-description</i18n:text>:</span></td>
                        <td>
                        <xsl:for-each select="dim:field[@element='description' and not(@qualifier)]">
                                <xsl:copy-of select="./node()"/>
                        </xsl:for-each>
                        </td>
                    </tr>
            </xsl:if>

            <xsl:if test="dim:field[@element='identifier' and @qualifier='uri']"> <!-- dc.identifier.uri -->
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
            </xsl:if> <!-- end dc.identifier.uri -->


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


        <xsl:if test="dim:field[@element='contributor' and @qualifier='repository']"> <!-- dc.contributor.repository -->
			<tr class="ds-table-row even">
				<td><span class="bold">Repository:</span></td>
				<td><xsl:copy-of select="dim:field[@element='contributor' and @qualifier='repository']/child::node()"/></td>
            </tr>
        </xsl:if> <!-- end dc.contributor.repository -->

    </table>
    </xsl:template>
	
</xsl:stylesheet>
