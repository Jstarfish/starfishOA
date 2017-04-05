<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/views/common/taglibs.jsp"%>
<html>
<head>

<title>List of Purchase Orders</title>

<%@ include file="/views/common/meta.jsp" %>
<link rel="stylesheet" type="text/css" href="${basePath}/css/style.css" />
<link rel="stylesheet" href="${basePath}/component/messageBox/myJsBox.css" type="text/css"/>
<script type="text/javascript" src="${basePath}/component/messageBox/myJsBox_zh.js"></script>
<script type="text/javascript" src="${basePath}/component/My97DatePicker/WdatePicker.js"></script>
<script type="text/javascript" src="${basePath}/js/jquery/jquery-1.9.1.js"></script>

<script type="text/javascript" charset="UTF-8">

function newPurchaseOrder(){
	showBox('order.do?method=initPurchaseOrder','新增订单',550,800);
}

function showDetails(orderNo){
	showBox('order.do?method=purchaseDetail&purchaseOrderNo=' + orderNo,'订单明细',550,800);
}

function editOrder(orderNo){
	showBox('order.do?method=initPurchaseOrderEdit&purchaseOrderNo=' + orderNo,'修改订单',550,800);
}

function cancelOrder(orderId,status) {
	if(status != 1){
		showError('订单不能被取消!');
		return false;
	}
	
	var url = "order.do?method=cancelOrder&purchaseOrderNo=" + orderId;
	showDialog("doCancel('"+url+"')",'取消','你确定要取消订单 : '+orderId);
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
    <!-- 订单管理 -->
    <div id="title">订单列表</div>
    
    <div class="queryDiv">
        <form action="order.do?method=listOrderByApplyUser" id="queryForm" method="post">
            <div class="left">
                <span>订单编号: <input id="purchaseOrderNo" name="purchaseOrderNo" value="${form.purchaseOrderNo}" class="text-normal" maxlength="10"/></span>
                <span>订单日期:
                    <input id="applyDate" name="applyDate" value="${form.applyDate }" class="Wdate text-normal" onfocus="WdatePicker({lang:'zh-cn',dateFmt:'yyyy-MM-dd',readOnly:true})"/>
                </span>
                <input type="submit" value="查询" class="button-normal"></input>
            </div>
            <div class="right">
                <table width="260" border="0" cellspacing="0" cellpadding="0">
                    <tr style="height:50px;line-height:50px">
                        <td align="right">
                            <input type="button" value="提交订单" onclick="newPurchaseOrder();" class="button-normal"></input>
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
                            <td style="width:10%">订单编号</td>
                            <th width="1%">|</th>
                            <td style="width:10%">订单日期</td>
                            <th width="1%">|</th>
                            <td style="width:8%">总张数 (张)</td>
                            <th width="1%">|</th>
                            <td style="width:10%">总金额 (瑞尔)</td>
                            <th width="1%">|</th>
                            <td style="width:20%">提交人</td>
                            <th width="1%">|</th>
                            <td style="width:10%">订货站点</td>
                            <th width="1%">|</th>
                            <td style="width:10%">订单状态</td>
                            <th width="1%">|</th>
                            <td style="width:*%">操作</td>
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
                <td style="width:8%"><fmt:formatNumber value="${obj.applyTickets}" /></td>
                <td width="1%">&nbsp;</td>
                <td style="width:10%;text-align: right"><fmt:formatNumber value="${obj.applyAmount}" /></td>
                <td width="1%">&nbsp;</td>
                <td style="width:20%">${obj.applyName}</td>
                <td width="1%">&nbsp;</td>
                <td style="width:10%">${obj.applyAgency}</td>
                <td width="1%">&nbsp;</td>
                <td style="width:10%;"><c:forEach var="item" items="${purchaseOrderStatus}"><c:if test="${obj.status==item.key }">${item.value}</c:if></c:forEach></td>
                <td width="1%">&nbsp;</td>
                <td style="width:*%">
                    <span><a href="#" onclick="showDetails('${obj.orderNo}')">详情</a></span>&nbsp;|
                    <span>
                    	<c:if test="${obj.status == 3 || sessionScope.current_user.id != obj.applyAdmin}">
                    		修改
                    	</c:if>
                    	<c:if test="${obj.status != 3 && sessionScope.current_user.id == obj.applyAdmin}">
                    		<a href="#" onclick="editOrder('${obj.orderNo}')">修改</a>
                    	</c:if>
                    </span>&nbsp;|
                    <span>
                    	<c:if test="${obj.status == 1 && sessionScope.current_user.id == obj.applyAdmin}">
                    		<a href="#" onclick="cancelOrder('${obj.orderNo}','${obj.status}');">取消</a>
                    	</c:if>
                    	<c:if test="${obj.status != 1 || sessionScope.current_user.id != obj.applyAdmin}">
                    		取消
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