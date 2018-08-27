<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/includes/taglibs.jsp"%>

<title><fmt:message key="site.name" /></title>
<content tag="heading">SMTP Setting</content>
<script>
    var isSave = false;
    var changed = false;
    
    $(document).ready(function() {
        getSMTPSetting();
    });
 
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
    
    function restoreDefault(){
        var r = confirm("Restore default?");
        if (r == true) {
            $("#host").val("smtp.gmail.com");
            $("#port").val("465");
            $("#auth").val("true");
            $("#user").val("chatbot.api.active@gmail.com");
            $("#pass").val("conga@123");
            $("#protocol").val("smtps");
            $("#starttls").val("true");
            $("#debug").val("true");
        } 
        else {
           //do nothing
        }
        
        
    }
    
    function getSMTPSetting(){
        $.ajax({
            type: "GET",
            url: "getSMTPJosnString.html",
            dataType: "json",
            success : function(response){
                console.log('get SMTP Setting success : ');
                //console.log('host:'+response['host']);
                //console.log('auth:'+response['auth']);
                //$('#host').val(response['host']);
                //$('#auth').val(response['auth']);
                showSetting(response);
            },
	 
            error : function(xhr, ajaxOptions, thrownError){
                $("#settingDiv").append("<p>Fail to get SMTP Setting</p>");
                console.log('get SMTP Setting fail')
            }
        })
    }
    
    function showSetting(response){
        var item = "";
        
        item = 
            "<div class='form-group row'>"+
                "<div class='col-xs-4'>"+
                    "<label>mail.smtp.host:</label>"+
                    "<input type='text' class='form-control' id='host' value='"+response['host']+"'>"+
                "</div>"+
            "</div>";
        
        item +=
            "<div class='form-group row'>"+
                "<div class='col-xs-4'>"+
                    "<label>mail.smtp.auth:</label>"+
                    "<select class='form-control' id='auth'>";
        if(response['auth'] == 'true'){
            item +=
                    "<option selected>true</option>"+
                    "<option>false</option>";
        }
        else{
            item +=
                    "<option>true</option>"+
                    "<option selected>false</option>";
        }
        item +=
                    "</select>"+
                "</div>"+
            "</div>";
        
        
        item +=
        "<div class='form-group row'>"+
            "<div class='col-xs-4'>"+
                "<label>mail.smtp.port:</label>"+
                "<input type='text' class='form-control' id='port' value='"+response['port']+"'>"+
            "</div>"+
        "</div>"+
            
        "<div class='form-group row'>"+
            "<div class='col-xs-4'>"+
                "<label>mail.smtp.user:</label>"+
                "<input type='email' class='form-control' id='user' value='"+response['user']+"'>"+
            "</div>"+
        "</div>"+
            
        "<div class='form-group row'>"+
            "<div class='col-xs-4'>"+
                "<label>mail.smtp.pass:</label>"+
                "<input type='text' class='form-control' id='pass' value='"+response['pass']+"'>"+
            "</div>"+
        "</div>"+
            
       "<div class='form-group row'>"+
            "<div class='col-xs-4'>"+
                "<label>mail.transport.protocol:</label>"+
                "<input type='text' class='form-control' id='protocol' value='"+response['protocol']+"'>"+
            "</div>"+
        "</div>";
        
        item +=
            "<div class='form-group row'>"+
                "<div class='col-xs-4'>"+
                "<label>mail.starttls.enable:</label>"+
                "<select class='form-control' id='starttls'>";
        if(response['starttls'] == 'true'){
            item +=
                    "<option selected>true</option>"+
                    "<option>false</option>";
        }
        else{
            item +=
                    "<option>true</option>"+
                    "<option selected>false</option>";
        }
        item +=
                    "</select>"+
                "</div>"+
            "</div>";
        item +=
            "<div class='form-group row'>"+
                "<div class='col-xs-4'>"+
                "<label>mail.smtp.debug:</label>"+
                "<select class='form-control' id='debug'>";
        if(response['debug'] == 'true'){
            item +=
                    "<option selected>true</option>"+
                    "<option>false</option>";
        }
        else{
            item +=
                    "<option>true</option>"+
                    "<option selected>false</option>";
        }
        item +=
                    "</select>"+
                "</div>"+
            "</div>";
        
        item +=
        "<button type='button' class='btn btn-primary' onclick = 'editSMTP()' style='margin-right:1vw;'>Save</button>"+
        "<button type='button' class='btn btn-default' onclick = 'restoreDefault()'>Restore Default</button>";
        
        $("#settingDiv").append(item);	
       
        checkChange();
    }
    
    function editSMTP(){
        isSave = true;
        //檢查輸入
        if($('#host').val().length == 0){
            alert('Please input mail.smtp.host value');
        }
        /*
        else if($('#auth').val().length == 0){
            alert('Please select mail.smtp.auth value');
        }
        */
        else if($('#port').val().length == 0){
            alert('Please input mail.smtp.port value');
        }
        else if($('#user').val().length == 0){
            alert('Please input mail.smtp.user value');
        }
        else if($('#pass').val().length == 0){
            alert('Please input mail.smtp.pass value');
        }
        else if($('#protocol').val().length == 0){
            alert('Please input mail.transport.protocol: value');
        }
        /*
        else if($('#enable').val().length == 0){
            alert('Please select mail.starttls.enable value');
        }
        else if($('#debug').val().length == 0){
            alert('Please select mail.smtp.debug value');
        }
        */
        else{
           $.ajax({
               type: "POST",
               url: "editSMTP.html",
               data: {
                   host: $('#host').val(),
                   auth: $('#auth').val(),
                   port: $('#port').val(),
                   user: $('#user').val(),
                   pass: $('#pass').val(),
                   protocol: $('#protocol').val(),
                   starttls: $('#starttls').val(),
                   debug: $('#debug').val()
               },
               success : function(response){
                   console.log('edit success')
                   location.reload();
               },	 
               error : function(xhr, ajaxOptions, thrownError){
                   console.log('edit fail')
               }
           })
        }			
    }

</script>    
    
<div id="settingDiv"></div>            


