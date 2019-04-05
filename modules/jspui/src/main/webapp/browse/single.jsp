<%--

    The contents of this file are subject to the license and copyright
    detailed in the LICENSE and NOTICE files at the root of the source
    tree and available online at

    http://www.dspace.org/license/

--%>
<%--
  - 
  --%>

<%@ page contentType="text/html;charset=UTF-8" %>

<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<%@ taglib uri="http://www.dspace.org/dspace-tags.tld" prefix="dspace" %>

<%@ page import="org.dspace.browse.BrowseInfo" %>
<%@ page import="org.dspace.browse.BrowseIndex" %>
<%@ page import="org.dspace.content.Collection" %>
<%@ page import="org.dspace.content.Community" %>
<%@ page import="org.dspace.content.DCDate" %>
<%@ page import="java.net.URLEncoder" %>
<%@ page import="org.dspace.core.Utils" %>
<%@ page import="org.dspace.app.webui.util.UIUtil" %>
<%@ page import="org.apache.commons.lang.StringUtils" %>

<%
    request.setAttribute("LanguageSwitch", "hide");

	//First, get the browse info object
	BrowseInfo bi = (BrowseInfo) request.getAttribute("browse.info");
	BrowseIndex bix = bi.getBrowseIndex();

	//values used by the header
	String scope = "";
	String type = "";

	Community community = null;
	Collection collection = null;
	if (bi.inCommunity())
	{
		community = (Community) bi.getBrowseContainer();
	}
	if (bi.inCollection())
	{
		collection = (Collection) bi.getBrowseContainer();
	}
	
	if (community != null)
	{
		scope = "\"" + community.getMetadata("name") + "\"";
	}
	if (collection != null)
	{
		scope = "\"" + collection.getMetadata("name") + "\"";
	}
	
	type = bix.getName();
	
	//FIXME: so this can probably be placed into the Messages.properties file at some point
	// String header = "Browsing " + scope + " by " + type;
	
	// get the values together for reporting on the browse values
	// String range = "Showing results " + bi.getStart() + " to " + bi.getFinish() + " of " + bi.getTotal();
	
	// prepare the next and previous links
	String linkBase = request.getContextPath() + "/";
	if (collection != null)
	{
		linkBase = linkBase + "handle/" + collection.getHandle() + "/";
	}
	if (community != null)
	{
		linkBase = linkBase + "handle/" + community.getHandle() + "/";
	}
	
	String direction = (bi.isAscending() ? "ASC" : "DESC");
	String sharedLink = linkBase + "browse?type=" + URLEncoder.encode(bix.getName(), "UTF-8") +
						"&amp;order=" + URLEncoder.encode(direction, "UTF-8") +
						"&amp;rpp=" + URLEncoder.encode(Integer.toString(bi.getResultsPerPage()), "UTF-8");
	
	// prepare the next and previous links
	String next = sharedLink;
	String prev = sharedLink;
	
	if (bi.hasNextPage())
    {
        next = next + "&amp;offset=" + bi.getNextOffset();
    }

	if (bi.hasPrevPage())
    {
        prev = prev + "&amp;offset=" + bi.getPrevOffset();
    }

	// prepare a url for use by form actions
	String formaction = request.getContextPath() + "/";
	if (collection != null)
	{
		formaction = formaction + "handle/" + collection.getHandle() + "/";
	}
	if (community != null)
	{
		formaction = formaction + "handle/" + community.getHandle() + "/";
	}
	formaction = formaction + "browse";
	
	String ascSelected = (bi.isAscending() ? "selected=\"selected\"" : "");
	String descSelected = (bi.isAscending() ? "" : "selected=\"selected\"");
	int rpp = bi.getResultsPerPage();
	
//	 the message key for the type
	String typeKey = "browse.type.metadata." + bix.getName();
%>

<dspace:layout titlekey="browse.page-title" navbar="default" locbar="off">

    
</dspace:layout>
