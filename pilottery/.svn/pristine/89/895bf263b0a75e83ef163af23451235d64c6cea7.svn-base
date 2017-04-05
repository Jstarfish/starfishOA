<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/views/common/taglibs.jsp"%>
<html>
<head>

<title>物流查询</title>

<%@ include file="/views/common/meta.jsp"%>
<link rel="stylesheet" type="text/css" href="${basePath}/css/style.css" />
<link rel="stylesheet" href="${basePath}/component/messageBox/myJsBox.css"
	type="text/css" />
<script type="text/javascript" src="${basePath}/component/messageBox/myJsBox.js"></script>
<script type="text/javascript"
	src="${basePath}/component/My97DatePicker/WdatePicker.js"></script>
<script type="text/javascript" src="${basePath}/js/jquery/jquery-1.9.1.js"></script>

<script type="text/javascript" charset="UTF-8">
	function doSubmit() {
		document.getElementById("queryForm").submit();
	}
</script>

</head>
<body>
	<!-- 顶部标题块 -->
	<div id="title">物流信息</div>
	<!-- 查询条件块 -->
	<div class="queryDiv">
		<form action="logistics.do?method=initLogistics" id="queryForm" method="POST">
			<div class="center">
				<span>物流编码: <input name="logisticsCode"
					id="logisticsCode" class="text-normal" maxlength="34" /></span> <input type="button"
					value="查询" onclick="doSubmit();" class="button-normal"></input>
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
							<td>日期</td>
							<th width="1%">|</th>
							<td>仓库</td>
							<th width="1%">|</th>
							<td>类型</td>
							<th width="1%">|</th>
							<td>操作人</td>
						</tr>
					</table>
				</td>
				<!-- 表头和下方数据对齐 -->
				<td style="width: 17px; background: #2aa1d9"></td>
			</tr>

			<div id="bodyDiv">
				<table class="datatable">
					<c:if test="${form!=null }">
						<tr class="dataRow">
							<td style="width: 10px;">&nbsp;</td>
							<td width="1%">&nbsp;</td>
							<td><fmt:formatDate value="${form.payoutDate }"
									pattern="yyyy-MM-dd HH:mm:ss" /></td>
							<td width="1%">&nbsp;</td>
							<td>兑奖站点--${form.outlet}</td>
							<td></td>
							<td></td>
						</tr>
					</c:if>
					<c:forEach var="data" items="${logistics}" varStatus="status">
						<tr class="dataRow">
							<td style="width: 10px;">&nbsp;</td>
							<td><fmt:formatDate value="${data.time }" pattern="yyyy-MM-dd HH:mm:ss" /></td>
							<td width="1%">&nbsp;</td>
							<td>${data.wareHouseType}</td>
							<td width="1%">&nbsp;</td>
							<td>${data.type}</td>
							<td width="1%">&nbsp;</td>
							<td>${data.operatorName}</td>
						</tr>
					</c:forEach>
				</table>
			</div>
		</table>
	</div>
</body>
</html>