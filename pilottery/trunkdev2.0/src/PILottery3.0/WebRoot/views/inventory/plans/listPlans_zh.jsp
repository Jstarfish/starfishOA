<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/views/common/taglibs.jsp"%>
<html>
<head>

<title>方案列表</title>

<%@ include file="/views/common/meta.jsp"%>
<link rel="stylesheet" type="text/css" href="${basePath}/css/style.css" />
<link rel="stylesheet" href="${basePath}/component/messageBox/myJsBox.css"
	type="text/css" />

<script type="text/javascript" src="${basePath}/component/messageBox/myJsBox_zh.js"></script>
<script type="text/javascript"
	src="${basePath}/component/My97DatePicker/WdatePicker.js"></script>
<script type="text/javascript" src="${basePath}/js/jquery/jquery-1.9.1.js"></script>

<script type="text/javascript" charset="UTF-8">
	function delte(planCode) {
		var msg = "你确定要删除吗 ?";
		showDialog("deleteOutlet('" + planCode + "')", "删除", msg);
	}
	function deleteOutlet(planCode) {

		var url = "plans.do?method=deletePlan&planCode=" + planCode;

		$
				.ajax({
					url : url,
					type:"POST",
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
	<div id="title">方案管理</div>

	<!-- 查询条件块 -->
	<div class="queryDiv">
		<form action="plans.do?method=listPlans" method="POST" id="planForm">
			<div class="left">
				<span>方案编号: <input id="planCodeQuery" name="planCodeQuery"
					value="${planForm.planCodeQuery}" class="text-normal" maxlength="40" /></span> <span>方案名称: <input id="planNameQuery" name="planNameQuery"
					value="${planForm.planNameQuery}" class="text-normal" maxlength="40" />
				</span> <span>出版商名称: <input id="publisherNameQuery"
					name="publisherNameQuery" value="${planForm.publisherNameQuery}"
					class="text-normal" maxlength="40" /></span> <input type="button" value="查询"
					onclick="updateQuery();" class="button-normal"></input>
			</div>
			<c:if test="${insCode=='00' }">
				<div class="right">
					<table width="260" border="0" cellspacing="0" cellpadding="0">
						<tr style="height: 50px; line-height: 50px">
							<td align="right"><input type="button" value="新增方案"
								onclick="showBox('plans.do?method=addPlanInit','新增方案','400','640');"
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
							<td style="width: 20%">方案编号</td>
							<th width="1%">|</th>
							<td style="width: 20%">方案名称</td>
							<th width="1%">|</th>
							<td style="width: 9%">面值(瑞尔)</td>
							<th width="1%">|</th>
							<td style="width: 20%">出版商</td>
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
					<td style="width: 10px;">&nbsp;</td>
					<td style="width: 20%">${data.planCode}</td>
					<td width="1%">&nbsp;</td>
					<td style="width: 20%">${data.fullName}</td>
					<td width="1%">&nbsp;</td>
					<td style="width: 9%;text-align: right"><fmt:formatNumber value="${data.faceValue}" /></td>
					<td width="1%">&nbsp;</td>
					<td style="width: 20%">${data.publisherName}</td>
					<td width="1%">&nbsp;</td>
					<td style="width: *%">
						<c:if test="${insCode=='00' }">
							<span><a href="#"
								onclick="showBox('plans.do?method=modifyInit&planCode=${data.planCode}','修改方案','400','640')">编辑</a></span>&nbsp;|
							<span><a href="#"
								onclick="showBox('plans.do?method=setPlanCommInit&planCode=${data.planCode}','批量设置佣金','400','640')">批量设置佣金</a></span>&nbsp;|
							<span><a href="#"
								onclick="showBox('plans.do?method=importBatchInit&planCode=${data.planCode}','导入批次','300','600')">导入批次</a></span>&nbsp;|
							<span><a href="#"
								onclick="showBox('plans.do?method=listBatchDetails&planCode=${data.planCode}','批次详情','550','1250')">批次信息</a></span>&nbsp;|
							<span><a href="#" onclick="delte('${data.planCode}')">删除</a></span>
						</c:if> 
						<c:if test="${insCode!='00' }">
							<span style="color: gray">编辑</span>&nbsp;|
							<span style="color: gray">导入批次</span>&nbsp;|
							<span><a href="#"
								onclick="showBox('plans.do?method=listBatchDetails&planCode=${data.planCode}','批次详情','550','1250')">批次信息</a></span>&nbsp;|
							<span style="color: gray">删除</span>
						</c:if>
						
					</td>
				</tr>
			</c:forEach>
		</table>
		${pageStr}
	</div>
</body>
</html>
