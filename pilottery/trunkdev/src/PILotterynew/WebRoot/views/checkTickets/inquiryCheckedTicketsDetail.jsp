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
					<th width="10%">Plan Name</th>
					<th width="1%">|</th>
					<th width="20%">Scan Tickets(tickts)</th>
					<th width="1%">|</th>
					<th width="20%">Winning Quantity(tickts)</th>
					<th width="1%">|</th>
					<th width="20%">Winning Amount(riels)</th>
					<th width="1%">|</th>
					<th width="*%">Winning Amount(USD)</th>
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
						<td width="10%">Total</td>
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
						<th width="8%">No.</th>
						<th width="1%">|</th>
						<th width="30%">Ticket No</th>
						<th width="1%">|</th>
						<th width="20%">Winning Amount(tickts)</th>
						<th width="1%">|</th>
						<th width="20%">Status</th>
						<th width="1%">|</th>
						<th width="*%">Identification</th>
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
									<c:when test="${data.paidStatusEn=='Reject Payout'}">
										<span style="font-weight: bold; color: red;">${data.paidStatusEn}</span>
									</c:when>
									<c:when test="${data.paidStatusEn=='Cashed'}">
										<span style="font-weight: bold; color: blue">${data.paidStatusEn}</span>
									</c:when>
									<c:when test="${data.paidStatusEn=='Not Win'}">
										<span style="font-weight: bold; color: ff8000">${data.paidStatusEn}</span>
									</c:when>
									<c:otherwise>${data.paidStatusEn}</c:otherwise>
								</c:choose>
							</td>
							<td width="1%"></td>
							<td width="*%">
								<c:choose>
									<c:when test="${data.paidStatusEn=='Reject Payout'}">
										<c:choose>
											<c:when test="${data.isNew==1}">
												<span style="font-weight: bold; color: red;">In System</span>
											</c:when>
											<c:otherwise>
												<span style="font-weight: bold; color: red;">Out System</span>										
											</c:otherwise>
										</c:choose>
									</c:when>
									<c:when test="${data.paidStatusEn=='Cashed'}">
										<c:choose>
											<c:when test="${data.isNew==1}">
												<span style="font-weight: bold; color: blue;">In System</span>
											</c:when>
											<c:otherwise>
												<span style="font-weight: bold; color: blue;">Out System</span>										
											</c:otherwise>
										</c:choose>
									</c:when>
									<c:when test="${data.paidStatusEn=='Not Win'}">
										<c:choose>
											<c:when test="${data.isNew==1}">
												<span style="font-weight: bold; color: ff8000">In System</span>
											</c:when>
											<c:otherwise>
												<span style="font-weight: bold; color: ff8000">Out System</span>										
											</c:otherwise>
										</c:choose>
									</c:when>
									<c:otherwise>
										<c:choose>
											<c:when test="${data.isNew==1}">
												<span style="font-weight: bold; color: red;">In System</span>
											</c:when>
											<c:otherwise>Out System</c:otherwise>
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