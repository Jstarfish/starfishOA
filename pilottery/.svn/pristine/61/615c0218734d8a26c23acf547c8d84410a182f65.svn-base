<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/views/common/taglibs.jsp"%>
<html>
<head>

<title>批次详情</title>

<%@ include file="/views/common/meta.jsp"%>
<link rel="stylesheet" type="text/css" href="${basePath}/css/style.css" />
<link rel="stylesheet" href="${basePath}/component/messageBox/myJsBox.css"
	type="text/css" />
<link rel="stylesheet" type="text/css" href="${basePath}/css/validate.css" />

<script type="text/javascript" src="${basePath}/js/myJs.js"></script>
<script type="text/javascript" src="${basePath}/component/messageBox/myJsBox.js"></script>
<script type="text/javascript"
	src="${basePath}/component/My97DatePicker/WdatePicker.js"></script>
<script type="text/javascript" src="${basePath}/js/jquery/jquery-1.9.1.js"></script>
<script type="text/javascript" src="${basePath}/js/regexEnum.js"></script>

<script type="text/javascript" charset="UTF-8">
	function doClose() {
		window.parent.closeBox();
	}
</script>

</head>
<body>
	<!-- 列表表头块 -->
	<div style="padding: 0 20px; margin-top: 15px;">
		<div style="position: relative; z-index: 1000px;">
			<table class="datatable" id="table1_head" width="100%">
				<tbody>
					<tr class="headRow">
						<td style="width: 10px;">&nbsp;</td>
						<td style="width: 5%">方案</td>
						<td width="2%">|</td>
						<td style="width: 9%">彩票名称</td>
						<td width="2%">|</td>
						<td style="width: 10%">批次</td>
						<td width="2%">|</td>
						<td style="width: 13%">奖组数量</td>
						<td width="2%">|</td>
						<td style="width: 15%">奖组张数(张)</td>
						<td width="2%">|</td>
						<td style="width: 13%">批次总箱数</td>
						<td width="2%">|</td>
						<td style="width: 13%">批次总张数(张)</td>
						<td width="2%">|</td>
						<td style="width: *%">状态</td>
				</tbody>
			</table>
		</div>

		<!-- 列表内容块 -->
		<div id="box" style="border: 1px solid #ccc;">
			<table id="fatable" class="datatable" cellpadding="0 " cellspacing="0"
				width="100%">
				<tbody>
					<c:forEach var="data" items="${batchDetails}" varStatus="status">
						<tr class="dataRow">
							<td style="width: 10px;">&nbsp;</td>
							<td style="width: 5%">${data.planCode}</td>
							<td width="2%">&nbsp;</td>
							<td style="width: 9%">${data.planName}</td>
							<td width="2%">&nbsp;</td>
							<td style="width: 10%">${data.batchNo}</td>
							<td width="2%">&nbsp;</td>
							<td style="width: 13%">${data.ticketsNum}</td>
							<td width="2%">&nbsp;</td>
							<td style="width: 15%"><fmt:formatNumber value="${data.ticketsAccount}" /></td>
							<td width="2%">&nbsp;</td>
							<td style="width: 13%">${data.totalTrunk}</td>
							<td width="2%">&nbsp;</td>
							<td style="width: 13%"><fmt:formatNumber value="${data.totalPaper}" /></td>
							<td width="2%">&nbsp;</td>
							<td style="width: *">${data.statusen}</td>
						</tr>
					</c:forEach>
				</tbody>
			</table>
		</div>
	</div>


</body>
</html>