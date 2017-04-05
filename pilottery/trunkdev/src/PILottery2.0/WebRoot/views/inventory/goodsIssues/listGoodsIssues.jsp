<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/views/common/taglibs.jsp"%>
<html>
<head>

<title>List of Goods Issues (Lottery)</title>

<%@ include file="/views/common/meta.jsp" %>
<link rel="stylesheet" type="text/css" href="${basePath}/css/style.css" />
<link rel="stylesheet" href="${basePath}/component/messageBox/myJsBox.css" type="text/css"/>
<script type="text/javascript" src="${basePath}/component/messageBox/myJsBox.js"></script>
<script type="text/javascript" src="${basePath}/component/My97DatePicker/WdatePicker.js"></script>
<script type="text/javascript" src="${basePath}/js/jquery/jquery-1.9.1.js"></script>

<script type="text/javascript" charset="UTF-8">
function updateQuery() {
    

    $("#goodsIssuesForm").attr("action","goodsIssues.do?method=listGoodsIssues");
   $("#goodsIssuesForm").submit();
}
function onNextGoodrecipts(val,type,refNo){

	if(type=='2'){
		$("#sgiNo").val(val);
		$("#doNo").val(refNo);
		$("#goodsIssuesForm").attr("action","goodsIssues.do?method=continueGoodsIssues&sgiNo="+val+"&refNo="+refNo);
	}
	if(type=='1'){
		$("#sgiNo").val(val);
		$("#stbNo").val(refNo);
		$("#goodsIssuesForm").attr("action","goodsIssues.do?method=continueGoodTranser&sgiNo="+val+"&refNo="+refNo);
	}

	$("#goodsIssuesForm").submit();
}
function doComplete(type,refNo,sgiNo){
	window.location.href="goodsIssues.do?method=completeGoodsIssues&type="+type+"&refNo="+refNo+"&sgiNo="+sgiNo;
}
</script>

</head>
<body>
    <!-- 顶部标题块 -->
    <div id="title">Goods Issues (Lottery)</div>
    
    <!-- 查询条件块 -->
    <div class="queryDiv">
       <form action="" id="goodsIssuesForm" method="post">
         <input type="hidden" name="sgiNo" value="" id="sgiNo" >
         <input type="hidden" name="stbNo" id="stbNo" >
         <input  type="hidden" name="doNo"  id="doNo">
          <input type="hidden" name="operType" id="operType" value="2">
            <div class="left">
                <span>Issue Code: <input id="sgiNo1" name="sgiNo1" class="text-normal" /></span>
                <span>Date of Issue:
                    <input id="sendDate" name="sendDate" class="Wdate text-normal" onfocus="WdatePicker({lang:'en',dateFmt:'yyyy-MM-dd',readOnly:true})"/>
                </span>
                
                <input type="button" value="Query" onclick="updateQuery();" class="button-normal"></input>
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
                            <td style="width:10%">Issue Code</td>
                              <td width="1%" >|</td>
                            <td style="width:10%">Date of Issue</td>
                              <td width="1%" >|</td>
                            <td style="width:12%">Total Quantity Issued(tickts)</td>
                              <td width="1%" >|</td>
                            <td style="width:12%">Total Amount Issued(riels)</td>
                              <td width="1%" >|</td>
                            <td style="width:10%">Processed By</td>
                              <td width="1%" >|</td>
                            <td style="width:10%">Type</td>
                              <td width="1%" >|</td>
                            <td style="width:10%">Status</td>
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
                <td style="width:10%">${data.sgiNo}</td>
                 <td width="1%" >&nbsp;</td>
                <td style="width:10%"><fmt:formatDate  value="${data.sendDate}"  pattern="yyyy-MM-dd HH:mm:ss" /></td>
                 <td width="1%" >&nbsp;</td>
                <td style="width:12%"><fmt:formatNumber value="${data.actTickets}" type="number"/></td>
                 <td width="1%" >&nbsp;</td>
                <td style="width:12%" align="right"><fmt:formatNumber value="${data.actAmount}" type="number"/></td>
                 <td width="1%" >&nbsp;</td>
                <td style="width:10%">${data.sendManger}</td>
                 <td width="1%" >&nbsp;</td>
                <td style="width:10%"><c:forEach var="item" items="${goodsIssuesType}"><c:if test="${!empty data }"><c:if test="${data.issueType==item.key }">${item.value}</c:if></c:if></c:forEach></td>
                 <td width="1%" >&nbsp;</td>
                <td style="width:10%"><c:forEach var="item" items="${goodsIssuesStatus}"><c:if test="${!empty data }"><c:if test="${data.status==item.key }">${item.value}</c:if></c:if></c:forEach></td>
                 <td width="1%" >&nbsp;</td>
                <td style="width:*%">
                    
                    <c:if test="${data.status==1}">
                    <c:if test="${data.tickets!=data.actTickets }">
                     <span><a href="#" onclick="onNextGoodrecipts('${data.sgiNo}','${data.issueType}','${data.refNo}')">Continue</a></span>&nbsp;|
                     </c:if>
                      <span><a href="#" onclick="doComplete('${data.issueType}','${data.refNo}','${data.sgiNo}')">Complete</a></span>&nbsp;|
                    </c:if>
                    <c:if test="${data.status==2}">
                      <a href="#" onclick="showPage('goodsIssues.do?method=printGoodsAll&refNo=${data.refNo}&type=${data.issueType}','Print')">Print</a>&nbsp;|
                    </c:if>
                   
                    <span><a href="#" onclick="showBox('goodsIssues.do?method=getGoodsIssuesDetailBysgiNo&sgiNo=${data.sgiNo}&issueType=${data.issueType}','Details',550,1020)">Details</a></span>&nbsp;
                   
                </td>
            </tr>
          </c:forEach>
        </table>
        ${pageStr} 
    </div>
</body>
</html>