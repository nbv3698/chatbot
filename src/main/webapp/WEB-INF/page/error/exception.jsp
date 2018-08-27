<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/includes/taglibs.jsp"%>

<title>Error Page</title>

<div>
	<c:choose>
		<c:when test="${errorCode == '404' }">
			<h3 class="errorLabel text-center">Nội dung không có sẵn, vui lòng quay trở lại sau</h3>
		</c:when>
		<c:otherwise>
			<div id="message" class="errorLabel">Exception Thrown: ${exception.message}</div>
			<c:if test="${showTrace eq null || showTrace eq true }">
				<div id="stackTrace">${exception.stackTrace}</div>
			</c:if>
		</c:otherwise>
	</c:choose>
</div>