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
<script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js"></script>
<script src="/resources/js/eakroko.js" ></script>

<script src='https://unpkg.com/nprogress@0.2.0/nprogress.js'></script>
<link rel='stylesheet' href='https://unpkg.com/nprogress@0.2.0/nprogress.css'/>

<!-- icheck -->
<link rel="stylesheet" href="/resources/css/all.css" >
<!-- Theme CSS -->
<link rel="stylesheet" href="/resources/css/style.css" >
<!-- Color CSS -->
<link rel="stylesheet" href="/resources/css/themes.css" >


<!-- Bootstrap -->
<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css">

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
		<h2>Forgotten Your Password?</h2>
		<div class="form-group error text-center" style="color: red">
			<c:if test="${not empty param.active}">
				Active failed
			</c:if>
		</div>
		<form id="formDiv" class="form-validate" action="#">
			<div class="form-group">
				<div class="email controls">
					<input type="email" class='form-control' id='email' value='' placeholder="Enter email">
				</div>
			</div>
			
            <div id="messageDiv" class="form-group error text-center" style="color:red; height:1vh">
				
			</div>
			
            
            
            
            <div id="buttonDiv" class="submit form-group">
                
				<button id="ConfirmBtn" type='button' class='btn btn-primary' onclick='sendPassword()' style="float:right;">Confirm</button>
			</div>
		</form>
        <div class="forget">
			<a href="/login.html">
				<span>Login</span>
			</a>
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
    
    $(document).ready(function() {
        var url = decodeURI(window.location.href);
        //console.log("url.split('?')[1] = " + url.split("?")[1]);
        if( url.split("?")[1] != undefined){
            var state = url.split("?")[1].split("=")[1];
            console.log("state = " + state);
            $("#formDiv").empty();
            $("#formDiv").append("We sent a new password to your email.<br>Please check email.");
        }
        else{
            getSMTPSetting();	
        }
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
    
    function sendPassword(){      
        if($('#email').val() == ""){
            $("#messageDiv").empty();
            $("#messageDiv").append("Please input E-mail.");	
        }
        else{
            $("#ConfirmBtn").empty();
            $("#ConfirmBtn").append("Sending...");
            document.getElementById("ConfirmBtn").disabled = true; 
            
            $.ajax({
                type: "POST",
                url: "sendConfirmResetPasswordMail.html",
                data: {
                    email: $('#email').val()         
                },
                success : function(response){
                    console.log(response);
                    $("#messageDiv").empty();
                   
                    if(response == "E-mail not existing."){
                        $("#messageDiv").append(response);
                        $("#ConfirmBtn").empty();
                        $("#ConfirmBtn").append("Confirm");
                        document.getElementById("ConfirmBtn").disabled = false; 
                    }
                    else{
                        console.log('E-mail existing.');
                        $("#formDiv").empty();
                        $("#formDiv").append("We sent a mail to check your identity.<br>Please check email.");
                        //location.href = 'login.html';
                    }
                },	 
                error : function(xhr, ajaxOptions, thrownError){
                    $("#messageDiv").empty();
                    $("#messageDiv").append(response);
                }
            }) 
        }
        
    }	
</script> 
