
<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8"%>
<%@ include file="/views/common/taglibs.jsp"%>
<%@ include file="/views/common/meta.jsp"%>
<html>
<head>
<title>还货审批</title>

<link rel="stylesheet" type="text/css" href="${basePath}/css/style.css" />
<link rel="stylesheet" type="text/css" href="${basePath}/css/pop-up.css" />
<link rel="stylesheet"
	href="${basePath}/component/messageBox/myJsBox.css" type="text/css" />
<link rel="stylesheet" type="text/css"
	href="${basePath}/css/validate.css" />
<link rel="stylesheet" href="${basePath}/css/demo.css" type="text/css">
<link rel="stylesheet" href="${basePath}/css/zTreeStyle/zTreeStyle.css"
	type="text/css">


<script type="text/javascript"
	src="${basePath}/component/messageBox/myJsBox.js"></script>
<script type="text/javascript"
	src="${basePath}/component/My97DatePicker/WdatePicker.js"></script>

<script type="text/javascript" src="${basePath}/js/myJs.js"></script>
<script type="text/javascript"
	src="${basePath}/js/jquery/jquery-1.9.1.js"></script>
<script type="text/javascript" src="${basePath}/js/regexEnum.js"></script>

<script type="text/javascript" charset="UTF-8">
	function doSubmit() {
		button_off("okBtn");
		$('#returnRecorder').submit();
	}

	function doClose() {
		window.parent.closeBox();
	}
</script>
</head>
<body>
	<form action="return.do?method=approveReturn" id="returnRecorder" method="POST">
		 <input type="hidden" name="returnNo" value="${returnRecordInfo.returnNo}">
		<div class="pop-body">
			<table width="100%" border="0" cellspacing="0" cellpadding="0">
				<tbody style="font-size: 14px;">
					<tr height="10px">
						<td colspan="2"></td>
					</tr>
					<tr>
						<td align="right"> 审批:</td>
						<td align="center">
							<input  type="radio" name="approveStatus" value="1" checked="checked"/> 同意 
							&nbsp;&nbsp;&nbsp;&nbsp;
							<input  type="radio" name="approveStatus" value="2" /> 拒绝
						</td>
						<td><span id="checkResultTip" class="tip_init"></span></td>
					</tr>
			</table>
		</div>
		<div class="pop-footer">
			<span class="left"><input id="okBtn" type="button" value="提交"
				onclick="doSubmit();" class="button-normal"></input></span> 
			<span class="right"><input type="button" value="取消"
				onclick="doClose();" class="button-normal"></input></span>
		</div>
	</form>
</body>
</html>