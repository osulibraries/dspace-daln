<%--
  - eperson-browse.jsp
  -
  - Version: $Revision: 3705 $
  -
  - Date: $Date: 2009-04-11 13:02:24 -0400 (Sat, 11 Apr 2009) $
  -
  - Copyright (c) 2002, Hewlett-Packard Company and Massachusetts
  - Institute of Technology.  All rights reserved.
  -
  - Redistribution and use in source and binary forms, with or without
  - modification, are permitted provided that the following conditions are
  - met:
  -
  - - Redistributions of source code must retain the above copyright
  - notice, this list of conditions and the following disclaimer.
  -
  - - Redistributions in binary form must reproduce the above copyright
  - notice, this list of conditions and the following disclaimer in the
  - documentation and/or other materials provided with the distribution.
  -
  - - Neither the name of the Hewlett-Packard Company nor the name of the
  - Massachusetts Institute of Technology nor the names of their
  - contributors may be used to endorse or promote products derived from
  - this software without specific prior written permission.
  -
  - THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
  - ``AS IS'' AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
  - LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
  - A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
  - HOLDERS OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT,
  - INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING,
  - BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS
  - OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
  - ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR
  - TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE
  - USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH
  - DAMAGE.
  --%>


<%--
  - Display list of E-people, with pagination
  -
  - Attributes:
  -
  -   epeople    - EPerson[] - all epeople to browse
  -   page_size  - size of pages (number of epeople per page)
  -   page_index - current page to display
  -   page_count - number of pages
  --%>

<%@ page contentType="text/html;charset=UTF-8" %>

<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt"
    prefix="fmt" %>

<%@ taglib uri="http://www.dspace.org/dspace-tags.tld" prefix="dspace" %>

<%@ page import="org.dspace.eperson.EPerson" %>

<%
    EPerson[] epeople =
        (EPerson[]) request.getAttribute("epeople");
    int pageSize  = ((Integer)request.getAttribute("page_size" )).intValue();
    int pageIndex = ((Integer)request.getAttribute("page_index")).intValue();
    int pageCount = ((Integer)request.getAttribute("page_count")).intValue();

    int firstEPerson = pageSize*pageIndex;
    int lastEPerson  = firstEPerson + (pageSize - 1);  // index of last person
                                                       // most common case is full page

    if (lastEPerson >= epeople.length)
    {
        // oops, less than a full page left, trim
        lastEPerson = -1 + firstEPerson + ((epeople.length-firstEPerson) % pageSize); 
    }


    String previousButton = "";
    String nextButton     = "";

    if (pageIndex > 0)
    {
        // not at start, so create 'previous' button
        previousButton = "<input type=\"hidden\" name=\"page_index\" value=\"" + pageIndex + "\"/>" +
                         "<input type=\"hidden\" name=\"page_request\" value=\"previous\"/> "       +
                         "<input type=\"submit\" name=\"submit_browse\" value=\"Previous\"/>";
    }

    if (pageIndex < (pageCount-1) )
    {
        // not showing last either, so create 'next' button
        nextButton = "<input type=\"hidden\" name=\"page_index\" value=\"" + pageIndex + "\"/>" +
                         "<input type=\"hidden\" name=\"page_request\" value=\"next\"/> "       +
                         "<input type=\"submit\" name=\"submit_browse\" value=\"Next\"/>";
    }

%>

