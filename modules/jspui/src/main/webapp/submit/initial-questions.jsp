<%--

    The contents of this file are subject to the license and copyright
    detailed in the LICENSE and NOTICE files at the root of the source
    tree and available online at

    http://www.dspace.org/license/

--%>
<%--
  - Initial questions for keeping UI as simple as possible.
  -
  - Attributes to pass in:
  -    submission.info    - the SubmissionInfo object
  -    submission.inputs  - the DCInputSet object
  --%>

<%@ page contentType="text/html;charset=UTF-8" %>

<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt"
    prefix="fmt" %>

<%@ page import="javax.servlet.jsp.jstl.fmt.LocaleSupport" %>

<%@ page import="org.dspace.core.Context" %>
<%@ page import="org.dspace.app.webui.servlet.SubmissionController" %>
<%@ page import="org.dspace.submit.AbstractProcessingStep" %>
<%@ page import="org.dspace.app.webui.util.UIUtil" %>
<%@ page import="org.dspace.app.util.SubmissionInfo" %>
<%@ page import="org.dspace.app.util.DCInputSet" %>
<%@ page import="org.dspace.core.ConfigurationManager" %>

<%-- KM: Added libraries --%>
<%@ page import="org.dspace.app.webui.submit.JSPStepManager" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.Set" %>
<%@ page import="java.util.Iterator" %>
<%@ page import="org.dspace.app.util.Util" %>


<%@ taglib uri="http://www.dspace.org/dspace-tags.tld" prefix="dspace" %>

<%
    request.setAttribute("LanguageSwitch", "hide");

        DCInputSet inputSet =
        (DCInputSet) request.getAttribute("submission.inputs");

	// Obtain DSpace context
    Context context = UIUtil.obtainContext(request);

	//get submission information object
    SubmissionInfo subInfo = SubmissionController.getSubmissionInfo(context, request);

	//KMS
    // Is the checklist checkbox checked?
    String checklist = "checked=\"checked\"";

    // Is the next-button disabled?
    String nextDisabled = "";

    // Which of the radio buttons is checked
    String never = "";
    String later = "";
    String now = "";

    if(SubmissionController.getStepReached(subInfo) == 1 || subInfo.getSubmissionItem().isPublishedBefore()){
	checklist = "";
    }

    // The next button is disabled when you start a submission
    if(SubmissionController.getStepReached(subInfo) == 1){
		nextDisabled = "disabled=\"disabled\"";
    }

    if(subInfo.getSubmissionItem().isPublishedBefore()){
		never = "checked=\"checked\"";
    }
    else if(subInfo.getSubmissionItem().hasMultipleTitles()){
		later = "checked=\"checked\"";
    }
    else{
		now = "checked=\"checked\"";
    }

    // Need to find the total number of steps and pages to use when enabling/disabling progressbar buttons

    // Get last step and page reached
    int stepReached = SubmissionController.getStepReached(subInfo);
    int pageReached = JSPStepManager.getPageReached(subInfo);

    HashMap progressBarInfo = (HashMap) subInfo.getProgressBarInfo();
    //get iterator
    Set keys = progressBarInfo.keySet();
    Iterator barIterator = keys.iterator();

    int stepPageCount = 0;
    // Count steps and pages up till current step
    while(barIterator.hasNext()){
		String stepAndPage = (String) barIterator.next();
		//split into stepNum and pageNum
		String[] fields = stepAndPage.split("\\.");  //split on period
		int stepNum = Integer.parseInt(fields[0]);
		int pageNum = Integer.parseInt(fields[1]);

		stepPageCount++;

		if(stepNum == stepReached && pageNum == pageReached){
	    	break;
		}
    }

    String onClick1 = "onClick=\"enableDisableNext(" + stepPageCount + ")\"";
    String onClick2 = "onClick=\"checkOrUncheck(this.value); enableDisableNext(" + stepPageCount + ")\"";

   //Doctor or master?
   String drOrMaster = LocaleSupport.getLocalizedMessage(pageContext, "ub.jsp.submit.initial-questions.master-short");
   if(Util.isDr(subInfo.getSubmissionItem().getItem())){
       drOrMaster = LocaleSupport.getLocalizedMessage(pageContext, "ub.jsp.submit.initial-questions.dr-short");
   }	
	//KME
%>

<%-- KM: Controls some of the logic of the initial questions.--%>
<script type="text/javascript" language="JavaScript">

