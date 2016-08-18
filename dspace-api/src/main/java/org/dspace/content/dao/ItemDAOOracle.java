/*
 * ItemDAOOracle.java
 *
 * Version: $Revision: 3761 $
 *
 * Date: $Date: 2009-05-07 00:18:02 -0400 (Thu, 07 May 2009) $
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

package org.dspace.content.dao;

import org.dspace.core.Context;
import org.dspace.content.Bitstream;

import java.sql.SQLException;

public class ItemDAOOracle extends ItemDAO
{
    ItemDAOOracle(Context ctx)
    {
        super(ctx);
    }

    public Bitstream getPrimaryBitstream(int itemId, String bundleName) throws SQLException {
        return null;  //To change body of implemented methods use File | Settings | File Templates.
    }

    public Bitstream getFirstBitstream(int itemId, String bundleName) throws SQLException {
        return null;  //To change body of implemented methods use File | Settings | File Templates.
    }

    public Bitstream getNamedBitstream(int itemId, String bundleName, String fileName) throws SQLException {
        return null;  //To change body of implemented methods use File | Settings | File Templates.
    }
}
