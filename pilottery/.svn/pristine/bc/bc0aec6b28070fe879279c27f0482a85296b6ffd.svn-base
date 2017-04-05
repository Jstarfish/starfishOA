<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/views/common/taglibs.jsp"%>
<html>
<head>

<title>List of Repayment Records</title>

<%@ include file="/views/common/meta.jsp" %>
<link rel="stylesheet" type="text/css" href="${basePath}/css/style.css"/>
<link rel="stylesheet" href="${basePath}/component/messageBox/myJsBox.css" type="text/css"/>
<link rel="stylesheet" type="text/css" href="${basePath}/css/validate.css"/>

<script type="text/javascript" src="${basePath}/js/myJs.js"></script>
<script type="text/javascript" src="${basePath}/component/messageBox/myJsBox.js"></script>
<script type="text/javascript" src="${basePath}/component/My97DatePicker/WdatePicker.js"></script>
<script type="text/javascript" src="${basePath}/js/jquery/jquery-1.9.1.js"></script>
<script type="text/javascript" src="${basePath}/js/regexEnum.js"></script>

<script type="text/javascript" charset="UTF-8">
//验证非空
function isNotEmptyString(value) {
    return value != '' ? true : false;
}

function updateQuery() {
	$("#repaymentQueryForm").submit();
}

function filterInput(obj) {
	var cursor = obj.selectionStart;
	obj.value = obj.value.replace(/[^\d]/g,'');
	obj.selectionStart = cursor;
	obj.selectionEnd = cursor;
}

/*
function clearValues() {
	$("#marketManagerCode").val('');
	$("#marketManagerName").val('');
	$("#repaymentDate").val('');
	$('#marketManagerCodeTip').text('');
}

$(document).ready(function() {
    $("#marketManagerCode").keydown(function(event) {
        if (event.keyCode == 13) {
            updateQuery();
        }
    });
    
    $("#marketManagerName").keydown(function(event) {
        if (event.keyCode == 13) {
            updateQuery();
        }
    });
});
*/
</script>

</head>
<body>
    <!-- 顶部标题块 -->
    <div id="title">Repayment Records</div>
    
    <!-- 查询条件块 -->
    <div class="queryDiv">
        <form action="repayment.do?method=listRepayment" method="POST" id="repaymentQueryForm">
            <div class="left">
	   			<span>Market Manager Code: </span>
	   			<span><input id="marketManagerCode" name="marketManagerCode" value="${repaymentQueryForm.marketManagerCode}" class="text-normal" oninput="filterInput(this);" onpropertychange="filterInput(this);" maxlength="40"/></span>
	   			<span>Market Manager Name: </span>
	   			<span><input id="marketManagerName" name="marketManagerName" value="${repaymentQueryForm.marketManagerName}" class="text-normal" maxlength="40"/></span>
	   			<span>Repayment Date:</span>
	   			<span><input id="repaymentDate" name="repaymentDate" value="${repaymentQueryForm.repaymentDate}" class="Wdate text-normal" onfocus="WdatePicker({dateFmt:'yyyy-MM-dd',readOnly:true,isShowClear:true,isShowToday:true})"/></span>
	   			<input type="button" value="Query" onclick="updateQuery();" class="button-normal"></input>
	   			<!-- <input type="button" value="Clear" onclick="clearValues();" class="button-normal"></input>-->
            </div>
            <div class="right">
                <table width="260" border="0" cellspacing="0" cellpadding="0">
                    <tr style="height:50px;line-height:50px">
                        <td align="right">
                            <input type="button" value="Process Repayment" onclick="showBox('repayment.do?method=addRepaymentInit', 'Process Repayment', 360, 650);" class="button-normal"></input>
                        </td>
                    </tr>
                </table>
            </div>
        </form>
    </div>
    
    <!-- 列表表头块 -->
    <div id="headDiv">
        <table width="100%" border="0" cellpadding="0" cellspacing="0">
            <tr>
                <td>
                    <table class="datatable">
                        <tr class="headRow">
                        	<td style="width:10px;">&nbsp;</td>
                            <td style="width:11%">Repayment Date</td>
                            <td width="1%">|</td>
                            <td style="width:11%">Market Manager Code</td>
                            <td width="1%">|</td>
                            <td style="width:11%">Market Manager Name</td>
                            <td width="1%">|</td>
                            <td style="width:11%">Before Repayment</td>
                            <td width="1%">|</td>
                            <td style="width:11%">Repay Amount</td>
                            <td width="1%">|</td>
                            <td style="width:11%">After Repayment</td>
                            <td width="1%">|</td>
                            <td style="width:11%">Remark</td>
                            <td width="1%">|</td>
                            <td style="width:*%">Operation</td>
                        </tr>
                    </table>
                 </td>
                 <!-- 表头和下方数据对齐 -->
                 <td style="width:17px;background:#2aa1d9"></td>
             </tr>
        </table>
    </div>
    
    <!-- 列表内容块 -->
    <div id="bodyDiv">
        <table class="datatable">
        	<c:forEach var="record" items="${repaymentList}" varStatus="status">
	        	<tr class="dataRow">
	        		<td style="width:10px;">&nbsp;</td>
	                <td style="width:11%" title="${record.repaymentDate}">${record.repaymentDate}</td>
	                <td width="1%">&nbsp;</td>
	                <td style="width:11%" title="${record.marketManagerCode}">${record.marketManagerCode}</td>
	                <td width="1%">&nbsp;</td>
	                <td style="width:11%" title="${record.marketManagerName}">${record.marketManagerName}</td>
	                <td width="1%">&nbsp;</td>
	                <td style="width:11%;text-align:right" title='<fmt:formatNumber value="${record.balanceBeforeRepayment}"/>'><fmt:formatNumber value="${record.balanceBeforeRepayment}"/></td>
	                <td width="1%">&nbsp;</td>
	                <td style="width:11%;text-align:right" title='<fmt:formatNumber value="${record.repaymentAmount}"/>'><fmt:formatNumber value="${record.repaymentAmount}"/></td>
	                <td width="1%">&nbsp;</td>
	                <td style="width:11%;text-align:right" title='<fmt:formatNumber value="${record.balanceAfterRepayment}"/>'><fmt:formatNumber value="${record.balanceAfterRepayment}"/></td>
	                <td width="1%">&nbsp;</td>
	                <td style="width:11%;text-align:right" title='${record.remark}'>${record.remark}</td>
	                <td width="1%">&nbsp;</td>
	                <td style="width:*%">
	                	<span><a href="#" onclick="showPage('repayment.do?method=printRepaymentCertificate&repaymentDate=${record.repaymentDate}&marketManagerCode=${record.marketManagerCode}&marketManagerName=${record.marketManagerName}&balanceBeforeRepayment=${record.balanceBeforeRepayment}&repaymentAmount=${record.repaymentAmount}&balanceAfterRepayment=${record.balanceAfterRepayment}&remark=${record.remark}','Print Repayment Certificate');">Print</a></span>
	                </td>
	            </tr>
        	</c:forEach>
        </table>
        ${pageStr}
    </div>
</body>
</html>