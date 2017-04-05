<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8"%>
<%@ include file="/views/common/taglibs.jsp"%>
<html>
<head>

<title>市场管理员账户列表</title>

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
		var msg = "确定要删除吗 ?";
		showDialog("delteManagerAcct('" + marketAdmin + "')", "删除", msg);
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
	<div id="title">市场管理员账户</div>
	<!-- 查询条件块 -->
	<div class="queryDiv">
		<form action="account.do?method=listMarketManagersAccounts"
			method="POST" id="managerAcctForm">
			<div class="left">
				<span>部门: 
            		<select class="select-normal" name="adminOrg" >
            		 	<c:if test="${sessionScope.current_user.id == 0}">
            		 		<option value="">--所有--</option>
            		 		<c:forEach var="obj" items="${orgList}" varStatus="s">
	                   	   		<c:if test="${obj.orgCode != managerAcctForm.adminOrg}">
	                   	   			<option value="${obj.orgCode}">${obj.orgName}</option>
	                   	   		</c:if>
	                   	   		<c:if test="${obj.orgCode == managerAcctForm.adminOrg}">
	                   	   			<option value="${obj.orgCode}" selected="selected">${obj.orgName}</option>
	                   	   		</c:if>
                   	  		</c:forEach>
            		 	</c:if>
            			<c:if test="${sessionScope.current_user.id != 0}">
            				<c:forEach var="obj" items="${orgList}" varStatus="s">
	                   	   		<c:if test="${obj.orgCode == managerAcctForm.adminOrg}">
	                   	   			<option value="${obj.orgCode}" selected="selected">${obj.orgName}</option>
	                   	   		</c:if>
                   	  		</c:forEach>
            		 	</c:if>
                    </select>
            	</span>
				<span>市场管理员编号: <input id="marketAdmin"
					name="marketAdmin" value="${managerAcctForm.marketAdmin }"
					class="text-normal" maxlength="4" onkeyup="this.value=this.value.replace(/[^\d,]/g,'')"/></span> 
				<span>市场管理员姓名:
					<input id="realName" name="realName"
					value="${managerAcctForm.realName }" class="text-normal"
					maxlength="25" />
				</span> <input type="button" value="查询" onclick="updateQuery();"
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
							<td style="width: 10%">市场管理员编号</td>
							<th width="1%">|</th>
							<td style="width: 13%">市场管理员姓名</td>
							<th width="1%">|</th>
							<td style="width: 13%">库存量(张)</td>
							<th width="1%">|</th>
							<td style="width: 13%">佘票金额(瑞尔)</td>
							<th width="1%">|</th>
							<td style="width: 13%">账户余额(瑞尔)</td>
							<th width="1%">|</th>
							<td style="width: 13%">信用额度(瑞尔)</td>
							<th width="1%">|</th>
							<td style="width: *%">操作</td>
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
					<td style="width: 13%"><fmt:formatNumber value="${data.tickets}" /></td>
					<td width="1%">&nbsp;</td>
					<td style="width: 13%; text-align:right"><fmt:formatNumber value="${data.maxAmountTickets}" /></td>
					<td width="1%">&nbsp;</td>
					<td style="width: 13%; text-align:right"><fmt:formatNumber value="${data.accountBalance}" /></td>
					<td width="1%">&nbsp;</td>
					<td style="width: 13%; text-align:right"><fmt:formatNumber value="${data.creditLimit}" /></td>
					<td width="1%">&nbsp;</td>
					<td style="width: *%">
						<span><a href="#" onclick="showBox('account.do?method=editMangerAccount&marketAdmin=${data.marketAdmin }','编辑',300,650);">编辑</a></span>
							|
						<span><a href="#" onclick="showBox('account.do?method=getInventoryDetail&marketAdmin=${data.marketAdmin }','详情',500,850);">详情</a></span> 
						<%-- 	|
						<span><a href="#" onclick="delte('${data.marketAdmin }')">Delete</a></span> --%>
					</td>
				</tr>
			</c:forEach>
		</table>
		${pageStr}
	</div>
</body>

</html>