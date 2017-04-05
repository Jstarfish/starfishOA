<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/views/common/taglibs.jsp"%>
<html>
<head>

<title>Stock Transfers Approval</title>

<%@ include file="/views/common/meta.jsp" %>
<link rel="stylesheet" type="text/css" href="${basePath}/css/style.css" />
<link rel="stylesheet" href="${basePath}/component/messageBox/myJsBox.css" type="text/css"/>
<script type="text/javascript" src="${basePath}/component/messageBox/myJsBox.js"></script>
<script type="text/javascript" src="${basePath}/component/My97DatePicker/WdatePicker.js"></script>
<script type="text/javascript" src="${basePath}/js/jquery/jquery-1.9.1.js"></script>

<script type="text/javascript" charset="UTF-8">
function showDetails(stbNo){
	showBox('transfer.do?method=stockTransferDetail&stbNo=' + stbNo,'Stock Transfer Details',550,800);
}
function approve(stbNo){
	showBox('transfer.do?method=initAproveStockTransfer&stbNo=' + stbNo,'Stock Transfer Approve',400,800);
}
</script>

</head>
<body>
    <!-- 调拨单管理 -->
    <div id="title">List Of Stock Transfers</div>
    
    <div class="queryDiv">
        <form action="transfer.do?method=listTransferForInquery" id="queryForm" method="post">
            <div class="left">
                <span>Stock Transfer: <input id="stockTransferNo" name="stockTransferNo" value="${form.stockTransferNo}" maxlength="10" class="text-normal"/></span>
                <span>Date:
                    <input id="applyDate" name="applyDate" value="${form.applyDate}" class="Wdate text-normal" onfocus="WdatePicker({lang:'en',dateFmt:'yyyy-MM-dd',readOnly:true})"/>
                </span>
                <input type="submit" value="Query" class="button-normal"></input>
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
                            <td style="width:6%">Stock Transfer</td>
                            <td width="1%">|</td>
                            <td style="width:9%">Date</td>
                            <td width="1%">|</td>
                            <td style="width:8%">Quantity (tickets)</td>
                            <td width="1%">|</td>
                            <td style="width:8%">Amount (riels)</td>
                            <td width="1%">|</td>
                            <td style="width:9%">Submitted By</td>
                            <td width="1%">|</td>
                            <td style="width:9%">Receiving Unit</td>
                            <td width="1%">|</td>
                            <td style="width:9%">Delivering Unit</td>
                            <td width="1%">|</td>
                            <td style="width:9%">Date of Receipt</td>
                            <td width="1%">|</td>
                            <td style="width:9%">Date of Delivery</td>
                            <td width="1%">|</td>
                            <td style="width:5%">Status</td>
                            <td width="1%">|</td>
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
            <tr class="dataRow">
            	<td style="width:10px;">&nbsp;</td>
                <td style="width:6%">${obj.stbNo}</td>
                <td width="1%">&nbsp;</td>
                <td style="width:9%"><fmt:formatDate value="${obj.applyDate}" pattern="yyyy-MM-dd HH:mm:ss"/></td>
                <td width="1%">&nbsp;</td>
                <td style="width:8%"><fmt:formatNumber value="${obj.tickets}" /></td>
                <td width="1%">&nbsp;</td>
                <td style="width:8%;text-align: right;"><fmt:formatNumber value="${obj.amount}" /></td>
                <td width="1%">&nbsp;</td>
                <td style="width:9%" title="${obj.applyName}">${obj.applyName}</td>
                <td width="1%">&nbsp;</td>
                <td style="width:9%" title="${obj.receiveOrgName}">${obj.receiveOrgName}</td>
                <td width="1%">&nbsp;</td>
                <td style="width:9%" title="${obj.sendOrgName}">${obj.sendOrgName}</td>
                <td width="1%">&nbsp;</td>
                <td style="width:9%"><fmt:formatDate value="${obj.receiveDate}" pattern="yyyy-MM-dd HH:mm:ss"/></td>
                <td width="1%">&nbsp;</td>
                <td style="width:9%"><fmt:formatDate value="${obj.sendDate}" pattern="yyyy-MM-dd HH:mm:ss"/></td>
                <td width="1%">&nbsp;</td>
                <td style="width:5%">${obj.statusValue}</td>
                <td width="1%">&nbsp;</td>
                <td style="width:*%">
                    <span><a href="#" onclick="showDetails('${obj.stbNo}')">Details</a></span>&nbsp;|
                    <span>
                    	<c:if test="${obj.status == 1 && sessionScope.isCollector != 1}">
                    		<a href="#" onclick="approve('${obj.stbNo}')">Approve</a>
                    	</c:if>
                    	<c:if test="${obj.status != 1 || sessionScope.isCollector == 1}">
                    		Approve
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