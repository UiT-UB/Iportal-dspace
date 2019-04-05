<%--

    The contents of this file are subject to the license and copyright
    detailed in the LICENSE and NOTICE files at the root of the source
    tree and available online at

    http://www.dspace.org/license/

--%>

<%--
  - Display list of Workflows, with 'abort' buttons next to them
  -
  - Attributes:
  -
  -   workflows - WorkflowItem [] to choose from
  --%>

<%@ page contentType="text/html;charset=UTF-8" %>

<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt"
    prefix="fmt" %>


<%@ taglib uri="http://www.dspace.org/dspace-tags.tld" prefix="dspace" %>

<%@ page import="javax.servlet.jsp.jstl.fmt.LocaleSupport" %>

<%@ page import="org.dspace.administer.DCType" %>
<%@ page import="org.dspace.content.Collection" %>
<%@ page import="org.dspace.core.Utils" %>
<%@ page import="org.dspace.workflow.WorkflowManager" %>
<%@ page import="org.dspace.workflow.WorkflowItem" %>

<%@ page import="org.dspace.content.Item" %>
<%@ page import="org.dspace.eperson.EPerson" %>
<%@ page import="org.dspace.content.DCValue" %>

<%
    WorkflowItem[] workflows =
        (WorkflowItem[]) request.getAttribute("workflows");
%>

<dspace:layout style="submission" 
			   titlekey="jsp.dspace-admin.workflow-list.title"
               navbar="admin"
               locbar="link"
               parenttitlekey="jsp.administer"
               parentlink="/dspace-admin"
               nocache="true">
  
	<h1>
	  <fmt:message key="jsp.dspace-admin.workflow-list.heading"/>
	  <dspace:popup page="<%= LocaleSupport.getLocalizedMessage(pageContext, \"help.site-admin\") + \"#workflow\"%>"><fmt:message key="jsp.morehelp"/></dspace:popup>
	</h1>   

   <table class="table" align="center" summary="Table displaying list of currently active workflows">
       <tr>
           <th class="oddRowOddCol"><strong><fmt:message key="ub.jsp.dspace-admin.workflow-list.wfid"/></strong></th>
           <th class="oddRowEvenCol"><strong><fmt:message key="ub.jsp.dspace-admin.workflow-list.intid"/></strong></th>
           <th class="oddRowOddCol"><strong><fmt:message key="ub.jsp.dspace-admin.workflow-list.date-exam"/></strong></th>
           <th class="oddRowEvenCol"><strong><fmt:message key="ub.jsp.dspace-admin.workflow-list.owner"/></strong></th>
           <th class="oddRowOddCol"><strong><fmt:message key="jsp.dspace-admin.workflow-list.collection"/></strong></th>
           <th class="oddRowEvenCol"><strong><fmt:message key="ub.jsp.dspace-admin.workflow-list.author"/></strong></th>
           <th class="oddRowOddCol"><strong><fmt:message key="jsp.dspace-admin.workflow-list.item-title"/></strong></th>
           <th class="oddRowEvenCol"><strong>&nbsp;</strong></th>
       </tr>
<%
    String row = "even";
    for (int i = 0; i < workflows.length; i++)
    {

	EPerson ep  = workflows[i].getOwner();
	String owner = "Ingen";
        if(ep != null){
	    owner = ep.getFullName();
	}

	DCValue[] dates = workflows[i].getItem().getMetadata("dc", "date", "issued", Item.ANY); 
	String date = "Ingen";
	if (dates.length > 0){
	    date = dates[0].value;
	} 
%>
        <tr>
	  <td class="<%= row %>RowOddCol">
	    <%= workflows[i].getID() %>
	  </td>
	  <td class="<%= row %>RowEvenCol">
	    <%= workflows[i].getItem().getID() %>
          </td>
	  <td class="<%= row %>RowOddCol">
	    <%= date  %>
          </td>
	  <td class="<%= row %>RowEvenCol">
            <%= owner  %>
          </td>
	  <td class="<%= row %>RowOddCol">
	    <%= workflows[i].getCollection().getMetadata("name") %>
	  </td>
	  <td class="<%= row %>RowEvenCol">
	    <%= WorkflowManager.getItemAuthor(workflows[i]) %>
          </td>
	  <td class="<%= row %>RowOddCol">
	    <%= Utils.addEntities(WorkflowManager.getItemTitle(workflows[i]))  %>
          </td>
	  <td class="<%= row %>RowOddCol">
               <form method="post" action="">
                   <input type="hidden" name="workflow_id" value="<%= workflows[i].getID() %>"/>

		   <%
	           if(ep != null)
		   {
		   %>
		   <input class="btn btn-default" type="submit" name="submit_send_back" value="<fmt:message key="ub.jsp.dspace-admin.workflow-list.back-to-tasklist"/>" />
		   <%
		   }
	           %>
                   <input class="btn btn-danger" type="submit" name="submit_abort" value="<fmt:message key="jsp.dspace-admin.general.abort-w-confirm"/>" />
                  
              </form>
            </td>
        </tr>
<%
        row = (row.equals("odd") ? "even" : "odd");
    }
%>
     </table>
</dspace:layout>
