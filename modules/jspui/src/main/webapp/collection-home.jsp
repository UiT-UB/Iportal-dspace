<%--

    The contents of this file are subject to the license and copyright
    detailed in the LICENSE and NOTICE files at the root of the source
    tree and available online at

    http://www.dspace.org/license/

--%>
<%--
  - Collection home JSP
  -
  - Attributes required:
  -    collection  - Collection to render home page for
  -    community   - Community this collection is in
  -    last.submitted.titles - String[], titles of recent submissions
  -    last.submitted.urls   - String[], corresponding URLs
  -    logged.in  - Boolean, true if a user is logged in
  -    subscribed - Boolean, true if user is subscribed to this collection
  -    admin_button - Boolean, show admin 'edit' button
  -    editor_button - Boolean, show collection editor (edit submitters, item mapping) buttons
  -    show.items - Boolean, show item list
  -    browse.info - BrowseInfo, item list
  --%>

<%@ page contentType="text/html;charset=UTF-8" %>

<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://www.dspace.org/dspace-tags.tld" prefix="dspace" %>

<%@ page import="org.dspace.app.webui.components.RecentSubmissions" %>

<%@ page import="org.dspace.app.webui.servlet.admin.EditCommunitiesServlet" %>
<%@ page import="org.dspace.app.webui.util.UIUtil" %>
<%@ page import="org.dspace.browse.BrowseIndex" %>
<%@ page import="org.dspace.browse.BrowseInfo" %>
<%@ page import="org.dspace.browse.ItemCounter"%>
<%@ page import="org.dspace.content.*"%>
<%@ page import="org.dspace.core.ConfigurationManager"%>
<%@ page import="org.dspace.core.Context" %>
<%@ page import="org.dspace.core.Utils" %>
<%@ page import="org.dspace.eperson.Group"     %>
<%@ page import="javax.servlet.jsp.jstl.fmt.LocaleSupport" %>
<%@ page import="java.net.URLEncoder" %>

<%@ page import="org.apache.commons.lang.StringUtils" %>


<%
    // Retrieve attributes
    Collection collection = (Collection) request.getAttribute("collection");
    Community  community  = (Community) request.getAttribute("community");
    Group      submitters = (Group) request.getAttribute("submitters");

    RecentSubmissions rs = (RecentSubmissions) request.getAttribute("recently.submitted");
    
    boolean loggedIn =
        ((Boolean) request.getAttribute("logged.in")).booleanValue();
    boolean subscribed =
        ((Boolean) request.getAttribute("subscribed")).booleanValue();
    Boolean admin_b = (Boolean)request.getAttribute("admin_button");
    boolean admin_button = (admin_b == null ? false : admin_b.booleanValue());

    Boolean editor_b      = (Boolean)request.getAttribute("editor_button");
    boolean editor_button = (editor_b == null ? false : editor_b.booleanValue());

    Boolean submit_b      = (Boolean)request.getAttribute("can_submit_button");
    boolean submit_button = (submit_b == null ? false : submit_b.booleanValue());

	// get the browse indices
    BrowseIndex[] bis = BrowseIndex.getBrowseIndices();

    // Put the metadata values into guaranteed non-null variables
    String name = collection.getMetadata("name");
    String intro = collection.getMetadata("introductory_text");
    if (intro == null)
    {
        intro = "";
    }
    String copyright = collection.getMetadata("copyright_text");
    if (copyright == null)
    {
        copyright = "";
    }
    String sidebar = collection.getMetadata("side_bar_text");
    if(sidebar == null)
    {
        sidebar = "";
    }

    String communityName = community.getMetadata("name");
    String communityLink = "/handle/" + community.getHandle();

    Bitstream logo = collection.getLogo();
    
    boolean feedEnabled = ConfigurationManager.getBooleanProperty("webui.feed.enable");
    String feedData = "NONE";
    if (feedEnabled)
    {
        feedData = "coll:" + ConfigurationManager.getProperty("webui.feed.formats");
    }
    
    ItemCounter ic = new ItemCounter(UIUtil.obtainContext(request));

    Boolean showItems = (Boolean)request.getAttribute("show.items");
    boolean show_items = showItems != null ? showItems.booleanValue() : false;
%>

<%@page import="org.dspace.app.webui.servlet.MyDSpaceServlet"%>
<dspace:layout locbar="commLink" title="<%= name %>" feedData="<%= feedData %>">
    <div class="well">
    <div class="row"><div class="col-md-8"><h2><%= name %>
<%
            if(ConfigurationManager.getBooleanProperty("webui.strengths.show"))
            {
%>
                : [<%= ic.getCount(collection) %>]
<%
            }
%>
		<small><fmt:message key="jsp.collection-home.heading1"/></small>
      <%--<a class="statisticsLink btn btn-info" href="<%= request.getContextPath() %>/handle/<%= collection.getHandle() %>/statistics"><fmt:message key="jsp.collection-home.display-statistics"/></a>--%>
      </h2></div>
<%  if (logo != null) { %>
        <div class="col-md-4">
        	<img class="img-responsive pull-right" alt="Logo" src="<%= request.getContextPath() %>/retrieve/<%= logo.getID() %>" />
        </div>
<% 	} %>
	</div>
