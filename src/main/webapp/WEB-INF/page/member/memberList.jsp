<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/includes/taglibs.jsp"%>
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
                console.log('host:'+response['host']);
                console.log('auth:'+response['auth']);
                console.log('port:'+response['port']);
                console.log('user:'+response['user']);
                console.log('pass:'+response['pass']);
                console.log('protocol:'+response['protocol']);
                console.log('starttls:'+response['starttls']);
                console.log('debug:'+response['debug']);
            },
	 
            error : function(xhr, ajaxOptions, thrownError){
                console.log('get SMTPJosnString fail')
            }
        })
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
			<input type="text" class="form-control" name="name" value="${name}">
		</div>
		<label class="col-md-2 control-label">
			Email
		</label>
		<div class="col-md-3">
			<input type="text" class="form-control" name="email" value="${email}">
		</div>
		
		<div class="col-md-2">
			<input type="submit" class="btn btn-primary" value="Search">
		</div>
	</div>
</form>

<div class="box box-color">
	<div class="box-content nopadding">
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