
<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8"%>
<%@ include file="/views/common/taglibs.jsp"%>
<%@ include file="/views/common/meta.jsp"%>
<html>
<head>
<title>MM Inventory Detail</title>
<link rel="stylesheet" type="text/css" href="${basePath}/css/style.css" />
<link rel="stylesheet" type="text/css" href="${basePath}/css/pop-up.css" />
<link rel="stylesheet" type="text/css" href="${basePath}/css/validate.css" />
<script type="text/javascript" src="${basePath}/js/oms/myJs.js"></script>
<script type="text/javascript" src="${basePath}/js/jquery/jquery-1.9.1.js"></script>

</head>
<body>
	<div id="tck" >
	  <div class="mid">
	  	<table width="100%" border="0" cellspacing="0" cellpadding="0" >
	      <tr>
	     	<td align="right">Quantity (tickets)：</td>
	        <td align="left" >${total.tickets}</td>
	        <td align="right">Total Amount (riels)：</td>
	        <td align="left" ><fmt:formatNumber value="${total.amount}" /></td>
	      </tr>
		</table>
	 </div>
     <div style="padding:0 20px;">
         <div style="position:relative; z-index:1000px;">
           <table class="datatable" id="table1_head" width="100%">
             <tbody><tr>
               <th width="30%">Plan </th>
               <th width="5%">|</th>
               <th width="30%">Quantity (tickets)</th>
               <th width="5%">|</th>
               <th width="*%">Amount (riels)</th>
             </tr>
           </tbody></table>
         </div>
         <div id="box" style="border:1px solid #ccc;">
           <table id="fatable" class="datatable" cellpadding="0" cellspacing="0" width="100%">
             <tbody>
             <c:forEach  var="obj" items="${list}" varStatus="s">
             <tr>
                <td width="30%">${obj.planName }</td>
                <td width="5%">&nbsp;</td>
                <td width="30%">${obj.tickets }</td>
                <td width="5%">&nbsp;</td>
                <td width="*%;" style="text-align: right;"><fmt:formatNumber value="${obj.amount}" /></td>
              </tr>
             </c:forEach>
           </tbody></table>
         </div>
      </div>
	</div>
</body>
</html>