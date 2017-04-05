<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/views/common/taglibs.jsp"%>
<html>
<head>

<title>Delivery Orders Inquiry</title>

<%@ include file="/views/common/meta.jsp" %>
<link rel="stylesheet" type="text/css" href="${basePath}/css/style.css" />
<link rel="stylesheet" href="${basePath}/component/messageBox/myJsBox.css" type="text/css"/>
<script type="text/javascript" src="${basePath}/component/messageBox/myJsBox_zh.js"></script>
<script type="text/javascript" src="${basePath}/component/My97DatePicker/WdatePicker.js"></script>
<script type="text/javascript"	src="${basePath}/js/jquery/jquery-1.9.1.js"></script>

<script type="text/javascript" charset="UTF-8">
function showDetails(orderId){
	var url = "delivery.do?method=deliveryDetail&deliveryOrderNo="+orderId;
	showBox(url,'出货单详情',550,800);
}
</script>

</head>
<body>
    <!-- 出货单管理 -->
    <div id="title">出货单列表</div>
    
    <div class="queryDiv">
        <form action="delivery.do?method=listDeliveryForInquery" id="queryForm" method="post">
            <div class="left">
                <span>出货单编号: <input id="deliveryOrderNo" name="deliveryOrderNo" value="${form.deliveryOrderNo }" class="text-normal" maxlength="10"/></span>
                <span>出货日期:
                    <input id="applyDate" name="applyDate" value="${form.applyDate }" class="Wdate text-normal" onfocus="WdatePicker({lang:'zh-cn',dateFmt:'yyyy-MM-dd',readOnly:true})"/>
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
                            <td style="width:10%">出货单编号</td>
                            <td width="1%">|</td>
                            <td style="width:10%">出货日期</td>
                            <td width="1%">|</td>
                            <td style="width:10%">总金额 (瑞尔)</td>
                            <td width="1%">|</td>
                            <td style="width:12%">提交人</td>
                            <td width="1%">|</td>
                            <td style="width:15%">出货单位</td>
                            <td width="1%">|</td>
                            <td style="width:12%">出货人</td>
                            <td width="1%">|</td>
                            <td style="width:10%">出货状态</td>
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
                <td style="width:10%">${obj.doNo}</td>
                <td width="1%">&nbsp;</td>
                <td style="width:10%"><fmt:formatDate value="${obj.applyDate}" pattern="yyyy-MM-dd HH:mm:ss"/></td>
                <td width="1%">&nbsp;</td>
                <td style="width:10%;text-align: right"><fmt:formatNumber value="${obj.totalAmount}" /></td>
                <td width="1%">&nbsp;</td>
                <td style="width:12%" title="${obj.applyAdminName}">${obj.applyAdminName}</td>
                <td width="1%">&nbsp;</td>
                <td style="width:15%" title="${obj.orgName}">${obj.orgName}</td>
                <td width="1%">&nbsp;</td>
                <td style="width:12%" title="${obj.managerAdminName}">${obj.managerAdminName}</td>
                <td width="1%">&nbsp;</td>
                <td style="width:10%"><c:forEach var="item" items="${deliveryOrderStatus}"><c:if test="${obj.status==item.key }">${item.value}</c:if></c:forEach></td>
                <td width="1%">&nbsp;</td>
                <td style="width:*%">
                    <span><a href="#" onclick="showDetails('${obj.doNo}')">详情</a></span>
                </td>
            </tr>
            </c:forEach>
        </table>
        ${pageStr }
    </div>
</body>
</html>