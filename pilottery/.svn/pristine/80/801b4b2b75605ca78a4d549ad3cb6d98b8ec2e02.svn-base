<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/views/common/taglibs.jsp"%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Inquiry Tickets</title>

<%@ include file="/views/common/meta.jsp"%>
<link rel="stylesheet" type="text/css" href="${basePath}/css/style.css" />
<link rel="stylesheet" href="${basePath}/component/messageBox/myJsBox.css"
	type="text/css" />
<script type="text/javascript" src="${basePath}/component/messageBox/myJsBox.js"></script>
<script type="text/javascript"
	src="${basePath}/component/My97DatePicker/WdatePicker.js"></script>
</head>
<body>
	<div id="title">Inquiry Tickets</div>
	<!-- 查询条件块 -->
	<div class="queryDiv">
		<form action="checktickets.do?method=inquiryCheckedTickets" id="queryForm"
			method="post">
			<div class="left">
				<span>Date: <input name="paidDate" value="${form.paidDate }"
					class="Wdate text-normal"
					onfocus="WdatePicker({dateFmt:'yyyy-MM-dd',isShowClear:true,readOnly:true})" />
				</span> <input type="submit" value="Query" class="button-normal"></input>
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
							<td style="width: 15%">Date</td>
							<th width="1%">|</th>
							<td style="width: 20%">Operator</td>
							<th width="1%">|</th>
							<td style="width: 20%">Scan Tickets(tickets)</td>
							<th width="1%">|</th>
							<td style="width: 20%">Payout Tickets(tickets)</td>
							<th width="1%">|</th>
							<td style="width: *%">Operation</td>
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
						<span><a href="#" onclick="showBox('checktickets.do?method=detailQuiry&flow=${data.payFlow}','Details',550,800)">Details</a></span>
						|
						<span><a href="#" onclick="showBox('checktickets.do?method=getStatisticInfo&flow=${data.payFlow}','Statistics',550,800)">Statistics</a></span>
					</td>
				</tr>
			</c:forEach>
		</table>
		${pageStr}
	</div>
</body>
</html>