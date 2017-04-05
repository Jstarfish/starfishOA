<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/views/common/taglibs.jsp"%>
<html>
<head>
<title>票面信息发布</title>
<%@ include file="/views/common/meta.jsp" %>
<script type="text/javascript" src="${basePath}/js/jquery/jquery-1.9.1.js"></script>
<script type="text/javascript" src="${basePath}/js/myJs_zh.js"></script>
<script type="text/javascript" src="${basePath}/component/messageBox/myJsBox_zh.js"></script>
<script type="text/javascript" src="${basePath}/js/oms/notice.js" charset="UTF-8"></script>

<link rel="stylesheet" type="text/css" href="${basePath}/component/messageBox/myJsBox.css" />
<link rel="stylesheet" type="text/css" href="${basePath}/css/style.css" />
<link rel="stylesheet" type="text/css" href="${basePath}/css/notice.css" />
<link rel="stylesheet" type="text/css" href="${basePath}/css/oms_notice.css" />

<script type="text/javascript">
var hint6 = '请输入消息内容，长度限42字符';
$(function(){
	var ticketMsg = "${msgLen}";
	if (typeof(ticketMsg)!= "undefined" && ticketMsg =="0") {
		$("#txtmsgcontent").val(hint6);
	}
});

function reLoad(){
	window.location.reload();
}
</script>
<style type="text/css">
#right1 .tit1 {
	font-size: 18px;
	height: 40px;
	line-height: 40px;
	padding-left: 20px;
	background: #f6f6f6;
}
.edui-editor {
	border: 1px solid #DDD;
	border-top: 1px solid #EBEBEB;
	border-bottom: 1px solid #B7B7B7;
	background-color: white;
	position: relative;
	overflow: visible;
	padding: 5px;
	border-radius: 4px;
	-moz-border-radius: 4px;
	-webkit-border-radius: 4px;
	box-shadow: 0 1px 1px #d3d1d1;
	margin-left: 20px;
	margin-top: 20px;
	width: 95%;
	font-family: "微软雅黑";
}
</style>
</head>
<body>
<div id="title">票面信息发布</div>
<!--中间部分开始-->
<form:form modelAttribute="notice" id="planForm">
<div style="height:80%; width:100%;	">
<div id="right1" style="margin:0">
  <div class="tit1" style="padding:0;margin-top:20px; margin:0 auto; width:1200px;">票面信息<span id="txtmsgtitleTip"></span></div>
  <div style="margin:0 auto;width:1200px;"><textarea id="txtmsgcontent" name="content" maxlength="100" rows="10" class="edui-editor" style="width: 100%;margin-left:0;font-size:35;">${ticketMsg}</textarea></div>
  <div style="margin:0 auto;width:1200px;">
	  <div class="button-div" style="float:left; width:68px;height:30px;line-height:30px" onclick="return tsmsg.clscc();">清空</div>
	  <div id="button-div" class="button-div" style="float:right;width:68px;height:30px;line-height:30px" onclick="tsmsg.publisTicketInfo('发送成功','发送失败');">发送</div>
  </div>
<div></div>
</div>
</div>
</form:form>
</body>
</html>

