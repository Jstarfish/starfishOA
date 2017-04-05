<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/views/common/taglibs.jsp"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<link rel="stylesheet" type="text/css" href="${basePath}/css/print-button.css"/>
<link href="${basePath}/views/inventory/goodsReceipts/css/style3.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="${basePath}/js/jquery/jquery-1.9.1.js"></script>
<script type="text/javascript" src="${basePath}/js/jquery/jquery.jqprint-0.3.js"></script>
<script type="text/javascript" src="${basePath}/js/jquery/jquery-migrate-1.2.1.min.js"></script>
<title>Transfer Receipt Slip</title>
<style>
body {
	font-family:"Times New Roman",Times,serif,"微软雅黑";
}
</style>
<script type="text/javascript">
    function exportPdf() {
        //var html = document.documentElement.outerHTML;
     /*   var html = printDiv.innerHTML;

        var input1 = document.createElement("input");
        input1.type = "hidden";
        input1.name = "htmlStr";
        input1.value = encodeURIComponent(html);

        var form1 = document.createElement("form");
        form1.appendChild(input1);
        //document.body.appendChild(form1);
        form1.action = "export.do";
        form1.method="post";
        form1.submit();
*/
    	$("#printDiv").jqprint();
    }
</script>
</head>

<body>
<div style="margin:10px 70px; float:right;">
  <table width="100%" border="0" cellspacing="0" cellpadding="0">
    <tr>
      <td align="right">
      
          <button class="report-print-button" type="button" onclick="exportPdf();">
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
  <table width="1000" border="0" cellspacing="0" cellpadding="0" align="center"  class="normal" style="margin:30px 20px 0px 60px;">
   <tr>
      <td colspan="3" align="right"><img src="views/inventory/goodsReceipts/images/KPW.jpg" width="170" height="55" /></td>
    </tr>
   
    <tr>
      <td colspan="4" style="font-size: 24px;line-height: 80px;border-bottom:2px solid #000;font-weight: bold;text-align:center;">调拨单入库</td>
    </tr>
    <tr height="80">
      <td colspan="3"><table width="100%" border="0" cellspacing="0" cellpadding="0">
          <tr>
            <td>操作人: ${vo.sendOperater }</td>
            <td align="right"><fmt:formatDate  value="${vo.sendDate}"  pattern="yyyy-MM-dd HH:mm:ss" /></td>
          </tr>
        </table></td>
    </tr>
        <tr height="40">
      <td align="left"  colspan="3">调拨单编码:${tranvo.stbNo }</td>
    </tr>
     <tr height="40">
      <td align="left"  colspan="3">调拨单位: ${tranvo.sendUnit}</td>
    </tr>
      <tr height="40">
      <td align="left"  colspan="3">接收单位: ${tranvo.receiveUnit}</td>
    </tr>
    <tr>
      <td colspan="3" style="padding:20px 0;"><table width="1000" border="1" align="center" cellpadding="0" cellspacing="0"  class="normal">
       <tr align="center" height="80">
            
            <td width="126" >方案编码</td>
            <td width="269" >方案名称</td>
            <td width="129" >批次编码</td>
            <td width="144" >票数 (张)</td>
            <td width="142" >面值</td>
            <td width="176" >金额 (瑞尔)</td>
          </tr>
         <c:forEach var="data" items="${listvo}">
       <tr align="center" height="80">
            
            <td>${data.planCode}</td>
            <td>${data.planName }</td>
             <td>${data.batchNo }</td>
            <td><fmt:formatNumber value='${data.tickets}' type='number' /></td>
            <td style="text-align:right"><fmt:formatNumber value='${data.tickAmount}' type='number' /></td>
            <td style="text-align:right"><fmt:formatNumber value='${data.amount}' type='number' /></td>
          </tr>
          </c:forEach>
        
          <tr align="left" height="80">
            <td colspan="3" style="padding:10px;">总票数 (张):<fmt:formatNumber value='${vosum.tickets}' type='number' /></td>
          
            <td colspan="3" style="padding:10px;">总金额 (瑞尔):<span style="float:right;"><fmt:formatNumber value='${vosum.amount}' type='number' /></span></td>
          </tr>
        </table></td>
    </tr>
  
    <tr height="40">
      <td width="150" align="left">签名: </td>
      <td width="953"><div style="border-bottom:1px solid;width:150px;">&nbsp;</div></td>
    </tr>
    <tr height="80">
      <td align="left">审批人:</td>
      <td><div style="border-bottom:1px solid;width:150px;">&nbsp;</div></td>
    </tr>
  </table>
</div>
</body>
</html>