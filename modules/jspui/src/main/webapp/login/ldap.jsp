 <%--

    The contents of this file are subject to the license and copyright
    detailed in the LICENSE and NOTICE files at the root of the source
    tree and available online at

    http://www.dspace.org/license/

--%>
<%--
  - Page that displays the netid/password login form
  --%>

<%@ page contentType="text/html;charset=UTF-8" %>

<%@ taglib uri="http://www.dspace.org/dspace-tags.tld" prefix="dspace" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<%@ page import="javax.servlet.jsp.jstl.fmt.LocaleSupport" %>

<dspace:layout navbar="default" locbar="off" titlekey="jsp.login.ldap.title" nocache="true">
  <div class="panel panel-primary">
    <div class="panel-heading">
      <fmt:message key="jsp.login.ldap.heading"/>
      <%--<span class="pull-right"><dspace:popup page="<%= LocaleSupport.getLocalizedMessage(pageContext, \"help.index\") + \"#login\"%>"><fmt:message key="jsp.help"/></dspace:popup></span>--%>
    </div>
    <dspace:include page="/components/ldap-form.jsp" />
  </div>
</dspace:layout>