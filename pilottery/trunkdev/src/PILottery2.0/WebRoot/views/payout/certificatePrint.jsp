<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/views/common/taglibs.jsp"%>
<html>
<head>
<title></title>
<%@ include file="/views/common/meta.jsp"%>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<link href="${basePath}/views/inventory/goodsReceipts/css/style3.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="${basePath}/js/jquery/jquery-1.9.1.js"></script>
<script type="text/javascript" src="${basePath}/js/jquery/jquery.jqprint-0.3.js"></script>
<script type="text/javascript" src="${basePath}/js/jquery/jquery-migrate-1.2.1.min.js"></script>
<link rel="stylesheet" type="text/css" href="${basePath}/css/print-button.css"/>
<title>Payout Certificate</title>
<style>
body {
	font-family:"Times New Roman",Times,serif,"微软雅黑";
}
</style>
<script type="text/javascript">
    function exportPdf() {

    	$("#printDiv").jqprint();
    }
</script>
</head>

<body>
<div style="margin:10px 80px; float:right;">
  <table width="40%" border="0" cellspacing="0" cellpadding="0">
    <tr>
      <td align="right">
      
          <button class="report-print-button" type="button" onclick="exportPdf();">
                        <table width="100%" border="0" cellspacing="0" cellpadding="0">
                          <tr>
                              <td><img src="img/icon-printer.png" width="18" height="17"   /></td>
                            <td style="color: #fff;">Print</td>
                          </tr>
                        </table>
                        </button>
      
      </td>
    </tr>
  </table>
</div>
	<div id="printDiv">
		<table width="1000" border="0" cellspacing="0" cellpadding="0" align="center"
			class="normal">
			<tr>
				<td colspan="3" align="right"><img src="img/KPW.jpg" width="170" height="55" /></td>
			</tr>
			<tr>
				<td colspan="2"
					style="font-size: 24px; font-weight: bold; text-align: center; line-height: 80px; border-bottom: 2px solid #000;">Payout
					Certificate</td>
			</tr>
			<tr height="80">
				<td colspan="3"><table width="100%" border="0" cellspacing="0"
						cellpadding="0">
						<tr>
							<td>Operator: ${record.operaName}</td>
							<td align="right"><fmt:formatDate value="${date}"
									pattern="yyyy-MM-dd HH:mm:ss" /></td>
						</tr>
					</table></td>
			</tr>
			<td colspan="3" height="40"><table width="100%" border="0" cellspacing="0"
					cellpadding="0">
					<tr>
						<td>Payout Record Code：${recordNo }</td>

					</tr>
				</table></td>
			</tr>
			<tr>
				<td colspan="3" style="padding: 20px 0;"><table width="1000" border="1"
						align="center" cellpadding="0" cellspacing="0" class="normal">

						<td colspan="3" align="center" height="80">Winning Ticket Information</td>
						</tr>
						<tr align="left" height="80">
							<td width="302" style="padding: 10px;">Plan Code:${record.planCode }</td>
							<td colspan="2" style="padding: 10px;">Plan Name:${record.planName }</td>
						</tr>
						<tr align="left" height="80">
							<td style="padding: 10px;">Batch:${record.batchCode }</td>
							<td style="padding: 10px;">Pack:${record.packageNo }</td>
							<td style="padding: 10px;">Ticket:${record.ticketNo }</td>
						</tr>
						<tr align="left" height="80">
							<td colspan="3" style="padding: 10px;">Winning Amount：<fmt:formatNumber value="${record.amount }" /></td>
						</tr>
						<tr align="center" height="80">
							<td colspan="3" style="padding: 10px;">Payout Information</td>
						</tr>
						<tr align="left" height="80">
							<td style="padding: 10px;">Payout Institution:${record.operOrgName }</td>
							<td colspan="2" style="padding: 10px;">Institution Code：${record.operOrgCode }</td>
						</tr>
						<tr>
							<td colspan="3" align="center" height="80">Winner's Information</td>
						</tr>
						<tr align="left" height="80">
							<td style="padding: 10px;">Winner's Name:${record.winnerName }</td>
							<td width="252" style="padding: 10px;">Winner's Sex:${record.sexEn }</td>
							<td width="238" style="padding: 10px;">Winner's Age:${record.age }</td>
						</tr>
						<tr align="left" height="80">
							<td style="padding: 10px;">Personal ID:${record.personalId }</td>
							<td colspan="2" style="padding: 10px;">Contact Phone:${record.contact }</td>
						</tr>
						<tr align="left" height="80">
							<td colspan="3" style="padding: 10px;">Remark:${record.remark }</td>
						</tr>
					</table></td>
			</tr>
			<tr height="40">
				<td width="150" align="left">Signature:</td>
				<td width="953"><div style="border-bottom: 1px solid; width: 150px;">&nbsp;</div></td>
			</tr>
			<tr height="80">
				<td align="left">Approved By:</td>
				<td><div style="border-bottom: 1px solid; width: 150px;">&nbsp;</div></td>
			</tr>
		</table>
	</div>
</body>
</html>