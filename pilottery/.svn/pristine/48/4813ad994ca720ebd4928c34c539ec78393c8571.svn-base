<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/views/common/taglibs.jsp"%>
<html>
<head>

<title>List of Goods Receipts (Lottery)</title>

<%@ include file="/views/common/meta.jsp" %>
<link rel="stylesheet" type="text/css" href="${basePath}/css/style.css" />
<link rel="stylesheet" href="${basePath}/component/messageBox/myJsBox.css" type="text/css"/>
<script type="text/javascript" src="${basePath}/component/messageBox/myJsBox.js"></script>
<script type="text/javascript" src="${basePath}/component/My97DatePicker/WdatePicker.js"></script>
<script type="text/javascript" src="${basePath}/js/jquery/jquery-1.9.1.js"></script>

<script type="text/javascript" charset="UTF-8">
function updateQuery() {
   $("#goodsReceiptsForm").submit();
}
function onNextGoodrecipts(val,type,refNo){
	if(type=='1'){
		window.location.href="goodsReceipts.do?method=continueGoodreceipt&sgrNo="+val+"&refNo="+refNo;
	}
	if(type=='2'){
		window.location.href="goodsReceipts.do?method=continueGoodTranser&sgrNo="+val+"&refNo="+refNo;;
	}
	if(type=='3'){
		window.location.href="goodsReceipts.do?method=continueGoodReturn&sgrNo="+val+"&refNo="+refNo;;
	}
	
}
function onFinish(type,refNo){
	window.location.href="goodsReceipts.do?method=finishGoodreceipt&type="+type+"&refNo="+refNo;
}
function onComplete(type,refNo){
	window.location.href="goodsReceipts.do?method=completeGoodreceipt&type="+type+"&refNo="+refNo;
}
</script>

</head>
<body>
    <!-- 顶部标题块 -->
    <div id="title">Goods Receipts (Lottery)</div>
    
    <!-- 查询条件块 -->
    <div class="queryDiv">
        <form action="goodsReceipts.do?method=listGoodsReceipts" id="goodsReceiptsForm" method="post">
            <div class="left">
                <span>Receipt Code: <input id="sgrNo" name="sgrNo" class="text-normal" /></span>
                <span>Date of Receipt:
                    <input id="sendDate" name="sendDate" class="Wdate text-normal" onfocus="WdatePicker({dateFmt:'yyyy-MM-dd',readOnly:true})"/>
                </span>
                <input type="button" value="Query" onclick="updateQuery();" class="button-normal"></input>
            </div>
            <div class="right">
                <table width="260" border="0" cellspacing="0" cellpadding="0">
                    <tr style="height:50px;line-height:50px">
                        <td align="right">
                           <!--  <input type="button" value="Batch" onclick="showWarn('TODO');" class="button-normal"></input>
                            <input type="button" value="Transfer" onclick="showWarn('TODO');" class="button-normal"></input>
                            <input type="button" value="Return" onclick="showWarn('TODO');" class="button-normal"></input> -->
                        </td>
                    </tr>
                </table>
            </div>
        </form>
    </div>
    
    <!-- 列表表头块 -->
    <div id="headDiv">
        <table width="100%" border="0" cellpadding="0" cellspacing="0">
            <tr>
                <td>
                    <table class="datatable">
                        <tr class="headRow">
                        <td style="width:10px;">&nbsp;</td>
                            <td style="width:10%">Receipt Code</td>
                            <td width="1%" >|</td>
                            <td style="width:10%">Total Quantity(tickets)</td>
                              <td width="1%" >|</td>
                            <td style="width:14%">Total Amount(riels)</td>
                              <td width="1%" >|</td>
                            <td style="width:14%">Date of Receipt</td>
                              <td width="1%" >|</td>
                            <td style="width:14%">Processed By</td>
                              <td width="1%" >|</td>
                            <td style="width:10%">Type</td>
                              <td width="1%" >|</td>
                             <td style="width:8%">Status</td>
                               <td width="1%" >|</td>
                            <td style="width:*%">Operation</td>
                        </tr>
                    </table>
                 </td>
                 <!-- 表头和下方数据对齐 -->
                 <td style="width:17px;background:#2aa1d9"></td>
             </tr>
        </table>
    </div>
    
    <!-- 列表内容块 -->
    <div id="bodyDiv">
        <table class="datatable">
         <c:forEach var="data" items="${pageDataList}" varStatus="status" >
            <tr class="dataRow">
            <td style="width:10px;">&nbsp;</td>
                <td style="width:10%">${data.sgrNo}</td>
                 <td width="1%" >&nbsp;</td>
                <td style="width:10%"><fmt:formatNumber value='${data.actReceiptTickets}'/></td>
                 <td width="1%" >&nbsp;</td>
                <td style="width:14%" align="right"><fmt:formatNumber value='${data.actReceiptAmount}'/></td>
                 <td width="1%" >&nbsp;</td>
                <td style="width:14%"><fmt:formatDate  value="${data.sendDate}"  pattern="yyyy-MM-dd HH:mm:ss" /></td>
                 <td width="1%" >&nbsp;</td>
                <td style="width:14%">${data.sendOperater}</td>
                 <td width="1%" >&nbsp;</td>
                <td style="width:10%"><c:forEach var="item" items="${goodsReceiptType}"><c:if test="${!empty data }"><c:if test="${data.receiptType==item.key }">${item.value}</c:if></c:if></c:forEach></td>
                 <td width="1%" >&nbsp;</td>
                <td style="width:8%"><c:forEach var="item" items="${goodsReceiptStatus}"><c:if test="${!empty data }"><c:if test="${data.status==item.key }">${item.value}</c:if></c:if></c:forEach></td>
                 <td width="1%" >&nbsp;</td>
                <td style="width:*%">
                    <c:choose>
                          <c:when test="${data.status=='1'}">
                          <c:if test="${data.receiptTickets!=data.actReceiptTickets }">
                    
                                 <span><a href="#" onclick="onNextGoodrecipts('${data.sgrNo}','${data.receiptType}','${data.refNo}');">Continue</a></span>&nbsp;|
                           </c:if>
                                <span><a href="#"  onclick="onComplete('${data.receiptType}','${data.refNo}')">Complete</a></span>&nbsp;|
                          </c:when>
                          <c:when test="${data.status=='2'}">
                             
                                 <a href="#" onclick="showPage('goodsReceipts.do?method=printAll&sgrNo=${data.refNo}&type=${data.receiptType}','Print')">Print</a>&nbsp;|
                                 
                                 <c:if test="${data.receiptType <= 2}">
                                	<span><a href="#"  onclick="onFinish('${data.receiptType}','${data.refNo}')">Damage Reg</a></span>&nbsp;|
                          		</c:if>
                           
                          </c:when> 
                          
                    </c:choose>
                     <span><a href="#" onclick="showBox('goodsReceipts.do?method=getGoodsDetailBysgrNo&sgrNo=${data.sgrNo}&refNo=${data.refNo}','Details',650,1000)">Details</a></span>
                </td>
            </tr>
            </c:forEach>
        </table>
      ${pageStr}
    </div>
</body>
</html>