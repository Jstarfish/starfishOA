<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/views/common/taglibs.jsp"%>
<html>
<head>

<title>List of Damaged Items</title>

<%@ include file="/views/common/meta.jsp" %>
<link rel="stylesheet" type="text/css" href="${basePath}/css/style.css" />
<link rel="stylesheet" href="${basePath}/component/messageBox/myJsBox.css" type="text/css"/>

<script type="text/javascript" src="${basePath}/component/messageBox/myJsBox.js"></script>
<script type="text/javascript" src="${basePath}/component/My97DatePicker/WdatePicker.js"></script>
<script type="text/javascript" src="${basePath}/js/jquery/jquery-1.9.1.js"></script>

<script type="text/javascript" charset="UTF-8">
function updateQuery() {
	$("#itemDamageQueryForm").submit();
}

/*
function clearValues() {
	$("#itemCodeQuery").val('');
	$("#itemNameQuery").val('');
	$("#damageDateQuery").val('');
}

$(document).ready(function() {
	$("#itemCodeQuery").keydown(function(event) {
        if (event.keyCode == 13) {
            updateQuery();
        }
    });
	$("#itemNameQuery").keydown(function(event) {
        if (event.keyCode == 13) {
            updateQuery();
        }
    });
});
*/
</script>

</head>
<body>
    <!-- 顶部标题块 -->
    <div id="title">Damaged Items</div>
    
    <!-- 查询条件块 -->
    <div class="queryDiv">
        <form action="item.do?method=listDamagedItems" method="POST" id="itemDamageQueryForm">
            <div class="left">
	   			<span>Item Code: <input id="itemCodeQuery" name="itemCode" value="${itemDamageQueryForm.itemCode}" class="text-normal" maxlength="60"/></span>
	   			<span>Item Name: <input id="itemNameQuery" name="itemName" value="${itemDamageQueryForm.itemName}" class="text-normal" maxlength="40"/></span>
	   			<span>Register Date: <input id="damageDateQuery" name="damageDate" value="${itemDamageQueryForm.damageDate}" class="Wdate text-normal" onfocus="WdatePicker({dateFmt:'yyyy-MM-dd',readOnly:true,isShowClear:true,isShowToday:true})" maxlength="40"/></span>
	   			<input type="button" value="Query" onclick="updateQuery();" class="button-normal"></input>
	   			<!--<input type="button" value="Clear" onclick="clearValues();" class="button-normal"></input>-->
            </div>
            <div class="right">
                <table width="260" border="0" cellspacing="0" cellpadding="0">
                    <tr style="height:50px;line-height:50px">
                        <td align="right">
                            <input type="button" value="Register Damaged Items" onclick="showBox('item.do?method=addItemDamageInit','Register Damaged Item',450,700);" class="button-normal"></input>
                        </td>
                    </tr>
                </table>
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
                            <td style="width:10%">Register Code</td>
                            <td width="1%">|</td>
                            <td style="width:14%">Register Date</td>
                            <td width="1%">|</td>
                            <td style="width:14%">Item Code</td>
                            <td width="1%">|</td>
                            <td style="width:14%">Item Name</td>
                            <td width="1%">|</td>
                            <td style="width:14%">Quantity Damaged</td>
                            <td width="1%">|</td>
                            <td style="width:14%">Warehouse</td>
                            <td width="1%">|</td>
                            <td style="width:*%">Operation</td>
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
        	<c:forEach var="data" items="${itemDamageList}" varStatus="status">
	        	<tr class="dataRow">
	        		<td style="width:10px;">&nbsp;</td>
	                <td style="width:10%" title="${data.idNo}">${data.idNo}</td>
	                <td width="1%">&nbsp;</td>
	                <td style="width:14%" title="${data.damageDate}">${data.damageDate}</td>
	                <td width="1%">&nbsp;</td>
	                <td style="width:14%" title="${data.itemCode}">${data.itemCode}</td>
	                <td width="1%">&nbsp;</td>
	                <td style="width:14%" title="${data.itemName}">${data.itemName}</td>
	                <td width="1%">&nbsp;</td>
	                <td style="width:14%" title='<fmt:formatNumber value="${data.quantity}"/>'><fmt:formatNumber value="${data.quantity}"/></td>
	                <td width="1%">&nbsp;</td>
	                <td style="width:14%" title="${data.warehouseName}">${data.warehouseName}</td>
	                <td width="1%">&nbsp;</td>
	                <td style="width:*%">
	                    <span><a href="#" onclick="showBox('item.do?method=itemDamageDetails&idNo=${data.idNo}&damageDate=${data.damageDate}&itemCode=${data.itemCode}&itemName=${data.itemName}&quantity=${data.quantity}&checkAdminName=${data.checkAdminName}&remark=${data.remark}&warehouseCode=${data.warehouseCode}&warehouseName=${data.warehouseName}','Item Damage Details', 400, 800);">Details</a></span>
	                </td>
	            </tr>
        	</c:forEach>
        </table>
        ${pageStr}
    </div>
</body>
</html>