<dspace:layout titlekey="jsp.dspace-admin.eperson-browse.title"
               navbar="admin"
               locbar="link"
               parenttitlekey="jsp.administer"
               parentlink="/dspace-admin">

    <%-- <h1>Browse EPeople <%=firstEPerson%>-<%=lastEPerson%> of <%=epeople.length%></h1> --%>
    <h1><fmt:message key="jsp.dspace-admin.eperson-browse.heading">
        <fmt:param><%=firstEPerson%></fmt:param>
        <fmt:param><%=lastEPerson%></fmt:param>
        <fmt:param><%=epeople.length%></fmt:param>
    </fmt:message></h1>

    <table class="miscTable" align="center" summary="Browse E-people">
        <tr>
            <th id="t1" class="oddRowOddCol"> <strong><a href="<%= request.getContextPath() %>/dspace-admin/edit-epeople?submit_browse=1&sortby=id">ID</a></strong></th>
            <%-- <th class="oddRowEvenCol"><strong><a href="<%= request.getContextPath() %>/dspace-admin/edit-epeople?submit_browse=1&sortby=email">E-mail Address</a></strong></th> --%>
            <th id="t2" class="oddRowEvenCol"><strong><a href="<%= request.getContextPath() %>/dspace-admin/edit-epeople?submit_browse=1&sortby=email"><fmt:message key="jsp.dspace-admin.eperson-browse.email"/></a></strong></th>
            <%-- <th class="oddRowOddCol"> <strong><a href="<%= request.getContextPath() %>/dspace-admin/edit-epeople?submit_browse=1&sortby=lastname">Last Name</a></strong></th> --%>
            <th id="t3" class="oddRowOddCol"> <strong><a href="<%= request.getContextPath() %>/dspace-admin/edit-epeople?submit_browse=1&sortby=lastname"><fmt:message key="jsp.dspace-admin.eperson.general.lastname"/></a></strong></th>
            <%-- <th class="oddRowEvenCol"><strong>First Name</strong></th> --%>
            <th id="t4" class="oddRowEvenCol"><strong><fmt:message key="jsp.dspace-admin.eperson.general.lastname"/></strong></th>
            <%-- <th class="oddRowOddCol"> <strong>Can Log In?</strong></th> --%>
            <th id="t5" class="oddRowOddCol"> <strong><fmt:message key="jsp.dspace-admin.eperson-browse.canlogin"/></strong></th>
            <%-- <th class="oddRowEvenCol"><strong>Must Use Cert?</strong></th> --%>
            <th id="t6" class="oddRowEvenCol"><strong><fmt:message key="jsp.dspace-admin.eperson-browse.mustusecert"/></strong></th>
            <%-- <th class="oddRowOddCol"> <strong>Self Registered</strong></th> --%>
            <th id="t7" class="oddRowOddCol"> <strong><fmt:message key="jsp.dspace-admin.eperson-browse.self"/></strong></th>
            <%-- <th class="oddRowEvenCol"><strong>Telephone</strong></th> --%>
            <th id="t8" class="oddRowEvenCol"><strong><fmt:message key="jsp.dspace-admin.eperson-browse.phone"/></strong></th>
            <th id="t9" class="oddRowOddCol">&nbsp;</th>
            <th id="t10" class="oddRowEvenCol">&nbsp;</th>
        </tr>

<%
    String row = "even";
    for (int i = firstEPerson; i <= lastEPerson; i++)
    {
        EPerson e = epeople[i];
        String commandString = request.getContextPath() + "/dspace-admin/edit-epeople?submit_edit&amp;eperson_id=" + e.getID();
%>
        <form method="post" action="<%= request.getContextPath() %>/dspace-admin/edit-epeople">
            <tr>
                <td headers="t1" class="<%= row %>RowOddCol"><%= e.getID() %></td>
                <td headers="t2" class="<%= row %>RowEvenCol">
                    <%= (e.getEmail() == null ? "" : e.getEmail()) %>
                </td>
                <td headers="t3" class="<%= row %>RowOddCol">
                    <%= (e.getLastName() == null ? "" : e.getLastName()) %>
                </td>
                <td headers="t4" class="<%= row %>RowEvenCol">
                    <%= (e.getFirstName() == null ? "" : e.getFirstName()) %>
                </td>
                <td headers="t5" class="<%= row %>RowOddCol" align="center">
                    <%= e.canLogIn() ? "yes" : "no" %>
                </td>
                <td headers="t6" class="<%= row %>RowEvenCol" align="center">
                    <%= e.getRequireCertificate() ? "yes" : "no" %>
                </td>
                <td headers="t7" class="<%= row %>RowOddCol">
                    <%= e.getSelfRegistered() ? "yes" : "no" %>
                </td>
                <td headers="t8" class="<%= row %>RowEvenCol">
                    <%= (e.getMetadata("phone") == null ? "" : e.getMetadata("phone")) %>
                </td>
                <td headers="t9" class="<%= row %>RowOddCol">
                    <input type="hidden" name="eperson_id" value="<%= e.getID() %>"/>
<%      if (request.getParameter("sortby") != null) { %>
                    <input type="hidden" name="sortby" value="<%= request.getParameter("sortby") %>"/>
<%      } %>
                    <%-- <input type="submit" name="submit_edit" value="Edit..."> --%>
                    <input type="submit" name="submit_edit" value="<fmt:message key="jsp.dspace-admin.general.edit"/>" />
                </td>
                <td headers="t10" class="<%= row %>RowEvenCol">
                    <%-- <input type="submit" name="submit_delete" value="Delete..."> --%>
                    <input type="submit" name="submit_delete" value="<fmt:message key="jsp.dspace-admin.general.delete-w-confirm"/>" />
                </td>
            </tr>
        </form>
<%
        row = (row.equals("odd") ? "even" : "odd");
    }
%>
    </table>

    <form method="post" action="">
    <%=previousButton%>
    </form>

    <form method="post" action="">
    <%=nextButton%>
    </form>


</dspace:layout>
