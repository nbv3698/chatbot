<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/includes/taglibs.jsp"%>

<title><fmt:message key="site.name" /></title>
<content tag="heading">Account Setting</content>
<script>
	var isSave = false;
    var changed = false;
	function checkChange(){
        //檢查是否修改
        $("input[type='text']").change(function() {		//偵測頁面上任一個文字輸入欄位有沒有被修改
            changed = true;
        });
        $("input[type='password']").change(function() {		//偵測頁面上任一個文字輸入欄位有沒有被修改
            changed = true;
        });
        $("select").change(function () {		//偵測頁面上任一個下拉式選單有沒有被修改
            changed = true;
        });
    }
    
    $(window).on("beforeunload", function() {
        if(changed && !isSave) return "尚有未儲存的修改。";
    });
	
	
	$(document).ready(function() {
        getAccountSetting();
        checkChange();
    });

	function getAccountSetting(){
		 $.ajax({
            type: "GET",
            url: "getAccountSetting.html",
            dataType: "json",
            success : function(response){
                console.log('get Account Setting success : ');
                showAccountSetting(response);
            },
	 
            error : function(xhr, ajaxOptions, thrownError){
                $("#settingDiv").append("<p>Fail to get Account Setting</p>");
                console.log('get Account Setting fail')
            }
        })
	}
	
	function showAccountSetting(response){
		//console.log('email:'+response['email']);
        //console.log('name:'+response['name']);
		$('#email').empty();
		$('#email').append(response['email']);
		
		$('#userName').val(response['name']);
	}
	
    function changeName(){
        isSave = true;
        //console.log($('#userName').val());
        
        if($('#userName').val().length == 0){
            alert('Please input user name.');
        }
        else if($('#userName').val().length > 100){
            alert('The length of user name should less than 100.');
        }
        else{
            
            $.ajax({
                type: "POST",
                url: "setUserName.html",
                dataType: "text",
                data: {
                    userName: $('#userName').val()
                },
                success : function(response){
                    console.log(response);
                    alert(response);
                    location.reload();
                },

                error : function(){
                    console.log('change password fail')
                }
            })
        }
    }
    
	function changePassword(){
        isSave = true;
        console.log($('#password').val());
        console.log($('#confirmPassword').val());
        
        if($('#password').val() != $('#confirmPassword').val()){
            alert('The password you input is inconsistent.');
        }
        else if($('#password').val().length == 0){
            alert('Please input password.');
        }
        else if($('#password').val().length > 255){
            alert('The length of password should less than 255.');
        }
        else{
            $.ajax({
                type: "POST",
                url: "setPassword.html",
                dataType: "text",
                data: {
                    password: $('#password').val()
                },
                success : function(response){
                    console.log(response);
                    alert(response);
                    location.reload();
                },

                error : function(){
                    console.log('change password fail')
                }
            })
        }
    }
</script>    
    

<div id="settingDiv">
<!--
<div class="form-group row">
	<div class="col-xs-4">
		<label>Email:</label>
		
		  <p id="email" class="form-control-static">someone@example.com</p>
		
	</div>
</div>
		<label>Name:</label>
		<input type="text" class="form-control" id="userName" value="">
        <button type="button" class="btn btn-primary" onclick="changeName()" style="float: left;" >Save</button>
        <div class="form-group row">
	<div class="col-xs-4">
		<label>Password:</label>
		<input type="password" class="form-control" id="password" value="">
	</div>
</div>
<div class="form-group row">
	<div class="col-xs-4">
		<label>Confirm Password:</label>
		<input type="password" class="form-control" id="confirmPassword" value="">
	</div>
</div>
    
    <div class="form-group row">
	<div class="col-xs-4">
		<button type="button" class="btn btn-defult" onclick="changePassword()" style="margin-right:1vw;">Change Password</button>
	</div>
    </div>
-->

	<div class="container col-xs-4">       
        <div class="panel-group">
            <div class="panel panel-primary">
                <div class="panel-heading">Personal Infomation</div>
                <div class="panel-body">
                    <label>Email:</label><br>		
                    <span id="email" class="form-control-static" style=""></span><br>
                    <div class="form-group">
                        <label style="margin-top: 1vh;">Name:</label>
                        <input type="text" class="form-control" id="userName" value="" style="">
                        <button type="button" class="btn btn-primary" onclick="changeName()" style="float: right; margin-top: 1vh;" >Save</button> 
                     </div>    
                </div>
            </div>

            <div class="panel panel-danger">
                <div class="panel-heading">Change Password</div>
                <div class="panel-body">
                    <label>New Password:</label>
                    <input type="password" class="form-control" id="password" value="">
                    <label style="margin-top: 1vh;">Input again:</label>
                    <input type="password" class="form-control" id="confirmPassword" value="">
                    <button type="button" class="btn btn-defult" onclick="changePassword()" style="float: right; margin-top: 1vh;">Save</button>
                </div>
            </div>     
        </div>
    </div>   
</div>