<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/views/common/taglibs.jsp"%>
<html>
<head>

<title>调拨单列表</title>

<%@ include file="/views/common/meta.jsp" %>
<link rel="stylesheet" type="text/css" href="${basePath}/css/style.css" />
<link rel="stylesheet" href="${basePath}/component/messageBox/myJsBox.css" type="text/css"/>
<script type="text/javascript" src="${basePath}/component/messageBox/myJsBox_zh.js"></script>
<script type="text/javascript" src="${basePath}/component/My97DatePicker/WdatePicker.js"></script>
<script type="text/javascript" src="${basePath}/js/jquery/jquery-1.9.1.js"></script>

<script type="text/javascript" charset="UTF-8">

function newStockTransfer(){
	showBox('transfer.do?method=initStockTransferAdd','填写调拨单',600,800);
}

function showDetails(stbNo){
	showBox('transfer.do?method=stockTransferDetail&stbNo=' + stbNo,'调拨单详情',600,800);
}

function editOrder(stbNo){
	showBox('transfer.do?method=initStockTransferEdit&stbNo=' + stbNo,'修改调拨单',600,800);
}

function cancelOrder(stbNo,status) {
	if(status != 1){
		showError('订单无法取消');
		return false;
	}
	
	var url = "transfer.do?method=cancelStockTransfer&stbNo=" + stbNo;
	showDialog("doCancel('"+url+"')",'取消','你确定取消<br/> 调拨单 : '+stbNo);
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
    <div id="title">调拨单列表</div>
    
    <div class="queryDiv">
        <form action="transfer.do?method=listTransferByApplyUser" id="queryForm" method="post">
            <div class="left">
                <span>调拨单编号: <input id="stockTransferNo" name="stockTransferNo" value="${form.stockTransferNo}" maxlength="10" class="text-normal"/></span>
                <span>申请日期:
                    <input id="applyDate" name="applyDate" value="${form.applyDate}" class="Wdate text-normal" onfocus="WdatePicker({lang:'zh-cn',dateFmt:'yyyy-MM-dd',readOnly:true})"/>
                </span>
                <input type="submit" value="查询" class="button-normal"></input>
            </div>
            <div class="right">
                <table width="260" border="0" cellspacing="0" cellpadding="0">
                    <tr style="height:50px;line-height:50px">
                        <td align="right">
                            <input type="button" value="新建调拨单" onclick="newStockTransfer();" class="button-normal"></input>
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
                            <td style="width:6%">调拨单编号</td>
                            <td width="1%">|</td>
                            <td style="width:9%">申请日期</td>
                            <td width="1%">|</td>
                            <td style="width:8%">总张数 (张)</td>
                            <td width="1%">|</td>
                            <td style="width:7%">总金额 (瑞尔)</td>
                            <td width="1%">|</td>
                            <td style="width:9%">申请人</td>
                            <td width="1%">|</td>
                            <td style="width:9%">收货单位</td>
                            <td width="1%">|</td>
                            <td style="width:9%">发货单位</td>
                            <td width="1%">|</td>
                            <td style="width:9%">收货时间</td>
                            <td width="1%">|</td>
                            <td style="width:9%">发货时间</td>
                            <td width="1%">|</td>
                            <td style="width:5%">状态</td>
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
                <td style="width:5%"><c:forEach var="item" items="${stockTransferStatus}"><c:if test="${obj.status==item.key }">${item.value}</c:if></c:forEach></td>
                <td width="1%">&nbsp;</td>
                <td style="width:*%">
                    <span><a href="#" onclick="showDetails('${obj.stbNo}')">详情</a></span>&nbsp;|
                    <span>
                    	<c:if test="${(obj.status == 1 || obj.status == 2) && sessionScope.current_user.id == obj.applyAdmin}">
                    		<a href="#" onclick="editOrder('${obj.stbNo}')">编辑</a>
                    	</c:if>
                    	<c:if test="${(obj.status != 1 && obj.status != 2) || sessionScope.current_user.id != obj.applyAdmin}">
                    		编辑
                    	</c:if>
                    </span>&nbsp;|
                    <span>
                    	<c:if test="${obj.status == 1 && sessionScope.current_user.id == obj.applyAdmin}">
                    		<a href="#" onclick="cancelOrder('${obj.stbNo}','${obj.status}');">取消</a>
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