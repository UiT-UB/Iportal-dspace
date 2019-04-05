<%--

    The contents of this file are subject to the license and copyright
    detailed in the LICENSE and NOTICE files at the root of the source
    tree and available online at

    http://www.dspace.org/license/

--%>
<%--
  - Preview task page
  -
  -   workflow.item:  The workflow item for the task theyre performing
  --%>

<%@ page contentType="text/html;charset=UTF-8" %>

<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt"
    prefix="fmt" %>

<%@ taglib uri="http://www.dspace.org/dspace-tags.tld" prefix="dspace" %>

<%@ page import="org.dspace.app.webui.servlet.MyDSpaceServlet" %>
<%@ page import="org.dspace.content.Collection" %>
<%@ page import="org.dspace.content.Item" %>
<%@ page import="org.dspace.eperson.EPerson" %>
<%@ page import="org.dspace.workflow.WorkflowItem" %>
<%@ page import="org.dspace.workflow.WorkflowManager" %>

<%@ page import="org.dspace.app.util.Util" %>

<%
    WorkflowItem workflowItem =
        (WorkflowItem) request.getAttribute("workflow.item");

    Collection collection = workflowItem.getCollection();
    Item item = workflowItem.getItem();
%>

<dspace:layout style="submission"
			   locbar="off"
               parentlink="/mydspace"
               parenttitlekey="jsp.mydspace"
               titlekey="jsp.mydspace.preview-task.title"
               nocache="true">

	<h1><fmt:message key="jsp.mydspace.preview-task.title"/></h1>

	<p>
	<fmt:message key="ub.jsp.mydspace.preview-task.internal_id"/> <%= item.getID() %>
	</p>

    <%
     if(!Util.isDr(item)){

    if (workflowItem.isPublishedBefore())
    {
    %>
    <p class="alert alert-danger">
      <fmt:message key="ub.jsp.mydspace.preview-task.publish-never"/>
    </p>
    <%
    }
    if (workflowItem.hasMultipleTitles())
    {
    %>
    <p class="alert alert-danger">
      <fmt:message key="ub.jsp.mydspace.preview-task.publish-later"/>
    </p>
    <%
    }
     }
    %>  
        
<%
    if (workflowItem.getState() == WorkflowManager.WFSTATE_STEP1POOL)
    {
	if(Util.isDr(item)){
%>
	<p><fmt:message key="ub.jsp.mydspace.preview-task.text1-doctor"> 
        <fmt:param><%= collection.getMetadata("name") %></fmt:param>
    </fmt:message></p>
<%
	}
	else {
%>
	<p><fmt:message key="ub.jsp.mydspace.preview-task.text1-master"> 
            <fmt:param><%= collection.getMetadata("name") %></fmt:param>
	</fmt:message></p>
<%
	}
    }
    else if(workflowItem.getState() == WorkflowManager.WFSTATE_STEP2POOL)
    {
	if(Util.isDr(item)){
%>    
	<p><fmt:message key="ub.jsp.mydspace.preview-task.text3-doctor"> 
            <fmt:param><%= collection.getMetadata("name") %></fmt:param>
	</fmt:message></p>
<%
	}
	else {
%>    
	<p><fmt:message key="ub.jsp.mydspace.preview-task.text3-master"> 
            <fmt:param><%= collection.getMetadata("name") %></fmt:param>
	</fmt:message></p>
<%
	}
    }
    else if(workflowItem.getState() == WorkflowManager.WFSTATE_STEP3POOL)
    {
%>
	<p><fmt:message key="jsp.mydspace.preview-task.text4"> 
        <fmt:param><%= collection.getMetadata("name") %></fmt:param>
    </fmt:message></p>
<%
    }
%>
    
    <form action="<%= request.getContextPath() %>/mydspace" method="post">
        <input type="hidden" name="workflow_id" value="<%= workflowItem.getID() %>"/>
        <input type="hidden" name="step" value="<%= MyDSpaceServlet.PREVIEW_TASK_PAGE %>"/>
	<div class="col-md-4 pull-right btn-group padding-topbtm-15px">
	  <input class="btn btn-default col-md-6" type="submit" name="submit_cancel" value="<fmt:message key="jsp.mydspace.general.cancel"/>" />
	  <input class="btn btn-primary col-md-6 pull-right" type="submit" name="submit_start" value="<fmt:message key="jsp.mydspace.preview-task.accept.button"/>" />
	</div>
    </form>

    <dspace:item item="<%= item %>" />

</dspace:layout>
