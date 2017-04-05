<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/views/common/taglibs.jsp"%>
<html>
<head>

<title>兑奖报表</title>

<%@ include file="/views/common/meta.jsp"%>
<link rel="stylesheet" type="text/css" href="${basePath}/css/style.css" />
<link rel="stylesheet" href="${basePath}/component/messageBox/myJsBox.css"
	type="text/css" />

<script type="text/javascript" src="${basePath}/component/messageBox/myJsBox.js"></script>
<script type="text/javascript"
	src="${basePath}/component/My97DatePicker/WdatePicker.js"></script>
<script type="text/javascript" src="${basePath}/js/jquery/jquery-1.9.1.js"></script>

</head>
<body>
	<!-- 顶部标题块 -->
	<div id="title">兑奖报表</div>

	<!-- 查询条件块 -->
	<div class="queryDiv">
		<form action="report.do?method=getPayoutReport" id="queryForm" method="post">
			<div class="left">
				<span>方案: <select name="planCode" class="select-normal">
						<option value="">--全部--</option>
						<c:forEach var="obj" items="${planList}" varStatus="plan">
							<c:if test="${obj.planCode == form.planCode}">
								<option value="${obj.planCode}" selected="selected">${obj.planName}</option>
							</c:if>
							<c:if test="${obj.planCode != form.planCode}">
								<option value="${obj.planCode}">${obj.planName}</option>
							</c:if>
						</c:forEach>
				</select>
				</span> <span>日期: <input name="beginDate" value="${form.beginDate }"
					class="Wdate text-normal"
					onfocus="WdatePicker({lang:'zh-cn',dateFmt:'yyyy-MM-dd',readOnly:true})" /> - <input
					name="endDate" value="${form.endDate }" class="Wdate text-normal"
					onfocus="WdatePicker({lang:'zh-cn',dateFmt:'yyyy-MM-dd',readOnly:true})" />
				</span> <input type="submit" value="查询" class="button-normal"></input>
			</div>
			<div style="overflow: right;">
				<span style="position: absolute; right: 80px;"> <input type="hidden"
					id="reportTitle" name="reportTitle" value="兑奖报表"> <er:exportReport
						url="${pageContext.request.contextPath }/er/exportReportServlet" types="excel"
						classs="icon-lz" tableId="exportPdf" title="exportPdf"></er:exportReport>
				</span>
			</div>
		</form>
	</div>

	<!-- 列表表头块 -->
	<div id="headDiv">
		<table width="100%" border="0" cellpadding="0" cellspacing="0">
			<tr>
				<td>
					<table class="datatable" id="exportPdf">
						<tr class="headRow">
							<td style="width:10px;" noExp="true">&nbsp;</td>
							<td style="width: 4%">编号</td>
							<td width="1%" noExp="true">|</td>
							<td style="width: 5%">日期</td>
							<td width="1%" noExp="true">|</td>
							<td style="width: 8%">方案名称</td>
							<td width="1%" noExp="true">|</td>
							<td style="width: 8%">1 等奖(瑞尔)</td>
							<td width="1%" noExp="true">|</td>
							<td style="width: 8%">2 等奖(瑞尔)</td>
							<td width="1%" noExp="true">|</td>
							<td style="width: 8%">3 等奖(瑞尔)</td>
							<td width="1%" noExp="true">|</td>
							<td style="width: 8%">4 等奖(瑞尔)</td>
							<td width="1%" noExp="true">|</td>
							<td style="width: 8%">5 等奖(瑞尔)</td>
							<td width="1%" noExp="true">|</td>
							<td style="width: 8%">6 等奖(瑞尔)</td>
							<td width="1%" noExp="true">|</td>
							<td style="width: 8%">7 等奖(瑞尔)</td>
							<td width="1%" noExp="true">|</td>
							<td style="width: 8%">8 等奖(瑞尔)</td>
							<td width="1%" noExp="true">|</td>
							<td style="width: *%">总额(瑞尔)</td>
						</tr>
					</table>
				</td>
				<!-- 表头和下方数据对齐 -->
				<td style="width: 17px; background: #2aa1d9"></td>
			</tr>
		</table>
	</div>

	<!-- 列表内容块 -->
	<div id="bodyDiv">
		<table class="datatable" id="exportPdfData">
			<c:if test="${fn:length(pageDataList) > 0}">
				<tr class="dataRow">
					<td style="width:10px;" noExp="true">&nbsp;</td>
					<td style="width: 4%">统计</td>
					<td width="1%" noExp="true">&nbsp;</td>
					<td style="width: 5%">&nbsp;</td>
					<td width="1%" noExp="true">&nbsp;</td>
					<td style="width: 8%">&nbsp;</td>
					<td width="1%" noExp="true">&nbsp;</td>
					<td style="width: 8%;text-align: right"><fmt:formatNumber value="${sum.onePrize }" /></td>
					<td width="1%" noExp="true">&nbsp;</td>
					<td style="width: 8%;text-align: right"><fmt:formatNumber value="${sum.twoPrize }" /></td>
					<td width="1%" noExp="true">&nbsp;</td>
					<td style="width: 8%;text-align: right"><fmt:formatNumber value="${sum.threePrize }" /></td>
					<td width="1%" noExp="true">&nbsp;</td>
					<td style="width: 8%;text-align: right"><fmt:formatNumber value="${sum.fourPrize }" /></td>
					<td width="1%" noExp="true">&nbsp;</td>
					<td style="width: 8%;text-align: right"><fmt:formatNumber value="${sum.fivePrize }" /></td>
					<td width="1%" noExp="true">&nbsp;</td>
					<td style="width: 8%;text-align: right"><fmt:formatNumber value="${sum.sixPrize }" /></td>
					<td width="1%" noExp="true">&nbsp;</td>
					<td style="width: 8%;text-align: right"><fmt:formatNumber value="${sum.senvenPrize }" /></td>
					<td width="1%" noExp="true">&nbsp;</td>
					<td style="width: 8%;text-align: right"><fmt:formatNumber value="${sum.eightPrize }" /></td>
					<td width="1%" noExp="true">&nbsp;</td>
					<td style="width: *%;text-align: right"><fmt:formatNumber value="${sum.amount }" /></td>
				</tr>
			</c:if>
			<c:forEach var="obj" items="${pageDataList}" varStatus="status">
				<tr class="dataRow">
					<td style="width:10px;" noExp="true">&nbsp;</td>
					<td style="width: 4%">${status.index+1 }</td>
					<td width="1%" noExp="true">&nbsp;</td>
					<td style="width: 5%">${obj.payoutDate }</td>
					<td width="1%" noExp="true">&nbsp;</td>
					<td style="width: 8%">${obj.gameName }</td>
					<td width="1%" noExp="true">&nbsp;</td>
					<td style="width: 8%;text-align: right"><fmt:formatNumber value="${obj.onePrize }" /></td>
					<td width="1%" noExp="true">&nbsp;</td>
					<td style="width: 8%;text-align: right"><fmt:formatNumber value="${obj.twoPrize }" /></td>
					<td width="1%" noExp="true">&nbsp;</td>
					<td style="width: 8%;text-align: right"><fmt:formatNumber value="${obj.threePrize }" /></td>
					<td width="1%" noExp="true">&nbsp;</td>
					<td style="width: 8%;text-align: right"><fmt:formatNumber value="${obj.fourPrize }" /></td>
					<td width="1%" noExp="true">&nbsp;</td>
					<td style="width: 8%;text-align: right"><fmt:formatNumber value="${obj.fivePrize }" /></td>
					<td width="1%" noExp="true">&nbsp;</td>
					<td style="width: 8%;text-align: right"><fmt:formatNumber value="${obj.sixPrize }" /></td>
					<td width="1%" noExp="true">&nbsp;</td>
					<td style="width: 8%;text-align: right"><fmt:formatNumber value="${obj.senvenPrize }" /></td>
					<td width="1%" noExp="true">&nbsp;</td>
					<td style="width: 8%;text-align: right"><fmt:formatNumber value="${obj.eightPrize }" /></td>
					<td width="1%" noExp="true">&nbsp;</td>
					<td style="width: *%;text-align: right"><fmt:formatNumber value="${obj.amount }" /></td>
				</tr>
			</c:forEach>
		</table>
	</div>
</body>
</html>