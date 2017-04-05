<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/views/common/taglibs.jsp"%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<link rel="stylesheet" type="text/css" href="${basePath}/css/print-button.css"/>
<script type="text/javascript" src="${basePath}/js/jquery/jquery-1.9.1.js"></script>
<script type="text/javascript" src="${basePath}/js/jquery/jquery.jqprint-0.3.js"></script>
<script type="text/javascript" src="${basePath}/js/jquery/jquery-migrate-1.2.1.min.js"></script>
<style>
body {
	font-family:"Times New Roman",Times,serif,"微软雅黑";
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
	<table width="90%" border="0" cellspacing="0" cellpadding="0">
		<tr>
			<td align="right">
				<button class="report-print-button" type="button" onclick="exportPdf();">
					<table width="100%" border="0" cellspacing="0" cellpadding="0">
						<tr>
							<td><img src="img/icon-printer.png" width="18" height="17"/></td>
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
      <td colspan="3" align="right"><img src="./img/KPW.jpg" width="170" height="55" /></td>
    </tr>
    <tr>
      <td colspan="3"  style="font-size: 24px; line-height: 60px; border-bottom:2px solid #000;	font-weight: bold;
		  text-align:center;">充值凭证</td>
    </tr>
    <tr height="80">
      <td colspan="3"><table width="100%" border="0" cellspacing="0" cellpadding="0">
          <tr>
            <td>操作:${topUpsInfo.realName}</td>
            <td align="right"><fmt:formatDate value="${date}" pattern="yyyy-MM-dd HH:mm:ss"/></td>
          </tr>
        </table></td>
    </tr>
      
    <tr>
      <td colspan="3" style="padding:20px 0;"><table width="1000" border="1" align="center" cellpadding="0" cellspacing="0"  class="normal">
         <tr align="left" height="80">
            <td width="302" style="padding:10px;">站点编码:${topUpsInfo.aoCode}</td>
            <td colspan="2" style="padding:10px;">站点名称:${topUpsInfo.aoName}</td>
          </tr>
          <tr align="left" height="80">
            <td  width="302" style="padding:10px;">账户余额:<fmt:formatNumber value="${topUpsInfo.afterBalance}" /></td>
            <td style="padding:10px;" colspan="2" >充值金额:<fmt:formatNumber value="${topUpsInfo.applyAmount}" /></td>
           </tr>
            <tr align="left" height="80">
            <td colspan="3" style="padding:10px;">充值时间:&nbsp;&nbsp;<fmt:formatDate
							value="${topUpsInfo.applyDate}" pattern="yyyy-MM-dd HH:mm:ss" /></td>
           </tr>
         
        </table></td>
    </tr>
  
    <tr height="40">
      <td width="120" align="left">签名:</td>
      <td width="300"><div style="border-bottom:1px solid;width:150px;">&nbsp;</div></td>
    </tr>
    <tr height="80">
      <td align="left">审批人:</td>
      <td><div style="border-bottom:1px solid;width:150px;">&nbsp;</div></td>
    </tr>
  </table>
</div>
</body>
</html>