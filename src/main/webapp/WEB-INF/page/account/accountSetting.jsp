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
        $("input[type='email']").change(function() {		//偵測頁面上任一個文字輸入欄位有沒有被修改
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
    });

	function getAccountSetting(){
		 $.ajax({
            type: "GET",
            url: "getAccountSetting.html",
            dataType: "json",
            success : function(response){
                console.log('get Account Setting success : ');
                //console.log('host:'+response['host']);
                //console.log('auth:'+response['auth']);
                //$('#host').val(response['host']);
                //$('#auth').val(response['auth']);
                showAccountSetting(response);
            },
	 
            error : function(xhr, ajaxOptions, thrownError){
                $("#settingDiv").append("<p>Fail to get Account Setting</p>");
                console.log('get Account Setting fail')
            }
        })
	}
	
	
	function showAccountSetting(response){
		console.log('email:'+response['email']);
        console.log('name:'+response['name']);
		$('#email').empty();
		$('#email').append(response['email']);
		
		$('#userName').val(response['name']);
	}
	
	
</script>    
    

<div id="settingDiv">
<div class="form-group row">
	<div class="col-xs-4">
		<label>Email:</label>
		
		  <p id="email" class="form-control-static">someone@example.com</p>
		
	</div>
</div>
<div class="form-group row">
	<div class="col-xs-4">
		<label>Name:</label>
		<input type="text" class="form-control" id="userName" value="">
	</div>
</div>
<div class="form-group row">
	<div class="col-xs-4">
		<button type="button" class="btn btn-defult" onclick="changePassword()" style="margin-right:1vw;">Change Password</button>
	</div>
</div>

<div class="form-group row">
	<div class="col-xs-4">
		<label>Password:</label>
		<input type="text" class="form-control" id="password" value="">
	</div>
</div>
<div class="form-group row">
	<div class="col-xs-4">
		<label>Confirm Password:</label>
		<input type="text" class="form-control" id="confirmPassword" value="">
	</div>
</div>
<button type="button" class="btn btn-primary" onclick="editSMTP()" style="margin-right:1vw;">Save</button>
</div>
          


