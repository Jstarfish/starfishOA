<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/views/common/taglibs.jsp"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<link rel="stylesheet" type="text/css" href="${basePath}/css/print-button.css"/>
<script type="text/javascript" src="${basePath}/js/jquery/jquery-1.9.1.js"></script>
<script type="text/javascript" src="${basePath}/js/jquery/jquery.jqprint-0.3.js"></script>
<script type="text/javascript" src="${basePath}/js/jquery/jquery-migrate-1.2.1.min.js"></script>
<title>Adjustment Certificate</title>
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
  <table width="1000" border="0" cellspacing="0" cellpadding="0" align="center"  class="normal">
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
    <tr >
      <td colspan="3"  style="font-size: 24px;
	 line-height: 80px;
     border-bottom:2px solid #000;
	font-weight: bold;
	 text-align:center;">Adjustment Certificate</td>
    </tr>
    <tr height="80">
      <td colspan="3" ><table width="100%" border="0" cellspacing="0" cellpadding="0">
          <tr height="80">
            <td>Operator：${certificateInfo.operAdminName }</td>
            <td align="right"><fmt:formatDate value="${date}"
									pattern="yyyy-MM-dd HH:mm:ss" /></td>
          </tr>
		  <tr>
            <td>Unit：Riel</td>
          </tr>
        </table></td>
    </tr>  
    <tr>
      <td colspan="3" style="padding:20px 0;"><table width="1000" border="1" align="center" cellpadding="0" cellspacing="0"  class="normal">
          <tr align="center" height="80">
            
            <td width="200">Institution Name</td>
            <td width="300" >${certificateInfo.orgName }</td>
            <td width="200">Outlet Code</td>
            <td width="300" >${certificateInfo.agencyCode }</td>
          </tr>
          <tr align="center" height="80">
           
            <td>Outlet Name</td>
            <td>${certificateInfo.agencyName }</td>
            <td>Credit Limit</td>
            <td><fmt:formatNumber value="${certificateInfo.credit }"/></td>
          </tr>
           <tr align="center" height="80">
           
            <td>Current Balance</td>
            <td><fmt:formatNumber value="${certificateInfo.beforeBalance }"/></td>
            <td>Adjustment Amount</td>
            <td><fmt:formatNumber value="${certificateInfo.adjustAmount }"/></td>
          </tr>
           <tr align="center" height="80">
           
            <td>Balance after Adjustment</td>
            <td><fmt:formatNumber value="${certificateInfo.afterBalance }"/></td>
            <td>Adjustment Amount</td>
            <td><fmt:formatDate value="${certificateInfo.operTime }" pattern="yyyy-MM-dd HH:mm:ss"/></td>
          </tr> 
		 <tr align="left" height="80">
            <td colspan="1" align="center">Remark</td>
			<td colspan="3" align="center">${certificateInfo.reason }</td>
          </tr>
        </table></td>
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