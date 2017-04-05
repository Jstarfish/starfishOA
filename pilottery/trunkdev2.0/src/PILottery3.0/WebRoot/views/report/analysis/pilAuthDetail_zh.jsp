<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/views/common/taglibs.jsp"%>
<html>
<head>
<title>即开票详情</title>

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
             <th width="20%">游戏编码</th>
             <th width="2%">|</th>
             <th width="20%">游戏名称</th>
             <th width="2%">|</th>
             <th width="20%">销售佣金比例(‰)</th>
             <th width="2%">|</th>
             <th width="*%">兑奖佣金比例(‰)</th>
           </tr>
         </tbody></table>
       </div>	
		
		<div id="box" style="border:1px solid #ccc;">
         <table id="fatable" class="datatable" cellpadding="0" cellspacing="0" width="100%">
           <tbody>
            <c:forEach var="data" items="${authDetails }">
           	<tr>
              <td width="20%">${data.gameCode } </td>
              <td width="2%">&nbsp;</td>
              <td width="20%">${data.gameName }</td>
              <td width="2%">&nbsp;</td>
              <td width="20%">${data.saleComm }</td>
              <td width="2%">&nbsp;</td>
              <td width="*%">${data.payoutComm }</td>
            </tr>
            </c:forEach>
         </tbody></table>
       </div>
	</div>

</body>
</html>
