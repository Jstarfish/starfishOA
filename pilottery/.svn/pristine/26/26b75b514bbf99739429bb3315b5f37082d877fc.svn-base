<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/views/common/taglibs.jsp"%>
<html>
<head>

<title>List of Stock Transfers</title>

<%@ include file="/views/common/meta.jsp" %>
<link rel="stylesheet" type="text/css" href="${basePath}/css/style.css" />
<link rel="stylesheet" href="${basePath}/component/messageBox/myJsBox.css" type="text/css"/>
<script type="text/javascript" src="${basePath}/component/messageBox/myJsBox.js"></script>
<script type="text/javascript" src="${basePath}/component/My97DatePicker/WdatePicker.js"></script>
<script type="text/javascript" src="${basePath}/js/jquery/jquery-1.9.1.js"></script>

<script type="text/javascript" charset="UTF-8">

function newReturnDelivery(){
	showBox('returnDelivery.do?method=initReturnDeliveryAdd','New Return Delivery',650,800);
}

function showDetails(stbNo){
	showBox('returnDelivery.do?method=returnDeliveryDetail&queryNo=' + stbNo,'Return Delivery Details',650,800);
}

function editOrder(stbNo){
	showBox('returnDelivery.do?method=initReturnDeliveryEdit&queryNo=' + stbNo,'Edit Return Delivery',650,800);
}

function approve(stbNo){
	showBox('returnDelivery.do?method=initAproveReturnDelivery&queryNo=' + stbNo,'Return Delivery Approve',650,800);
}

function cancelOrder(stbNo,status) {
	if(status != 1){
		showError('Order Cannot Be Cancelled');
		return false;
	}
	
	var url = "returnDelivery.do?method=cancelReturnDelivery&queryNo=" + stbNo;
	showDialog("doCancel('"+url+"')",'Cancel','Are you sure you want to cancel<br/> Return Delivery : '+stbNo);
}
function doCancel(url) {
	$.ajax({
		url : url,
		dataType : "",
		async : false,
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
    <!-- 调拨单管理 -->
    <div id="title">Return Delivery</div>
    
    <div class="queryDiv">
        <form action="returnDelivery.do?method=listReturnDeliveries" id="queryForm" method="post">
            <div class="left">
                <span>Return Code: <input id="queryNo" name="queryNo" value="${form.queryNo}" maxlength="10" class="text-normal"/></span>
                <span>Date:
                    <input id="queryDate" name="queryDate" value="${form.queryDate}" class="Wdate text-normal" onfocus="WdatePicker({dateFmt:'yyyy-MM-dd',readOnly:true})"/>
                </span>
                <input type="submit" value="Query" class="button-normal"></input>
            </div>
            <div class="right">
                <table width="260" border="0" cellspacing="0" cellpadding="0">
                    <tr style="height:50px;line-height:50px">
                        <td align="right">
                            <input type="button" value="Submit Return Delivery" onclick="newReturnDelivery();" class="button-normal"></input>
                        </td>
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
                            <td style="width:7%">Return Code</td>
                            <td width="1%">|</td>
                            <td style="width:12%">Returned From</td>
                            <td width="1%">|</td>
                            <td style="width:12%">Warehouse Manager</td>
                            <td width="1%">|</td>
                            <td style="width:12%">Financial Manager</td>
                            <td width="1%">|</td>
                            <td style="width:10%">Date of Return</td>
                            <td width="1%">|</td>
                            <td style="width:10%">Quantity (tickets)</td>
                            <td width="1%">|</td>
                            <td style="width:10%">Amount (riels)</td>
                            <td width="1%">|</td>
                            <td style="width:7%">Status</td>
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
                <td style="width:7%">${obj.returnNo}</td>
                <td width="1%">&nbsp;</td>
                <td style="width:12%">${obj.marketAdminName}</td>
                <td width="1%">&nbsp;</td>
                <td style="width:12%">${obj.warehouseManager}</td>
                <td width="1%">&nbsp;</td>
                <td style="width:12%">${obj.financeAdminName}</td>
                <td width="1%">&nbsp;</td>
                <td style="width:10%"><fmt:formatDate value="${obj.applyDate}" pattern="yyyy-MM-dd HH:mm:ss"/></td>
                <td width="1%">&nbsp;</td>
                <td style="width:10%"><fmt:formatNumber value="${obj.applyTickets}"/></td>
                <td width="1%">&nbsp;</td>
                <td style="width:10%;text-align: right;"><fmt:formatNumber value="${obj.applyAmount}"/></td>
                <td width="1%">&nbsp;</td>
                <td style="width:7%">${obj.statusValue}</td>
                <td width="1%">&nbsp;</td>
                <td style="width:*%">
                    <span><a href="#" onclick="showDetails('${obj.returnNo}')">Details</a></span>&nbsp;|
                    <span>
                    	<c:if test="${obj.status == 1 && sessionScope.current_user.id == obj.marketManagerAdmin}">
                    		<a href="#" onclick="editOrder('${obj.returnNo}')">Edit</a>
                    	</c:if>
                    	<c:if test="${obj.status != 1 || sessionScope.current_user.id != obj.marketManagerAdmin}">
                    		Edit
                    	</c:if>
                    </span>&nbsp;|
                    <span>
                    	<c:if test="${obj.status == 1 && sessionScope.current_user.id == obj.marketManagerAdmin}">
                    		<a href="#" onclick="cancelOrder('${obj.returnNo}','${obj.status}');">Cancel</a>
                    	</c:if>
                    	<c:if test="${obj.status != 1 || sessionScope.current_user.id != obj.marketManagerAdmin}">
                    		Cancel
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