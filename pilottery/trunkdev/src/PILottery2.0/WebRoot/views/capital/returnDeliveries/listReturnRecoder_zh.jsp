<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/views/common/taglibs.jsp"%>
<html>
<head>

<title>还货列表</title>

<%@ include file="/views/common/meta.jsp" %>
<link rel="stylesheet" type="text/css" href="${basePath}/css/style.css" />
<link rel="stylesheet" href="${basePath}/component/messageBox/myJsBox.css" type="text/css"/>
<script type="text/javascript" src="${basePath}/component/messageBox/myJsBox.js"></script>
<script type="text/javascript" src="${basePath}/component/My97DatePicker/WdatePicker.js"></script>
<script type="text/javascript" src="${basePath}/js/jquery/jquery-1.9.1.js"></script>

<script type="text/javascript" charset="UTF-8">

function approve(returnNo){
	showBox('return.do?method=initApproveReturn&returnNo=' + returnNo,'还货审批',240,400);
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
    <div id="title">还货列表</div>
    
    <div class="queryDiv">
        <form action="return.do?method=listReturnDeliveries" id="returnRecoderForm" method="post">
            <div class="left">
                <span>还货申请编号: <input id="returnNo" name="returnNo" value="${returnRecoderForm.returnNo}" class="text-normal" maxlength="10"/></span>
                <span>还货日期:
                    <input id="applyDate" name="applyDate" value="${returnRecoderForm.applyDate }" class="Wdate text-normal" onfocus="WdatePicker({lang:'zh-cn',dateFmt:'yyyy-MM-dd',readOnly:true})"/>
                </span>
                <input type="submit" value="查询" class="button-normal"></input>
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
                            <td style="width:12%">还货申请编号</td>
                            <th width="1%">|</th>
                            <td style="width:12%">还货人</td>
                            <th width="1%">|</th>
                            <td style="width:12%">申请日期</td>
                            <th width="1%">|</th>
                            <td style="width:12%">还货数量(张)</td>
                            <th width="1%">|</th>
                            <td style="width:10%">还货金额(瑞尔)</td>
                            <th width="1%">|</th>
                            <td style="width:8%">申请状态</td>
                            <th width="1%">|</th>
                            <td style="width:*%">操作</td>
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
                	<c:if test="${obj.status==1 }"> 已提交 </c:if>
		<%-- 		<c:if test="${obj.status==3 }"> Approved</c:if> 
					<c:if test="${obj.status==4 }"> Goods Returned</c:if> 
					<c:if test="${obj.status==5 }"> Payment Returned</c:if> --%>
					<c:if test="${obj.status==6 }"> 已还货 </c:if>  
					<c:if test="${obj.status==7 }"> 已审批 </c:if>
					<c:if test="${obj.status==8 }"> 已拒绝 </c:if>
                </td>
                <td width="1%">&nbsp;</td>
                <td style="width:*%">
                    <span>
                   		<c:if test="${obj.status == 1}">
                    		<a href="#" onclick="approve('${obj.returnNo}')">审批</a>
                    	</c:if>
                    	<c:if test="${obj.status != 1 }">
                    		审批
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