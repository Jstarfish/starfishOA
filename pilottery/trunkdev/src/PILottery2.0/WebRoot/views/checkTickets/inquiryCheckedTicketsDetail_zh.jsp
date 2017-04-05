<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/views/common/taglibs.jsp"%>
<html>
<head>

<title>Inquiry Detail</title>

<%@ include file="/views/common/meta.jsp"%>

<link rel="stylesheet" type="text/css" href="${basePath}/css/pop-up.css" />
<script type="text/javascript" src="${basePath}/component/messageBox/myJsBox.js"></script>
<script type="text/javascript"
	src="${basePath}/component/My97DatePicker/WdatePicker.js"></script>
<script type="text/javascript" src="${basePath}/js/jquery/jquery-1.9.1.js"></script>

</head>
<body style="text-align: center">

	<div
		style="position: relative; z-index: 1000px; padding: 0 0px; margin-bottom: 0px;margin-top: 25px;">

		<table class="datatable" id="table1_head" width="100%">
			<tbody>
				<tr>
					<th width="10%">方案名称</th>
					<th width="1%">|</th>
					<th width="20%">扫描数量(张)</th>
					<th width="1%">|</th>
					<th width="20%">中奖票数量(张)</th>
					<th width="1%">|</th>
					<th width="20%">中奖金额(瑞尔)</th>
					<th width="1%">|</th>
					<th width="*%">中奖金额(美元)</th>
				</tr>
			</tbody>
		</table>
	</div>
	<div id="box" style="padding: 0 0px; margin-bottom: 15px;">

		<table id="fatable" class="datatable" cellpadding="0 " cellspacing="0" width="100%">
			<tbody>
				<c:set var="sumScanTickets" value="0"></c:set>
				<c:set var="sumWinTickets" value="0"></c:set>
				<c:set var="sumWinAmount" value="0"></c:set>
				<c:set var="sumWinAmountUsd" value="0"></c:set>
				
				<c:forEach var="data" items="${pageUp}">
					<tr>
						<td width="10%">${data.planCode }</td>
						<td width="1%"></td>
						<td width="20%"><fmt:formatNumber value='${data.scanTicket }' /></td>
						<td width="1%"></td>
						<td width="20%"><fmt:formatNumber value='${data.winNum}' /></td>
						<td width="1%"></td>
						<td width="20%" style="text-align: right">
							<fmt:formatNumber value="${data.wimAmount}" type="number" />
						</td>
						<td width="1%"></td>
						<td width="*%" style="text-align: right">
							<fmt:formatNumber value="${data.wimAmount/4000}" type="number" />
						</td>
						<c:set var="sumScanTickets" value="${sumScanTickets + data.scanTicket }"></c:set>
						<c:set var="sumWinTickets" value="${sumWinTickets + data.winNum }"></c:set>
						<c:set var="sumWinAmount" value="${sumWinAmount + data.wimAmount }"></c:set>
						<c:set var="sumWinAmountUsd" value="${sumWinAmountUsd + data.wimAmount /4000 }"></c:set>
					</tr>
				</c:forEach>
				<tr style="background-color: #C7C7C7;">
						<td width="10%">合计</td>
						<td width="1%"></td>
						<td width="20%">${sumScanTickets}</td>
						<td width="1%"></td>
						<td width="20%">${sumWinTickets}</td>
						<td width="1%"></td>
						<td width="20%" style="text-align: right">
							<fmt:formatNumber value="${sumWinAmount}" type="number" />
						</td>
						<td width="1%"></td>
						<td width="*%" style="text-align: right">
							<fmt:formatNumber value="${sumWinAmountUsd}" type="number" />
						</td>
					</tr>
			</tbody>
		</table>
	</div>
	<div style="padding: 0 0px;">
		<p align="left">&nbsp;</p>
		<div style="position: relative; z-index: 1000px;">

			<table class="datatable" id="table1_head" width="100%">
				<tbody>
					<tr>
						<th width="8%">序号</th>
						<th width="1%">|</th>
						<th width="30%">票号</th>
						<th width="1%">|</th>
						<th width="20%">奖金(瑞尔)</th>
						<th width="1%">|</th>
						<th width="20%">状态</th>
						<th width="1%">|</th>
						<th width="*%">标识</th>
					</tr>
				</tbody>
			</table>
		</div>
		<div id="box" style="border: 1px solid #ccc;margin-bottom: 25px">

			<table id="fatable" class="datatable" cellpadding="0 " cellspacing="0"
				width="100%">
				<tbody>
					<c:forEach var="data" items="${pageDown}" varStatus="s">
						<tr>
							<td width="8%">${s.index+1 }</td>
							<td width="1%"></td>
							<td width="30%">${data.ticketsNo }</td>
							<td width="1%"></td>
							<td width="20%" style="text-align: right"><c:choose>
									<c:when test="${data.paidStatus==1||data.paidStatus==3}">
										<fmt:formatNumber value='${data.wimAmount }' />
									</c:when>
									<c:otherwise>-</c:otherwise>
								</c:choose></td>
							<td width="1%"></td>
							<td width="20%">	
								<c:choose>
									<c:when test="${data.paidStatusEn=='新票'}">
										<span style="font-weight: bold; color: red;">${data.paidStatusEn}</span>
									</c:when>
									<c:when test="${data.paidStatusEn=='已兑奖'}">
										<span style="font-weight: bold; color: blue">${data.paidStatusEn}</span>
									</c:when>
									<c:when test="${data.paidStatusEn=='未中奖'}">
										<span style="font-weight: bold; color: ff8000">${data.paidStatusEn}</span>
									</c:when>
									<c:otherwise>${data.paidStatusEn}</c:otherwise>
								</c:choose>
							</td>
							<td width="1%"></td>
							<td width="*%">
								<c:choose>
									<c:when test="${data.paidStatusEn=='新票'}">
										<c:choose>
											<c:when test="${data.isNew==1}">
												<span style="font-weight: bold; color: red;">系统中</span>
											</c:when>
											<c:otherwise>
												<span style="font-weight: bold; color: red;">系统外</span>										
											</c:otherwise>
										</c:choose>
									</c:when>
									<c:when test="${data.paidStatusEn=='已兑奖'}">
										<c:choose>
											<c:when test="${data.isNew==1}">
												<span style="font-weight: bold; color: blue;">系统中</span>
											</c:when>
											<c:otherwise>
												<span style="font-weight: bold; color: blue;">系统外</span>										
											</c:otherwise>
										</c:choose>
									</c:when>
									<c:when test="${data.paidStatusEn=='未中奖'}">
										<c:choose>
											<c:when test="${data.isNew==1}">
												<span style="font-weight: bold; color: ff8000">系统中</span>
											</c:when>
											<c:otherwise>
												<span style="font-weight: bold; color: ff8000">系统外</span>										
											</c:otherwise>
										</c:choose>
									</c:when>
									<c:otherwise>
										<c:choose>
											<c:when test="${data.isNew==1}">
												<span style="font-weight: bold; color: red;">系统中</span>
											</c:when>
											<c:otherwise>系统外</c:otherwise>
										</c:choose>
									</c:otherwise>
								</c:choose>
							</td>
						</tr>
					</c:forEach>
				</tbody>
			</table>
		</div>
	</div>
</body>
</html>