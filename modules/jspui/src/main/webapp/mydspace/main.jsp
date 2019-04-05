<%--

    The contents of this file are subject to the license and copyright
    detailed in the LICENSE and NOTICE files at the root of the source
    tree and available online at

    http://www.dspace.org/license/

--%>
<%--
  - Main My DSpace page
  -
  -
  - Attributes:
  -    mydspace.user:    current user (EPerson)
  -    workspace.items:  WorkspaceItem[] array for this user
  -    workflow.items:   WorkflowItem[] array of submissions from this user in
  -                      workflow system
  -    workflow.owned:   WorkflowItem[] array of tasks owned
  -    workflow.pooled   WorkflowItem[] array of pooled tasks
  --%>

<%@ page contentType="text/html;charset=UTF-8" %>

<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt"
    prefix="fmt" %>

<%@ taglib uri="http://www.dspace.org/dspace-tags.tld" prefix="dspace" %>

<%@ page  import="javax.servlet.jsp.jstl.fmt.LocaleSupport" %>

<%@ page import="org.dspace.app.webui.servlet.MyDSpaceServlet" %>
<%@ page import="org.dspace.content.Collection" %>
<%@ page import="org.dspace.content.DCDate" %>
<%@ page import="org.dspace.content.DCValue" %>
<%@ page import="org.dspace.content.Item" %>
<%@ page import="org.dspace.content.SupervisedItem" %>
<%@ page import="org.dspace.content.WorkspaceItem" %>
<%@ page import="org.dspace.core.Utils" %>
<%@ page import="org.dspace.eperson.EPerson" %>
<%@ page import="org.dspace.eperson.Group"   %>
<%@ page import="org.dspace.workflow.WorkflowItem" %>
<%@ page import="org.dspace.workflow.WorkflowManager" %>
<%@ page import="java.util.List" %>

<%@ page import="org.dspace.app.webui.util.UIUtil" %>
<%@ page import="org.dspace.core.Context" %>
<%@ page import="org.dspace.app.util.Util" %>

<%
    EPerson user = (EPerson) request.getAttribute("mydspace.user");

    WorkspaceItem[] workspaceItems =
        (WorkspaceItem[]) request.getAttribute("workspace.items");

    WorkflowItem[] workflowItems =
        (WorkflowItem[]) request.getAttribute("workflow.items");

    WorkflowItem[] owned =
        (WorkflowItem[]) request.getAttribute("workflow.owned");

    WorkflowItem[] pooled =
        (WorkflowItem[]) request.getAttribute("workflow.pooled");
	
    Group [] groupMemberships =
        (Group []) request.getAttribute("group.memberships");

    SupervisedItem[] supervisedItems =
        (SupervisedItem[]) request.getAttribute("supervised.items");
    
    List<String> exportsAvailable = (List<String>)request.getAttribute("export.archives");
    
    // Is the logged in user an admin
    Boolean displayMembership = (Boolean)request.getAttribute("display.groupmemberships");
    boolean displayGroupMembership = (displayMembership == null ? false : displayMembership.booleanValue());


    // Obtain context
    Context context = UIUtil.obtainContext(request);

    // Print view (link version)
    // boolean printView = false;
    // String listView = request.getParameter("view");
    // if(listView != null && listView.equals("print")){
    // 	printView = true;
    // }

    // Print view (group version) (213 = group id for A-HSL-Trykk group)
    boolean printView = false;
    if(Group.isMember(context, 213)){
	printView = true;
    }
%>

<dspace:layout style="submission" locbar="off" titlekey="jsp.mydspace" nocache="true">
	<div class="panel panel-primary">
        <div class="panel-heading">
                    <fmt:message key="jsp.mydspace"/>: <%= Utils.addEntities(user.getFullName()) %>
	                <%--<span class="pull-right"><dspace:popup page="<%= LocaleSupport.getLocalizedMessage(pageContext, \"help.index\") + \"#mydspace\"%>"><fmt:message key="jsp.help"/></dspace:popup></span>--%>
        </div>         

		<div class="panel-body">
		    <form action="<%= request.getContextPath() %>/mydspace" method="post">
		        <input type="hidden" name="step" value="<%= MyDSpaceServlet.MAIN_PAGE %>" />
                <input class="btn btn-success" type="submit" name="submit_new" value="<fmt:message key="jsp.mydspace.main.start.button"/>" />
                <%-- <input class="btn btn-info" type="submit" name="submit_own" value="<fmt:message key="jsp.mydspace.main.view.button"/>" /> --%>
		    </form>
		
		
