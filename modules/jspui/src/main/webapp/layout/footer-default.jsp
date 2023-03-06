<%--

    The contents of this file are subject to the license and copyright
    detailed in the LICENSE and NOTICE files at the root of the source
    tree and available online at

    http://www.dspace.org/license/

--%>
<%--
  - Footer for home page
  --%>

<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<%@ page contentType="text/html;charset=UTF-8" %>

<%@ page import="java.net.URLEncoder" %>
<%@ page import="org.dspace.app.webui.util.UIUtil" %>

<%
    String sidebar = (String) request.getAttribute("dspace.layout.sidebar");
%>

            <%-- Right-hand side bar if appropriate --%>
<%
    if (sidebar != null)
    {
%>
	</div>
	<div class="col-md-3">
                    <%= sidebar %>
    </div>
    </div>       
<%
    }
%>
</div>
</main>
            <%-- Page footer --%>
	    <footer class="navbar navbar-inverse navbar-bottom">
	      <div class="footer-wrap">
	      <div id="designedby" class="container text-muted">
		
		<div class="col col-sm-8">
			<a href="https://uit.no" target="_blank" title="UiT">
			    <img class="logo-bottom" src="<%= request.getContextPath() %>/image/<fmt:message key="ub.jsp.logo-file"/>" alt="UiT logo" title="UiT logo" />
			</a>
		</div>
		
		<div id="footer_feedback" class="col col-sm-4"> 
			<div class="pull-right">
				<p><fmt:message key="ub.jsp.layout.footer-default.about"/></p>
				<p><fmt:message key="ub.jsp.layout.footer-default.contact"/></p>
				<p><fmt:message key="ub.jsp.layout.footer-default.accessibility"/></p>
				<a href="<%= request.getContextPath() %>/htmlmap" aria-label="htmlmap"></a>
			</div>
		</div>
		
	      </div>
	      </div>
	    </footer>
    </body>
</html>
