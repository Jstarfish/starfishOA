<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8"%>
<%@ include file="/views/common/taglibs.jsp"%>
<html>
<head>

<title>List of Purchase Orders</title>

<%@ include file="/views/common/meta.jsp"%>

<link rel="stylesheet" type="text/css" href="${basePath}/css/pop-up.css" />
<script type="text/javascript"	src="${basePath}/component/messageBox/myJsBox.js"></script>
<script type="text/javascript"	src="${basePath}/component/My97DatePicker/WdatePicker.js"></script>
<script type="text/javascript"	src="${basePath}/js/jquery/jquery-1.9.1.js"></script>
<style type="text/css">
.edui-editor1 {
	border: 1px solid #DDD;
	border-top: 1px solid #EBEBEB;
	border-bottom: 1px solid #B7B7B7;
	background-color: #fff;
	position: relative;
	overflow: visible;
	border-radius: 4px;
	-moz-border-radius: 4px;
	-webkit-border-radius: 4px;
	box-shadow: 0 1px 1px #d3d1d1;
	margin-top: 0px;
	width: 100%;
	font-family: "微软雅黑";
	color: #000;
	font-size: 14px;
	padding: 5px;
}

</style>

</head>
<body style="text-align:center">
	<div id="tck" >
	<div style="padding:0 20px;margin-bottom: 20px;">
	</div>
	<div style="padding:0 20px;margin-bottom: 20px;">

	<p align="left">Details of Goods Receipts Information</p>
         <div style="position:relative; z-index:1000px;">
         
           <table class="datatable" id="table1_head" width="100%">
             <tbody><tr>
                            <th width="10%" >Plan Code</th>
                            <th width="1%" >|</th>
                            <th width="10%" >Specification</th>
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
              <c:forEach var="data" items="${listdetail}">
                          <tr>
                             <td width="10%" >${data.planCode }</td>
                            <td width="1%" ></td>
                            <td width="10%" ><c:choose>
                                <c:when test="${data.validNumber=='1' }">Trunk</c:when>
                                 <c:when test="${data.validNumber=='2' }">Box</c:when>
                                 <c:otherwise>
                                 Pack
                                 </c:otherwise>
                            </c:choose>
                            </td>
                            <td width="1%" ></td>
                            <td width="12%" ><fmt:formatNumber value='${data.tickets}'/></td>
                            <td width="1%" ></td>
                            <td width="12%" style="text-align:right" ><fmt:formatNumber value="${data.amount}" type="number"/></td>
                         
                          </tr>
                          </c:forEach>
           </tbody></table>
         </div>
      </div>
      <div style="padding:0 20px;margin-bottom: 15px;">
	<p align="left">Details of Goods Receipts Information</p>
         <div style="position:relative; z-index:1000px;">
         
           <table class="datatable" id="table1_head" width="100%">
             <tbody><tr>
                            <th width="10%" >Plan Code</th>
                            <th width="1%" >|</th>
                            <th width="10%" >Plan Name</th>
                            <th width="1%" >|</th>
                            <th width="12%" >Batch Code</th>
                            
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
            <c:forEach var="data" items="${detail}">
                          <tr>
                             <td width="10%" >${data.planCode }</td>
                            <td width="1%" ></td>
                              <td width="10%" >${data.planName }</td>
                            <td width="1%" ></td>
                              <td width="12%" >${data.batchNo}</td>
                              
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
                            <td width="12%"><fmt:formatNumber value='${data.tickets }'/></td>
                    
                          </tr>
                      
                          </c:forEach>
                               <tr>
                             <td width="10%" >Total Tickets</td>
                            <td width="1%" ></td>
                              <td width="10%" ></td>
                            <td width="1%" ></td>
                              <td width="12%" ></td>
                              
                               <td width="1%" ></td>
                            <td width="12%" ></td>
                              <td width="1%" ></td>
                            <td width="12%" >
                                </td>
                            <td width="1%" ></td>
                            <td width="12%" ><fmt:formatNumber value='${detailsum.tickets }'/></td>
                            
                           
                      
                          </tr>
           </tbody></table>
         </div>
      </div>
    
     
        <div class="mid">
	  <table width="100%" border="0" cellspacing="0" cellpadding="0">
                     <tr>
                          <td  align="right" width="25%">Receivable : </td>
                          <td  align="left"  width="25%"><fmt:formatNumber value='${vo.receiptTickets }'/> tickets</td>
                          
                          <td align="right" width="25%">Received : </td>
                          <td align="left"  width="25%"><fmt:formatNumber value='${vo.actReceiptTickets }'/> tickets</td>
                        </tr>
                         <tr>
                          
                          
                          <td align="right" width="25%">Differences : </td>
                          <td align="left"  width="25%"><fmt:formatNumber value='${differencesAmount }'/> tickets</td>
                          <td align="right" width="25%">Quantity Damaged :</td>
                          <td  align="left"  width="25%"><fmt:formatNumber value='${differencesAmount }'/> tickets</td>
                        </tr>
                      
	                       <c:if test="${!empty vo.remark }">
	                        <tr>
	                          <td style="padding-top:20px; " colspan="4" >Remarks :
	                            <textarea name="remarks" rows="5" readonly="readonly" class="edui-editor1" >${vo.remark}</textarea></td>
	                        </tr>
	                        </c:if>
                    
                    
                 
                  <tr>
                    <td><div style="margin:10px 40px; float:right;">
                    
                        
                      </div></td>
                  </tr>
                </table>
	</div>
   </div>
</body>
</html>