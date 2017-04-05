<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8"%>
<%@ include file="/views/common/taglibs.jsp"%>
<html>
<head>

<title>List of Purchase Orders</title>

<%@ include file="/views/common/meta.jsp"%>
<link rel="stylesheet" type="text/css" href="${basePath}/css/style.css" />
<link rel="stylesheet"	href="${basePath}/component/messageBox/myJsBox.css" type="text/css" />
<link rel="stylesheet" type="text/css" href="${basePath}/css/pop-up.css" />
<script type="text/javascript"	src="${basePath}/component/messageBox/myJsBox_zh.js"></script>
<script type="text/javascript"	src="${basePath}/component/My97DatePicker/WdatePicker.js"></script>
<script type="text/javascript"	src="${basePath}/js/jquery/jquery-1.9.1.js"></script>

</head>
<body style="text-align:center">
	<div id="tck" >
	  <div class="mid">
	  	<table width="100%" border="0" cellspacing="0" cellpadding="0" >
	      <tr>
	        <td align="right" width="25%">订单编号：</td>
	        <td align="left"  width="25%">${order.orderNo}	</td>
	        <td align="right" width="25%">订单日期：</td>
	        <td align="left" ><fmt:formatDate value='${order.applyDate}' pattern='yyyy-MM-dd HH:mm:ss'/></td>
	      </tr>
	      <tr>
	        <td align="right">站点编号：</td>
	        <td align="left" >${order.applyAgency}</td>
	        <td align="right">联系电话：</td>
	        <td align="left" >${order.applyContact}</td>
	      </tr>
	      <tr>
	     	<td align="right">总张数 (张)：</td>
	        <td align="left" > <fmt:formatNumber value="${order.applyTickets}"/></td>
	        <td align="right">总金额 (瑞尔)：</td>
	        <td align="left" ><fmt:formatNumber value="${order.applyAmount}"/></td>
	      </tr>
	      <tr>
	        <td align="right">备注：</td>
	        <td align="left" colspan="3">${order.remark }</td>
	      </tr>
		</table>
	</div>
	<div style="padding:0 20px;margin-bottom: 15px;">
         <div style="position:relative; z-index:1000px;">
           <table class="datatable" id="table1_head" width="100%">
             <tbody><tr>
               <th width="30%">方案名称 </th>
               <th width="2%">|</th>
               <th width="30%">张数 (张)</th>
               <th width="2%">|</th>
               <th width="*%">金额 (瑞尔)</th>
             </tr>
           </tbody></table>
         </div>
         <div id="box" style="border:1px solid #ccc;">
           <table id="fatable" class="datatable" cellpadding="0 " cellspacing="0" width="100%">
             <tbody>
             <c:forEach var="item" items="${order.orderDetail}" varStatus="status">
             <tr>
               <td width="30%"> ${item.planName} </td>
               <td width="2%">&nbsp;</td>
               <td width="30%"><fmt:formatNumber value='${item.tickets}'/></td>
               <td width="2%">&nbsp;</td>
               <td width="*%" style="text-align: right"><fmt:formatNumber value='${item.amount}'/></td>
             </tr>
             </c:forEach>
           </tbody></table>
         </div>
      </div>
   </div>
</body>
</html>