<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/views/common/taglibs.jsp"%>
<html>
<head>

<title>物品损毁详情</title>

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
</style>

</head>
<body style="text-align:center">
	<div class="pop-body">
		<table width="100%" border="0" cellspacing="0" cellpadding="0" style="padding:0 20px;margin-bottom:30px;">
			<tr>
				<td width="25%" align="right">登记编号：</td>
				<td width="20%" align="left">${idNo}</td>
				<td width="25%" align="right">登记日期：</td>
				<td width="30%" align="left">${damageDate}</td>
			</tr>
			<tr>
				<td width="25%" align="right">损毁物品编码：</td>
				<td width="20%" align="left">${itemCode}</td>
				<td width="25%" align="right">损毁物品名称：</td>
				<td width="30%" align="left">${itemName}</td>
			</tr>
			<tr>
				<td width="25%" align="right">登记仓库编码：</td>
				<td width="20%" align="left">${warehouseCode}</td>
				<td width="25%" align="right">登记仓库名称：</td>
				<td width="30%" align="left">${warehouseName}</td>
			</tr>
			<tr>
				<td width="25%" align="right">损毁数量：</td>
				<td width="20%" align="left"><fmt:formatNumber value="${quantity}"/></td>
				<td width="25%" align="right">登记人：</td>
				<td width="30%" align="left">${checkAdminName}</td>
			</tr>
			<tr>
				<td width="25%" align="right">备注：</td>
				<td width="75%" align="left" colspan="3" style="word-break:break-all;">${remark}</td>
			</tr>
		</table>
	</div>
</body>
</html>