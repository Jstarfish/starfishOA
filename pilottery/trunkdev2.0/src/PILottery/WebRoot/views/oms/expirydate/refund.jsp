<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/views/common/taglibs.jsp"%>
<%-- <%@ taglib uri="http://cls.taishan.util.report.tags" prefix="er" %> --%>
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
							<td style="color: #fff;">Print</td>
						</tr>
					</table>
				</button>
			</td>
		</tr>
	</table>
</div>

	<div id="printDiv">
		<table width="1000" border="0" cellspacing="0" cellpadding="0"
			align="center">
			<tr>
				<td colspan="3" align="right">
		      		<c:if test="${applicationScope.useCompany == 1}">
		        		<img src="<%=request.getContextPath() %>/img/NSL.png" width="170" height="55" />
		        	</c:if>
		        	<c:if test="${applicationScope.useCompany == 2}">
		        		<img src="<%=request.getContextPath() %>/img/KPW.jpg" width="170" height="55" />
		        	</c:if>
		      	</td>
			</tr>
			<tr>
				<td colspan="3"
					style="font-size: 24px; line-height: 60px; border-bottom: 2px solid #000; text-align: center;">Refund Certificate</td>
			</tr>
			<tr height="50">
				<td colspan="3"><table width="100%" border="0" cellspacing="0"
									   cellpadding="0">
					<tr  height="60">
						<td>Operator:${vo.canceler}</td>
						<td align="right">${currdatetime}</td>
					</tr>
					<tr height="20">
						<td>Unit:KHR</td>
					</tr>
				</table></td>

			</tr>

			<tr>
				<td colspan="3" style="padding: 20px 0;">
					<table width="1000" border="1" align="center" cellpadding="0"
						   cellspacing="0" class="normal">
						<tr align="center" height="80">
							<td width="142">Refund Time</td>
							<td><fmt:formatDate value="${vo.cancelTime}" pattern="yyyy-MM-dd HH:mm:ss" /></td>
							<td width="142">Refund Institution</td>
							<td>${vo.orgName}</td>
						</tr>
						<tr align="center" height="80">
							<td width="142">Refund Amount</td>
							<td><fmt:formatNumber value="${vo.cancelAmount}" pattern="#,###" /></td>
							<td width="142">Refund Flow Number</td>
							<td>${vo.id}</td>
						</tr>
						<tr align="center" height="80">
							<td width="142">Game</td>
							<td>${vo.gameName}</td>
							<td width="142">Issue</td>
							<td>${vo.issueNumer}</td>
						</tr>
						<tr align="center"  height="80">
							<td width="142">Sale Outlet</td>
							<td>${vo.saleAgencyCodeFormat}</td>
							<td width="142">Sale Time</td>
							<td><fmt:formatDate value="${vo.saleTime}" pattern="yyyy-MM-dd HH:mm:ss" /></td>
						</tr>
						<tr align="center"  height="80">
							<td width="142">Sale Amount</td>
							<td><fmt:formatNumber value="${vo.cancelAmount}" pattern="#,###" /></td>
							<td width="142">Ticket No.</td>
							<td>${vo.saleTsn}</td>
						</tr>

					</table>
				</td>
			</tr>


			<tr height="40">
				<td width="100" align="left">Signature:</td>
				<td width="300"><div
						style="border-bottom: 1px solid; width: 150px;">&nbsp;</div></td>
			</tr>
			<tr height="80">
				<td align="left">Approved By:</td>
				<td><div style="border-bottom: 1px solid; width: 150px;">&nbsp;</div></td>
			</tr>
		</table>
	</div>
</body>
</html>



