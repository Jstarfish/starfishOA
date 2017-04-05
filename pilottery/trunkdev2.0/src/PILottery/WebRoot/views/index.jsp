<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title></title>
<%@ include file="/views/common/meta.jsp" %>

</head>

<body style="overflow: hidden">
	<%
	String path = request.getRequestURI(); 
	String version = request.getParameter("ver");
	String isTestSystem = (String)this.getServletContext().getAttribute("isTestSystem");
	int httpPort = (Integer)this.getServletContext().getAttribute("httpServerPort");
	if(isTestSystem.equals("0") && version == null){
	%>
		<jsp:include page="./upgradeForbidden.jsp" />
	<%
	}else{
	if(path.indexOf("/pos.do") == -1 && request.getServerPort() == httpPort && isTestSystem.equals("0")){
    %>
    	<jsp:include page="./loginForbiddenTip.jsp" />
    <%}else{ %>
   		<jsp:include page="./login.jsp" />
    <%}} %>
    
</body>
</html>
