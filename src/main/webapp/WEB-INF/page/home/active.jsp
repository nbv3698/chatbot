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

<div class="wrapper">
	<h1>
		<a href="/">
			CHATBOT
		</a>
	</h1>
	<div class="login-body">
		<h2>ACTIVE</h2>
		<form action="active.html" method='post' class='form-validate'>
			<input type="hidden" name="email" value="${member.email }" />
			<div class="form-group">
				<div class="email controls">
					We sent a active code to your email (${member.email }). Please check email and enter in below form:
				</div>
			</div>
			
			<div class="form-group">
				<div class="controls">
					<input type="text" placeholder="Active code" name="activeCode" class="form-control" data-rule-required="true" />
				</div>
			</div>
			<div class="submit form-group">
				<input type="submit" value="Active" class='btn btn-primary'>
			</div>
		</form>
		<div class="forget">
			<a href="/login.html">
				<span>Login</span>
			</a>
		</div>
	</div>
</div>

