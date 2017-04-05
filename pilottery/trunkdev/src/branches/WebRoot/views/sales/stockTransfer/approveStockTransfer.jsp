<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8"%>
<%@ include file="/views/common/taglibs.jsp"%>
<html>
<head>

<title></title>

<%@ include file="/views/common/meta.jsp"%>
<link rel="stylesheet" type="text/css" href="${basePath}/css/style.css" />
<link rel="stylesheet"	href="${basePath}/component/messageBox/myJsBox.css" type="text/css" />
<link rel="stylesheet" type="text/css" href="${basePath}/css/pop-up.css" />
<script type="text/javascript"	src="${basePath}/component/messageBox/myJsBox.js"></script>
<script type="text/javascript"	src="${basePath}/component/My97DatePicker/WdatePicker.js"></script>
<script type="text/javascript"	src="${basePath}/js/jquery/jquery-1.9.1.js"></script>
<script type="text/javascript"	src="${basePath}/js/myJs.js"></script>
<script type="text/javascript">
function doSubmit(){
	button_off("okBtn");
	$('#editForm').submit();
}
</script>
</head>
<body style="text-align:center">
	<form  id="editForm" method="post" action="transfer.do?method=approveStockTransfer">
		<div class="pop-body">
			<table width="100%" border="0" cellspacing="0" cellpadding="0"	height="180px"  style="margin-top:10px; ">
				<tr>
					<td width="20%" align="right">Stock Transfer:</td>
					<td width="30%" align="center">
						<input class="text-big-noedit" maxLength="10" name="stbNo" readonly="readonly" value="${order.stbNo}"/>
					</td>
					<td width="20%" align="right">Date of Order:</td>
					<td width="30%" align="center">
						<input name="" class="text-big-noedit" readonly="readonly" value="<fmt:formatDate value='${order.applyDate}' pattern='yyyy-MM-dd HH:mm:ss'/>" />
					</td>
				</tr>
				<tr>
					<td  align="right">Delivering Unit:</td>
					<td  align="center">
						<input class="text-big-noedit" maxLength="10" readonly="readonly" name="sendOrg" value="${order.sendOrgName}"/>
					</td>
					<td  align="right">Receiving Unit:</td>
					<td  align="center">
						<input class="text-big-noedit" maxLength="10" readonly="readonly" name="receiveOrg" value="${order.receiveOrgName}"/>
					</td>
				</tr>
				<tr>
					<td  align="right">Quantity (tickets):</td>
					<td  align="center">
						<input id="applyTickets" name="tickets" readonly="readonly" class="text-big-noedit" value="${order.tickets }"/>
					</td>
					<td  align="right">Amount (riels):</td>
					<td  align="center">
						<input id="applyAmount" name="amount" readonly="readonly" class="text-big-noedit" value="${order.amount }"/>
					</td>
				</tr>
				<tr>
					<td>&nbsp;</td>
				</tr>
				<tr>
					<td align="right">Approve:</td>
					<td  align="center" >
						<select class="select-big"  name="status" >
							<option value="7">Allow</option>
							<option value="8">Deny</option>
						</select>
					</td>
				</tr>
			</table>
		</div>
		<div class="pop-footer" style="margin-top: 30px">
			<span class="left"><input id="okBtn" type="button" value="Submit" onclick="doSubmit();" class="button-normal"></input></span>
			<span class="right"><input type="Reset" value="Reset" class="button-normal"></input></span>
		</div>
	</form>

</body>
</html>