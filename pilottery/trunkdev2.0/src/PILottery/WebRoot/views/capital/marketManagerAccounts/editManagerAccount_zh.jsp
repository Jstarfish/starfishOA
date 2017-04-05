
<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8"%>
<%@ include file="/views/common/taglibs.jsp"%>
<%@ include file="/views/common/meta.jsp"%>
<html>
<head>
<title>编辑市场管理员账户</title>
<link rel="stylesheet" type="text/css" href="${basePath}/css/style.css" />
<link rel="stylesheet" type="text/css" href="${basePath}/css/pop-up.css" />
<link rel="stylesheet" type="text/css" href="${basePath}/css/validate.css" />
<link rel="stylesheet" href="${basePath}/component/messageBox/myJsBox.css" type="text/css" />
<script type="text/javascript" src="${basePath}/component/messageBox/myJsBox_zh.js"></script>
<script type="text/javascript" src="${basePath}/js/myJs.js"></script>
<script type="text/javascript" src="${basePath}/js/jquery/jquery-1.9.1.js"></script>

<script type="text/javascript" charset="UTF-8">
	function doSubmit() {
		button_off("okBtn");
		$('#editManagerAccountForm').submit();
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
	<form action="account.do?method=modifyManagerAcct"
		id="editManagerAccountForm" method="POST">
		<div class="pop-body">
			<table width="100%" border="0" cellspacing="0" cellpadding="0">
				<tr>
					<td align="right" width="35%">市场管理员编号：</td>
					<td align="left" width="25%">
					<input class="text-big-noedit" name=marketAdmin id="marketAdmin" value="${managerAccts.marketAdmin }" readonly="readonly"/>
					</td>
					<td><span id="marketAdminTip" class="tip_init"></span></td>
				</tr>
				
				<tr>
					<td align="right">市场管理员姓名：</td>
					<td align="left"><input class="text-big-noedit"
						name="realName" value="${managerAccts.realName }" readonly="readonly"></td>
					<td><span id="realNameTip" class="tip_init"></span></td>
				</tr>

				<tr>
					<td align="right">信用额度：</td>
					<td align="left"><input name="creditLimit" class="text-big"
						id="creditLimit" value="${managerAccts.creditLimit }" 
						maxlength="10" oninput="filterInput(this)"/></td>
					<td><span id="creditLimitTip" class="tip_init"></span></td>
				</tr>
				<c:if test="${applicationScope.useCompany == 2}">
				<tr>
					<td align="right">佘票金额：</td>
					<td align="left"><input name="maxAmountTickets"
						class="text-big" id="maxAmountTickets"
						value="${managerAccts.maxAmountTickets }" maxlength="10"
								oninput="filterInput(this)"/></td>
					<td><span id="maxAmountTicketsTip" class="tip_init"></span></td>
				</tr>
				</c:if>
			</table>
		</div>

		<div class="pop-footer">
			<span class="left"><input id="okBtn" type="button"
				value="修改" onclick="doSubmit();" class="button-normal"></input></span>
			<span class="right"><input type="Reset" value="重置"
				class="button-normal"></input></span>
		</div>
	</form>
</body>
</html>