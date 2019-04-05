<%--

    The contents of this file are subject to the license and copyright
    detailed in the LICENSE and NOTICE files at the root of the source
    tree and available online at

    http://www.dspace.org/license/

--%>
<%--
  - Displays a message indicating the user has logged out
  --%>

<%@ page contentType="text/html;charset=UTF-8" %>

<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt"
    prefix="fmt" %>

<%@ taglib uri="http://www.dspace.org/dspace-tags.tld" prefix="dspace" %>

<dspace:layout locbar="off" titlekey="jsp.login.logged-out.title">
    <%-- <h1>Logged Out</h1> --%>
    <h1><fmt:message key="jsp.login.logged-out.title"/></h1>

    <%-- <p>Thank you for remembering to log out!</p> --%>
    <p><fmt:message key="jsp.login.logged-out.thank"/></p>
    <%-- <p><a href="<%= request.getContextPath() %>/">Go to DSpace Home</a></p> --%>
    <p><a href="<%= request.getContextPath() %>/mydspace"><fmt:message key="ub.jsp.login.logged-out.login"/></a></p>
    <p><a href="http://munin.uit.no"><fmt:message key="jsp.general.gohome"/></a></p>

</dspace:layout>
