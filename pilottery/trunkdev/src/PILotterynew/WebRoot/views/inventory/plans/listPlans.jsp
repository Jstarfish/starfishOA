<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/views/common/taglibs.jsp"%>
<html>
<head>

<title>List of Plans</title>

<%@ include file="/views/common/meta.jsp"%>
<link rel="stylesheet" type="text/css" href="${basePath}/css/style.css" />
<link rel="stylesheet" href="${basePath}/component/messageBox/myJsBox.css"
	type="text/css" />

<script type="text/javascript" src="${basePath}/component/messageBox/myJsBox.js"></script>
<script type="text/javascript"
	src="${basePath}/component/My97DatePicker/WdatePicker.js"></script>
<script type="text/javascript" src="${basePath}/js/jquery/jquery-1.9.1.js"></script>

<script type="text/javascript" charset="UTF-8">
	function delte(planCode) {
		var msg = "Are you sure you want to delete ?";
		showDialog("deleteOutlet('" + planCode + "')", "Delete", msg);
	}
	function deleteOutlet(planCode) {

		var url = "plans.do?method=deletePlan&planCode=" + planCode;

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
	function updateQuery() {
		$("#planForm").submit();
	}

	$(document).ready(function() {
		$("#planCodeQuery").keydown(function(event) {
			if (event.keyCode == 13) {
				updateQuery();
			}
		});

		$("#planNameQuery").keydown(function(event) {
			if (event.keyCode == 13) {
				updateQuery();
			}
		});

		$("#publisherNameQuery").keydown(function(event) {
			if (event.keyCode == 13) {
				updateQuery();
			}
		});
	});
</script>

</head>
<body>
	<!-- 顶部标题块 -->
	<div id="title">Plans</div>

	<!-- 查询条件块 -->
	<div class="queryDiv">
		<form action="plans.do?method=listPlans" method="POST" id="planForm">
			<div class="left">
				<span>Plan Code: <input id="planCodeQuery" name="planCodeQuery"
					value="${planForm.planCodeQuery}" class="text-normal" maxlength="40" /></span> <span>Plan
					Name: <input id="planNameQuery" name="planNameQuery"
					value="${planForm.planNameQuery}" class="text-normal" maxlength="40" />
				</span> <span>Publisher Name: <input id="publisherNameQuery"
					name="publisherNameQuery" value="${planForm.publisherNameQuery}"
					class="text-normal" maxlength="40" /></span> <input type="button" value="Query"
					onclick="updateQuery();" class="button-normal"></input>
			</div>
			<c:if test="${insCode=='00' }">
				<div class="right">
					<table width="260" border="0" cellspacing="0" cellpadding="0">
						<tr style="height: 50px; line-height: 50px">
							<td align="right"><input type="button" value="New Plan"
								onclick="showBox('plans.do?method=addPlanInit','New Plan','400','640');"
								class="button-normal"></input></td>
						</tr>
					</table>
				</div>
			</c:if>
		</form>
	</div>

	<!-- 列表表头块 -->
	<div id="headDiv">
		<table width="100%" border="0" cellpadding="0" cellspacing="0">
			<tr>
				<td>
					<table class="datatable">
						<tr class="headRow">
							<td style="width: 10px;">&nbsp;</td>
							<td style="width: 20%">Plan Code</td>
							<th width="1%">|</th>
							<td style="width: 20%">Plan Name</td>
							<th width="1%">|</th>
							<td style="width: 9%">Face Value(riels)</td>
							<th width="1%">|</th>
							<td style="width: 20%">Publisher</td>
							<th width="1%">|</th>
							<td style="width: *%">Operation</td>
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
					<td style="width: 10px;">&nbsp;</td>
					<td style="width: 20%">${data.planCode}</td>
					<td width="1%">&nbsp;</td>
					<td style="width: 20%">${data.fullName}</td>
					<td width="1%">&nbsp;</td>
					<td style="width: 9%;text-align: right"><fmt:formatNumber value="${data.faceValue}" /></td>
					<td width="1%">&nbsp;</td>
					<td style="width: 20%">${data.publisherName}</td>
					<td width="1%">&nbsp;</td>
					<td style="width: *%"><c:if test="${insCode=='00' }">
						<span><a href="#"
								onclick="showBox('plans.do?method=modifyInit&planCode=${data.planCode}','Modify Plan','400','640')">Edit</a></span>&nbsp;|
						<span><a href="#"
								onclick="showBox('plans.do?method=setPlanCommInit&planCode=${data.planCode}','Batch Set Commission','400','640')">Set Comm</a></span>&nbsp;|
						<span><a href="#"
								onclick="showBox('plans.do?method=importBatchInit&planCode=${data.planCode}','ImportBatch','300','600')">Import</a></span>&nbsp;|
						<span><a href="#"
								onclick="showBox('plans.do?method=listBatchDetails&planCode=${data.planCode}','Batch Details','550','1250')">Batch</a></span>&nbsp;|
							<span><a href="#" onclick="delte('${data.planCode}')">Delete</a></span>
						</c:if> <c:if test="${insCode!='00' }">
							<span style="color: gray">Edit</span>&nbsp;|
						<span style="color: gray">Import</span>&nbsp;|
						<span><a href="#"
								onclick="showBox('plans.do?method=listBatchDetails&planCode=${data.planCode}','Batch Details','550','1250')">Batch</a></span>&nbsp;|
							<span style="color: gray">Delete</span>
						</c:if></td>

				</tr>
			</c:forEach>
		</table>
		${pageStr}
	</div>
</body>
</html>
