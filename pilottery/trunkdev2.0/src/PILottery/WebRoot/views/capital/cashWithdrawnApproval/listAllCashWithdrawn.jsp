<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/views/common/taglibs.jsp"%>
<html>
<head>

<title>List of Cash Withdrawn</title>

<%@ include file="/views/common/meta.jsp" %>
<link rel="stylesheet" type="text/css" href="${basePath}/css/style.css" />
<link rel="stylesheet" href="${basePath}/component/messageBox/myJsBox.css" type="text/css"/>
<script type="text/javascript" src="${basePath}/component/messageBox/myJsBox.js"></script>
<script type="text/javascript" src="${basePath}/component/My97DatePicker/WdatePicker.js"></script>
<script type="text/javascript" src="${basePath}/js/jquery/jquery-1.9.1.js"></script>

<script type="text/javascript" charset="UTF-8">

function approve(fundNo){
	//window.location.href="cashWithdrawn.do?method=initApproveWithdrawn&fundNo="+fundNo;
	showBoxRefresh('cashWithdrawn.do?method=initApproveWithdrawn&fundNo=' + fundNo,'Cash Withdrawn Approve',260,400);
}

function confirm(fundNo) {
	showBox('cashWithdrawn.do?method=initConfirm&fundNo=' + fundNo,'Confirm Cash Withdrawn',260,500);
}

function print(obj){
	showPage('cashWithdrawn.do?method=withdrawnCertificate&fundNo=' + obj,'Print');
} 

function doCancel(url) {
	$.ajax({
		url : url,
		dataType : "",
		success : function(result){
            if(result != '' && result !=null){
	            closeDialog();
            	showError(decodeURI(result));
	        }else{
            	window.location.reload();
	        }
		}
	});		
};
</script>

</head>
<body>
    <!-- 提现申请 -->
     <div id="title">Cash Withdrawn Approval</div>
    
    <div class="queryDiv">
        <form action="cashWithdrawn.do?method=listCashWithdrawn" id="newCashWithdrawnForm" method="post">
            <div class="left">
                <!-- <span>Type: <select name="accountType" class="select-big">
                <option value="">--All--</option>
                <option value="1">Department</option>
                <option value="2">Outlet</option>
                </select></span> -->
                <span>Name: <input id="aoName" name="aoName" value="${newCashWithdrawnForm.aoName }" class="text-normal" maxlength="10"/></span>
                <span>Date:
                    <input id="applyDate" name="applyDate" value="${newCashWithdrawnForm.applyDate }" class="Wdate text-normal" onfocus="WdatePicker({lang:'en',dateFmt:'yyyy-MM-dd',readOnly:true})"/>
                </span>
                <input type="submit" value="Query" class="button-normal"></input>
            </div>
            
            <div class="right">
				<table width="260" border="0" cellspacing="0" cellpadding="0">
					<tr style="height: 50px; line-height: 50px">
					</tr>
				</table>
			</div>
			
        </form>
    </div>
    <div id="headDiv">
        <table width="100%" border="0" cellpadding="0" cellspacing="0">
            <tr>
                <td>
                    <table class="datatable">
                        <tr class="headRow">
                        	<td style="width:10px;">&nbsp;</td>
                            <td style="width:10%">Record Code</td>
                            <th width="1%">|</th>
                            <td style="width:8%">Code</td>
                            <th width="1%">|</th>
                            <td style="width:10%">Name</td>
                            <th width="1%">|</th>
                            <td style="width:8%">Type</td>
                            <th width="1%">|</th>
                            <td style="width:10%">Account Balance(riels)</td>
                            <th width="1%">|</th>
                            <td style="width:10%">Cash Withdrawn(riels)</td>
                            <th width="1%">|</th>
                            <td style="width:10%">Date of Withdrawal</td>
                            <th width="1%">|</th>
                            <td style="width:8%">Status</td>
                            <th width="1%">|</th>
                            <td style="width:*%">Operation</td>
                        </tr>
                    </table>
                 </td>
                 <td style="width:17px;background:#2aa1d9"></td>
             </tr>
        </table>
    </div>
    <div id="bodyDiv">
        <table class="datatable">
        <c:forEach var="obj" items="${pageDataList}" varStatus="status" >
        <input type="hidden" name="accountType" id="accountType" value="${obj.accountType}">
            <tr class="dataRow">
            	<td style="width:10px;">&nbsp;</td>
                <td style="width:10%">${obj.fundNo}</td>
                <td width="1%">&nbsp;</td>
                <td style="width:8%">${obj.aoCode}</td>
                <td width="1%">&nbsp;</td>
                <td style="width:10%" title="${obj.aoName}">${obj.aoName}</td>
                <td width="1%">&nbsp;</td>
                <td style="width:8%"><c:forEach var="item" items="${approveAccountType}"><c:if test="${!empty obj }"><c:if test="${obj.accountType==item.key }">${item.value}</c:if></c:if></c:forEach></td>
                <td width="1%">&nbsp;</td>
                <td style="width:10%;text-align:right"><fmt:formatNumber value="${obj.accountBalance}" /></td>
                <td width="1%">&nbsp;</td>
                <td style="width:10%;text-align:right"><fmt:formatNumber value="${obj.applyAmount}" /></td>
                <td width="1%">&nbsp;</td>
                <td style="width:10%"><fmt:formatDate value="${obj.applyDate}" pattern="yyyy-MM-dd HH:mm:ss"/></td>
                <td width="1%">&nbsp;</td>
                <td style="width:8%"><c:forEach var="item" items="${cashWithdrawnStatus}"><c:if test="${!empty obj }"><c:if test="${obj.applyStatus==item.key }">${item.value}</c:if></c:if></c:forEach></td>
                <td width="1%">&nbsp;</td>
                <td style="width:*%">
                    <span>
                   		<c:if test="${obj.applyStatus == 1}">
                    		<a href="#" onclick="approve('${obj.fundNo}')">Approval</a>
                    	</c:if>
                    	<c:if test="${obj.applyStatus != 1 }">
                    		Approval
                    	</c:if>
                    </span>
                     |
                    <span>
                    	<c:if test="${obj.applyStatus == 3 && obj.accountType == 1}">
                    		<a href="#" onclick="confirm('${obj.fundNo}')">Confirm</a>
                    	</c:if>
                    	<c:if test="${obj.applyStatus != 3 || obj.accountType == 2}">
                    		Confirm
                    	</c:if>
                    </span>
                    |
                    <span>
                    	<c:if test="${obj.applyStatus == 3  || obj.applyStatus == 5 || obj.applyStatus == 6}">
                    		<a href="#" onclick="print('${obj.fundNo}')">Print</a>
                    	</c:if>
                    	<c:if test="${obj.applyStatus != 3 && obj.applyStatus != 5 && obj.applyStatus != 6}">
                    		Print
                    	</c:if>
                    </span>
                </td>
            </tr>
          </c:forEach>
        </table>
        ${pageStr} 
    </div>
</body> 
</html>