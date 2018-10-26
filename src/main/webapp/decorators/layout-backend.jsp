<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/includes/taglibs.jsp"%>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en">

<head>
	<meta charset="utf-8">
	<meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no" />
	<!-- Apple devices fullscreen -->
	<meta name="apple-mobile-web-app-capable" content="yes" />
	<!-- Apple devices fullscreen -->
	<meta names="apple-mobile-web-app-status-bar-style" content="black-translucent" />

	<title><decorator:title /></title>

	<!-- Bootstrap -->
	<link rel="stylesheet" href="/resources/js/bootstrap/bootstrap.min.css" />
	<!-- jQuery UI -->
	<link rel="stylesheet" href="/resources/js/jquery-ui/jquery-ui.min.css" />
	<!-- Theme CSS -->
	<link rel="stylesheet" href="/resources/css/style.css" />
	<!-- Color CSS -->
	<link rel="stylesheet" href="/resources/css/themes.css" />
	
	<link rel="stylesheet" href="/resources/css/font-awesome.min.css" />
	
	<link rel="stylesheet" href="/resources/css/message.css" />
	<link rel="stylesheet" href="/resources/css/qlnt.css" />
	
	<link rel="stylesheet" href="/resources/js/toastr/toastr.min.css" />
	<link rel="stylesheet" href="/resources/js/nprogress/nprogress.css" />
	
	<!-- KendoUI CSS -->
	<link rel="stylesheet" href="/resources/js/kendoui/styles/kendo.common-material.min.css" />
	<link rel="stylesheet" href="/resources/js/kendoui/styles/kendo.material.min.css" />

	<!-- jQuery -->
	<script src="/resources/js/jquery/jquery.min.js" ></script>
	<!-- Nice Scroll -->
	<script src="/resources/plugin/jquery/jquery.nicescroll.min.js" ></script>
	<!-- jQuery UI -->
	<script src="/resources/js/jquery-ui/jquery-ui.js" ></script>
	<!-- slimScroll -->
	<script src="/resources/plugin/jquery/jquery.slimscroll.min.js" ></script>
	<!-- Bootstrap -->
	<script src="/resources/js/bootstrap/bootstrap.min.js" ></script>
	<!-- Form -->
	<script src="/resources/plugin/jquery/jquery.form.min.js" ></script>
	
	<link href="/resources/plugin/datepicker/datepicker.css" rel="stylesheet" />
	<script src="/resources/plugin/datepicker/bootstrap-datepicker.js"></script>

	<!-- Theme framework -->
	<script src="/resources/js/eakroko.min.js" ></script>
	<!-- Theme scripts -->
	<script src="/resources/js/application.min.js" ></script>
	<!-- Just for demonstration -->
	<!-- <script src="/resources/js/demonstration.min.js" ></script> -->
	
	<!-- Kendo UI -->
	<script src="/resources/js/kendoui/js/kendo.all.min.js"></script>
	
	<script src="/resources/js/toastr/toastr.min.js"></script>
	<script src="/resources/js/nprogress/nprogress.js"></script>
	
	<script src="/resources/plugin/select2/select2.min.js"></script>
	<link rel="stylesheet" href="/resources/plugin/select2/select2.css" />
	
	<!-- Validation -->
	<script src="/resources/plugin/validation/jquery.validate.min.js" ></script>
	<script src="/resources/plugin/validation/additional-methods.min.js" ></script>

	<!--[if lte IE 9]>
		<script src="/resources/plugin/jquery/jquery.placeholder.min.js"></script>
		<script>
			$(document).ready(function() {
				$('input, textarea').placeholder();
			});
		</script>
	<![endif]-->
	<script>
        /*
    var memberAmount;
    var memberIdArray = [];
    var memberNameArray = [];
    var memberPasswordArray = [];
    var memberActiveArray = [];
    var memberEmailArray = [];
    
    $(document).ready(function() {
        getMemberList();
    });
    function getMemberList(){
        $.ajax({
            type: "GET",
            url: "/member/getMemberList.html",
            dataType: "json",
            success : function(response){
                console.log('getMemberList success');
                //console.log(response);
                memberAmount = response.length;
                for(var i = 0 ; i < response.length; i++){                   
                    memberIdArray[i]=response[i]['userId'];
                    memberNameArray[i]=response[i]['name'];
                    memberPasswordArray[i]=response[i]['password'];
                    memberActiveArray[i]=response[i]['active'];
                    memberEmailArray[i]=response[i]['email'];
                    //console.log("Id: " + memberIdArray[i]);
                    //console.log("Name: " + memberNameArray[i]);
                    //console.log("Password: " + memberPasswordArray[i]);
                    //console.log("Active: " + memberActiveArray[i]);
                    //console.log("Email: " + memberEmailArray[i]);
                }
                getMemberActive();
                
            },
	 
            error : function(xhr, ajaxOptions, thrownError){
                console.log('getMemberList fail');
            }
        })
    }
        
    function getMemberActive(){
        var email = localStorage.getItem("email");
        for(var i = 0; i < memberAmount ; i++){
            if(email == memberEmailArray[i] ){
                //console.log("Name: " + memberNameArray[i]);
                //console.log("Email: " + memberEmailArray[i]);
                localStorage.setItem("active", memberActiveArray[i]);   
                break;
            }
        }
        
        if(localStorage.getItem("active")!=1){
            //alert("not active");
            window.location.href = 'logout.html';
        }
        
    }
    */
    </script>
