<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/views/common/taglibs.jsp"%>
<html>
<head>

<title>New Warehouse</title>

<%@ include file="/views/common/meta.jsp" %>
<link rel="stylesheet" type="text/css" href="${basePath}/css/style.css"/>
<link rel="stylesheet" type="text/css" href="${basePath}/css/pop-up.css"/>
<link rel="stylesheet" type="text/css" href="${basePath}/css/validate.css"/>
<link rel="stylesheet" href="${basePath}/component/messageBox/myJsBox.css" type="text/css"/>
<link rel="stylesheet" type="text/css" href="${basePath}/css/validate.css"/>

<script type="text/javascript" src="${basePath}/js/myJs.js"></script>
<script type="text/javascript" src="${basePath}/component/messageBox/myJsBox.js"></script>
<script type="text/javascript" src="${basePath}/component/My97DatePicker/WdatePicker.js"></script>
<script type="text/javascript" src="${basePath}/js/jquery/jquery-1.9.1.js"></script>
<script type="text/javascript" src="${basePath}/js/regexEnum.js"></script>

<style type="text/css">
.datatable {
    border-collapse: collapse;
    border:1px solid #ccc;
    background: #fff;
    font-family: "微软雅黑";
    font-size: 12px;
}
.datatable img {
    line-height: 20px;
    vertical-align: middle;
    display:block;
}
.datatable th {
    background-color: #2aa1d9;
    height: 35px;
    line-height: 35px;
    color: #fff;
    text-align: left;
    padding-left: 5px;
    font-size: 12px;
}
.datatable td {
    border-bottom: 1px solid #e4e5e5;
    height: 35px;
    line-height: 35px;
    text-align: left;
    padding-left: 10px;
    font-size: 12px;
}
.datatable caption {
    color: #33517A;
    padding-top: 3px;
    padding-bottom: 8px;
}
.datatable tr:hover, .datatable tr.hilite {
    background-color: #f3f4f4;
    color: #000000;
}
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

function genWarehouseCode(value) {
	var url = "warehouses.do?method=getRecommendedWarehouseCode&orgCode="+value;
	$.ajax({
		url: url,
		dataType: "text",
		async: true,
		success: function(r) {
			$("#warehouseCode").val(r);
		}
	});
}

function genDynamicBox(value) {
	var url = "warehouses.do?method=getUserUnder&orgCode="+value;
	$.ajax({
		url: url,
		dataType: "json",
		async: true,
		success: function(r) {
			$("#dynamicBox").empty();
			var html = '<table style="width:100%" class="datatable">';
			
            html += '<tr>';
            html += '<th width="1px">&nbsp;</th>';
            html += '<th width="12%" align="left">User Code</th>';
            html += '<th width="2%" align="left">|</th>';
            html += '<th width="16%" align="left">User Name</th>';
            html += '<th width="2%" align="left">|</th>';
            html += '<th width="25%" align="left">Real Name</th>';
            html += '<th width="2%" align="left">|</th>';
            html += '<th width="15%" align="left">Contact Phone</th>';
            html += '<th width="2%" align="left">|</th>';
            html += '<th width="10%" style="padding-left:11px;">Director</th>';
            html += '<th width="2%" align="left">|</th>';
            html += '<th width="*%" style="padding-left:8px;">Manager</th>';
            html += '</tr>';
            
			if (r != null && r != '') {
				for (var i = 0; i < r.length; i++) {
					html += '<tr>';
					html += '<td width="1px">&nbsp</td>';
					html += '<td width="12%" title="'+r[i].id+'">'+r[i].id+'</td>';
					html += '<td width="2%">&nbsp;</td>';
					html += '<td width="16%" title="'+r[i].loginId+'">'+r[i].loginId+'</td>';
					html += '<td width="2%">&nbsp;</td>';
					html += '<td width="25%" title="'+r[i].realName+'">'+r[i].realName+'</td>';
					html += '<td width="2%">&nbsp;</td>';
					html += '<td width="15%" title="'+r[i].mobilePhone+'">'+r[i].mobilePhone+'</td>';
					html += '<td width="2%">&nbsp;</td>';
					html += '<td width="10%"><input type="radio" id="contactPerson" name="contactPerson" value="'+r[i].id+'" align="left"></input></td>';
					html += '<td width="2%">&nbsp;</td>';
					html += '<td width="*%"><div style="padding-top:3px;margin:0px"><input type="checkbox" id="warehouseManager" name="warehouseManager" value="'+r[i].id+'" align="left"></input></td>';
					html += '</tr>';
				}
			}
			
			html += '</table>';
			$("#dynamicBox").html(html);
		}
	});
}

