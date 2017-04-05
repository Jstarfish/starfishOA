<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/views/common/taglibs.jsp"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<link href="${basePath}/views/inventory/goodsReceipts/css/style3.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="${basePath}/js/jquery/jquery-1.9.1.js"></script>
<script type="text/javascript" src="${basePath}/js/jquery/jquery.jqprint-0.3.js"></script>
<script type="text/javascript" src="${basePath}/js/jquery/jquery-migrate-1.2.1.min.js"></script>

<title>Termination Batch</title>
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
                            <td style="color: #fff;">Print</td>
                          </tr>
                        </table>
                        </button>
      
      </td>
    </tr>
  </table>
</div>
<div id="printDiv">
  <table width="1000" border="0" cellspacing="0" cellpadding="0" align="center"  class="normal" style="margin:30px 20px 0px 60px;">
   <tr>
      <td colspan="3" align="right"><img src="views/inventory/goodsReceipts/images/KPW.jpg" width="170" height="55" /></td>
    </tr>
   
    <tr>
      <td colspan="3" style="font-size: 24px;line-height: 80px;border-bottom:2px solid #000;font-weight: bold;text-align:center;">Termination Batch</td>
    </tr>
    <tr height="80">
      <td colspan="3"><table width="100%" border="0" cellspacing="0" cellpadding="0">
          <tr>
            <td>Operator:${username}</td>
            <td align="right"><fmt:formatDate  value="${date}"  pattern="yyyy-MM-dd HH:mm:ss" /></td>
          </tr>
        </table></td>
    </tr>
    <tr height="40">
      <td colspan="2">Plan Code：${publisher.planCode}</td>
    </tr>
    <tr height="40">
      <td colspan="2">Plan Name：${publisher.planName}</td>
    </tr>
    <tr height="40">
      <td colspan="2">Batch No：${publisher.batchNo}</td>
    </tr>
    <tr>
      <td colspan="3" style="padding:20px 0;"><table width="1000" border="1" align="center" cellpadding="0" cellspacing="0"  class="normal">
          <tr align="left" height="80">
            <td width="120" colspan="2" style="padding:10px;">Total Tickets(tickets):${batch.batchCounts }</td>
          </tr>
          <tr align="left" height="80">
            <td width="120" style="padding:10px;">Tickets Sold(tickets):${batch.saleCounts }</td>
            <td width="110" style="padding:10px;">Amount Sold(riels)：${batch.saleMoney }</td>
          </tr>
          <tr align="left" height="80">
            <td width="120" style="padding:10px;">Tickets Payout(tickets)：${batch.payoutNum }</td>
            <td width="110" style="padding:10px;">Amount Payout(riels)：${batch.counts }</td>
          </tr>
          <tr align="left" height="80">
            <td width="120" style="padding:10px;">Storage Quantity(tickets)：${batch.warehouseCounts }</td>
            <td width="110" style="padding:10px;">Manager Storage Quantity(tickets)：${batch.marketCounts }</td>
          </tr>
          <tr align="left" height="80">
            <td width="120" colspan="2" style="padding:10px;">Damaged Tickets(tickets)：${batch.brokenNum }</td>
          </tr>
        </table></td>
    </tr>
    <tr height="40">
      <td align="left"  colspan="3">Tickets Termination<span style="padding:10px;">(tickets)</span>：${batch.warehouseCounts+batch.marketCounts }</td>
    </tr>
    <tr height="80">
      <td width="150" align="left">Signature:</td>
      <td width="953"><div style="border-bottom:1px solid;width:150px;">&nbsp;</div></td>
    </tr>
    <tr height="80">
      <td align="left">Approved By:</td>
      <td><div style="border-bottom:1px solid;width:150px;">&nbsp;</div></td>
    </tr>
  </table>
</div>
</body>
</html>