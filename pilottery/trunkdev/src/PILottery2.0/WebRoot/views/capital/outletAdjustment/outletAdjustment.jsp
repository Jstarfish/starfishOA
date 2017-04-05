<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8"%>
<%@ include file="/views/common/taglibs.jsp"%>
<%@ include file="/views/common/meta.jsp"%>
<html>
<head>
<title>Edit OutletAccount</title>

<link rel="stylesheet" type="text/css" href="${basePath}/css/style.css" />
<link rel="stylesheet" type="text/css" href="${basePath}/css/pop-up.css" />
<link rel="stylesheet"
	href="${basePath}/component/messageBox/myJsBox.css" type="text/css" />
<link rel="stylesheet" type="text/css" href="${basePath}/css/validate.css" />
<script type="text/javascript" src="${basePath}/component/messageBox/myJsBox.js"></script>
<script type="text/javascript" src="${basePath}/js/myJs.js"></script>
<script type="text/javascript" src="${basePath}/js/jquery/jquery-1.9.1.js"></script>
<script type="text/javascript">
function doSubmit() {
	var adjustType = $('#adjustType').val();
	var adjustAmount = $('#adjustAmount').val();
	if(trim(adjustType) == ''){
		showError('Please select the adjust type');
		return false;
	}
	if(trim(adjustAmount) == '' || parseInt(adjustAmount)<=0){
		showError('Please input a right adjust amount');
		return false;
	}
	
	button_off("okBtn");
	$('#editForm').submit();
}
</script>
</head>
<body style="text-align: center">
	<form action="account.do?method=adjustOutletAccount" id="editForm" method="POST">
		<div class="pop-body">
			<table width="100%" border="0" cellspacing="0">
				<tr>
					<td align="right">Outlet Code：</td>
					<td align="left">
						<input class="text-big-noedit" name="agencyCode" value="${outlet.agencyCode }" readonly="readonly">
					</td>
				</tr>
				<tr>
					<td align="right">Outlet Name：</td>
					<td align="left">
						<input class="text-big-noedit" name="agencyName" value="${outlet.agencyName }" readonly="readonly">
					</td>
				</tr>
				<tr>
					<td align="right">Credit Limit：</td>
					<td align="left">
						<input name="creditLimit" class="text-big-noedit" value="${outlet.creditLimit }" readonly="readonly"/>
					</td>
				</tr>
				<tr>
					<td align="right">Account Balance：</td>
					<td align="left">
						<input class="text-big-noedit"	name="balance" value="${outlet.balance }" readonly="readonly">
					</td>
				</tr>
				<tr>
					<td align="right">Adjust Type：</td>
					<td align="left">
						<select class="select-big" name="adjustType" id="adjustType">
							<option value="">--Please Select--</option>
							<option value="1">Top up</option>
							<option value="2">Withdraw</option>
						</select>
					</td>
				</tr>
				<tr>
					<td align="right">Adjust Amount(riels)：</td>
					<td align="left">
					<input class="text-big" name="adjustAmount" id="adjustAmount"  onkeyup="this.value=this.value.replace(/[^\d,]/g,'')" >
					</td>
				</tr>
			</table>
		</div>
	<div class="pop-footer">
		<span class="left"><input id="okBtn" type="button" onclick="doSubmit()" value="Submit" class="button-normal"></input></span>
		<span class="right"><input type="Reset" value="Reset" class="button-normal"></input></span>
	</div>
	</form>
</body>
</html>