<%--

    The contents of this file are subject to the license and copyright
    detailed in the LICENSE and NOTICE files at the root of the source
    tree and available online at

    http://www.dspace.org/license/

--%>
<%--
  - UI page for selection of collection.
  -
  - Required attributes:
  -    collections - Array of collection objects to show in the drop-down.
  --%>

<%@ page contentType="text/html;charset=UTF-8" %>

<%@ page import="javax.servlet.jsp.jstl.fmt.LocaleSupport" %>

<%@ page import="org.dspace.core.Context" %>
<%@ page import="org.dspace.app.webui.servlet.SubmissionController" %>
<%@ page import="org.dspace.submit.AbstractProcessingStep" %>
<%@ page import="org.dspace.app.webui.util.UIUtil" %>
<%@ page import="org.dspace.content.Collection" %>

<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt"
    prefix="fmt" %>
	
<%@ taglib uri="http://www.dspace.org/dspace-tags.tld" prefix="dspace" %>

<%
    request.setAttribute("LanguageSwitch", "hide");

    //get collections to choose from
    Collection[] collections =
        (Collection[]) request.getAttribute("collections");

	//check if we need to display the "no collection selected" error
    Boolean noCollection = (Boolean) request.getAttribute("no.collection");

    // Obtain DSpace context
    Context context = UIUtil.obtainContext(request);
%>

<%-- KM: Puts the course code into a parameter.--%>
<script type="text/javascript" language="JavaScript">

	 // Sets an http parameter value for course code and department, and enable the submit next button
	 function setHidden(course, departmentid, departmentname) {
	     document.forms[0].courseID.value = course;
	     document.forms[0].departmentID.value = departmentid;
         document.forms[0].departmentName.value = departmentname;

		 document.forms[0].<%=AbstractProcessingStep.NEXT_BUTTON%>.disabled = "";
     }
	
     // Turn on and off visibility of lists
     function showHide(listType) {

         node = document.getElementById(listType);

         if(node.style.display == 'block'){
             node.style.display = 'none';
         }
         else {
             node.style.display = 'block';
         }
     }
</script>


<dspace:layout style="submission" locbar="off"
               navbar="off"
               titlekey="jsp.submit.select-collection.title"
               nocache="true">

    <h1><fmt:message key="jsp.submit.select-collection.heading"/>
    <%--<dspace:popup page="<%= LocaleSupport.getLocalizedMessage(pageContext, \"help.index\") + \"#choosecollection\"%>"><fmt:message key="jsp.morehelp"/> </dspace:popup>--%>
      </h1>

	
