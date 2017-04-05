<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/views/common/taglibs.jsp"%>
<html>
<head>

<title>修改球队</title>

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
							if (isNull(trim($("#shortName").val()))) {
								ckSetFormOjbErrMsg('shortName','不可为空');
								result = false;
							}
							if (isNull(trim($("#fullName").val()))) {
								ckSetFormOjbErrMsg('fullName','不可为空');
								result = false;
							}

							if (!doCheck("countryCode", isSelected($(
									"#countryCode").val()),
									"请选择国家")) {
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
	<form action="team.do?method=modifyTeam" id="newPlanForm" method="POST">

		<div class="pop-body">
			<table width="650" border="0" cellspacing="0" cellpadding="0">
				<tr>
					<td align="right" width="30%">球队编号：</td>
					<td align="left" width="40%"><input type="hidden" name="teamCode"
						value="${team.teamCode }">${team.teamCode }</td>
					<td><span></span></td>
				</tr>
				<tr>
					<td align="right" width="30%">球队简称：</td>
					<td align="left" width="40%"><input id="shortName" name="shortName"
						class="text-big" maxLength="30" value="${team.shortName }"
						isCheckSpecialChar="true" cMaxByteLength="30" /></td>
					<td><span id="shortNameTip" class="tip_init"> *1~30 字符</span></td>
				</tr>
				<tr>
					<td align="right" width="30%">球队全称：</td>
					<td align="left" width="40%"><input id="fullName" name="fullName"
						class="text-big" maxLength="100" value="${team.fullName }"
						isCheckSpecialChar="true" /></td>
					<td><span id="fullNameTip" class="tip_init"> *1~100 字符</span></td>
				</tr>
				<tr>
					<td align="right" width="30%">所属地区：</td>
					<td align="left" width="40%"><select style="width:200px" id="countryCode" name="countryCode"
						class="select-big">
							<c:forEach var="data" items="${countryList}">
								<option value="${data.countryCode}"
									<c:if test="${team.countryCode==data.countryCode }">selected</c:if>>${data.countryName}</option>
							</c:forEach>
					</select></td>
					<td><span id="countryCodeTip" class="tip_init">*</span></td>
				</tr>
				<tr>
					<td align="right" width="30%">备注：</td>
					<td align="left" width="40%"><textarea id="remark" name="remark"
							isCheckSpecialChar="true" cMaxByteLength="200" class="text-big"
							style="height: 80px; width: 200px;">${team.remark }</textarea></td>
					<td><span id="remarkTip" class="tip_init"></span></td>
				</tr>
			</table>
		</div>

		<div class="pop-footer">
			<span class="left"> <input id="okButton" type="button" value='修改'
				class="button-normal"></input>
			</span> <span class="right"> <input type="button" value="取消"
				onclick="doClose();" class="button-normal"></input>
			</span>
		</div>

	</form>
</body>
</html>