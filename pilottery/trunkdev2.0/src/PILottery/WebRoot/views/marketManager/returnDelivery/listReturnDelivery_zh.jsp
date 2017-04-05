<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/views/common/taglibs.jsp"%>
<html>
<head>

<title>List of Stock Transfers</title>

<%@ include file="/views/common/meta.jsp" %>
<link rel="stylesheet" type="text/css" href="${basePath}/css/style.css" />
<link rel="stylesheet" href="${basePath}/component/messageBox/myJsBox.css" type="text/css"/>
<script type="text/javascript" src="${basePath}/component/messageBox/myJsBox_zh.js"></script>
<script type="text/javascript" src="${basePath}/component/My97DatePicker/WdatePicker.js"></script>
<script type="text/javascript" src="${basePath}/js/jquery/jquery-1.9.1.js"></script>

<script type="text/javascript" charset="UTF-8">

function newReturnDelivery(){
	showBox('returnDelivery.do?method=initReturnDeliveryAdd','新建还货申请',550,800);
}

function showDetails(stbNo){
	showBox('returnDelivery.do?method=returnDeliveryDetail&queryNo=' + stbNo,'还货单详情',550,800);
}

function editOrder(stbNo){
	showBox('returnDelivery.do?method=initReturnDeliveryEdit&queryNo=' + stbNo,'修改还货申请',550,800);
}

function approve(stbNo){
	showBox('returnDelivery.do?method=initAproveReturnDelivery&queryNo=' + stbNo,'还货审批',550,800);
}

function cancelOrder(stbNo,status) {
	if(status != 1){
		showError('订单不能被取消!');
		return false;
	}
	
	var url = "returnDelivery.do?method=cancelReturnDelivery&queryNo=" + stbNo;
	showDialog("doCancel('"+url+"')",'取消','您想取消<br/> 还货申请 : '+stbNo);
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
    <div id="title">还货列表</div>
    
    <div class="queryDiv">
        <form action="returnDelivery.do?method=listReturnDeliveries" id="queryForm" method="post">
            <div class="left">
                <span>还货申请编号: <input id="queryNo" name="queryNo" value="${form.queryNo}" maxlength="10" class="text-normal"/></span>
                <span>还货日期:
                    <input id="queryDate" name="queryDate" value="${form.queryDate}" class="Wdate text-normal" onfocus="WdatePicker({lang:'zh-cn',dateFmt:'yyyy-MM-dd',readOnly:true})"/>
                </span>
                <input type="submit" value="查询" class="button-normal"></input>
            </div>
            <div class="right">
                <table width="260" border="0" cellspacing="0" cellpadding="0">
                    <tr style="height:50px;line-height:50px">
                        <td align="right">
                            <input type="button" value="提交还货申请 " onclick="newReturnDelivery();" class="button-normal"></input>
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
                            <td style="width:7%">还货单编号</td>
                            <td width="1%">|</td>
                            <td style="width:12%">还货人</td>
                            <td width="1%">|</td>
                            <td style="width:12%">仓库管理员</td>
                            <td width="1%">|</td>
                            <td style="width:12%">财务审批人</td>
                            <td width="1%">|</td>
                            <td style="width:10%">还货日期</td>
                            <td width="1%">|</td>
                            <td style="width:10%">还货数量 (张)</td>
                            <td width="1%">|</td>
                            <td style="width:10%">还货总金额 (瑞尔)</td>
                            <td width="1%">|</td>
                            <td style="width:7%">申请状态</td>
                            <td width="1%">|</td>
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
                <td style="width:7%">
                <c:forEach var="item" items="${returnDeliveryStatus}"><c:if test="${!empty obj }"><c:if test="${obj.status==item.key }">${item.value}</c:if></c:if></c:forEach></td>
                <td width="1%">&nbsp;</td>
                <td style="width:*%">
                    <span><a href="#" onclick="showDetails('${obj.returnNo}')">详情</a></span>&nbsp;|
                    <span>
                    	<c:if test="${obj.status == 1 && sessionScope.current_user.id == obj.marketManagerAdmin}">
                    		<a href="#" onclick="editOrder('${obj.returnNo}')">编辑</a>
                    	</c:if>
                    	<c:if test="${obj.status != 1 || sessionScope.current_user.id != obj.marketManagerAdmin}">
                    		编辑
                    	</c:if>
                    </span>&nbsp;|
                    <span>
                    	<c:if test="${obj.status == 1 && sessionScope.current_user.id == obj.marketManagerAdmin}">
                    		<a href="#" onclick="cancelOrder('${obj.returnNo}','${obj.status}');">取消</a>
                    	</c:if>
                    	<c:if test="${obj.status != 1 || sessionScope.current_user.id != obj.marketManagerAdmin}">
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