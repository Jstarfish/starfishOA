<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/views/common/taglibs.jsp"%>
<html>
<head>
<title>出货单明细</title>

<link rel="stylesheet" type="text/css" href="${basePath}/css/style.css" />
<link rel="stylesheet" type="text/css" href="${basePath}/css/pop-up.css" />
<link rel="stylesheet" type="text/css" href="${basePath}/css/validate.css" />
<script type="text/javascript" src="${basePath}/js/oms/myJs.js"></script>
<script type="text/javascript" src="${basePath}/js/jquery/jquery-1.9.1.js"></script>

<script type="text/javascript">
</script>

</head>
<body>
	<div id="tck" >
	  <div class="mid">
	  	<table width="100%" border="0" cellspacing="0" cellpadding="0" >
	      <tr>
	        <td align="right" width="25%">出货单编号：</td>
	        <td align="left"  width="25%">${order.doNo}	</td>
	        <td align="right" width="25%">提交人：</td>
	        <td align="left" > ${order.applyAdminName}</td>
	      </tr>
	      <tr>
	        <td align="right">提交日期：</td>
	        <td align="left" ><fmt:formatDate value="${order.applyDate}" pattern="yyyy-MM-dd HH:mm:ss"/></td>
	        <td align="right">发货日期：</td>
	        <td align="left" ><fmt:formatDate value="${order.outDate}" pattern="yyyy-MM-dd HH:mm:ss"/></td>
	      </tr>
	       <tr>
	        <td align="right">发货单位：</td>
	        <td align="left" >${order.orgName}</td>
	        <td align="right">发货人：</td>
	        <td align="left" >${order.managerAdminName}</td>
	      </tr>
	      <tr>
	     	<td align="right">票数 (tickets)：</td>
	        <td align="left" > <fmt:formatNumber value="${order.totalTickets}"/></td>
	        <td align="right">总金额 (riels)：</td>
	        <td align="left" ><fmt:formatNumber value="${order.totalAmount}"/></td>
	      </tr>
	      <tr>
	        <td align="right">备注：</td>
	        <td align="left" colspan="3">${order.remark }</td>
	      </tr>
		</table>
	 </div>
     <div style="padding:0 20px;">
         <div style="position:relative; z-index:1000px;">
           <table class="datatable" id="table1_head" width="100%">
             <tbody><tr>
               <th width="22%">方案名称 </th>
               <th width="2%">|</th>
               <th width="22%">数量 (packs)</th>
               <th width="2%">|</th>
               <th width="22%">张数 (tickets)</th>
               <th width="2%">|</th>
               <th width="*%">金额 (riels)</th>
             </tr>
           </tbody></table>
         </div>
         <div id="box" style="border:1px solid #ccc;">
           <table id="fatable" class="datatable" cellpadding="0" cellspacing="0" width="100%">
             <tbody>
             <c:forEach  var="detail" items="${order.deliveryDetail}" varStatus="s">
             <tr>
                <td width="22%">${detail.planName}</td>
                <td width="2%">&nbsp;</td>
                <td width="22%"><fmt:formatNumber value="${detail.packages}"/></td>
                <td width="2%">&nbsp;</td>
                <td width="22%"><fmt:formatNumber value="${detail.tickets}"/></td>
                <td width="2%">&nbsp;</td>
                <td width="*%;" style="text-align: right"><fmt:formatNumber value="${detail.amount}"/></td>
              </tr>
             </c:forEach>
           </tbody></table>
         </div>
      </div>
	</div>
</body>
</html>