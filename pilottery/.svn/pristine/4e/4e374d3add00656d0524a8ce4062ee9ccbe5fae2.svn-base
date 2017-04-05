<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8"%>
<%@ include file="/views/common/taglibs.jsp"%>
<%@ include file="/views/common/meta.jsp"%>
<html>
<head>
<title>Edit Bank Account</title>

<link rel="stylesheet" type="text/css" href="${basePath}/css/style.css" />
<link rel="stylesheet" type="text/css" href="${basePath}/css/pop-up.css" />
<link rel="stylesheet" href="${basePath}/component/messageBox/myJsBox.css" type="text/css" />
<link rel="stylesheet" type="text/css" href="${basePath}/css/validate.css" />
<script type="text/javascript" src="${basePath}/component/messageBox/myJsBox_zh.js"></script>
<script type="text/javascript" src="${basePath}/js/myJs.js"></script>
<script type="text/javascript" src="${basePath}/js/jquery/jquery-1.9.1.js"></script>
<script type="text/javascript" src="${basePath}/js/regexEnum.js"></script>
<script type="text/javascript" charset="UTF-8">

function isNull(data) {
	return (data == "" || data == 0 || data == null);
}
//提现并判断
function doSubmit() {
	var result = true;
 	
 	if (!doCheck("bankAccNo", !isNull($("#bankAccNo").val()),	'Bank account no can not be null or empty！')) {
		result = false;
	} 
 	
 	if (!doCheck("bankAccName", !isNull($("#bankAccName").val()),	'Bank account name can not be null or empty！')) {
		result = false;
	}


 	if (result) {
		button_off("okBtn");
		$("#editOutletAccountForm").submit();
	}
}
</script>

</head>
<body style="text-align: center">
	<form action="outletBank.do?method=saveOutletAcct"
		id="editOutletAccountForm" method="POST">
		<div class="pop-body">
		<input type="hidden" id="bankAccSeq"name="bankAccSeq" value="${OutletAcc.bankAccSeq}">
			<table width="100%" border="0" cellspacing="0">
				<tr>
					<td align="right">Outlet Code：</td>
					<td align="left"><input class="text-big-noedit" name="agencyCode"
						value="${OutletAcc.agencyCode }" readonly="readonly"></td>
					<td><span id="agencyCodeTip" class="tip_init"></span></td>
				</tr>

				<tr>
					<td align="right">Outlet Name：</td>
					<td align="left" ><input class="text-big-noedit" id="agencyName"
						name="agencyName" value="${OutletAcc.agencyName }" readonly="readonly"></td>
					<td><span id="agencyNameTip" class="tip_init"></span></td>
				</tr>
				
				<tr>
					<td align="right">Org Name：</td>
					<td align="left" ><input class="text-big-noedit"
						name="orgName" value="${OutletAcc.orgName }" readonly="readonly"></td>
					<td><span id="orgNameTip" class="tip_init"></span></td>
				</tr>
				
				<tr>
					<td align="right">Administator：</td>
					<td align="left" ><input class="text-big-noedit"
						name="adminName" value="${OutletAcc.adminName }" readonly="readonly"></td>
					<td><span id="adminNameTip" class="tip_init"></span></td>
				</tr>
				
				<tr>
					<td align="right">Bank Account No：</td>
					<td align="left" ><input class="text-big" id="bankAccNo" 
						name="bankAccNo" value="${OutletAcc.bankAccNo }"></td>
					<td><span id="bankAccNoTip" class="tip_init"></span></td>
				</tr>
				<tr>
					<td align="right">Bank Account Name：</td>
					<td align="left"><input class="text-big" id="bankAccName" 
						name="bankAccName" value="${OutletAcc.bankAccName }"></td>
					<td><span id="bankAccNameTip" class="tip_init"></span></td>
				</tr>
				<tr>
					<td align="right">Currency：</td>
					<td align="left">
						<select name="currency" class="select-big" id="currency" readonly="readonly">
							<option value="1" selected="selected">Riel</option>
							<option value="2">USD</option>
						</select>
					</td>
					<td><span id="currencyTip" class="tip_init"></span></td>
				</tr>
			</table>

		</div>
		<div class="pop-footer">
			<span class="left"><input id="okBtn" type="button"
				value="Save" onclick="doSubmit();" class="button-normal"></input></span>
			<span class="right"><input type="Reset" value="Reset"
				class="button-normal"></input></span>
		</div>
	</form>
</body>
</html>