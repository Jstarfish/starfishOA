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
	        <td align="right" width="25%">Return Code：</td>
	        <td align="left"  width="25%">${order.returnNo}	</td>
	        <td align="right" width="25%">Date of Order：</td>
	        <td align="left" > <fmt:formatDate value='${order.applyDate}' pattern='yyyy-MM-dd HH:mm:ss'/></td>
	      </tr>
	      <tr>
	        <td align="right" width="25%">Submitted By：</td>
	        <td align="left"  width="25%">${order.marketAdminName}	</td>
	        <td align="right" width="25%">Approve By：</td>
	        <td align="left" >${order.financeAdminName}</td>
	      </tr>
	      <tr>
	        <td align="right" width="25%">Date of Receipt：</td>
	        <td align="left"  width="25%"><fmt:formatDate value='${order.receiveDate}' pattern='yyyy-MM-dd HH:mm:ss'/>	</td>
	        <td align="right" width="25%">Receive Manager：</td>
	        <td align="left">${order.warehouseManager}</td>
	      </tr>
	      <tr>
	     	<td align="right">Quantity (tickets)：</td>
	        <td align="left" ><fmt:formatNumber value="${order.applyTickets}"/></td>
	        <td align="right">Amount (riels)：</td>
	        <td align="left" ><fmt:formatNumber value="${order.applyAmount}"/></td>
	      </tr>
		</table>
	 </div>
	<div style="padding:0 20px;">
        <div style="position:relative; z-index:1000px;">
          <table class="datatable" id="table1_head" width="100%">
            <tbody><tr>
              <th width="23%">Plan </th>
              <th width="2%">|</th>
              <th width="23%">Quantity (packs)</th>
              <th width="2%">|</th>
              <th width="23%">Quantity (tickets)</th>
              <th width="2%">|</th>
              <th width="*%">Amount (riels)</th>
            </tr>
          </tbody></table>
        </div>
        <div id="box" style="border:1px solid #ccc;">
          <table id="fatable" class="datatable" cellpadding="0 " cellspacing="0" width="100%">
            <tbody>
            <c:forEach var="item" items="${order.rdDetail}" varStatus="status">
            <tr>
              <td width="23%">${item.planName}</td>
              <td width="2%">&nbsp;</td>
              <td width="23%"><fmt:formatNumber value="${item.packages}"/></td>
              <td width="2%">&nbsp;</td>
              <td width="23%"><fmt:formatNumber value="${item.tickets}"/></td>
              <td width="2%">&nbsp;</td>
              <td width="*%" style="text-align: right;"><fmt:formatNumber value="${item.amount}"/></td>
            </tr>
            </c:forEach>
          </tbody></table>
       </div>
    </div>
 </div>
</body>
</html>