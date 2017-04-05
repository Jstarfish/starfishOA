<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/views/common/taglibs.jsp"%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>查询</title>

<%@ include file="/views/common/meta.jsp"%>
<link rel="stylesheet" type="text/css" href="${basePath}/css/style.css" />
<link rel="stylesheet" href="${basePath}/component/messageBox/myJsBox.css"
	type="text/css" />
<script type="text/javascript" src="${basePath}/component/messageBox/myJsBox_zh.js"></script>
<script type="text/javascript"
	src="${basePath}/component/My97DatePicker/WdatePicker.js"></script>
</head>
<body>
	<div id="title">验票查询</div>
	<!-- 查询条件块 -->
	<div class="queryDiv">
		<form action="checktickets.do?method=inquiryCheckedTickets" id="queryForm"
			method="post">
			<div class="left">
				<span>日期: <input name="paidDate" value="${form.paidDate }"
					class="Wdate text-normal"
					onfocus="WdatePicker({lang:'zh-cn',dateFmt:'yyyy-MM-dd',isShowClear:true,readOnly:true})" />
				</span> <input type="submit" value="查询" class="button-normal"></input>
			</div>
		</form>
	</div>

	<!-- 列表表头块 -->
	<div id="headDiv">
		<table width="100%" border="0" cellpadding="0" cellspacing="0">
			<tr>
				<td>
					<table class="datatable">
						<tr class="headRow">
							<td style="width: 10px;">&nbsp;</td>
							<td style="width: 15%">日期</td>
							<th width="1%">|</th>
							<td style="width: 20%">操作人</td>
							<th width="1%">|</th>
							<td style="width: 20%">扫描(张) </td>
							<th width="1%">|</th>
							<td style="width: 20%">兑奖(张)</td>
							<th width="1%">|</th>
							<td style="width: *%">操作</td>
						</tr>
					</table>
				</td>
				<!-- 表头和下方数据对齐 -->
				<td style="width: 17px; background: #2aa1d9"></td>
			</tr>
		</table>
	</div>
	<div id="bodyDiv">
		<table class="datatable">
			<c:forEach var="data" items="${list}" varStatus="status">
				<tr class="dataRow">
					<td style="width: 10px;">&nbsp;</td>
					<td style="width: 15%"><fmt:formatDate value="${data.paidTime }" pattern="yyyy-MM-dd HH:mm:ss" /></td>
					<td width="1%">&nbsp;</td>
					<td style="width: 20%">${data.paidAdminName}</td>
					<td width="1%">&nbsp;</td>
					<td style="width: 20%">${data.apply_tickets}</td>
					<td width="1%">&nbsp;</td>
					<td style="width: 20%">${data.succ_tickets}</td>
					<td width="1%">&nbsp;</td>
					<td style="width: *%">
						<span><a href="#" onclick="showBox('checktickets.do?method=detailQuiry&flow=${data.payFlow}','详情',550,800)">详情</a></span>
						|
						<span><a href="#" onclick="showBox('checktickets.do?method=getStatisticInfo&flow=${data.payFlow}','统计',550,800)">统计</a></span>
					</td>
				</tr>
			</c:forEach>
		</table>
		${pageStr}
	</div>
</body>
</html>