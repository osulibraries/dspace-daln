<?xml version="1.0" encoding="UTF-8"?>

<!--
    DALN REVISION HISTORY [Locate revisions by searching for revision code]  
    HLU_080806a: Added "xsl:if" test to check for dri:label and add appropriate link
    HLU_080808a: Open links in new window, add titles to links, add consent and release links.
    HLU_080928a: Added previous "hint" text to "link" text. Removed Deed of Gift option.
    HLU_081009a: Changed text of consent and release help text.
    HLU 081117a: XPath predicates used to suppress table rows with provenance information.
    HLU 130903a: Repositioning "hint" text for Description field to here in order to use HTML.
-->   
<!--
  template.xsl

  Version: $Revision: 1.7 $
 
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
<!-- OhioLINK 2008-04-28 KRG * Changing to use ohiolink_common import -->

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
    <xsl:output indent="yes"/>
    
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
				
<!-- Code to track file downloads via Google analytics -->
<script src="http://daln.osu.edu/themes/daln/scripts/gatag.js" type="text/javascript"></script>

<!-- Code implementing Google analytics -->
				<script type="text/javascript">
var gaJsHost = (("https:" == document.location.protocol) ? "https://ssl." : "http://www.");
document.write(unescape("%3Cscript src='" + gaJsHost + "google-analytics.com/ga.js' type='text/javascript'%3E%3C/script%3E"));
</script>
<script type="text/javascript">
try {
var pageTracker = _gat._getTracker("UA-5946124-5");
pageTracker._trackPageview();
} catch(err) {}</script>

            </body>
        </html>
    </xsl:template>


    
    <!-- HLU 081117a: Predicates used here to suppress only rows with provenance information. -->   
    <xsl:template match="dri:list[not(@type)]/dri:item[dri:label!='dc.description.provenance']" priority="2" mode="labeled">
        <tr>
            <xsl:attribute name="class">
                <xsl:text>ds-table-row </xsl:text>
                <xsl:if test="(position() mod 2 = 0)">even </xsl:if>
                <xsl:if test="(position() mod 2 = 1)">odd </xsl:if>
                <xsl:value-of select="@rend"/>
            </xsl:attribute>
            <xsl:if test="name(preceding-sibling::*[position()=1]) = 'label'">
                <xsl:apply-templates select="preceding-sibling::*[position()=1]" mode="labeled"/>
            </xsl:if>
            <td>
                <xsl:apply-templates />
            </td>
        </tr>
    </xsl:template>
    <xsl:template match="dri:list[not(@type)]/dri:item[dri:label='dc.description.provenance']" priority="2" mode="labeled"/>
        
    <xsl:template match="dri:list[not(@type)]/dri:label" priority="2" mode="labeled">
        <td>
            <xsl:if test="count(./node())>0">
                <span>
                    <xsl:attribute name="class">
                        <xsl:text>ds-gloss-list-label </xsl:text>
                        <xsl:value-of select="@rend"/>
                    </xsl:attribute>
                    <xsl:apply-templates />
                    <xsl:text>:</xsl:text>
                </span>
            </xsl:if>
        </td>
    </xsl:template>

    <xsl:template match="dri:field" mode="normalField">
        <xsl:choose>
            <!-- TODO: this has changed drammatically (see form3.xml) -->
			<xsl:when test="@type= 'select'">
				<select>
				    <xsl:call-template name="fieldAttributes"/>
				    <xsl:apply-templates/>
				</select>
			</xsl:when>
            <xsl:when test="@type= 'textarea'">
				<textarea>
				    <xsl:call-template name="fieldAttributes"/>
				    
				    <!--  
				    	if the cols and rows attributes are not defined we need to call
				     	the tempaltes for them since they are required attributes in strict xhtml
				     -->
				    <xsl:choose>
				    	<xsl:when test="not(./dri:params[@cols])">
							<xsl:call-template name="textAreaCols"/>
				    	</xsl:when>
				    </xsl:choose>
				    <xsl:choose>
				    	<xsl:when test="not(./dri:params[@rows])">
				    		<xsl:call-template name="textAreaRows"/>
				    	</xsl:when>
				    </xsl:choose>
				    
				    <xsl:apply-templates />
				    <xsl:choose>
				        <xsl:when test="./dri:value[@type='raw']">
				            <xsl:copy-of select="./dri:value[@type='raw']/node()"/>
				        </xsl:when>
				        <xsl:otherwise>
				            <xsl:copy-of select="./dri:value[@type='default']/node()"/>
				        </xsl:otherwise>
				    </xsl:choose>
				    <xsl:if  test="string-length(./dri:value) &lt; 1">
				       <i18n:text>xmlui.dri2xhtml.default.textarea.value</i18n:text>
				    </xsl:if>				    
				</textarea>
                
            <!-- HLU 130903a: Repositioning "hint" text for Description field to here in order to use HTML. -->
            	<xsl:if test="dri:label='Description'">
                <br/>
				        <span class="field-help">
				            To help other DALN users find your literacy narrative, 
				            please describe your literacy narrative briefly in this box (optional). 
				            <br/>
                            <br/>
				            <strong>NOTE</strong>: If you would like to assign a <strong>Creative Commons</strong> (CC) license to 
				            your narrative, thereby retaining ownership while specifying the uses that others 
				            may make of your narrative, please visit the Creative Commons site at 
				            <a href="http://creativecommons.org/choose/" target="_blank">http://creativecommons.org/choose/</a>, 
				            choose a license, then place a license notification to this field, including the name 
				            of the CC license (e.g., “My Narrative’s Title” by Lewis Ulman is licensed under a 
				            Creative Commons Attribution-NonCommercial-NoDerivs 3.0 Unported License).
				            <br/>
                            <br/>
				            If you wish to contribute your narrative under a <strong>Deed of Gift</strong>, 
				            thereby transferring ownership of your narrative to the DALN, 
				            which will establish its own guidelines for usage, you will have an opportunity to do so 
				            at the end of the submission process. (Optional)
				        </span>
                        
				 </xsl:if>

            </xsl:when>
            <!-- This is changing drammatically -->
            
            <xsl:when test="@type= 'checkbox' or @type= 'radio'">
                
                <!-- HLU_081009a modification begins here -->
                <!-- HLU_080928a modification begins here -->
                <!-- HLU_080808a modification begins here -->
                <xsl:if test="dri:label='Consent to Participate'">
                    <span class="field-help">Because we value your right to make an informed decision to participate
                        in the DALN, we must have your consent before we accept a submission. 
                        Please click one of the following links to read our 
                            <a href="http://dalnresources.org.ohio-state.edu/adultconsent.html" target="_blank" title="Adult Consent Form">
                             Adult Consent Form</a> or 
                        <a href="http://dalnresources.org.ohio-state.edu/minorconsent.html" target="_blank" title="Under-18 Consent Form"> 
                            Under-18 Consent Form</a> before completing this field. Then you must select
                        either &quot;Adult&quot; or &quot;Under-18&quot; below to
                        affirm that you have read and agreed to the terms of the appropriate consent
                        form.
                    </span>
                    <br/>
                </xsl:if>
                <xsl:if test="dri:label='Release for Materials'">
                    <span class="field-help">Because we want you to know how your materials and personal information will
                        be used in the DALN, we must have your release before we accept a submission. 
                        Please click one of the following links to read our 
                        <a href="http://dalnresources.org.ohio-state.edu/adultreleaseclick.html" target="_blank" title="Adult Release Form">
                            Adult Release Form</a> or 
                        <a href="http://dalnresources.org.ohio-state.edu/minorreleaseclick.html" target="_blank" title="Under-18 Release Form"> 
                            Under-18 Release Form</a> before completing this field. Then you must select
                        either &quot;Adult&quot; or &quot;Under-18&quot; below to
                        affirm that you have read and agreed to the terms of the appropriate release
                        form.
                    </span>
                    <br/>
                </xsl:if>
                <!-- HLU_080808a modification ends here -->
                <!-- HLU_080928a modification ends here -->
                <!-- HLU_081009a modification ends here -->
                
                <fieldset>
                    <xsl:call-template name="standardAttributes">
			            <xsl:with-param name="class">
			                <xsl:text>ds-</xsl:text><xsl:value-of select="@type"/><xsl:text>-field </xsl:text>
			                <xsl:if test="dri:error">
			                    <xsl:text>error </xsl:text>
			                </xsl:if>
			            </xsl:with-param>
			        </xsl:call-template> 
			        <xsl:attribute name="id"><xsl:value-of select="generate-id()"/></xsl:attribute>
                    <xsl:if test="dri:label">
                    	<legend><xsl:apply-templates select="dri:label" mode="compositeComponent" /></legend>
                    </xsl:if>
                    <xsl:apply-templates />
                </fieldset>
                
            </xsl:when>
            <!--
                <input>
		            <xsl:call-template name="fieldAttributes"/>
                    <xsl:if test="dri:value[@checked='yes']">
		                <xsl:attribute name="checked">checked</xsl:attribute>
                    </xsl:if>
                    <xsl:apply-templates/>
                </input>
                -->
            <xsl:when test="@type= 'composite'">
                <!-- TODO: add error and help stuff on top of the composite --> 
                <span class="ds-composite-field">
                    <xsl:apply-templates select="dri:field" mode="compositeComponent"/>
                </span>
                <xsl:apply-templates select="dri:field/dri:error" mode="compositeComponent"/>
                <xsl:apply-templates select="dri:error" mode="compositeComponent"/>
                <xsl:apply-templates select="dri:field/dri:help" mode="compositeComponent"/>
                <!--<xsl:apply-templates select="dri:help" mode="compositeComponent"/>-->
            </xsl:when>
		    <!-- text, password, file, and hidden types are handled the same. 
		        Buttons: added the xsl:if check which will override the type attribute button
		            with the value 'submit'. No reset buttons for now...
		    -->
		    <xsl:otherwise>
		        <input>
		            <xsl:call-template name="fieldAttributes"/>
		            <xsl:if test="@type='button'">
		                <xsl:attribute name="type">submit</xsl:attribute>
		            </xsl:if>
		            <xsl:attribute name="value">
		                <xsl:choose>
		                    <xsl:when test="./dri:value[@type='raw']">
		                        <xsl:value-of select="./dri:value[@type='raw']"/>
		                    </xsl:when>
		                    <xsl:otherwise>
		                        <xsl:value-of select="./dri:value[@type='default']"/>
		                    </xsl:otherwise>
		                </xsl:choose>
		            </xsl:attribute>
		            <xsl:if test="dri:value/i18n:text">
		                <xsl:attribute name="i18n:attr">value</xsl:attribute>
		            </xsl:if>
		            <xsl:apply-templates />
		        </input>
		    </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <!-- Hide Provenance Information -->
    <xsl:template match="dim:field" mode="itemDetailView-DIM">
        <xsl:if test="not(@element='description' and @qualifier='provenance')">
            <tr>
                <xsl:attribute name="class">
                    <xsl:text>ds-table-row </xsl:text>
                    <xsl:if test="(position() div 2 mod 2 = 0)">even </xsl:if>
                    <xsl:if test="(position() div 2 mod 2 = 1)">odd </xsl:if>
                </xsl:attribute>
                <td>
                    <xsl:value-of select="./@mdschema"/>
                    <xsl:text>.</xsl:text>
                    <xsl:value-of select="./@element"/>
                    <xsl:if test="./@qualifier">
                        <xsl:text>.</xsl:text>
                        <xsl:value-of select="./@qualifier"/>
                    </xsl:if>
                </td>
                <td><xsl:copy-of select="./node()"/></td>
                <td><xsl:value-of select="./@language"/></td>
            </tr>
        </xsl:if>
    </xsl:template>

	
</xsl:stylesheet>