$(document).ready(function(){
	//当区域改变时，其他相应的选择框内容改变
	$("#institutionCode").change(function() {
		var val = $("#institutionCode").val();
		if (val != null && val != "") {
			genWarehouseCode(val);
			genDynamicBox(val);
		}
		else {
			$("#warehouseCode").val('');
			$("#dynamicBox").empty();
		}
	});
	
	//提交与提交前校验
    $("#okButton").bind("click", function(){
        var result = true;
        
        if (!doCheck("institutionCode", isNotEmptyString($("#institutionCode").val()), "Can't be empty")) {
            result = false;
        }
        
        if (!doCheck("warehouseCode", isNotEmptyString($("#warehouseCode").val()), "Can't be empty")) {
            result = false;
        }
        
        if (!doCheck("warehouseName", isNotEmptyString($("#warehouseName").val()), "Can't be empty")) {
            result = false;
        }
        
        if (!doCheck("warehouseAddress", isNotEmptyString($("#warehouseAddress").val()), "Can't be empty")) {
            result = false;
        }
        
        if (!doCheck("contactPhone", isNotEmptyString($("#contactPhone").val()), "Can't be empty")) {
            result = false;
        }
        if(result){
	        if (!checkFormComm('newWarehouseForm')) {
	        	result = false;
	        }
        }
        
        if (result) {
            button_off("okButton");
            $("#newWarehouseForm").submit();
        }
    });
});
</script>

</head>
<body>
    <form action="warehouses.do?method=addWarehouse" id="newWarehouseForm" method="POST">
        <div class="pop-body">
            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                <tr>
                    <td align="right" width="25%">Institution：</td>
                    <td align="left" width="30%">
                        <select id="institutionCode" name="institutionCode" class="select-big">
                            <option value="">Please select...</option>
                            <c:forEach var="data" items="${institutionList}" varStatus="status">
                                <option value="${data.orgCode}">${data.orgName}</option>
                            </c:forEach>
                        </select>
                    </td>
                    <td><span id="institutionCodeTip" class="tip_init">*</span></td>
                </tr>
                <tr>
                    <td align="right" width="25%">Warehouse Code：</td>
                    <td align="left" width="30%">
                        <input id="warehouseCode" name="warehouseCode" class="text-big-noedit" readonly="readonly" maxLength="40"/>
                    </td>
                    <td><span id="warehouseCodeTip" class="tip_init">*</span></td>
                </tr>
                <tr>
                    <td align="right" width="25%">Warehouse Name：</td>
                    <td align="left" width="30%">
                        <input id="warehouseName" name="warehouseName" class="text-big" maxLength="40" isCheckSpecialChar="true" cMaxByteLength="500"/>
                    </td>
                    <td><span id="warehouseNameTip" class="tip_init">*</span></td>
                </tr>
                <tr>
                    <td align="right" width="25%">Warehouse Address：</td>
                    <td align="left" width="30%">
                        <textarea id="warehouseAddress" name="warehouseAddress" rows="4" class="address-area" maxlength="600" isCheckSpecialChar="true" cMaxByteLength="500"></textarea>
                    </td>
                    <td><span id="warehouseAddressTip" class="tip_init">*</span></td>
                </tr>
                <tr>
                    <td align="right" width="25%">Contact Phone：</td>
                    <td align="left" width="30%">
                        <input id="contactPhone" name="contactPhone" class="text-big" maxLength="40" isCheckSpecialChar="true" cMaxByteLength="15"/>
                    </td>
                    <td><span id="contactPhoneTip" class="tip_init">*</span>
                    </td>
                </tr>
            </table>
            
            <div id="dynamicBox" style="padding:0 20px; margin-top:10px;margin-bottom:30px;">
                <!-- 动态内容：在选中区域下的用户列表 -->
            </div>
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