<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/views/common/taglibs.jsp"%>
<html>
<head>

<title>新增方案</title>

<%@ include file="/views/common/meta.jsp"%>
<link rel="stylesheet" type="text/css" href="${basePath}/css/style.css" />
<link rel="stylesheet" type="text/css" href="${basePath}/css/pop-up.css" />
<link rel="stylesheet" type="text/css" href="${basePath}/css/validate.css" />
<link rel="stylesheet" href="${basePath}/component/messageBox/myJsBox.css"
	type="text/css" />
<script type="text/javascript" src="${basePath}/component/messageBox/myJsBox_zh.js"></script>
<script type="text/javascript" src="${basePath}/js/myJs_zh.js"></script>
<script type="text/javascript" src="${basePath}/js/jquery/jquery-1.9.1.js"></script>

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
	function isNull(data) {
		return (data == "" || data == undefined || data == null);
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
							if (isNull(trim($("#planCode").val()))) {
								ckSetFormOjbErrMsg('planCode','不可为空');
								result = false;
							}
							if (isNull(trim($("#fullName").val()))) {
								ckSetFormOjbErrMsg('fullName','不可为空');
								result = false;
							}
							if (isNull(trim($("#shortName").val()))) {
								ckSetFormOjbErrMsg('shortName','不可为空');
								result = false;
							}
							if (isNull(trim($("#faceValue").val()))) {
								ckSetFormOjbErrMsg('faceValue','不可为空');
								result = false;
							}


							if (!doCheck("publisherCode", isSelected($(
									"#publisherCode").val()),
									"请选择出版社")) {
								result = false;
							}
						
							if (result) {
								$("#newPlanForm").submit();
								//$("#newPlanForm").submit();
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
	<form action="plans.do?method=addPlan" id="newPlanForm" method="POST">
		<!-- TODO -->

		<div class="pop-body">
			<table width="100%" border="0" cellspacing="0" cellpadding="0">
				<tr>
					<td align="right" width="30%">方案编号：</td>
					<td align="left"><input id="planCode" name="planCode" class="text-big"
						maxLength="8" isCheckSpecialChar="true" cMaxByteLength="8" /> <span
						id="planCodeTip" class="tip_init"> *1~8 字符</span></td>
				</tr>
				<tr>
					<td align="right">方案全称：</td>
					<td align="left"><input id="fullName" name="fullName" class="text-big"
						maxLength="30" isCheckSpecialChar="true" cMaxByteLength="30" /> <span
						id="fullNameTip" class="tip_init"> *1~30 字符</span></td>
				</tr>
				<tr>
					<td align="right">方案简称：</td>
					<td align="left"><input id="shortName" name="shortName" class="text-big"
						 isCheckSpecialChar="true" cMaxByteLength="10" /> <span
						id="shortNameTip" class="tip_init"> *1~10 字符</span></td>
				</tr>
				<tr>
					<td align="right">面值：</td>
					<td align="left"><input id="faceValue" name="faceValue" class="text-big"
						maxLength="9" oninput="this.value=this.value.replace(/[^\d,]/g,'')" /> <span
						id="faceValueTip" class="tip_init"> *</span></td>
				</tr>
				<tr>
					<td align="right">出版社：</td>
					<td align="left"><select id="publisherCode" name="publisherCode"
						class="select-big">
							<c:forEach var="data" items="${publisherList}" varStatus="status">
								<option value="${data.publisherCode}">${data.publisherName}</option>
							</c:forEach>
					</select> <span id="publisherCodeTip" class="tip_init">*</span></td>
				</tr>
			</table>
		</div>

		<div class="pop-footer">
			<span class="left"> <input id="okButton" type="button" value='提交'
				class="button-normal"></input>
			</span> <span class="right"> <input type="button" value="取消"
				onclick="doClose();" class="button-normal"></input>
			</span>
		</div>

	</form>
</body>
</html>