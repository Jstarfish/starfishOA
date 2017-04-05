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
		var msg = "Are you sure you want to delete ?";
		showDialog("deleteWithdrawn('"+fundNo+"')","Delete",msg);
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
				'Are you sure you want to cancel Withdrawn Approval : '
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
     <div id="title">Cash Withdrawn Records</div>
    <div class="queryDiv">
        <form action="withdrawnRecords.do?method=listWithdrawnRecords" id="queryForm" method="post">
            <div class="left">
                <span>Outlet Code: <input id="aoCode" name="aoCode" value="${outletCashWithdrawnForm.aoCode}" class="text-normal" maxlength="10"/></span>
                <span>Outlet Name: <input id="aoName" name="aoName" value="${outletCashWithdrawnForm.aoName}" class="text-normal" maxlength="10"/></span>
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
                            <td style="width:10%">Record Code</td>
                            <th width="1%">|</th>
                            <td style="width:10%">Outlet Code</td>
                            <th width="1%">|</th>
                            <td style="width:12%">Outlet Name</td>
                            <th width="1%">|</th>
                            <td style="width:14%">Balance after Withdrawal(riels)</td>
                            <th width="1%">|</th>
                            <td style="width:12%">Cash Withdrawn(riels)</td>
                            <th width="1%">|</th>
                            <td style="width:12%">Date of Withdrawal</td>
                            <th width="1%">|</th>
                            <td style="width:8%">Status</td>
                            <th width="1%">|</th>
                            <td style="width: *%">Operation</td>
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
				<td style="width:8%">${obj.statusValue }</td>
            	<td width="1%">&nbsp;</td>
                <td style="width: *%">
					<span> 
						<c:if test="${obj.applyStatus == 1}">
							<a href="#" onclick="cancel('${obj.fundNo}')">Cancel</a>
						</c:if> 
						<c:if test="${obj.applyStatus != 1 }"> Cancel</c:if>
					</span>
					 | 
					<span> 
					<c:if test="${obj.applyStatus == 2}">
						<a href="#" onclick="delet('${obj.fundNo}')">Delete</a>
					</c:if> <c:if test="${obj.applyStatus != 2}">Delete</c:if>
					</span>
					</td>
            </tr>
          </c:forEach>
        </table>
        ${pageStr} 
    </div>
</body> 
</html>