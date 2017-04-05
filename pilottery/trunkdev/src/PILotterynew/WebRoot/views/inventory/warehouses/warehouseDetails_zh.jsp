<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/views/common/taglibs.jsp"%>
<html>
<head>

<title>仓库详情</title>

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
    width:91.9%;
    color:#000;
    font-size:14px;
    vertical-align:middle;
}
</style>

</head>
<body style="text-align:center">
	<div class="pop-body">
		<table width="100%" border="0" cellspacing="0" cellpadding="0" style="padding:0 20px;">
			<tr>
				<td width="25%" align="right">仓库编号：</td>
				<td width="20%" align="left">${details.warehouseCode}</td>
				<td width="25%" align="right">仓库名称：</td>
				<td width="30%"  align="left">${details.warehouseName}</td>
			</tr>
			<tr>
				<td width="25%" align="right">机构编号：</td>
				<td width="20%" align="left">${details.orgCode}</td>
				<td width="25%" align="right">机构名称：</td>
				<td width="30%" align="left">${details.orgName}</td>
			</tr>
			<tr>
				<td width="25%" align="right">联系电话：</td>
				<td width="20%" align="left">${details.phone}</td>
				<td width="25%" align="right">负责人：</td>
				<td width="30%" align="left">${details.directorName}</td>
			</tr>
			<tr>
				<td width="25%" align="right">仓库状态：</td>
				<td width="*%" align="left" colspan="3">
					<c:if test="${details.status == 1}">启用</c:if>
					<c:if test="${details.status == 2}">停用</c:if>
					<c:if test="${details.status == 3}">盘点中</c:if>
				</td>
			</tr>
			<tr>
				<td width="25%" align="right">仓库地址：</td>
				<td width="*%" align="left" colspan="3" style="word-break:break-all">${details.address}</td>
			</tr>
		</table>
		
		<div style="padding:0 20px; margin-top:10px;margin-bottom:30px;">
			<table style="width:100%" class="datatable">
				<tr>
					<th width="1px">&nbsp;</th>
					<th width="24%">管理员编号</th>
					<th width="2%">|</th>
					<th width="24%">管理员名称</th>
					<th width="2%">|</th>
					<th width="24%">真实名称</th>
					<th width="2%">|</th>
					<th width="*%">联系电话</th>
				</tr>
				<c:forEach var="row" items="${managers}" varStatus="status">
					<tr>
						<td width="1px">&nbsp;</td>
						<td width="24%" title="${row.managerID}">${row.managerID}</td>
						<td width="2%">&nbsp;</td>
						<td width="24%" title="${row.userName}">${row.userName}</td>
						<td width="2%">&nbsp;</td>
						<td width="24%" title="${row.managerName}">${row.managerName}</td>
						<td width="2%">&nbsp;</td>
						<td width="*%" title="${row.phone}">${row.phone}</td>
					</tr>
				</c:forEach>
			</table>
		</div>
	</div>
</body>
</html>