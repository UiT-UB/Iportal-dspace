<%--

    The contents of this file are subject to the license and copyright
    detailed in the LICENSE and NOTICE files at the root of the source
    tree and available online at

    http://www.dspace.org/license/

--%>

<%--
  - Display the form to refine the simple-search and dispaly the results of the search
  -
  - Attributes to pass in:
  -
  -   scope            - pass in if the scope of the search was a community
  -                      or a collection
  -   scopes 		   - the list of available scopes where limit the search
  -   sortOptions	   - the list of available sort options
  -   availableFilters - the list of filters available to the user
  -
  -   query            - The original query
  -   queryArgs		   - The query configuration parameters (rpp, sort, etc.)
  -   appliedFilters   - The list of applied filters (user input or facet)
  -
  -   search.error     - a flag to say that an error has occurred
  -   spellcheck	   - the suggested spell check query (if any)
  -   qResults		   - the discovery results
  -   items            - the results.  An array of Items, most relevant first
  -   communities      - results, Community[]
  -   collections      - results, Collection[]
  -
  -   admin_button     - If the user is an admin
  --%>

<%@page import="org.dspace.core.Utils"%>
<%@page import="com.coverity.security.Escape"%>
<%@page import="org.dspace.discovery.configuration.DiscoverySearchFilterFacet"%>
<%@page import="org.dspace.app.webui.util.UIUtil"%>
<%@page import="java.util.HashMap"%>
<%@page import="java.util.ArrayList"%>
<%@page import="org.dspace.discovery.DiscoverFacetField"%>
<%@page import="org.dspace.discovery.configuration.DiscoverySearchFilter"%>
<%@page import="org.dspace.discovery.DiscoverFilterQuery"%>
<%@page import="org.dspace.discovery.DiscoverQuery"%>
<%@page import="org.apache.commons.lang.StringUtils"%>
<%@page import="java.util.Map"%>
<%@page import="org.dspace.discovery.DiscoverResult.FacetResult"%>
<%@page import="org.dspace.discovery.DiscoverResult"%>
<%@page import="org.dspace.content.DSpaceObject"%>
<%@page import="java.util.List"%>
<%@ page contentType="text/html;charset=UTF-8" %>

<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt"
    prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core"
    prefix="c" %>

<%@ taglib uri="http://www.dspace.org/dspace-tags.tld" prefix="dspace" %>
<%@ page import="java.net.URLEncoder"            %>
<%@ page import="org.dspace.content.Community"   %>
<%@ page import="org.dspace.content.Collection"  %>
<%@ page import="org.dspace.content.Item"        %>
<%@ page import="org.dspace.search.QueryResults" %>
<%@ page import="org.dspace.sort.SortOption" %>
<%@ page import="java.util.Enumeration" %>
<%@ page import="java.util.Set" %>
<%
    // Get the attributes
    DSpaceObject scope = (DSpaceObject) request.getAttribute("scope" );
    String searchScope = scope!=null?scope.getHandle():"";
    List<DSpaceObject> scopes = (List<DSpaceObject>) request.getAttribute("scopes");
    List<String> sortOptions = (List<String>) request.getAttribute("sortOptions");

    String query = (String) request.getAttribute("query");
	if (query == null)
	{
	    query = "";
	}
    Boolean error_b = (Boolean)request.getAttribute("search.error");
    boolean error = (error_b == null ? false : error_b.booleanValue());
    
    DiscoverQuery qArgs = (DiscoverQuery) request.getAttribute("queryArgs");
    String sortedBy = qArgs.getSortField();
    String order = qArgs.getSortOrder().toString();
    String ascSelected = (SortOption.ASCENDING.equalsIgnoreCase(order)   ? "selected=\"selected\"" : "");
    String descSelected = (SortOption.DESCENDING.equalsIgnoreCase(order) ? "selected=\"selected\"" : "");
    String httpFilters ="";
	String spellCheckQuery = (String) request.getAttribute("spellcheck");
    List<DiscoverySearchFilter> availableFilters = (List<DiscoverySearchFilter>) request.getAttribute("availableFilters");
	List<String[]> appliedFilters = (List<String[]>) request.getAttribute("appliedFilters");
	List<String> appliedFilterQueries = (List<String>) request.getAttribute("appliedFilterQueries");
	if (appliedFilters != null && appliedFilters.size() >0 ) 
	{
	    int idx = 1;
	    for (String[] filter : appliedFilters)
	    {
	        httpFilters += "&amp;filter_field_"+idx+"="+URLEncoder.encode(filter[0],"UTF-8");
	        httpFilters += "&amp;filter_type_"+idx+"="+URLEncoder.encode(filter[1],"UTF-8");
	        httpFilters += "&amp;filter_value_"+idx+"="+URLEncoder.encode(filter[2],"UTF-8");
	        idx++;
	    }
	}
    int rpp          = qArgs.getMaxResults();
    int etAl         = ((Integer) request.getAttribute("etal")).intValue();

    String[] options = new String[]{"equals","contains","authority","notequals","notcontains","notauthority"};
    
    // Admin user or not
    Boolean admin_b = (Boolean)request.getAttribute("admin_button");
    boolean admin_button = (admin_b == null ? false : admin_b.booleanValue());
%>

<c:set var="dspace.layout.head.last" scope="request">
<script type="text/javascript">
	var jQ = jQuery.noConflict();
	jQ(document).ready(function() {
		jQ( "#spellCheckQuery").click(function(){
			jQ("#query").val(jQ(this).attr('data-spell'));
			jQ("#main-query-submit").click();
		});
		jQ( "#filterquery" )
			.autocomplete({
				source: function( request, response ) {
					jQ.ajax({
						url: "<%= request.getContextPath() %>/json/discovery/autocomplete?query=<%= URLEncoder.encode(query,"UTF-8")%><%= httpFilters.replaceAll("&amp;","&") %>",
						dataType: "json",
						cache: false,
						data: {
							auto_idx: jQ("#filtername").val(),
							auto_query: request.term,
							auto_sort: 'count',
							auto_type: jQ("#filtertype").val(),
							location: '<%= searchScope %>'	
						},
						success: function( data ) {
							response( jQ.map( data.autocomplete, function( item ) {
								var tmp_val = item.authorityKey;
								if (tmp_val == null || tmp_val == '')
								{
									tmp_val = item.displayedValue;
								}
								return {
									label: item.displayedValue + " (" + item.count + ")",
									value: tmp_val
								};
							}))			
						}
					})
				}
			});
	});
	function validateFilters() {
		return document.getElementById("filterquery").value.length > 0;
	}
</script>		
</c:set>

<dspace:layout titlekey="jsp.search.title" locbar="off">


</dspace:layout>

