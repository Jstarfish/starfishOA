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

<title>打印凭证</title>
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
      
          <button class="gl-btn2" type="button" onclick="exportPdf();">
                        <table width="100%" border="0" cellspacing="0" cellpadding="0">
                          <tr>
                              <td><img src="views/inventory/goodsReceipts/images/printx.png" width="18" height="17"   /></td>
                            <td style="color: #fff;">打印</td>
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
					style="font-size: 24px; font-weight: bold; text-align: center; line-height: 80px; border-bottom: 2px solid #000;">兑奖凭证打印</td>
			</tr>
			<tr height="80">
				<td colspan="3"><table width="100%" border="0" cellspacing="0"
						cellpadding="0">
						<tr>
							<td>操作人: ${record.operaName}</td>
							<td align="right"><fmt:formatDate value="${date}"
									pattern="yyyy-MM-dd HH:mm:ss" /></td>
						</tr>
					</table></td>
			</tr>
			<td colspan="3" height="40"><table width="100%" border="0" cellspacing="0"
					cellpadding="0">
					<tr>
						<td>兑奖记录编号：${flow }</td>

					</tr>
				</table></td>
			</tr>
			<tr>
				<td colspan="3" style="padding: 20px 0;"><table width="1000" border="1"
						align="center" cellpadding="0" cellspacing="0" class="normal">

						<td colspan="3" align="center" height="80">中奖票信息</td>
						</tr>
						<tr align="left" height="80">
							<td width="302" style="padding: 10px;">方案编码:${info.planCode }</td>
							<td colspan="2" style="padding: 10px;">方案名称:${info.planName }</td>
						</tr>
						<tr align="left" height="80">
							<td style="padding: 10px;">批次:${record.batchCode }</td>
							<td style="padding: 10px;">本号:${record.packageNo }</td>
							<td style="padding: 10px;">票号:${record.ticketNo }</td>
						</tr>
						<tr align="left" height="80">
							<td colspan="3" style="padding: 10px;">中奖金额：<fmt:formatNumber value="${record.amount }" /></td>
						</tr>
						<tr align="center" height="80">
							<td colspan="3" style="padding: 10px;">兑奖信息</td>
						</tr>
						<tr align="left" height="80">
							<td style="padding: 10px;">兑奖机构:${orgs.orgName }</td>
							<td colspan="2" style="padding: 10px;">机构编码：${orgs.orgCode }</td>
						</tr>
						<tr>
							<td colspan="3" align="center" height="80">兑奖人信息</td>
						</tr>
						<tr align="left" height="80">
							<td style="padding: 10px;">中奖人名称:${record.winnerName }</td>
							<td width="252" style="padding: 10px;">中奖人性别:${record.sexEn }</td>
							<td width="238" style="padding: 10px;">中奖人年龄:${record.age }</td>
						</tr>
						<tr align="left" height="80">
							<td style="padding: 10px;">省份证号码:${record.personalId }</td>
							<td colspan="2" style="padding: 10px;">联系方式:${record.contact }</td>
						</tr>
					</table></td>
			</tr>
			<tr height="40">
				<td width="150" align="left">签字:</td>
				<td width="953"><div style="border-bottom: 1px solid; width: 150px;">&nbsp;</div></td>
			</tr>
			<tr height="80">
				<td align="left">批准:</td>
				<td><div style="border-bottom: 1px solid; width: 150px;">&nbsp;</div></td>
			</tr>
		</table>
	</div>
</body>
</html>