<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/views/common/taglibs.jsp"%>
<html>
<head>
<title></title>
<link rel="stylesheet" type="text/css" href="${basePath}/css/style.css" />
<link rel="stylesheet" type="text/css" href="${basePath}/css/pop-up.css" />
<link rel="stylesheet" type="text/css" href="${basePath}/css/validate.css" />
<script type="text/javascript" src="${basePath}/js/jquery/jquery-1.9.1.js"></script>
<link rel="stylesheet" href="${basePath}/component/messageBox/myJsBox.css" type="text/css"/>
<script type="text/javascript" src="${basePath}/component/messageBox/myJsBox_zh.js"></script>
<script type="text/javascript" src="${basePath}/js/oms/myJs.js"></script>
<script type="text/javascript" charset="UTF-8" >
function doSubmit() {
	var fdbd = $("#fdbd").val();
	var fdfd = $("#fdfd").val();
	var fdmin = $("#fdmin").val();
	if(fdbd == '' || fdbd == 'undefined'){
		$('#fdbdTip').html("不能为空");return false;
	}
	if(fdfd == '' || fdfd == 'undefined'){
		$('#fdfdTip').html("不能为空");return false;
	}
	if(Number(fdfd) < Number(fdbd)){
		alert('封顶金额不能小于保底金额');return false;
	}
	if(fdmin == '' || fdmin == 'undefined'){
		$('#fdminTip').html("不能为空");return false;
	}else if(fdmin == 0){
		$('#fdminTip').html("抹零金额不能为0");return false;
	}
	$("#gmForm").attr("action","issueManagement.do?method=saveCalcWinningParam");
	button_off("okBtn"); 
	$("#gmForm").submit();
}
</script>
</head>
<body>
 	<form method="POST" id="gmForm">
	<input type="hidden" name="gameIssue.gameCode" value="${gameIssue.gameCode }" />
	<input type="hidden" name="gameIssue.issueNumber" value="${gameIssue.issueNumber }" />
  	<div class="pop-body">
        <table width="100%" border="0" cellspacing="0" cellpadding="0" >
	  		<c:if test="${gameIssue.gameCode==6}">
			<tr>
				<td align="center"><br><br>是否启用特殊奖级：
					<input type="radio" name="isSpecial" value="1" <c:if test="${gameManagementForm.isSpecial==1}">checked</c:if>>是</input>
					<input type="radio" name="isSpecial" value="0" <c:if test="${gameManagementForm.isSpecial==0}">checked</c:if>>否</input>
				</td>
			</tr>
			</c:if>
			<c:if test="${gameIssue.gameCode==7}">
			<tr>
				<td align="right" width="40%">保底金额：&nbsp;&nbsp; </td>
				<td>
					<input id="fdbd" name="fdbd" cass="text-normal" onblur="value=value.replace(/[^0-9]/g,'')" maxlength="11"/>
					<font color="red"><label id="fdbdTip"></label></font>
				</td>
			</tr>
			<tr>
				<td align="right">封顶金额：&nbsp;&nbsp;</td>
				<td> 
					<input id="fdfd" name="fdfd" class="text-normal" onblur="value=value.replace(/[^0-9]/g,'')" maxlength="11"/>
					<font color="red"><label id="fdfdTip"></label></font>
				</td>
			</tr>
			<tr>
				<td align="right">抹零金额：&nbsp;&nbsp;</td>
				<td> 
					<select name="fdmin" class="select-normal">
					  <option value ="1" <c:if test="${gameManagementForm.fdmin==1}"> selected </c:if>>1</option>
					  <option value ="10" <c:if test="${gameManagementForm.fdmin==10}"> selected </c:if>>10</option>
					  <option value ="100" <c:if test="${gameManagementForm.fdmin==100}"> selected </c:if>>100</option>
					  <option value ="1000" <c:if test="${gameManagementForm.fdmin==1000}"> selected </c:if>>1000</option>
					</select>
					<font color="red"><label id="fdminTip"></label></font>
				</td>
			</tr>
			</c:if>
		</table>
	</div>
    <div class="pop-footer">
        <span class="left"><input id="okBtn" type="button" value="提交" onclick="doSubmit();" class="button-normal"></input></span>
        <span class="right"><input type="reset" value="重置" class="button-normal"></input></span>
    </div>
	</form>
</body>
</html>
