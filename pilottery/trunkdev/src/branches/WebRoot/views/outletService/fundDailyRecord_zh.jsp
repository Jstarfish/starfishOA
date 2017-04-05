<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/views/common/taglibs.jsp"%>
<html>
<head>

<title>资金日结</title>

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
		$("#dealRecordForm").submit();
	}
</script>

</head>
<body>
	<!-- 顶部标题块 -->
	<div id="title">资金日结</div>

	<!-- 查询条件块 -->
	<div class="queryDiv">
		<form action="outlets.do?method=fundDailyRecord" method="POST" id="dealRecordForm">
			<div class="left">
				<span>站点编码: <input id="outletCode" name="outletCode"
					class="text-normal" maxlength="40" value="${agencyForm.outletCode }"/></span> <span>日期: <input id="beginTime"
					name="beginTime" class="Wdate text-normal" value="${agencyForm.beginTime }"
					onfocus="WdatePicker({dateFmt:'yyyy-MM-dd',readOnly:true,maxDate:'%y-%M-{%d}'})" readonly="readonly"
					type="text" />
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
							<td style="width: 20%">站点编码</td>
							<td width="1%">|</td>
							<td style="width: 10%">类型</td>
							<td width="1%">|</td>
							<td style="width: 20%">金额(瑞尔)</td>
							<td width="1%">|</td>
							<td style="width: *%">日期</td>
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
					<td style="width: 20%">${data.outletCode }</td>
					<td width="1%">&nbsp;</td>
					<td style="width: 10%">${data.fundType }</td>
					<td width="1%">&nbsp;</td>
					<td style="width: 20%; text-align: right"><fmt:formatNumber
							value="${data.account }" /></td>
					<td width="1%">&nbsp;</td>
					<td style="width: *%">${data.dateTime }</td>
				</tr>
			</c:forEach>
		</table>
		${pageStr}
	</div>
</body>
</html>
