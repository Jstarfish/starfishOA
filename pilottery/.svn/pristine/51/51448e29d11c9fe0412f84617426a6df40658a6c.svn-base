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
<title>调账凭证</title>
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
	 text-align:center;">调账凭证</td>
    </tr>
    <tr height="80">
      <td colspan="3" ><table width="100%" border="0" cellspacing="0" cellpadding="0">
          <tr height="80">
            <td>操作人：${certificateInfo.operAdminName }</td>
            <td align="right"><fmt:formatDate value="${date}"
									pattern="yyyy-MM-dd HH:mm:ss" /></td>
          </tr>
		  <tr>
            <td>单位：瑞尔</td>
          </tr>
        </table></td>
    </tr>  
    <tr>
      <td colspan="3" style="padding:20px 0;"><table width="1000" border="1" align="center" cellpadding="0" cellspacing="0"  class="normal">
          <tr align="center" height="80">
            
            <td width="200">所属部门</td>
            <td width="300" >${certificateInfo.orgName }</td>
            <td width="200">站点编号</td>
            <td width="300" >${certificateInfo.agencyCode }</td>
          </tr>
          <tr align="center" height="80">
           
            <td>站点名称</td>
            <td>${certificateInfo.agencyName }</td>
            <td>信用额度</td>
            <td><fmt:formatNumber value="${certificateInfo.credit }"/></td>
          </tr>
           <tr align="center" height="80">
           
            <td>调账前余额</td>
            <td><fmt:formatNumber value="${certificateInfo.beforeBalance }"/></td>
            <td>调账金额</td>
            <td><fmt:formatNumber value="${certificateInfo.adjustAmount }"/></td>
          </tr>
           <tr align="center" height="80">
           
            <td>调账后余额</td>
            <td><fmt:formatNumber value="${certificateInfo.afterBalance }"/></td>
            <td>调账时间</td>
            <td><fmt:formatDate value="${certificateInfo.operTime }" pattern="yyyy-MM-dd HH:mm:ss"/></td>
          </tr> 
		 <tr align="left" height="80">
            <td colspan="1" align="center">备注</td>
			<td colspan="3" align="center">${certificateInfo.reason }</td>
          </tr>
        </table></td>
    </tr>
  
    <tr height="40">
      <td width="47" align="left">签字:</td>
      <td width="953"><div style="border-bottom:1px solid;width:150px;">&nbsp;</div></td>
    </tr>
    <tr height="80">
      <td align="left">审核:</td>
      <td><div style="border-bottom:1px solid;width:150px;">&nbsp;</div></td>
    </tr>
  </table>
</div>
</body>
</html>