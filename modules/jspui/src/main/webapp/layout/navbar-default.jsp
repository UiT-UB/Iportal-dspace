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

<%@ page import="java.util.Locale"%>
<%@ page import="javax.servlet.jsp.jstl.core.*" %>
<%@ page import="org.dspace.core.I18nUtil" %>
<%@ page import="org.apache.commons.lang3.text.WordUtils" %>


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
    
    // get the browse indices
    
	BrowseIndex[] bis = BrowseIndex.getBrowseIndices();
    BrowseInfo binfo = (BrowseInfo) request.getAttribute("browse.info");
    String browseCurrent = "";
    if (binfo != null)
    {
        BrowseIndex bix = binfo.getBrowseIndex();
        // Only highlight the current browse, only if it is a metadata index,
        // or the selected sort option is the default for the index
        if (bix.isMetadataIndex() || bix.getSortOption() == binfo.getSortOption())
        {
            if (bix.getName() != null)
    			browseCurrent = bix.getName();
        }
    }

    //KM: Added
    Locale[] supportedLocales = I18nUtil.getSupportedLocales();
    Locale sessionLocale = UIUtil.getSessionLocale(request);
    Config.set(request.getSession(), Config.FMT_LOCALE, sessionLocale);
%>


       <div class="navbar-header">
         <button type="button" class="navbar-toggle" data-toggle="collapse" data-target=".navbar-collapse">
           <span class="icon-bar"></span>
           <span class="icon-bar"></span>
           <span class="icon-bar"></span>
         </button>
         <%--<a class="navbar-brand" href="<%= request.getContextPath() %>/"><img height="25px" src="<%= request.getContextPath() %>/image/dspace-logo-only.png" /></a>--%>
	 <a class="navbar-brand" href="<%= request.getContextPath() %>/">
		 <img class="img-responsive" src="<%= request.getContextPath() %>/image/<fmt:message key="ub.jsp.navnetrekk-file"/>" alt="<fmt:message key="ub.jsp.logo"/>" />
	 </a>
	 <a class="navbar-brand-bottom" href="<%= request.getContextPath() %>/">
		 <img class="img-responsive banner-bottom" src="<%= request.getContextPath() %>/image/banner-bottom.png" alt="<fmt:message key="ub.jsp.logo-bottom"/>" /> 
	 </a>

       </div>
       <nav class="collapse navbar-collapse bs-navbar-collapse" role="navigation">


<%--
         <ul class="nav navbar-nav">
           <li class="<%= currentPage.endsWith("/home.jsp")? "active" : "" %>"><a href="<%= request.getContextPath() %>/"><span class="glyphicon glyphicon-home"></span> <fmt:message key="jsp.layout.navbar-default.home"/></a></li>
                
           <li class="dropdown">
             <a href="#" class="dropdown-toggle" data-toggle="dropdown"><fmt:message key="jsp.layout.navbar-default.browse"/> <b class="caret"></b></a>
             <ul class="dropdown-menu">
               <li><a href="<%= request.getContextPath() %>/community-list"><fmt:message key="jsp.layout.navbar-default.communities-collections"/></a></li>
				<li class="divider"></li>
				<li class="dropdown-header">Browse Items by:</li>
								
				<%
	                          //Insert the dynamic browse indices here
					for (int i = 0; i < bis.length; i++)
					{
						BrowseIndex bix = bis[i];
						String key = "browse.menu." + bix.getName();
					%>
				      			<li><a href="<%= request.getContextPath() %>/browse?type=<%= bix.getName() %>"><fmt:message key="<%= key %>"/></a></li>
					<%	
					}

					//End of dynamic browse indices 
				%>

            </ul>
          </li>
          <li class="<%= ( currentPage.endsWith( "/help" ) ? "active" : "" ) %>"><dspace:popup page="<%= LocaleSupport.getLocalizedMessage(pageContext, \"help.index\") %>"><fmt:message key="jsp.layout.navbar-default.help"/></dspace:popup></li>
       </ul>
--%>


   <div class="nav navbar-nav navbar-right">
     <ul class="nav navbar-nav navbar-right">

<% if (supportedLocales != null && supportedLocales.length > 1)
{
%>
        <form method="get" name="repost" action="">
          <input type ="hidden" name ="locale"/>
        </form>
<%
for (int i = supportedLocales.length-1; i >= 0; i--)
{
%>
      <li class="right-menu-lang">
	<img border="0" src="<%= request.getContextPath() %>/image/lang-<%=supportedLocales[i].toString()%>.gif" alt="<%= WordUtils.capitalize(supportedLocales[i].getDisplayLanguage(supportedLocales[i]))%>" />
        <a class="langChangeOn"
                  onclick="javascript:document.repost.locale.value='<%=supportedLocales[i].toString()%>';
                  document.repost.submit();">
		  <%= WordUtils.capitalize(supportedLocales[i].getDisplayLanguage(supportedLocales[i]))%>
		</a>
      </li>
<%
}
}
%>

</ul>

<ul class="nav navbar-nav navbar-right user-menu">

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

	 <%
	   if (isAdmin)
	       {
	 %>
	 <li class="divider"></li>  
	 <li class="right-menu"><a href="<%= request.getContextPath() %>/dspace-admin"><fmt:message key="jsp.administer"/></a></li>
	 <%
	   }

	   if (user != null) {
	 %>
	 <li class="right-menu"><a href="<%= request.getContextPath() %>/logout"><span class="glyphicon glyphicon-log-out"></span> <fmt:message key="jsp.layout.navbar-default.logout"/></a></li>
	 <% } %>

        
          </ul>




	<%-- Search Box --%>
<%--
	<form method="get" action="<%= request.getContextPath() %>/simple-search" class="navbar-form navbar-right" scope="search">
	    <div class="form-group">
          <input type="text" class="form-control" placeholder="<fmt:message key="jsp.layout.navbar-default.search"/>" name="query" id="tequery" size="25"/>
        </div>
        <button type="submit" class="btn btn-primary"><span class="glyphicon glyphicon-search"></span></button>
--%>
<%--               <br/><a href="<%= request.getContextPath() %>/advanced-search"><fmt:message key="jsp.layout.navbar-default.advanced"/></a>
<%
			if (ConfigurationManager.getBooleanProperty("webui.controlledvocabulary.enable"))
			{
%>        
              <br/><a href="<%= request.getContextPath() %>/subject-search"><fmt:message key="jsp.layout.navbar-default.subjectsearch"/></a>
<%
            }
%> --%>
<%--
	</form>
--%>
      </div>

    </nav>
