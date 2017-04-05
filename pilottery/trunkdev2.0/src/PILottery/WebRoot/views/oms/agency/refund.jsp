<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/views/common/taglibs.jsp"%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
"http://www.w3.org/TR/html4/loose.dtd">
<html>



<head>
<link rel="stylesheet" type="text/css" href="${basePath}/css/style.css" />

<link rel="stylesheet" type="text/css" href="${basePath}/css/print-button.css"/>
<link href="${basePath}/views/inventory/goodsReceipts/css/style3.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="${basePath}/js/jquery/jquery-1.9.1.js"></script>
<script type="text/javascript" src="${basePath}/js/jquery/jquery.jqprint-0.3.js"></script>
<script type="text/javascript" src="${basePath}/js/jquery/jquery-migrate-1.2.1.min.js"></script>
<script type="text/javascript">

function doClose(){
	
	window.parent.location.reload();
	//window.parent.closeBox();
}
function exportPdf() {

	$("#printDiv").jqprint();
}
</script>
</head>

<body>
<div style="margin:60px 100px; float:right;">
  <table width="100%" border="0" cellspacing="0" cellpadding="0">
    <tr >
      <td align="right">
      
          <button class="report-print-button" type="button" onclick="exportPdf();">
                        <table width="100%" border="0" cellspacing="0" cellpadding="0">
                          <tr  height="50">
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
<div class="pop-body" style="text-align:center;">
<table style="margin:auto; width:95%;" border="1" id="exportPdf" cellspacing="0" cellpadding="0">
		<tr>
			<td colspan="4" align="center" style="font-size:24px; line-height:50px;">
			
			<c:if test="${applicationScope.useCompany == 1}">
        			National Sports Lottery Ltd. Outlet Account Clearance Receipt
	        	</c:if>
	        	<c:if test="${applicationScope.useCompany == 2}">
	        		Khmer Pools Welfare Lottery Co. Ltd. Outlet Account Clearance Receipt
	        	</c:if>
			</td>
		</tr>
		<tr>
			<td colspan="2" class="gm-sty-dj-left">Date  &nbsp;&nbsp; <fmt:formatDate value="${agencys.refunddate }" pattern="yyyy-MM-dd  HH:mm:ss "/> </td>
			<td colspan="2" class="gm-sty-dj-right">Receipt No. &nbsp;&nbsp;  ${agencys.id }</td>
		</tr>
		<tr>
			<td width="14%">Outlet Code</td>
			<td width="23%">${agencys.agencyCode}</td>
			<td width="20%">Outlet Name</td>
			<td width="43%">${agencys.agencyName}</td>
		</tr>
		<tr>
			<td>Contact</td>
			<td>${agencys.person}</td>
			<td>Outlet Address</td>
			<td>${agencys.address}</td>
		</tr>
		<tr>
			<td>Serial No.</td>
			<td>Item</td>
			<td colspan="2">Amount</td>
		</tr>
		<tr>
			<td>1</td>
			<td>Account Balance</td>
			<td colspan="2" class="gm-sty-dj-right"><fmt:formatNumber value='${agencys.fundamount}'/></td>
		</tr>
		<tr>
			<td>2</td>
			<td>Fixed Cost</td>
			<td colspan="2" class="gm-sty-dj-right">0</td>
		</tr>
		<tr>
			<td>3</td>
			<td>Equipment Deposit</td>
			<td colspan="2" class="gm-sty-dj-right">0</td>
		</tr>
		<tr>
			<td>4</td>
			<td>Other expenses</td>
			<td colspan="2" class="gm-sty-dj-right">0</td>
		</tr>
		<tr>
			<td colspan="2">Total</td>
			<td colspan="2" class="gm-sty-dj-right"><fmt:formatNumber value='${agencys.fundamount}'/> </td>
		</tr>
		<tr>
			<td colspan="2">Clearance Agent：</td>
			<td colspan="2">Outlet Removing Operator：</td>
		</tr>
	</table>
</div>
</div>
</body>
</html>
