<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/views/common/taglibs.jsp"%>
<html>
<head>

<title>物品入库列表</title>

<%@ include file="/views/common/meta.jsp" %>
<link rel="stylesheet" type="text/css" href="${basePath}/css/style.css" />
<link rel="stylesheet" href="${basePath}/component/messageBox/myJsBox.css" type="text/css"/>

<script type="text/javascript" src="${basePath}/component/messageBox/myJsBox.js"></script>
<script type="text/javascript" src="${basePath}/component/My97DatePicker/WdatePicker.js"></script>
<script type="text/javascript" src="${basePath}/js/jquery/jquery-1.9.1.js"></script>

<script type="text/javascript" charset="UTF-8">
function updateQuery() {
	$("#itemReceiptQueryForm").submit();
}

/*
function clearValues() {
    $("#receiptCode").val('');
    $("#receiptDate").val('');
    $("#warehouseCode").val('');
}

$(document).ready(function() {
	$("#receiptCode").keydown(function(event) {
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
    <div id="title">物品入库列表</div>
    
    <!-- 查询条件块 -->
    <div class="queryDiv">
        <form action="item.do?method=listGoodsReceipts" method="POST" id="itemReceiptQueryForm">
            <div class="left">
           		<span>入库单编号: <input id="receiptCode" name="receiptCode" value="${itemReceiptQueryForm.receiptCode}" class="text-normal" maxlength="40"/></span>
           		<span>入库日期: <input id="receiptDate" name="receiptDate" value="${itemReceiptQueryForm.receiptDate}" class="Wdate text-normal" onfocus="WdatePicker({dateFmt:'yyyy-MM-dd',readOnly:true,isShowClear:true,isShowToday:true})" maxlength="40"/></span>
           		<span>入库仓库: 
           			<select id="warehouseCode" name="warehouseCode" class="select-normal">
                        <option value="">全部</option>
                        <c:forEach var="wh" items="${whInfoList}" varStatus="status">
                            <option value="${wh.warehouseCode}" <c:if test="${itemReceiptQueryForm.warehouseCode==wh.warehouseCode}">selected</c:if>>${wh.warehouseName}</option>
                        </c:forEach>
                    </select>
				</span>
           		<input type="button" value="查询" onclick="updateQuery();" class="button-normal"></input>
           		<!--<input type="button" value="Clear" onclick="clearValues();" class="button-normal"></input>-->
            </div>
            <div class="right">
                <table width="260" border="0" cellspacing="0" cellpadding="0">
                    <tr style="height:50px;line-height:50px">
                        <td align="right">
                            <input type="button" value="新增物品入库" onclick="showBox('item.do?method=addItemReceiptInit','新增物品入库', 600, 800);" class="button-normal"></input>
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
                            <td style="width:18%">入库单编号</td>
                            <td width="1%">|</td>
                            <td style="width:20%">入库日期</td>
                            <td width="1%">|</td>
                            <td style="width:20%">入库仓库</td>
                            <td width="1%">|</td>
                            <td style="width:20%">操作人</td>
                            <td width="1%">|</td>
                            <td style="width:*%">操作</td>
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
        	<c:forEach var="data" items="${itemReceiptList}" varStatus="status">
            	<tr class="dataRow">
            		<td style="width:10px;">&nbsp;</td>
            		<td style="width:18%" title="${data.irNo}">${data.irNo}</td>
            		<td width="1%">&nbsp;</td>
                	<td style="width:20%" title="${data.receiveDate}">${data.receiveDate}</td>
                	<td width="1%">&nbsp;</td>
                	<td style="width:20%" title="${data.receiveWhName}">${data.receiveWhName}</td>
                	<td width="1%">&nbsp;</td>
                	<td style="width:20%" title="${data.createAdminName}">${data.createAdminName}</td>
                	<td width="1%">&nbsp;</td>
                	<td style="width:*%">
                    	<span><a href="#" onclick="showBox('item.do?method=itemReceiptDetails&irNo=${data.irNo}&receiveWhName=${data.receiveWhName}&createAdminName=${data.createAdminName}','物品入库详情', 600, 800);">详情</a></span>&nbsp;|
                    	<span><a href="#" onclick="showPage('item.do?method=printItemReceiptSlip&irNo=${data.irNo}&receiveOrgName=${data.receiveOrgName}&receiveWhName=${data.receiveWhName}','打印物品入库单');">打印</a></span>
                	</td>
            	</tr>
            </c:forEach>
        </table>
        ${pageStr}
    </div>
</body>
</html>