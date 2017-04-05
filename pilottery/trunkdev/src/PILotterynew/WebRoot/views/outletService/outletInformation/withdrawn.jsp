<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8"%>
<%@ include file="/views/common/taglibs.jsp"%>
<%@ include file="/views/common/meta.jsp"%>
<html>
<head>
<title>Withdrawn</title>
<link rel="stylesheet" type="text/css" href="${basePath}/css/style.css" />
<link rel="stylesheet" type="text/css" href="${basePath}/css/pop-up.css" />
<link rel="stylesheet" type="text/css" href="${basePath}/css/validate.css" />
<script type="text/javascript" src="${basePath}/js/myJs.js"></script>
<script type="text/javascript" src="${basePath}/js/jquery/jquery-1.9.1.js"></script>
<script type="text/javascript" src="${basePath}/component/My97DatePicker/WdatePicker.js"></script>
<script type="text/javascript" charset="UTF-8">
	//提现并判断	
	//关闭
	function doClose() {
		window.parent.closeBox();
	}
	
	function isNull(data) {
		return (data == "" || data == 0 || data == null);
	}
	function doSubmit() {
		var result = true;
	 	if (!doCheck("applyAmount", !isNull($("#applyAmount").val()), 'Amount cannot be empty')) {
			result = false;
		}else{
			//判断提现金额不能大于账户余额
			var num1 = $("#applyAmount").val();
			var num2 = $("#accountBalance").val();
		 	if (!doCheck("applyAmount", parseInt(num1) <= parseInt(num2),
					'The cash withdrawn cannot be larger than the current account balance')) {
				result = false;
			} 
		}
		 if (result) {
			button_off("okBtn");
			$("#cashWithdrawnForm").submit();
	}
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
	<form action="outletInfo.do?method=OutletCashWithdrawn"
		id="cashWithdrawnForm" name="cashWithdrawnForm" method="POST">
		<input type="hidden" name="aoCode"
			value="${outletWithdrawnForm.agencyCode}">
		<!-- 实体类和jsp的名字不同，这样写获取值 -->
		<input type="hidden" name="aoName"
			value="${outletWithdrawnForm.agencyName}"> <input
			type="hidden" name="accNo" value="${outletWithdrawnForm1.accNo}">
	
	<div class="pop-body">
		<table width="100%" border="0" cellspacing="0" cellpadding="0">
			<tr>
				<td class="td" align="right" width="30%">Outlet Code：</td>
				<td class="td" align="left" width="30%">
				<input type="text" name="agencyCode" class="text-big-noedit" id="agencyCode" 
				readonly="readonly" value="${outletWithdrawnForm.agencyCode }"/></td>
				<td><span id="agencyCodeTip" class="tip_init"></span></td>
	    	</tr>
	    	
			<tr>
				<td class="td" align="right">Outlet Name：</td>
				<td class="td" align="left"><input type="text" name="agencyName" class="text-big-noedit" id="agencyName" 
				readonly="readonly"	value="${outletWithdrawnForm.agencyName }" /></td>
				<td><span id="agencyNameTip" class="tip_init"></span></td>
			</tr>
			<tr>
				<td class="td" align="right">Account Balance：</td>
				<td class="td" align="left"><input type="text" name="accountBalance" class="text-big-noedit" id="accountBalance" 
				readonly="readonly" value="${outletWithdrawnForm1.accountBalance }" /></td>
				<td><span id="accountBalanceTip" class="tip_init"></span></td>
			</tr>
			
			<tr>
				<td class="td" align="right">Cash Withdrawn：</td>
				<td class="td" align="left"><input type="text" name="applyAmount" class="text-big" id="applyAmount"
					oninput="filterInput(this)"/></td>
				<td><span id="applyAmountTip" class="tip_init">*</span></td>
			</tr>
		</table>
	</div>
	
        <div class="pop-footer">
            <span class="left">
                <input id="okBtn" type="button" onclick="doSubmit();" class="button-normal" value="Submit"></input>
            </span>
            <span class="right">
                <input id="cancelButton" type="button" value="Cancel" class="button-normal" onclick="doClose();"></input>
            </span>
        </div>
</form>
</body>
</html>