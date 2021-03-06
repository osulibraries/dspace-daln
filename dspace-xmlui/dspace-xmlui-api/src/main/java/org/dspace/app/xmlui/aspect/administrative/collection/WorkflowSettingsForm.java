/*
 *
 * Version: $Revision: 1.0 $
 *
 * Date: $Date: 2006/07/13 23:20:54 $
 *
 * Copyright (c) 2002, Hewlett-Packard Company and Massachusetts
 * Institute of Technology.  All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions are
 * met:
 *
 * - Redistributions of source code must retain the above copyright
 * notice, this list of conditions and the following disclaimer.
 *
 * - Redistributions in binary form must reproduce the above copyright
 * notice, this list of conditions and the following disclaimer in the
 * documentation and/or other materials provided with the distribution.
 *
 * - Neither the name of the Hewlett-Packard Company nor the name of the
 * Massachusetts Institute of Technology nor the names of their
 * contributors may be used to endorse or promote products derived from
 * this software without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
 * ``AS IS'' AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
 * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
 * A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
 * HOLDERS OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT,
 * INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING,
 * BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS
 * OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
 * ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR
 * TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE
 * USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH
 * DAMAGE.
 */
package org.dspace.app.xmlui.aspect.administrative.collection;

import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Enumeration;
import java.util.HashMap;

import org.apache.cocoon.environment.ObjectModelHelper;
import org.apache.cocoon.environment.Request;
import org.dspace.app.xmlui.aspect.administrative.FlowContainerUtils;
import org.dspace.app.xmlui.cocoon.AbstractDSpaceTransformer;
import org.dspace.app.xmlui.wing.Message;
import org.dspace.app.xmlui.wing.WingException;
import org.dspace.app.xmlui.wing.element.Body;
import org.dspace.app.xmlui.wing.element.Button;
import org.dspace.app.xmlui.wing.element.Division;
import org.dspace.app.xmlui.wing.element.Item;
import org.dspace.app.xmlui.wing.element.List;
import org.dspace.app.xmlui.wing.element.Option;
import org.dspace.app.xmlui.wing.element.PageMeta;
import org.dspace.app.xmlui.wing.element.Para;
import org.dspace.app.xmlui.wing.element.Radio;
import org.dspace.app.xmlui.wing.element.Select;
import org.dspace.app.xmlui.wing.element.Text;
import org.dspace.authorize.AuthorizeException;
import org.dspace.authorize.AuthorizeManager;
import org.dspace.content.Collection;
import org.dspace.harvest.HarvestedCollection;
import org.dspace.harvest.OAIHarvester;
import org.dspace.core.ConfigurationManager;


/**
 */
public class WorkflowSettingsForm extends CollectionFormBase
{
	/** Language Strings */
	private static final Message T_title = message("xmlui.administrative.collection.WorkflowSettingsForm.title");
	private static final Message T_trail = message("xmlui.administrative.collection.WorkflowSettingsForm.trail");
	
	private static final Message T_label = message("xmlui.administrative.collection.WorkflowSettingsForm.label");
	private static final Message T_review_pre = message("xmlui.administrative.collection.WorkflowSettingsForm.review_pre");
	private static final Message T_review_post = message("xmlui.administrative.collection.WorkflowSettingsForm.review_post");

	private static final Message T_submit_return = message("xmlui.general.return");
	private static final Message T_submit_save = message("xmlui.administrative.collection.WorkflowSettingsForm.submit_save");
	
	
	public void addPageMeta(PageMeta pageMeta) throws WingException
    {
        pageMeta.addMetadata("title").addContent(T_title);
        pageMeta.addTrailLink(contextPath + "/", T_dspace_home);
        pageMeta.addTrail().addContent(T_collection_trail);
        pageMeta.addTrail().addContent(T_trail);
    }
	
	
	public void addBody(Body body) throws WingException, SQLException, AuthorizeException
	{
		int collectionID = parameters.getParameterAsInteger("collectionID", -1);
		Collection thisCollection = Collection.find(context, collectionID);
	    boolean isPostReview = thisCollection.isPostReview();
	    
		// DIVISION: main
	    Division main = body.addInteractiveDivision("collection-harvesting-setup",contextPath+"/admin/collection",Division.METHOD_MULTIPART,"primary administrative collection");
	    main.setHead(T_main_head.parameterize(thisCollection.getMetadata("name")));   
	    
	    addTabs(main, T_options_workflow);
	    
	    List reviewSettings = main.addList("workflowSettings", "form");
	    
	    reviewSettings.addLabel(T_label);
	    Radio source = reviewSettings.addItem().addRadio("review");
    	source.addOption(!isPostReview, "review_pre", T_review_pre);
    	source.addOption(isPostReview, "review_post", T_review_post);
   
		Para buttonList = main.addPara();
	    buttonList.addButton("submit_save").setValue(T_submit_save);
	    buttonList.addButton("submit_return").setValue(T_submit_return);
	    
    	main.addHidden("administrative-continue").setValue(knot.getId());
    }
	
}
