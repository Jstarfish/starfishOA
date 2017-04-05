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
<script type="text/javascript" src="${basePath}/component/messageBox/myJsBox.js"></script>
<script type="text/javascript" src="${basePath}/js/oms/myJs.js"></script>
<script type="text/javascript" charset="UTF-8" >
function doSubmit() {
	var fdbd = $("#fdbd").val();
	var fdfd = $("#fdfd").val();
	var fdmin = $("#fdmin").val();
	if(fdbd == '' || fdbd == 'undefined'){
		$('#fdbdTip').html("Cannot be empty");return false;
	}
	if(fdfd == '' || fdfd == 'undefined'){
		$('#fdfdTip').html("Cannot be empty");return false;
	}
	if(Number(fdfd) < Number(fdbd)){
		alert('First-prize lower limit cannot be less than first-prize upper limit');return false;
	}
	if(fdmin == '' || fdmin == 'undefined'){
		$('#fdminTip').html("Cannot be empty");return false;
	}else if(fdmin == 0){
		$('#fdminTip').html("Chump change cannot be zero");return false;
	}
	$("#gmForm").attr("action","issueManagement.do?method=saveCalcWinningParam");
	button_off("okBtn"); 
	$("#gmForm").submit();
}
</script>
</head>
<body>
 	<form:form modelAttribute="gameManagementForm" id="gmForm">
	<form:hidden path="gameIssue.gameCode" />
	<form:hidden path="gameIssue.issueNumber" />
  	<div class="pop-body">
        <table width="100%" border="0" cellspacing="0" cellpadding="0" >
	  		<c:if test="${gameIssue.gameCode==6}">
			<tr>
				<td align="center"><br><br>Special Award Enabled：
					<input type="radio" name="isSpecial" value="1" <c:if test="${gameManagementForm.isSpecial==1}">checked</c:if>>Yes</input>
					<input type="radio" name="isSpecial" value="0" <c:if test="${gameManagementForm.isSpecial==0}">checked</c:if>>No</input>
				</td>
			</tr>
			</c:if>
			<c:if test="${gameIssue.gameCode==7}">
			<tr>
				<td align="right" width="40%">1st-Prize Lower Limit：&nbsp;&nbsp; </td>
				<td>
					<form:input id="fdbd" path="fdbd" class="text-normal" onblur="value=value.replace(/[^0-9]/g,'')" maxlength="11"/>
					<font color="red"><label id="fdbdTip"></label></font>
				</td>
			</tr>
			<tr>
				<td align="right">1st-Prize Upper Limit：&nbsp;&nbsp;</td>
				<td> 
					<form:input id="fdfd" path="fdfd" class="text-normal" onblur="value=value.replace(/[^0-9]/g,'')" maxlength="11"/>
					<font color="red"><label id="fdfdTip"></label></font>
				</td>
			</tr>
			<tr>
				<td align="right">Chump Change：&nbsp;&nbsp;</td>
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
        <span class="left"><input id="okBtn" type="button" value="Submit" onclick="doSubmit();" class="button-normal"></input></span>
        <span class="right"><input type="reset" value="Reset" class="button-normal"></input></span>
    </div>
	</form:form>
</body>
</html>
