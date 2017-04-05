<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/views/common/taglibs.jsp"%>
<html>
<head>
<title> </title>
<link rel="stylesheet" type="text/css" href="${basePath}/css/style.css" />
<link rel="stylesheet" type="text/css" href="${basePath}/css/pop-up.css" />
<link rel="stylesheet" type="text/css" href="${basePath}/css/validate.css" />
<script type="text/javascript" src="${basePath}/js/jquery/jquery-1.9.1.js"></script>
<script type="text/javascript" src="${basePath}/js/oms/myJs.js"></script>
<script type="text/javascript" charset="UTF-8" >
function doSubmit() {
	$("#gmForm").attr("action","issueManagement.do?method=savePrize&listSize=${listSize}");
	button_off("okBtn");
	$("#gmForm").submit();
}
</script>
</head>
<body style="overflow-y:hidden;overflow-x:hidden;">
  <form:form modelAttribute="gameManagementForm" id="gmForm">
	  <div class="pop-body" style="overflow-y:auto;margin-bottom:50px;position:absolute;left:10px;right:10px;bottom:20px;top:10px;">
        <table class="datatable" width="100%" border="0" cellspacing="0" cellpadding="0" >
			<tr class="headRow">
				<td width="10%"/><td>Name</td><td>Award</td>
			</tr>
			<c:forEach var="gameIssuePrizeRule" items="${list}" varStatus="s" >
				<input type="hidden" name="gameIssuePrizeRule${s.index}.gameCode" value="${gameIssuePrizeRule.gameCode}"/>
				<input type="hidden" name="gameIssuePrizeRule${s.index}.prizeLevel" value="${gameIssuePrizeRule.prizeLevel}"/>
				<input type="hidden" name="gameIssuePrizeRule${s.index}.issueNumber" value="${gameIssuePrizeRule.issueNumber}"/>
				<tr><td width="10%"></td>
					<td width="40%">${gameIssuePrizeRule.prizeName}<input type="hidden" name="gameIssuePrizeRule${s.index}.prizeName" value="${gameIssuePrizeRule.prizeName}"/></td>
					<td width="50%"><input type="text" name="gameIssuePrizeRule${s.index}.levelPrize" value="${gameIssuePrizeRule.levelPrize}" class="text-normal" onblur="value=value.replace(/[^0-9]/g,'')" maxlength="12"/></td>
				</tr>
			</c:forEach>
		 </table>
	  </div>
	  <div class="pop-footer">
            <span class="left"><input id="okBtn" type="button" value="Submit" onclick="doSubmit();" class="button-normal"></input></span>
            <span class="right"><input type="reset" value="Reset" class="button-normal"></input></span>
       </div>
  </form:form>
</body>
</html>
