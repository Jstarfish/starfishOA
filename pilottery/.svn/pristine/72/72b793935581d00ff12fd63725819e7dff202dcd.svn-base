<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/views/common/taglibs.jsp"%>
<html>
<head>
<title>电脑票详情</title>

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
             <th width="13%">游戏编码</th>
             <th width="1%">|</th>
             <th width="13%">游戏名称</th>
             <th width="1%">|</th>
             <th width="13%">是否可销售</th>
             <th width="1%">|</th>
             <th width="13%">是否可兑奖</th>
             <th width="1%">|</th>
             <th width="13%">是否可退票</th>
             <th width="1%">|</th>
             <th width="13%">销售佣金比例(‰)</th>
             <th width="1%">|</th>
             <th width="*%">兑奖佣金比例(‰)</th>
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
              	<c:if test="${data.isSale == 1}">是</c:if>
              	<c:if test="${data.isSale == 0}">否</c:if>
              </td>
              <td width="1%">&nbsp;</td>
              <td width="13%">
              	<c:if test="${data.isPayout == 1}">是</c:if>
              	<c:if test="${data.isPayout == 0}">否</c:if>
              </td>
              <td width="1%">&nbsp;</td>
              <td width="13%">
              	<c:if test="${data.isCancel == 1}">是</c:if>
              	<c:if test="${data.isCancel == 0}">否</c:if>
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
