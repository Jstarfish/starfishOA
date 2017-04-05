<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/views/common/taglibs.jsp"%>
<html>
<head>
<title>兑奖详细信息</title>

<link rel="stylesheet" type="text/css" href="${basePath}/css/pop-up.css" />

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
					<td align="right" width="25%">兑奖编号：</td>
					<td align="left" width="25%">${record.payNo}</td>
					<td align="right" width="25%">方案名称：</td>
					<td align="left">${record.planName}</td>
				</tr>
				<tr>
					<td align="right">批次编号：</td>
					<td align="left">${record.batchCode}</td>
					<td align="right">中奖金额：</td>
					<td align="left"><fmt:formatNumber value="${record.amount}" /></td>
				</tr>
				<tr>
					<td align="right">对奖票信息：</td>
					<td align="left"  colspan="3">箱号：${record.trunk}&nbsp;盒号：${record.box}&nbsp; 
						本号：${record.packages }</td>
				</tr>
				<tr>
					<td align="right">中奖人姓名：</td>
					<td align="left">${record.winnerName}</td>
					<td align="right">性别：</td>
					<td align="left">${record.sexEn}</td>
				</tr>
				<tr>
					<td align="right">年龄：</td>
					<td align="left">${record.age}</td>
					<td align="right">联系方式：</td>
					<td align="left">${record.contact}</td>
				</tr>
				<tr>
					<td align="right">省份证号码：</td>
					<td align="left">${record.personalId}</td>
				</tr>

				<tr>
					<td align="right">兑奖日期：</td>
					<td align="left"><fmt:formatDate value="${record.dateOfPayout}"
							pattern="yyyy-MM-dd HH:mm:ss" /></td>
					<td align="right">操作人：</td>
					<td align="left">${record.operaName}</td>
				</tr>
			</table>
		</div>
	</div>

</body>
</html>