// Disables the checklist check box when a user checks that he does not want to publish.
function checkOrUncheck(val) {
// "checked" == true, "" == false
if(val == "publish_never"){
document.forms[0].checklist.disabled = "disabled";
document.forms[0].checklist.checked = "";
document.getElementById("checklistLabel").className = "form-control checklistGray";
}
else{
document.forms[0].checklist.disabled = "";
document.getElementById("checklistLabel").className = "form-control";
//alert("<fmt:message key="ub.jsp.submit.initial-questions.checklist-alert"/>");
}
}

// Disable or enable Next button and progressbar buttons, when user changes publish values and checklist
function enableDisableNext(stepReached){
  if(document.forms[0].checklist.checked == false && document.forms[0].publish[document.forms[0].publish.length-1].checked == false){
    document.forms[0].submit_next.disabled = "disabled";
    // pluss alle eventuelle knapper i progressbar, minus den første
    for(i=1; i<stepReached; i++){
      document.forms[0].elements[i].disabled = "disabled";
      document.forms[0].elements[i].className = "submitProgressButtonNotDone btn btn-info";
    }
  }
  else {
    document.forms[0].submit_next.disabled = "";
    // pluss alle eventuelle knapper i progressbar, minus den første
    for(i=1; i<stepReached; i++){
      document.forms[0].elements[i].disabled = "";
      document.forms[0].elements[i].className = "submitProgressButtonDone btn btn-info";
    }
  }
}

</script>

<noscript>
  <b>No javascript. Javascript has to be turned on for thise pages to work correctly.</b><br />
</noscript>


<dspace:layout style="submission"
		navbar="off" locbar="off"
		titlekey="jsp.submit.initial-questions.title"
		nocache="true">

    <form action="<%= request.getContextPath() %>/submit" method="post" onkeydown="return disableEnterKey(event);">

        <jsp:include page="/submit/progressbar.jsp" />

        <%-- <h1>Submit: Describe Your Item</h1> --%>
		<h1><fmt:message key="jsp.submit.initial-questions.heading"/>
		<%--<dspace:popup page="<%= LocaleSupport.getLocalizedMessage(pageContext, \"help.index\") + \"#describe1\"%>"><fmt:message key="jsp.morehelp"/></dspace:popup>--%>
		</h1>
   
<%-- 
	We are using the published_before field to indicate if the submitter never wants to publish the item 
	and the multiple_titles field to indicate if the submitter wants to publish the item later.
	Since we are not using these fields, and that we don´t want to alter the database, this is probably the best solution. 
--%> 

<% 
	if(Util.isDr(subInfo.getSubmissionItem().getItem()))
	{
%>

	<p><fmt:message key="ub.jsp.submit.initial-questions.permissions-dr"/></p>

<%
	}
%>

<% 
	if(!Util.isDr(subInfo.getSubmissionItem().getItem()))
	{
%>

	<p>
	 <fmt:message key="ub.jsp.submit.initial-questions.policy"/>
	 <br /><br />
     <fmt:message key="jsp.submit.initial-questions.info"><fmt:param><%= drOrMaster %></fmt:param></fmt:message>
	</p>

<%
	}
%>

<% 
	if(Util.isDr(subInfo.getSubmissionItem().getItem()))
	{
%>

	<p><fmt:message key="jsp.submit.initial-questions.info"><fmt:param><%= drOrMaster %></fmt:param></fmt:message></p>

	<div class="input-group">
		<span class="input-group-addon">
			<input type="radio" name="publish" value="publish_now" <%= now %> <%= onClick2 %> />
		</span>
		<label class="form-control" for="multiple_titles"><fmt:message key="ub.jsp.submit.initial-questions.publish-now-dr"/></label>
	</div>

	<div class="input-group">
		<span class="input-group-addon">
			<input type="radio" name="publish" value="publish_never" <%= never %> <%= onClick2 %> />
		</span>
		<label class="form-control" for="multiple_titles"><fmt:message key="ub.jsp.submit.initial-questions.publish-never-dr"/></label>
	</div>

	<br />
	<p><fmt:message key="ub.jsp.submit.initial-questions.agreement-info1-doctor" /></p>

	<div class="input-group">
		<span class="input-group-addon">
			<input type="checkbox" name="checklist" <%= checklist %> value="true" <%= (subInfo.getSubmissionItem().isPublishedBefore() ? "disabled='disabled'" : "") %> <%= onClick1 %> />
		</span>
		<!-- TODO: Fiks style alt etter valg -->
		<label id="checklistLabel" class="form-control" for="multiple_titles"><fmt:message key="ub.jsp.submit.initial-questions.agreement-doctor"/></label>
	</div>

<%
	}
	else
	{
%>

	<div class="input-group">
		<span class="input-group-addon">
			<input type="radio" name="publish" value="publish_now" <%= now %> <%= onClick2 %> />
		</span>
		<label class="form-control" for="multiple_titles"><fmt:message key="ub.jsp.submit.initial-questions.publish-now"/></label>
	</div>

	<div class="input-group">
		<span class="input-group-addon">
			<input type="radio" name="publish" value="publish_later" <%= later %> <%= onClick2 %> />
		</span>
		<label class="form-control" for="multiple_titles"><fmt:message key="ub.jsp.submit.initial-questions.publish-later"/></label>
	</div>

	<div class="input-group">
		<span class="input-group-addon">
			<input type="radio" name="publish" value="publish_never" <%= never %> <%= onClick2 %> />
		</span>
		<label class="form-control" for="multiple_titles"><fmt:message key="ub.jsp.submit.initial-questions.publish-never"/></label>
	</div>

	<br />
	<p>
	<fmt:message key="ub.jsp.submit.initial-questions.agreement-info1" />

	  <dspace:popup page="<%= LocaleSupport.getLocalizedMessage(pageContext, \"ub.jsp.submit.initial-questions.agreement-path\")%>"><b><fmt:message key="ub.jsp.submit.initial-questions.agreement-info2"/></b></dspace:popup>

	</p>

	<div class="input-group">
		<span class="input-group-addon">
			<input type="checkbox" name="checklist" <%= checklist %> value="true" <%= (subInfo.getSubmissionItem().isPublishedBefore() ? "disabled='disabled'" : "") %> <%= onClick1 %> />
		</span>
		<!-- TODO: Fiks style alt etter valg -->
		<label id="checklistLabel" class="form-control" for="multiple_titles"><fmt:message key="ub.jsp.submit.initial-questions.agreement-master"/></label>
	</div>

<%
	}