<%-- Task list:  Only display if the user has any tasks --%>
<%
    if (owned.length > 0)
    {
%>
    <h3><fmt:message key="jsp.mydspace.main.heading2"/></h3>

<%

	    // Find out if there are any doctoral theses in the owned array
	    boolean hasDoctor = false;
	    for(int j=0; j<owned.length; j++){
		if(Util.isDr(owned[j].getItem())){
		    hasDoctor = true;
		    break;
		}
	    }

	    if(hasDoctor)
	    {
%>
    <p class="submitFormHelp">
        <%-- Below are the current tasks that you have chosen to do. --%>
        <fmt:message key="jsp.mydspace.main.text1">
	  <fmt:param><fmt:message key="ub.jsp.mydspace.main.doctoral-theses" /></fmt:param>
	</fmt:message>
    </p>

    <table class="table" align="center" summary="Table listing owned tasks">
        <tr>
            <th id="t0d" class="oddRowOddCol"><a href="?sort=title"><fmt:message key="jsp.mydspace.main.elem1"/></a></th>
            <th id="t1d" class="oddRowEvenCol"><a href="?sort=author"><fmt:message key="ub.jsp.mydspace.main.author"/></a></th>
            <th id="t2d" class="oddRowOddCol"><a href="?sort=course"><fmt:message key="ub.jsp.mydspace.main.faculty"/></a></th>
            <th id="t3d" class="oddRowEvenCol"><a href="?sort=subok"><fmt:message key="ub.jsp.mydspace.main.subok"/></a></th>
	    <th id="t4d" class="oddRowOddCol"><a href="?sort=printex"><fmt:message key="ub.jsp.mydspace.main.printexamination"/></a></th>
	    <th id="t5d" class="oddRowEvenCol"><a href="?sort=print"><fmt:message key="ub.jsp.mydspace.main.print-doctor"/></a></th>
	    <th id="t6d" class="oddRowOddCol"><fmt:message key="ub.jsp.mydspace.main.approved"/></th>
	    <th id="t7d" class="oddRowEvenCol">&nbsp;</th>
        </tr>
<%
        // even or odd row:  Starts even since header row is odd (1).  Toggled
        // between "odd" and "even" so alternate rows are light and dark, for
        // easier reading.
        String row = "even";

        for (int i = 0; i < owned.length; i++)
        {

	    // Only doctoral theses here
	    if(Util.isDr(owned[i].getItem()))
	    {
		// Title
		DCValue[] titleArray =
		    owned[i].getItem().getDC("title", null, Item.ANY);
		String title = (titleArray.length > 0 ? titleArray[0].value
                                                  : LocaleSupport.getLocalizedMessage(pageContext,"jsp.general.untitled") );
		// Author
		DCValue[] authorArray = owned[i].getItem().getDC("contributor", "author", Item.ANY);
		//Lag loekke her for aa faa med alle forfattere
		String author = "";
		for(int j=0; j<authorArray.length; j++){
		    author = author + authorArray[j].value + "<br />";
		}

		// Faculty
		DCValue[] courseArray = owned[i].getItem().getDC("subject", "courseID", Item.ANY);
		String course = (courseArray.length > 0 ? courseArray[0].value : "unknown");
		
		String faculty = "unknown";

		if(course.equals("DOKTOR-001")){
		    faculty = "HSL";
		}
		else if(course.equals("DOKTOR-002")){
		    faculty = "BFE";
		}
		else if(course.equals("DOKTOR-003")){
		    faculty = "Helsefak";
		}
		else if(course.equals("DOKTOR-004")){
		    faculty = "NT";
		}
		else if(course.equals("DOKTOR-005")){
		    faculty = "Jurfak";
		}
		else if(course.equals("DOKTOR-006")){
		    faculty = "Kunstfak";
		}
		else if(course.equals("DOKTOR-007")){
		    faculty = "IRS";
		}
		else if(course.equals("DOKTOR-008")){
		    faculty = "IVT";
		}
		else {
		    faculty = "unknown";
		}
		
		// Submission OK
		DCValue[] checkedArray = owned[i].getItem().getDC("description", "checked", Item.ANY);
		String checked = (checkedArray.length > 0 ? checkedArray[0].value : "unknown");

		// Print for committee
		DCValue[] printexaminationArray = owned[i].getItem().getDC("description", "printexamination", Item.ANY);
		String printexamination = (printexaminationArray.length > 0 ? printexaminationArray[0].value : "unknown");

		// Print for disputas
		DCValue[] printArray = owned[i].getItem().getDC("description", "print", Item.ANY);
		String print = (printArray.length > 0 ? printArray[0].value : "unknown");
		
		// Approval committee
		DCValue[] approvedArray = owned[i].getItem().getDC("description", "approved", Item.ANY);
		String approved = (approvedArray.length > 0 ? approvedArray[0].value : "unknown");

%>
        <tr>
            <td headers="t0d" class="<%= row %>RowOddCol"><%= Utils.addEntities(title) %></td>
            <td headers="t1d" class="<%= row %>RowEvenCol"><%= author %></td>
	    <td headers="t2d" class="<%= row %>RowOddCol"><%= Utils.addEntities(faculty) %></td>
	    <td headers="t3d" class="<%= row %>RowEvenCol"><%= Utils.addEntities(checked) %></td>
	    <td headers="t4d" class="<%= row %>RowOddCol"><%= Utils.addEntities(printexamination) %></td>
	    <td headers="t5d" class="<%= row %>RowEvenCol"><%= Utils.addEntities(print) %></td>
	    <td headers="t6d" class="<%= row %>RowOddCol"><%= Utils.addEntities(approved) %></td>

            <td headers="t7d" class="<%= row %>RowEvenCol">
                <form action="<%= request.getContextPath() %>/mydspace" method="post">
                    <input type="hidden" name="step" value="<%= MyDSpaceServlet.MAIN_PAGE %>" />
                    <input type="hidden" name="workflow_id" value="<%= owned[i].getID() %>" />  
                    <input class="btn btn-primary" type="submit" name="submit_perform" value="<fmt:message key="jsp.mydspace.main.perform.button"/>" /><br />  
                    <input class="btn btn-default" type="submit" name="submit_return" value="<fmt:message key="jsp.mydspace.main.return.button"/>" />
                </form> 
            </td>
        </tr>
<%
            row = (row.equals("even") ? "odd" : "even" );
        }
     }
%>
    </table>

    <%-- Master theses --%>

<%
  }
	    // Find out if there are any master theses in the owned array
	    boolean hasMaster = false;
	    for(int j=0; j<owned.length; j++){
		if(!Util.isDr(owned[j].getItem())){
		    hasMaster = true;
		    break;
		}
	    }

	    if(hasMaster)
	    {

%>
    <p class="submitFormHelp">
        <%-- Below are the current tasks that you have chosen to do. --%>
        <fmt:message key="jsp.mydspace.main.text1">
	  <fmt:param><fmt:message key="ub.jsp.mydspace.main.master-theses" /></fmt:param>
	</fmt:message>
    </p>

    <table class="table" align="center" width="95%" summary="Table listing owned tasks">
        <tr>
            <th id="t0m" class="oddRowOddCol"><a href="?sort=title"><fmt:message key="jsp.mydspace.main.elem1"/></a></th>
            <th id="t1m" class="oddRowEvenCol"><a href="?sort=course"><fmt:message key="ub.jsp.mydspace.main.course"/></a></th>
            <th id="t2m" class="oddRowOddCol"><a href="?sort=author"><fmt:message key="ub.jsp.mydspace.main.author"/></a></th>
	    <th id="t3m" class="oddRowEvenCol"><a href="?sort=subok"><fmt:message key="ub.jsp.mydspace.main.subok"/></a></th>
	    <th id="t4m" class="oddRowOddCol"><fmt:message key="ub.jsp.mydspace.main.puballowed"/></th>
	    <th id="t5m" class="oddRowEvenCol"><a href="?sort=print"><fmt:message key="ub.jsp.mydspace.main.print"/></a></th>
	    <th id="t6m" class="oddRowOddCol"><fmt:message key="ub.jsp.mydspace.main.examination"/></th>
	    <th id="t7m" class="oddRowEvenCol"><fmt:message key="ub.jsp.mydspace.main.maypub"/></th>

	    <th id="t8m" class="oddRowOddCol"><a href="?sort=submitdate"><fmt:message key="ub.jsp.mydspace.main.submitdate"/></a></th>

	    <th id="t9m" class="oddRowEvenCol">&nbsp;</th>
        </tr>
<%
        // even or odd row:  Starts even since header row is odd (1).  Toggled
        // between "odd" and "even" so alternate rows are light and dark, for
        // easier reading.
        String row = "even";

        for (int i = 0; i < owned.length; i++)
        {
	    // Only master theses here
	    if(!Util.isDr(owned[i].getItem()))
	    {
		DCValue[] titleArray =
		    owned[i].getItem().getDC("title", null, Item.ANY);
		String title = (titleArray.length > 0 ? titleArray[0].value
				: LocaleSupport.getLocalizedMessage(pageContext,"jsp.general.untitled") );
		
		DCValue[] courseArray = owned[i].getItem().getDC("subject", "courseID", Item.ANY);
		String course = (courseArray.length > 0 ? courseArray[0].value : "unknown");
		
		DCValue[] authorArray = owned[i].getItem().getDC("contributor", "author", Item.ANY);
		//Lag loekke her for aa faa med alle forfattere
		String author = "";
		for(int j=0; j<authorArray.length; j++){
		    author = author + authorArray[j].value + "<br />";
		}
		
		DCValue[] checkedArray = owned[i].getItem().getDC("description", "checked", Item.ANY);
		String checked = (checkedArray.length > 0 ? checkedArray[0].value : "unknown");
		
		String willPublish;
		
		if(owned[i].isPublishedBefore()){
		    willPublish = LocaleSupport.getLocalizedMessage(pageContext, "ub.jsp.mydspace.main.never");
		}
		else if(owned[i].hasMultipleTitles()){
		    willPublish = LocaleSupport.getLocalizedMessage(pageContext, "ub.jsp.mydspace.main.later");
		}
		else{
		    willPublish = LocaleSupport.getLocalizedMessage(pageContext, "ub.jsp.mydspace.main.now");
		}
		
		DCValue[] printArray = owned[i].getItem().getDC("description", "print", Item.ANY);
		String print = (printArray.length > 0 ? printArray[0].value : "unknown");
		
		DCValue[] examinationresultsArray = owned[i].getItem().getDC("description", "examinationresults", Item.ANY);
		String examinationresults = (examinationresultsArray.length > 0 ? examinationresultsArray[0].value : "unknown");
		
		DCValue[] publishArray = owned[i].getItem().getDC("description", "publish", Item.ANY);
		String publish = (publishArray.length > 0 ? publishArray[0].value : "unknown");

		// Extract submit date from description.provenance fields
		/*
		DCValue[] provenanceArray = owned[i].getItem().getDC("description", "provenance", Item.ANY);
		String submitDate = "";
		for(int j=0; j<provenanceArray.length; j++){
		    if(provenanceArray[j].value.startsWith("Submitted by")){
			int tempIndex;
			if((tempIndex = provenanceArray[j].value.indexOf(") on ")) != -1){
			    int startIndex = tempIndex + 5;
			    String tempDate = provenanceArray[j].value.substring(startIndex, startIndex + 10);
			    if(tempDate.compareTo(submitDate) > 0){
				submitDate = tempDate;
			    }
			}
		    }
		}
		*/

		// Date issued
		DCValue[] dateissuedArray = pooled[i].getItem().getMetadata("dc", "date", "issued", Item.ANY);
		String submitDate = (dateissuedArray.length > 0 ? dateissuedArray[0].value : "unknown");

		
  %>
        <tr>
	    <td headers="t0m" class="<%= row %>RowOddCol"><%= Utils.addEntities(title) %></td>
            <td headers="t1m" class="<%= row %>RowEvenCol"><%= Utils.addEntities(course) %></td>
	    <td headers="t2m" class="<%= row %>RowOddCol"><%= author %></td>
	    <td headers="t3m" class="<%= row %>RowEvenCol"><%= Utils.addEntities(checked) %></td>
	    <td headers="t4m" class="<%= row %>RowOddCol"><%= Utils.addEntities(willPublish) %></td>
	    <td headers="t5m" class="<%= row %>RowEvenCol"><%= Utils.addEntities(print) %></td>
	    <td headers="t6m" class="<%= row %>RowOddCol"><%= Utils.addEntities(examinationresults) %></td>
	    <td headers="t7m" class="<%= row %>RowEvenCol"><%= Utils.addEntities(publish) %></td>

	    <td headers="t8m" class="<%= row %>RowOddCol"><%= Utils.addEntities(submitDate) %></td>

            <td headers="t9am" class="<%= row %>RowEvenCol">
                <form action="<%= request.getContextPath() %>/mydspace" method="post">
                    <input type="hidden" name="step" value="<%= MyDSpaceServlet.MAIN_PAGE %>" />
                    <input type="hidden" name="workflow_id" value="<%= owned[i].getID() %>" />  
                    <input class="btn btn-primary" type="submit" name="submit_perform" value="<fmt:message key="jsp.mydspace.main.perform.button"/>" /><br />  
                    <input class="btn btn-default" type="submit" name="submit_return" value="<fmt:message key="jsp.mydspace.main.return.button"/>" />
                </form> 
            </td>
        </tr>
<%
            row = (row.equals("even") ? "odd" : "even" );
        }
    }
%>
    </table>
<%
	    }
    }

    // Pooled tasks - only show if there are any
    if (pooled.length > 0)
    {
%>
    <h3><fmt:message key="jsp.mydspace.main.heading3"/></h3>

    <%-- Doctoral theses --%>

<%
	    // Find out if there are any doctoral theses in the owned array
	    boolean hasDoctor = false;
	    for(int j=0; j<pooled.length; j++){
		if(Util.isDr(pooled[j].getItem())){
		    hasDoctor = true;
		    break;
		}
	    }

	    if(hasDoctor)
	    {
%>

    <p class="submitFormHelp">
        <%--Below are tasks in the task pool that have been assigned to you. --%>
        <fmt:message key="jsp.mydspace.main.text2">
	  <fmt:param><fmt:message key="ub.jsp.mydspace.main.doctoral-theses" /></fmt:param>
	</fmt:message>
    </p>

    <table class="table" align="center" summary="Table listing the tasks in the pool">
        <tr>
            <th id="t10d" class="oddRowOddCol"><a href="?sort=title"><fmt:message key="jsp.mydspace.main.elem1"/></a></th>
            <th id="t11d" class="oddRowEvenCol"><a href="?sort=author"><fmt:message key="ub.jsp.mydspace.main.author"/></a></th>
            <th id="t12d" class="oddRowOddCol"><a href="?sort=course"><fmt:message key="ub.jsp.mydspace.main.faculty"/></a></th>
            <th id="t13d" class="oddRowEvenCol"><a href="?sort=subok"><fmt:message key="ub.jsp.mydspace.main.subok"/></a></th>
	    <th id="t14d" class="oddRowOddCol"><a href="?sort=printex"><fmt:message key="ub.jsp.mydspace.main.printexamination"/></a></th>
	    <th id="t15d" class="oddRowEvenCol"><a href="?sort=print"><fmt:message key="ub.jsp.mydspace.main.print-doctor"/></a></th>
	    <th id="t16d" class="oddRowOddCol"><fmt:message key="ub.jsp.mydspace.main.approved"/></th>
	    <th id="t17d" class="oddRowEvenCol"><fmt:message key="ub.jsp.mydspace.main.claim-ownedby"/></th>
        </tr>
<%
        // even or odd row:  Starts even since header row is odd (1).  Toggled
        // between "odd" and "even" so alternate rows are light and dark, for
        // easier reading.
        String row = "even";

        for (int i = 0; i < pooled.length; i++)
        {
	    // Only doctoral theses here
	    if(Util.isDr(pooled[i].getItem()))
	    {
		// Title
		DCValue[] titleArray =
		    pooled[i].getItem().getDC("title", null, Item.ANY);
		String title = (titleArray.length > 0 ? titleArray[0].value
                    : LocaleSupport.getLocalizedMessage(pageContext,"jsp.general.untitled") );

		// Author
		DCValue[] authorArray = pooled[i].getItem().getDC("contributor", "author", Item.ANY);
		//Lag loekke her for aa faa med alle forfattere
		String author = "";
		for(int j=0; j<authorArray.length; j++){
		    author = author + authorArray[j].value + "<br />";
		}
		
		// Faculty
		DCValue[] courseArray = pooled[i].getItem().getDC("subject", "courseID", Item.ANY);
		String course = (courseArray.length > 0 ? courseArray[0].value : "unknown");
		
		String faculty = "unknown";

		if(course.equals("DOKTOR-001")){
		    faculty = "HSL";
		}
		else if(course.equals("DOKTOR-002")){
		    faculty = "BFE";
		}
		else if(course.equals("DOKTOR-003")){
		    faculty = "Helsefak";
		}
		else if(course.equals("DOKTOR-004")){
		    faculty = "NT";
		}
		else if(course.equals("DOKTOR-005")){
		    faculty = "Jurfak";
		}
		else if(course.equals("DOKTOR-006")){
		    faculty = "Kunstfak";
		}
		else if(course.equals("DOKTOR-007")){
		    faculty = "IRS";
		}
		else if(course.equals("DOKTOR-008")){
		    faculty = "IVT";
		}
		else {
		    faculty = "unknown";
		}
		
		// Submission OK
		DCValue[] checkedArray = pooled[i].getItem().getDC("description", "checked", Item.ANY);
		String checked = (checkedArray.length > 0 ? checkedArray[0].value : "unknown");

		// Print for committee
		DCValue[] printexaminationArray = pooled[i].getItem().getDC("description", "printexamination", Item.ANY);
		String printexamination = (printexaminationArray.length > 0 ? printexaminationArray[0].value : "unknown");

		// Print for disputas
		DCValue[] printArray = pooled[i].getItem().getDC("description", "print", Item.ANY);
		String print = (printArray.length > 0 ? printArray[0].value : "unknown");
		
		// Approval committee
		DCValue[] approvedArray = pooled[i].getItem().getDC("description", "approved", Item.ANY);
		String approved = (approvedArray.length > 0 ? approvedArray[0].value : "unknown");

%>
        <tr>
	 <%
	    EPerson ep = pooled[i].getOwner();
	    if (ep != null){
         %>  
            <td headers="t10d" class="<%= row %>RowOddCol"><span style="font-style: italic;"><%= Utils.addEntities(title) %></span></td>
            <td headers="t11d" class="<%= row %>RowEvenCol"><span style="font-style: italic;"><%= author %></span></td>
	    <td headers="t12d" class="<%= row %>RowOddCol"><span style="font-style: italic;"><%= Utils.addEntities(faculty) %></span></td>
	    <td headers="t13d" class="<%= row %>RowEvenCol"><span style="font-style: italic;"><%= Utils.addEntities(checked) %></span></td>
	    <td headers="t14d" class="<%= row %>RowOddCol"><span style="font-style: italic;"><%= Utils.addEntities(printexamination) %></span></td>
	    <td headers="t15d" class="<%= row %>RowEvenCol"><span style="font-style: italic;"><%= Utils.addEntities(print) %></span></td>
	    <td headers="t16d" class="<%= row %>RowOddCol"><span style="font-style: italic;"><%= Utils.addEntities(approved) %></span></td>

	    <td headers="t17d" class="<%= row %>RowEvenCol">
	       <span style="font-style: italic;"><%= ep.getFullName() %></span>
	    </td>

	 <%
	      }
	      else {
	 %>
            <td headers="t10d" class="<%= row %>RowOddCol"><%= Utils.addEntities(title) %></td>
            <td headers="t11d" class="<%= row %>RowEvenCol"><%= author %></td>
	    <td headers="t12d" class="<%= row %>RowOddCol"><%= Utils.addEntities(faculty) %></td>
	    <td headers="t13d" class="<%= row %>RowEvenCol"><%= Utils.addEntities(checked) %></td>
	    <td headers="t14d" class="<%= row %>RowOddCol"><%= Utils.addEntities(printexamination) %></td>
	    <td headers="t15d" class="<%= row %>RowEvenCol"><%= Utils.addEntities(print) %></td>
	    <td headers="t16d" class="<%= row %>RowOddCol"><%= Utils.addEntities(approved) %></td>

            <td headers="t17d" class="<%= row %>RowEvenCol">
              <form action="<%= request.getContextPath() %>/mydspace" method="post">
		<input type="hidden" name="step" value="<%= MyDSpaceServlet.MAIN_PAGE %>" />
		<input type="hidden" name="workflow_id" value="<%= pooled[i].getID() %>" />
		<input class="btn btn-default" type="submit" name="submit_claim" value="<fmt:message key="jsp.mydspace.main.take.button"/>" />
              </form> 
            </td>
         <%
	   }
         %>
        </tr>
<%
            row = (row.equals("even") ? "odd" : "even");
        }
      }
%>
    </table>

    <%-- Master theses --%>

<%
  }
	    // Find out if there are any master theses in the owned array
	    boolean hasMaster = false;
	    for(int j=0; j<pooled.length; j++){
		if(!Util.isDr(pooled[j].getItem())){
		    hasMaster = true;
		    break;
		}
	    }

	    if(hasMaster)
	    {

%>

    <p class="submitFormHelp">
        <%--Below are tasks in the task pool that have been assigned to you. --%>
        <fmt:message key="jsp.mydspace.main.text2">
	  <fmt:param><fmt:message key="ub.jsp.mydspace.main.master-theses" /></fmt:param>
	</fmt:message>
	<%-- Print view (link version) --%>
	<%--<a style="text-align: right;" href="mydspace?view=print">For trykkeri</a>--%>
    </p>

    <table class="table" align="center" width="95%" summary="Table listing the tasks in the pool">
        <tr>
            <th id="t10m" class="oddRowOddCol"><a href="?sort=title"><fmt:message key="jsp.mydspace.main.elem1"/></a></th>
            <th id="t11m" class="oddRowEvenCol"><a href="?sort=course"><fmt:message key="ub.jsp.mydspace.main.course"/></a></th>
            <th id="t12m" class="oddRowOddCol"><a href="?sort=author"><fmt:message key="ub.jsp.mydspace.main.author"/></a></th>
	    <th id="t13m" class="oddRowEvenCol"><a href="?sort=subok"><fmt:message key="ub.jsp.mydspace.main.subok"/></a></th>
	    <th id="t14m" class="oddRowOddCol"><fmt:message key="ub.jsp.mydspace.main.puballowed"/></th>
	    <th id="t15m" class="oddRowEvenCol"><a href="?sort=print"><fmt:message key="ub.jsp.mydspace.main.print"/></a></th>
	    <th id="t16m" class="oddRowOddCol"><fmt:message key="ub.jsp.mydspace.main.examination"/></th>
	    <th id="t17m" class="oddRowEvenCol"><fmt:message key="ub.jsp.mydspace.main.maypub"/></th>

    	    <th id="t18m" class="oddRowOddCol"><a href="?sort=submitdate"><fmt:message key="ub.jsp.mydspace.main.submitdate"/></a></th>

	    <th id="t19m" class="oddRowEvenCol"><fmt:message key="ub.jsp.mydspace.main.claim-ownedby"/></th>
        </tr>
<%
        // even or odd row:  Starts even since header row is odd (1).  Toggled
        // between "odd" and "even" so alternate rows are light and dark, for
        // easier reading.
        String row = "even";

        for (int i = 0; i < pooled.length; i++)
        {
	    // Only master theses here
	    if(!Util.isDr(pooled[i].getItem()) && Util.isPrint(pooled[i].getItem(), printView))
	    {
		DCValue[] titleArray =
		    pooled[i].getItem().getDC("title", null, Item.ANY);
		String title = (titleArray.length > 0 ? titleArray[0].value
				: LocaleSupport.getLocalizedMessage(pageContext,"jsp.general.untitled") );
		
		DCValue[] courseArray = pooled[i].getItem().getDC("subject", "courseID", Item.ANY);
		String course = (courseArray.length > 0 ? courseArray[0].value : "unknown");
		
		DCValue[] authorArray = pooled[i].getItem().getDC("contributor", "author", Item.ANY);
		//Lag loekke her for aa faa med alle forfattere
		String author = "";
		for(int j=0; j<authorArray.length; j++){
		    author = author + authorArray[j].value + "<br />";
		}
		
		DCValue[] checkedArray = pooled[i].getItem().getDC("description", "checked", Item.ANY);
		String checked = (checkedArray.length > 0 ? checkedArray[0].value : "unknown");
		
		String willPublish;
		if(pooled[i].isPublishedBefore()){
		    willPublish = LocaleSupport.getLocalizedMessage(pageContext, "ub.jsp.mydspace.main.never");
		}
		else if(pooled[i].hasMultipleTitles()){
		    willPublish = LocaleSupport.getLocalizedMessage(pageContext, "ub.jsp.mydspace.main.later");
		}
		else{
		    willPublish = LocaleSupport.getLocalizedMessage(pageContext, "ub.jsp.mydspace.main.now");
		}
		
		DCValue[] printArray = pooled[i].getItem().getDC("description", "print", Item.ANY);
		String print = (printArray.length > 0 ? printArray[0].value : "unknown");
		
		DCValue[] examinationresultsArray = pooled[i].getItem().getDC("description", "examinationresults", Item.ANY);
		String examinationresults = (examinationresultsArray.length > 0 ? examinationresultsArray[0].value : "unknown");
		
		DCValue[] publishArray = pooled[i].getItem().getDC("description", "publish", Item.ANY);
		String publish = (publishArray.length > 0 ? publishArray[0].value : "unknown");

		// Extract submit date from description.provenance fields
		/*
		DCValue[] provenanceArray = pooled[i].getItem().getDC("description", "provenance", Item.ANY);
		String submitDate = "";
		for(int j=0; j<provenanceArray.length; j++){
		    if(provenanceArray[j].value.startsWith("Submitted by")){
			int tempIndex;
			if((tempIndex = provenanceArray[j].value.indexOf(") on ")) != -1){
			    int startIndex = tempIndex + 5;
			    String tempDate = provenanceArray[j].value.substring(startIndex, startIndex + 10);
			    if(tempDate.compareTo(submitDate) > 0){
				submitDate = tempDate;
			    }
			}
		    }
		}
		*/

		// Date issued
		DCValue[] dateissuedArray = pooled[i].getItem().getMetadata("dc", "date", "issued", Item.ANY);
		String submitDate = (dateissuedArray.length > 0 ? dateissuedArray[0].value : "unknown");
		
         %>
    <tr>
    
	 <%
	        EPerson ep = pooled[i].getOwner();
		if (ep != null){
		    %>  
	 <td headers="t10m" class="<%= row %>RowOddCol"><span style="font-style: italic;"><%= Utils.addEntities(title) %></span></td>
	 <td headers="t11m" class="<%= row %>RowEvenCol"><span style="font-style: italic;"><%= Utils.addEntities(course) %></span></td>
	 <td headers="t12m" class="<%= row %>RowOddCol"><span style="font-style: italic;"><%= author %></span></td>
	 <td headers="t13m" class="<%= row %>RowEvenCol"><span style="font-style: italic;"><%= Utils.addEntities(checked) %></span></td>
	 <td headers="t14m" class="<%= row %>RowOddCol"><span style="font-style: italic;"><%= Utils.addEntities(willPublish) %></span></td>
	 <td headers="t15m" class="<%= row %>RowEvenCol"><span style="font-style: italic;"><%= Utils.addEntities(print) %></span></td>
	 <td headers="t16m" class="<%= row %>RowOddCol"><span style="font-style: italic;"><%= Utils.addEntities(examinationresults) %></span></td>
	 <td headers="t17m" class="<%= row %>RowEvenCol"><span style="font-style: italic;"><%= Utils.addEntities(publish) %></span></td>

	 <td headers="t18m" class="<%= row %>RowOddCol"><span style="font-style: italic;"><%= Utils.addEntities(submitDate) %></span></td>
	 
	 <td headers="t19m" class="<%= row %>RowEvenCol">
	   <span style="font-style: italic;"><%= ep.getFullName() %></span>
	 </td>
	 <%
	  }
	  else {
	 %>
         <td headers="t10m" class="<%= row %>RowOddCol"><%= Utils.addEntities(title) %></td>
         <td headers="t11m" class="<%= row %>RowEvenCol"><%= Utils.addEntities(course) %></td>
	 <td headers="t12m" class="<%= row %>RowOddCol"><%= author %></td>
	 <td headers="t13m" class="<%= row %>RowEvenCol"><%= Utils.addEntities(checked) %></td>
	 <td headers="t14m" class="<%= row %>RowOddCol"><%= Utils.addEntities(willPublish) %></td>
	 <td headers="t15m" class="<%= row %>RowEvenCol"><%= Utils.addEntities(print) %></td>
	 <td headers="t16m" class="<%= row %>RowOddCol"><%= Utils.addEntities(examinationresults) %></td>
	 <td headers="t17m" class="<%= row %>RowEvenCol"><%= Utils.addEntities(publish) %></td>

	 <td headers="t18m" class="<%= row %>RowOddCol"><%= Utils.addEntities(submitDate) %></td>
	 
         <td headers="t19m" class="<%= row %>RowEvenCol">
           <form action="<%= request.getContextPath() %>/mydspace" method="post">
             <input type="hidden" name="step" value="<%= MyDSpaceServlet.MAIN_PAGE %>" />
             <input type="hidden" name="workflow_id" value="<%= pooled[i].getID() %>" />
             <input class="btn btn-default" type="submit" name="submit_claim" value="<fmt:message key="jsp.mydspace.main.take.button"/>" />
           </form> 
         </td>
      <%
	 }
      %>

    </tr>
    <%
	  row = (row.equals("even") ? "odd" : "even");
	 }
     }
    %>


    </table>

<%
	  }
    }

    // Display workspace items (authoring or supervised), if any
    if (workspaceItems.length > 0 || supervisedItems.length > 0)
    {
        // even or odd row:  Starts even since header row is odd (1)
        String row = "even";
%>

    <h3><fmt:message key="jsp.mydspace.main.heading4"/></h3>

    <p><fmt:message key="jsp.mydspace.main.text4" /></p>

    <table class="table" align="center" summary="Table listing unfinished submissions">
        <tr>
            <th id="t19" class="oddRowOddCol">&nbsp;</th>
            <th id="t20" class="oddRowEvenCol"><fmt:message key="jsp.mydspace.main.subby"/></th>
            <th id="t21" class="oddRowOddCol"><fmt:message key="jsp.mydspace.main.elem1"/></th>
            <th id="t22" class="oddRowEvenCol"><fmt:message key="jsp.mydspace.main.elem2"/></th>
            <th id="t23" class="oddRowOddCol"><fmt:message key="ub.jsp.mydspace.main.author"/></th>
            <th id="t24" class="oddRowEvenCol">&nbsp;</th>
        </tr>
<%
        if (supervisedItems.length > 0 && workspaceItems.length > 0)
        {
%>
        <tr>
            <th colspan="5">
                <%-- Authoring --%>
                <fmt:message key="jsp.mydspace.main.authoring" />
            </th>
        </tr>
<%
        }

        for (int i = 0; i < workspaceItems.length; i++)
        {
            DCValue[] titleArray =
                workspaceItems[i].getItem().getDC("title", null, Item.ANY);
            String title = (titleArray.length > 0 ? titleArray[0].value
                    : LocaleSupport.getLocalizedMessage(pageContext,"jsp.general.untitled") );
            EPerson submitter = workspaceItems[i].getItem().getSubmitter();

	    DCValue[] authorArray = workspaceItems[i].getItem().getDC("contributor", "author", Item.ANY);
	    String author = (authorArray.length > 0 ? authorArray[0].value : "unknown");
%>
        <tr>
            <td headers="t19" class="<%= row %>RowOddCol">
                <form action="<%= request.getContextPath() %>/workspace" method="post">
                    <input type="hidden" name="workspace_id" value="<%= workspaceItems[i].getID() %>"/>
                    <input class="btn btn-default" type="submit" name="submit_open" value="<fmt:message key="jsp.mydspace.general.open" />"/>
                </form>
            </td>
            <td headers="t20" class="<%= row %>RowEvenCol">
                <a href="mailto:<%= submitter.getEmail() %>"><%= Utils.addEntities(submitter.getFullName()) %></a>
            </td>
            <td headers="t21" class="<%= row %>RowOddCol"><%= Utils.addEntities(title) %></td>
            <td headers="t22" class="<%= row %>RowEvenCol"><%= workspaceItems[i].getCollection().getMetadata("name") %></td>
	    <td headers="t23" class="<%= row %>RowOddCol"><%= Utils.addEntities(author) %></td>
            <td headers="t24" class="<%= row %>RowOddCol">
	    <% 
	    if(WorkflowManager.getWorkflowItem(context, workspaceItems[i].getItem()) == null){
		%>
                <form action="<%= request.getContextPath() %>/mydspace" method="post">
                    <input type="hidden" name="step" value="<%= MyDSpaceServlet.MAIN_PAGE %>"/>
                    <input type="hidden" name="workspace_id" value="<%= workspaceItems[i].getID() %>"/>
                    <input class="btn btn-danger" type="submit" name="submit_delete" value="<fmt:message key="jsp.mydspace.general.remove" />"/>
                </form> 
		<%
	    }
	    %>
            </td>
        </tr>
<%
            row = (row.equals("even") ? "odd" : "even" );
        }
%>

<%-- Start of the Supervisors workspace list --%>
<%
        if (supervisedItems.length > 0)
        {
%>
        <tr>
            <th colspan="5">
                <fmt:message key="jsp.mydspace.main.supervising" />
            </th>
        </tr>
<%
        }

        for (int i = 0; i < supervisedItems.length; i++)
        {
            DCValue[] titleArray =
                supervisedItems[i].getItem().getDC("title", null, Item.ANY);
            String title = (titleArray.length > 0 ? titleArray[0].value
                    : LocaleSupport.getLocalizedMessage(pageContext,"jsp.general.untitled") );
            EPerson submitter = supervisedItems[i].getItem().getSubmitter();
%>

        <tr>
            <td class="<%= row %>RowOddCol">
                <form action="<%= request.getContextPath() %>/workspace" method="post">
                    <input type="hidden" name="workspace_id" value="<%= supervisedItems[i].getID() %>"/>
                    <input class="btn btn-default" type="submit" name="submit_open" value="<fmt:message key="jsp.mydspace.general.open" />"/>
                </form>
            </td>
            <td class="<%= row %>RowEvenCol">
                <a href="mailto:<%= submitter.getEmail() %>"><%= Utils.addEntities(submitter.getFullName()) %></a>
            </td>
            <td class="<%= row %>RowOddCol"><%= Utils.addEntities(title) %></td>
            <td class="<%= row %>RowEvenCol"><%= supervisedItems[i].getCollection().getMetadata("name") %></td>
            <td class="<%= row %>RowOddCol">
                <form action="<%= request.getContextPath() %>/mydspace" method="post">
                    <input type="hidden" name="step" value="<%= MyDSpaceServlet.MAIN_PAGE %>"/>
                    <input type="hidden" name="workspace_id" value="<%= supervisedItems[i].getID() %>"/>
                    <input class="btn btn-default" type="submit" name="submit_delete" value="<fmt:message key="jsp.mydspace.general.remove" />"/>
                </form>  
            </td>
        </tr>
<%
            row = (row.equals("even") ? "odd" : "even" );
        }
%>
    </table>
<%
    }
