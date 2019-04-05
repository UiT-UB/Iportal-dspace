<%--

    The contents of this file are subject to the license and copyright
    detailed in the LICENSE and NOTICE files at the root of the source
    tree and available online at

    http://www.dspace.org/license/

--%>
<%--
  - License rejected page
  --%>

<%@ page contentType="text/html;charset=UTF-8" %>

<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt"
    prefix="fmt" %>

<%@ taglib uri="http://www.dspace.org/dspace-tags.tld" prefix="dspace" %>

<%@ page import="org.dspace.core.I18nUtil" %>
<%@ page import="org.dspace.core.Context" %>
<%@ page import="org.dspace.app.webui.util.UIUtil" %>
<%@ page import="org.dspace.app.webui.servlet.SubmissionController" %>
<%@ page import="org.dspace.app.util.Util" %>
<%@ page import="org.dspace.app.util.SubmissionInfo" %>

<%
      // Obtain DSpace context
      Context context = UIUtil.obtainContext(request);

      //get submission information object
      SubmissionInfo subInfo = SubmissionController.getSubmissionInfo(context, request);

      String drOrMaster = I18nUtil.getMessage("ub.jsp.submit.license-rejected.master", UIUtil.getSessionLocale(request));
      if(Util.isDr(subInfo.getSubmissionItem().getItem())){
	  drOrMaster = I18nUtil.getMessage("ub.jsp.submit.license-rejected.doctor");
      }
%>

<% request.setAttribute("LanguageSwitch", "hide"); %>

<dspace:layout style="submission" navbar="off" locbar="off" titlekey="jsp.submit.license-rejected.title">

    <%-- <h1>Submit: License Rejected</h1> --%>
	<h1><fmt:message key="jsp.submit.license-rejected.heading"><fmt:param><%= drOrMaster %></fmt:param></fmt:message></h1>
    
    <%-- <p>You have chosen not to grant the license to distribute your submission
    via the DSpace system.  Your submission has not been deleted and can be
    accessed from the My DSpace page.</p> --%>
	<p><fmt:message key="jsp.submit.license-rejected.info1"><fmt:param><%= drOrMaster %></fmt:param></fmt:message></p>
    
    <%-- <p>If you wish to contact us to discuss the license, please use one
    of the methods below:</p> --%>
	<p class="alert alert-danger"><fmt:message key="jsp.submit.license-rejected.info2"><fmt:param><%= drOrMaster %></fmt:param></fmt:message></p>

    <%-- <dspace:include page="/components/contact-info.jsp" /> --%>

    <%-- <p><a href="<%= request.getContextPath() %>/mydspace">Go to My DSpace</a></p> --%>
	<p><a href="<%= request.getContextPath() %>/mydspace"><fmt:message key="jsp.mydspace.general.goto-mydspace"/></a></p>

</dspace:layout>
