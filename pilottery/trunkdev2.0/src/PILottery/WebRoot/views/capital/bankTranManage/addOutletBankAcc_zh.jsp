<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8"%>
<%@ include file="/views/common/taglibs.jsp"%>
<%@ include file="/views/common/meta.jsp"%>
<html>
<head>
<title>增加站点银行账户</title>

<link rel="stylesheet" type="text/css" href="${basePath}/css/style.css" />
<link rel="stylesheet" type="text/css" href="${basePath}/css/pop-up.css" />
<link rel="stylesheet" href="${basePath}/component/messageBox/myJsBox.css" type="text/css" />
<link rel="stylesheet" type="text/css" href="${basePath}/css/validate.css" />
<script type="text/javascript" src="${basePath}/component/messageBox/myJsBox_zh.js"></script>
<script type="text/javascript" src="${basePath}/js/myJs.js"></script>
<script type="text/javascript" src="${basePath}/js/jquery/jquery-1.9.1.js"></script>
<script type="text/javascript" src="${basePath}/js/regexEnum.js"></script>
<script type="text/javascript" charset="UTF-8">


function getOutletInfo() {

	var url = "outletBank.do?method=getOutletInfo&outletCode=" + $("#agencyCode").val();
	$.ajax({
			url : url,
			dataType : "json",
			async : false,
			success : function(r) {
				if (r.reservedSuccessMsg == ''
						&& r.reservedSuccessMsg != null) {
					$("#agencyName").val(r.agencyName);
					$("#orgName").val(r.orgName);
					$("#adminName").val(r.adminName);
					
				} else {
					
					showError(decodeURI("站点无效或者站点不存在！"));
					return;
				}
			}
	});
}

function isNull(data) {
	return (data == "" || data == 0 || data == null);
}
//提现并判断
function doSubmit() {
	var result = true;

 	if (!doCheck("agencyCode", !isNull($("#agencyCode").val()),	'站点编号不能为空！')) {
		result = false;
	} 
	
 	if (!doCheck("bankAccNo", !isNull($("#bankAccNo").val()),	'账户卡号不能为空！')) {
		result = false;
	} 
 	
 	if (!doCheck("bankAccName", !isNull($("#bankAccName").val()),	'账户名称不能为空！')) {
		result = false;
	}

 	if (result) {
		button_off("okBtn");
		$("#addOutletAccountForm").submit();
	}
}



</script>

</head>
<body style="text-align: center">
	<form action="outletBank.do?method=addOutletAcct"
		id="addOutletAccountForm" method="POST">
		<div class="pop-body">
			<table width="100%" border="0" cellspacing="0">
				<tr>
					<td align="right">站点编码：</td>
					<td align="left">
						<input class="text-big" name="agencyCode" id="agencyCode">
						<input type="button" class="button-normal" value="验证" onclick="getOutletInfo();"/>
					</td>
					<td><span id="agencyCodeTip" class="tip_init"></span></td>
				</tr>

				<tr>
					<td align="right">站点名称：</td>
					<td align="left"><input class="text-big-noedit" id="agencyName"
						name="agencyName"  readonly="readonly"></td>
					<td><span id="agencyNameTip" class="tip_init"></span></td>
				</tr>
				
				<tr>
					<td align="right">所属机构：</td>
					<td align="left"><input class="text-big-noedit" id="orgName" 
						name="orgName"  readonly="readonly"></td>
					<td><span id="orgNameTip" class="tip_init"></span></td>
				</tr>
				
				<tr>
					<td align="right">负责人：</td>
					<td align="left"><input class="text-big-noedit" id="adminName" 
						name="adminName"  readonly="readonly"></td>
					<td><span id="adminNameTip" class="tip_init"></span></td>
				</tr>
				<tr>
					<td align="right">银行：</td>
					<td align="left">
						<select name="bankAccType" class="select-big" id="bankAccType" readonly="readonly">
							<option value="2" selected="selected">Wing</option>
						</select>
					</td>
					<td><span id="bankAccTypeTip" class="tip_init"></span></td>
				</tr>
				<tr>
					<td align="right">账户卡号：</td>
					<td align="left"><input class="text-big" id="bankAccNo"
						name="bankAccNo" ></td>
					<td><span id="bankAccNoTip" class="tip_init"></span></td>
				</tr>
				<tr>
					<td align="right">账户名称：</td>
					<td align="left"><input class="text-big" id="bankAccName"
						name="bankAccName" ></td>
					<td><span id="bankAccNameTip" class="tip_init"></span></td>
				</tr>
				<tr>
					<td align="right">币种：</td>
					<td align="left">
						<select name="currency" class="select-big" id="currency">
							<option value="1" selected="selected">瑞尔</option>
							<option value="2">美金</option>
						</select>
					</td>
					<td><span id="currencyTip" class="tip_init"></span></td>
				</tr>
			</table>

		</div>
		<div class="pop-footer">
			<span class="left"><input id="okBtn" type="button"
				value="保存" onclick="doSubmit();" class="button-normal"></input></span>
			<span class="right"><input type="Reset" value="重置"
				class="button-normal"></input></span>
		</div>
	</form>
</body>
</html>