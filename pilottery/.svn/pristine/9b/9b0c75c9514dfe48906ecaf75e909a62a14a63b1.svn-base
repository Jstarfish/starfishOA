<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/views/common/taglibs.jsp"%>
<html>
<head>

<title>操作物品盘点</title>

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
    text-align: center;
    padding-left: 0px;
    font-size: 12px;
}
.datatable td {
    border-bottom: 1px solid #e4e5e5;
    height: 35px;
    line-height: 35px;
    text-align: center;
    padding-left: 0px;
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

#checkQuantity {
	width:100px;
	text-align:center;
}
</style>

<script type="text/javascript" charset="UTF-8">
function doClose() {
    window.parent.closeBox();
}

function addQuantity(obj) {
	var tr = $(obj).parent().parent();
	
	var checkQuantity = tr.find("#checkQuantity").val();
	checkQuantity = parseInt(checkQuantity) + 1;
	tr.find("#checkQuantity").val(checkQuantity);
	
	var beforeQuantity = tr.find("#beforeQuantity").text();
	beforeQuantity = parseInt(beforeQuantity);
	
	var discrepancy = checkQuantity - beforeQuantity;
	tr.find("#discrepancy").text(discrepancy);
	tr.find("#discrepancyRow").attr("title",discrepancy);
	
	if (discrepancy > 0) {
		tr.find("#result").text("盘盈");
		tr.find("#resultRow").attr("title","盘盈");
		tr.find("#result").css("color","blue");
	} else if (discrepancy < 0) {
		tr.find("#result").text("盘亏");
		tr.find("#resultRow").attr("title","盘亏");
		tr.find("#result").css("color","red");
	} else {
		tr.find("#result").text("一致");
		tr.find("#resultRow").attr("title","一致");
		tr.find("#result").css("color","#878787");
	}
}

function subQuantity(obj) {
	var tr = $(obj).parent().parent();
	
	var checkQuantity = tr.find("#checkQuantity").val();
	checkQuantity = parseInt(checkQuantity) - 1;
	if (checkQuantity < 0) {
		checkQuantity = checkQuantity + 1;
	}
	tr.find("#checkQuantity").val(checkQuantity);
	
	var beforeQuantity = tr.find("#beforeQuantity").text();
	beforeQuantity = parseInt(beforeQuantity);
	
	var discrepancy = checkQuantity - beforeQuantity;
	tr.find("#discrepancy").text(discrepancy);
	tr.find("#discrepancyRow").attr("title",discrepancy);
	
	if (discrepancy > 0) {
		tr.find("#result").text("盘盈");
		tr.find("#resultRow").attr("title","盘盈");
		tr.find("#result").css("color","blue");
	} else if (discrepancy < 0) {
		tr.find("#result").text("盘亏");
		tr.find("#resultRow").attr("title","盘亏");
		tr.find("#result").css("color","red");
	} else {
		tr.find("#result").text("一致");
		tr.find("#resultRow").attr("title","一致");
		tr.find("#result").css("color","#878787");
	}
}

function initQuantity() {
	var row = $("#itemCheckList tr[name=itemCheckRow]");
	row.each(function(){
		var beforeQuantity = $(this).find("#beforeQuantity").text();
		beforeQuantity = parseInt(beforeQuantity);
		
		var checkQuantity = $(this).find("#checkQuantity").val();
	
		if (checkQuantity == null || checkQuantity == undefined || checkQuantity == '') {
			checkQuantity = 0;
			$(this).find("#checkQuantity").val(0);
		}
		checkQuantity = parseInt(checkQuantity);
		
		var discrepancy = checkQuantity - beforeQuantity;
		$(this).find("#discrepancy").text(discrepancy);
		$(this).find("#discrepancyRow").attr("title",discrepancy);
		
		if (discrepancy > 0) {
			$(this).find("#result").text("盘盈");
			$(this).find("#resultRow").attr("title","盘盈");
			$(this).find("#result").css("color","blue");
		} else if (discrepancy < 0) {
			$(this).find("#result").text("盘亏");
			$(this).find("#resultRow").attr("title","盘亏");
			$(this).find("#result").css("color","red");
		} else {
			$(this).find("#result").text("一致");
			$(this).find("#resultRow").attr("title","一致");
			$(this).find("#result").css("color","#878787");
		}
	});
}

function filterInput(obj) {
	var cursor = obj.selectionStart;
	obj.value = obj.value.replace(/[^\d]/g,'');
	obj.selectionStart = cursor;
	obj.selectionEnd = cursor;
}

$(document).ready(function(){
	initQuantity();
	
	$("#okButton").click(function(){
		$("#checkOp").val('1');
		button_off("okButton");
		button_off("completeButton");
		$("#processItemCheckForm").submit();
	});
	
	$("#completeButton").click(function(){
		$("#checkOp").val('2');
		button_off("okButton");
		button_off("completeButton");
		$("#processItemCheckForm").submit();
	});
});
</script>

