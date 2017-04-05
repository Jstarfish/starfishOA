<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/views/common/taglibs.jsp"%>
<html>
<head>

<title>List of Plans</title>

<%@ include file="/views/common/meta.jsp"%>

<link rel="stylesheet" type="text/css" href="${basePath}/css/style.css" />
<link rel="stylesheet" type="text/css" href="${basePath}/css/pop-up.css" />
<link rel="stylesheet" type="text/css" href="${basePath}/css/validate.css" />
<link rel="stylesheet" href="${basePath}/component/messageBox/myJsBox.css"
	type="text/css" />
<script type="text/javascript" src="${basePath}/component/messageBox/myJsBox.js"></script>
<script type="text/javascript" src="${basePath}/js/myJs.js"></script>
<script type="text/javascript" src="${basePath}/js/jquery/jquery-1.9.1.js"></script>
<link href="${basePath}/views/inventory/goodsReceipts/css/style3.css"
	rel="stylesheet" type="text/css" />
<style type="text/css">
body {
	margin: 0;
	padding: 0;
	margin: 0px;
	padding: 0px;
	font: 14px/20px "微软雅黑", Arial, Helvetica, sans-serif;
	background: #f2f1f1;
	width: 100%;
	height: 100%;
}

select {
	outline: none;
}

ul {
	list-style: none;
}

a {
	text-decoration: none;
}
</style>
<script type="text/javascript" charset="UTF-8">
	$(document).ready(function() {

		var val1 = $('#planName').val();
		initSelect(val1);

	});
	function isNull(data) {
		return (data == "" || data == undefined || data == null);
	}

	function initSelect(val1) {

		var url = "termination.do?method=liandong&planCode=" + val1;

		$.ajax({
			url : url,
			dataType : "",
			type : "get",
			async : false,
			success : function(r) {
				$("#terBatch").empty();
				for ( var i = 0; i < r.length; i++) {
					var option = $("<option>").val(r[i]).text(r[i]);
					$("#terBatch").append(option);
				}
			}
		});
		var val2 = $('#terBatch').val();
		if (!isNull(val1) && !isNull(val2)) {
			inittwo(val2);
		}
	}
	function inittwo(val2) {
		var val1 = $('#planName').val();
		if (!isNull(val1) && !isNull(val2)) {
			var url1 = "termination.do?method=liandong1&planCode=" + val1
					+ "&batchNo=" + val2;
			$
					.ajax({
						url : url1,
						dataType : "",
						type : "get",
						async : false,
						success : function(r) {
							$("#box").empty();
							var html = '';
							html += '<table class="datatable">';
							
								html += '<tr><td style="width:20%">'
										+ r[i].total + '</td>';
								html += '<td style="width:17%">' + r[i].sales
										+ '</td>';
								html += '<td style="width:21%">' + r[i].damages
										+ '</td>';
								html += '<td style="width:17%">' + r[i].stock
										+ '</td>';
								html += '<td style="width:*%">' + r[i].manager
										+ '</td></tr>';
							
							$("#box").html(html);
						}
					});
		}
	}
	function terBatch() {
		$.post("termination.do?method=terBatch", {
			"planCode" : $("#planName").val(),
			"batchCode" : $("#terBatch").val()
		}, function(data) {
			if (data.errorMessage != null && data.errorMessage != "") {
				showError(data.errorMessage);
			} else {

				$("#batchCounts").val(data.batchCounts);
				$("#saleCounts").val(data.saleCounts);
				$("#counts").val(data.counts);
				$("#warehouseCounts").val(data.warehouseCounts);
				$("#marketCounts").val(data.marketCounts);
				$("#brokenNum").val(data.brokenNum);
				$("#saleMoney").val(data.saleMoney);
				$("#totalNum").val(data.warehouseCounts + data.marketCounts);
				$("tr").show();
			}
		});
	}
	function initTerBatch() {
		$
				.post(
						"termination.do?method=initTerBatch",
						{
							"planCode" : $("#planName").val(),
							"batchCode" : $("#terBatch").val()
						},
						function(data) {
							if (data == "success") {
								terBatch();
							} else {
								var mydiv = document.getElementById("mydiv");
								if (mydiv == null) {
									mydiv = document.createElement("div");
									mydiv.id = "mydiv";
									var str = '<div id="fullbg"></div>'
											+ '<div id="dialog" style="height:220px;width:400px">'
											+ '<div class="title" onmousedown="mouseDown(event)">'
											+ "Termination Batch"
											+ '<div class="close"><a href="#" onclick="closeDialog();"></a></div></div>'
											+ '<div class="container">'
											+ '<table border="0" cellspacing="0" cellpadding="0" width="100%" height="100%" style="word-break: break-all;">'
											+ '<tr><td width="25%"><div class="question"><div></td><td style="font-size:14px;padding: 0px 50px 0px 10px;word-break: keep-all">'
											+ "Exist en route or en outlet lottery.Do you want continue ?"
											+ '</td></tr>'
											+ '<tr height="60px">'
											+ '<td colspan="2" class="fotter">'
											+ '<input id="ok_button" type="button" onclick="initTer()" class="my-button" value="Submit" style="float:left;margin-left:50px"></input>'
											+ '<input type="button" class="my-button" value="Cancel" onclick="closeDialog()" style="float:right;margin-right:50px"></input>'
											+ '</td>' + '</tr>' + '</table>'
											+ '</div>' + '</div>';

									mydiv.innerHTML = str;
									document.body.appendChild(mydiv);
								}

								openDialog();

								document.getElementById("dialog").onmouseout = mouseUp;
								window.onmouseup = mouseUp;
								window.onmousemove = mouseMove;
							}
						});

	}
	function initTer() {
		closeDialog();
		terBatch();
	}
