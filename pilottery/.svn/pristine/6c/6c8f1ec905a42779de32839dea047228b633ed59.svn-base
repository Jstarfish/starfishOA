<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/views/common/taglibs.jsp"%>
<html>
<head>
<title>Institution Commsion Detail</title>

<link rel="stylesheet" type="text/css" href="${basePath}/css/pop-up.css" />
<script type="text/javascript" src="${basePath}/js/myJs.js"></script>
<script type="text/javascript" src="${basePath}/js/jquery/jquery-1.9.1.js"></script>
<script type="text/javascript">
	function doClose() {
		window.parent.closeBox();
	}
</script>
</head>
<body>
<div id="tck" >
	 <div style="padding:0 20px 20px 20px;">
	     <div style="position:relative; z-index:1000px;margin-top: 10px;">
	       <table class="datatable" id="table1_head" width="100%">
	         <tbody>
	         	<tr>
		           <th style="width:6%">Agency Code </th>
		           <th width="1%" noExp="true">|</th>
		           <th style="width:10%">Trans.Time</th>
		           <th width="1%" noExp="true">|</th>
		           <th style="width:6%">Amount</th>
		           <th width="1%" noExp="true">|</th>
                   <th style="width:6%">Sales Amount</th>
                   <th width="1%" noExp="true">|</th>
                   <th style="width:6%">Sales Comm</th>
                   <th width="1%" noExp="true">|</th>
                   <th style="width:6%">Payout Amount</th>
                   <th width="1%" noExp="true">|</th>
                   <th style="width:6%">Payout Comm</th>
                   <th width="1%" noExp="true">|</th>
                   <th style="width:6%">Return Amount</th>
                   <th width="1%" noExp="true">|</th>
                   <th style="width:6%">Return Comm</th>	         
		         </tr>
		       </tbody>
	       </table>
	     </div>
	     <div id="box" style="border:1px solid #ccc;">
	       <table id="fatable" class="datatable" cellpadding="0" cellspacing="0" width="100%">
	         <tbody>
	          <c:forEach var="data" items="${Listara}">
	         	<tr>
					<td width="6%">${data.agencyCode }</td>
					<td width="1%" noExp="true">&nbsp;</td>
					<td width="10%">${data.transDate }</td>
					<td width="1%" noExp="true">&nbsp;</td>
					<td width="6%">${data.Amount }</td>
					<td width="1%" noExp="true">&nbsp;</td>
					<td style="width:6%;text-align: right;"><fmt:formatNumber value="${data.saleAmount }" /></td>
					<td width="1%" noExp="true">&nbsp;</td>
					<td style="width:6%;text-align: right;"><fmt:formatNumber value="${data.saleComm }" /></td>
					<td width="1%" noExp="true">&nbsp;</td>
					<td style="width:6%;text-align: right;"><fmt:formatNumber value="${data.payout }" /></td>
					<td width="1%" noExp="true">&nbsp;</td>
					<td style="width:6%;text-align: right;"><fmt:formatNumber value="${data.payoutComm }" /></td>
					<td width="1%" noExp="true">&nbsp;</td>
					<td style="width:6%;text-align: right;"><fmt:formatNumber value="${data.returnAmount }" /></td>
					<td width="1%" noExp="true">&nbsp;</td>
					<td style="width:6%;text-align: right;"><fmt:formatNumber value="${data.returnComm }" /></td>	            
	          	</tr>
	          </c:forEach>
	          
	        </tbody></table>
	      </div>
	</div>
 </div>

</body>
</html>