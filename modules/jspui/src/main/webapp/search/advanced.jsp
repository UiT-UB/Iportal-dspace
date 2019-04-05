<%--

    The contents of this file are subject to the license and copyright
    detailed in the LICENSE and NOTICE files at the root of the source
    tree and available online at

    http://www.dspace.org/license/

--%>
<%--
  - Advanced Search JSP
  -
  -
  -
  --%>

<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="org.apache.commons.lang.StringEscapeUtils" %>
<%@ page import="org.dspace.content.Community" %>
<%@ page import="org.dspace.search.QueryResults" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="org.dspace.core.ConfigurationManager" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://www.dspace.org/dspace-tags.tld" prefix="dspace" %>


<%
    Community [] communityArray = (Community[] )request.getAttribute("communities");
	String query1 			= request.getParameter("query1") == null ? "" : request.getParameter("query1");
	String query2 			= request.getParameter("query2") == null ? "" : request.getParameter("query2");
	String query3 			= request.getParameter("query3") == null ? "" : request.getParameter("query3");

	String field1 			= request.getParameter("field1") == null ? "ANY" : request.getParameter("field1");
	String field2 			= request.getParameter("field2") == null ? "ANY" : request.getParameter("field2");
	String field3 			= request.getParameter("field3") == null ? "ANY" : request.getParameter("field3");

	String conjunction1 	= request.getParameter("conjunction1") == null ? "AND" : request.getParameter("conjunction1");
	String conjunction2 	= request.getParameter("conjunction2") == null ? "AND" : request.getParameter("conjunction2");

        QueryResults qResults = (QueryResults)request.getAttribute("queryresults");

	//Read the configuration to find out the search indices dynamically
	int idx = 1;
	String definition;
	ArrayList<String> searchIndices = new ArrayList<String>();
	int dateIndex = -1;
	String dateIndexConfig = ConfigurationManager.getProperty("search.index.date");

	while ( ((definition = ConfigurationManager.getProperty("jspui.search.index.display." + idx))) != null){
	        
		String index = definition;
		searchIndices.add(index);
		if (index.equals(dateIndexConfig))
			dateIndex = idx+1;
	    idx++;
	 }
	
	// backward compatibility
	if (searchIndices.size() == 0)
	{
	    searchIndices.add("ANY");
	    searchIndices.add("author");
        searchIndices.add("title");
        searchIndices.add("keyword");
        searchIndices.add("abstract");
        searchIndices.add("series");
        searchIndices.add("sponsor");
        searchIndices.add("identifier");
        searchIndices.add("language");
	}
%>

<dspace:layout locbar="off" titlekey="jsp.search.advanced.title">



</dspace:layout>
