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
      <td colspan="3"  style="font-size: 24px; line-height: 60px; border-bottom:2px solid #000; font-weight: bold;
	 	text-align:center;">Cash Withdrawn Certificate</td>
    </tr>
    <tr height="80">
      <td colspan="3"><table width="100%" border="0" cellspacing="0" cellpadding="0">
          <tr>
            <%-- <td>操作人：${withdrawnInfos.checkAdminId}</td> --%>
            <td>Operator:${withdrawnInfos.realName}</td>
            <td align="right"><fmt:formatDate value="${date}" pattern="yyyy-MM-dd HH:mm:ss"/></td>
          </tr>
        </table></td>
    </tr>
      
    <tr>
      <td colspan="3" style="padding:20px 0;"><table width="1000" border="1" align="center" cellpadding="0" cellspacing="0"  class="normal">
         <tr align="left" height="80">
            <td width="302" style="padding:10px;">Institution Code:${withdrawnInfos.aoCode}</td>
            <td colspan="2" style="padding:10px;">Institution Name:${withdrawnInfos.aoName}</td>
         </tr>
          <tr align="left" height="80">
            <td  width="302" style="padding:10px;">Account Balance:<fmt:formatNumber value="${withdrawnInfos.accountBalance}"/></td>
            <td style="padding:10px;" colspan="2" >Cash Withdrawn Amount:<fmt:formatNumber value="${withdrawnInfos.applyAmount}"/></td>
          </tr>
          <tr align="left" height="80">
            <td colspan="3" style="padding:10px;">Time of Cash Withdrawn:&nbsp;&nbsp;<fmt:formatDate
				value="${withdrawnInfos.applyDate}" pattern="yyyy-MM-dd HH:mm:ss" /></td>
           </tr></table>
      </td>
    </tr>
  
    <tr height="40">
      <td width="120" align="left">Signature:</td>
      <td width="300"><div style="border-bottom:1px solid;width:150px;">&nbsp;</div></td>
    </tr>
    <tr height="80">
      <td align="left">Approved By:</td>
      <td><div style="border-bottom:1px solid;width:150px;">&nbsp;</div></td>
    </tr>
  </table>
</div>
</body>
</html>