</head>
<body style="text-align:center">
	<form id="processItemCheckForm" method="POST" action="item.do?method=processItemCheck">
		<div class="pop-body">
			<table width="100%" border="0" cellspacing="0" cellpadding="0">
				<tr>
					<td width="20%" align="right">盘点编号：</td>
					<td width="30%" align="left"><input id="checkNo" name="checkNo" class="text-big-noedit" value="${checkNo}" readonly="readonly" maxLength="40"/></td>
					<td width="18%" align="right">盘点名称：</td>
					<td width="*%" align="left"><input id="checkName" name="checkName" class="text-big-noedit" value="${checkName}" readonly="readonly" maxLength="40"/></td>
				</tr>
				<tr>
					<td width="20%" align="right">盘点日期：</td>
					<td width="30%" align="left"><input id="checkDate" name="checkDate" class="text-big-noedit" value="${checkDate}" readonly="readonly" maxLength="40"/></td>
					<td width="18%" align="right">盘点状态：</td>
					<td width="*%" align="left">
						<c:if test="${status==1}">
							<input id="status" name="status" class="text-big-noedit" value="未完成" readonly="readonly" maxLength="40"/>
						</c:if>
						<c:if test="${status==2}">
							<input id="status" name="status" class="text-big-noedit" value="已完成" readonly="readonly" maxLength="40"/>
						</c:if>
					</td>
				</tr>
				<tr>
					<td width="20%" align="right">盘点人编码：</td>
					<td width="30%" align="left"><input id="checkAdmin" name="checkAdmin" class="text-big-noedit" value="${checkAdmin}" readonly="readonly" maxLength="40"/></td>
					<td width="18%" align="right">盘点人名称：</td>
					<td width="*%" align="left"><input id="checkAdminName" name="checkAdminName" class="text-big-noedit" value="${checkAdminName}" readonly="readonly" maxLength="40"/></td>
				</tr>
				<tr>
					<td width="20%" align="right">盘点仓库编码：</td>
					<td width="30%" align="left"><input id="checkWarehouse" name="checkWarehouse" class="text-big-noedit" value="${checkWarehouse}" readonly="readonly" maxLength="40"/></td>
					<td width="18%" align="right">盘点仓库名称：</td>
					<td width="*%" align="left"><input id="checkWarehouseName" name="checkWarehouseName" class="text-big-noedit" value="${checkWarehouseName}" readonly="readonly" maxLength="40"/></td>
				</tr>
			</table>
			
			<div style="padding:0 20px;margin-top:10px;margin-bottom:10px;">
				<table id="itemCheckList" border="1" style="width:100%" class="datatable">
					<tr>
						<th width="15%">物品编码</th>
						<th width="15%">物品名称</th>
						<th width="15%">盘点前数量</th>
						<th width="15%">盘点数量</th>
						<th width="5%">&nbsp;</th>
						<th width="5%">&nbsp;</th>
						<th width="15%">盘点差异</th>
						<th width="*%">盘点结果</th>
					</tr>
					<c:forEach var="data" items="${itemCheckDetailList}" varStatus="status">
						<tr name="itemCheckRow">
							<td width="15%" title="${data.itemCode}">
								<input type="hidden" name="itemDetails[${status.index}].itemCode" value="${data.itemCode}"/>
								${data.itemCode}
							</td>
							<td width="15%" title="${data.itemName}">
								${data.itemName}
							</td>
							<td width="15%" title="${data.beforeQuantity}">
								<span id="beforeQuantity">${data.beforeQuantity}</span>
							</td>
							<td width="15%">
								<c:if test="${not empty data.checkQuantity}">
									<input id="checkQuantity" name="itemDetails[${status.index}].checkQuantity" value="${data.checkQuantity}" oninput="filterInput(this);initQuantity();" onpropertychange="filterInput(this);initQuantity();" maxLength="10"/>
								</c:if>
								<c:if test="${empty data.checkQuantity}">
									<input id="checkQuantity" name="itemDetails[${status.index}].checkQuantity" oninput="filterInput(this);initQuantity();" onpropertychange="filterInput(this);initQuantity();" maxLength="10"/>
								</c:if>
							</td>
							<td width="5%">
								<img src="${basePath}/img/plus.gif" onclick="addQuantity(this);" height="16px" width="16px" style="padding-left:9px;"/>
							</td>
							<td width="5%">
								<img src="${basePath}/img/minus.gif" onclick="subQuantity(this);" height="16px" width="16px" style="padding-left:9px;"/>
							</td>
							<td id="discrepancyRow" width="15%"><span id="discrepancy"></span></td>
							<td id="resultRow" width="*%"><span id="result"></span></td>
						</tr>
					</c:forEach>
				</table>
			</div>
			
			<div id="remarkDiv" style="padding:0 20px;margin-top:10px;margin-bottom:30px">
				<c:if test="${not empty remark}">
					<textarea id="remark" name="remark" rows="5" style="width:100%;text-align:left" class="address-area" maxlength="500">${remark}</textarea>
				</c:if>
				<c:if test="${empty remark}">
					<textarea id="remark" name="remark" rows="5" style="width:100%;text-align:left" class="address-area" maxlength="500">请输入备注，最多500字节。</textarea>
				</c:if>
				</textarea>
			</div>
		</div>
		
		<div class="pop-footer">
	        <span class="left">
	            <input id="okButton" type="button" value="保存" class="button-normal"></input>
	            <input id="completeButton" type="button" value="保存并结束" class="button-normal"></input>
	            <input type="hidden" name="checkOp" id="checkOp"></input><!-- 隐藏域：是否完成盘点操作 -->
	        </span>
	        <span class="right">
	            <input id="cancelButton" type="button" value="取消" class="button-normal" onclick="doClose();"></input>
	        </span>
	    </div>

    </form>
</body>
</html>