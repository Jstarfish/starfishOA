<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/views/common/taglibs.jsp"%>
<html>
<head>

<title>物品出库详情</title>

<%@ include file="/views/common/meta.jsp" %>
<link rel="stylesheet" type="text/css" href="${basePath}/css/style.css"/>
<link rel="stylesheet" type="text/css" href="${basePath}/css/pop-up.css"/>
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
				<td width="30%" align="right">出库单编号：</td>
				<td width="20%" align="left">${iiNo}</td>
				<td width="25%" align="right">&nbsp;</td>
				<td width="25%" align="left">&nbsp;</td>
			</tr>
			<tr>
				<td width="30%" align="right">操作人：</td>
				<td width="20%" align="left">${operAdminName}</td>
				<td width="25%" align="right">&nbsp;</td>
				<td width="25%" align="left">&nbsp;</td>
			</tr>
			<tr>
				<td width="30%" align="right">收货单位：</td>
				<td width="20%" align="left">${receiveOrgName}</td>
				<td width="25%" align="right">&nbsp;</td>
				<td width="25%" align="left">&nbsp;</td>
			</tr>
			<tr>
				<td width="30%" align="right">发货单位：</td>
				<td width="20%" align="left">${sendOrgName}</td>
				<td width="25%" align="right">&nbsp;</td>
				<td width="25%" align="left">&nbsp;</td>
			</tr>
			<tr>
				<td width="30%" align="right">发货仓库：</td>
				<td width="20%" align="left">${sendWhName}</td>
				<td width="25%" align="right">&nbsp;</td>
				<td width="25%" align="left">&nbsp;</td>
			</tr>
		</table>
		
		<div style="padding:0 20px; margin-top:10px;margin-bottom:10px;">
			<table id="itemList" style="width:100%" class="datatable">
				<tr>
					<th width="1px">&nbsp;</th>
					<th width="31%">物品</th>
					<th width="2%">|</th>
					<th width="31%">数量</th>
					<th width="2%">|</th>
					<th width="*%">单位</th>
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
		
		<div id="remarkDiv" style="padding:0 20px;margin-top:10px;margin-bottom:30px">
			<c:if test="${not empty remark}">
				<textarea id="remark" name="remark" rows="5" style="width:100%;text-align:left" class="address-area" readonly="readonly">${remark}</textarea>
			</c:if>
		</div>
	</div>
</body>
</html>