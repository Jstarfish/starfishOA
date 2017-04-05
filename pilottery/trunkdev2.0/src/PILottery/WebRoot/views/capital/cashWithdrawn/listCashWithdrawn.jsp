<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8"%>
<%@ include file="/views/common/taglibs.jsp"%>
<html>
<head>
<title>List of Cash Withdrawn</title>
<%@ include file="/views/common/meta.jsp"%>
<link rel="stylesheet" type="text/css" href="${basePath}/css/style.css" />
<link rel="stylesheet" href="${basePath}/component/messageBox/myJsBox.css" type="text/css" />
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
//ajax执行操作之后 进行刷新
/* 		$.ajax({
			url : url,
			dataType : "json",
			async : false,
			success : function(r) {
				if (r.message != '' && r.message != null) {
					showError(decodeURI(r.message));
				} else {
					window.location.reload();
				}
			}
		});
	}; */

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
		<form action="orgsWithdrawnRecords.do?method=listRecords" id="cashWithdrawnForm" method="post">
			<div class="left">
			<%-- 	 <span>Name: <input id="aoName"
					name="aoName" value="${cashWithdrawnForm.aoName}" class="text-big"
					maxlength="10" />
				 </span>  --%>
				
				 <span>Date: <input id="applyDate"
					name="applyDate" class="Wdate text-normal"
					onfocus="WdatePicker({lang:'en',dateFmt:'yyyy-MM-dd',readOnly:true})" value="${cashWithdrawnForm.applyDate }" />
				</span> <input type="submit" value="Query" class="button-normal"></input>
			</div>

			<div class="right">
				<table width="260" border="0" cellspacing="0" cellpadding="0">
					<tr style="height: 50px; line-height: 50px">
						<td align="right"><input type="button" value="Cash Withdrawn"
							onclick="showBox('orgsWithdrawnRecords.do?method=addWithdrawnInit', 'Cash Withdrawn', 300, 650);"
							class="button-normal"></input></td>
					</tr>
				</table>
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
							<td style="width: 10%">Record Code</td>
							<th width="1%">|</th>
							<td style="width: 8%">Instiution Code</td>
							<th width="1%">|</th>
							<td style="width: 10%">Instiution Name</td>
							<th width="1%">|</th>
							<td style="width: 15%">Balance after Withdrawal(riels)</td>
							<th width="1%">|</th>
							<td style="width: 15%">Cash Withdrawn Amount(riels)</td>
							<th width="1%">|</th>
							<td style="width: 12%">Date of Withdrawal</td>
							<th width="1%">|</th>
							<td style="width: 8%">Status</td>
							<th width="1%">|</th>
							<td style="width: *%">Processed By</td>
						</tr>
					</table>
				</td>
				<td style="width: 17px; background: #2aa1d9"></td>
			</tr>
		</table>
	</div>
	<div id="bodyDiv">
		<table class="datatable">
			<c:forEach var="obj" items="${pageDataList}" varStatus="status">
				<tr class="dataRow">
					<td style="width:10px;">&nbsp;</td>
					<td style="width: 10%">${obj.fundNo}</td>
					<td width="1%">&nbsp;</td>
					<td style="width: 8%">${obj.aoCode}</td>
					<td width="1%">&nbsp;</td>
					<td style="width: 10%" title="${obj.aoName}">${obj.aoName}</td>
					<td width="1%">&nbsp;</td>
					<td style="width: 15%;text-align:right">
					<c:choose>
						<c:when test="${obj.afterAccountBalance == 0}">
							--
						</c:when>
						<c:otherwise>
							<fmt:formatNumber value="${obj.afterAccountBalance}" />
						</c:otherwise>
					</c:choose>
					</td>
					<td width="1%">&nbsp;</td>
					<td style="width: 15%;text-align:right"><fmt:formatNumber value="${obj.applyAmount}" /></td>
					<td width="1%">&nbsp;</td>
					<td style="width: 12%"><fmt:formatDate
							value="${obj.applyDate}" pattern="yyyy-MM-dd HH:mm:ss" /></td>
					<td width="1%">&nbsp;</td>
					<td style="width: 8%">
					<c:forEach var="item" items="${cashWithdrawnStatus}"><c:if test="${!empty obj }"><c:if test="${obj.applyStatus==item.key }">${item.value}</c:if></c:if></c:forEach></td>
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