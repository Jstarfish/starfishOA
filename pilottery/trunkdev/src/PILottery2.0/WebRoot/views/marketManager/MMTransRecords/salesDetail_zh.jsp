<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8"%>
<%@ include file="/views/common/taglibs.jsp"%>
<html>
<head>
<title>销售详情</title>

<%@ include file="/views/common/meta.jsp"%>
<link rel="stylesheet" type="text/css" href="${basePath}/css/style.css" />
<link rel="stylesheet"	href="${basePath}/component/messageBox/myJsBox.css" type="text/css" />
<link href="${basePath}/views/inventory/goodsReceipts/css/style3.css" rel="stylesheet" type="text/css" />
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
	        <td align="right" width="15%">站点编号：</td>
	        <td align="left"  width="15%">${saleDetail_1.outletCode }</td>
	        <td align="right" width="15%">日期：</td>
	        <td align="left" ><fmt:formatDate value='${saleDetail_1.saleDate }' pattern='yyyy-MM-dd HH:mm:ss'/></td>
	      </tr>
	      <tr>
	        <td align="right">销售金额：</td>
	        <td align="left" >${saleDetail_1.saleAmount }</td>
	        <td align="right">销售佣金: </td>
	        <td align="left" >${saleDetail_1.saleComm }</td>
	      </tr>
		</table>
	</div>
	 <div style="padding:0 20px;margin-bottom: 45px;">
	<p align="left"></p>
         <div style="position:relative; z-index:1000px;">
           <table class="datatable" id="table1_head" width="100%">
             <tbody><tr>
                            <th width="8%" >方案</th>
                            <th width="1%" >|</th>
                            <th width="8%" >票数</th>
                            <th width="1%" >|</th>
                            <th width="8%" >金额(瑞尔)</th>
                          </tr>
           </tbody></table>
         </div>
         <div id="box" style="border:1px solid #ccc;">
         
           <table id="fatable" class="datatable" cellpadding="0 " cellspacing="0" width="100%">
             <tbody>
             <c:forEach var="data" items="${saleDetail_2}">
                   <tr>
                     <td width="8%" >${data.planCode }</td>
                     <td width="1%" ></td>
                     <td width="8%" ><fmt:formatNumber value='${data.tickets}' type='number'/></td>
                     <td width="1%" ></td>
                     <td width="8%" style="text-align:right" ><fmt:formatNumber value="${data.sumAmount }" type="number"/></td>
                   </tr>
              </c:forEach>
           </tbody></table>
         </div>
      </div>
      <c:if test="${issueType!=1 }">
      <div style="padding:0 20px;margin-bottom: 20px;">
	</div>
      
      </c:if>
      
      
      <div style="padding:0 20px;margin-bottom: 15px;">
	<p align="left"></p>
         <div style="position:relative; z-index:1000px;">
         
           <table class="datatable" id="table1_head" width="100%">
             <tbody><tr>
                            <th width="10%" >规格</th>
                            <th width="1%" >|</th>
                            <th width="12%" >金额(瑞尔)</th>
                           
                          </tr>
           </tbody></table>
         </div>
         <div id="box" style="border:1px solid #ccc;">
         
           <table id="fatable" class="datatable" cellpadding="0 " cellspacing="0" width="100%">
             <tbody>
            <c:forEach var="data" items="${saleDetail_3}">
                          <tr>
                             <td width="10%" >${data.saleSpecification}</td>
                            <td width="1%" ></td>
                            <%-- <td width="10%" ><c:choose>
                                <c:when test="${data.validNumber=='1' }">Trunk</c:when>
                                 <c:when test="${data.validNumber=='2' }">Box</c:when>
                                 <c:otherwise>
                                 Pack
                                 </c:otherwise>
                            </c:choose></td>
                            <td width="1%" ></td> --%>
                            <td width="12%" style="text-align:right"><fmt:formatNumber value="${data.amount}" type="number"/></td>
                          </tr>
              </c:forEach>
           </tbody></table>
         </div>
      </div>
   </div>
</body>
</html>