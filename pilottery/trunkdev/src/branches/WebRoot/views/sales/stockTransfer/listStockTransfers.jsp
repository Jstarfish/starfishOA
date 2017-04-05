<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/views/common/taglibs.jsp"%>
<html>
<head>

<title>Stock Transfers Apply</title>

<%@ include file="/views/common/meta.jsp" %>
<link rel="stylesheet" type="text/css" href="${basePath}/css/style.css" />
<link rel="stylesheet" href="${basePath}/component/messageBox/myJsBox.css" type="text/css"/>
<script type="text/javascript" src="${basePath}/component/messageBox/myJsBox.js"></script>
<script type="text/javascript" src="${basePath}/component/My97DatePicker/WdatePicker.js"></script>
<script type="text/javascript" src="${basePath}/js/jquery/jquery-1.9.1.js"></script>

<script type="text/javascript" charset="UTF-8">

function newStockTransfer(){
	showBox('transfer.do?method=initStockTransferAdd','New Stock Transfer',600,800);
}

function showDetails(stbNo){
	showBox('transfer.do?method=stockTransferDetail&stbNo=' + stbNo,'Stock Transfer Details',600,800);
}

function editOrder(stbNo){
	showBox('transfer.do?method=initStockTransferEdit&stbNo=' + stbNo,'Edit Stock Transfer',600,800);
}

function cancelOrder(stbNo,status) {
	if(status != 1){
		showError('Order Cannot Be Cancelled');
		return false;
	}
	
	var url = "transfer.do?method=cancelStockTransfer&stbNo=" + stbNo;
	showDialog("doCancel('"+url+"')",'Cancel','Are you sure you want to cancel<br/> Stock Transfer : '+stbNo);
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
    <div id="title">List Of Stock Transfers</div>
    
    <div class="queryDiv">
        <form action="transfer.do?method=listTransferByApplyUser" id="queryForm" method="post">
            <div class="left">
                <span>Stock Transfer: <input id="stockTransferNo" name="stockTransferNo" value="${form.stockTransferNo}" maxlength="10" class="text-normal"/></span>
                <span>Date:
                    <input id="applyDate" name="applyDate" value="${form.applyDate}" class="Wdate text-normal" onfocus="WdatePicker({dateFmt:'yyyy-MM-dd',readOnly:true})"/>
                </span>
                <input type="submit" value="Query" class="button-normal"></input>
            </div>
            <div class="right">
                <table width="260" border="0" cellspacing="0" cellpadding="0">
                    <tr style="height:50px;line-height:50px">
                        <td align="right">
                            <input type="button" value="Submit Stock Transfer" onclick="newStockTransfer();" class="button-normal"></input>
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
                            <td style="width:6%">Stock Transfer</td>
                            <td width="1%">|</td>
                            <td style="width:9%">Date</td>
                            <td width="1%">|</td>
                            <td style="width:8%">Quantity (tickets)</td>
                            <td width="1%">|</td>
                            <td style="width:7%">Amount (riels)</td>
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
                <td style="width:7%;text-align: right;"><fmt:formatNumber value="${obj.amount}" /></td>
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
                    	<c:if test="${(obj.status == 1 || obj.status == 2) && sessionScope.current_user.id == obj.applyAdmin}">
                    		<a href="#" onclick="editOrder('${obj.stbNo}')">Edit</a>
                    	</c:if>
                    	<c:if test="${(obj.status != 1 && obj.status != 2) || sessionScope.current_user.id != obj.applyAdmin}">
                    		Edit
                    	</c:if>
                    </span>&nbsp;|
                    <span>
                    	<c:if test="${obj.status == 1 && sessionScope.current_user.id == obj.applyAdmin}">
                    		<a href="#" onclick="cancelOrder('${obj.stbNo}','${obj.status}');">Cancel</a>
                    	</c:if>
                    	<c:if test="${obj.status != 1 || sessionScope.current_user.id != obj.applyAdmin}">
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