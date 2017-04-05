<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8"%>
<%@ include file="/views/common/taglibs.jsp"%>
<html>
<head>
<title>兑奖详情</title>

<%@ include file="/views/common/meta.jsp"%>
<link rel="stylesheet" type="text/css" href="${basePath}/css/style.css" />
<link rel="stylesheet"	href="${basePath}/component/messageBox/myJsBox.css" type="text/css" />
<link href="${basePath}/views/inventory/goodsReceipts/css/style3.css" rel="stylesheet" type="text/css" />
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
	        <td align="right" width="15%">站点编号：</td>
	        <td align="left"  width="15%">${payoutDetail_1.outletCode }</td>
	        <td align="right" width="15%">日期：</td>
	        <td align="left" ><fmt:formatDate value='${payoutDetail_1.payoutDate }' pattern='yyyy-MM-dd HH:mm:ss'/></td>
	      </tr>
	      <tr>
	        <td align="right">兑奖金额：</td>
	        <td align="left" >${payoutDetail_1.payoutAmount }</td>
	        <td align="right">兑奖佣金: </td>
	        <td align="left" >${payoutDetail_1.payoutComm }</td>
	      </tr>
		</table>
	</div>
	 <div style="padding:0 20px;margin-bottom: 45px;">
	<p align="left"></p>
         <div style="position:relative; z-index:1000px;">
           <table class="datatable" id="table1_head" width="100%">
             <tbody><tr>
                            <th width="12%" >奖级(瑞尔)</th>
                            <th width="1%" >|</th>
                            <th width="12%" >票数</th>
                            <th width="1%" >|</th>
                            <th width="12%" >金额(瑞尔)</th>
                          </tr>
           </tbody></table>
         </div>
         <div id="box" style="border:1px solid #ccc;">
         
           <table id="fatable" class="datatable" cellpadding="0 " cellspacing="0" width="100%">
             <tbody>
             <c:forEach var="data" items="${payoutDetail_2}">
                   <tr>
                     <td width="12%" style="text-align:right" ><fmt:formatNumber value="${data.levelAmount }" type="number"/></td>
                     <td width="1%" ></td>
                     <td width="12%" ><fmt:formatNumber value='${data.tickets}' type='number'/></td>
                     <td width="1%" ></td>
                     <td width="12%" style="text-align:right" ><fmt:formatNumber value="${data.amount }" type="number"/></td>
                   </tr>
              </c:forEach>
           </tbody></table>
         </div>
      </div>
      
      <div style="padding:0 20px;margin-bottom: 15px;">
	<p align="left"></p>
         <div style="position:relative; z-index:1000px;">
         
           <table class="datatable" id="table1_head" width="100%">
             <tbody><tr>
                            <th width="20%" >规格</th>
                            <th width="1%" >|</th>
                            <th width="20%" >状态</th>
                          </tr>
           </tbody></table>
         </div>
         <div id="box" style="border:1px solid #ccc;">
         
           <table id="fatable" class="datatable" cellpadding="0 " cellspacing="0" width="100%">
             <tbody>
            <c:forEach var="data" items="${payoutDetail_3}">
                          <tr>
                             <td width="20%" >${data.payoutSpecification}</td>
                            <td width="1%" ></td>
                            <td width="20%">
                            	<c:choose>
	                                 <c:when test="${data.payoutStatus=='1' }">成功</c:when>
	                                 <c:when test="${data.payoutStatus=='2' }">非法票</c:when>
	                                 <c:when test="${data.payoutStatus=='3' }">已兑奖</c:when>
	                                 <c:when test="${data.payoutStatus=='4' }">大奖</c:when>
	                                 <c:when test="${data.payoutStatus=='5' }">未中奖</c:when>
	                                 <c:when test="${data.payoutStatus=='6' }">未销售</c:when>
	                                 <c:when test="${data.payoutStatus=='8' }">批次终结</c:when>
	                               <%--   <c:otherwise>
	                                 	Pack
	                                 </c:otherwise> --%>
                            </c:choose></td>
                          </tr>
              </c:forEach>
           </tbody></table>
         </div>
      </div>
   </div>
</body>
</html>