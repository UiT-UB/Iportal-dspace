<%--

    The contents of this file are subject to the license and copyright
    detailed in the LICENSE and NOTICE files at the root of the source
    tree and available online at

    http://www.dspace.org/license/

--%>
<%--
  - Default navigation bar
--%>

<%@page import="org.apache.commons.lang.StringUtils"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<%@ page contentType="text/html;charset=UTF-8" %>

<%@ taglib uri="/WEB-INF/dspace-tags.tld" prefix="dspace" %>

<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.List" %>
<%@ page import="javax.servlet.jsp.jstl.fmt.LocaleSupport" %>
<%@ page import="org.dspace.app.webui.util.UIUtil" %>
<%@ page import="org.dspace.content.Collection" %>
<%@ page import="org.dspace.content.Community" %>
<%@ page import="org.dspace.eperson.EPerson" %>
<%@ page import="org.dspace.core.ConfigurationManager" %>
<%@ page import="org.dspace.browse.BrowseIndex" %>
<%@ page import="org.dspace.browse.BrowseInfo" %>
<%@ page import="java.util.Map" %>
<%
    // Is anyone logged in?
    EPerson user = (EPerson) request.getAttribute("dspace.current.user");

    // Is the logged in user an admin
    Boolean admin = (Boolean)request.getAttribute("is.admin");
    boolean isAdmin = (admin == null ? false : admin.booleanValue());

    // Get the current page, minus query string
    String currentPage = UIUtil.getOriginalURL(request);
    int c = currentPage.indexOf( '?' );
    if( c > -1 )
    {
        currentPage = currentPage.substring( 0, c );
    }

    // E-mail may have to be truncated
    String navbarEmail = null;
    String navbarFullName = null;

    if (user != null)
    {
        navbarEmail = user.getEmail();
	navbarFullName = user.getFullName();
    }
%>


       <div class="navbar-header navbar-background">
	 <a class="navbar-brand" href="<%= request.getContextPath() %>/"><img height="100px" src="<%= request.getContextPath() %>/image/<fmt:message key="ub.jsp.navnetrekk-file"/>" /></a>
       </div>
       <nav class="collapse navbar-collapse bs-navbar-collapse navbar-background" role="navigation">
       <div class="nav navbar-nav navbar-right">
	 <ul class="nav navbar-nav navbar-right">
 
         <li class="right-menu">
         <%
    if (user != null)
    {
	 %>
		  <a href="#" class="user"><span class="glyphicon glyphicon-user"></span><%= StringUtils.abbreviate(navbarFullName, 40) %></a>
	 <%
    }
	 %>
	 </li>

          </ul>
          
	</div>
    </nav>
