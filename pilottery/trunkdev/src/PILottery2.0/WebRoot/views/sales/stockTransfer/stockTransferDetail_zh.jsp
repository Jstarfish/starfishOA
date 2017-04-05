<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8"%>
<%@ include file="/views/common/taglibs.jsp"%>
<html>
<head>

<title></title>

<%@ include file="/views/common/meta.jsp"%>
<link rel="stylesheet" type="text/css" href="${basePath}/css/style.css" />
<link rel="stylesheet"	href="${basePath}/component/messageBox/myJsBox.css" type="text/css" />
<link rel="stylesheet" type="text/css" href="${basePath}/css/pop-up.css" />
<script type="text/javascript"	src="${basePath}/component/messageBox/myJsBox.js"></script>
<script type="text/javascript"	src="${basePath}/component/My97DatePicker/WdatePicker.js"></script>
<script type="text/javascript"	src="${basePath}/js/jquery/jquery-1.9.1.js"></script>
</head>
<body style="text-align:center">
<div id="tck" >
	  <div class="mid">
	  	<table width="100%" border="0" cellspacing="0" cellpadding="0" >
	      <tr>
	        <td align="right" width="25%">调拨单编号：</td>
	        <td align="left"  width="25%">${order.stbNo}	</td>
	        <td align="right" width="25%">申请日期：</td>
	        <td align="left" ><fmt:formatDate value='${order.applyDate}' pattern='yyyy-MM-dd HH:mm:ss'/></td>
	      </tr>
	      <tr>
	        <td align="right">申请人：</td>
	        <td align="left" >${order.applyName}</td>
	        <td align="right">审批人：</td>
	        <td align="left" >${order.approveName}</td>
	      </tr>
	      <tr>
	        <td align="right">发货单位：</td>
	        <td align="left" >${order.sendOrgName}</td>
	        <td align="right">发货人：</td>
	        <td align="left" >${order.sendManagerName}</td>
	      </tr>
	      <tr>
	        <td align="right">收货单位：</td>
	        <td align="left" >${order.receiveOrgName}</td>
	        <td align="right">发货时间：</td>
	        <td align="left" ><fmt:formatDate value="${order.sendDate}" pattern="yyyy-MM-dd HH:mm:ss"/></td>
	      </tr>
	      <tr>
	        <td align="right">收货时间：</td>
	        <td align="left" ><fmt:formatDate value="${order.receiveDate}" pattern="yyyy-MM-dd HH:mm:ss"/></td>
	        <td align="right">总张数 (张)：</td>
	        <td align="left" > <fmt:formatNumber value="${order.tickets}"/></td>
	      </tr>
	      <tr>
	        <td align="right">总金额 (瑞尔)：</td>
	        <td align="left" ><fmt:formatNumber value="${order.amount}"/></td>
	        <td align="right">备注：</td>
	        <td align="left" colspan="3">${order.remark }</td>
	      </tr>
		</table>
	</div>

	<div style="padding:0 20px;margin-bottom: 20px;">
         <div style="position:relative; z-index:1000px;">
           <table class="datatable" id="table1_head" width="100%">
             <tbody><tr>
               <th width="23%">方案名称 </th>
               <th width="2%">|</th>
               <th width="23%">本数 (本)</th>
               <th width="2%">|</th>
               <th width="23%">张数 (张)</th>
               <th width="2%">|</th>
               <th width="*%">金额 (瑞尔)</th>
             </tr>
           </tbody></table>
         </div>
         <div id="box" style="border:1px solid #ccc;">
           <table id="fatable" class="datatable" cellpadding="0 " cellspacing="0" width="100%">
             <tbody>
             <c:forEach var="item" items="${order.transferDetail}" varStatus="status">
             <tr>
               <td width="23%">${item.planName}</td>
               <td width="2%">&nbsp;</td>
               <td width="23%"><fmt:formatNumber value='${item.packages}'/></td>
               <td width="2%">&nbsp;</td>
               <td width="23%"><fmt:formatNumber value='${item.detailTickets}'/></td>
               <td width="2%">&nbsp;</td>
               <td width="*%" style="text-align: right;"><fmt:formatNumber value='${item.detailAmount}'/></td>
             </tr>
             </c:forEach>
           </tbody></table>
         </div>
   </div>
</div>

</body>
</html>