<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ include file="/views/common/meta.jsp" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
<head>
<title>凭证打印</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<link rel="stylesheet" href="${basePath}/css/cncp/common.css"/>

<script type="text/javascript" src="${basePath}/js/jquery.min.js"></script>
<script type="text/javascript" src="${basePath}/js/jquery.jqprint-0.3.js"></script>
<script type="text/javascript" src="${basePath}/js/jquery-migrate-1.2.1.min.js"></script>
<title>充值凭证</title>
<style>
body {
	font-family: "Times New Roman", Times, serif, "微软雅黑";
}
</style>
<script type="text/javascript">
	function exportPdf() {
		$("#printDiv").jqprint();
	}
</script>
</head>
<body>
	<div style="margin:10px 40px; float:right;">
	<table width="100%" border="0" cellspacing="0" cellpadding="0">
		<tbody><tr>
			<td align="right">
				<button class="report-print-button" type="button" onclick="exportPdf();">
					<table width="100%" border="0" cellspacing="0" cellpadding="0">
						<tbody><tr>
							<td><img src="${basePath}/img/icon-printer.png" width="18" height="17"/></td>
							<td style="color: #fff;">打印</td>
						</tr>
					</tbody></table>
				</button>
			</td>
		</tr>
	</tbody></table>
	</div>

	<div id="printDiv">
		<table width="1000" border="0" cellspacing="0" cellpadding="0"
			align="center" class="normal" style="margin: 30px 20px 0px 60px;">
			<tr>
				<td colspan="3"	style="font-size: 24px; line-height: 60px; border-bottom: 2px solid #000; font-weight: bold; 
					text-align: center;">充值凭证</td>
			</tr>
			<tr height="80">
				<td colspan="3"><table width="100%" border="0" cellspacing="0"
						cellpadding="0">
						<tr>
							<td>操作人:${topUpInfo.operAdminName}</td>
							<td align="right"><fmt:formatDate value="${date}" pattern="yyyy-MM-dd HH:mm:ss" /></td>
						</tr>
					</table>
				</td>
			</tr>

			<tr>
				<td colspan="3" style="padding: 20px 0;">
					<table width="1000" border="1" align="center" cellpadding="0"
						cellspacing="0" class="normal">
						<tr align="left" height="80">
							<td width="302" style="padding: 10px;">渠道商编码:&nbsp;&nbsp;${topUpInfo.dealerCode}</td>
							<td colspan="2" style="padding: 10px;">渠道商名称:&nbsp;&nbsp;${topUpInfo.dealerName}</td>
						</tr>
						<tr align="left" height="80">
							<td width="302" style="padding: 10px;">账户余额:&nbsp;&nbsp;<fmt:formatNumber value="${topUpInfo.afterAccountBalance}" /></td>
							<td style="padding: 10px" colspan="2">充值金额: &nbsp;&nbsp;<fmt:formatNumber value="${topUpInfo.operAmount}" /></td>
						</tr>
						<tr align="left" height="80">
							<td colspan="3" style="padding: 10px;">充值时间:&nbsp;&nbsp;${topUpInfo.operTime}</td>
						</tr>
					</table>
				</td>
			</tr>

			<tr height="40">
				<td width="120" align="left">签名:</td>
				<td width="300"><div style="border-bottom: 1px solid; width: 150px;">&nbsp;</div></td>
			</tr>
			<tr height="80">
				<td align="left">审批人:</td>
				<td><div style="border-bottom: 1px solid; width: 150px;">&nbsp;</div></td>
			</tr>
		</table>
	</div>
</body>
</html>