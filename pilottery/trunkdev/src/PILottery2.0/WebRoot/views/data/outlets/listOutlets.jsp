<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/views/common/taglibs.jsp"%>
<html>
<head>

<title>List of Outlets</title>

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
		var msg = "Are you sure you want to delete ?";
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
							showError("This outlet banlance not 0 !");
						} else {
							showDialog("deleteOutlet('" + outletCode + "')",
									"Delete", msg);
						}
					}
				});

	}
	function enable(outletCode) {
		var msg = "Are you sure you want to enable outlet ?";
		showDialog("enableOutlet('" + outletCode + "')", "Enable", msg);
	}
	function resetPassword(outletCode) {
		var msg = "Are you sure you want to reset password ?";
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
					showError("Failed enable");
				} else {
					closeDialog();
					window.location.reload();
				}
			}
		});
	}
	function disable(outletCode) {
		var msg = "Are you sure you want to disable outlet ?";
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
					showError("Failed disable");
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
	<div id="title">Outlets</div>
	<!-- 查询条件块 -->
	<div class="queryDiv">
		<form action="outlets.do?method=listOutlets" id="queryForm" method="POST">
			<div class="left">
				<span>Institution: <select name="institutionName" id="institutionName"
					class="select-normal">
					<option value="">--All--</option>
					<c:forEach items="${orgs}" var="obj">
						<option value="${obj.orgName}" <c:if test="${obj.orgName==form.institutionName}">selected="selected"</c:if>>${obj.orgName }</option>
					</c:forEach>                  
					</select>
				</span> 
				<span>Outlet Code: 
					<input name="outletCode" id="outletCode" class="text-normal" maxlength="12" value="${form.outletCode }"/>
				</span>
				<span>Status:<select name="status" id="status" class="select-normal">
				<option value="0">--All--</option>
				<option value="1" <c:if test="${form.status == 1}">selected="selected"</c:if>>Enabled</option>
				<option value="2" <c:if test="${form.status == 2}">selected="selected"</c:if>>Disabled</option>
				<option value="3" <c:if test="${form.status == 3}">selected="selected"</c:if>>Deleted</option>
				</select>
				</span> 
				<input type="button" value="Query" onclick="doSubmit();" class="button-normal"></input>
			</div>
			<div class="right">
				<table width="260" border="0" cellspacing="0" cellpadding="0">
					<tr style="height: 50px; line-height: 50px">
						<td align="right"><input type="button" value="New Outlet"
							onclick="showBox('outlets.do?method=createInit','New Outlet',550,800)"
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
							<td style="width: 8%">Outlet Code</td>
							<th width="1%">|</th>
							<td style="width: 10%">Outlet Name</td>
							<th width="1%">|</th>
							<td style="width: 10%">Institution</td>
							<th width="1%">|</th>
							<td style="width: 12%">Administrative Area</td>
							<th width="1%">|</th>
							<td style="width: 10%">Contact Person</td>
							<th width="1%">|</th>
							<td style="width: 10%">Contact Phone</td>
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
					<%-- <td style="width: 7%">${items.statusValue}</td>
					<td width="1%">&nbsp;</td> --%>
					<td style="width: *%"><c:if test="${items.status==1 }">
							<span><a href="#" onclick="resetPassword('${items.outletCode }')">Reset Outlet Password</a></span>&nbsp;|
							<span><a href="#"
								onclick="showBox('outlets.do?method=detailsOutlets&outletCode=${items.outletCode }','Outlet Details',450,800)">Details</a></span>&nbsp;|
						<span><a href="#"
								onclick="showBox('outlets.do?method=modifyInit&outletCode=${items.outletCode}','Modify Outlet',550,800)">Edit</a></span>&nbsp;|
							<span>Enable</span>&nbsp;|
							<span><a href="#" onclick="disable('${items.outletCode }')">Disable</a></span>&nbsp;|
							<span><a href="#" onclick="delte('${items.outletCode }')">Delete</a></span>
						</c:if> <c:if test="${items.status==2 }">
							<span style="color: gray">Reset Outlet Password</span>&nbsp;|
							<span><a href="#"
								onclick="showBox('outlets.do?method=detailsOutlets&outletCode=${items.outletCode }','Outlet Details',450,800)">Details</a></span>&nbsp;|
						
						<span><a href="#"
								onclick="showBox('outlets.do?method=modifyInit&outletCode=${items.outletCode}','Modify Outlet',550,800)">Edit</a></span>&nbsp;|
							<span><a href="#" onclick="enable('${items.outletCode }')">Enable</a></span>&nbsp;|
							<span style="color: gray">Disable</span>&nbsp;|
							<span><a href="#" onclick="delte('${items.outletCode }')">Delete</a></span>
						</c:if> <c:if test="${items.status==3 }">
							<span style="color: gray">Reset Outlet Password</span>&nbsp;|
							<span><a href="#"
								onclick="showBox('outlets.do?method=detailsOutlets&outletCode=${items.outletCode }','Outlet Details',450,800)">Details</a></span>&nbsp;|
						<span style="color: gray">Edit</span>&nbsp;|
							<span style="color: gray">Enable</span>&nbsp;|
							<span style="color: gray">Disable</span>&nbsp;|
							<span style="color: gray">Delete</span>
						</c:if></td>
				</tr>
			</c:forEach>
		</table>
		${pageStr}
	</div>
</body>
</html>