<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/views/common/taglibs.jsp"%>
<html>
<head>

<title>调拨单审批</title>

<%@ include file="/views/common/meta.jsp" %>
<link rel="stylesheet" type="text/css" href="${basePath}/css/style.css" />
<link rel="stylesheet" href="${basePath}/component/messageBox/myJsBox.css" type="text/css"/>
<script type="text/javascript" src="${basePath}/component/messageBox/myJsBox_zh.js"></script>
<script type="text/javascript" src="${basePath}/component/My97DatePicker/WdatePicker.js"></script>
<script type="text/javascript" src="${basePath}/js/jquery/jquery-1.9.1.js"></script>

<script type="text/javascript" charset="UTF-8">
function showDetails(stbNo){
	showBox('transfer.do?method=stockTransferDetail&stbNo=' + stbNo,'调拨单详情',550,800);
}
function approve(stbNo){
	showBoxRefresh('transfer.do?method=initAproveStockTransfer&stbNo=' + stbNo,'调拨单审批',400,800);
}

function expired(stbNo) {
	var url = "transfer.do?method=expiredStockTransfer&stbNo=" + stbNo;
	showDialog("doExpired('"+url+"')",'作废','你确定作废<br/> 调拨单 : '+stbNo);
}
function doExpired(url) {
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
    <div id="title">调拨单审批列表</div>
    
    <div class="queryDiv">
        <form action="transfer.do?method=listTransferForInquery" id="queryForm" method="post">
            <div class="left">
            	<span>机构:
            		<select class="select-normal" name="institutionCode" >
            			<option value="">--全部--</option>
                   	   <c:forEach var="obj" items="${institutionList}" varStatus="plan">
                   	   		<c:if test="${obj.institutionCode == form.institutionCode}">
                   	   			<option value="${obj.institutionCode}" selected="selected">${obj.institutionName}</option>
                   	   		</c:if>
                   	   		<c:if test="${obj.institutionCode != form.institutionCode}">
                   	   			<option value="${obj.institutionCode}">${obj.institutionName}</option>
                   	   		</c:if>
                   	   </c:forEach>
                    </select>
            	</span>
                <span>调拨单编号: <input id="stockTransferNo" name="stockTransferNo" value="${form.stockTransferNo}" maxlength="10" class="text-normal"/></span>
                <span>日期:
                    <input id="applyDate" name="applyDate" value="${form.applyDate}" class="Wdate text-normal" onfocus="WdatePicker({lang:'zh-cn',dateFmt:'yyyy-MM-dd',readOnly:true})"/>
                </span>
                <input type="submit" value="查询" class="button-normal"></input>
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
                            <td style="width:9%">日期</td>
                            <td width="1%">|</td>
                            <td style="width:8%">数量 (张)</td>
                            <td width="1%">|</td>
                            <td style="width:8%">金额 (瑞尔)</td>
                            <td width="1%">|</td>
                            <td style="width:9%">申请人</td>
                            <td width="1%">|</td>
                            <td style="width:9%">收货单位</td>
                            <td width="1%">|</td>
                            <td style="width:9%">发货单位</td>
                            <td width="1%">|</td>
                            <td style="width:9%">收货日期</td>
                            <td width="1%">|</td>
                            <td style="width:9%">发货日期</td>
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
                <td style="width:5%"><c:forEach var="item" items="${stockTransferStatus}"><c:if test="${obj.status==item.key }">${item.value}</c:if></c:forEach></td>
                <td width="1%">&nbsp;</td>
                <td style="width:*%">
                    <span><a href="#" onclick="showDetails('${obj.stbNo}')">详情</a></span>&nbsp;|
                    <span>
                    	<c:if test="${obj.status == 1 && sessionScope.isCollector != 1}">
                    		<a href="#" onclick="approve('${obj.stbNo}')">审批</a>
                    	</c:if>
                    	<c:if test="${obj.status != 1 || sessionScope.isCollector == 1}">
                    		审批
                    	</c:if>
                    </span>
                    <span>
                    	<c:if test="${obj.status == 7 && sessionScope.isCollector != 1}">
                    		<a href="#" onclick="expired('${obj.stbNo}')">作废</a>
                    	</c:if>
                    	<c:if test="${obj.status != 7 || sessionScope.isCollector == 1}">
                    		作废
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