</script>

</head>
<body>
	<form action="plans.do?method=listPlans" method="POST" id="planForm">
		<div class="pop-body">
			<table width="100%" border="0" cellspacing="0" cellpadding="0">
				<thead>
					<tr>
						<td colspan="2"
							style="background: #2aa1d9; height: 42px; font-size: 18px; color: #fff; line-height: 42px; padding-left: 20px; padding-right: 10px;">
							Batch Termination</td>
					</tr>
				</thead>
				<tr>
					<td align="right" width="25%">Select Plan</td>
					<td align="left" width="30%"><select id="planName" class="select-big"
						name="planName" onchange="initSelect($('#planName').val());">
							<c:forEach items="${planList}" var="plan">
								<option value="${plan.planCode}">${plan.fullName}</option>
							</c:forEach>
					</select></td>
				</tr>
				<tr>
					<td align="right">Select Termination Batch</td>
					<td align="left"><select id="terBatch" class="select-big" name="terBatch"
						onchange="inittwo($('#terBatch').val());">
					</select></td>
				</tr>
				<tr>
					<td align="right"></td>
					<td align="left"><input id="okButton" type="button" value='Submit'
						class="button-normal" onclick="doSubmit();" /></td>
				</tr>
				<tr>
					<td colspan="2">
						<div style="border: 1px solid #ccc;">
							<table class="datatable" id="table1_head" width="100%">
								<tr>
									<th width=15%>Total Tickets</th>
									<th width=5%>|</th>
									<th width=12%>Sales Tickets</th>
									<th width=3%>|</th>
									<th width=14%>Damaged Tickets</th>
									<th width=7%>|</th>
									<th width=13%>In Stock</th>
									<th width=4%>|</th>
									<th>Marketmanager Stock</th>

								</tr>
							</table>
						</div>
					</td>
				</tr>
				<tr>
					<td colspan="2">
						<div id="box" style="border: 1px solid #ccc;"></div>
					</td>
				</tr>
				<tr hidden="true">
					<td align="right">Total Tickets(tickets):</td>
					<td align="left"><input name="batchCounts" class="text-big"
						id="batchCounts" value="" readonly="true" /></td>
				</tr>
				<tr hidden="true">
					<td align="right">Tickets Sold:</td>
					<td align="left"><input name="saleCounts" class="text-big" id="saleCounts"
						value="" readonly="true" /></td>
				</tr>
				<tr hidden="true">
					<td align="right">Payout Amount:</td>
					<td align="left"><input name="counts" class="text-big" id="counts" value=""
						readonly="true" /></td>
				</tr>
				<tr hidden="true">
					<td align="right">Sale Amount:</td>
					<td align="left"><input name="saleMoney" class="text-big" id="saleMoney"
						value="" readonly="true" /></td>
				</tr>
				<tr hidden="true">
					<td align="right">Storage Quantity:</td>
					<td align="left"><input name="warehouseCounts" class="text-big"
						id="warehouseCounts" value="" readonly="true" /></td>
				</tr>
				<tr hidden="true">
					<td align="right">Marketmanger Quantity:</td>
					<td align="left"><input name="marketCounts" class="text-big"
						id="marketCounts" value="" readonly="true" /></td>
				</tr>
				<tr hidden="true">
					<td align="right">Damage Quantity:</td>
					<td align="left"><input name="brokenNum" class="text-big" id="brokenNum"
						value="" readonly="true" /></td>
				</tr>
				<tr hidden="true">
					<td align="right">Total Quantity:</td>
					<td align="left"><input name="totalNum" class="text-big" id="totalNum"
						value="" readonly="true" /></td>
				</tr>
			</table>

		</div>


	</form>
	<!-- 列表表头块 -->



</body>
</html>
