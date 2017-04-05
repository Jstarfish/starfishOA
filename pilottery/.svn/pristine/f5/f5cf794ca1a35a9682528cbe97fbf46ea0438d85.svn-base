<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/views/common/taglibs.jsp"%>
<html>
<head>

<title>Outlet Deal</title>

<%@ include file="/views/common/meta.jsp"%>
<link rel="stylesheet" type="text/css" href="${basePath}/css/style.css" />
<link rel="stylesheet" href="${basePath}/component/messageBox/myJsBox.css"
	type="text/css" />

<script type="text/javascript" src="${basePath}/component/messageBox/myJsBox.js"></script>
<script type="text/javascript"
	src="${basePath}/component/My97DatePicker/WdatePicker.js"></script>
<script type="text/javascript" src="${basePath}/js/jquery/jquery-1.9.1.js"></script>

<script type="text/javascript" charset="UTF-8">
	function updateQuery() {
		var outletCode = $('#outletCode').val();
		var beginTime = $('#beginTime').val();
		if(outletCode == ''){
			showError('Please Input Outlet Code!');
			return false;
		}
		if(beginTime == ''){
			showError('Please Input Date!');
			return false;
		}
		$("#dealRecordForm").submit();
	}
</script>

</head>
<body>
	<!-- 顶部标题块 -->
	<div id="title">Transaction Records</div>

	<!-- 查询条件块 -->
	<div class="queryDiv">
		<form action="outlets.do?method=queryAgencyDealRecord" method="POST" id="dealRecordForm">
			<div class="left">
				<span>Outlet Code: <input id="outletCode" name="outletCode"
					value="${form.outletCode}" class="text-normal" maxlength="30" /></span> <span>Transaction
					Type: <select id="dealType" name="dealType" class="select-normal">
					<option value="0">All</option>
						<c:forEach var="item" items="${flowTypes }">
							<option value="${item.key }" <c:if test="${item.key == form.dealType}">selected="selected"</c:if>>${item.value }</option>
						</c:forEach>
				</select>
				</span> <span>Date: <input name="beginTime" value="${form.beginTime }" id="beginTime"
					class="Wdate text-normal"
					onfocus="WdatePicker({lang:'en',dateFmt:'yyyy-MM-dd',readOnly:true})" />
					<%--  - <input
					name="endTime" value="${form.endTime }" class="Wdate text-normal"
					onfocus="WdatePicker({lang:'en',dateFmt:'yyyy-MM-dd',readOnly:true})" /> --%>
				</span> <input type="button" value="Query" onclick="updateQuery();"
					class="button-normal"></input>
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
							<td style="width: 20%">Outlet Code</td>
							<td width="1%">|</td>
							<td style="width: 20%">Date</td>
							<td width="1%">|</td>
							<td style="width: 15%">Type</td>
							<td width="1%">|</td>
							<td style="width: *%">Amount(riels)</td>
							
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
		<table class="datatable">
			<c:forEach var="data" items="${pageAgencyList}" varStatus="status">
				<tr class="dataRow">
					<td style="width: 10px;">&nbsp;</td>
					<td style="width: 20%">${data.agencyCode}</td>
					<td width="1%">&nbsp;</td>
					<td style="width: 20%">${data.realTime}</td>
					<td width="1%">&nbsp;</td>
					<td style="width: 15%">${data.dealEnType}</td>
					<td width="1%">&nbsp;</td>
					<td style="width: *%; text-align: right"><fmt:formatNumber value="${data.amount}" /></td>
				</tr>
			</c:forEach>
		</table>
		${pageStr}
	</div>
</body>
</html>
