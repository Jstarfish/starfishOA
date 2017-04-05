<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/views/common/taglibs.jsp"%>
<html>
<head>
<title>PIL Detail</title>

<link rel="stylesheet" type="text/css" href="${basePath}/css/style.css" />
<link rel="stylesheet" type="text/css" href="${basePath}/css/pop-up.css" />
<link rel="stylesheet" type="text/css" href="${basePath}/css/validate.css" />
<script type="text/javascript" src="${basePath}/js/oms/myJs.js"></script>
<script type="text/javascript" src="${basePath}/js/jquery/jquery-1.9.1.js"></script>
</head>
<body style="margin:0;">
	<div id="tck" >
       <div>
         <table class="datatable" id="table1_head" width="100%">
           <tbody><tr>
             <th width="13%">Game Code</th>
             <th width="1%">|</th>
             <th width="13%">Game Name</th>
             <th width="1%">|</th>
             <th width="13%">Sale</th>
             <th width="1%">|</th>
             <th width="13%">Payout</th>
             <th width="1%">|</th>
             <th width="13%">Cancel</th>
             <th width="1%">|</th>
             <th width="13%">Sale Comm(‰)</th>
             <th width="1%">|</th>
             <th width="*%">Payout Comm(‰)</th>
           </tr>
         </tbody></table>
       </div>	
		
		<div id="box" style="border:1px solid #ccc;">
         <table id="fatable" class="datatable" cellpadding="0" cellspacing="0" width="100%">
           <tbody>
            <c:forEach var="data" items="${authDetails }">
           	<tr>
              <td width="13%">${data.gameCode } </td>
              <td width="1%">&nbsp;</td>
              <td width="13%">${data.gameName }</td>
              <td width="1%">&nbsp;</td>
              <td width="13%">
              	<c:if test="${data.isSale == 1}">Y</c:if>
              	<c:if test="${data.isSale == 0}">N</c:if>
              </td>
              <td width="1%">&nbsp;</td>
              <td width="13%">
              	<c:if test="${data.isPayout == 1}">Y</c:if>
              	<c:if test="${data.isPayout == 0}">N</c:if>
              </td>
              <td width="1%">&nbsp;</td>
              <td width="13%">
              	<c:if test="${data.isCancel == 1}">Y</c:if>
              	<c:if test="${data.isCancel == 0}">N</c:if>
              </td>
              <td width="1%">&nbsp;</td>
              <td width="13%">${data.saleComm }</td>
              <td width="1%">&nbsp;</td>
              <td width="*%">${data.payoutComm }</td>
            </tr>
            </c:forEach>
         </tbody></table>
       </div>
	</div>

</body>
</html>
