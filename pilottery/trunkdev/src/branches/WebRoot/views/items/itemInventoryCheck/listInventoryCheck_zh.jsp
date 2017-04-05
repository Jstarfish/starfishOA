<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/views/common/taglibs.jsp"%>
<html>
<head>

<title>物品盘点列表</title>

<%@ include file="/views/common/meta.jsp" %>
<link rel="stylesheet" type="text/css" href="${basePath}/css/style.css" />
<link rel="stylesheet" href="${basePath}/component/messageBox/myJsBox.css" type="text/css"/>

<script type="text/javascript" src="${basePath}/component/messageBox/myJsBox.js"></script>
<script type="text/javascript" src="${basePath}/component/My97DatePicker/WdatePicker.js"></script>
<script type="text/javascript" src="${basePath}/js/jquery/jquery-1.9.1.js"></script>

<script type="text/javascript" charset="UTF-8">
function updateQuery() {
	$("#itemCheckQueryForm").submit();
}

/*
function clearValues() {
	$("#checkCodeQuery").val('');
	$("#checkNameQuery").val('');
	$("#checkDateQuery").val('');
	$("#warehouseQuery").val('');
}

$(document).ready(function() {
	$("#checkCodeQuery").keydown(function(event) {
        if (event.keyCode == 13) {
            updateQuery();
        }
    });
	$("#checkNameQuery").keydown(function(event) {
        if (event.keyCode == 13) {
            updateQuery();
        }
    });
});
*/

function completeItemCheckPrompt(checkNo, warehouseCode) {
	var msg = "您确认要结束编号为 <b>"+checkNo+"</b> 的盘点吗？";
	showDialog("completeItemCheckAjax('"+checkNo+"','"+warehouseCode+"')", "结束盘点", msg);
}

function completeItemCheckAjax(checkNo, warehouseCode) {
	$.ajax({
		url: "item.do?method=completeItemCheck",
		data: {checkNo: checkNo, warehouseCode: warehouseCode},
		type: "POST",
		dataType: "json",
		success: function(json) {
			if (json.message != '' && json.message != null) {
                closeDialog();
                showError(json.message);
            } else {
                closeDialog();
                window.location.reload();
            }
		}
	});
}

function deleteItemCheckPrompt(checkNo, warehouseCode) {
	var msg = "您确认要删除编号为 <b>"+checkNo+"</b> 的盘点吗?";
	showDialog("deleteItemCheckAjax('"+checkNo+"','"+warehouseCode+"')", "删除盘点", msg);
}

function deleteItemCheckAjax(checkNo, warehouseCode) {
	$.ajax({
		url: "item.do?method=deleteItemCheck",
		data: {checkNo: checkNo, warehouseCode: warehouseCode},
		type: "POST",
		dataType: "json",
		success: function(json) {
			if (json.message != '' && json.message != null) {
                closeDialog();
                showError(json.message);
            } else {
                closeDialog();
                window.location.reload();
            }
		}
	});
}
</script>

