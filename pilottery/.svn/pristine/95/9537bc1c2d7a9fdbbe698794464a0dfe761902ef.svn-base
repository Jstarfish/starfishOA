<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/views/common/taglibs.jsp"%>
<html>
<head>

<title>修改联赛</title>

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

function checkTeam(obj,teamCode){
	if (obj.checked){	
		obj.value=teamCode;
	}else{
		obj.value="";
	}
}

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
							 if (!checkFormComm('newLeagueForm')) {
								result = false;
							}
							 if (isNull($("#abbr").val())) {
								ckSetFormOjbErrMsg('abbr','不可为空');
								result = false;
							}
							if (isNull($("#name").val())) {
								ckSetFormOjbErrMsg('name','不可为空');
								result = false;
							} 

							if (result) {
								$("#newLeagueForm").submit();
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
	<form action="league.do?method=editLeague" id="newLeagueForm" method="POST">
		<div class="pop-body">
			<table width="100%" border="0" cellspacing="0" cellpadding="0">
				<tr>
					<td align="right" width="30%">联赛编号：</td>
					<td align="left">
						<input type="hidden" name="competitionCode" value="${league.competitionCode }">${league.competitionCode }
					</td>
				</tr>
				<tr>
					<td align="right">联赛简称：</td>
					<td align="left"><input id="abbr" name="abbr" class="text-big"
						maxLength="30" isCheckSpecialChar="true" cMaxByteLength="30" value="${league.abbr }"/> <span
						id="abbrTip" class="tip_init"> *1~30 字符</span></td>
				</tr>
				<tr>
					<td align="right">联赛全称：</td>
					<td align="left"><input id="name" name="name" class="text-big"
						 isCheckSpecialChar="true" cMaxByteLength="100" value="${league.name }"/> <span
						id="nameTip" class="tip_init" >*1~100 字符 </span></td>
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