/*
 * Upgrade11To12.java
 *
 * Version: $Revision: 3733 $
 *
 * Date: $Date: 2009-04-23 23:52:11 -0400 (Thu, 23 Apr 2009) $
 *
 * Copyright (c) 2002-2009, The DSpace Foundation.  All rights reserved.
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
 * - Neither the name of the DSpace Foundation nor the names of its
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
package org.dspace.administer;

import org.dspace.content.Bitstream;
import org.dspace.content.BitstreamFormat;
import org.dspace.content.Bundle;
import org.dspace.content.Collection;
import org.dspace.content.Item;
import org.dspace.content.ItemIterator;
import org.dspace.core.Context;

/**
 * Command-line tool for making changes to DSpace database when updating from
 * version 1.1/1.1.1 to 1.2.
 * <P>
 * The changes are:
 * <ul>
 * <li>Setting owning collection field for items
 * <li>Reorganising content bitstreams into one bundle named ORIGINAL, license
 * bitstreams into a bundle named LICENSE
 * <li>Setting the sequence_id numbers in the bitstream table. This happens as
 * item.update() is called on every item.
 * <li>If a (newly-reorganised) 'ORIGINAL' bundle contains a text/html
 * bitstream, that bitstream is set to the primary bitstream for HTML support.
 * </ul>
 */
public class Upgrade11To12
{
    public static void main(String[] argv) throws Exception
    {
        Context c = new Context();

        // ve are superuser!
        c.setIgnoreAuthorization(true);

        ItemIterator ii = null;

        // first set owning Collections
        Collection[] collections = Collection.findAll(c);

        System.out.println("Setting item owningCollection fields in database");

        for (int q = 0; q < collections.length; q++)
        {
            ii = collections[q].getItems();

            while (ii.hasNext())
            {
                Item myItem = ii.next();

                // set it if it's not already set
                if (myItem.getOwningCollection() == null)
                {
                    myItem.setOwningCollection(collections[q]);
                    myItem.update();
                    System.out.println("Set owner of item " + myItem.getID()
                            + " to collection " + collections[q].getID());
                }
            }
        }

        // commit pending transactions before continuing
        c.commit();

        // now combine some bundles
        ii = Item.findAll(c);

        while (ii.hasNext())
        {
            boolean skipItem = false;
            Item myItem = ii.next();

            int licenseBundleIndex = -1; // array index of license bundle (we'll
                                         // skip this one often)
            int primaryBundleIndex = -1; // array index of our primary bundle
                                         // (all bitstreams assemble here)

            System.out.println("Processing item #: " + myItem.getID());

            Bundle[] myBundles = myItem.getBundles();

            // look for bundles with multiple bitstreams
            // (if any found, we'll skip this item)
            for (int i = 0; i < myBundles.length; i++)
            {
                // skip if bundle is already named
                if (myBundles[i].getName() != null)
                {
                    System.out
                            .println("Skipping this item - named bundles already found");
                    skipItem = true;

                    break;
                }

                Bitstream[] bitstreams = myBundles[i].getBitstreams();

                // skip this item if we already have bundles combined in this
                // item
                if (bitstreams.length > 1)
                {
                    System.out
                            .println("Skipping this item - compound bundles already found");
                    skipItem = true;

                    break;
                }

                // is this the license? check the format
                BitstreamFormat bf = bitstreams[0].getFormat();

                if (bf.getShortDescription().equals("License"))
                {
                    System.out.println("Found license!");

                    if (licenseBundleIndex == -1)
                    {
                        licenseBundleIndex = i;
                        System.out.println("License bundle set to: " + i);
                    }
                    else
                    {
                        System.out
                                .println("ERROR - multiple license bundles in item - skipping");
                        skipItem = true;

                        break;
                    }
                }
                else
                {
                    // not a license, if primary isn't set yet, set it
                    if (primaryBundleIndex == -1)
                    {
                        primaryBundleIndex = i;
                        System.out.println("Primary bundle set to: " + i);
                    }
                }
            }

            if (!skipItem)
            {
                // name the primary and license bundles
                if (primaryBundleIndex != -1)
                {
                    myBundles[primaryBundleIndex].setName("ORIGINAL");
                    myBundles[primaryBundleIndex].update();
                }

                if (licenseBundleIndex != -1)
                {
                    myBundles[licenseBundleIndex].setName("LICENSE");
                    myBundles[licenseBundleIndex].update();
                }

                for (int i = 0; i < myBundles.length; i++)
                {
                    Bitstream[] bitstreams = myBundles[i].getBitstreams();

                    // now we can safely assume no bundles with multiple
                    // bitstreams
                    if (bitstreams.length > 0)
                    {
                        if ((i != primaryBundleIndex)
                                && (i != licenseBundleIndex))
                        {
                            // only option left is a bitstream to be combined
                            // with primary bundle
                            // and remove now-redundant bundle
                            myBundles[primaryBundleIndex]
                                    .addBitstream(bitstreams[0]); // add to
                                                                  // primary
                            myItem.removeBundle(myBundles[i]); // remove this
                                                               // bundle

                            System.out.println("Bitstream from bundle " + i
                                    + " moved to primary bundle");

                            // flag if HTML bitstream
                            if (bitstreams[0].getFormat().getMIMEType().equals(
                                    "text/html"))
                            {
                                System.out
                                        .println("Set primary bitstream to HTML file in item #"
                                                + myItem.getID()
                                                + " for HTML support.");
                            }
                        }
                    }
                }
            }
        }

        c.complete();
    }
}
