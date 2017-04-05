<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/views/common/taglibs.jsp"%>
<html>
<head>

<title>List of Return Deliveries</title>

<%@ include file="/views/common/meta.jsp" %>
<link rel="stylesheet" type="text/css" href="${basePath}/css/style.css" />
<link rel="stylesheet" href="${basePath}/component/messageBox/myJsBox.css" type="text/css"/>
<script type="text/javascript" src="${basePath}/component/messageBox/myJsBox.js"></script>
<script type="text/javascript" src="${basePath}/component/My97DatePicker/WdatePicker.js"></script>
<script type="text/javascript" src="${basePath}/js/jquery/jquery-1.9.1.js"></script>

<script type="text/javascript" charset="UTF-8">

function approve(returnNo){
	showBox('return.do?method=initApproveReturn&returnNo=' + returnNo,'Return Delivery Approval',240,400);
}

function doCancel(url) {
	$.ajax({
		url : url,
		dataType : "",
		async : false,
		success : function(result){
            if(result != '' && result !=null){
	            closeDialog();
            	showError(decodeURI(result));
	        }else{
            	window.location.reload(); 
	        }
		}
	});		
};
</script>

</head>
<body>
    <!-- 还货查询 -->
    <div id="title">List of Return Deliveries</div>
    
    <div class="queryDiv">
        <form action="return.do?method=listReturnDeliveries" id="returnRecoderForm" method="post">
            <div class="left">
                <span>Return Code: <input id="returnNo" name="returnNo" value="${returnRecoderForm.returnNo}" class="text-normal" maxlength="10"/></span>
                <span>Date of Return:
                    <input id="applyDate" name="applyDate" value="${returnRecoderForm.applyDate }" class="Wdate text-normal" onfocus="WdatePicker({lang:'en',dateFmt:'yyyy-MM-dd',readOnly:true})"/>
                </span>
                <input type="submit" value="Query" class="button-normal"></input>
            </div>
        </form>
    </div>
    <div id="headDiv">
        <table width="100%" border="0" cellpadding="0" cellspacing="0">
            <tr>
                <td>
                    <table class="datatable">
                        <tr class="headRow">
                        	<td style="width:10px;">&nbsp;</td>
                            <td style="width:12%">Return Code</td>
                            <th width="1%">|</th>
                            <td style="width:12%">Returned From</td>
                            <th width="1%">|</th>
                            <td style="width:12%">Date of Apply</td>
                            <th width="1%">|</th>
                            <td style="width:12%">Quantity Returned(tickets)</td>
                            <th width="1%">|</th>
                            <td style="width:10%">Amount(riels)</td>
                            <th width="1%">|</th>
                            <td style="width:8%">Status</td>
                            <th width="1%">|</th>
                            <td style="width:*%">Operation</td>
                        </tr>
                    </table>
                 </td>
                 <td style="width:17px;background:#2aa1d9"></td>
             </tr>
        </table>
    </div>
    <div id="bodyDiv">
        <table class="datatable">
        <c:forEach var="obj" items="${pageDataList}" varStatus="status" >
            <tr class="dataRow">
            	<td style="width:10px;">&nbsp;</td>
                <td style="width:12%">${obj.returnNo}</td>
                <td width="1%">&nbsp;</td>
                <td style="width:12%" title="${obj.realName}">${obj.realName}</td>
                <td width="1%">&nbsp;</td>
                <td style="width:12%"><fmt:formatDate value="${obj.applyDate}"  pattern="yyyy-MM-dd HH:mm:ss"/></td>
                <td width="1%">&nbsp;</td>
                <td style="width:12%"><fmt:formatNumber value="${obj.applyTickets}" /></td>
                <td width="1%">&nbsp;</td>
                <td style="width:10%;text-align:right"><fmt:formatNumber value="${obj.amount}" /></td>
                <td width="1%">&nbsp;</td>
                <td style="width:8%">
                	<c:if test="${obj.status==1 }"> Submitted </c:if>
		<%-- 		<c:if test="${obj.status==3 }"> Approved</c:if> 
					<c:if test="${obj.status==4 }"> Goods Returned</c:if> 
					<c:if test="${obj.status==5 }"> Payment Returned</c:if> --%>
					<c:if test="${obj.status==6 }"> Returned </c:if>  
					<c:if test="${obj.status==7 }"> Approved </c:if>
					<c:if test="${obj.status==8 }"> Rejected </c:if>
                </td>
                <td width="1%">&nbsp;</td>
                <td style="width:*%">
                    <span>
                   		<c:if test="${obj.status == 1}">
                    		<a href="#" onclick="approve('${obj.returnNo}')">Approval</a>
                    	</c:if>
                    	<c:if test="${obj.status != 1 }">
                    		Approval
                    	</c:if>
                    </span>
                </td>
            </tr>
          </c:forEach>
        </table>
        ${pageStr} 
    </div>
</body>
</html>