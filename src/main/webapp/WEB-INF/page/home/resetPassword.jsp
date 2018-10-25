<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/includes/taglibs.jsp" %>

<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no" />
<!-- Apple devices fullscreen -->
<meta name="apple-mobile-web-app-capable" content="yes" />
<!-- Apple devices fullscreen -->
<meta names="apple-mobile-web-app-status-bar-style" content="black-translucent" />

<title><fmt:message key="site.name"/></title>
<!-- jQuery -->
<script src="/resources/js/jquery/jquery.min.js" ></script>
<!-- Nice Scroll -->
<script src="/resources/plugin/jquery/jquery.nicescroll.min.js" ></script>
<!-- Validation -->
<script src="/resources/plugin/validation/jquery.validate.min.js" ></script>
<script src="/resources/plugin/validation/additional-methods.min.js" ></script>
<!-- icheck -->
<script src="/resources/plugin/jquery/jquery.icheck.min.js" ></script>
<!-- Bootstrap -->
<script src="/resources/js/bootstrap/bootstrap.min.js" ></script>
<script src="/resources/js/eakroko.js" ></script>



<!-- icheck -->
<link rel="stylesheet" href="/resources/css/all.css" >
<!-- Theme CSS -->
<link rel="stylesheet" href="/resources/css/style.css" >
<!-- Color CSS -->
<link rel="stylesheet" href="/resources/css/themes.css" >


<!-- Bootstrap -->
<link rel="stylesheet" href="/resources/js/bootstrap/bootstrap.min.css" >


<!--[if lte IE 9]>
	<script src="/resources/plugin/jquery/jquery.placeholder.min.js" ></script>
	<script>
		$(document).ready(function() {
			$('input, textarea').placeholder();
		});
	</script>
<![endif]-->


<!-- Favicon -->
<link rel="shortcut icon" href="favicon.ico" />
<!-- Apple devices Homescreen icon -->
<link rel="apple-touch-icon-precomposed" href="apple-touch-icon-precomposed.png" />

<style>
.login .wrapper .login-body .forget {
	margin-top: 10px;
}
</style>

<content tag="body.class">login</content>

<security:authorize access="isAuthenticated()">
	<c:redirect url="/security.jsp" />
</security:authorize>
<div class="wrapper">
	<h1>
		<a href="/">
			CHATBOT
		</a>
	</h1>
	<div class="login-body">
		<h2>Setting Password</h2>
		<div class="form-group error text-center" style="color: red">
			<c:if test="${not empty param.active}">
				Active failed
			</c:if>
		</div>
		<div>
			<div class="form-group">
				<div class="email controls">
					<input type='text' class='form-control' id='email' value=''>
					<span class="error"><form:errors path="email"/></span>
				</div>
			</div>
			<div class="form-group">
				<div class="pw controls">
					<input type='password' class='form-control' id='password' value=''>
					<span class="error"><form:errors path="password"/></span>
				</div>
			</div>

			<div class="submit form-group">
				<button type='button' class='btn btn-primary' onclick = 'setPassword()' style='margin-right:1vw;'>Save</button>
			</div>
		</div>
		<!---
		<form:form onsubmit="return validate();" action="setPassword.html" method='post' class='form-validate' commandName="member" >
			<div class="form-group">
				<div class="email controls">
					<form:input path="email" placeholder="Email" class='form-control' data-rule-required="true" data-rule-email="true" id="email" />
					<span class="error"><form:errors path="email"/></span>
				</div>
			</div>
			<div class="form-group">
				<div class="pw controls">
					<form:password path="password" placeholder="Password" class='form-control' data-rule-required="true"/>
					<span class="error"><form:errors path="password"/></span>
				</div>
			</div>

			<div class="submit form-group">
				<input type="submit" value="Save Password" class='btn btn-primary'>
			</div>
			
		</form:form>
		--->
	</div>
</div> 

<script>

function setPassword(){
        //alert($('#email').val());
		
        $.ajax({
            type: "POST",
            url: "setPassword.html",
               data: {
                   email: $('#email').val(),
                   password: $('#password').val(),
         
               },
               success : function(response){
                   console.log('setPassword success')
                    location.href = 'login.html'
               },	 
               error : function(xhr, ajaxOptions, thrownError){
                   console.log('setPassword fail')
               }
           })
    }	
			
    
	
</script> 
