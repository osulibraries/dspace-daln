<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE xsl:stylesheet [
    <!ENTITY nbsp "&#x00A0;">
]>


<!--
	Toledo.xsl
	01/04/2008
	KRG
	OhioLINK
	
	Contains customizations for the The University of Toledo Manakin theme.
	
	TODO: Check if the main site is using different stylesheets for firefox,IE
	TODO: Fix display problem in footer with IE6 on local system. Looks okay
	       on DRCDEV.
	TODO: Discover cause of item row display problem in IE6 on my local system
	       - no problem on DRCDEV
	TODO: Find cause of disappearing buttons on IE6in "SEARCH DRC" box on my local
	system.  Looks okay in DEV.
	TODO: See if there is a better place to move Search DRC box now that there
	are additional menu items above it.
	TODO:  Add digital resource commons link to left hand menus
	
-->

<xsl:stylesheet xmlns="http://www.w3.org/1999/xhtml"
	xmlns:i18n="http://apache.org/cocoon/i18n/2.1"
	xmlns:dri="http://di.tamu.edu/DRI/1.0/"
	xmlns:mets="http://www.loc.gov/METS/"
	xmlns:xlink="http://www.w3.org/TR/xlink/"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0"
	xmlns:dim="http://www.dspace.org/xmlns/dspace/dim"
	xmlns:xhtml="http://www.w3.org/1999/xhtml"
	xmlns:mods="http://www.loc.gov/mods/v3"
	xmlns:dc="http://purl.org/dc/elements/1.1/"
	exclude-result-prefixes="i18n dri mets xlink xsl dim xhtml mods dc">

	<xsl:import href="../ohiolink_common/ohiolink_common.xsl" />
	<xsl:output indent="yes" />

	<!-- The header (distinct from the HTML head element) contains the title, subtitle, login box and various
		placeholders for header images -->
	<xsl:template name="buildHeader">
		<div style="cursor: pointer;" title="UT home page"
			onclick="window.location='http://utoledo.edu';" id="shield">&nbsp;
		</div>
		<div id="banner_wrap">
			<div id="topNav_wrap">
				<ul id="topNav">
					<li id="topNav_first">
						<a href="http://www.utoledo.edu/index.html">
							Home
						</a>
					</li>
					<li>
						<a
							href="http://www.utoledo.edu/campus/about/index.html">
							About UT
						</a>
					</li>
					<li>
						<a
							href="http://www.utoledo.edu/campus/maps/index.html">
							Directions/Maps
						</a>
					</li>
					<li>
						<a
							href="http://utoledo.edu/eDirectory/default.asp">
							Campus Directory
						</a>
					</li>
					<li>
						<a
							href="http://www.utoledo.edu/campus/about/address.html">
							Contact
						</a>
					</li>
					<li id="myut">
						<a href="http://myut.utoledo.edu/"
							target="_blank">
							myUT
						</a>
					</li>
				</ul>
			</div><!-- topNav_wrap -->
			<div id="topHead_wrap">
				<div id="titleHold">&nbsp;
				</div>
				<div id="headSearchHold">
					<a name="search" />
					<div id="headSearch">
						<!--TODO: Fix hrefs in below search form and sublinks -->
						<form
							action="http://find.utoledo.edu:3242/custom/utoledo/query.html"
							method="get" name="form1">
							<input type="text" class="searchbox"
								name="qt" />
							<input type="hidden" value="utoledo"
								name="col" />
							<input type="submit" value="SEARCH"
								id="Search" class="searchbtn" name="Search" />
						</form>
					</div><!--headSearch -->
					<ul id="headSearchSubs">
						<li id="headSearchSubs_first">
							<a
								href="http://find.utoledo.edu:3242/custom/utoledo/query.html?ql=a&amp;qt=&amp;charset=iso-8859-1&amp;col=utoledo">
								Advanced Search
							</a>
						</li>
						<!-- TODO: Figure out problem with text-only link - displays  a sign in page and has the word Manakin -->
						<li>
							<a
								href="http://transcoder.usablenet.com/tt/referrer">
								Text Only
							</a>
						</li>
						<li>
							<a
								onclick="this.href='mailto:'+reverse('ude.odelotu@retsambew');"
								href="#">
								Feedback
							</a>
						</li>
					</ul><!-- headSearchSubs -->
				</div><!-- headSearchHold-->
			</div><!-- topHead_wrap -->
			<div id="mainNav_wrap">
				<ul id="mainNav">
					<li id="mainNav_first">
						<a
							href="http://www.utoledo.edu/menu/prospective.html">
							Prospective Students
						</a>
					</li>
					<li>
						<a href="http://utoledo.edu/admission/">
							Admission
						</a>
					</li>
					<li>
						<a
							href="http://www.utoledo.edu/menu/academics.html">
							Academics
						</a>
					</li>
					<li>
						<a
							href="http://www.utoledo.edu/menu/campus_life.html">
							Campus Life
						</a>
					</li>
					<li>
						<a
							href="http://www.utoledo.edu/menu/current.html">
							Current Students
						</a>
					</li>
					<li>
						<a
							href="http://www.utoledo.edu/menu/faculty_staff.html">
							Faculty &amp; Staff
						</a>
					</li>
					<li>
						<a href="http://utoledo.edu/research">
							Research
						</a>
					</li>
					<li>
						<a href="http://utrockets.com/">Athletics</a>
					</li>
					<li>
						<a
							href="http://www.utoledo.edu/menu/alumni.html">
							Alumni &amp; Community
						</a>
					</li>
				</ul>
			</div><!--mainNav_wrap -->
			<div style="padding-bottom: 0pt;" id="headShad">&nbsp;
			</div>
			<!-- this would be a good place for breadcrumbs - KRG -->
			<div style="padding-bottom: 0pt;" id="breadcrumb_wrap">
				<ul style="padding-bottom: 0pt;" id="breadcrumb">
					<xsl:apply-templates
						select="/dri:document/dri:meta/dri:pageMeta/dri:trail" />
				</ul>
				<ul style="padding-bottom: 0pt;" id="extras">
					<li id="extras_first">
						<script type="text/javascript">
							//
							<!--
								var txt = "Bookmark"
								
								// url to be bookmarked
								var url = window.location;
								
								// title to appear with it
								var who =  document.title;
								
								var ver = navigator.appName
								var num = parseInt(navigator.appVersion)
								if ((ver=="Microsoft Internet Explorer")&&(num >= 4)&&(navigator.userAgent.toLowerCase().indexOf("mac")==-1)) {
								document.write('<' + 'a href="javascript:window.external.AddFavorite(url,who);" ');
								document.write('onMouseOver=" window.status=')
								document.write("txt; return true ")
								document.write('"onMouseOut=" window.status=')
								document.write("' '; return true ")
								document.write('">'+ txt + '</' + 'a>')
								}else{
								txt += "&nbsp;&nbsp;("
								if (navigator.userAgent.toLowerCase().indexOf("mac")!=-1) {
								txt += "Apple"
								}
								else{
								txt += "Ctrl"
								}
								txt += "+D)&nbsp;"
								document.write(txt)
								} 
								//-->
						</script>
						Bookmark  (Ctrl+D) 
					</li>
					<li>
						<a href="javascript:window.print()">Print</a>
					</li>
				</ul>
			</div>
		</div><!-- banner_wrap -->
	</xsl:template>

	<!-- An example of an existing template copied from structural.xsl and overridden -->
	<xsl:template name="buildFooter">
		<div id="contentBotCtr">
			<div id="contentBotRht">
				<div id="contentBotLft">&nbsp;
				</div>
			</div>
		</div>
		<div id="footerNav_wrap">
			<ul id="footerNav">
				<li id="footerNav_first">
					<a
						href="http://www.utoledo.edu/menu/prospective.html">
						Prospective Students
					</a>
				</li>
				<li>
					<a href="http://utoledo.edu/admission/">
						Admission
					</a>
				</li>
				<li>
					<a
						href="http://www.utoledo.edu/menu/academics.html">
						Academics
					</a>
				</li>
				<li>
					<a
						href="http://www.utoledo.edu/menu/campus_life.html">
						Campus Life
					</a>
				</li>
				<li>
					<a
						href="http://www.utoledo.edu/menu/current.html">
						Current Students
					</a>
				</li>
				<li>
					<a
						href="http://www.utoledo.edu/menu/faculty_staff.html">
						Faculty &amp; Staff
					</a>
				</li>
				<li>
					<a href="http://utoledo.edu/research">Research</a>
				</li>
				<li>
					<a href="http://utrockets.com/">Athletics</a>
				</li>
				<li>
					<a href="http://www.utoledo.edu/menu/alumni.html">
						Alumni &amp; Community
					</a>
				</li>
			</ul>
		</div><!--footerNav_wrap -->
		<div id="copyright_wrap">
			<div id="copyrightHold">
				<div align="left">
					The University of Toledo . 2801 W. Bancroft .
					Toledo, OH 43606-3390 . 1.800.586.5336
					<br />
					© 2006-2007 The University of Toledo. All rights
					reserved. . Send all feedback / comments to
					<a
						onclick="this.href='mailto:'+reverse('ude.odelotu@retsambew');"
						href="#">
						webmaster
					</a>
					.
				</div>
			</div>
			<ul id="privateHold">
				<li id="private_first">
					<a
						href="http://www.utoledo.edu/campus/terms.html">
						Terms of Use
					</a>
				</li>
			</ul>
		</div>
	</xsl:template>

	<!--
		The starting point of any XSL processing is matching the root element. In DRI the root element is document,
		which contains a version attribute and three top level elements: body, options, meta (in that order).
		
		This template creates the html document, giving it a head and body. A title and the CSS style reference
		are placed in the html head, while the body is further split into several divs. The top-level div
		directly under html body is called "ds-main". It is further subdivided into:
		"ds-header"  - the header div containing title, subtitle, trail and other front matter
		"ds-body"    - the div containing all the content of the page; built from the contents of dri:body
		"ds-options" - the div with all the navigation and actions; built from the contents of dri:options
		"ds-footer"  - optional footer div, containing misc information
		
		The order in which the top level divisions appear may have some impact on the design of CSS and the
		final appearance of the DSpace page. While the layout of the DRI schema does favor the above div
		arrangement, nothing is preventing the designer from changing them around or adding new ones by
		overriding the dri:document template.
	-->
	<xsl:template match="/dri:document">
		<html>
			<!-- First of all, build the HTML head element -->
			<xsl:call-template name="buildHead" />
			<!-- Then proceed to the body -->
			<body>
				<!--
					The header div, complete with title, subtitle, trail and other junk. The trail is
					built by applying a template over pageMeta's trail children. -->
				<xsl:call-template name="buildHeader" />
				<!-- KRG 01/04/2008 University of Toledo Customizations -->
				<div class="noPaddingNoMargin" align="center">
					<div id="layout_wrap">
						<div id="header">
							<div id="headerCorner">
								<div id="headerTitle">
									<div align="right"
										style="border: 0pt none ; margin: 0pt; padding: 0pt; font-size: 8pt; font-family: verdana,tahoma,sans-serif; float: right; text-align: right; width: 460px; height: 30px; position: relative; top: -2px; left: 0px;">
										<form
											action="http://utmost.cl.utoledo.edu/search~/a?a"
											method="post" style="margin: 0pt; padding: 0pt;">
											<select name="searchtype"
												style="margin: 0pt; padding: 0pt; width: 85px; position: absolute; left: 126px; top: 0pt;">
												<option selected=""
													value="t">
													by Title
												</option>
												<option value="a">
													Author
												</option>
												<option value="d">
													Subject
												</option>
												<option value="j">
													Med Subject
												</option>
												<option value="X">
													Keyword
												</option>
												<option value="c">
													LC Call #
												</option>
												<option value="m">
													NLM Call #
												</option>
												<option value="f">
													Local Call #
												</option>
												<option value="g">
													SuDoc #
												</option>
												<option value="o">
													OCLC #
												</option>
												<option value="i">
													ISBN/ISSN
												</option>
											</select>
											<input size="15"
												value="Search Catalog..." maxlength="75" name="searcharg"
												style="margin: 0pt; padding: 2px 0pt 0pt; width: 120px; position: absolute; left: 0px; top: 0pt;"
												onfocus="this.value='';" />
											<select name="searchscope"
												style="margin: 0pt; padding: 0pt; width: 100px; position: absolute; left: 214px; top: 0pt;">
												<option value="1">
													Health Sci Lib
												</option>
												<option value="2">
													Law Library
												</option>
												<option
													selected="selected" value="3">
													All Libraries
												</option>
											</select>
											<input type="hidden"
												value="D" name="SORT" />
											<input type="submit"
												value="Go!"
												style="margin: 0pt; padding: 0px 0pt 0pt; font-size: 10pt; font-family: verdana,tahoma,sans-serif; position: absolute; left: 317px; width: 40px; top: -1px;"
												name="submit" />
											<a
												href="http://utmost.cl.utoledo.edu/search/X"
												title="Advanced keyword search"
												style="position: relative; top: 3px;">
												Advanced Search
											</a>
										</form>
									</div>
									University of Toledo Libraries
								</div><!-- headerTitle -->
							</div><!--headerCorner -->
						</div><!--header -->
						<div id="content_rht">
							<div id="content_lft">
								<div id="content_wrap">
									<div id="redLine">&nbsp;
									</div>
									<div id="topLineNav_wrap"
										style="display: block">
										<a name="menu" id="menu" />
										<ul id="topLineNav">
											<li>
												<a target="_self"
													href="http://www.utoledo.edu/library/index.html" title="" class="">
													<strong>
														UT Libraries
														Home
													</strong>
												</a>
											</li>
											<li>
												<a target="_self"
													href="http://www.utoledo.edu/library/find/index.html" title="" class="">
													How do I find...?
												</a>
											</li>
											<li>
												<a target="_self"
													href="http://www.utoledo.edu/library/serv/index.html" title="" class="">
													Library Services
												</a>
											</li>
											<li>
												<a target="_self"
													href="http://www.utoledo.edu/library/locations.html" title="" class="">
													Libraries &amp;
													Collections
												</a>
											</li>
											<li>
												<a target="_self"
													href="http://www.utoledo.edu/library/info/index.html" title="" class="">
													General Information
												</a>
											</li>
											<li>
												<a target="_self"
													href="http://www.utoledo.edu/library/help/index.html" title="" class="">
													Help
												</a>
											</li>
											<li>
												<a target="_self"
													href="http://www.utoledo.edu/library/help/ask.html" title="" class="">
													Ask a Librarian
												</a>
											</li>
										</ul>
										<!--TODO: Get missing javascript here -->
									</div><!-- topLineNav_wrap -->
									<div id="navContent_wrap">
										<div id="navContentOverflow"
											align="left">
											<div id="lftNavHold">
												<div id="navHead"
													class="navHead">
													Quick Links
												</div>
												<div id="lftNav_wrap"
													class="lftNav_wrap">
													<ul>
														<li>
															<a
																target="_self"
																href="http://utmost.cl.utoledo.edu/search" title=""
																class="">
																UT
																Library
																Catalog
															</a>
														</li>
														<li>
															<a
																target="_self"
																href="http://utmost.cl.utoledo.edu/patroninfo/" title=""
																class="">
																Your
																Library
																Record
															</a>
														</li>
														<li>
															Research
															Databases
															<br />
															   by
															<a
																target="_self"
																href="http://www.ohiolink.edu/resources/dblist.php?by=alpha&amp;search=a"
																title="" class="">
																Name
															</a>
															or
															<a
																target="_self"
																href="http://www.ohiolink.edu/resources.cgi?by=subject"
																title="" class="">
																Subject
															</a>
														</li>
														<li>
															<a
																target="_self"
																href="http://kl6fz4nh2b.search.serialssolutions.com/"
																title="" class="">
																Online
																Journals
															</a>
														</li>
														<li>
															<a
																target="_self" href="http://www.ohiolink.edu" title=""
																class="">
																OhioLINK
															</a>
														</li>
														<li>
															<a
																target="_self"
																href="http://www.utoledo.edu/library/help/index.html"
																title="" class="">
																Help
															</a>
															 |
															<a
																target="_self"
																href="http://www.utoledo.edu/library/help/ask.html"
																title="" class="">
																Ask a
																Librarian
															</a>
														</li>
														<li>
															<a
																target="_self"
																href="http://www.utoledo.edu/library/help/siteindex.html"
																title="" class="">
																Site
																Index
															</a>
															|
															<a
																href="http://find.utoledo.edu:3242/custom/utoledo/query.html?qm=1&amp;qt=url%3Autoledo.edu/library">
																Site
																Search
															</a>
														</li>
													</ul>
												</div><!-- lftNav_wrap -->
												<h3 id="ds-search-option-head" class="navHead">
				<i18n:text>xmlui.dri2xhtml.structural.search</i18n:text>
			</h3>
			<div id="ds-search-option"
				class="ds-option-set lftNav_wrap">
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
									<xsl:when
										test="/dri:document/dri:meta/dri:objectMeta/dri:object[@objectIdentifier=/dri:document/dri:meta/dri:pageMeta/dri:metadata[@element='focus'][@qualifier='container']]/mets:METS/mets:structMap[@TYPE='LOGICAL']/mets:div[@TYPE='DSpace Collection']">
										This Collection
									</xsl:when>
									<xsl:when
										test="/dri:document/dri:meta/dri:objectMeta/dri:object[@objectIdentifier=/dri:document/dri:meta/dri:pageMeta/dri:metadata[@element='focus'][@qualifier='container']]/mets:METS/mets:structMap[@TYPE='LOGICAL']/mets:div[@TYPE='DSpace Community']">
										This Community
									</xsl:when>
								</xsl:choose>
							</label>
						</xsl:if>
					</fieldset>
				</form>
				<!-- The "Advanced search" link, to be perched underneath the search box -->
				<ul>
					<li>
						<a>
							<xsl:attribute name="href">
                        <xsl:value-of
									select="/dri:document/dri:meta/dri:pageMeta/dri:metadata[@element='search'][@qualifier='advancedURL']" />
                    </xsl:attribute>
							<i18n:text>
								xmlui.dri2xhtml.structural.search-advanced
							</i18n:text>
						</a>
					</li>
				</ul>
			</div>
												<div
													style="display: block;" id="relateHead" class="navHead">
													Ward M. Canaday
													Center for Special
													Collections
												</div>
												<div
													style="display: block;" class="lftNav_wrap"
													id="relateNav_wrap">
													<a target="_self"
														href="http://utoledo.edu/library/canaday/manuscripts.html"
														title="Manuscript Collection" class="" />
													<ul>
														<li>
															<a
																target="_self" href="http://utoledo.edu/library/canaday/manuscripts.html"
																title="Manuscript Collection" class="">
																Manuscript
																Collection
															</a>
														</li>
														<li>
															<a
																target="_self" href="http://utoledo.edu/library/canaday/archives.html"
																title="University Archives" class="">
																University
																Archives
															</a>
														</li>
														<li>
															<a
																target="_self"
																href="http://utoledo.edu/library/canaday/rarebooks.html"
																title="Rare Book Collection" class="">
																Rare
																Book
																Collection
															</a>
															<a
																target="_self"
																href="http://utoledo.edu/library/canaday/archives1.html"
																title="University of Toledo Archives" class="">
															</a>
														</li>
														<li>
															<a
																target="_self" href="http://utoledo.edu/library/canaday/exhibit.html"
																title="Exhibits and Events" class="">
																Exhibits
																and
																Events
															</a>
														</li>
														<li>
															<a
																target="_self"
																href="http://utoledo.edu/library/canaday/vethist.html"
																title="Veterans History Project" class="">
																Veterans
																History
																Project
															</a>
														</li>
														<li>
															<a
																target="_self" href="http://utoledo.edu/library/canaday/rules.html"
																title="Use and Reproduction of Canaday Center Materials"
																class="">
																Use and
																Reproduction
																of
																Canaday
																Center
																Materials
															</a>
														</li>
														<li>
															<a
																target="_self" href="http://www.toledosattic.org/"
																title="" class="">
																Toledo's
																Attic
																Online
																Museum
															</a>
														</li>
														<li>
															<a
																target="_self" href="http://utoledo.edu/library/canaday/staff.html"
																title="Canaday Center Faculty and Staff" class="">
																Faculty
																and
																Staff
															</a>
														</li>
														<li>
															<a
																target="_self" href="http://utoledo.edu/library/canaday/history.html"
																title="Ward M. Canaday" class="">
																Ward M.
																Canaday
															</a>
														</li>
														<li>
															<a
																target="_self" href="http://utoledo.edu/library/canaday/news.html"
																title="Announcements and News" class="">
																Announcements
																and News
															</a>
														</li>
														<li>
															<a
																target="_self" href="http://utoledo.edu/library/canaday/index.html"
																title="Return to the Main Page" class="">
																Return
																to the
																Main
																Page
															</a>
															<br />
														</li>
													</ul>
													<br />
												</div>
												<!-- Build DRC menus, with relateHead,relateNav_wrap, lftNavWrap styles, and additional js -->
												<!-- TODO: Implement Toledo Javascript to adjust related menu styles with correct div names -->
												<!-- The options template generates
													the ds-options div that contains the navigation and action options available to the
													user.-->
												<xsl:apply-templates
													select="dri:options" />
											</div>
											<!--lftNavHold -->
											<div id="textHold_wrap">
												<div id="textHold">
													<div
														style="display: block;" id="rhtNav_bg"
														class="rhtNav_bg">
														<div
															id="rhtNavHead">
															Ward M.
															Canaday
															Center
															Manuscript
															Collection
															<br />
														</div>
														<div
															id="rhtNav">
															<ul>
																<li>
																	<a
																		target="_self" href="http://utoledo.edu/library/canaday/guidepages/aa.html" title=""
																		class="">
																		African-Americans
																	</a>
																</li>
																<li>
																	<a
																		target="_self" href="http://utoledo.edu/library/canaday/guidepages/arch.html" title=""
																		class="">
																		Architecture
																	</a>
																</li>
																<li>
																	<a
																		target="_self" href="http://utoledo.edu/library/canaday/guidepages/business.html"
																		title="" class="">
																		Business
																		and
																		Commerce
																	</a>
																</li>
																<li>
																	<a
																		target="_self" href="http://utoledo.edu/library/canaday/guidepages/civic.html" title=""
																		class="">
																		Civic
																		Interests
																	</a>
																</li>
																<li>
																	<a
																		target="_self" href="http://utoledo.edu/library/canaday/guidepages/collectors.html"
																		title="" class="">
																		Collectors
																		and
																		Collecting
																	</a>
																</li>
																<li>
																	<a
																		target="_self" href="http://utoledo.edu/library/canaday/guidepages/crime.html" title=""
																		class="">
																		Crime
																		and
																		Criminals
																	</a>
																</li>
																<li>
																	<a
																		target="_self" href="http://utoledo.edu/library/canaday/guidepages/disability.html"
																		title="" class="">
																		Disability
																		History
																	</a>
																</li>
																<li>
																	<a
																		target="_self" href="http://utoledo.edu/library/canaday/guidepages/education.html"
																		title="" class="">
																		Education
																		and
																		Schools
																	</a>
																</li>
																<li>
																	<a
																		target="_self" href="http://utoledo.edu/library/canaday/guidepages/ethinc.html" title=""
																		class="">
																		Ethnic
																		Culture
																	</a>
																</li>
																<li>
																	<a
																		target="_self" href="http://utoledo.edu/library/canaday/guidepages/labor.html" title=""
																		class="">
																		Labor
																	</a>
																</li>
																<li>
																	<a
																		target="_self" href="http://utoledo.edu/library/canaday/guidepages/lit.html" title=""
																		class="">
																		Literature
																	</a>
																</li>
																<li>
																	<a
																		target="_self" href="http://utoledo.edu/library/canaday/guidepages/med.html" title=""
																		class="">
																		Medicine
																		and
																		Health
																	</a>
																</li>
																<li>
																	<a
																		target="_self" href="http://utoledo.edu/library/canaday/guidepages/muni.html" title=""
																		class="">
																		Municipal
																		Government
																	</a>
																</li>
																<li>
																	<a
																		target="_self" href="http://utoledo.edu/library/canaday/guidepages/music.html" title=""
																		class="">
																		Music,
																		Art,
																		Drama,
																		and
																		Theatre
																	</a>
																</li>
																<li>
																	<a
																		target="_self" href="http://utoledo.edu/library/canaday/guidepages/politics.html"
																		title="" class="">
																		Politics
																		and
																		Government
																	</a>
																</li>
																<li>
																	<a
																		target="_self" href="http://utoledo.edu/library/canaday/guidepages/religion.html"
																		title="" class="">
																		Religion
																	</a>
																</li>
																<li>
																	<a
																		target="_blank" href="http://utoledo.edu/library/canaday/findingaids1/Smallmss.pdf"
																		title="Small Manuscripts Collection" class="">
																		Small
																		Manuscripts
																		Collection
																	</a>
																</li>
																<li>
																	<a
																		target="_self" href="http://utoledo.edu/library/canaday/guidepages/socialife.html"
																		title="" class="">
																		Social
																		Life
																		and
																		Customs
																	</a>
																</li>
																<li>
																	<a
																		target="_self" href="http://utoledo.edu/library/canaday/guidepages/swelfare.html"
																		title="" class="">
																		Social
																		Welfare
																	</a>
																</li>
																<li>
																	<a
																		target="_self" href="http://utoledo.edu/library/canaday/guidepages/travel.html" title=""
																		class="">
																		Travel
																	</a>
																</li>
																<li>
																	<a
																		target="_self" href="http://utoledo.edu/library/canaday/guidepages/war.html" title=""
																		class="">
																		War,
																		Soldiers,
																		and
																		Veterans
																	</a>
																</li>
																<li>
																	<a
																		target="_self" href="http://utoledo.edu/library/canaday/guidepages/women.html" title=""
																		class="">
																		Women
																	</a>
																	<br />
																</li>
															</ul>
															<script>
																document.getElementById('rhtNav_bg').style.display='block';
															</script>
														</div>
														<p
															style="clear: both;" />
													</div><!--rhtNav_bg-->
													<div id="pageTitle"
														class="pageTitle">
														<a
															name="content" />
														Digital Resource
														Commons
													</div>
													<!--
														Goes over the document tag's children element: body. The body template
														generates the ds-body div that contains all the content. The ds-options template 
														was already called above. 
														The meta element does not need to be called here because it is
														instead referenced from the different points in the document. -->
													<xsl:apply-templates
														select="dri:body" />

													<div
														id="textFoot_wrap" style="margin-right: 210px;">
														<div
															id="dateModified">
															Page
															updated:
															January 07,
															2008
														</div>
														<div
															id="pageTop">
															<a href="#"
																class="up" id="__top">
																Page top
															</a>
														</div>
													</div><!-- textFoot_wrap -->
												</div><!-- textHold -->
											</div>
											<!--textHold_wrap" -->
										</div><!-- navContentOverflow -->
									</div><!--navContent_wrap-->

									<!--
										The footer div, dropping whatever extra information is needed on the page. It will
										most likely be something similar in structure to the currently given example. -->
									<div class="ends"></div>
								</div><!-- content_wrap -->
							</div><!-- content_left -->
						</div><!-- content_rht -->
						<xsl:call-template name="buildFooter" />
					</div><!-- layout_wrap -->
				</div><!-- no padding no margin center -->
				
