package org.dspace.app.xmlui.aspect.lists;

import org.apache.log4j.Logger;
import org.dspace.app.xmlui.aspect.tagging.TagConsumer;
import org.dspace.app.xmlui.aspect.tagging.TagManager;
import org.dspace.content.DSpaceObject;
import org.dspace.core.Constants;
import org.dspace.core.Context;
import org.dspace.event.Consumer;
import org.dspace.event.Event;
import org.dspace.search.DSIndexer;

public class ListConsumer implements Consumer {

    /** log4j logger */
    private static Logger log = Logger.getLogger(ListConsumer.class);

    public void initialize() throws Exception {
	}

	public void consume(Context ctx, Event event) throws Exception {
        log.debug("consume() evaluating event: " + event.toString());
        
        
        int st = event.getSubjectType();
        int et = event.getEventType();
        
        switch (st)
        {
        case Constants.ITEM:
        	// XXX this is technically incorrect, because the item has already been deleted.
            if(et == Event.DELETE)
            {
                DSpaceObject subj = event.getSubject(ctx);
                if (subj != null)
                {
                	ListUtils.handle_item_delete(ctx, subj.getID());
                }
            }
            break;
        case Constants.EPERSON:
            if (et == Event.DELETE)
            {
                DSpaceObject subj = event.getSubject(ctx);
                if (subj != null)
                {
                	ListUtils.handle_eperson_delete(ctx, subj.getID());
                }
            }
            break;
        default:
            log.debug("consume() ingnoring event: " + event.toString());
        }
	}

	public void end(Context ctx) throws Exception {
        ctx.getDBConnection().commit();
	}

	public void finish(Context ctx) throws Exception {
	}

}
