<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/views/common/taglibs.jsp"%>
<html>
<head>
<title>批次详情</title>

<link rel="stylesheet" type="text/css" href="${basePath}/css/pop-up.css" />

<script type="text/javascript" src="${basePath}/js/myJs.js"></script>
<script type="text/javascript" src="${basePath}/js/jquery/jquery-1.9.1.js"></script>
<script type="text/javascript">
	function doClose() {
		window.parent.closeBox();
	}
</script>
</head>
<body>
	<div id="tck">
		<div class="mid">
			<table width="100%" border="0" cellspacing="0" cellpadding="0">
				<tr>
					<td align="right" width="25%">批次张数(张)：</td>
					<td align="left" width="25%"><fmt:formatNumber value="${tickets.total}" /></td>

				</tr>
				<tr>
					<td align="right">销售数量(张)：</td>
					<td align="left"><fmt:formatNumber value="${tickets.sales}" /></td>
				</tr>
				<tr>
					<td align="right">在途数量(张)：</td>
					<td align="left"><fmt:formatNumber value="${tickets.road}" /></td>
				</tr>
				<tr>
					<td align="right">损毁数量(张)：</td>
					<td align="left"><fmt:formatNumber value="${tickets.damages}" /></td>
				</tr>
				<tr>
					<td align="right">当前库存(张)：</td>
					<td align="left"><fmt:formatNumber value="${tickets.stock}" /></td>
				</tr>
				<tr>
					<td align="right">市场管理员库存(张)：</td>
					<td align="left"><fmt:formatNumber value="${tickets.manager}" /></td>
				</tr>
			</table>
		</div>
	</div>

</body>
</html>