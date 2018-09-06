<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/includes/taglibs.jsp"%>

<title><fmt:message key="site.name" /></title>
<content tag="heading">Chatbot</content>

<style>
.search-results ul li {
	position: relative;
}

.search-results ul li .action {
	position: absolute;
	top: 12px;
	right: 0px;
}

</style>


<div class="row form-group">
	
	<div class="col-sm-5 box box-bordered">
	<div >
		<li class="right hidden">
					<div class="image">
						<img src="/resources/image/icon/user.png" alt="">
					</div>
					<div class="message">
						<span class="caret"></span>
						<span class="name">Client Input</span>
					</div>
		</li>
		</div>
		<div class="form-group" >
			<textarea placeholder="User Input" class="form-control" name="question" id="question" style="height: 120px"></textarea>
			
			<div class="pull-right" style="padding: 11px 0px">
				<button id="ask" class="btn" type="button">Send</button>
			</div>
			<div class="input-group-btn pull-right">
				
			</div>
		</div>
		<div class="row"></div>
		<div class="form-group" >
			<div class="box-content" style="border: 1px solid #ddd; height: 580px; overflow: auto;">
				<div class="search-results">
					<p>Suggested answers</p>
					<ul id="answers"></ul>
				</div>
			</div>
		</div>
	</div>
	
	<div class="col-sm-7 box box-bordered">
		<div class="box-content" style="border: 1px solid #ddd; height: 500px">
			<ul class="messages" id="messages">
				<li class="left hidden">
					<div class="image">
						<img src="/resources/image/icon/user.png" alt="">
					</div>
					<div class="message">
						<span class="caret"></span>
						<span class="name">User</span>
						<p>Lorem ipsum aute ut ullamco et nisi ad. Lorem ipsum adipisicing nisi Excepteur eiusmod ex culpa laboris. Lorem ipsum est ut...</p>
						<span class="time hidden">
							12 minutes ago
						</span>
					</div>
				</li>
				
				<li class="right hidden">
					<div class="image">
						<img src="/resources/image/icon.svg" alt="">
					</div>
					<div class="message">
						<span class="caret"></span>
						<span class="name">Chatbot</span>
						<p>Hi</p>
						<span class="time hidden">
							12 minutes ago
						</span>
					</div>
				</li>
			</ul>
			
		</div>
		
		<div class="box-content" style="border: 1px solid #ddd">
			<div class="form-group">
				<input type="hidden" id="modify-id" />
				<input type="hidden" id="modify-org-question" />
				<input type="hidden" id="modify-org-answer" />
				<textarea id="modify-answer" class="form-control" style="height: 120px"></textarea>
			</div>
			
			<div class="form-group pull-right">
				<button id="modify-button" type="submit" class="btn btn-primary">Send</button>
			</div>
		</div>
		
		<div class="box-content" style="border: 1px solid #ddd; ">
			<span id="new-session" style="color: red; float: right; cursor: pointer">New session</span>
		</div>
	</div>
</div>


<script>

var answers;
//記錄使用者輸入的問題
var userQuestion;
var answerIDArray = [];
//初始化所有answerID
function initailAnswerArray(result){
				
	for (var i = 0; i < result.length; i++) {
		//console.log(result[i].id);
		//console.log(result[i].question);
		//console.log(result[i].answer);
		answerIDArray.push(result[i].id.toString());
	}
	console.log("initail answerIDArray:");
	for(i=0;i<answerIDArray.length;i++){		
		console.log("answerIDArray["+i+"] = "+answerIDArray[i]+" type:"+typeof(answerIDArray[i]));
	}
}

//刪除特定answerID
function removeAnswerID(answerID){
	//answerID = parseInt(answerID);
	//console.log(typeof(answerID));
	console.log("answerID:"+answerID+" type:"+typeof(answerID));
	console.log("Before remove:");
	console.log(answerIDArray);
	var index = answerIDArray.indexOf(answerID)
	console.log("index:"+index);
	if (index > -1) {
		answerIDArray.splice(index, 1);
	}
	console.log("After remove:");
	console.log(answerIDArray);
}

//None of the above
function removeAllAnswer(){
	console.log("remove All Answer:");
	console.log(answerIDArray);
	for(i=0;i<answerIDArray.length;i++){		
		//console.log("answerIDArray["+i+"] = "+answerIDArray[i]+" type:"+typeof(answerIDArray[i]));
		$.ajax({
		url: "/chat/remove.html",
		data: {id:answerIDArray[i]},
		method: "post",
		beforeSend: function(xhr) {
			//_this.attr("disabled", "disabled");
		},
		complete: function() {
			//_this.prop("disabled", false);
		},
		success: function(result) {

		},
		error: function(e) {
				//alert("Error in processing");
			console.log(e);
		}
	});
		
	}
	/*
	$.ajax({
		url: "/chat/remove.html",
		data: {id: _this.closest('li').attr("id")},
		method: "post",
		beforeSend: function(xhr) {
			//_this.attr("disabled", "disabled");
		},
		complete: function() {
			//_this.prop("disabled", false);
		},
		success: function(result) {
			removeAnswerID(removeID);

			_this.closest('li').remove();
		},
		error: function(e) {
				//alert("Error in processing");
			console.log(e);
		}
	});
	
	*/
	
}

