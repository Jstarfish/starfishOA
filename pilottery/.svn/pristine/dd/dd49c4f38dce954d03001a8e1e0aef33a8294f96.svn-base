<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/views/common/taglibs.jsp"%>
<html>
<head>
<title>提现申请</title>
<link rel="stylesheet" type="text/css" href="${basePath}/css/style.css" />
<link rel="stylesheet" type="text/css" href="${basePath}/css/pop-up.css" />
<link rel="stylesheet" type="text/css" href="${basePath}/css/validate.css" />
<link rel="stylesheet" href="${basePath}/component/messageBox/myJsBox.css" type="text/css" />
<script type="text/javascript" src="${basePath}/component/messageBox/myJsBox_zh.js"></script>
<script type="text/javascript" src="${basePath}/js/myJs.js"></script>
<script type="text/javascript" src="${basePath}/js/jquery/jquery-1.9.1.js"></script>
<script type="text/javascript" charset="UTF-8">
function doClose() {
    window.parent.closeBox();
}

//根据选择的部门名称更新部门编码以及当前欠款
/* function updateValues(obj) {
	var orgCode = $(obj).find("option:selected").attr('orgCode');
	var accountBalance = $(obj).find("option:selected").attr('accountBalance');
	$("#orgCode").val(orgCode);
	$("#accountBalance").val(accountBalance);
} */

function isNull(data) {
	return (data == "" || data == 0 || data == null);
}
//提现并判断
function doSubmit() {
	var result = true;

 	if (!doCheck("orgName", !isNull($("#orgName").val()),	'Agent cannot be empty')) {
		result = false;
	} 
	
 	if (!doCheck("applyAmount", !isNull($("#applyAmount").val()), '提现金额不能为空')) {
		result = false;
	}else{
		//判断提现金额不能大于账户余额
		var num1 = $("#applyAmount").val();
		var num2 = $("#accountBalance").val();
	 	if (!doCheck("applyAmount", parseInt(num1) <= parseInt(num2),
				'提现金额不能大于当前账户余额')) {
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
		obj.value = obj.value.replace(/[^\d]/g, '');
		obj.selectionStart = cursor;
		obj.selectionEnd = cursor;
	}
</script>
</head>
<body>
    <form action="orgsWithdrawnRecords.do?method=addWithdrawn" id="cashWithdrawnForm" name="cashWithdrawnForm" method="POST">
    <input type="hidden" name="applyStatus" value="1">
        <div class="pop-body">
            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                <tr>
                    <td align="right" width="25%">部门名称：</td>
                    <td align="left" width="30%">
                    <%-- 	<select id="orgName" name="orgName" class="select-big" onchange="updateValues(this);">
                    		 <option value="" accountNo="" accountBalance="">Please select...</option> 
                    		<c:forEach var="data" items="${institutionAccountList}" varStatus="status">
                    			<option value="${data.orgName}" orgCode="${data.orgCode}" accountBalance="${data.accountBalance}">${data.orgName}</option>
                    		</c:forEach>
                    	</select> --%>
                    	
                    	<input id="orgName" name="orgName" class="text-big-noedit" value="${institutionAccountList.orgName}" readonly="readonly"/>
                    </td>
                    <td><span id="orgNameTip" class="tip_init"></span></td>
                </tr>
                
                <tr>
                    <td align="right">部门编码：</td>
                    <td align="left"><input id="orgCode" name="orgCode" value="${institutionAccountList.orgCode }" class="text-big-noedit" readonly="readonly"/>
                    </td>
                    <td> <span id="orgCodeTip" class="tip_init"></span></td>
                </tr>
                
                <tr>
                    <td align="right">账户余额：</td>
                    <td align="left" ><input id="accountBalance" name="accountBalance" value="${institutionAccountList.accountBalance }" class="text-big-noedit" readonly="readonly"/>
                    </td>
                    <td><span id="accountBalanceTip" class="tip_init"></span></td>
                </tr>
                
                <tr>
                    <td align="right">提现金额：</td>
                    <td align="left" ><input id="applyAmount" name="applyAmount" class="text-big"
                    	oninput="filterInput(this)"/>
                    </td>
                    <td><span id="applyAmountTip" class="tip_init">*</span></td>
                </tr>
            </table>
        </div>
        
        <div class="pop-footer">
            <span class="left">
                <input id="okBtn" type="button" onclick="doSubmit();" class="button-normal" value="提交"></input>
            </span>
            <span class="right">
                <input id="cancelButton" type="button" value="取消" class="button-normal" onclick="doClose();"></input>
            </span>
        </div>
    </form>
</body>
</html>