<%  if (collections.length > 0)
    {
%>
<%--<p><fmt:message key="jsp.submit.select-collection.info1"/></p>--%>

    <form action="<%= request.getContextPath() %>/submit" method="post" onkeydown="return disableEnterKey(event);">
<%
		//if no collection was selected, display an error
		if((noCollection != null) && (noCollection.booleanValue()==true))
		{
%>
					<div class="alert alert-warning"><fmt:message key="jsp.submit.select-collection.no-collection"/></div>
<%
		}
%>            

<%-- Fjerne mastergrader --%>

	<div class="row padding-topbtm-15px">
	<input type="button" class="btn btn-success col-md-4" name="deposit_master" value="<fmt:message key="ub.jsp.submit.select-collection.deposit-master"/>" onclick="javascript:showHide('master-list');" />
	</div>

    <div id="master-list" style="display: none;">

        <b><fmt:message key="ub.jsp.submit.select-collection.choice-master"/></b>
        <br /><br />
        <fmt:message key="jsp.submit.select-collection.info1"/>

		<%-- Course list --%>

        <dspace:courses />

        <input type="hidden" name="courseID" />
        <input type="hidden" name="departmentID" />
        <input type="hidden" name="departmentName" />

    </div>


	<div class="row padding-topbtm-15px">
	<input type="button" class="btn btn-success col-md-4" name="deposit_doctor" value="<fmt:message key="ub.jsp.submit.select-collection.deposit-doctor"/>" onclick="showHide('doktor-list');" />
	</div>

    <div id="doktor-list" style="display: none;">
		<b><fmt:message key="ub.jsp.submit.select-collection.choice-doctor"/></b>
		<br /><br />
		<fmt:message key="ub.jsp.submit.select-collection.choose-faculty"/>

        <ul class="controlledvocabulary">
          <li>
            <table>
              <tr>
                <td>
                  <input onclick="setHidden('DOKTOR-001', '0', '');" value="53" id="tcollection" name="collection" class="controlledvocabulary" type="radio" />
                </td>
                <td>
                  <fmt:message key="ub.jsp.submit.select-collection.DOKTOR-001"/>
                </td>
              </tr>
              <tr>
                <td>
                  <input onclick="setHidden('DOKTOR-002', '0', '');" value="56" id="tcollection" name="collection" class="controlledvocabulary" type="radio" />
                </td>
                <td>
                  <fmt:message key="ub.jsp.submit.select-collection.DOKTOR-002"/>
                </td>
              </tr>
              <tr>
                <td>
                  <input onclick="setHidden('DOKTOR-003', '0', '');" value="58" id="tcollection" name="collection" class="controlledvocabulary" type="radio" />
                </td>
                <td>
                  <fmt:message key="ub.jsp.submit.select-collection.DOKTOR-003"/>
                </td>
              </tr>
              <tr>
                <td>
                  <input onclick="setHidden('DOKTOR-004', '0', '');" value="54" id="tcollection" name="collection" class="controlledvocabulary" type="radio" />
                </td>
                <td>
                  <fmt:message key="ub.jsp.submit.select-collection.DOKTOR-004"/>
                </td>
              </tr>
              <tr>
                <td>
                  <input onclick="setHidden('DOKTOR-005', '0', '');" value="57" id="tcollection" name="collection" class="controlledvocabulary" type="radio" />
                </td>
                <td>
                  <fmt:message key="ub.jsp.submit.select-collection.DOKTOR-005"/>
                </td>
              </tr>

              <tr>
                <td>
                  <input onclick="setHidden('DOKTOR-006', '0', '');" value="92" id="tcollection" name="collection" class="controlledvocabulary" type="radio" />
                </td>
                <td>
                  <fmt:message key="ub.jsp.submit.select-collection.DOKTOR-006"/>
                </td>
              </tr>

              <tr>
                <td>
                  <input onclick="setHidden('DOKTOR-008', '0', '');" value="89" id="tcollection" name="collection" class="controlledvocabulary" type="radio" />
                </td>
                <td>
                  <fmt:message key="ub.jsp.submit.select-collection.DOKTOR-008"/>
                </td>
              </tr>
            </table>
          </li>
        </ul>
    </div>
<%--            
					<div class="input-group">
					<label for="tcollection" class="input-group-addon">
						<fmt:message key="jsp.submit.select-collection.collection"/>
					</label>
                    <select class="form-control" name="collection" id="tcollection">
                    	<option value="-1"></option>
<%
        for (int i = 0; i < collections.length; i++)
        {
%>
                            <option value="<%= collections[i].getID() %>"><%= collections[i].getMetadata("name") %></option>
<%
        }
%>
                        </select>
					</div><br/>
--%>

            <%-- Hidden fields needed for SubmissionController servlet to know which step is next--%>
            <%= SubmissionController.getSubmissionParameters(context, request) %>

				<div class="row">
					<div class="col-md-4 pull-right btn-group">
						<input class="btn btn-default col-md-6" type="submit" name="<%=AbstractProcessingStep.CANCEL_BUTTON%>" value="<fmt:message key="jsp.submit.select-collection.cancel"/>" />
						<input class="btn btn-primary col-md-6" type="submit" name="<%=AbstractProcessingStep.NEXT_BUTTON%>" value="<fmt:message key="jsp.submit.general.next"/>" disabled="disabled" />
					</div>
				</div>		
    </form>
<%  } else { %>
	<p class="alert alert-warning"><fmt:message key="jsp.submit.select-collection.none-authorized"/></p>
<%  } %>	
<%-- KM: Don't show navigation links --%>	
	<%--
	   <p><fmt:message key="jsp.general.goto"/><br />
	   <a href="<%= request.getContextPath() %>"><fmt:message key="jsp.general.home"/></a><br />
	   <a href="<%= request.getContextPath() %>/mydspace"><fmt:message key="jsp.general.mydspace" /></a>
	   </p>	
	--%>
</dspace:layout>
