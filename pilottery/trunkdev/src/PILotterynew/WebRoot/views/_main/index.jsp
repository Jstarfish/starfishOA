<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title></title>
<%@ include file="/views/common/meta.jsp" %>

</head>

<body style="overflow: hidden">

 
<div id="header" style="top:0px;left:0px; width:100%;">
    <jsp:include page="./header.jsp" />
</div>
<div id="main" style="position:fixed; width:100%; height:auto; top:90px; bottom:0px; left:0px;">
    <iframe id="ifmain" name="ifmain" frameborder="0" src="index.do?method=mainRequest" scrolling="auto" style="width:100%; height:100%;">
    </iframe>
</div>
</body>
</html>
