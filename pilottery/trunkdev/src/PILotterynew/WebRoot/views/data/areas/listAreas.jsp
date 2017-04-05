<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/views/common/taglibs.jsp"%>
<html>
<head>

<title>List of Administrative Areas</title>

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
		$("#queryForm").submit();
	}
</script>

</head>
<body>
	<!-- 顶部标题块 -->
	<div id="title">Administrative Areas</div>

	<!-- 查询条件块 -->
	<div class="queryDiv">
		<form action="areas.do?method=listAreas" id="queryForm" method="post">
			<div class="left">
				<span>Area Code：<input name="areaCode" class="text-normal" maxlength="20"
					value="${areaForm.areaCode }" oninput="this.value=this.value.replace(/\D/g,'')"
					autocomplete="off" /></span> <span>Area Name：<input name="areaName"
					maxlength="100" class="text-normal" value="${areaForm.areaName }" /></span> <input
					type="button" onclick="updateQuery();" value="Query" class="button-normal"></input>
			</div>
		</form>
	</div>

	

	<!-- 列表内容块 -->
	<div id="headDiv">
		<table width="100%" border="0" cellpadding="0" cellspacing="0">
			<tr>
				<td>
					<table class="datatable">
						<tr class="headRow">
							<td style="width: 10px;">&nbsp;</td>
							<td style="width: 10%">Area Code</td>
							<th width="1%">|</th>
							<td style="width: 25%">Area Name</td>
							<th width="1%">|</th>
							<td style="width: 6%">Level</td>
							<th width="1%">|</th>
							<td style="width: 25%">Super Name</td>
							<th width="1%">|</th>
							<td style="width: *">Area Status</td>

						</tr>
					</table>
				</td>
				<td style="width: 17px; background: #2aa1d9"></td>
			</tr>
		</table>
	</div>
	<div id="bodyDiv">
		<table class="datatable">
			<c:forEach var="item" items="${pageAreaList}" varStatus="status">
				<c:choose>
					<c:when test="${item.areaName==item.parentAreaName }">
						<tr class="dataRow">
							<td style="width: 10px;">&nbsp;</td>
							<td style="width: 10%">${item.areaCode}</td>
							<td width="1%">&nbsp;</td>
							<td style="width: 25%" title="${item.areaName}">${item.areaName}</td>
							<td width="1%">&nbsp;</td>
							<td style="width: 6%">${item.statusShow}</td>
							<td width="1%">&nbsp;</td>
							<td style="width: 25%">--</td>
							<td width="1%">&nbsp;</td>
							<td style="width: *%">${item.typeShow}</td>
						</tr>
					</c:when>
					<c:otherwise>
						<tr class="dataRow">
							<td style="width: 10px;">&nbsp;</td>
							<td style="width: 10%">${item.areaCode}</td>
							<td width="1%">&nbsp;</td>
							<td style="width: 25%" title="${item.areaName}">${item.areaName}</td>
							<td width="1%">&nbsp;</td>
							<td style="width: 6%">${item.statusShow}</td>
							<td width="1%">&nbsp;</td>
							<td style="width: 25%" title="${item.parentAreaName}">${item.parentAreaName}</td>
							<td width="1%">&nbsp;</td>
							<td style="width: *%">${item.typeShow}</td>
						</tr>
					</c:otherwise>
				</c:choose>
			</c:forEach>
		</table>
		${pageStr}
	</div>
</body>
</html>