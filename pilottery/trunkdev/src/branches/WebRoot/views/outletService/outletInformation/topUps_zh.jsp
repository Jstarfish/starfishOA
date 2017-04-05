<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8"%>
<%@ include file="/views/common/taglibs.jsp"%>
<%@ include file="/views/common/meta.jsp"%>
<html>
<head>
<title>站点充值</title>
<link rel="stylesheet" type="text/css" href="${basePath}/css/style.css" />
<link rel="stylesheet" type="text/css" href="${basePath}/css/pop-up.css" />
<link rel="stylesheet" href="${basePath}/component/messageBox/myJsBox.css" type="text/css" />
<link rel="stylesheet" type="text/css" href="${basePath}/css/validate.css" />
<script type="text/javascript" src="${basePath}/component/messageBox/myJsBox.js"></script>
<script type="text/javascript" src="${basePath}/component/My97DatePicker/WdatePicker.js"></script>
<script type="text/javascript" src="${basePath}/js/myJs.js"></script>
<script type="text/javascript" src="${basePath}/js/jquery/jquery-1.9.1.js"></script>
<script type="text/javascript" src="${basePath}/js/regexEnum.js"></script>
<script type="text/javascript" charset="UTF-8">
$(document).ready(function(){
	 $("#operAmount").blur(function(){
		  get_num();
		});
});
function get_num(){
	var num2=$("#operAmount").val();
	if(num2){
	var num1 = $("#beforeBalance").val();
	$("#afterBalance").val(parseInt(num1) + parseInt(num2));
	}
}

//市场管理员给站点充值，充值金额不能大于市场管理员的账户金额+信用额度

function isNull(data) {
	return (data == "" || data == 0 || data == null);
}

function ifNull(data) {
	return (data == "" || data == null);
}

function doSubmit() {
	var num5 =parseInt($("#mmCreditLimit").val()) + parseInt($("#mmAccountBalance").val());
	var result = true;
	
 	if (!doCheck("operAmount", !isNull($("#operAmount").val()), '充值金额不能为0')) {
		result = false;
	}else{ 
		if(!doCheck("operAmount", $("#operAmount").val() <= num5, '充值金额不能大于信用额度和账户余额的总和')){
		result = false;
	   }
	}
 	 if (!doCheck("password", !ifNull($("#password").val()), '交易密码不能为空')) {
		result = false;
	}
 	
	 if (result) {
		 button_off("okButton");
		 $("#OutletTopUpsForm").submit();
	}
}
	//关闭
	function doClose() {
		window.parent.closeBox();
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
<form action="outletInfo.do?method=OutletTopUps" id="OutletTopUpsForm" name="OutletTopUpsForm" method="POST">
 	<c:forEach var="obj" items="${OutletTopUpsForm2}">
		<input type="hidden" name="beforeBalance" id="beforeBalance" value="${obj.accountBalance}">
	</c:forEach> 
		<input type="hidden" name="mmCreditLimit" id="mmCreditLimit" value="${marketManager.creditLimit}">
		<input type="hidden" name="mmAccountBalance" id="mmAccountBalance" value="${marketManager.accountBalance}">
	
	<div class="pop-body">
		<table width="100%" border="0" cellspacing="0" cellpadding="0">
			<tr>
				<td class="td" align="right" width="30%">站点编码：</td>
				<td class="td" align="left" width="30%">
				<input type="text" name="agencyCode" class="text-big-noedit" id="agencyCode" 
				readonly="readonly" value="${OutletTopUpsForm.agencyCode }"/></td>
				<td><span id="agencyCodeTip" class="tip_init"></span></td>
	    	</tr>

			<tr>
				<td class="td" align="right">站点名称：</td>
				<td class="td" align="left"><input type="text" name="agencyName" class="text-big-noedit" id="agencyName" 
				readonly="readonly" value="${OutletTopUpsForm.agencyName }" /></td>
				<td><span id="agencyNameTip" class="tip_init"></span></td>
			</tr>
			
			<tr>
				<td class="td" align="right">充值金额：</td>
				<td class="td" align="left"><input type="text" name="operAmount" class="text-big" id="operAmount"
					oninput="filterInput(this)" maxlength="12"/></td>
				<td><span id="operAmountTip" class="tip_init">*</span></td>
			</tr>
			
			<tr>
				<td class="td" align="right">充值后余额：</td>
				<td class="td" align="left"><input type="text" name="afterBalance" class="text-big-noedit" id="afterBalance" readonly="readonly"/></td>
				<td><span id="afterBalanceTip" class="tip_init"></span></td>
			</tr>
			
			<tr>
				<td class="td" align="right">密码：</td>
				<td class="td" align="left"><input type="password" name="password" class="text-big" id="password" /></td>
				<td><span id="passwordTip" class="tip_init">*</span></td>
			</tr>
		</table>
	</div>
		
	<div class="pop-footer">
		<span class="left">
			<input id="okButton" type="button" value='充值' onclick="doSubmit();" class="button-normal"></input>
		</span> 
		<span class="right">			
			<input type="button" value="取消" onclick="doClose();" class="button-normal"></input>
		</span>
	</div>
</form>
</body>
</html>
