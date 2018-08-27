<%@ include file="/includes/taglibs.jsp" %>

<%-- Redirected because we can't set the welcome page to a virtual URL. --%>

<security:authorize ifAnyGranted="4">
	<c:redirect url="/report/data.html"/>
</security:authorize>

<c:redirect url="/index.html"/>