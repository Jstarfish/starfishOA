<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/views/common/taglibs.jsp"%>
<html>
<head>

<title>站点管理</title>

<%@ include file="/views/common/meta.jsp"%>
<link rel="stylesheet" type="text/css" href="${basePath}/css/style.css" />
<link rel="stylesheet" href="${basePath}/component/messageBox/myJsBox.css"
	type="text/css" />
<script type="text/javascript" src="${basePath}/component/messageBox/myJsBox.js"></script>
<script type="text/javascript"
	src="${basePath}/component/My97DatePicker/WdatePicker.js"></script>
<script type="text/javascript" src="${basePath}/js/jquery/jquery-1.9.1.js"></script>

<script type="text/javascript" charset="UTF-8">
	function doSubmit() {
		document.getElementById("queryForm").submit();
	}
	function delte(outletCode) {
		var msg = "你确定要删除吗 ?";
		var url = "outlets.do?method=deleteOutletsInit&outletCode="
				+ outletCode;
		$
				.ajax({
					url : url,
					dataType : "",
					type : "get",
					async : false,
					success : function(r) {
						if (r != '0') {
							showError("此站点余额不为0 .");
						} else {
							showDialog("deleteOutlet('" + outletCode + "')",
									"Delete", msg);
						}
					}
				});

	}
	function enable(outletCode) {
		var msg = "你确定要将此站点变为可用 ?";
		showDialog("enableOutlet('" + outletCode + "')", "Enable", msg);
	}
	function resetPassword(outletCode) {
		var msg = "你确定要充值站点密码 ?";
		showDialog("resetPass('" + outletCode + "')", "Reset Password", msg);
	}
	function resetPass(outletCode) {
		var url = "outlets.do?method=resetPass&outletCode=" + outletCode;
		$.ajax({
			url : url,
			dataType : "",
			type : "get",
			async : false,
			success : function(r) {
				if (r == 'error') {
					closeDialog();
					showError("Failed reset");
				} else {
					closeDialog();
					window.location.reload();
				}
			}
		});
	}
	function enableOutlet(outletCode) {
		var url = "outlets.do?method=enable&outletCode=" + outletCode;
		$.ajax({
			url : url,
			dataType : "",
			type : "get",
			async : false,
			success : function(r) {
				if (r == 'error') {
					closeDialog();
					showError("失败");
				} else {
					closeDialog();
					window.location.reload();
				}
			}
		});
	}
	function disable(outletCode) {
		var msg = "你确定要将该站点变为不可用 ?";
		showDialog("disableOutlet('" + outletCode + "')", "Enable", msg);

	}
	function disableOutlet(outletCode) {
		var url = "outlets.do?method=disable&outletCode=" + outletCode;
		$.ajax({
			url : url,
			dataType : "",
			type : "get",
			async : false,
			success : function(r) {
				if (r == 'error') {
					closeDialog();
					showError("失败");
				} else {
					closeDialog();
					window.location.reload();
				}
			}
		});
	}
	function deleteOutlet(outletCode) {

		var url = "outlets.do?method=deleteOutlets&outletCode=" + outletCode;

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
	<div id="title">站点管理</div>
	<!-- 查询条件块 -->
	<div class="queryDiv">
		<form action="outlets.do?method=listOutlets" id="queryForm" method="POST">
			<div class="left">
				<span>机构名称: <input name="institutionName" id="institutionName"
					class="text-normal" maxlength="12" value="${form.institutionName }"/></span> <span>站点编码: <input
					name="outletCode" id="outletCode" class="text-normal" maxlength="12" value="${form.outletCode }"/></span> <input
					type="button" value="查询" onclick="doSubmit();" class="button-normal"></input>
			</div>
			<div class="right">
				<table width="260" border="0" cellspacing="0" cellpadding="0">
					<tr style="height: 50px; line-height: 50px">
						<td align="right"><input type="button" value="新建站点"
							onclick="showBox('outlets.do?method=createInit','新建站点',650,800)"
							class="button-normal"></input></td>
					</tr>
				</table>
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
							<td style="width: 10px;">&nbsp;</td>
							<td style="width: 8%">站点编号</td>
							<th width="1%">|</th>
							<td style="width: 10%">站点名称</td>
							<th width="1%">|</th>
							<td style="width: 10%">所属机构</td>
							<th width="1%">|</th>
							<td style="width: 12%">所属区域</td>
							<th width="1%">|</th>
							<td style="width: 10%">联系人</td>
							<th width="1%">|</th>
							<td style="width: 10%">联系电话</td>
							<th width="1%">|</th>
							<td style="width: 7%">状态</td>
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
			<c:forEach var="items" items="${listOutlets }" varStatus="status">
				<tr class="dataRow">
					<td style="width: 10px;">&nbsp;</td>
					<td style="width: 8%">${items.outletCode}</td>
					<td width="1%">&nbsp;</td>
					<td style="width: 10%" title="${items.outletName}">${items.outletName}</td>
					<td width="1%">&nbsp;</td>
					<td style="width: 10%">${items.institutionName}</td>
					<td width="1%">&nbsp;</td>
					<td style="width: 12%" title="${items.area}">${items.area}</td>
					<td width="1%">&nbsp;</td>
					<td style="width: 10%" title="${items.contractPerson}">${items.contractPerson}</td>
					<td width="1%">&nbsp;</td>
					<td style="width: 10%">${items.contractPhone}</td>
					<td width="1%">&nbsp;</td>
					<td style="width: 7%">${items.statusValue}</td>
					<td width="1%">&nbsp;</td>
					<td style="width: *%"><c:if test="${items.status==1 }">
							<span><a href="#" onclick="resetPassword('${items.outletCode }')">重置站点密码</a></span>&nbsp;|
							<span><a href="#"
								onclick="showBox('outlets.do?method=detailsOutlets&outletCode=${items.outletCode }','站点详情',450,800)">详情</a></span>&nbsp;|
						<span><a href="#"
								onclick="showBox('outlets.do?method=modifyInit&outletCode=${items.outletCode}','修改站点',650,800)">编辑</a></span>&nbsp;|
							<span>可用</span>&nbsp;|
							<span><a href="#" onclick="disable('${items.outletCode }')">不可用</a></span>&nbsp;|
							<span><a href="#" onclick="delte('${items.outletCode }')">删除</a></span>
						</c:if> <c:if test="${items.status==2 }">
							<span style="color: gray">重置站点密码</span>&nbsp;|
							<span><a href="#"
								onclick="showBox('outlets.do?method=detailsOutlets&outletCode=${items.outletCode }','站点详情',450,800)">详情</a></span>&nbsp;|
						
						<span><a href="#"
								onclick="showBox('outlets.do?method=modifyInit&outletCode=${items.outletCode}','修改站点',650,800)">编辑</a></span>&nbsp;|
							<span><a href="#" onclick="enable('${items.outletCode }')">可用</a></span>&nbsp;|
							<span style="color: gray">不可用</span>&nbsp;|
							<span><a href="#" onclick="delte('${items.outletCode }')">删除</a></span>
						</c:if> <c:if test="${items.status==3 }">
							<span style="color: gray">重置站点密码</span>&nbsp;|
							<span><a href="#"
								onclick="showBox('outlets.do?method=detailsOutlets&outletCode=${items.outletCode }','站点详情',450,800)">详情</a></span>&nbsp;|
						<span style="color: gray">编辑</span>&nbsp;|
							<span style="color: gray">可用</span>&nbsp;|
							<span style="color: gray">不可用</span>&nbsp;|
							<span style="color: gray">删除</span>
						</c:if></td>
				</tr>
			</c:forEach>
		</table>
		${pageStr}
	</div>
</body>
</html>