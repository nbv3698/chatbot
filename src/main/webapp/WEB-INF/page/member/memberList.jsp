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
            alert();
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
                                    "<th class=''>Fullname</th>"+
                                    "<th class=''>Email</th>"+
                                    "<th>Management</th>"+
                                "</tr>"+
                            "</thead>"+
                            "<tbody>"+
                                "<tr class='odd'>"+
                                    "<td class='stt'>" + memberIdArray[i] + "</td>"+
                                    "<td>" + memberNameArray[i] + "</td>"+
                                    "<td></td>"+
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
</script>
<title><fmt:message key="site.name" /></title>
<content tag="heading">Member</content>

<form id="user" action="list.html" method="POST" class="form-horizontal" role="form" >
	<div class="form-group">
		<label class="col-md-2 control-label">
			Name
		</label>
		<div class="col-md-3">
			<input id="inputName" type="text" class="form-control" name="name">
		</div>
		<label class="col-md-2 control-label">
			Email
		</label>
		<div class="col-md-3">
			<input id="inputEmail" type="text" class="form-control" name="email">
		</div>
		
		<div class="col-md-2">
			<input class="btn btn-primary" value="Search" onclick='searchMember()'>
		</div>
	</div>
</form>

<div class="box box-color">
	<div id="tableDiv" class="box-content nopadding">
		<display:table name="${memberList}" class="table table-hover" export="true" id="user" requestURI="" pagesize="15" defaultsort="2">
		    <display:column title="#" class="stt" > <c:out value="${user_rowNum}"/> </display:column>
		    <display:column title="Name" property="name" />
		    <display:column title="Fullname" property="fullname" sortable="true" sortName="ROLE" />
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
		    <display:setProperty name="export.csv.filename" value="${exportFileName}.csv"/>
		    <display:setProperty name="export.excel.filename" value="${exportFileName}.xls"/>
		    <display:setProperty name="export.xml.filename" value="${exportFileName}.xml"/>
		</display:table>
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