<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/views/common/taglibs.jsp"%>
<html>
<head>

<title>新增物品盘点</title>

<%@ include file="/views/common/meta.jsp" %>
<link rel="stylesheet" type="text/css" href="${basePath}/css/style.css"/>
<link rel="stylesheet" type="text/css" href="${basePath}/css/pop-up.css"/>
<link rel="stylesheet" type="text/css" href="${basePath}/css/validate.css"/>
<link rel="stylesheet" href="${basePath}/component/messageBox/myJsBox.css" type="text/css"/>
<link rel="stylesheet" type="text/css" href="${basePath}/css/validate.css"/>

<script type="text/javascript" src="${basePath}/js/myJs.js"></script>
<script type="text/javascript" src="${basePath}/component/messageBox/myJsBox_zh.js"></script>
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

function genDynamicBox(value) {
	var url = "item.do?method=getAvailableItemForCheck&warehouseCode="+value;
	$.ajax({
		url: url,
		dataType: "json",
		async: true,
		success: function(r) {
			$("#dynamicBox").empty();
			var html = '<table style="width:100%" class="datatable">';
			
			html += '<tr>';
			html += '<th width="1px">&nbsp;</th>';
            html += '<th width="24%" align="left">物品编号</th>';
            html += '<th width="2%" align="left">|</th>';
            html += '<th width="24%" align="left">物品名称</th>';
            html += '<th width="2%" align="left">|</th>';
            html += '<th width="24%" align="left">储量</th>';
            html += '<th width="2%" align="left">|</th>';
            html += '<th width="*%" style="padding-left:8px;">请勾选</th>';
            html += '</tr>';
            
            if (r != null && r != '') {
            	for (var i = 0; i < r.length; i++) {
            		html += '<tr>';
            		html += '<td width="1px">&nbsp</td>';
					html += '<td width="24%" title="'+r[i].itemCode+'">'+r[i].itemCode+'</td>';
					html += '<td width="2%">&nbsp;</td>';
					html += '<td width="24%" title="'+r[i].itemName+'">'+r[i].itemName+'</td>';
					html += '<td width="2%">&nbsp;</td>';
					html += '<td width="24%" title="'+toThousands(r[i].quantity)+'">'+toThousands(r[i].quantity)+'</td>';
					html += '<td width="2%">&nbsp;</td>';
					html += '<td width="*%"><input type="checkbox" id="checkItemSet" name="checkItemSet" value="'+r[i].itemCode+'" align="left"></input></td>';
					html += '</tr>';
            	}
            }
			
			html += '</table>';
			$("#dynamicBox").html(html);
		}
	});
}

$(document).ready(function(){
	
	$("#warehouseCode").ready(function(){
    	$.ajax({
    		url: "item.do?method=getWarehouseManagerList",
    		data: {warehouseCode: $("#warehouseCode").val()},
    		type: "GET",
    		dataType: "json",
    		success: function(json) {
    			var html;
    			for (var i = 0; i < json.length; i++) {
    				html += '<option value="'+json[i].managerID+'">'+decodeURI(json[i].managerName)+'</option>';
    			}
    			$("#checkAdmin").html(html);
            }
    	});
    	
    	genDynamicBox($("#warehouseCode").val());
	});
	
	$("#warehouseCode").change(function(){
    	$.ajax({
    		url: "item.do?method=getWarehouseManagerList",
    		data: {warehouseCode: $("#warehouseCode").val()},
    		type: "GET",
    		dataType: "json",
    		success: function(json) {
    			var html;
    			for (var i = 0; i < json.length; i++) {
    				html += '<option value="'+json[i].managerID+'">'+decodeURI(json[i].managerName)+'</option>';
    			}
    			$("#checkAdmin").html(html);
            }
    	});
    	
    	genDynamicBox($("#warehouseCode").val());
	});
	
	//提交与提交前校验
    $("#okButton").bind("click", function(){
        var result = true;
        
        if (!checkFormComm('newItemCheckForm')) {
        	result = false;
        }
        
        if (!doCheck("checkName", isNotEmptyString($("#checkName").val()), "不可为空")) {
            result = false;
        }
        
        if (result) {
            button_off("okButton");
            $("#newItemCheckForm").submit();
        }
    });
});
</script>

</head>
<body>
    <form action="item.do?method=addItemCheck" id="newItemCheckForm" method="POST">
        <div class="pop-body">
            <table width="100%" border="0" cellspacing="0" cellpadding="0">
            	<tr>
                    <td align="right" width="25%">盘点名称：</td>
                    <td align="left" width="30%">
                        <input id="checkName" name="checkName" class="text-big" maxLength="120" isCheckSpecialChar="true" cMaxByteLength="100"/>
                    </td>
                    <td width="*%"><span id="checkNameTip" class="tip_init">*</span></td>
                </tr>
            	<tr>
					<td align="right" width="25%">盘点仓库：</td>
					<td align="left" width="30%">
						<select id="warehouseCode" name="warehouseCode" class="select-big">
							<c:forEach var="wh" items="${whInfoList}" varStatus="status">
                            	<option value="${wh.warehouseCode}">${wh.warehouseName}</option>
                        	</c:forEach>
                    	</select>
					</td>
					<td width="*%">&nbsp;</td>
				</tr>
            	<tr>
					<td align="right" width="25%">盘点人：</td>
					<td align="left" width="30%">
						<select id="checkAdmin" name="checkAdmin" class="select-big">
							<!-- 根据填写的仓库编码动态生成 -->
						</select>
					</td>
					<td width="*%">&nbsp;</td>
				</tr>
            </table>
            
            <div id="dynamicBox" style="padding:0 20px; margin-top:10px;margin-bottom:30px;">
                <!-- 动态内容：在选中区域下的用户列表 -->
            </div>
        </div>
        
        <div class="pop-footer">
            <span class="left">
                <input id="okButton" type="button" value="确定" class="button-normal"></input>
            </span>
            <span class="right">
                <input id="cancelButton" type="button" value="取消" class="button-normal" onclick="doClose();"></input>
            </span>
        </div>
    </form>
</body>
</html>