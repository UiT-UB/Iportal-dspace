<%--

    The contents of this file are subject to the license and copyright
    detailed in the LICENSE and NOTICE files at the root of the source
    tree and available online at

    http://www.dspace.org/license/

--%>
<%--
  - Display the results of browsing a full hit list
  --%>

<%@ page contentType="text/html;charset=UTF-8" %>

<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<%@ taglib uri="http://www.dspace.org/dspace-tags.tld" prefix="dspace" %>

<%@ page import="org.dspace.browse.BrowseInfo" %>
<%@ page import="org.dspace.sort.SortOption" %>
<%@ page import="org.dspace.content.Collection" %>
<%@ page import="org.dspace.content.Community" %>
<%@ page import="org.dspace.browse.BrowseIndex" %>
<%@ page import="org.dspace.core.ConfigurationManager" %>
<%@ page import="java.net.URLEncoder" %>
<%@ page import="org.dspace.content.DCDate" %>
<%@ page import="org.dspace.app.webui.util.UIUtil" %>

<%
    request.setAttribute("LanguageSwitch", "hide");

    String urlFragment = "browse";
    String layoutNavbar = "default";
    boolean withdrawn = false;
    boolean privateitems = false;
	if (request.getAttribute("browseWithdrawn") != null)
	{
	    layoutNavbar = "admin";
        urlFragment = "dspace-admin/withdrawn";
        withdrawn = true;
    }
	else if (request.getAttribute("browsePrivate") != null)
	{
	    layoutNavbar = "admin";
        urlFragment = "dspace-admin/privateitems";
        privateitems = true;
    }

	// First, get the browse info object
	BrowseInfo bi = (BrowseInfo) request.getAttribute("browse.info");
	BrowseIndex bix = bi.getBrowseIndex();
	SortOption so = bi.getSortOption();

	// values used by the header
	String scope = "";
	String type = "";
	String value = "";
	
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
	
	// next and previous links are of the form:
	// [handle/<prefix>/<suffix>/]browse?type=<type>&sort_by=<sort_by>&order=<order>[&value=<value>][&rpp=<rpp>][&[focus=<focus>|vfocus=<vfocus>]
	
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
	
	String argument = null;
	if (bi.hasAuthority())
    {
        value = bi.getAuthority();
        argument = "authority";
    }
	else if (bi.hasValue())
	{
		value = bi.getValue();
	    argument = "value";
	}

	String valueString = "";
	if (value!=null)
	{
		valueString = "&amp;" + argument + "=" + URLEncoder.encode(value, "UTF-8");
	}
	
    String sharedLink = linkBase + urlFragment + "?";

    if (bix.getName() != null)
        sharedLink += "type=" + URLEncoder.encode(bix.getName(), "UTF-8");

    sharedLink += "&amp;sort_by=" + URLEncoder.encode(Integer.toString(so.getNumber()), "UTF-8") +
				  "&amp;order=" + URLEncoder.encode(direction, "UTF-8") +
				  "&amp;rpp=" + URLEncoder.encode(Integer.toString(bi.getResultsPerPage()), "UTF-8") +
				  "&amp;etal=" + URLEncoder.encode(Integer.toString(bi.getEtAl()), "UTF-8") +
				  valueString;
	
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
	formaction = formaction + urlFragment;
	
	// prepare the known information about sorting, ordering and results per page
	String sortedBy = so.getName();
	String ascSelected = (bi.isAscending() ? "selected=\"selected\"" : "");
	String descSelected = (bi.isAscending() ? "" : "selected=\"selected\"");
	int rpp = bi.getResultsPerPage();
	
	// the message key for the type
	String typeKey;

	if (bix.isMetadataIndex())
		typeKey = "browse.type.metadata." + bix.getName();
	else if (bi.getSortOption() != null)
		typeKey = "browse.type.item." + bi.getSortOption().getName();
	else
		typeKey = "browse.type.item." + bix.getSortOption().getName();

    // Admin user or not
    Boolean admin_b = (Boolean)request.getAttribute("admin_button");
    boolean admin_button = (admin_b == null ? false : admin_b.booleanValue());
%>

<%-- OK, so here we start to develop the various components we will use in the UI --%>

<%@page import="java.util.Set"%>
<dspace:layout titlekey="browse.page-title" navbar="<%=layoutNavbar %>" locbar="off">



</dspace:layout>