</head>

<body >
	<div id="navigation">
		<div class="container">
			<a href="/security.jsp" id="brand">
				Chatbot
			</a>
			<ul class='main-nav'>
				<security:authorize ifAnyGranted="1">
					<li>
						<a href="/member/list.html" data-href="member" class='dropdown-toggle'>
							<span>Member list</span>
						</a>
					</li>
				</security:authorize>
				<li>
					<a href="/index.html" data-href="index" class='dropdown-toggle'>
						<span>Question</span>
					</a>
				</li>
                <security:authorize ifAnyGranted="1">
					<li>
						<a href="/smtp/SMTPSetting.html" data-href="smtp" class='dropdown-toggle'>
							<span>SMTP Setting</span>
						</a>
					</li>
				</security:authorize>
				<li>
					<a href="/account/accountSetting.html" data-href="account" class='dropdown-toggle'>
						<span>Account Setting</span>
					</a>
				</li>
				
	<!--				<li class="hidden">
					<a href="#" data-href="thiet-bi" data-toggle="dropdown" class='dropdown-toggle'> 
					<span><fmt:message key="menu.thietbi"/></span>
						<span class="caret"></span>
					</a>
					<ul class="dropdown-menu">
						<li><a href="/thiet-bi/chi-tiet-thiet-bi.html"><fmt:message key="menu.thietbi.qltb"/></a></li>
						<li><a href="/thiet-bi/tram.html"><fmt:message key="menu.thietbi.tram"/></a></li>
						
						<li class='dropdown-submenu'>
							<a href="#"><fmt:message key="menu.thietbi.truyendan"/></a>
							<ul class="dropdown-menu">
								<li><a href="/thiet-bi/truyen-dan/minilink.html"><fmt:message key="menu.thietbi.truyendan.miniLink"/></a></li>
								<li><a href="/thiet-bi/truyen-dan/pasolink.html"><fmt:message key="menu.thietbi.truyendan.pasolink"/></a></li>
								<li><a href="/thiet-bi/truyen-dan/thue.html"><fmt:message key="menu.thietbi.truyendan.thue"/></a></li>
							</ul>
						</li>
						<li><a href="/thiet-bi/du-phong.html"><fmt:message key="menu.thietbi.duphong"/></a></li>
					</ul>
				</li> -->
				
				<security:authorize ifAnyGranted="4">
					<li>
						<a href="#" data-href="admin" data-toggle="dropdown" class='dropdown-toggle'>
							<span>Report</span>
							<span class="caret"></span>
						</a>
						<ul class="dropdown-menu">
							<li><a href="/report/data.html">View data</a></li>
							<li><a href="/report/chart.html">Chart</a></li>
							<li><a href="/report/raw-data.html">Raw data</a></li>
						</ul>
					</li>
					
					<li>
						<a href="#" data-href="admin" data-toggle="dropdown" class='dropdown-toggle'>
							<span>Alarm</span>
							<span class="caret"></span>
						</a>
						<ul class="dropdown-menu">
							<li><a href="/config/sensor-threshold/list.html">Sensor threshold</a></li>
							<li><a href="/threshold/log.html">Threshold log</a></li>
						</ul>
					</li>
					
					<li>
						<a href="#" data-href="admin" data-toggle="dropdown" class='dropdown-toggle'>
							<span>Sensor</span>
							<span class="caret"></span>
						</a>
						<ul class="dropdown-menu">
							<li><a href="/sensor/layout.html">Layout</a></li>
						</ul>
					</li>
				</security:authorize>
			</ul>
			<security:authorize access="isAuthenticated()">
				<div class="user">
					<div class="dropdown">
						<a href="#" class='dropdown-toggle' data-toggle="dropdown">
							<security:authentication property="principal.username" />
							<img src="/resources/upload/image/user.png" alt="" height="40px" />
						</a>
						<ul class="dropdown-menu pull-right">
							<li class="hidden">
								<a href="/user/change-password.html">Change password</a>
							</li>
							<!--
							<li>
								<a href="accountSetting.html">Account Setting</a>
							</li>
							-->
							<li>
								<a href="logout.html">Logout</a>
							</li>
                           
						</ul>
					</div>
				</div>
			</security:authorize>
		</div>
	</div>
	
	<div class="container nav-hidden" id="content">
	
		<div id="page-header">
			<h5 style="font-weight: bold; line-height: 22px; margin: 15px 20px; color: #444;">
			</h5>
		</div>
		
		<div id="main" style="margin-left: 0px;">
			<div class="container-fluid">
				<h3 class="page-title"><decorator:getProperty property="page.heading" /></h3>
				
				<div class="row">
					<div class="col-sm-12">
						<%@ include file="/includes/messages.jsp"%>
						<div class="separator-x"></div>
						<decorator:body />
					</div>
				</div>
			</div>
		</div>
	</div>
	
	<div id="footer" class="text-center" style="padding-top: 15px">
		<p>
			Chatbot
		</p>
		<a class="gototop" href="#">
			<i class="fa fa-arrow-up"></i>
		</a>
	</div>
	
	<script>
		$(".main-nav>li").each(function() {
			var href = $(this).find('a').first().attr('data-href');
			if (window.location.pathname.indexOf('/' + href) == 0) {
				$(this).addClass('active');
			}
		});
	</script>
</body>

</html>
