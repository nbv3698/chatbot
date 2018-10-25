<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/includes/taglibs.jsp" %>

<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no" />
<!-- Apple devices fullscreen -->
<meta name="apple-mobile-web-app-capable" content="yes" />
<!-- Apple devices fullscreen -->
<meta names="apple-mobile-web-app-status-bar-style" content="black-translucent" />

<title><fmt:message key="site.name"/></title>

<!-- Bootstrap -->
<link rel="stylesheet" href="/resources/js/bootstrap/bootstrap.min.css" >
<!-- icheck -->
<link rel="stylesheet" href="/resources/css/all.css" >
<!-- Theme CSS -->
<link rel="stylesheet" href="/resources/css/style.css" >
<!-- Color CSS -->
<link rel="stylesheet" href="/resources/css/themes.css" >


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

<!--[if lte IE 9]>
	<script src="/resources/plugin/jquery/jquery.placeholder.min.js" ></script>
	<script>
		$(document).ready(function() {
			$('input, textarea').placeholder();
		});
	</script>
<![endif]-->
<script>
    /*
    function storeEmail(){
        //alert($('#j_username').val());
        localStorage.setItem("email", $('#j_username').val());
    }
    */
</script>
<style>
.gplus {

    background-color: #CC3E2F;
    margin-bottom: 15px;

}
.sign-in-button {

    width: 100%;
    line-height: 0;
    padding: 2px;
    border-radius: 6px;
    display: inline-block;

}
.sign-in-button .icon {
    display: inline-block;
    border-top-left-radius: 4px;
    border-bottom-left-radius: 4px;
    padding: 0 17px;
    height: 48px;
    line-height: 58px;
    position: relative;
    float: left;
    width: 66px;
}
.sign-in-button .icon .fa-facebook, .sign-in-button .icon .fa-google-plus {

    font-size: 25px;
    color: white;

}
.sign-in-button .sign-in-text {
    line-height: 50px;
    font-size: 18px;
    padding-left: 16px;
    color: #FFFFFF;
}
.sign-in-button .icon::after {
    display: inline-block;
    height: 36px;
    width: 0;
    content: '';
    border-right: 1px solid #fff;
    position: absolute;
    top: 8px;
    right: 10px;
}
.hr {
    position: relative;
    display: block;
    height: 0;
    width: 100%;
    margin: 14px 0;
    border-top: 1px #ccc solid;
    text-align: center;
    padding-bottom: 8px;
}
hr {
    display:none;
}
.hr > span {
    display: inline-block;
    position: relative;
    top: -0.70em;
    padding: 2px 10px;
    margin: 0 auto;
    background-color: white;
    line-height: 1em;
    text-align: center;
    font-size: 16px;
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
		<h2>SIGN IN</h2>
		
    
		<form action="j_spring_security_check.html" method='post' class='form-validate' id="test">
			
			<div class="sign-in-button gplus button form-group">
				<a id="gplus-signin" rel="nofollow" href="https://accounts.google.com/o/oauth2/auth?scope=email&redirect_uri=http://localhost:8080/login-google&response_type=code
				    &client_id=442524518434-oqa3ur3t2v3fm948sfjo3ah2i1ns9ki9.apps.googleusercontent.com&approval_prompt=force">
				    <div class="icon gplus-icon">
						<i class="fa fa-google-plus"></i>
					</div>
					<div class="sign-in-text">
						Sign in with Google
					</div>
				</a>
				
				
			</div>
			<div class="hr"><hr>
				<span>or</span>
			</div>
			<div class="form-group text-center" style="color: #4b4b4b">
				<c:if test="${not empty param.active}">
					The email is valid. Please sign in now. 
				</c:if>
			</div>
			
			<div class="form-group">
				<div class="email controls">
					<input type="text" id="j_username" name="j_username" placeholder="Email" class='form-control' data-rule-required="true">
				</div>
			</div>
			<div class="form-group">
				<div class="pw controls">
					<input type="password" id="j_password" name="j_password" placeholder="Password" class='form-control' data-rule-required="true">
				</div>
			</div>
			<div class="submit form-group">
				<div class="remember">
					<input type="checkbox" name="_spring_security_remember_me" class='icheck-me' data-skin="square" data-color="blue" id="remember">
					<label for="remember">Remember me</label>
				</div>
				<input type="submit" value="Sign me in" class='btn btn-primary' onclick="storeEmail()">
			</div>
			
			<div class="form-group error text-center" style="color: red">
				<c:if test="${not empty param.authfailed}">
					Username or password is incorrect
					<div style="display: none;">
						Error:
						<c:out value="${SPRING_SECURITY_LAST_EXCEPTION.message}" />
					</div>
				</c:if>
			</div>
		</form>
		<div class="forget">
			<a href="/register.html">
				<span>Register</span>
			</a>
		</div>
	</div>
</div>