$(document).ready(function() {
	
	$("#new-session").click(function(e) {
		$("#question").val("");
		$("#answers").html("");
		$("#modify-id").val("");
		$("#modify-answer").val("");
		
		var first = $("#messages li").first().clone();
		$("#messages").html(first);
	});
	
	$("#ask").click(function(e) {
		
		e.preventDefault();
		
		var _this = $(this);
		
		if ($('#question').val() == '') {
			alert("Enter content, please!");
			return;
		}
		
		userQuestion = $('#question').val();
		//右邊的對話紀錄
		var html='';
		html += '<li class="left">';
		html += '	<div class="image">';
		html += '		<img src="/resources/image/icon/user.png" alt="">';
		html += '	</div>';
		html += '	<div class="message">';
		html += '		<span class="caret"></span>';
		html += '		<span class="name">User</span>';
		html += '		<p>' + userQuestion + '</p>';
		html += '	</div>';
		html += '</li>';
		
		$("#messages").append(html);
		
		$.ajax({
			url: "/chat/ask.html",
			data: {question: userQuestion},
			method: "post",
			beforeSend: function(xhr) {
				_this.attr("disabled", "disabled");
			},
			complete: function() {
				_this.prop("disabled", false);
			},
			success: function(result) {
				$('#question').val("");
				if (result.length == 0) {
					//alert("No answer");
					return;
				}
				
				initailAnswerArray(result);			
				render(result);
				answers = result;
			},
			error: function(e) {
				//alert("Error in processing");
				$('#modify-answer').val = 'No Answer';
				console.log(e);
			}
		});
	});
	
	$("#modify-button").click(function(e) {
		
		e.preventDefault();
		
		var _this = $(this);
		
		if ($('#modify-answer').val() == '') {
			alert("Enter content, please!");
			return;
		}
		
		var html='';
		html += '<li class="right">';
		html += '	<div class="image">';
		html += '		<img src="/resources/image/icon.svg" alt="">';
		html += '	</div>';
		html += '	<div class="message">';
		html += '		<span class="caret"></span>';
		html += '		<span class="name"> Chatbot</span>';
		html += '		<p>' + $('#modify-answer').val() + '</p>';
		html += '	</div>';
		html += '</li>';
		
		$("#messages").append(html);
		var idTest = $('#modify-id').val();
		if(idTest.length==0){
			$('#modify-id').val(0)
		}
		//alert($('#modify-id').val());
		$.ajax({
			url: "/chat/modify.html",
			data: {id: $('#modify-id').val(), question: userQuestion, orgquestion: $("#modify-org-question").val(),organswer: $("#modify-org-answer").val(), answer: $("#modify-answer").val()},
			method: "post",
			beforeSend: function(xhr) {
				_this.attr("disabled", "disabled");
			},
			complete: function() {
				_this.prop("disabled", false);
			},
			success: function(result) {
				$("#modify-answer").val("");
				
			},
			error: function(e) {
				//alert("Error in processing");
				console.log(e);
			}
		});
	});
	
	$('#answers').on('click', '.fa-edit', function() {
		$("#modify-id").val($(this).closest('li').attr("id"));
		$("#modify-org-question").val($(this).closest('li').find(".result-question").text());
		$("#modify-org-answer").val($(this).closest('li').find(".result-answer").text());
		//alert($("#modify-org-answer").val());
		$("#modify-answer").val($(this).closest('li').find(".result-answer").text());
		var _this = $(this);
		$.ajax({
			url: "/chat/updateModifyCount.html",
			data: {id: _this.closest('li').attr("id")},
			method: "post",
			beforeSend: function(xhr) {
				//_this.attr("disabled", "disabled");
			},
			complete: function() {
				//_this.prop("disabled", false);
			},
			success: function(result) {
				
// 				_this.closest('li').remove();
			},
			error: function(e) {
				//alert("Error in processing");
				console.log(e);
			}
		});
		
	})
	.on('click', '.fa-remove', function() {
		
		var _this = $(this);
		var removeID = _this.closest('li').attr("id");
		//alert(typeof(removeID));
		//alert(_this.closest('li').attr("id"));
		$.ajax({
			url: "/chat/remove.html",
			data: {id: _this.closest('li').attr("id")},
			method: "post",
			beforeSend: function(xhr) {
				//_this.attr("disabled", "disabled");
			},
			complete: function() {
				//_this.prop("disabled", false);
			},
			success: function(result) {
				removeAnswerID(removeID);
				_this.closest('li').remove();
			},
			error: function(e) {
				//alert("Error in processing");
				console.log(e);
			}
		});
	})
	.on('click', '.remove-all', function(e) {
		removeAllAnswer();
		e.preventDefault();
		$("#answers").html("");
	});
});



function render(result) {
	
	$("#answers").html("");
	
	for (var i = 0; i < result.length; i++) {
		var html = '';
		html += '<li id="' + result[i].id + '">';
		
		html += '<a class="result-question" href="#">' + result[i].question + '</a>';
		html += '<p class="result-answer">' + result[i].answer + '</p>';
		html += '<p class="action"><i style="cursor: pointer" class="fa fa-edit"></i>&nbsp;<i style="cursor: pointer" class="fa fa-remove"></i></p>';
		
		html += '</li>';
		
		$("#answers").append(html);
	}
	
	var html = '';
	html += '<li>';
	
	html += '<a class="pull-right remove-all" style="color:red" href="#remote-all">None of the above</a>';
	
	html += '</li>';
	
	$("#answers").append(html);
}


</script>