<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/views/common/taglibs.jsp"%>
<html>
<head>
<title>销售站详情</title>

<link rel="stylesheet" type="text/css" href="${basePath}/css/style.css" />
<link rel="stylesheet" type="text/css" href="${basePath}/css/pop-up.css" />
<link rel="stylesheet" type="text/css" href="${basePath}/css/validate.css" />
<script type="text/javascript" src="${basePath}/js/oms/myJs.js"></script>
<script type="text/javascript" src="${basePath}/js/jquery/jquery-1.9.1.js"></script>
</head>
<body style="margin:0;">
<div id="tck" >
		<div class="mid">
			<table width="100%" border="0" cellspacing="0" cellpadding="0" >
				<tr>
				    <td align="right" class="td" width="25%">站点编号：</td>
				    <td  align="left" class="td" width="20%">${agency.agencyCode}	</td>		
				    <td  class="td" align="right" width="25%">站点名称：</td>
        			<td class="td" align="left" > ${agency.agencyName}</td>
      			</tr>
      			
      			<tr>
			       <td class="td"  align="right">联系人：</td>
			        <td class="td" align="left">${agency.agencyManager }</td>  
			        <td  class="td" align="right">联系电话：</td>
			        <td class="td" align="left">${agency.agencyPhone}</td> 
     			 </tr>
      			
      			<tr>
			       <td class="td"  align="right">所属银行：</td>
			        <td class="td" align="left">${agency.agencyBank.bankName}</td>  
			        <td  class="td" align="right">银行账户：</td>
			        <td class="td" align="left">${agency.bankAccount}</td> 
     			 </tr>
      			
      			<tr>
			       <td class="td"  align="right">合同编号：</td>
			        <td class="td" align="left">${agency.contractNo}</td>  
			        <td  class="td" align="right">地址：</td>
			        <td class="td" align="left">${agency.agencyAddress}</td> 
     			 </tr>
			</table>
			</div>
			
		 <div style="padding:0 20px 20px 20px;">
       <div style="position:relative; z-index:1000px;margin-top: 10px;">
         <table class="datatable" id="table1_head" width="100%">
           <tbody><tr>
             <th width="20%">终端机编码</th>
             <th width="2%">|</th>
             <th width="22%">Mac地址</th>
             <th width="2%">|</th>
             <th width="22%">终端机状态</th>
             <th width="2%"></th>
           </tr>
         </tbody></table>
       </div>	
		
		<div id="box" style="border:1px solid #ccc;">
         <table id="fatable" class="datatable" cellpadding="0" cellspacing="0" width="100%">
           <tbody>
            <c:forEach var="data" items="${agencyTerminal }">
           	<tr>
              <td width="20%">
             	${data.terminalCode }
              </td>
              <td width="2%">&nbsp;</td>
              <td width="22%">${data.macAddress }</td>
              <td width="2%">&nbsp;</td>
              <td width="22%">
              	<c:if test="${data.status == 1}">可用</c:if>
              	<c:if test="${data.status == 2}">禁用</c:if>
              	<c:if test="${data.status == 3}">退机 </c:if>
              </td>
              <td width="2%">&nbsp;</td>
            </tr>
            </c:forEach>
         </tbody></table>
       </div>
		</div>

<!-- 销售员 -->
	<div style="padding:0 20px 20px 20px;">
       <div style="position:relative; z-index:1000px;margin-top: 10px;">
         <table class="datatable" id="table1_head" width="100%">
           <tbody><tr>
             <th width="20%">销售员编号</th>
             <th width="2%">|</th>
             <th width="22%">销售员姓名</th>
             <th width="2%">|</th>
             <th width="22%">销售员类型</th>
             <th width="2%">|</th>
             <th width="22%">销售员状态</th>
             <th width="2%"></th>
           </tr>
         </tbody></table>
       </div>	
		
		<div id="box" style="border:1px solid #ccc;">
         <table id="fatable" class="datatable" cellpadding="0" cellspacing="0" width="100%">
           <tbody>
            <c:forEach var="data" items="${agencyTeller }">
           	<tr>
              <td width="20%">
             	${data.tellerCode }
              </td>
              <td width="2%">&nbsp;</td>
              <td width="22%">${data.tellerName }</td>
              <td width="2%">&nbsp;</td>
              <td width="22%">
              	<c:if test="${data.newTellerType == 1}">普通销售员</c:if>
              	<c:if test="${data.newTellerType == 2}">销售站经理</c:if>
              	<c:if test="${data.newTellerType == 3}">培训员 </c:if>
              </td>
              <td width="2%">&nbsp;</td>
              <td width="22%">
              	<c:if test="${data.newTellerStatus == 1}">可用</c:if>
              	<c:if test="${data.newTellerStatus == 2}">禁用</c:if>
              	<c:if test="${data.newTellerStatus == 3}">已删除 </c:if>
              </td>
              <td width="2%">&nbsp;</td>
            </tr>
            </c:forEach>
         </tbody></table>
       </div>
	</div>
    </div>
</body>
</html>