%>

<%
    // Display workflow items, if any
    if (workflowItems.length > 0)
    {
        // even or odd row:  Starts even since header row is odd (1)
        String row = "even";
%>
    <h3><fmt:message key="jsp.mydspace.main.heading5"/></h3>

    <table class="table" align="center" summary="Table listing submissions in workflow process">
        <tr>
            <th id="t25" class="oddRowOddCol"><fmt:message key="jsp.mydspace.main.elem1"/></th>
            <th id="t26" class="oddRowEvenCol"><fmt:message key="jsp.mydspace.main.elem2"/></th>
        </tr>
<%
        for (int i = 0; i < workflowItems.length; i++)
        {
            DCValue[] titleArray =
                workflowItems[i].getItem().getDC("title", null, Item.ANY);
            String title = (titleArray.length > 0 ? titleArray[0].value
                    : LocaleSupport.getLocalizedMessage(pageContext,"jsp.general.untitled") );
%>
            <tr>
                <td headers="t25" class="<%= row %>RowOddCol"><%= Utils.addEntities(title) %></td>
                <td headers="t26" class="<%= row %>RowEvenCol">
                   <form action="<%= request.getContextPath() %>/mydspace" method="post">
                       <%= workflowItems[i].getCollection().getMetadata("name") %>
                       <input type="hidden" name="step" value="<%= MyDSpaceServlet.MAIN_PAGE %>" />
                       <input type="hidden" name="workflow_id" value="<%= workflowItems[i].getID() %>" />
                   </form>   
                </td>
            </tr>
<%
      row = (row.equals("even") ? "odd" : "even" );
    }
%>
    </table>
<%
  }

  if(displayGroupMembership && groupMemberships.length>0)
  {
%>
    <h3><fmt:message key="jsp.mydspace.main.heading6"/></h3>
    <ul>
<%
    for(int i=0; i<groupMemberships.length; i++)
    {
%>
    <li><%=groupMemberships[i].getName()%></li> 
<%    
    }
%>
	</ul>
<%
  }
%>

	<%if(exportsAvailable!=null && exportsAvailable.size()>0){ %>
	<h3><fmt:message key="jsp.mydspace.main.heading7"/></h3>
	<ol class="exportArchives">
		<%for(String fileName:exportsAvailable){%>
			<li><a href="<%=request.getContextPath()+"/exportdownload/"+fileName%>" title="<fmt:message key="jsp.mydspace.main.export.archive.title"><fmt:param><%= fileName %></fmt:param></fmt:message>"><%=fileName%></a></li> 
		<% } %>
	</ol>
	<%} %>
	</div>
</div>	
</dspace:layout>
