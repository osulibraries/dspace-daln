<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE xsl:stylesheet [
    <!ENTITY nbsp "&#x00A0;">
]>
<!--
	sscc.xsl (sscc-LearningObjects/sscc.xsl)
-->

<!--
	This file is the Manakin theme for Southern State Community College.
	KRG 01/15/2007
	UPDATE: This is the version for the Learning Objects Collection, which contains our flv player.
	This version simply omits the importing of ohiolink_common.xsl as it is imported already by films.xsl
	Jeff 11/2/2009
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

	<!-- <xsl:import href="../ohiolink_common/ohiolink_common.xsl" /> already referenced in films.xsl of sscc-films, and films.xsl calls THIS xsl. -->
	<xsl:output indent="yes" />

	<!--  The theme location variable calculates the URL to the theme directory. It's used for building 
		paths to images and other resources. -->
	<xsl:variable name="theme_location"
		select="concat(/dri:document/dri:meta/dri:pageMeta/dri:metadata[@element='contextPath'][not(@qualifier)],'/themes/',/dri:document/dri:meta/dri:pageMeta/dri:metadata[@element='theme'][@qualifier='path'])" />



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
var pageTracker = _gat._getTracker("UA-5946124-10");
pageTracker._trackPageview();
} catch(err) {}</script>

            </body>
        </html>
    </xsl:template>








		<!--
		The template to handle dri:options. Since it contains only dri:list tags (which carry the actual
		information), the only things than need to be done is creating the ds-options div and applying
		the templates inside it.
		
		In fact, the only bit of real work this template does is add the search box, which has to be
		handled specially in that it is not actually included in the options div, and is instead built
		from metadata available under pageMeta.
		KRG:  Added special clear div at the bottom.
		KRG:  Putting SSCC content in this pane - image logo, navigation links
	-->
	<!-- TODO: figure out why i18n tags break the go button -->
	<xsl:template match="dri:options">
		<div id="ds-options">
			<img id ="little_logo" src="{$theme_location}/images/sscclogo.subpage.gif"
				alt="SSCC Logo" />
			<ul id="sscc_image_menu">
				<li>
					<a href="http://www.sscc.edu/current_students/">
						<img alt="Current Students">
							<xsl:attribute name="src">
             <xsl:value-of select="$theme_location" />
             <xsl:text>/images/current.students.gif</xsl:text>
           </xsl:attribute>
						</img>
					</a>
				</li>
				<li>
					<a
						href="http://www.sscc.edu/prospective_students/">
						<img
							src="{$theme_location}/images/prospective.student.gif"
							alt="Prospective Students" />
					</a>
				</li>
				<li>
					<a href="http://www.sscc.edu/transfer_students/">
						<img
							src="{$theme_location}/images/transfer.students.gif"
							alt="Transfer Students" />
					</a>
				</li>
				<li>
					<a href="http://www.sscc.edu/business_industry/">
						<img
							src="{$theme_location}/images/business.industry.gif"
							alt="Business and Industry" />
					</a>
				</li>
				<li>
					<a href="http://www.sscc.edu/community/">
						<img
							src="{$theme_location}/images/community.members.gif"
							alt="Community Members" />
					</a>
				</li>
				<li>
					<a href="http://www.sscc.edu/faculty_staff/">
						<img
							src="{$theme_location}/images/faculty.staff.gif"
							alt="Faculty and Staff" />
					</a>
				</li>
			</ul>

			<h3 id="ds-search-option-head" class="ds-option-set-head">
				<i18n:text>xmlui.dri2xhtml.structural.search</i18n:text>
			</h3>
			<div id="ds-search-option" class="ds-option-set">
				<!-- The form, complete with a text box and a button, all built from attributes referenced
					from under pageMeta. -->
				<form id="ds-search-form" method="post">
					<xsl:attribute name="action">
                        <xsl:value-of
			select="/dri:document/dri:meta/dri:pageMeta/dri:metadata[@element='search'][@qualifier='simpleURL']" />
                    </xsl:attribute>
					<fieldset>
						<input class="ds-text-field " type="text">
							<xsl:attribute name="name">
                                <xsl:value-of
									select="/dri:document/dri:meta/dri:pageMeta/dri:metadata[@element='search'][@qualifier='queryField']" />
                            </xsl:attribute>
						</input>
						<input class="ds-button-field " name="submit"
							type="submit" i18n:attr="value" value="xmlui.general.go">
							<xsl:attribute name="onclick">
                                <xsl:text>
                                    var radio = document.getElementById(&quot;ds-search-form-scope-container&quot;);
                                    if (radio != undefined &amp;&amp; radio.checked)
                                    {
                                    var form = document.getElementById(&quot;ds-search-form&quot;);
                                    form.action=
                                </xsl:text>
                                <xsl:text>&quot;</xsl:text>
                                <xsl:value-of
									select="/dri:document/dri:meta/dri:pageMeta/dri:metadata[@element='contextPath']" />
                                <xsl:text>/handle/&quot; + radio.value + &quot;/search&quot; ; </xsl:text>
                                <xsl:text>
                                    }
                                </xsl:text>
                            </xsl:attribute>
						</input>
						<xsl:if
							test="/dri:document/dri:meta/dri:pageMeta/dri:metadata[@element='focus'][@qualifier='container']">
							<label>
								<input id="ds-search-form-scope-all"
									type="radio" name="scope" value="" checked="checked" />
								<i18n:text>
									xmlui.dri2xhtml.structural.search
								</i18n:text>
							</label>
							<br />
							<label>
								<input
									id="ds-search-form-scope-container" type="radio"
									name="scope">
									<xsl:attribute name="value">
                                        <xsl:value-of
											select="substring-after(/dri:document/dri:meta/dri:pageMeta/dri:metadata[@element='focus'][@qualifier='container'],':')" />
                                    </xsl:attribute>
								</input>
								<xsl:choose>
								<xsl:when test="/dri:document/dri:body//dri:div/dri:referenceSet[@type='detailView' and @n='community-view']">
                                                                                <i18n:text>xmlui.dri2xhtml.structural.search-in-community</i18n:text>
                                                                        </xsl:when>
                                                                        <xsl:otherwise>
                                                                                <i18n:text>xmlui.dri2xhtml.structural.search-in-collection</i18n:text>
                                                                        </xsl:otherwise>
                                                                </xsl:choose>
							</label>
						</xsl:if>
					</fieldset>
				</form>
				<!-- The "Advanced search" link, to be perched underneath the search box -->
				<a>
					<xsl:attribute name="href">
                        <xsl:value-of
							select="/dri:document/dri:meta/dri:pageMeta/dri:metadata[@element='search'][@qualifier='advancedURL']" />
                    </xsl:attribute>
					<i18n:text>
						xmlui.dri2xhtml.structural.search-advanced
					</i18n:text>
				</a>
			</div>

			<!-- Once the search box is built, the other parts of the options are added -->
			<xsl:apply-templates />
		</div>
		<!--KRG add special clear div to make display look proper -->
		<div style="clear:both;">&nbsp;
		</div>
	</xsl:template>

	<!-- KRG Just hide the footer for now to match their library home page -->
	<xsl:template name="buildFooter" />


	<!-- The header (distinct from the HTML head element) contains the title, subtitle, login box and various
		placeholders for header images -->
	<xsl:template name="buildHeader">
		<div id="ds-header">
			<!--
				<a>
				<xsl:attribute name="href">
				<xsl:text>http://drcdev.ohiolink.edu/</xsl:text>
				</xsl:attribute>
				<span id="ds-header-logo">&#160;</span>
				</a>
				<h1><xsl:copy-of select="/dri:document/dri:meta/dri:pageMeta/dri:metadata[@element='title']/node()"/></h1>
				<h2><i18n:text>xmlui.dri2xhtml.structural.head-subtitle</i18n:text></h2>
			-->


			<!-- KRG incorporate the menus from the SSCC main pages
				This currently gives a Javascript error about the
				unregistered DCube menus, so the DCube menus are not in use
				until an answer is provided by SSCC web development team
			-->
			<ul id="topdropmenu">
				<li>
					<a href="http://www.sscc.edu/About/">
						<img 
							src="{$theme_location}/images/black.about.sscc.gif" 
							alt="About SSCC" />
					</a>
					<ul>
						<li>
							<a
								href="http://www.sscc.edu/about/board_of_trustees.htm">
								Board of Trustees
							</a>
						</li>
						<li>
							<a
								href="http://www.sscc.edu/about/values.htm">
								Values/Vision/Mission
							</a>
						</li>
						<li>
							<a
								href="http://www.sscc.edu/faculty_staff/Strategic_Planning/">
								Strategic Plan
							</a>
						</li>
						<li>
							<a
								href="http://www.sscc.edu/about/foundation.htm">
								Foundation
							</a>
						</li>
						<li>
							<a
								href="http://www.sscc.edu/about/news.htm">
								News
							</a>
						</li>
						<li>
							<a
								href="http://www.sscc.edu/about/campus_locations.htm">
								Locations
							</a>
						</li>
						<li>
							<a
								href="http://www.sscc.edu/about/about_area.htm">
								About the Area
							</a>
						</li>
						<li>
							<a
								href="http://www.sscc.edu/about/default.htm">
								More...
							</a>
						</li>
					</ul>
				</li>
				<li>
					<a href="http://www.sscc.edu/Admissions/">
						<img 
							src="{$theme_location}/images/black.admissions.gif"
							alt="Admissions" />
					</a>
					<ul>
						<li>
							<a
								href="http://www.sscc.edu/admissions/getting_started.htm">
								Getting Started
							</a>
						</li>
						<li>
							<a
								href="http://www.sscc.edu/admissions/financial_aid.htm">
								Financial Aid
							</a>
						</li>
						<li>
							<a
								href="http://www.sscc.edu/admissions/tuition_fees.htm">
								Tuition/Fees
							</a>
						</li>
						<li>
							<a
								href="http://www.sscc.edu/admissions/transferring_credit.htm">
								Transferring Credits
							</a>
						</li>
						<li>
							<a
								href="http://www.sscc.edu/admissions/request_information.htm">
								Request Information
							</a>
						</li>
						<li>
							<a
								href="http://www.sscc.edu/admissions/default.htm">
								More...
							</a>
						</li>
					</ul>
				</li>
				<li>
					<a href="http://www.sscc.edu/Academics/">
						<img 
							src="{$theme_location}/images/black.academics.gif" 
							alt="Academics" />
					</a>
					<ul>
						<li>
							<a
								href="http://www.sscc.edu/academics/degree_programs.htm">
								Degree Programs
							</a>
						</li>
						<li>
							<a
								href="http://www.sscc.edu/academics/course_descriptions.htm">
								Course Descriptions
							</a>
						</li>
						<li>
							<a
								href="http://www.sscc.edu/academics/academic_regulations.htm">
								Academic Regulations
							</a>
						</li>
						<li>
							<a
								href="http://www.sscc.edu/academics/adult_opportunity_center.htm">
								Adult Opportunity Center
							</a>
						</li>
						<li>
							<a
								href="http://www.sscc.edu/academics/continuing_education.htm">
								Continuing Education
							</a>
						</li>
						<li>
							<a href="http://lrc.sscc.edu/">
								Learning Resources Center
							</a>
						</li>
						<li>
							<a
								href="http://www.sscc.edu/faculty_staff/faculty.htm">
								Faculty Web Sites
							</a>
						</li>
						<li>
							<a href="http://www.sscc.edu/catalog.pdf">
								College Catalog
							</a>
						</li>
						<li>
							<a
								href="http://www.sscc.edu/academics/default.htm">
								More...
							</a>
						</li>
					</ul>
				</li>
				<li>
					<a href="http://www.sscc.edu/Students/">
						<img 
							src="{$theme_location}/images/black.students.gif"
							alt="Students" />
					</a>
					<ul>
						<li>
							<a
								href="http://www.sscc.edu/students/student_records.htm">
								Student Records
							</a>
						</li>
						<li>
							<a
								href="http://www.sscc.edu/admissions/financial_aid.htm">
								Financial Aid
							</a>
						</li>
						<li>
							<a
								href="http://www.sscc.edu/students/student_payments.htm">
								Student Payments
							</a>
						</li>
						<li>
							<a
								href="http://www.sscc.edu/Students/Career_Svcs/">
								Career Services
							</a>
						</li>
						<li>
							<a
								href="http://www.sscc.edu/students/student_activities.htm">
								Student Activities
							</a>
						</li>
						<li>
							<a
								href="http://www.sscc.edu/students/athletics/athletics.htm">
								Athletics
							</a>
						</li>
						<li>
							<a
								href="http://www.sscc.edu/students/bookstore.htm">
								Bookstore
							</a>
						</li>
						<li>
							<a
								href="http://www.sscc.edu/students/student_policies.htm">
								Student Policies
							</a>
						</li>
						<li>
							<a
								href="http://www.sscc.edu/students/emergency_closing_procedures.htm">
								Emergency Closing Procedures
							</a>
						</li>
						<li>
							<a
								href="http://www.sscc.edu/students/default.htm">
								More...
							</a>
						</li>
					</ul>
				</li>
				<li>
					<a href="http://lrc.sscc.edu/">
						<img
							src="{$theme_location}/images/black.library.gif" 
							alt="Library" />
					</a>
					<ul>
						<li>
							<a href="http://lrc.sscc.edu/">
								About the LRC
							</a>
						</li>
						<li>
							<a
								href="http://lrc.southern.cc.oh.us/screens/opacmenu.html">
								OPASS (Library Catalog)
							</a>
						</li>
						<li>
							<a href="http://academic.knowitnow.org/">
								Chat with a Librarian
							</a>
						</li>
						<li>
							<a href="http://www.ohiolink.edu/">
								OhioLINK
							</a>
						</li>
						<li>
							<a href="http://lrc.sscc.edu">More...</a>
						</li>
					</ul>
				</li>
				<li>
					<a
						href="http://www.sscc.edu/General_Information/">
						<img 
							src="{$theme_location}/images/black.general.information.gif" 
							alt="General Information" />
					</a>
					<ul>
						<li>
							<a
								href="http://www.sscc.edu/general_information/accreditation.htm">
								Accreditation
							</a>
						</li>
						<li>
							<a
								href="http://www.sscc.edu/general_information/directory_info.htm">
								Directory Information
							</a>
						</li>
						<li>
							<a
								href="http://www.sscc.edu/general_information/directory_personnel.htm">
								Directory of Personnel
							</a>
						</li>
						<li>
							<a
								href="http://www.sscc.edu/students/upcoming_events.htm">
								Upcoming Events
							</a>
						</li>
						<li>
							<a
								href="http://www.sscc.edu/general_information/college_calendar.htm">
								College Calendar
							</a>
						</li>
						<li>
							<a
								href="http://www.sscc.edu/general_information/employment_sscc.htm">
								Employment at SSCC
							</a>
						</li>
						<li>
							<a
								href="http://www.sscc.edu/general_information/default.htm">
								More...
							</a>
						</li>
					</ul>
				</li>
			</ul><!--  topdropmenu -->
			<div style="clear: both;">&nbsp;
			</div>

			<!-- 
				
				<xsl:choose>
				<xsl:when test="/dri:document/dri:meta/dri:userMeta/@authenticated = 'yes'">
				<div id="ds-user-box">
				<p>
				<a>
				<xsl:attribute name="href">
				<xsl:value-of select="/dri:document/dri:meta/dri:userMeta/
				dri:metadata[@element='identifier' and @qualifier='url']"/>
				</xsl:attribute>
				<i18n:text>xmlui.dri2xhtml.structural.profile</i18n:text>
				<xsl:value-of select="/dri:document/dri:meta/dri:userMeta/
				dri:metadata[@element='identifier' and @qualifier='firstName']"/>
				<xsl:text> </xsl:text>
				<xsl:value-of select="/dri:document/dri:meta/dri:userMeta/
				dri:metadata[@element='identifier' and @qualifier='lastName']"/>
				</a>
				<xsl:text> | </xsl:text>
				<a>
				<xsl:attribute name="href">
				<xsl:value-of select="/dri:document/dri:meta/dri:userMeta/
				dri:metadata[@element='identifier' and @qualifier='logoutURL']"/>
				</xsl:attribute>
				<i18n:text>xmlui.dri2xhtml.structural.logout</i18n:text>
				</a>
				</p>
				</div>
				</xsl:when>
				<xsl:otherwise>
				<div id="ds-user-box">
				<p>
				<a>
				<xsl:attribute name="href">
				<xsl:value-of select="/dri:document/dri:meta/dri:userMeta/
				dri:metadata[@element='identifier' and @qualifier='loginURL']"/>
				</xsl:attribute>
				<i18n:text>xmlui.dri2xhtml.structural.login</i18n:text>
				</a>
				</p>
				</div>
				</xsl:otherwise>
				</xsl:choose>
			-->
		</div>
	</xsl:template>

	<!--
		The template to handle the dri:body element. It simply creates the ds-body div and applies
		templates of the body's child elements (which consists entirely of dri:div tags).
		Modified for sscc to move the ds-trail breadcrumb element into the body.
		
	-->
	<xsl:template match="dri:body">
		<div id="ds-body">
			<ul id="ds-trail">
				<xsl:apply-templates
					select="/dri:document/dri:meta/dri:pageMeta/dri:trail" />
			</ul>
			<xsl:if
				test="/dri:document/dri:meta/dri:pageMeta/dri:metadata[@element='alert'][@qualifier='message']">
				<div id="ds-system-wide-alert">
					<p>
						<xsl:copy-of
							select="/dri:document/dri:meta/dri:pageMeta/dri:metadata[@element='alert'][@qualifier='message']/node()" />
					</p>
				</div>
			</xsl:if>
			<xsl:apply-templates />
		</div>
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
                        mets:file[@GROUP_ID=current()/@GROUP_ID]">
                        <a class="thickbox image-link" rel="thickboxgallery">
                            <xsl:attribute name="title">
                              <xsl:value-of select="mets:FLocat[@LOCTYPE='URL']/@xlink:title"/>
                            </xsl:attribute>
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
                            <i18n:text>xmlui.dri2xhtml.METS-1.0.item-files-viewOpen</i18n:text>
                        </a>
                    </xsl:otherwise>
                </xsl:choose>
            </td>
        </tr>
    </xsl:template>




</xsl:stylesheet>
