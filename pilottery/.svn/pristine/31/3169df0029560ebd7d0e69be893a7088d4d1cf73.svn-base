<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/views/common/taglibs.jsp"%>
<html>
<head>

<title>Purchase Order Inquiry</title>

<%@ include file="/views/common/meta.jsp" %>
<link rel="stylesheet" type="text/css" href="${basePath}/css/style.css" />
<link rel="stylesheet" href="${basePath}/component/messageBox/myJsBox.css" type="text/css"/>
<script type="text/javascript" src="${basePath}/component/messageBox/myJsBox.js"></script>
<script type="text/javascript" src="${basePath}/component/My97DatePicker/WdatePicker.js"></script>
<script type="text/javascript" src="${basePath}/js/jquery/jquery-1.9.1.js"></script>

<script type="text/javascript" charset="UTF-8">
function showDetails(orderNo){
	showBox('order.do?method=purchaseDetail&purchaseOrderNo=' + orderNo,'Purchase Order Details',550,800);
}
</script>

</head>
<body>
    <!-- 订单管理 -->
    <div id="title">List Of Purchase Orders</div>
    
    <div class="queryDiv">
        <form action="order.do?method=listOrderForInquery" id="queryForm" method="post">
            <div class="left">
                <span>Purchase Order: <input id="purchaseOrderNo" name="purchaseOrderNo" value="${form.purchaseOrderNo}" class="text-normal" maxlength="10"/></span>
                <span>Date:
                    <input id="applyDate" name="applyDate" value="${form.applyDate }" class="Wdate text-normal" onfocus="WdatePicker({dateFmt:'yyyy-MM-dd',readOnly:true})"/>
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
                            <td style="width:10%">Purchase Order</td>
                            <th width="1%">|</th>
                            <td style="width:10%">Date</td>
                            <th width="1%">|</th>
                            <td style="width:10%">Quantity (tickets)</td>
                            <th width="1%">|</th>
                            <td style="width:10%">Total Amount (riels)</td>
                            <th width="1%">|</th>
                            <td style="width:20%">Submitted By</td>
                            <th width="1%">|</th>
                            <td style="width:10%">Purchasing Unit</td>
                            <th width="1%">|</th>
                            <td style="width:10%">Status</td>
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
            <tr class="dataRow">
            	<td style="width:10px;">&nbsp;</td>
                <td style="width:10%">${obj.orderNo}</td>
                <td width="1%">&nbsp;</td>
                <td style="width:10%"><fmt:formatDate value="${obj.applyDate}" pattern="yyyy-MM-dd HH:mm:ss"/></td>
                <td width="1%">&nbsp;</td>
                <td style="width:10%"><fmt:formatNumber value="${obj.applyTickets}" /></td>
                <td width="1%">&nbsp;</td>
                <td style="width:10%;text-align: right"><fmt:formatNumber value="${obj.applyAmount}" /></td>
                <td width="1%">&nbsp;</td>
                <td style="width:20%">${obj.applyName}</td>
                <td width="1%">&nbsp;</td>
                <td style="width:10%">${obj.applyAgency}</td>
                <td width="1%">&nbsp;</td>
                <td style="width:10%;">${obj.statusValue}</td>
                <td width="1%">&nbsp;</td>
                <td style="width:*%">
                    <span><a href="#" onclick="showDetails('${obj.orderNo}')">Details</a></span>
                </td>
            </tr>
          </c:forEach>
        </table>
        ${pageStr} 
    </div>
</body>
</html>