<%--

    The contents of this file are subject to the license and copyright
    detailed in the LICENSE and NOTICE files at the root of the source
    tree and available online at

    http://www.dspace.org/license/

--%>
<%--
  - Show the user a license which they may grant or reject
  -
  - Attributes to pass in:
  -    license          - the license text to display
  --%>

<%@ page contentType="text/html;charset=UTF-8" %>

<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt"
    prefix="fmt" %>
 
<%@ page import="javax.servlet.jsp.jstl.fmt.LocaleSupport" %>

<%@ page import="org.dspace.core.Context" %>
<%@ page import="org.dspace.app.webui.servlet.SubmissionController" %>
<%@ page import="org.dspace.app.util.SubmissionInfo" %>
<%@ page import="org.dspace.app.webui.util.UIUtil" %>

<%@ page import="org.dspace.app.util.Util" %>
<%@ page import="org.dspace.core.I18nUtil" %>

<%@ taglib uri="http://www.dspace.org/dspace-tags.tld" prefix="dspace" %>

<%
    request.setAttribute("LanguageSwitch", "hide");

    // Obtain DSpace context
    Context context = UIUtil.obtainContext(request);    

	//get submission information object
    SubmissionInfo subInfo = SubmissionController.getSubmissionInfo(context, request);

    String license = (String) request.getAttribute("license");

    String drOrMaster = I18nUtil.getMessage("ub.jsp.submit.saved.master", UIUtil.getSessionLocale(request));
    if(Util.isDr(subInfo.getSubmissionItem().getItem())){
	drOrMaster = I18nUtil.getMessage("ub.jsp.submit.saved.doctor");
    }
%>

<dspace:layout style="submission"
			   locbar="off"
               navbar="off"
               titlekey="jsp.submit.show-license.title"
               nocache="true">

    <form action="<%= request.getContextPath() %>/submit" method="post" onkeydown="return disableEnterKey(event);">

        <jsp:include page="/submit/progressbar.jsp"/>

	<h1><fmt:message key="jsp.submit.show-license.title" />
	<%--<dspace:popup page="<%= LocaleSupport.getLocalizedMessage(pageContext, \"help.index\") +\"#license\"%>"><fmt:message key="jsp.morehelp"/></dspace:popup>--%>

	<%    
	    if(Util.isDr(subInfo.getSubmissionItem().getItem()))
	    {
%>
		<dspace:popup page="<%= LocaleSupport.getLocalizedMessage(pageContext, \"ub.help.doctor-path\") +\"#license\"%>"><fmt:message key="jsp.morehelp"/></dspace:popup>
<%
	    }
	    else
	    {
%>
		<dspace:popup page="<%= LocaleSupport.getLocalizedMessage(pageContext, \"ub.help.master-path\") +\"#license\"%>"><fmt:message key="jsp.morehelp"/></dspace:popup>
<%
	    }
%>
      </h1>

	<%-- No publish - no license --%>
<%
     if(subInfo.getSubmissionItem().isPublishedBefore()){
%>	

     <p><fmt:message key="ub.jsp.submit.show-license.nopublish-info1"><fmt:param><%= drOrMaster %></fmt:param></fmt:message></p>
     <p><fmt:message key="ub.jsp.submit.show-license.nopublish-info2"><fmt:param><%= drOrMaster %></fmt:param></fmt:message></p>
     <p><fmt:message key="ub.jsp.submit.show-license.nopublish-info3"><fmt:param><%= drOrMaster %></fmt:param></fmt:message></p>
     <div class="alert alert-info"><fmt:message key="ub.jsp.submit.show-license.nopublish-info4"/></div>

     <%-- Hidden fields needed for SubmissionController servlet to know which step is next--%>
     <%= SubmissionController.getSubmissionParameters(context, request) %>
     
     <div class="btn-group col-md-8 col-md-offset-2">
       <input class="btn btn-warning col-md-6" type="submit" name="submit_reject" value="<fmt:message key="ub.jsp.submit.show-license.nopublish-notgrant.button"/>" />
       <input class="btn btn-success col-md-6" type="submit" name="submit_grant" value="<fmt:message key="ub.jsp.submit.show-license.nopublish-grant.button"><fmt:param><%= drOrMaster %></fmt:param></fmt:message>" />
     </div>
     
<%
     }

     // Publish - show license

     else {
  
	    if(Util.isDr(subInfo.getSubmissionItem().getItem()))
	    {
%>
	        <p><fmt:message key="ub.jsp.submit.show-license.info-doctor" /></p>
<%
	    }
	    else
	    {
%>
	        <p><fmt:message key="jsp.submit.show-license.info1"><fmt:param><%= drOrMaster %></fmt:param></fmt:message></p>
		<p><fmt:message key="jsp.submit.show-license.info2"><fmt:param><%= drOrMaster %></fmt:param></fmt:message></p>
	        <p><fmt:message key="ub.jsp.submit.show-license.nopublish-info3"><fmt:param><%= drOrMaster %></fmt:param></fmt:message></p>
<%
	    }
%>
        

	<div class="alert alert-danger"><fmt:message key="ub.jsp.submit.show-license.nopublish-info4"/></div>

        <pre class="panel panel-primary col-md-10 col-md-offset-1"><%= license %></pre>

        <%-- Hidden fields needed for SubmissionController servlet to know which step is next--%>
        <%= SubmissionController.getSubmissionParameters(context, request) %>

	<div class="btn-group col-md-8 col-md-offset-2">
	  <input class="btn btn-warning col-md-6" type="submit" name="submit_reject" value="<fmt:message key="jsp.submit.show-license.notgrant.button"/>" />
	  <input class="btn btn-success col-md-6" type="submit" name="submit_grant" value="<fmt:message key="jsp.submit.show-license.grant.button"><fmt:param><%= drOrMaster %></fmt:param></fmt:message>" />
        </div>       

<%
    }
%>
       
    </form>
</dspace:layout>
