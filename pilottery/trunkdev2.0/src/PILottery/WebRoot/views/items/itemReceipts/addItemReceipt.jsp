<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/views/common/taglibs.jsp"%>
<html>
<head>

<title>New Item Receipt</title>

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
    padding-left: 8px;
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
    width:91.9%;
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
        
        if (result) {
        	button_off("okButton");
            $("#newItemReceiptForm").submit();
        }
    });
    
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
    			$("#warehouseManager").html(html);
            }
    	});
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
    			$("#warehouseManager").html(html);
            }
    	});
    });
});

//动态增加一行物品记录
function addTr(obj) {
	//获得当前最后一行的隐藏index
	var index = $("#itemList tr:last input[type=hidden]").attr('index');
	
	//将当前行复制一份附到最后一行去
	var tr = $(obj).parent().parent().clone();
	tr.appendTo("#itemList");
	
	//更新index以及新增行的各标签名称
	index = parseInt(index) + 1;
	$("#itemList tr:last input[type=hidden]").attr('index', index);
	$("#itemList tr:last select")[0].name = 'itemDetails['+index+'].itemCode';
	$("#itemList tr:last input[type=text]")[0].name = 'itemDetails['+index+'].quantity';
	$("#itemList tr:last input[type=text]")[0].value = '';
	$("#itemList tr:last input[type=text]")[1].name = 'itemDetails['+index+'].baseUnit';
	$("#itemList tr:last input[type=text]")[1].value = '';
}

//动态删除一行物品记录
function delTr(obj) {
	var trlen = $("#itemList tr").length;
	if (trlen == 2) {
		return false;
	}
	$(obj).parent().parent().remove();
}

//根据选择的物品在单位栏显示单位
function displayUnit(obj) {
	var tr = $(obj).parent().parent();
	var baseUnit = tr.find("option:selected").attr('baseUnit');
	if (baseUnit != null && baseUnit != "") {
		tr.find("input[alias=baseUnit]").val(baseUnit);
	} else {
		tr.find("input[alias=baseUnit]").val('');
	}
}

function filterInput(obj) {
	var cursor = obj.selectionStart;
	obj.value = obj.value.replace(/[^\d]/g,'');
	obj.selectionStart = cursor;
	obj.selectionEnd = cursor;
}
</script>

</head>
<body>
	<form id="newItemReceiptForm" method="POST" action="item.do?method=addItemReceipt">
		<div class="pop-body">
			<table width="100%" border="0" cellspacing="0" cellpadding="0">
				<tr>
					<td width="25%" align="right">Warehouse：</td>
					<td width="30%" align="left">
						<select id="warehouseCode" name="warehouseCode" class="select-big">
							<c:forEach var="wh" items="${whInfoList}" varStatus="status">
                            	<option value="${wh.warehouseCode}">${wh.warehouseName}</option>
                        	</c:forEach>
                    	</select>
					</td>
					<td width="*%" >&nbsp;</td>
				</tr>
				<tr>
					<td width="25%" align="right">Processed By：</td>
					<td width="30%" align="left">
						<select id="warehouseManager" name="warehouseManager" class="select-big">
							<!-- 根据填写的仓库编码动态生成 -->
                    	</select>
					</td>
					<td width="*%" >&nbsp;</td>
				</tr>
			</table>
			
			<div style="padding:0 20px; margin-top:10px;margin-bottom:10px;">
				<table id="itemList" style="width:100%" class="datatable">
					<tr>
						<th width="1px">&nbsp;</th>
						<th width="23%" align="left">Item</th>
						<th width="2%" align="left">|</th>
						<th width="23%" align="left">Quantity</th>
						<th width="2%" align="left">|</th>
						<th width="23%" align="left">Unit</th>
						<th width="2%" align="left">|</th>
						<th width="10%" align="left" style="padding-left:9px;">Add</th>
						<th width="2%" align="left">|</th>
						<th width="*%" align="left" style="padding-left:9px;">Delete</th>
					</tr>
					<tr>
						<td width="1px">&nbsp;</td>
						<td width="23%">
							<input type="hidden" index="0"><!-- 用来放index的隐藏tag -->
							<select name="itemDetails[0].itemCode" style="width:150px" onchange="displayUnit(this);">
								<option value="" baseUnit=""></option>
								<c:forEach var="item" items="${itemList}" varStatus="status">
									<option value="${item.itemCode}" baseUnit="${item.baseUnitName}">${item.itemName}</option>
								</c:forEach>
							</select>
						</td>
						<td width="2%">&nbsp;</td>
						<td width="23%"><input type="text" alias="quantity" name="itemDetails[0].quantity" oninput="filterInput(this);" onpropertychange="filterInput(this);" style="width:130px" maxlength="7"></input></td>
						<td width="2%">&nbsp;</td>
						<td width="23%"><input type="text" alias="baseUnit" name="itemDetails[0].baseUnit" readonly="readonly" style="width:130px"/></input></td>
						<td width="2%">&nbsp;</td>
						<td width="10%"><img src="${basePath}/img/add.png"  onclick="addTr(this);" height="16px" width="16px"/></td>
						<td width="2%">&nbsp;</td>
						<td width="*%"><img src="${basePath}/img/cross.png"  onclick="delTr(this);" height="16px" width="16px"/></td>
					</tr>
				</table>
			</div>
			
			<div id="remarkDiv" style="padding:0 20px;margin-top:10px;margin-bottom:30px">
				<textarea id="remark" name="remark" rows="5" style="width:100%;text-align:left" class="address-area" maxlength="500">Please enter your remark here. Maximum 500 characters.</textarea>
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