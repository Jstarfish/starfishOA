<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/views/common/taglibs.jsp"%>
<html>
<head>
<title>Details Payout</title>

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
					<td align="right" width="25%">Record No：</td>
					<td align="left" width="25%">${record.payNo}</td>
					<td align="right" width="25%">Plan Name：</td>
					<td align="left">${record.planName}</td>
				</tr>
				<tr>
					<td align="right">Batch No：</td>
					<td align="left">${record.batchCode}</td>
					<td align="right">Amount：</td>
					<td align="left"><fmt:formatNumber value="${record.amount}" /></td>
				</tr>
				<tr>
					<td align="right">Ticket Information：</td>
					<td align="left"  colspan="3">trunk：${record.trunk}&nbsp;box：${record.box}&nbsp; 
						packages：${record.packages }</td>
				</tr>
				<tr>
					<td align="right">Winner Name：</td>
					<td align="left">${record.winnerName}</td>
					<td align="right">Sex：</td>
					<td align="left">${record.sexEn}</td>
				</tr>
				<tr>
					<td align="right">Age：</td>
					<td align="left">${record.age}</td>
					<td align="right">Contact：</td>
					<td align="left">${record.contact}</td>
				</tr>
				<tr>
					<td align="right">Personal ID：</td>
					<td align="left">${record.personalId}</td>
				</tr>

				<tr>
					<td align="right">Payout Date：</td>
					<td align="left"><fmt:formatDate value="${record.dateOfPayout}"
							pattern="yyyy-MM-dd HH:mm:ss" /></td>
					<td align="right">Operator：</td>
					<td align="left">${record.operaName}</td>
				</tr>
			</table>
		</div>
	</div>

</body>
</html>