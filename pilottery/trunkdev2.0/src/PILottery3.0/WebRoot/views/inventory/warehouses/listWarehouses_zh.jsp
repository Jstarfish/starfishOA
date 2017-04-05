<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/views/common/taglibs.jsp"%>
<html>
<head>

<title>仓库列表</title>

<%@ include file="/views/common/meta.jsp" %>
<link rel="stylesheet" type="text/css" href="${basePath}/css/style.css" />
<link rel="stylesheet" href="${basePath}/component/messageBox/myJsBox.css" type="text/css"/>

<script type="text/javascript" src="${basePath}/component/messageBox/myJsBox_zh.js"></script>
<script type="text/javascript" src="${basePath}/component/My97DatePicker/WdatePicker.js"></script>
<script type="text/javascript" src="${basePath}/js/jquery/jquery-1.9.1.js"></script>

<script type="text/javascript" charset="UTF-8">
function updateQuery() {
    $("#warehouseQueryForm").submit();
}

/*
function clearValues() {
    $("#warehouseCodeQuery").val('');
    $("#institutionQuery").val('');
}
*/

function deleteWarehousePrompt(warehouseCode) {
	var msg = "您确定要删除编号为 <b>" + warehouseCode + "</b> 的仓库吗?";
	showDialog("deleteWarehouseAjax('"+warehouseCode+"')", "删除仓库", msg);
}

function deleteWarehouseAjax(code) {
	$.ajax({
		url: "warehouses.do?method=deleteWarehouse",
		data: {warehouseCode: code},
		type: "POST",
		dataType: "json",
		success: function(json) {
			if (json.message != '' && json.message != null) {
                closeDialog();
                showError(decodeURI(json.message));
            } else {
                closeDialog();
                window.location.reload();
            }
		}
	});
}

/*
$(document).ready(function() {
    $("#warehouseCodeQuery").keydown(function(event) {
        if (event.keyCode == 13) {
            updateQuery();
        }
    });
    
    $("#institutionQuery").keydown(function(event) {
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
    <div id="title">仓库列表</div>
    
    <!-- 查询条件块 -->
    <div class="queryDiv">
        <form action="warehouses.do?method=listWarehouses" method="POST" id="warehouseQueryForm">
            <div class="left">
                <span>仓库编号: <input id="warehouseCodeQuery" name="warehouseCodeQuery" value="${warehouseQueryForm.warehouseCodeQuery}" class="text-normal" maxlength="40"/></span>
                <span>组织机构: 
                    <select id="institutionQuery" name="institutionQuery" class="select-normal">
                        <option value="">全部</option>
                        <c:forEach var="data" items="${institutionList}" varStatus="status">
                            <option value="${data.orgCode}" <c:if test="${warehouseQueryForm.institutionQuery==data.orgCode}">selected</c:if> >${data.orgName}</option>
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
                            <input type="button" value="新增仓库" onclick="showBox('warehouses.do?method=addWarehouseInit','新增仓库', 550, 800);" class="button-normal"></input>
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
                            <td style="width:14%">组织机构</td>
                            <td width="1%">|</td>
                            <td style="width:10%">仓库编号</td>
                            <td width="1%">|</td>
                            <td style="width:14%">仓库名称</td>
                            <td width="1%">|</td>
                            <td style="width:20%">仓库地址</td>
                            <td width="1%">|</td>
                            <td style="width:10%">仓库负责人</td>
                            <td width="1%">|</td>
                            <td style="width:10%">仓库状态</td>
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
            <c:forEach var="row" items="${pageDataList}" varStatus="status">
                <tr class="dataRow">
                	<td style="width:10px;">&nbsp;</td>
                    <td style="width:14%" title="${row.orgName}">${row.orgName}</td>
                    <td width="1%">&nbsp;</td>
                    <td style="width:10%" title="${row.warehouseCode}">${row.warehouseCode}</td>
                    <td width="1%">&nbsp;</td>
                    <td style="width:14%" title="${row.warehouseName}">${row.warehouseName}</td>
                    <td width="1%">&nbsp;</td>
                    <td style="width:20%" title="${row.address}">${row.address}</td>
                    <td width="1%">&nbsp;</td>
                    <td style="width:10%" title="${row.directorName}">${row.directorName}</td>
                    <td width="1%">&nbsp;</td>
                    <c:if test="${row.status == 1}">
                    	<td style="width:10%" title="启用">启用</td>
                    </c:if>
                    <c:if test="${row.status == 2}">
                    	<td style="width:10%" title="停用">停用</td>
                    </c:if>
                    <c:if test="${row.status == 3}">
                    	<td style="width:10%" title="盘点中">盘点中</td>
                    </c:if>
                    <td width="1%">&nbsp;</td>
                    <td style="width:*%">
                        <span><a href="#" onclick="showBox('warehouses.do?method=warehouseDetails&curWarehouseCode=${row.warehouseCode}','仓库详情', 550, 800);">详情</a></span>&nbsp;|
                        <span><a href="#" onclick="showBox('warehouses.do?method=modifyWarehouseInit&curWarehouseCode=${row.warehouseCode}','修改仓库信息', 550, 800);">修改</a></span>&nbsp;|
                        <span><a href="#" onclick="deleteWarehousePrompt('${row.warehouseCode}');">删除</a></span>
                    </td>
                </tr>
            </c:forEach>
        </table>
        ${pageStr}
    </div>
</body>
</html>