</head>
<body>
    <!-- 顶部标题块 -->
    <div id="title">物品盘点列表</div>
    
    <!-- 查询条件块 -->
    <div class="queryDiv">
        <form action="item.do?method=listInventoryCheck" method="POST" id="itemCheckQueryForm">
            <div class="left">
            	<span>盘点编号: <input id="checkCodeQuery" name="checkCode" value="${itemCheckQueryForm.checkCode}" class="text-normal" maxlength="40"/></span>
            	<span>盘点名称: <input id="checkNameQuery" name="checkName" value="${itemCheckQueryForm.checkName}" class="text-normal" maxlength="40"/></span>
            	<span>盘点日期: <input id="checkDateQuery" name="checkDate" value="${itemCheckQueryForm.checkDate}" class="Wdate text-normal" onfocus="WdatePicker({dateFmt:'yyyy-MM-dd',readOnly:true,isShowClear:true,isShowToday:true})" maxlength="40"/></span>
            	<span>盘点仓库: 
            		<select id="warehouseQuery" name="warehouseCode" class="select-normal">
    					<option value="">全部</option>
    					<c:forEach var="wh" items="${whInfoList}" varStatus="status">
                    		<option value="${wh.warehouseCode}" <c:if test="${itemCheckQueryForm.warehouseCode==wh.warehouseCode}">selected</c:if>>${wh.warehouseName}</option>
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
                            <input type="button" value="新增物品盘点" onclick="showBox('item.do?method=addItemCheckInit','新增物品盘点',600,800);" class="button-normal"></input>
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
                            <td style="width:10%">盘点编号</td>
                            <td width="1%">|</td>
                            <td style="width:15%">盘点名称</td>
                            <td width="1%">|</td>
                            <td style="width:14%">盘点日期</td>
                            <td width="1%">|</td>
                            <td style="width:15%">盘点人</td>
                            <td width="1%">|</td>
                            <td style="width:15%">盘点仓库</td>
                            <td width="1%">|</td>
                            <td style="width:10%">盘点状态</td>
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
        	<c:forEach var="data" items="${itemCheckList}" varStatus="status">
	        	<tr class="dataRow">
	        		<td style="width:10px;">&nbsp;</td>
	                <td style="width:10%" title="${data.checkNo}">${data.checkNo}</td>
	                <td width="1%">&nbsp;</td>
	                <td style="width:15%" title="${data.checkName}">${data.checkName}</td>
	                <td width="1%">&nbsp;</td>
	                <td style="width:14%" title="${data.checkDate}">${data.checkDate}</td>
	                <td width="1%">&nbsp;</td>
	                <td style="width:15%" title="${data.checkAdminName}">${data.checkAdminName}</td>
	                <td width="1%">&nbsp;</td>
	                <td style="width:15%" title="${data.checkWarehouseName}">${data.checkWarehouseName}</td>
	                <td width="1%">&nbsp;</td>
	                <c:if test="${data.status==1}">
	                	<td style="width:10%" title="未完成">未完成</td>
	                </c:if>
	                <c:if test="${data.status==2}">
	                	<td style="width:10%" title="已完成">已完成</td>
	                </c:if>
	                <td width="1%">&nbsp;</td>
	                <td style="width:*%">
	                	<c:if test="${data.status==1}"><!-- Not Completed -->
	                		<span><a href="#" onclick="showBox('item.do?method=processItemCheckInit&checkNo=${data.checkNo}&checkName=${data.checkName}&checkDate=${data.checkDate}&checkAdmin=${data.checkAdmin}&checkAdminName=${data.checkAdminName}&checkWarehouse=${data.checkWarehouse}&checkWarehouseName=${data.checkWarehouseName}&status=${data.status}','操作物品盘点', 600, 900);">盘点</a></span>&nbsp;|
	                    	<span><a href="#" onclick="completeItemCheckPrompt('${data.checkNo}','${data.checkWarehouse}');">结束</a></span>&nbsp;|
	                		<span><a href="#" onclick="deleteItemCheckPrompt('${data.checkNo}','${data.checkWarehouse}');">删除</a></span>
	                	</c:if>
	                	<c:if test="${data.status==2}"><!-- Completed -->
	                		<span><a href="#" onclick="showBox('item.do?method=itemCheckDetails&checkNo=${data.checkNo}&checkName=${data.checkName}&checkDate=${data.checkDate}&checkAdmin=${data.checkAdmin}&checkAdminName=${data.checkAdminName}&checkWarehouse=${data.checkWarehouse}&checkWarehouseName=${data.checkWarehouseName}&status=${data.status}','盘点详情', 600, 900);">详情</a></span>&nbsp;|
	                		<span><a href="#" onclick="showPage('item.do?method=printItemCheckSlip&checkNo=${data.checkNo}&checkName=${data.checkName}&checkWarehouseName=${data.checkWarehouseName}','打印盘点单')">打印</a></span>
	                	</c:if>
	                </td>
	            </tr>
        	</c:forEach>
        </table>
        ${pageStr}
    </div>
</body>
</html>
