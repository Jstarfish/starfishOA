<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/views/common/taglibs.jsp"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>无标题文档</title>
<link rel="stylesheet" type="text/css" href="${basePath}/css/print-button.css"/>
<script type="text/javascript" src="${basePath}/js/jquery/jquery-1.9.1.js"></script>
<script type="text/javascript" src="${basePath}/js/jquery/jquery.jqprint-0.3.js"></script>
<script type="text/javascript" src="${basePath}/js/jquery/jquery-migrate-1.2.1.min.js"></script>
<style>
body {
	font-family: "Times New Roman", Times, serif, "微软雅黑";
}
</style>
<script type="text/javascript">
	//打印函数
	function exportPdf() {
		$("#printDiv").jqprint();
	}
</script>
</head>

<body>

<div style="margin:10px 40px; float:right;">
	<table width="100%" border="0" cellspacing="0" cellpadding="0">
		<tr>
			<td align="right">
				<button class="report-print-button" type="button" onclick="exportPdf();">
					<table width="100%" border="0" cellspacing="0" cellpadding="0">
						<tr>
							<td><img src="<%=request.getContextPath() %>/img/icon-printer.png" width="18" height="17"/></td>
							<td style="color: #fff;">打印</td>
						</tr>
					</table>
				</button>
			</td>
		</tr>
	</table>
</div>

	<div id="printDiv">
		<table width="1000" border="0" cellspacing="0" cellpadding="0"
			align="center" class="normal" style="margin: 30px 20px 0px 60px;">
			<tr>
				<td colspan="3" align="right"><img src="<%=request.getContextPath() %>/img/KPW.jpg"
					width="170" height="55" /></td>
			</tr>
			<tr>
				<td colspan="3"
					style="font-size: 24px; line-height: 60px; border-bottom: 2px solid #000; font-weight: bold; text-align: center;">高棉国家彩票公司退票凭证</td>
			</tr>
			<tr height="50">
				<td colspan="3"><table width="100%" border="0" cellspacing="0"
						cellpadding="0">
						<tr>
							<td>操作人:${realname}</td>
							<td align="right"><fmt:formatDate value="${date}"
									pattern="yyyy-MM-dd HH:mm:ss" /></td>
						</tr>
					</table></td>
			</tr>

			<tr>
				<td colspan="3" style="padding: 20px 0;">
					<table width="1000" border="1" align="center" cellpadding="0"
						cellspacing="0" class="normal">
						<tr height="40">
							<td>退票时间</td>
							<td>${currdatetime}</td>
						</tr>
						<tr height="40">
							<td>退票销售站</td>
							<td>${refundForm.cancelAgencyCodeFormat}</td>
						</tr>
						<tr height="40">
							<td>退票金额</td>
							<td><fmt:formatNumber value="${refundReq.cancelAmount}"
									pattern="#,###" /></td>
						</tr>
						<tr height="40">
							<td>退票流水号</td>
							<td>${refundReq.rspfn_ticket_cancel}</td>
						</tr>
						<tr height="40">
							<td>游戏</td>

							<td>${refundForm.gameName}</td>
						</tr>
						<tr height="40">
							<td>期号</td>
							<td>${refundReq.startIssueNumber}</td>
						</tr>
						<tr height="40">
							<td>销售站点</td>
							<td>${refundForm.saleAgencyCodeFormat}</td>
						</tr>
						<tr height="40">
							<td>售票时间</td>
							<td><fmt:formatDate value="${refundReq.saleDate}"
									pattern="yyyy-MM-dd HH:mm:ss" /></td>
						</tr>
						<tr height="40">
							<td>销售金额</td>
							<td><fmt:formatNumber value="${refundReq.cancelAmount}"
									pattern="#,###" /></td>
						</tr>
						<tr height="40">
							<td>彩票票号</td>
							<td>${refundReq.rspfn_ticket}</td>

						</tr>
					</table>
				</td>
			</tr>

			<tr height="40">
				<td width="120" align="left">签名:</td>
				<td width="300"><div
						style="border-bottom: 1px solid; width: 150px;">&nbsp;</div></td>
			</tr>
			<tr height="80">
				<td align="left">审批人:</td>
				<td><div style="border-bottom: 1px solid; width: 150px;">&nbsp;</div></td>
			</tr>
		</table>
	</div>
</body>
</html>



