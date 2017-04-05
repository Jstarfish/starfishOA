<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/views/common/taglibs.jsp"%>
<html>
<head>

<title>Inquiry Detail</title>

<%@ include file="/views/common/meta.jsp"%>

<link rel="stylesheet" type="text/css" href="${basePath}/css/pop-up.css" />
<script type="text/javascript" src="${basePath}/component/messageBox/myJsBox.js"></script>
<script type="text/javascript" src="${basePath}/component/My97DatePicker/WdatePicker.js"></script>
<script type="text/javascript" src="${basePath}/js/jquery/jquery-1.9.1.js"></script>
</head>
<body style="text-align: center">
	<div style="position: relative; z-index: 1000px; padding: 0 10px; margin-bottom: 0px;margin-top: 25px;">
		<table class="datatable" id="table1_head" width="100%">
			<tbody>
				<tr>
					<th width="20%">方案名称</th>
					<th width="1%">|</th>
					<th width="25%">奖级</th>
					<th width="1%">|</th>
					<th width="25%">中奖数量(张)</th>
					<th width="1%">|</th>
					<th width="*%">中奖金额(瑞尔)</th>
				</tr>
			</tbody>
		</table>
	</div>
	<div id="box" style="padding: 0 10px; margin-bottom: 15px;">
		<table id="fatable" class="datatable" cellpadding="0 " cellspacing="0" width="100%">
			<tbody>
				<c:forEach var="data" items="${list}">
					<tr>
						<td width="20%">${data.planName }</td>
						<td width="1%"></td>
						<td width="25%"><fmt:formatNumber value='${data.levelAmount }' /></td>
						<td width="1%"></td>
						<td width="25%"><fmt:formatNumber value='${data.winTickets}' /></td>
						<td width="1%"></td>
						<td width="*%" style="text-align: right"><fmt:formatNumber value="${data.winAmount}" type="number"/></td>
					</tr>
				</c:forEach>
			</tbody>
		</table>
	</div>
</body>
</html>