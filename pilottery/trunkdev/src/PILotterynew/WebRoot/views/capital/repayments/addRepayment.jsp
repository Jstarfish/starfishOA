<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/views/common/taglibs.jsp"%>
<html>
<head>

<title>Process Repayment</title>

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

        if (!checkFormComm('newRepaymentForm')) {
			result = false;
			return false;
		}
        
        if (!doCheck("marketManagerCode", isNotEmptyString($("#marketManagerCode").val()), "Select a market manager")) {
            result = false;
        }
        
        if (!doCheck("accountNo", isNotEmptyString($("#accountNo").val()), "Can't be empty")) {
            result = false;
        }
        
        if (!doCheck("currentDebt", isNotEmptyString($("#currentDebt").val()), "Can't be empty")) {
            result = false;
        }
        
        if (!doCheck("repaymentAmount", isNotEmptyString($("#repaymentAmount").val()), "Can't be empty")) {
            result = false;
        }
        
        if (isNotEmptyString($("#repaymentAmount").val()) && !doCheck("repaymentAmount", /^(-)?[1-9][0-9]{0,9}$/, "Wrong format")) {
            result = false;
        }

        if($("#repaymentAmount").val()<0 && !$.trim($("#remark").val()) && result==true){
        	//showError('Remark Cannot Be Empty');
        	$('#remarkTip').text('Remark Cannot Be Empty');
        	$('#remarkTip').attr('class','tip_error');
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
                	<td align="right" width="30%">Market Manager：</td>
                	<td align="left" width="30%">
                		<select id="marketManagerCode" name="marketManagerCode" class="select-big" onchange="updateValues(this);">
                    		<option value="" accountNo="" accountBalance="">Please select...</option>
                    		<c:forEach var="data" items="${marketManagerAccountList}" varStatus="status">
                    			<option value="${data.marketAdmin}" accountNo="${data.accountNo}" accountBalance="${data.accountBalance}">${data.adminRealName}</option>
                    		</c:forEach>
                    	</select>
                	</td>
                	<td><span id="marketManagerCodeTip" class="tip_init">*</span></td>
                </tr>
                <tr>
                	<td align="right" width="30%">Account No.：</td>
                	<td align="left" width="30%">
                		<input id="accountNo" name="accountNo" class="text-big-noedit" readonly="readonly"/>
                	</td>
                	<td><span id="accountNoTip" class="tip_init">*</span></td>
                </tr>
                <tr>
                	<td align="right" width="30%">Current Debt：</td>
                	<td align="left" width="30%">
                		<input id="currentDebt" name="currentDebt" class="text-big-noedit" readonly="readonly"/>
                	</td>
                	<td><span id="currentDebtTip" class="tip_init">*</span></td>
                </tr>
                <tr>
                	<td align="right" width="30%">Repayment Amount：</td>
                	<td align="left" width="30%">
                		<input id="repaymentAmount" name="repaymentAmount" class="text-big"/>
                	</td>
                	<td><span id="repaymentAmountTip" class="tip_init">*</span></td>
				</tr>
				<tr>
                	<td align="right" width="30%">Remark：</td>
                	<td align="left" width="30%">
                		<textarea id="remark" name="remark" class="text-big" style="height:64px;width: 198px;" maxLength="500" isCheckSpecialChar="true" cMaxByteLength="500"/></textarea>
                	</td>
                	<td><span id="remarkTip" class="tip_init">1~500 characters</span></td>
				</tr>
            </table>
        </div>
        
        <div class="pop-footer">
            <span class="left">
                <input id="okButton" type="button" value="Submit" class="button-normal"></input>
            </span>
            <span class="right">
                <input id="cancelButton" type="button" value="Cancel" class="button-normal" onclick="doClose();"></input>
            </span>
        </div>
        
    </form>
</body>
</html>