<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/views/common/taglibs.jsp"%>
<html>
<head>

<title>Cash Withdrawn Records</title>

<%@ include file="/views/common/meta.jsp" %>
<link rel="stylesheet" type="text/css" href="${basePath}/css/style.css" />
<link rel="stylesheet" href="${basePath}/component/messageBox/myJsBox.css" type="text/css"/>
<script type="text/javascript" src="${basePath}/component/messageBox/myJsBox.js"></script>
<script type="text/javascript" src="${basePath}/component/My97DatePicker/WdatePicker.js"></script>
<script type="text/javascript" src="${basePath}/js/jquery/jquery-1.9.1.js"></script>

<script type="text/javascript" charset="UTF-8">
	function delet(fundNo) {
		var msg = "你确定要删除吗 ?";
		showDialog("deleteWithdrawn('"+fundNo+"')","删除",msg);
	}
	function deleteWithdrawn(fundNo) {
		var url = "orgsWithdrawnRecords.do?method=deleteWithdrawn&fundNo="+ fundNo;
				$.ajax({
					url : url,
					dataType : "json",
					async : false,
					success : function(r){
				            if(r.message!='' && r.message!=null){
					            closeDialog();
				            	showError(r.message);
					        }
				            else{
				            	closeDialog();	
				            	window.location.reload(); 
					       }
				}
				});
	}
	
	function cancel(fundNo) {
		var url = "orgsWithdrawnRecords.do?method=cancelWithdrawn&fundNo="
				+ fundNo;
		showDialog("doCancel('" + url + "')", 'Cancel',
				'你确定去取消提现申请: '
						+ fundNo);
	}
	function doCancel(url) {
		$.ajax({
			url : url,
			dataType : "",
			success : function(result) {
				if (result != '' && result != null) {
					closeDialog();
					showError(decodeURI(result));
				} else {
					window.location.reload();
				}
			}
		});
	};
</script>
</head>
<body>
    <!-- 提现申请 -->
     <div id="title">站点提现申请记录</div>
    <div class="queryDiv">
        <form action="withdrawnRecords.do?method=listWithdrawnRecords" id="queryForm" method="post">
            <div class="left">
                <span>站点编码: <input id="aoCode" name="aoCode" value="${outletCashWithdrawnForm.aoCode}" class="text-normal" maxlength="10"/></span>
                <span>站点名称: <input id="aoName" name="aoName" value="${outletCashWithdrawnForm.aoName}" class="text-normal" maxlength="10"/></span>
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
                            <td style="width:10%">申请单编号</td>
                            <th width="1%">|</th>
                            <td style="width:10%">站点编号</td>
                            <th width="1%">|</th>
                            <td style="width:12%">站点名称</td>
                            <th width="1%">|</th>
                            <td style="width:14%">提现后账户余额(瑞尔)</td>
                            <th width="1%">|</th>
                            <td style="width:12%">提现金额(瑞尔)</td>
                            <th width="1%">|</th>
                            <td style="width:12%">提现时间</td>
                            <th width="1%">|</th>
                            <td style="width:8%">申请状态</td>
                            <th width="1%">|</th>
                            <td style="width: *%">操作</td>
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
                <td style="width:10%">${obj.fundNo}</td>
            	<td width="1%">&nbsp;</td>
                <td style="width:10%">${obj.aoCode}</td>
            	<td width="1%">&nbsp;</td>
                <td style="width:12%" title="${obj.aoName }">${obj.aoName}</td>
            	<td width="1%">&nbsp;</td>
                <td style="width:14%;text-align: right">
                	
                	<c:choose>
						<c:when test="${obj.accountBalance == 0}">
							--
						</c:when>
						<c:otherwise>
							<fmt:formatNumber value="${obj.accountBalance}" />
						</c:otherwise>
					</c:choose>
                
                	<%-- <fmt:formatNumber value="${obj.accountBalance}" /> --%>
                </td>
            	<td width="1%">&nbsp;</td>
                <td style="width:12%;text-align: right"><fmt:formatNumber value="${obj.applyAmount}" /></td>
            	<td width="1%">&nbsp;</td>
                <td style="width:12%"><fmt:formatDate value="${obj.applyDate}" pattern="yyyy-MM-dd HH:mm:ss"/></td>
            	<td width="1%">&nbsp;</td>
               <%--  <td style="width:8%">
                	<c:if test="${obj.applyStatus==1 }"> Submitted </c:if>
					<c:if test="${obj.applyStatus==2 }"> Cancelled </c:if> 
					<c:if test="${obj.applyStatus==3 }"> Approved</c:if>
					<c:if test="${obj.applyStatus==4 }"> Refused</c:if> 
					<c:if test="${obj.applyStatus==5 }"> Processed</c:if>
					<c:if test="${obj.applyStatus==6 }"> Succeed</c:if>
                </td> --%>
				<td style="width:8%"><c:forEach var="item" items="${applyStatus}"><c:if test="${!empty obj }"><c:if test="${obj.applyStatus==item.key }">${item.value}</c:if></c:if></c:forEach></td>
            	<td width="1%">&nbsp;</td>
                <td style="width: *%">
					<span> 
						<c:if test="${obj.applyStatus == 1}">
							<a href="#" onclick="cancel('${obj.fundNo}')">取消</a>
						</c:if> 
						<c:if test="${obj.applyStatus != 1 }">取消</c:if>
					</span>
					 | 
					<span> 
					<c:if test="${obj.applyStatus == 2}">
						<a href="#" onclick="delet('${obj.fundNo}')">删除</a>
					</c:if> <c:if test="${obj.applyStatus != 2}">删除</c:if>
					</span>
					</td>
            </tr>
          </c:forEach>
        </table>
        ${pageStr} 
    </div>
</body> 
</html>