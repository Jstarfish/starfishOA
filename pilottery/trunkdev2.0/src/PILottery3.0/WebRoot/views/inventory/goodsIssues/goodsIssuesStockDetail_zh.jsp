<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8"%>
<%@ include file="/views/common/taglibs.jsp"%>
<html>
<head>

<title>List of Purchase Orders</title>

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
	 <c:if test="${issueType==1 }">
	  <div class="mid">
	  	<table width="100%" border="0" cellspacing="0" cellpadding="0" >
	      <tr>
	        <td align="right" width="25%">调拨单编号：</td>
	        <td align="left"  width="25%">${vo.stbNo}</td>
	        <td align="right" width="25%">接收单位：</td>
	        <td align="left" >${vo.receivingUnit }</td>
	      </tr>
	      <tr>
	        <td align="right">交付单位：</td>
	        <td align="left" >${vo.deliveringUnit }</td>
	        <td align="right"></td>
	        <td align="left" ></td>
	      </tr>
	   
		</table>
	</div>
	<div style="padding:0 20px;margin-bottom: 15px;">
	<p align="left">出货列表</p>
         <div style="position:relative; z-index:1000px;">
         
           <table class="datatable" id="table1_head" width="100%">
             <tbody><tr>
                            <th width="10%" >方案编码</th>
                            <th width="1%" >|</th>
                            <th width="10%" >方案名称</th>
                            <th width="1%" >|</th>
                            <th width="12%" >总票数(张)</th>
                            <th width="1%" >|</th>
                            <th width="12%" >总金额(瑞尔)</th>
                           
                          </tr>
           </tbody></table>
         </div>
         <div id="box" style="border:1px solid #ccc;">
         
           <table id="fatable" class="datatable" cellpadding="0 " cellspacing="0" width="100%">
             <tbody>
             <c:forEach var="data" items="${listvo}">
                          <tr>
                             <td width="10%" >${data.planCode }</td>
                            <td width="1%" ></td>
                            <td width="10%" >${data.planName }</td>
                            <td width="1%" ></td>
                            <td width="12%" ><fmt:formatNumber value='${data.tickets}' type='number'/></td>
                            <td width="1%" ></td>
                            <td width="12%" style="text-align:right" ><fmt:formatNumber value="${data.amount}" type="number"/></td>
                           
                      
                          </tr>
                          </c:forEach>
           </tbody></table>
         </div>
      </div>
      </c:if>
      <c:if test="${issueType!=1 }">
      <div style="padding:0 20px;margin-bottom: 20px;">
	</div>
      
      </c:if>
      <div style="padding:0 20px;margin-bottom: 15px;">
	<p align="left">汇总列表</p>
         <div style="position:relative; z-index:1000px;">
         
           <table class="datatable" id="table1_head" width="100%">
             <tbody><tr>
                            <th width="10%" >方案名称</th>
                            <th width="1%" >|</th>
                            <th width="10%" >规格</th>
                            <th width="1%" >|</th>
                            <th width="12%" >总票数 (张)</th>
                            <th width="1%" >|</th>
                            <th width="12%" >总金额(瑞尔)</th>
                           
                          </tr>
           </tbody></table>
         </div>
         <div id="box" style="border:1px solid #ccc;">
         
           <table id="fatable" class="datatable" cellpadding="0 " cellspacing="0" width="100%">
             <tbody>
            <c:forEach var="data" items="${listdevosum}">
                          <tr>
                             <td width="10%" >${data.planName}</td>
                            <td width="1%" ></td>
                            <td width="10%" ><c:choose>
                                <c:when test="${data.validNumber=='1' }">箱</c:when>
                                 <c:when test="${data.validNumber=='2' }">盒</c:when>
                                 <c:otherwise>
                                 本
                                 </c:otherwise>
                            </c:choose></td>
                            <td width="1%" ></td>
                            <td width="12%" ><fmt:formatNumber value="${data.tickets}" type="number"/></td>
                            <td width="1%" ></td>
                            <td width="12%" style="text-align:right"><fmt:formatNumber value="${data.amount}" type="number"/></td>
                           
                      
                          </tr>
                          </c:forEach>
           </tbody></table>
         </div>
      </div>
        <div style="padding:0 20px;margin-bottom: 15px;">
	<p align="left">出货详细列表</p>
         <div style="position:relative; z-index:1000px;">
         
           <table class="datatable" id="table1_head" width="100%">
             <tbody> <tr>
                            <th width="10%" >方案编码</th>
                            <th width="1%" >|</th>
                            <th width="10%" >方案名称</th>
                            <th width="1%" >|</th>
                            <th width="12%" >批次编码</th>
                            <th width="1%" >|</th>
                            <th width="12%" >奖组号码</th>
                            <th width="1%" >|</th>
                            <th width="12%" >规格</th>
                            <th width="1%" >|</th>
                            <th width="12%" >条码</th>
                             <th width="1%" >|</th>
                            <th width="12%" >总票数</th>
                          </tr>
           </tbody></table>
         </div>
         <div id="box" style="border:1px solid #ccc;">
         
           <table id="fatable" class="datatable" cellpadding="0 " cellspacing="0" width="100%">
             <tbody>
           <c:forEach var="data" items="${listdevo}">
                          <tr>
                             <td width="10%" >${data.planCode }</td>
                            <td width="1%" ></td>
                              <td width="10%" >${data.planName }</td>
                            <td width="1%" ></td>
                              <td width="12%" >${data.batchNo }</td>
                               <td width="1%" ></td>
                                <td width="12%" >${data.rewardNo }</td>
                               <td width="1%" ></td>
                            <td width="12%" ><c:choose>
                                <c:when test="${data.validNumber=='1' }">箱</c:when>
                                 <c:when test="${data.validNumber=='2' }">盒</c:when>
                                 <c:otherwise>
                                 本
                                 </c:otherwise>
                            </c:choose></td>
                              <td width="1%" ></td>
                            <td width="12%" ><c:choose>
                                <c:when test="${data.validNumber=='1' }">${data.trunkNo }</c:when>
                                 <c:when test="${data.validNumber=='2' }">${data.boxNo }</c:when>
                                 <c:otherwise>
                                ${data.packageNo }
                                 </c:otherwise>
                            </c:choose></td>
                            <td width="1%" ></td>
                            <td width="12%" ><fmt:formatNumber value='${data.tickets}'  type='number' /></td>
                            
                           
                      
                          </tr>
                          </c:forEach>
                    
           </tbody></table>
         </div>
      </div>
     
                
                     <div class="mid">
	  <table width="100%" border="0" cellspacing="0" cellpadding="0">
                     <tr>
                          <td  align="right" width="25%">应出库 : </td>
                          <td  align="left"  width="25%"><fmt:formatNumber value='${gvo.tickets }'  type='number' /> 张</td>
                          
                          <td align="right" width="25%">实际出库 : </td>
                          <td align="left"  width="25%"><fmt:formatNumber value='${gvo.actTickets }'  type='number' /> 张</td>
                        </tr>
                         <tr>
                          
                          
                          <td align="right" width="25%">差异 : </td>
                          <td align="left"  width="25%"><fmt:formatNumber value='${differencesAmount }'  type='number' /> 张</td>
                          <td align="right" width="25%"></td>
                          <td  align="left"  width="25%"></td>
                        </tr>
                       
                       
                       
                    
                 
                  <tr>
                    <td><div style="margin:10px 40px; float:right;">
                    
                        
                      </div></td>
                  </tr>
                </table>
	</div>
   </div>
</body>
</html>