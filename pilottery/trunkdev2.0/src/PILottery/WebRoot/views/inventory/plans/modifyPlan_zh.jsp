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
<script type="text/javascript" src="${basePath}/component/messageBox/myJsBox_zh.js"></script>
<script type="text/javascript"
	src="${basePath}/component/My97DatePicker/WdatePicker.js"></script>
<script type="text/javascript" src="${basePath}/js/jquery/jquery-1.9.1.js"></script>
<script type="text/javascript" src="${basePath}/js/regexEnum.js"></script>

<script type="text/javascript" charset="UTF-8">
	function doClose() {
		window.parent.closeBox();
	}

	//验证非空
	function isNotEmptyString(value) {
		return value != '' ? true : false;
	}

	function isSelected(value) {
		return value != 0 ? true : false;
	}

	$(document).ready(
			function() {
				$("#okButton").bind(
						"click",
						function() {
							var result = true;
							if (!checkFormComm('newPlanForm')) {
								result = false;
							}
							if (!doCheck("fullName", isNotEmptyString(trim($(
									"#fullName").val())), "不能为空")) {
								result = false;
							}

							if (!doCheck("shortName", isNotEmptyString(trim($(
									"#shortName").val())), "不能为空")) {
								result = false;
							}

							if (!doCheck("faceValue", isNotEmptyString($(
									"#faceValue").val()), "不能为空")) {
								result = false;
							}

							if (!doCheck("publisherCode", isSelected($(
									"#publisherCode").val()),
									"请选择出版商")) {
								result = false;
							}
						
							if (result) {
								button_off("okButton");
								$("#newPlanForm").submit();
							}
						});
			});
</script>
<style type="text/css">
.pop-body table tr td {
	padding: 10px 5px;
}
</style>
</head>
<body>
	<form action="plans.do?method=modifyPlan" id="newPlanForm" method="POST">
		<!-- TODO -->

		<div class="pop-body">
			<table width="100%" border="0" cellspacing="0" cellpadding="0">
				<tr>
					<td align="right" width="30%">方案编码:</td>
					<td align="left"><input id="planCode" name="planCode"
						class="text-big-noedit" value="${plan.planCode}" readonly="true" /> <span
						id="planCodeTip" class="tip_init"></span></td>

				</tr>
				<tr>
					<td align="right">方案全称:</td>
					<td align="left"><input id="fullName" name="fullName" class="text-big"
						maxLength="30" value="${plan.fullName}" isCheckSpecialChar="true"
						cMaxByteLength="30" /> <span id="fullNameTip" class="tip_init">*</span></td>
				</tr>
				<tr>
					<td align="right">方案简称:</td>
					<td align="left"><input id="shortName" name="shortName" class="text-big"
						maxLength="10" value="${plan.shortName}" isCheckSpecialChar="true"
						cMaxByteLength="10" /> <span id="shortNameTip" class="tip_init">*</span></td>
				</tr>
				<tr>
					<td align="right">面值:</td>
					<td align="left"><input id="faceValue" name="faceValue"
						class="text-big-noedit" maxLength="9" value="${plan.faceValue}" readonly="true" />
						<span id="faceValueTip" class="tip_init"></span></td>
				</tr>
				<tr>
					<td align="right">出版商:</td>
					<td align="left"><select id="publisherCode" name="publisherCode"
						class="select-big">
							<option value="${plan.publisherCode}">${plan.publisherName}</option>
							<c:forEach var="data" items="${publisherList}" varStatus="status">
								<option value="${data.publisherCode}">${data.publisherName}</option>
							</c:forEach>
					</select> <span id="publisherCodeTip" class="tip_init">*</span></td>
				</tr>
			</table>
		</div>

		<div class="pop-footer">
			<span class="left"> <input id="okButton" type="button" value="修改"
				class="button-normal"></input>
			</span> <span class="right"> <input id="cancelButton" type="button" value="取消"
				class="button-normal" onclick="doClose();"></input>
			</span>
		</div>

	</form>
</body>
</html>