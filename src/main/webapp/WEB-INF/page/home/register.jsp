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
		<h2>REGISTER</h2>
		<div class="form-group error text-center" style="color: red">
			<c:if test="${not empty param.active}">
				Active failed
			</c:if>
		</div>
			
		<form:form onsubmit="return validate();" action="register.html" method='post' class='form-validate' commandName="member" >
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
			<div class="form-group">
				<div class="controls">
					<form:input path="name" placeholder="Name" class='form-control' data-rule-required="true"/>
					<span class="error"><form:errors path="name"/></span>
				</div>
			</div>
			<div class="submit form-group">
				<input type="submit" value="Register" class='btn btn-primary'>
			</div>
			
		</form:form>
		<div class="forget">
			<a href="/login.html">
				<span>Login</span>
			</a>
		</div>
	</div>
</div>

<script>
    $(document).ready(function() {
			getSMTPSetting();	
    });
    
    function getSMTPSetting(){
        $.ajax({
            type: "GET",
            url: "/smtp/getSMTPJosnString.html",
            dataType: "json",
            success : function(response){
                console.log('get SMTPJosnString success');
                //console.log('host:'+response['host']);
                //console.log('auth:'+response['auth']);
                //console.log('port:'+response['port']);
                //console.log('user:'+response['user']);
                //console.log('pass:'+response['pass']);
                //console.log('protocol:'+response['protocol']);
                //console.log('starttls:'+response['starttls']);
                //console.log('debug:'+response['debug']);
            },
	 
            error : function(xhr, ajaxOptions, thrownError){
                console.log('get SMTPJosnString fail')
            }
        })
    }
</script>
<script type="text/javascript">
	function validate(){
		var email = String(document.getElementById("email").value);
		
		$.ajax({
			url: "/duplicate-account.html?email="+email,
			type: 'get',
			success: function(data) {
				if (data.status == "success") {
					return true;
	   			} else {
	   	   			alert("The email address has bean used !");
	   	   			return false;
	   	   		}
			},
			error: function(e) {
				toastr.error("error");
				console.log(e);
				return false;
			}
		});
	};
</script>
 