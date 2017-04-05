<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/views/common/taglibs.jsp"%>
<html>
<head>

<title>Item Issue Details</title>

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

#itemList td{
    padding-left: 10px;
}

#itemList th{
    padding-left: 10px;
}
</style>

</head>
<body style="text-align:center">
	<div class="pop-body">
		<table width="100%" border="0" cellspacing="0" cellpadding="0">
			<tr>
				<td width="30%" align="right">Issue Code：</td>
				<td width="20%" align="left">${iiNo}</td>
				<td width="25%" align="right">&nbsp;</td>
				<td width="25%" align="left">&nbsp;</td>
			</tr>
			<tr>
				<td width="30%" align="right">Processed By：</td>
				<td width="20%" align="left">${operAdminName}</td>
				<td width="25%" align="right">&nbsp;</td>
				<td width="25%" align="left">&nbsp;</td>
			</tr>
			<tr>
				<td width="30%" align="right">Receiving Unit：</td>
				<td width="20%" align="left">${receiveOrgName}</td>
				<td width="25%" align="right">&nbsp;</td>
				<td width="25%" align="left">&nbsp;</td>
			</tr>
			<tr>
				<td width="30%" align="right">Delivering Unit：</td>
				<td width="20%" align="left">${sendOrgName}</td>
				<td width="25%" align="right">&nbsp;</td>
				<td width="25%" align="left">&nbsp;</td>
			</tr>
			<tr>
				<td width="30%" align="right">Delivering Warehouse：</td>
				<td width="20%" align="left">${sendWhName}</td>
				<td width="25%" align="right">&nbsp;</td>
				<td width="25%" align="left">&nbsp;</td>
			</tr>
		</table>
		
		<div style="padding:0 20px; margin-top:10px;margin-bottom:30px;">
			<table id="itemList" style="width:100%" class="datatable">
				<tr>
					<th width="1px">&nbsp;</th>
					<th width="31%">Item</th>
					<th width="2%">|</th>
					<th width="31%">Quantity</th>
					<th width="2%">|</th>
					<th width="*%">Unit</th>
				</tr>
				<c:forEach var="item" items="${itemList}" varStatus="status">
					<tr>
						<td width="1px">&nbsp;</td>
						<td width="31%" title="${item.itemName}">${item.itemName}</td>
						<td width="2%">&nbsp;</td>
						<td width="31%" title='<fmt:formatNumber value="${item.quantity}"/>'><fmt:formatNumber value="${item.quantity}"/></td>
						<td width="2%">&nbsp;</td>
						<td width="*%" title="${item.baseUnit}">${item.baseUnit}</td>
					</tr>
				</c:forEach>
			</table>
		</div>
	</div>
</body>
</html>