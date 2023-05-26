<%--

    The contents of this file are subject to the license and copyright
    detailed in the LICENSE and NOTICE files at the root of the source
    tree and available online at

    http://www.dspace.org/license/

--%>
<%--
  - Component which displays a login form and associated information
  --%>
  
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt"
    prefix="fmt" %>

<div class="panel-body">
    <p>
	<%--<fmt:message key="jsp.components.ldap-form.downtime"/>--%>
      <fmt:message key="jsp.components.ldap-form.enter"/>
    </p>
	<%--
  <form name="loginform" class="form-horizontal" id="loginform" method="post" action="<%= request.getContextPath() %>/ldap-login">  
     
    <div class="form-group">
      <label class="col-md-offset-3 col-md-2 control-label" for="tlogin_email"><fmt:message key="jsp.components.ldap-form.username-or-email"/></label>
      <div class="col-md-3">
	<input class="form-control" type="text" name="login_netid" id="tlogin_email" tabindex="1" />
      </div>
    </div>
    <div class="form-group">
      <label class="col-md-offset-3 col-md-2 control-label" for="tlogin_password"><fmt:message key="jsp.components.ldap-form.password"/></label>
      <div class="col-md-3">
	<input class="form-control" type="password" name="login_password" id="tlogin_password" tabindex="2" />
      </div>
    </div>
    <div class="row">
      <div class="col-md-6">
	<input type="submit" class="btn btn-success pull-right" name="login_submit" value="<fmt:message key="jsp.components.ldap-form.login.button"/>" tabindex="3" />
      </div>
    </div>
    
  </form>
  <script type="text/javascript">
    document.loginform.login_netid.focus();
  </script>
  --%>
</div>
