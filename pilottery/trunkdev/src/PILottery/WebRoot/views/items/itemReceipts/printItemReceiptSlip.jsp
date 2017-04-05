<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/views/common/taglibs.jsp"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<link rel="stylesheet" type="text/css" href="${basePath}/css/print-button.css"/>
<script type="text/javascript" src="${basePath}/js/jquery/jquery-1.9.1.js"></script>
<script type="text/javascript" src="${basePath}/js/jquery/jquery.jqprint-0.3.js"></script>
<script type="text/javascript" src="${basePath}/js/jquery/jquery-migrate-1.2.1.min.js"></script>

<title>Item Receipt Slip</title>

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
	<table width="1000" border="0" cellspacing="0" cellpadding="0" align="center" class="normal">
		<tr>
			<td colspan="3" align="right"><img src="img/KPW.jpg" width="170" height="55"/></td>
		</tr>
		<tr>
			<td colspan="3" style="font-size:24px;line-height:80px;border-bottom:2px solid #000;font-weight:bold;text-align:center;">Item Receipt Slip</td>
		</tr>
		<tr height="40">
      		<td colspan="3">
      			<table width="100%" border="0" cellspacing="0" cellpadding="0">
         			<tr>
            			<td>Operator: ${operator}</td>
            			<td align="right"><fmt:formatDate value="${date}" pattern="yyyy-MM-dd HH:mm:ss"/></td>
          			</tr>
        		</table>
        	</td>
    	</tr>
    	<tr height="40">
      		<td align="left" colspan="3">Item Receipt No: ${irNo}</td>
    	</tr>
		<tr height="40">
      		<td align="left" colspan="3">Receiving Unit: ${receiveOrgName}</td>
    	</tr>
    	<tr height="40">
      		<td align="left" colspan="3">Receiving Warehouse: ${receiveWhName}</td>
    	</tr>
    	<tr>
    		<td colspan="3" style="padding:20px 0;">
    			<table width="1000" border="1" align="center" cellpadding="0" cellspacing="0" class="normal">
          			<tr align="center" height="80">
            			<td width="332">Item Name</td>
            			<td width="332">Quantity</td>
            			<td width="332">Base Unit</td>
			        </tr>
			        <c:forEach var="item" items="${itemList}" varStatus="status">
			        	<tr align="center" height="80">
			        		<td>${item.itemName}</td>
			        		<td>${item.quantity}</td>
			        		<td>${item.baseUnit}</td>
			        	</tr>
			        </c:forEach>
        		</table>
    		</td>
    	</tr>
    	
		<tr height="40">
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