<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/views/common/taglibs.jsp"%>
<html>
<head>

<title>Item Check Details</title>

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
    padding-left: 10px;
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

#itemCheckList td{
    padding-left: 10px;
}

#itemCheckList th{
    padding-left: 10px;
}
</style>

<script type="text/javascript" charset="UTF-8">
$(document).ready(function(){
	var row = $("#itemCheckList tr[name=itemCheckRow]");
	row.each(function(){
		var beforeQuantity = $(this).find("#beforeQuantity").text();
		beforeQuantity = parseInt(beforeQuantity);
		
		var checkQuantity = $(this).find("#checkQuantity").text();
		checkQuantity = parseInt(checkQuantity);
		
		var discrepancy = checkQuantity - beforeQuantity;
		$(this).find("#discrepancy").text(discrepancy);
		$(this).find("#discrepancyRow").attr("title",discrepancy);
		
		if (discrepancy > 0) {
			$(this).find("#result").text("Surplus");
			$(this).find("#resultRow").attr("title","Surplus");
			$(this).find("#result").css("color","blue");
		} else if (discrepancy < 0) {
			$(this).find("#result").text("Deficit");
			$(this).find("#resultRow").attr("title","Deficit");
			$(this).find("#result").css("color","red");
		} else {
			$(this).find("#result").text("Balanced");
			$(this).find("#resultRow").attr("title","Balanced");
			$(this).find("#result").css("color","#878787");
		}
	});
});
</script>

</head>
<body style="text-align:center">
	<div class="pop-body">
		<table width="100%" border="0" cellspacing="0" cellpadding="0">
			<tr>
				<td width="20%" align="right">Check Code：</td>
				<td width="30%" align="left">${checkNo}</td>
				<td width="18%" align="right">Check Name：</td>
				<td width="*%" align="left">${checkName}</td>
			</tr>
			<tr>
				<td width="20%" align="right">Check Date：</td>
				<td width="30%" align="left">${checkDate}</td>
				<td width="18%" align="right">Status：</td>
				<td width="*%" align="left">
					<c:if test="${status==1}">Not completed</c:if>
					<c:if test="${status==2}">Completed</c:if>
				</td>
			</tr>
			<tr>
				<td width="20%" align="right">Operator Code：</td>
				<td width="30%" align="left">${checkAdmin}</td>
				<td width="18%" align="right">Operator Name：</td>
				<td width="*%" align="left">${checkAdminName}</td>
			</tr>
			<tr>
				<td width="20%" align="right">Warehouse Code：</td>
				<td width="30%" align="left">${checkWarehouse}</td>
				<td width="18%" align="right">Warehouse Name：</td>
				<td width="*%" align="left">${checkWarehouseName}</td>
			</tr>
		</table>
		
		<div style="padding:0 20px;margin-top:10px;margin-bottom:10px;">
			<table id="itemCheckList" style="width:100%" class="datatable">
				<tr>
					<th width="1px">&nbsp;</th>
					<th width="17%">Item Code</th>
					<th width="2%">|</th>
					<th width="17%">Item Name</th>
					<th width="2%">|</th>
					<th width="15%">Qty Before</th>
					<th width="2%">|</th>
					<th width="15%">Qty Check</th>
					<th width="2%">|</th>
					<th width="15%">Discrepancy</th>
					<th width="2%">|</th>
					<th width="*%">Result</th>
				</tr>
				<c:forEach var="data" items="${itemCheckDetailList}" varStatus="status">
					<tr name="itemCheckRow">
						<td width="1px">&nbsp;</td>
						<td width="17%" title="${data.itemCode}">${data.itemCode}</td>
						<td width="2%">&nbsp;</td>
						<td width="17%" title="${data.itemName}">${data.itemName}</td>
						<td width="2%">&nbsp;</td>
						<td width="15%" title='<fmt:formatNumber value="${data.beforeQuantity}"/>'>
							<span id="beforeQuantity"><fmt:formatNumber value="${data.beforeQuantity}"/></span>
						</td>
						<td width="2%">&nbsp;</td>
						<c:if test="${not empty data.checkQuantity}">
							<td width="15%" title='<fmt:formatNumber value="${data.checkQuantity}"/>'><span id="checkQuantity"><fmt:formatNumber value="${data.checkQuantity}"/></span></td>
						</c:if>
						<c:if test="${empty data.checkQuantity}">
							<td width="15%" title="0"><span id="checkQuantity">0</span></td>
						</c:if>
						<td width="2%">&nbsp;</td>
						<td id="discrepancyRow" width="15%"><span id="discrepancy"></span></td>
						<td width="2%">&nbsp;</td>
						<td id="resultRow" width="*%"><span id="result"></span></td>
					</tr>
				</c:forEach>
			</table>
		</div>
		
		<div id="remarkDiv" style="padding:0 20px;margin-top:10px;margin-bottom:30px">
			<c:if test="${not empty remark}">
				<textarea id="remark" name="remark" rows="5" style="width:100%;text-align:left" class="address-area" readonly="readonly">${remark}</textarea>
			</c:if>
		</div>
	</div>
</body>
</html>