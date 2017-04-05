<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/views/common/taglibs.jsp"%>
<html>
<head>

<title>Edit</title>

<%@ include file="/views/common/meta.jsp" %>
<link rel="stylesheet" type="text/css" href="${basePath}/css/style.css"/>
<link rel="stylesheet" type="text/css" href="${basePath}/css/pop-up.css"/>
<link rel="stylesheet" href="${basePath}/component/messageBox/myJsBox.css" type="text/css"/>
<link rel="stylesheet" type="text/css" href="${basePath}/css/validate.css"/>

<script type="text/javascript" src="${basePath}/js/myJs.js"></script>
<script type="text/javascript" src="${basePath}/component/messageBox/myJsBox_zh.js"></script>
<script type="text/javascript" src="${basePath}/component/My97DatePicker/WdatePicker.js"></script>
<script type="text/javascript" src="${basePath}/js/jquery/jquery-1.9.1.js"></script>
<script type="text/javascript" src="${basePath}/js/regexEnum.js"></script>
<script type="text/javascript">
function doClose(){
	window.parent.closeBox();
}

function filterInput(obj) {
	var cursor = obj.selectionStart;
	obj.value = obj.value.replace(/[^\d]/g,'');
	obj.selectionStart = cursor;
	obj.selectionEnd = cursor;
}
</script>
</head>
<body>
	<form action="operateLog.do?method=modifyOperateType" id="form" method="POST">
		<div class="pop-body">
			<table width="100%" border="0" cellspacing="0" cellpadding="0" style="margin-top:25px;">
				<tr>
					<td width="28%" align="right">Operation Id：</td>
					<td width="35%" align="center">
						<input id="operModeId" name="operModeId" class="text-big-noedit" value="${operateType.operModeId}" readonly="readonly"></input>
					</td>
					<td><span id="operModeIdTip" class="tip_init"></span></td>
				</tr>
				<tr>
					<td width="28%" align="right">Operation Type：</td>
					<td width="35%" align="center">
						<input id="operModeName" name="operModeName" class="text-big" value="${operateType.operModeName}" maxlength="40" isCheckSpecialChar="true" cMaxByteLength="200"></input>
					</td>
					<td><span id="operModeNameTip" class="tip_init">*</span></td>
				</tr>
				<tr>
					<td width="28%" align="right">Threshold：</td>
					<td width="35%" align="center">
						<input id="operModeThreshold" name="operModeThreshold" class="text-big-noedit" value="${operateType.operModeThreshold}" oninput="filterInput(this)" maxLength="10"></input>
					</td>
					<td><span id="operModeThresholdTip" class="tip_init"></span></td>
				</tr>
				<tr>
					<td width="28%" align="right">Description：</td>
					<td width="35%" align="center">
						<textarea id="operContents" name="operContents" rows="4" class="address-area" style="width:200px" maxlength="600" isCheckSpecialChar="true" cMaxByteLength="500">${operateType.operContents}</textarea>
					</td>
					<td><span id="operContentsTip" class="tip_init"></span></td>
				</tr>
			</table>
		</div>
		
	    <div class="pop-footer">
	    	<span class="left">
	        	<input id="okButton" type="submit" value="Modify" class="button-normal"></input>
	        </span>
	        <span class="right">
	            <input id="cancelButton" type="button" value="Cancel" class="button-normal" onclick="doClose();"></input>
	        </span>
		</div>
	</form>
</body>
</html>