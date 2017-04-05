<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8"%>
<%@ include file="/views/common/taglibs.jsp"%>
<html>
<head>

<title>List of MarketManager Accounts</title>

<%@ include file="/views/common/meta.jsp"%>
<link rel="stylesheet" type="text/css" href="${basePath}/css/style.css" />
<link rel="stylesheet"
	href="${basePath}/component/messageBox/myJsBox.css" type="text/css" />
<script type="text/javascript"
	src="${basePath}/component/messageBox/myJsBox.js"></script>
<script type="text/javascript"
	src="${basePath}/component/My97DatePicker/WdatePicker.js"></script>
<script type="text/javascript"
	src="${basePath}/js/jquery/jquery-1.9.1.js"></script>

<script type="text/javascript" charset="UTF-8">
	function updateQuery() {
		$("#managerAcctForm").submit();
	}
	function delte(marketAdmin) {
		var msg = "Are you sure you want to delete ?";
		showDialog("delteManagerAcct('" + marketAdmin + "')", "Delete", msg);
	}
	function delteManagerAcct(marketAdmin) {

		var url = "account.do?method=delteManagerAcct&marketAdmin="
				+ marketAdmin;
		$
				.ajax({
					url : url,
					dataType : "json",
					async : false,
					success : function(r) {
						if (r.reservedSuccessMsg != ''
								&& r.reservedSuccessMsg != null) {
							closeDialog();
							showError(decodeURI(r.reservedSuccessMsg));
						} else {
							closeDialog();
							window.location.reload();
						}
					}
				});
	}
</script>

</head>
<body>
	<!-- 顶部标题块 -->
	<div id="title">MarketManager Accounts</div>
	<!-- 查询条件块 -->
	<div class="queryDiv">
		<form action="account.do?method=listMarketManagersAccounts"
			method="POST" id="managerAcctForm">
			<div class="left">
				<span>Institution: 
            		<select class="select-normal" name="adminOrg" >
            		 	<option value="">--All--</option>
                   	    <c:forEach var="obj" items="${orgList}" varStatus="plan">
                   	   		<c:if test="${obj.institutionCode == managerAcctForm.adminOrg}">
                   	   			<option value="${obj.institutionCode}" selected="selected">${obj.institutionName}</option>
                   	   		</c:if>
                   	   		<c:if test="${obj.institutionCode != managerAcctForm.adminOrg}">
                   	   			<option value="${obj.institutionCode}">${obj.institutionName}</option>
                   	   		</c:if>
                   	    </c:forEach>
                    </select>
            	</span>
				<span>MarketManager Code: <input id="marketAdmin"
					name="marketAdmin" value="${managerAcctForm.marketAdmin }"
					class="text-normal" maxlength="4" onkeyup="this.value=this.value.replace(/[^\d,]/g,'')"/></span> 
				<span>MarketManager Name:
					<input id="realName" name="realName"
					value="${managerAcctForm.realName }" class="text-normal"
					maxlength="25" />
				</span> <input type="button" value="Query" onclick="updateQuery();"
					class="button-normal"></input>
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
							<td style="width: 10%">MarketManager Code</td>
							<th width="1%">|</th>
							<td style="width: 13%">MarketManager Name</td>
							<th width="1%">|</th>
							<c:if test="${applicationScope.useCompany == 2}">
							<td style="width: 13%">Quantity(tickets)</td>
							<th width="1%">|</th>
							<td style="width: 13%">Loanable Ticket Amount(riels)</td>
							<th width="1%">|</th>
							</c:if>
							<td style="width: 13%">Account Balance(riels)</td>
							<th width="1%">|</th>
							<td style="width: 13%">Credit Limit(riels)</td>
							<th width="1%">|</th>
							<td style="width: *%">Operations</td>
						</tr>
					</table>
				</td>
				<!-- 表头和下方数据对齐 -->
				<td style="width: 17px; background: #2aa1d9"></td>
			</tr>
		</table>
	</div>

	<!-- 列表内容块 -->
	<div id="bodyDiv">
		<table class="datatable">
			<c:forEach var="data" items="${pageDataList}" varStatus="status">
				<tr class="dataRow">
					<td style="width:10px;">&nbsp;</td>
					<td style="width: 10%">${data.marketAdmin }</td>
					<td width="1%">&nbsp;</td>
					<td style="width: 13%" title="${data.realName }">${data.realName}</td>
					<td width="1%">&nbsp;</td>
					<c:if test="${applicationScope.useCompany == 2}">
					<td style="width: 13%"><fmt:formatNumber value="${data.tickets}" /></td>
					<td width="1%">&nbsp;</td>
					<td style="width: 13%; text-align:right"><fmt:formatNumber value="${data.maxAmountTickets}" /></td>
					<td width="1%">&nbsp;</td>
					</c:if>
					<td style="width: 13%; text-align:right"><fmt:formatNumber value="${data.accountBalance}" /></td>
					<td width="1%">&nbsp;</td>
					<td style="width: 13%; text-align:right"><fmt:formatNumber value="${data.creditLimit}" /></td>
					<td width="1%">&nbsp;</td>
					<td style="width: *%">
						<span><a href="#" onclick="showBox('account.do?method=editMangerAccount&marketAdmin=${data.marketAdmin }','Edit',300,650);">Edit</a></span>
						<c:if test="${applicationScope.useCompany == 2}">
							|
						<span><a href="#" onclick="showBox('account.do?method=getInventoryDetail&marketAdmin=${data.marketAdmin }','Inventory Detail',500,850);">Detail</a></span>
						</c:if> 
					</td>
				</tr>
			</c:forEach>
		</table>
		${pageStr}
	</div>
</body>

</html>