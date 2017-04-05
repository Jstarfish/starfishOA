<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/views/common/taglibs.jsp"%>
<html>
<head>

<title>Register Damaged Item</title>

<%@ include file="/views/common/meta.jsp" %>
<link rel="stylesheet" type="text/css" href="${basePath}/css/style.css"/>
<link rel="stylesheet" type="text/css" href="${basePath}/css/pop-up.css"/>
<link rel="stylesheet" href="${basePath}/component/messageBox/myJsBox.css" type="text/css"/>
<link rel="stylesheet" type="text/css" href="${basePath}/css/validate.css"/>

<script type="text/javascript" src="${basePath}/js/myJs.js"></script>
<script type="text/javascript" src="${basePath}/component/messageBox/myJsBox.js"></script>
<script type="text/javascript" src="${basePath}/component/My97DatePicker/WdatePicker.js"></script>
<script type="text/javascript" src="${basePath}/js/jquery/jquery-1.9.1.js"></script>
<script type="text/javascript" src="${basePath}/js/regexEnum.js"></script>

<style type="text/css">
.address-area {
    border:1px solid #40a7da;
    background-color:#FFF;
    width:200px;
    color:#000;
    font-size:14px;
    vertical-align:middle;
}
</style>

<script type="text/javascript" charset="UTF-8">
function doClose() {
    window.parent.closeBox();
}

//验证非空
function isNotEmptyString(value) {
    return value != '' ? true : false;
}

$(document).ready(function(){
    $("#okButton").bind("click", function(){
        var result = true;
        
        if (!checkFormComm('newItemDamageForm')) {
        	result = false;
        }
        
        if (!doCheck("itemCode", isNotEmptyString($("#itemCode").val()), "Select an item")) {
            result = false;
        }
        
        if (!doCheck("quantity", isNotEmptyString($("#quantity").val()), "Can't be empty")) {
            result = false;
        }
        
        if (isNotEmptyString($("#quantity").val()) && !doCheck("quantity", /^[1-9][0-9]{0,9}$/, "Wrong format")) {
            result = false;
        }
        
        if (!doCheck("baseUnit", isNotEmptyString($("#baseUnit").val()), "Can't be empty")) {
            result = false;
        }
        
        if (!doCheck("warehouseCode", isNotEmptyString($("#warehouseCode").val()), "Select a warehouse")) {
            result = false;
        }
        
        if (result) {
        	button_off("okButton");
            $("#newItemDamageForm").submit();
        }
    });
    
    $("#itemCode").change(function(){
    	var itemCode = $("#itemCode").val();
    	var warehouseCode = $("#warehouseCode").val();
    	
    	if (itemCode != null && itemCode != '' && warehouseCode != null && warehouseCode != '') {
    		getCurrentQuantityAjax(itemCode, warehouseCode);
    	} else {
    		$("#currentQuantity").val('');
    	}
    });
    
	$("#warehouseCode").change(function(){
		var itemCode = $("#itemCode").val();
    	var warehouseCode = $("#warehouseCode").val();
    	
    	if (itemCode != null && itemCode != '' && warehouseCode != null && warehouseCode != '') {
    		getCurrentQuantityAjax(itemCode, warehouseCode);
    	} else {
    		$("#currentQuantity").val('');
    	}
    });
});

function getCurrentQuantityAjax(itemCode, warehouseCode) {
	$.ajax({
		url: "item.do?method=getCurrentQuantity",
		data: {itemCode: itemCode, warehouseCode: warehouseCode},
		type: "GET",
		dataType: "json",
		success: function(quantity) {
			$("#currentQuantity").val(quantity);
		}
	});
}

//根据选择的物品在单位栏显示单位
function displayUnit(obj) {
	var baseUnit = $("#itemCode option:selected").attr('baseUnit');
	if (baseUnit != null && baseUnit != "") {
		$("#baseUnit").val(baseUnit);
	} else {
		$("#baseUnit").val('');
	}
}
</script>

</head>
<body>
    <form action="item.do?method=addItemDamage" id="newItemDamageForm" method="POST">
    
        <div class="pop-body">
            <table width="100%" border="0" cellspacing="0" cellpadding="0" style="margin-bottom:30px">
                <tr>
                	<td align="right" width="25%">Item：</td>
                	<td align="left" width="30%">
                		<select id="itemCode" name="itemCode" class="select-big" onchange="displayUnit(this);">
							<option value="" baseUnit="">Please select..</option>
							<c:forEach var="item" items="${itemList}" varStatus="status">
								<option value="${item.itemCode}" baseUnit="${item.baseUnitName}">${item.itemName}</option>
							</c:forEach>
						</select>
                	</td>
                	<td><span id="itemCodeTip" class="tip_init">*</span></td>
                </tr>
                <tr>
                	<td align="right" width="25%">Quantity Damaged：</td>
                	<td align="left" width="30%">
                		<input id="quantity" name="quantity" class="text-big"/>
                	</td>
                	<td><span id="quantityTip" class="tip_init">*</span></td>
                </tr>
                <tr>
                	<td align="right" width="25%">Unit：</td>
                	<td align="left" width="30%">
                		<input id="baseUnit" name="baseUnit" class="text-big-noedit" readonly="readonly"/>
                	</td>
                	<td><span id="baseUnitTip" class="tip_init">*</span></td>
                </tr>
                <tr>
                	<td align="right" width="25%">Warehouse：</td>
                	<td align="left" width="30%">
                		<select id="warehouseCode" name="warehouseCode" class="select-big">
                			<option value="">Please select..</option>
							<c:forEach var="wh" items="${whInfoList}" varStatus="status">
                            	<option value="${wh.warehouseCode}">${wh.warehouseName}</option>
                        	</c:forEach>
                    	</select>
                	</td>
                	<td><span id="warehouseCodeTip" class="tip_init">*</span></td>
                </tr>
                <tr>
                	<td align="right" width="25%">Current Quantity：</td>
                	<td align="left" width="30%">
                		<input id="currentQuantity" name="currentQuantity" class="text-big-noedit" readonly="readonly"/>
                	</td>
                	<td><span id="baseUnitTip" class="tip_init"></span></td>
                </tr>
                <tr>
                    <td align="right" width="25%">Remark：</td>
                    <td align="left" width="30%">
                        <textarea id="remark" name="remark" rows="6" class="address-area" maxlength="600" isCheckSpecialChar="true" cMaxByteLength="500">Maximum 500 characters.</textarea>
                    </td>
                    <td><span id="remarkTip" class="tip_init"></span></td>
                </tr>
            </table>
        </div>
        
        <div class="pop-footer">
            <span class="left">
                <input id="okButton" type="button" value="Submit" class="button-normal"></input>
            </span>
            <span class="right">
                <input id="cancelButton" type="button" value="Cancel" class="button-normal" onclick="doClose();"></input>
            </span>
        </div>
        
    </form>
</body>
</html>