<!-- 1/2009 JRD Including Google Analytics JavaScript just before close of body tag. -->
				<script type="text/javascript">
var gaJsHost = (("https:" == document.location.protocol) ? "https://ssl." : "http://www.");
document.write(unescape("%3Cscript src='" + gaJsHost + "google-analytics.com/ga.js' type='text/javascript'%3E%3C/script%3E"));
</script>
<script type="text/javascript">
try {
var pageTracker = _gat._getTracker("UA-5946124-11");
pageTracker._trackPageview();
} catch(err) {}</script>

			</body>
		</html>
	</xsl:template>

	<!--
		The template to handle dri:options. Since it contains only dri:list tags (which carry the actual
		information), the only things than need to be done is creating the ds-options div and applying
		the templates inside it.
		
		This builds the search box and then calls templates to build the remaining options
		boxes.
	-->
	<!-- TODO: figure out why i18n tags break the go button -->
	<xsl:template match="dri:options">
		<div id="ds-options">

			
			<!-- Not building search here, so the other parts of the options are added -->
			<xsl:apply-templates />
		</div>
	</xsl:template>


	<!-- style the options head to look like UT menus -->

	<xsl:template match="dri:options/dri:list/dri:head" priority="3">
		<div>
			<xsl:call-template name="standardAttributes">
				<xsl:with-param name="class">navHead</xsl:with-param>
			</xsl:call-template>
			<xsl:apply-templates />
		</div>
	</xsl:template>


	<!-- Quick patch to remove empty lists from options -->
	<xsl:template match="dri:options//dri:list[count(child::*)=0]"
		priority="5" mode="nested">
	</xsl:template>
	<xsl:template match="dri:options//dri:list[count(child::*)=0]"
		priority="5">
	</xsl:template>


	<!-- This one is needed so that browse doesn't disappear -->
	<xsl:template match="dri:options/dri:list[dri:list]" priority="4">
		<xsl:apply-templates select="dri:head" />
		<div>
			<xsl:call-template name="standardAttributes">
				<xsl:with-param name="class">
					lftNav_wrap
				</xsl:with-param>
			</xsl:call-template>
			<ul class="ds-options-list">
				<xsl:apply-templates select="*[not(name()='head')]"
					mode="nested" />
			</ul>
		</div>
	</xsl:template>

	<!-- Special case for nested options lists -->
	<xsl:template match="dri:options/dri:list/dri:list" priority="3"
		mode="nested">
		<li>
			<xsl:apply-templates select="dri:head" mode="nested" />
			<ul class="">
				<xsl:apply-templates select="dri:item" mode="nested" />
			</ul>
		</li>
	</xsl:template>

	<!-- style subheader on sub lists -->
	<xsl:template match="dri:options/dri:list/dri:list/dri:head"
		priority="3" mode="nested">
		<xsl:call-template name="standardAttributes">
			<xsl:with-param name="class">
				ds-options-sublist-banner
			</xsl:with-param>
		</xsl:call-template>
		<xsl:apply-templates />
	</xsl:template>

	<!-- style simple lists, like "My Account", to look like UT Menus -->
	<xsl:template match="dri:options/dri:list" priority="3">
		<xsl:apply-templates select="dri:head" />
		<div>
			<xsl:call-template name="standardAttributes">
				<xsl:with-param name="class">
					lftNav_wrap
				</xsl:with-param>
			</xsl:call-template>
			<ul class="ds-simple-list">
				<xsl:apply-templates select="dri:item" mode="nested" />
			</ul>
		</div>
	</xsl:template>

</xsl:stylesheet>