%>







<%
    // Don't display thesis questions in workflow mode
    if (!subInfo.isInWorkflow())
    {
        if (ConfigurationManager.getBooleanProperty("webui.submit.blocktheses"))
        {
%>
			<div class="input-group">
                <span class="input-group-addon">
					<input type="checkbox" name="is_thesis" value="true">
				</span>	
				<label class="form-control" for="is_thesis">
					<fmt:message key="jsp.submit.initial-questions.elem4"/>
				</label>
			</div>		
<%
        }
    }
%>
<br/>
		<%-- Hidden fields needed for SubmissionController servlet to know which step is next--%>
        <%= SubmissionController.getSubmissionParameters(context, request) %>
				<%  //if not first step, show "Previous" button
					if(!SubmissionController.isFirstStep(request, subInfo))
					{ %>
					<div class="row">
						<div class="col-md-6 pull-right btn-group">
							<input class="btn btn-default col-md-4" type="submit" name="<%=AbstractProcessingStep.PREVIOUS_BUTTON%>" value="<fmt:message key="jsp.submit.general.previous"/>" />
							<input class="btn btn-default col-md-4" type="submit" name="<%=AbstractProcessingStep.CANCEL_BUTTON%>" value="<fmt:message key="jsp.submit.general.cancel-or-save.button"/>" />
							<%-- Need to enable next-button if javascript is disabled --%>
		 					<script type="text/javascript">
                   				document.write('<input class="btn btn-primary col-md-4" type="submit" name="<%=AbstractProcessingStep.NEXT_BUTTON%>" value="<fmt:message key="jsp.submit.general.next"/>" <%= nextDisabled %> / >');
		 					</script>
							<noscript>
								<input class="btn btn-primary col-md-4" type="submit" name="<%=AbstractProcessingStep.NEXT_BUTTON%>" value="<fmt:message key="jsp.submit.general.next"/>" />
							</noscript>
						</div>
					</div>		
		                       
				<%  } else { %>
    			<div class="row">
					<div class="col-md-4 pull-right btn-group">
						<input class="btn btn-default col-md-6" type="submit" name="<%=AbstractProcessingStep.CANCEL_BUTTON%>" value="<fmt:message key="jsp.submit.general.cancel-or-save.button"/>" />
						<%-- Need to enable next-button if javascript is disabled --%>
		 				<script type="text/javascript">
                   			document.write('<input class="btn btn-primary col-md-6" type="submit" name="<%=AbstractProcessingStep.NEXT_BUTTON%>" value="<fmt:message key="jsp.submit.general.next"/>" <%= nextDisabled %> / >');
		 				</script>
						<noscript>
						<input class="btn btn-primary col-md-6" type="submit" name="<%=AbstractProcessingStep.NEXT_BUTTON%>" value="<fmt:message key="jsp.submit.general.next"/>" />
						</noscript>
					</div>
				</div>		
    			<%  }  %>
    </form>

</dspace:layout>
