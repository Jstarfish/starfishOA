<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/views/common/taglibs.jsp"%>
<html>
<head>

<title>还款操作</title>

<%@ include file="/views/common/meta.jsp" %>
<link rel="stylesheet" type="text/css" href="${basePath}/css/style.css"/>
<link rel="stylesheet" type="text/css" href="${basePath}/css/pop-up.css"/>
<link rel="stylesheet" href="${basePath}/component/messageBox/myJsBox.css" type="text/css"/>
<link rel="stylesheet" type="text/css" href="${basePath}/css/validate.css"/>

<script type="text/javascript" src="${basePath}/js/myJs.js"></script>
<script type="text/javascript" src="${basePath}/component/messageBox/myJsBox.js"></script>
<script type="text/javascript" src="${basePath}/component/My97DatePicker/WdatePicker.js"></script>
<script type="text/javascript" src="${basePath}/js/jquery/jquery-1.9.1.js"></script>
<script type="text/javascript" src="${basePath}/js/regexEnum.js"></script>

<script type="text/javascript" charset="UTF-8">
function doClose() {
    window.parent.closeBox();
}

//验证非空
function isNotEmptyString(value) {
    return value != '' ? true : false;
}

$(document).ready(function(){
    $("#okButton").bind("click", function(){
        var result = true;
        
        if (!doCheck("marketManagerCode", isNotEmptyString($("#marketManagerCode").val()), "请选择市场管理员")) {
            result = false;
        }
        
        if (!doCheck("accountNo", isNotEmptyString($("#accountNo").val()), "不可为空")) {
            result = false;
        }
        
        if (!doCheck("currentDebt", isNotEmptyString($("#currentDebt").val()), "不可为空")) {
            result = false;
        }
        
        if (!doCheck("repaymentAmount", isNotEmptyString($("#repaymentAmount").val()), "不可为空")) {
            result = false;
        }
        
        if (isNotEmptyString($("#repaymentAmount").val()) && !doCheck("repaymentAmount", /^[1-9][0-9]{0,9}$/, "金额格式错误")) {
            result = false;
        }
        
        if (result) {
        	button_off("okButton");
            $("#newRepaymentForm").submit();
        }
    });
});

//根据选择的市场管理员更新账户编码以及当前欠款
function updateValues(obj) {
	var accountNo = $(obj).find("option:selected").attr('accountNo');
	var accountBalance = $(obj).find("option:selected").attr('accountBalance');
	$("#accountNo").val(accountNo);
	$("#currentDebt").val(accountBalance);
}
</script>

</head>
<body>
    <form action="repayment.do?method=addRepayment" id="newRepaymentForm" method="POST">
    
        <div class="pop-body">
            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                <tr>
                	<td align="right" width="30%">市场管理员：</td>
                	<td align="left" width="30%">
                		<select id="marketManagerCode" name="marketManagerCode" class="select-big" onchange="updateValues(this);">
                    		<option value="" accountNo="" accountBalance="">请选择...</option>
                    		<c:forEach var="data" items="${marketManagerAccountList}" varStatus="status">
                    			<option value="${data.marketAdmin}" accountNo="${data.accountNo}" accountBalance="${data.accountBalance}">${data.adminRealName}</option>
                    		</c:forEach>
                    	</select>
                	</td>
                	<td><span id="marketManagerCodeTip" class="tip_init">*</span></td>
                </tr>
                <tr>
                	<td align="right" width="30%">账户编码：</td>
                	<td align="left" width="30%">
                		<input id="accountNo" name="accountNo" class="text-big-noedit" readonly="readonly"/>
                	</td>
                	<td><span id="accountNoTip" class="tip_init">*</span></td>
                </tr>
                <tr>
                	<td align="right" width="30%">当前欠款：</td>
                	<td align="left" width="30%">
                		<input id="currentDebt" name="currentDebt" class="text-big-noedit" readonly="readonly"/>
                	</td>
                	<td><span id="currentDebtTip" class="tip_init">*</span></td>
                </tr>
                <tr>
                	<td align="right" width="30%">还款金额：</td>
                	<td align="left" width="30%">
                		<input id="repaymentAmount" name="repaymentAmount" class="text-big"/>
                	</td>
                	<td><span id="repaymentAmountTip" class="tip_init">*</span></td>
				</tr>
            </table>
        </div>
        
        <div class="pop-footer">
            <span class="left">
                <input id="okButton" type="button" value="确定" class="button-normal"></input>
            </span>
            <span class="right">
                <input id="cancelButton" type="button" value="取消" class="button-normal" onclick="doClose();"></input>
            </span>
        </div>
        
    </form>
</body>
</html>