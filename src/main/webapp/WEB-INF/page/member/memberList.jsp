<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/includes/taglibs.jsp"%>
<script>
    var memberAmount;
    var memberIdArray = [];
    var memberNameArray = [];
    var memberPasswordArray = [];
    var memberActiveArray = [];
    var memberEmailArray = [];
    
    $(document).ready(function() {
        getSMTPSetting();
        getMemberList();
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
                
            },
	 
            error : function(xhr, ajaxOptions, thrownError){
                console.log('getMemberList fail');
            }
        })
    }
    
    function searchMember(){
        //check input
        if($('#inputEmail').val().length==0||$('#inputName').val().length==0){
            alert("Please input E-mail and name.");
        }
        else{
            //clear table
            $('#tableDiv').empty();
            var table="";
            $('#tableDiv').append("No result.");
            //console.log($('#inputEmail').val());
            for(var i = 0; i < memberAmount ; i++){
                if($('#inputEmail').val() == memberEmailArray[i] && $('#inputName').val() == memberNameArray[i]){
                    //console.log("Name: " + memberNameArray[i]);
                    //console.log("Email: " + memberEmailArray[i]);
                    $('#tableDiv').empty();
                    table="<table class='table table-hover' id='user'>"+
                            "<thead>"+
                                "<tr>"+
                                    "<th>#</th>"+
                                    "<th class='sorted order1'>Name</th>"+
                                    //"<th class=''>Fullname</th>"+
                                    "<th class=''>Email</th>"+
                                    "<th>Management</th>"+
                                "</tr>"+
                            "</thead>"+
                            "<tbody>"+
                                "<tr class='odd'>"+
                                    "<td class='stt'>" + memberIdArray[i] + "</td>"+
                                    "<td>" + memberNameArray[i] + "</td>"+
                                    //"<td></td>"+
                                    "<td>" + memberEmailArray[i] + "</td>";

                    if(memberActiveArray[i]==1){   //已驗證
                        table+= "<td>Active</td>";
                    }
                    else{
                        table+= "<td><a href='#' onclick='javascript:send_active_code("+memberIdArray[i]+");return false;'>Send active code</a></td>";
                    }

                    table+="</tr>"+
                            "</tbody>"+
                        "</table>";

                    $('#tableDiv').append(table);
                    break;
                }
            }
        }   
    }
    
    //convert table to excel
    function tableToExcel(table, name, filename) {
        var uri = 'data:application/vnd.ms-excel;base64,';
        //定義格式及編碼方式

        var template = '<html xmlns:o="urn:schemas-microsoft-com:office:office"'
                   + '      xmlns:x="urn:schemas-microsoft-com:office:excel"'
                   + '      xmlns="http://www.w3.org/TR/REC-html40">'
                   + '<head>'
                   + '<!--[if gte mso 9]>'
                   + '<xml>'
                   + '  <x:ExcelWorkbook>'
                   + '    <x:ExcelWorksheets>'
                   + '      <x:ExcelWorksheet>'
                   + '        <x:Name>{worksheet}</x:Name>'
                   + '        <x:WorksheetOptions>'
                   + '          <x:DisplayGridlines/>'
                   + '        </x:WorksheetOptions>'
                   + '      </x:ExcelWorksheet>'
                   + '    </x:ExcelWorksheets>'
                   + '  </x:ExcelWorkbook>'
                   + '</xml>'
                   + '<![endif]-->'
                   + '</head>'
                   + '<body>'
                   + '  <table>{table}</table>'
                   + '</body>'
                       + '</html>';
          //Excel的基本框架

          if (!table.nodeType)
            table = document.getElementById(table)

          var ctx = { worksheet: name || 'Worksheet', table: table.innerHTML }

          document.getElementById("dlink").href = uri + base64(format(template, ctx));
          //將超連結指向Excel內容
          document.getElementById("dlink").download = filename;
          //定義超連結下載的檔名
          document.getElementById("dlink").click();
          //執行點擊超連結的動作來下載檔案
    }
    
    //將文字編譯成Base64格式
    function base64(s) {
      return window.btoa(unescape(encodeURIComponent(s)))
    }
    
    //將文字裡的{worksheet}和{table}替換成相對應文字
    function format(s, c) {
      return s.replace(/{(\w+)}/g, function (m, p) { return c[p]; })
    }
    
</script>
<title><fmt:message key="site.name" /></title>
<content tag="heading">Member</content>

<form id="" action="list.html" method="POST" class="form-horizontal" role="form" >
	<div class="form-group">
		<label class="col-md-1 control-label">
			Name
		</label>
		<div class="col-md-4">
			<input id="inputName" type="text" class="form-control" name="name">
		</div>
		<label class="col-md-1 control-label">
			Email
		</label>
		<div class="col-md-4">
			<input id="inputEmail" type="text" class="form-control" name="email">
		</div>	
		<div class="col-md-2">
            <button type="button" class="btn btn-primary" onclick="searchMember()" style="margin-left:1vw;margin-right:1vw;">Search</button>
		</div>
	</div>
</form>

<div class="box box-color">
	<div id="tableDiv" class="box-content nopadding">
		<display:table name="${memberList}" class="table table-hover" id="user" requestURI="" pagesize="15" defaultsort="2">
		    <display:column title="#" class="stt" > <c:out value="${user_rowNum}"/> </display:column>
		    <display:column title="Name" property="name" sortable="true"/>
		    <display:column title="Email" property="email" sortable="true" sortName="LOCKED" />
		    <display:column title="Management" media="html" >
		    	<c:choose>
		    		<c:when test="${user.active==1 }">
		    			Active
		    		</c:when>
		    		<c:otherwise>
		    			<a href="#" onclick="javascript:send_active_code('${user.userId}');return false;">Send active code</a>
		    		</c:otherwise>
		    	</c:choose>
		    </display:column>
            <!--
            <display:setProperty name="export.csv.filename" value="${exportFileName}.csv"/>
		    <display:setProperty name="export.excel.filename" value="${exportFileName}.xls"/>
		    <display:setProperty name="export.xml.filename" value="${exportFileName}.xml"/>
            -->	    
		</display:table>
        <a id="dlink" style="display:none;"></a>
        <br>
        Export:
        <a onclick="tableToExcel('user', 'user', 'user.xls')">Excel</a>
        <!--
        <button type="button" class="btn btn-primary" onclick="tableToExcel('user', 'user', 'user.xls')" style="">Export Excel file</button>
        --> 
	</div>
   
</div>


<script>
    
	function send_active_code(id) {
		
		// var smtpPort = prompt("Please enter SMTP port:");
		
		$.ajax({
			url: "/member/send-active-code.html?userId="+id,
			// url: "/member/send-active-code.html?userId="+id+"&smtpPort="+smtpPort,
			type: 'post',
			processData: false,
			contentType: false,
			beforeSend: function(xhr) {
				//_this.attr("disabled", "disabled");
				NProgress.start();
			},
			complete: function() {
				NProgress.done();
				//_this.prop("disabled", false);
			},
			success: function(data) {
				if (data.status == 'success') {
					$("#user").submit();
	   			} else {
	   	   			alert(data.status);
	   	   		}
                location.reload();
			},
			error: function(e) {
				toastr.error("error");
				console.log(e);
			}
		});
		
		/* $.getJSON("/member/send-active-code.html", {userId: id}, function(data){
   			if (data.status == 'success') {
				$("#user").submit();
   			} else {
   	   			alert(data.cause);
   	   		}
		}); */
    }
</script>