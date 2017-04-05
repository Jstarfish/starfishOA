<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/views/common/taglibs.jsp"%>
<html>
<head>

<title>List of Item Types</title>

<%@ include file="/views/common/meta.jsp" %>
<link rel="stylesheet" type="text/css" href="${basePath}/css/style.css"/>
<link rel="stylesheet" href="${basePath}/component/messageBox/myJsBox.css" type="text/css"/>

<script type="text/javascript" src="${basePath}/component/messageBox/myJsBox.js"></script>
<script type="text/javascript" src="${basePath}/component/My97DatePicker/WdatePicker.js"></script>
<script type="text/javascript" src="${basePath}/js/jquery/jquery-1.9.1.js"></script>

<script type="text/javascript" charset="UTF-8">
function updateQuery() {
    $("#itemTypeQueryForm").submit();
}

/*
function clearValues() {
    $("#itemCodeQuery").val('');
    $("#itemNameQuery").val('');
}
*/

function deleteItemPrompt(itemCode) {
    var msg = "Are you sure you want to delete item <b>" + itemCode + "</b>?";
    showDialog("deleteItemAjax('"+itemCode+"')", "Delete Item", msg);
}

function deleteItemAjax(code) {
    $.ajax({
        url: "item.do?method=deleteItemType",
        data: {itemCode: code},
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

/*
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
    <div id="title">Item Types</div>
    
    <!-- 查询条件块 -->
    <div class="queryDiv">
        <form action="item.do?method=listItemTypes" method="POST" id="itemTypeQueryForm">
            <div class="left">
                <span>Item Code: <input id="itemCodeQuery" name="itemCodeQuery" value="${itemTypeQueryForm.itemCodeQuery}" class="text-normal" maxlength="40"/></span>
                <span>Item Name: <input id="itemNameQuery" name="itemNameQuery" value="${itemTypeQueryForm.itemNameQuery}" class="text-normal" maxlength="40"/></span>
                <input type="button" value="Query" onclick="updateQuery();" class="button-normal"></input>
                <!--<input type="button" value="Clear" onclick="clearValues();" class="button-normal"></input>-->
            </div>
            <div class="right">
                <table width="260" border="0" cellspacing="0" cellpadding="0">
                    <tr style="height:50px;line-height:50px">
                        <td align="right">
                            <input type="button" value="New Item" onclick="showBox('item.do?method=addItemTypeInit','New Item', 300, 650);" class="button-normal"></input>
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
                            <td style="width:25%">Item Code</td>
                            <td width="1%">|</td>
                            <td style="width:25%">Item Name</td>
                            <td width="1%">|</td>
                            <td style="width:25%">Base Unit of Measure</td>
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
            <c:forEach var="data" items="${itemTypeList}" varStatus="status">
	            <tr class="dataRow">
	            	<td style="width:10px;">&nbsp;</td>
	                <td style="width:25%" title="${data.itemCode}">${data.itemCode}</td>
	                <td width="1%">&nbsp;</td>
	                <td style="width:25%" title="${data.itemName}">${data.itemName}</td>
	                <td width="1%">&nbsp;</td>
	                <td style="width:25%" title="${data.baseUnitName}">${data.baseUnitName}</td>
	                <td width="1%">&nbsp;</td>
	                <td style="width:*%">
	                    <span><a href="#" onclick="showBox('item.do?method=modifyItemTypeInit&itemCode=${data.itemCode}&itemName=${data.itemName}&baseUnitName=${data.baseUnitName}','Edit Item', 300, 650);">Edit</a></span>&nbsp;|
	                    <span><a href="#" onclick="deleteItemPrompt('${data.itemCode}');">Delete</a></span>
	                </td>
	            </tr>
            </c:forEach>
        </table>
        ${pageStr}
    </div>
</body>
</html>
