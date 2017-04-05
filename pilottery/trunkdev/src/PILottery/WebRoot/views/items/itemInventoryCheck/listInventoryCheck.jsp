<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/views/common/taglibs.jsp"%>
<html>
<head>

<title>List of Item Inventory Checks</title>

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
	var msg = "Are you sure you want to complete item check <b>"+checkNo+"</b>?";
	showDialog("completeItemCheckAjax('"+checkNo+"','"+warehouseCode+"')", "Complete Item Check", msg);
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
	var msg = "Are you sure you want to delete item check <b>"+checkNo+"</b>?";
	showDialog("deleteItemCheckAjax('"+checkNo+"','"+warehouseCode+"')", "Delete Item Check", msg);
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
    <div id="title">Item Inventory Check</div>
    
    <!-- 查询条件块 -->
    <div class="queryDiv">
        <form action="item.do?method=listInventoryCheck" method="POST" id="itemCheckQueryForm">
            <div class="left">
            	<span>Check Code: <input id="checkCodeQuery" name="checkCode" value="${itemCheckQueryForm.checkCode}" class="text-normal" maxlength="40"/></span>
            	<span>Check Name: <input id="checkNameQuery" name="checkName" value="${itemCheckQueryForm.checkName}" class="text-normal" maxlength="40"/></span>
            	<span>Check Date: <input id="checkDateQuery" name="checkDate" value="${itemCheckQueryForm.checkDate}" class="Wdate text-normal" onfocus="WdatePicker({dateFmt:'yyyy-MM-dd',readOnly:true,isShowClear:true,isShowToday:true})" maxlength="40"/></span>
            	<span>Warehouse: 
            		<select id="warehouseQuery" name="warehouseCode" class="select-normal">
    					<option value="">All</option>
    					<c:forEach var="wh" items="${whInfoList}" varStatus="status">
                    		<option value="${wh.warehouseCode}" <c:if test="${itemCheckQueryForm.warehouseCode==wh.warehouseCode}">selected</c:if>>${wh.warehouseName}</option>
                		</c:forEach>
    				</select>
   				</span>
            	<input type="button" value="Query" onclick="updateQuery();" class="button-normal"></input>
                <!--<input type="button" value="Clear" onclick="clearValues();" class="button-normal"></input>-->
            </div>
            <div class="right">
                <table width="260" border="0" cellspacing="0" cellpadding="0">
                    <tr style="height:50px;line-height:50px">
                        <td align="right">
                            <input type="button" value="New Inventory Check" onclick="showBox('item.do?method=addItemCheckInit','New Item Check',550,800);" class="button-normal"></input>
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
                            <td style="width:10%">Check Code</td>
                            <td width="1%">|</td>
                            <td style="width:15%">Check Name</td>
                            <td width="1%">|</td>
                            <td style="width:14%">Check Date</td>
                            <td width="1%">|</td>
                            <td style="width:15%">Checked By</td>
                            <td width="1%">|</td>
                            <td style="width:15%">Warehouse</td>
                            <td width="1%">|</td>
                            <td style="width:10%">Status</td>
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
	                	<td style="width:10%" title="Not Completed">Not Completed</td>
	                </c:if>
	                <c:if test="${data.status==2}">
	                	<td style="width:10%" title="Completed">Completed</td>
	                </c:if>
	                <td width="1%">&nbsp;</td>
	                <td style="width:*%">
	                	<c:if test="${data.status==1}"><!-- Not Completed -->
	                		<span><a href="#" onclick="showBox('item.do?method=processItemCheckInit&checkNo=${data.checkNo}&checkName=${data.checkName}&checkDate=${data.checkDate}&checkAdmin=${data.checkAdmin}&checkAdminName=${data.checkAdminName}&checkWarehouse=${data.checkWarehouse}&checkWarehouseName=${data.checkWarehouseName}&status=${data.status}','Process Item Check', 550, 900);">Check</a></span>&nbsp;|
	                    	<span><a href="#" onclick="completeItemCheckPrompt('${data.checkNo}','${data.checkWarehouse}');">Complete</a></span>&nbsp;|
	                		<span><a href="#" onclick="deleteItemCheckPrompt('${data.checkNo}','${data.checkWarehouse}');">Delete</a></span>
	                	</c:if>
	                	<c:if test="${data.status==2}"><!-- Completed -->
	                		<span><a href="#" onclick="showBox('item.do?method=itemCheckDetails&checkNo=${data.checkNo}&checkName=${data.checkName}&checkDate=${data.checkDate}&checkAdmin=${data.checkAdmin}&checkAdminName=${data.checkAdminName}&checkWarehouse=${data.checkWarehouse}&checkWarehouseName=${data.checkWarehouseName}&status=${data.status}','Item Check Details', 550, 900);">Details</a></span>&nbsp;|
	                		<span><a href="#" onclick="showPage('item.do?method=printItemCheckSlip&checkNo=${data.checkNo}&checkName=${data.checkName}&checkWarehouseName=${data.checkWarehouseName}','Item Check Slip')">Print</a></span>
	                	</c:if>
	                </td>
	            </tr>
        	</c:forEach>
        </table>
        ${pageStr}
    </div>
</body>
</html>
