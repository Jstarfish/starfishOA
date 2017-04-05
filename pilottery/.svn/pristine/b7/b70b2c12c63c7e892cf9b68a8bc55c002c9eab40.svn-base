<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/views/common/taglibs.jsp"%>
<html>
<head>

<title>New Plan</title>

<%@ include file="/views/common/meta.jsp"%>
<link rel="stylesheet" type="text/css" href="${basePath}/css/style.css" />
<link rel="stylesheet" type="text/css" href="${basePath}/css/pop-up.css" />
<link rel="stylesheet" href="${basePath}/component/messageBox/myJsBox.css"
	type="text/css" />
<link rel="stylesheet" type="text/css" href="${basePath}/css/validate.css" />

<script type="text/javascript" src="${basePath}/js/myJs.js"></script>
<script type="text/javascript" src="${basePath}/component/messageBox/myJsBox.js"></script>
<script type="text/javascript"
	src="${basePath}/component/My97DatePicker/WdatePicker.js"></script>
<script type="text/javascript" src="${basePath}/js/jquery/jquery-1.9.1.js"></script>
<script type="text/javascript" src="${basePath}/js/regexEnum.js"></script>

<script type="text/javascript" charset="UTF-8">
function doClose() {
	window.parent.closeBox();
}

function doSubmit(){
	var referPlan = $("#referPlan").val();
	if(referPlan == ''){
		showError('请选择参考方案！');
    	return false;
	}
	button_off("okButton");
	$('#newPlanForm').submit();
}
</script>
<style type="text/css">
.pop-body table tr td {
	padding: 10px 5px;
}
</style>
</head>
<body>
	<form action="plans.do?method=setPlanComm" id="newPlanForm" method="POST">
		<div class="pop-body">
			<table width="100%" border="0" cellspacing="0" cellpadding="0">
				<tr>
					<td align="right" width="30%">方案编码：</td>
					<td align="left">
					 	<input name="planCode" class="text-big-noedit" value="${plan.planCode}" readonly="readonly" /> 
					</td>
				</tr>
				<tr>
					<td align="right">方案名称:</td>
					<td align="left">
						<input class="text-big-noedit" value="${plan.fullName}" readonly="readonly"/> 
					</td>
				</tr>
				<tr>
					<td align="right">面值:</td>
					<td align="left">
						<input class="text-big-noedit" value="${plan.faceValue}" readonly="readonly" />
					</td>
				</tr>
				<tr>
					<td align="right">出版商:</td>
					<td align="left">
						<input class="text-big-noedit" value="${plan.publisherName}" readonly="readonly" />
					</td>
				</tr>
				<tr>
					<td align="right">参考方案:</td>
					<td align="left">
						<select id="referPlan" name="referPlan" class="select-big">
							<option value="">--Please Select--</option>
							<c:forEach var="data" items="${planList}" varStatus="status">
								<option value="${data.planCode}">${data.fullName}</option>
							</c:forEach>
						</select>
					</td>
				</tr>
			</table>
		</div>

		<div class="pop-footer">
			<span class="left"> 
				<input id="okButton" type="button" value="提交" class="button-normal" onclick="doSubmit();"></input>
			</span> 
			<span class="right"> 
				<input id="cancelButton" type="button" value="取消" class="button-normal" onclick="doClose();"></input>
			</span>
		</div>
</form>
</body>
</html>