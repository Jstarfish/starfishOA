<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/views/common/taglibs.jsp"%>
<html>
<head>

<title>库存信息列表</title>

<%@ include file="/views/common/meta.jsp" %>
<link rel="stylesheet" type="text/css" href="${basePath}/css/style.css" />
<link rel="stylesheet" href="${basePath}/component/messageBox/myJsBox.css" type="text/css"/>

<script type="text/javascript" src="${basePath}/component/messageBox/myJsBox.js"></script>
<script type="text/javascript" src="${basePath}/component/My97DatePicker/WdatePicker.js"></script>
<script type="text/javascript" src="${basePath}/js/jquery/jquery-1.9.1.js"></script>

<script type="text/javascript" charset="UTF-8">
function updateQuery() {
    $("#itemQuantityQueryForm").submit();
}
/*
function clearValues() {
	$("#warehouseQuery").val("");
	$("#itemQuery").val("");
}
*/
</script>

</head>
<body>
    <!-- 顶部标题块 -->
    <div id="title">库存信息列表</div>
    
    <!-- 查询条件块 -->
    <div class="queryDiv">
        <form action="item.do?method=listInventoryInfo" method="POST" id="itemQuantityQueryForm">
            <div class="left">
                <span>仓库:
                    <select name="warehouseCode" id="warehouseQuery" class="select-normal">
                        <option value="">全部</option>
                        <c:forEach var="wh" items="${whSelect}" varStatus="selectWhStatus">
                        	<option value="${wh.warehouseCode}" <c:if test="${itemQuantityQueryForm.warehouseCode==wh.warehouseCode}">selected</c:if>>${wh.warehouseName}</option>
                        </c:forEach>
                    </select>
                </span>
                <span>物品:
                    <select name="itemCode" id="itemQuery" class="select-normal">
                    	<option value="">全部</option>
                    	<c:forEach var="item" items="${itemSelect}" varStatus="selectItemStatus">
                    		<option value="${item.itemCode}" <c:if test="${itemQuantityQueryForm.itemCode==item.itemCode}">selected</c:if>>${item.itemName}</option>
                    	</c:forEach>
                    </select>
                </span>
                <input type="button" value="查询" onclick="updateQuery();" class="button-normal"></input>
                <!--<input type="button" value="Clear" onclick="clearValues();" class="button-normal"></input>-->
            </div>
        </form>
    </div>
    
    <!-- 列表表头块 -->
    <div id="headDiv">
        <table width="100%" border="0" cellpadding="0" cellspacing="0">
            <tr>
                <td>
                    <table class="datatable">
                        <tr class="headRow">
                        	<td style="width:10px;">&nbsp;</td>
                        	<td style="width:16%">仓库编码</td>
                        	<td width="1%">|</td>
                        	<td style="width:20%">仓库名称</td>
                        	<td width="1%">|</td>
                            <td style="width:20%">物品编码</td>
                            <td width="1%">|</td>
                            <td style="width:20%">物品名称</td>
                            <td width="1%">|</td>
                            <td style="width:*%">库存数量</td>
                        </tr>
                    </table>
                 </td>
                 <!-- 表头和下方数据对齐 -->
                 <td style="width:17px;background:#2aa1d9"></td>
             </tr>
        </table>
    </div>
    
    <!-- 列表内容块 -->
    <div id="bodyDiv">
        <table class="datatable">
        	<c:forEach var="data" items="${itemQuantityList}" varStatus="invInfoStatus">
        		<tr class="dataRow">
        			<td style="width:10px;">&nbsp;</td>
        			<td style="width:16%" title="${data.warehouseCode}">${data.warehouseCode}</td>
        			<td width="1%">&nbsp;</td>
	            	<td style="width:20%" title="${data.warehouseName}">${data.warehouseName}</td>
	            	<td width="1%">&nbsp;</td>
	                <td style="width:20%" title="${data.itemCode}">${data.itemCode}</td>
	                <td width="1%">&nbsp;</td>
	                <td style="width:20%" title="${data.itemName}">${data.itemName}</td>
	                <td width="1%">&nbsp;</td>
	                <td style="width:*%" title='<fmt:formatNumber value="${data.quantity}"/>'><fmt:formatNumber value="${data.quantity}"/></td>
        		</tr>
        	</c:forEach>
        </table>
        ${pageStr}
    </div>
</body>
</html>