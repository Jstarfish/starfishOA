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
<script type="text/javascript" src="${basePath}/component/messageBox/myJsBox_zh.js"></script>
<script type="text/javascript" src="${basePath}/js/myJs.js"></script>
<script type="text/javascript" src="${basePath}/js/jquery/jquery-1.9.1.js"></script>
<script type="text/javascript">
function doSubmit() {
	var adjustType = $('#adjustType').val();
	var adjustAmount = $('#adjustAmount').val();
	var reason = $('#reason').val();
	if(trim(adjustType) == ''){
		showError('请选择调整类型');
		return false;
	}
	if(trim(adjustAmount) == '' || parseInt(adjustAmount)<=0){
		showError('请输入调整金额');
		return false;
	}
	if(trim(reason) == ''){
		showError('请填写调账原因');
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
					<td align="right">站点编号：</td>
					<td align="left">
						<input class="text-big-noedit" name="agencyCode" value="${outlet.agencyCode }" readonly="readonly">
					</td>
				</tr>
				<tr>
					<td align="right">站点名称：</td>
					<td align="left">
						<input class="text-big-noedit" name="agencyName" value="${outlet.agencyName }" readonly="readonly">
					</td>
				</tr>
				<tr>
					<td align="right">信用额度：</td>
					<td align="left">
						<input name="creditLimit" class="text-big-noedit" value="${outlet.creditLimit }" readonly="readonly"/>
					</td>
				</tr>
				<tr>
					<td align="right">账户余额：</td>
					<td align="left">
						<input class="text-big-noedit"	name="balance" value="${outlet.balance }" readonly="readonly">
					</td>
				</tr>
				<tr>
					<td align="right">调整类型：</td>
					<td align="left">
						<select class="select-big" name="adjustType" id="adjustType">
							<option value="">--请选择--</option>
							<option value="1">充值</option>
							<option value="2">提现</option>
						</select>
					</td>
				</tr>
				<tr>
					<td align="right">调整金额(瑞尔)：</td>
					<td align="left">
					<input class="text-big" name="adjustAmount" id="adjustAmount"  onkeyup="this.value=this.value.replace(/[^\d,]/g,'')" maxLength="10">
					</td>
				</tr>
				<tr>
					<td  align="right">调账原因：</td>
					<td  align="left">
						<textarea id="reason" name="reason" cMaxByteLength="500" class="text-big" style="height:50px;width:200px;"></textarea>
					</td>
				</tr>
			</table>
		</div>
	<div class="pop-footer">
		<span class="left"><input id="okBtn" type="button" onclick="doSubmit()" value="提交" class="button-normal"></input></span>
		<span class="right"><input type="Reset" value="重置" class="button-normal"></input></span>
	</div>
	</form>
</body>
</html>