<%
	if (StringUtils.isNotBlank(intro)) { %>
	<%= intro %>
<% 	} %>
  </div>
  <p class="copyrightText"><%= copyright %></p>
  
  <%-- Browse --%>
  <div class="panel panel-primary">
  	<div class="panel-heading">
        <fmt:message key="jsp.general.browse"/>
	</div>
	<div class="panel-body">
	<%-- Insert the dynamic list of browse options --%>
<%
	for (int i = 0; i < bis.length; i++)
	{
		String key = "browse.menu." + bis[i].getName();
%>
	<form method="get" action="<%= request.getContextPath() %>/handle/<%= collection.getHandle() %>/browse">
		<input type="hidden" name="type" value="<%= bis[i].getName() %>"/>
		<%-- <input type="hidden" name="collection" value="<%= collection.getHandle() %>" /> --%>
		<input type="submit" class="btn btn-default col-md-2" name="submit_browse" value="<fmt:message key="<%= key %>"/>"/>
	</form>
<%	
	}
%>	</div>
</div>

  <dspace:sidebar>
<% if(admin_button || editor_button ) { %>
                 <div class="panel panel-warning">
                 <div class="panel-heading"><fmt:message key="jsp.admintools"/>
                 	<span class="pull-right"><dspace:popup page="<%= LocaleSupport.getLocalizedMessage(pageContext, \"help.collection-admin\")%>"><fmt:message key="jsp.adminhelp"/></dspace:popup></span>
                 </div>
                 <div class="panel-body">              
<% if( editor_button ) { %>
                <form method="post" action="<%=request.getContextPath()%>/tools/edit-communities">
                  <input type="hidden" name="collection_id" value="<%= collection.getID() %>" />
                  <input type="hidden" name="community_id" value="<%= community.getID() %>" />
                  <input type="hidden" name="action" value="<%= EditCommunitiesServlet.START_EDIT_COLLECTION %>" />
                  <input class="btn btn-default col-md-12" type="submit" value="<fmt:message key="jsp.general.edit.button"/>" />
                </form>
<% } %>

<% if( admin_button ) { %>
                 <form method="post" action="<%=request.getContextPath()%>/tools/itemmap">
                  <input type="hidden" name="cid" value="<%= collection.getID() %>" />
				  <input class="btn btn-default col-md-12" type="submit" value="<fmt:message key="jsp.collection-home.item.button"/>" />                  
                </form>
<% if(submitters != null) { %>
		      <form method="get" action="<%=request.getContextPath()%>/tools/group-edit">
		        <input type="hidden" name="group_id" value="<%=submitters.getID()%>" />
		        <input class="btn btn-default col-md-12" type="submit" name="submit_edit" value="<fmt:message key="jsp.collection-home.editsub.button"/>" />
		      </form>
<% } %>
<% if( editor_button || admin_button) { %>
                <form method="post" action="<%=request.getContextPath()%>/mydspace">
                  <input type="hidden" name="collection_id" value="<%= collection.getID() %>" />
                  <input type="hidden" name="step" value="<%= MyDSpaceServlet.REQUEST_EXPORT_ARCHIVE %>" />
                  <input class="btn btn-default col-md-12" type="submit" value="<fmt:message key="jsp.mydspace.request.export.collection"/>" />
                </form>
               <form method="post" action="<%=request.getContextPath()%>/mydspace">
                 <input type="hidden" name="collection_id" value="<%= collection.getID() %>" />
                 <input type="hidden" name="step" value="<%= MyDSpaceServlet.REQUEST_MIGRATE_ARCHIVE %>" />
                 <input class="btn btn-default col-md-12" type="submit" value="<fmt:message key="jsp.mydspace.request.export.migratecollection"/>" />
               </form>
               <form method="post" action="<%=request.getContextPath()%>/dspace-admin/metadataexport">
                 <input type="hidden" name="handle" value="<%= collection.getHandle() %>" />
                 <input class="btn btn-default col-md-12" type="submit" value="<fmt:message key="jsp.general.metadataexport.button"/>" />
               </form>
               </div>
               </div>
<% } %>
                 
<% } %>

<%  } %>

<%
	if (rs != null)
	{
%>
	<h3><fmt:message key="jsp.collection-home.recentsub"/></h3>
<%
		Item[] items = rs.getRecentSubmissions();
		for (int i = 0; i < items.length; i++)
		{
			DCValue[] dcv = items[i].getMetadata("dc", "title", null, Item.ANY);
			String displayTitle = "Untitled";
			if (dcv != null)
			{
				if (dcv.length > 0)
				{
					displayTitle = Utils.addEntities(dcv[0].value);
				}
			}
			%><p class="recentItem"><a href="<%= request.getContextPath() %>/handle/<%= items[i].getHandle() %>"><%= displayTitle %></a></p><%
		}
%>
    <p>&nbsp;</p>
<%      } %>

    <%= sidebar %>
    <%
    	int discovery_panel_cols = 12;
    	int discovery_facet_cols = 12;
    %>
    <%-- <%@ include file="discovery/static-sidebar-facet.jsp" %> --%>
  </dspace:sidebar>


</dspace:layout>

