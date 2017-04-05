<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/views/common/taglibs.jsp"%>
<html>
<head>

<title>物品出库列表</title>

<%@ include file="/views/common/meta.jsp" %>
<link rel="stylesheet" type="text/css" href="${basePath}/css/style.css" />
<link rel="stylesheet" href="${basePath}/component/messageBox/myJsBox.css" type="text/css"/>

<script type="text/javascript" src="${basePath}/component/messageBox/myJsBox.js"></script>
<script type="text/javascript" src="${basePath}/component/My97DatePicker/WdatePicker.js"></script>
<script type="text/javascript" src="${basePath}/js/jquery/jquery-1.9.1.js"></script>

<script type="text/javascript" charset="UTF-8">
function updateQuery() {
    $("#itemIssueQueryForm").submit();
}

/*
function clearValues() {
	$("#issueCode").val('');
	$("#issueDate").val('');
	$("#warehouseCode").val('');
}

$(document).ready(function() {
	$("#issueCode").keydown(function(event) {
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
    <div id="title">物品出库列表</div>
    
    <!-- 查询条件块 -->
    <div class="queryDiv">
        <form action="item.do?method=listGoodsIssues" method="POST" id="itemIssueQueryForm">
            <div class="left">
				<span>出库单编号: <input id="issueCode" name="issueCode" value="${itemIssueQueryForm.issueCode}" class="text-normal" maxlength="40"/></span>
				<span>出库日期: <input id="issueDate" name="issueDate" value="${itemIssueQueryForm.issueDate}" class="Wdate text-normal" onfocus="WdatePicker({dateFmt:'yyyy-MM-dd',readOnly:true,isShowClear:true,isShowToday:true})" maxlength="40"/></span>
				<span>出库仓库:
					<select id="warehouseCode" name="warehouseCode" class="select-normal">
						<option value="">全部</option>
						<c:forEach var="wh" items="${whInfoList}" varStatus="status">
							<option value="${wh.warehouseCode}" <c:if test="${itemIssueQueryForm.warehouseCode==wh.warehouseCode}">selected</c:if>>${wh.warehouseName}</option>
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
                            <input type="button" value="新增物品出库" onclick="showBox('item.do?method=addItemIssueInit','新增物品出库', 600, 800);" class="button-normal"></input>
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
                            <td style="width:12%">出库单编号</td>
                            <td width="1%">|</td>
                            <td style="width:14%">操作人</td>
                            <td width="1%">|</td>
                            <td style="width:14%">出库日期</td>
                            <td width="1%">|</td>
                            <td style="width:14%">收货单位</td>
                            <td width="1%">|</td>
                            <td style="width:14%">发货单位</td>
                            <td width="1%">|</td>
                            <td style="width:14%">发货仓库</td>
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
        	<c:forEach var="data" items="${itemIssueList}" varStatus="status">
        		<tr class="dataRow">
        			<td style="width:10px;">&nbsp;</td>
        			<td style="width:12%" title="${data.iiNo}">${data.iiNo}</td>
        			<td width="1%">&nbsp;</td>
        			<td style="width:14%" title="${data.operAdminName}">${data.operAdminName}</td>
        			<td width="1%">&nbsp;</td>
        			<td style="width:14%" title="${data.issueDate}">${data.issueDate}</td>
        			<td width="1%">&nbsp;</td>
        			<td style="width:14%" title="${data.receiveOrgName}">${data.receiveOrgName}</td>
        			<td width="1%">&nbsp;</td>
        			<td style="width:14%" title="${data.sendOrgName}">${data.sendOrgName}</td>
        			<td width="1%">&nbsp;</td>
        			<td style="width:14%" title="${data.sendWhName}">${data.sendWhName}</td>
        			<td width="1%">&nbsp;</td>
        			<td style="width:*%">
	                    <span><a href="#" onclick="showBox('item.do?method=itemIssueDetails&iiNo=${data.iiNo}&operAdminName=${data.operAdminName}&receiveOrgName=${data.receiveOrgName}&sendOrgName=${data.sendOrgName}&sendWhName=${data.sendWhName}','物品出库详情', 600, 800);">详情</a></span>&nbsp;|
	                    <span><a href="#" onclick="showPage('item.do?method=printItemIssueSlip&iiNo=${data.iiNo}&receiveOrgName=${data.receiveOrgName}&sendOrgName=${data.sendOrgName}&sendWhName=${data.sendWhName}','打印物品出库单');">打印</a></span>
                	</td>
        		</tr>
        	</c:forEach>
        </table>
        ${pageStr}
    </div>
</body>
</html>