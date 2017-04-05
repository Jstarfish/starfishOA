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
<script type="text/javascript"	src="${basePath}/component/messageBox/myJsBox.js"></script>
<script type="text/javascript"	src="${basePath}/component/My97DatePicker/WdatePicker.js"></script>
<script type="text/javascript"	src="${basePath}/js/jquery/jquery-1.9.1.js"></script>


</head>
<body style="text-align:center">
	<div id="tck" >
	 <c:if test="${issueType==1 }">
	  <div class="mid">
	  	<table width="100%" border="0" cellspacing="0" cellpadding="0" >
	      <tr>
	        <td align="right" width="25%">Stock Transfer：</td>
	        <td align="left"  width="25%">${vo.stbNo}</td>
	        <td align="right" width="25%">Receiving Unit：</td>
	        <td align="left" >${vo.receivingUnit }</td>
	      </tr>
	      <tr>
	        <td align="right">Delivering Unit：</td>
	        <td align="left" >${vo.deliveringUnit }</td>
	        <td align="right"></td>
	        <td align="left" ></td>
	      </tr>
	   
		</table>
	</div>
	<div style="padding:0 20px;margin-bottom: 15px;">
	<p align="left">Information list</p>
         <div style="position:relative; z-index:1000px;">
         
           <table class="datatable" id="table1_head" width="100%">
             <tbody><tr>
                            <th width="10%" >Plan Code</th>
                            <th width="1%" >|</th>
                            <th width="10%" >Plan</th>
                            <th width="1%" >|</th>
                            <th width="12%" >Total Quantity(tickts)</th>
                            <th width="1%" >|</th>
                            <th width="12%" >Total Amount(riels)</th>
                           
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
	<p align="left">Library summary list</p>
         <div style="position:relative; z-index:1000px;">
         
           <table class="datatable" id="table1_head" width="100%">
             <tbody><tr>
                            <th width="10%" >Plan</th>
                            <th width="1%" >|</th>
                            <th width="10%" >Specification</th>
                            <th width="1%" >|</th>
                            <th width="12%" >Total Tickets (titckets)</th>
                            <th width="1%" >|</th>
                            <th width="12%" >Total Amount(riels)</th>
                           
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
                                <c:when test="${data.validNumber=='1' }">Trunk</c:when>
                                 <c:when test="${data.validNumber=='2' }">Box</c:when>
                                 <c:otherwise>
                                 Pack
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
	<p align="left">Library information detailed list</p>
         <div style="position:relative; z-index:1000px;">
         
           <table class="datatable" id="table1_head" width="100%">
             <tbody> <tr>
                            <th width="10%" >Plan Code</th>
                            <th width="1%" >|</th>
                            <th width="10%" >Plan Name</th>
                            <th width="1%" >|</th>
                            <th width="12%" >Batch Code</th>
                            <th width="1%" >|</th>
                            <th width="12%" >Prize Group Code</th>
                            <th width="1%" >|</th>
                            <th width="12%" >Specification</th>
                            <th width="1%" >|</th>
                            <th width="12%" >Barcode</th>
                             <th width="1%" >|</th>
                            <th width="12%" >Total Tickets</th>
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
                                <c:when test="${data.validNumber=='1' }">Trunk</c:when>
                                 <c:when test="${data.validNumber=='2' }">Box</c:when>
                                 <c:otherwise>
                                 Pack
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
                          <td  align="right" width="25%">Receivable : </td>
                          <td  align="left"  width="25%"><fmt:formatNumber value='${gvo.tickets }'  type='number' /> tickets</td>
                          
                          <td align="right" width="25%">Received : </td>
                          <td align="left"  width="25%"><fmt:formatNumber value='${gvo.actTickets }'  type='number' /> tickets</td>
                        </tr>
                         <tr>
                          
                          
                          <td align="right" width="25%">Differences : </td>
                          <td align="left"  width="25%"><fmt:formatNumber value='${differencesAmount }'  type='number' /> tickets</td>
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