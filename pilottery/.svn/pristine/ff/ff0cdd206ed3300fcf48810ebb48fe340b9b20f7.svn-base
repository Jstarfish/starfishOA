<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"  %>
<%@ include file="/views/common/meta.jsp" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<link rel="stylesheet" href="${basePath}/css/cncp/common.css"/>
<script type="text/javascript" src="${basePath}/js/jquery.min.js"></script>
<script type="text/javascript" src="${basePath}/js/jquery.jqprint-0.3.js"></script>
<script type="text/javascript" src="${basePath}/js/jquery-migrate-1.2.1.min.js"></script>
<title>订单详情</title>
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
					text-align: center;">中奖信息</td>
			</tr>
			<tr height="80">
				<td colspan="3"><table width="100%" border="0" cellspacing="0"
						cellpadding="0">
						<tr>
							<td align="right"><fmt:formatDate value="${date}"
									pattern="yyyy-MM-dd HH:mm:ss" /></td>
						</tr>
					</table>
				</td>
			</tr>

			<tr>
				<td colspan="3" style="padding: 20px 0;">
					<table width="1000" border="1" align="center" cellpadding="0"
						cellspacing="0" class="normal">
						<tr align="left" height="80">
							<td width="302" style="padding: 10px;">申请流水:&nbsp;&nbsp;${prizeDetail.saleFlow}</td>
							<td colspan="2" style="padding: 10px;">TSN号:&nbsp;&nbsp;${prizeDetail.saleTsn}</td>
						</tr>
						<tr align="left" height="80">
							<td width="302" style="padding: 10px;">游戏名称:&nbsp;&nbsp;${prizeDetail.gameName}</td>
							<td style="padding: 10px;" colspan="2">期次编号:&nbsp;&nbsp;${prizeDetail.issueNumber}</td>
						</tr>
						<tr align="left" height="80">
							<td width="302" style="padding: 10px;">渠道编码:&nbsp;&nbsp;${prizeDetail.dealerCode}</td>
							<td colspan="2" style="padding: 10px;">渠道名称:&nbsp;&nbsp;${prizeDetail.dealerName}</td>
						</tr>
						<tr align="left" height="80">
							<td style="padding: 10px;" >订单总额:&nbsp;&nbsp;<fmt:formatNumber value="${prizeDetail.orderAmount}" /></td>
							<td style="padding: 10px;" colspan="2">中奖金额:&nbsp;&nbsp;<fmt:formatNumber value="${prizeDetail.rewardAmount}" /></td>
						</tr>
						<tr align="left" height="80">
							<td width="302" style="padding: 10px;">派奖状态:&nbsp;&nbsp;
								<%-- <c:choose>
									<c:when test="${prizeDetail.isPaid == 0} ">未派奖</c:when>
									<c:otherwise>已派奖</c:otherwise>
								</c:choose> --%>
								<c:if test="${prizeDetail.isPaid == 0 }">未派奖</c:if>
								<c:if test="${prizeDetail.isPaid == 1 }">已派奖</c:if>
							</td>
							<td colspan="2" style="padding: 10px;">派奖时间:&nbsp;&nbsp;${prizeDetail.paidTime}</td>
							</tr>
					</table>
				</td>
			</tr>

		</table>
	</div>
</body>
</html>