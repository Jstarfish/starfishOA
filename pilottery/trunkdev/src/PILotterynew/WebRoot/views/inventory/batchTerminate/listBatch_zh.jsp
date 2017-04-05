<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/views/common/taglibs.jsp"%>
<html>
<head>

<title>批次列表</title>

<%@ include file="/views/common/meta.jsp"%>

<%@ include file="/views/common/meta.jsp"%>
<link rel="stylesheet" type="text/css" href="${basePath}/css/style.css" />
<link rel="stylesheet" href="${basePath}/component/messageBox/myJsBox.css"
	type="text/css" />
<script type="text/javascript" src="${basePath}/component/messageBox/myJsBox_zh.js"></script>
<script type="text/javascript"
	src="${basePath}/component/My97DatePicker/WdatePicker.js"></script>
<script type="text/javascript" src="${basePath}/js/jquery/jquery-1.9.1.js"></script>
<script type="text/javascript">
function terBatch(planCode,batchNo,planName) {
	$.post("termination.do?method=terBatch", {
		"planCode" : planCode,
		"batchCode" : batchNo
	}, function(data) {
		if (data.errorMessage != null && data.errorMessage != "") {
			showError(data.errorMessage);
		} else {
			showPage('termination.do?method=print&planCode='+planCode+'&batchNo='+batchNo+'&planName='+planName,'Print');
		}
	});
}
function initTer(planCode,batchNo,planName) {
	
	closeDialog();
	terBatch(planCode,batchNo,planName);
}
function initTerBatch(planCode,batchNo,planName) {
	showBox('termination.do?method=detailsBatchPrint&planCode='+planCode+'&batchNo='+batchNo+"&planName="+planName,'批次详情',365,650);
}
/* function initTerBatch(planCode,batchNo,planName) {
	$
			.post(
					"termination.do?method=initTerBatch",
					{
						"planCode" : planCode,
						"batchCode" : batchNo
					},
					function(data) {
						if (data == "success") {
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
										+ "Do you want to termination batch ?"
										+ '</td></tr>'
										+ '<tr height="60px">'
										+ '<td colspan="2" class="fotter">'
										+ '<input id="ok_button" type="button" onclick="initTer('+"'"+planCode+"'"+','+"'"+batchNo+"'"+','+"'"+planName+"'"+')" class="my-button" value="Submit" style="float:left;margin-left:50px"></input>'
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
										+ '<input id="ok_button" type="button" onclick="initTer('+"'"+planCode+"'"+','+"'"+batchNo+"'"+','+"'"+planName+"'"+')" class="my-button" value="Submit" style="float:left;margin-left:50px"></input>'
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


} */
</script>
</head>
<body>
	<!-- 顶部标题块 -->
	<div id="title">批次列表</div>
	<!-- 列表表头块 -->
	<div id="headDiv">
		<table width="100%" border="0" cellpadding="0" cellspacing="0">
			<tr>
				<td>
					<table class="datatable">
						<tr class="headRow">
							<td style="width: 10px;">&nbsp;</td>
							<td style="width: 18%">方案编号</td>
							<th width="1%">|</th>
							<td style="width: 18%">方案名称</td>
							<th width="1%">|</th>
							<td style="width: 18%">批次</td>
							<th width="1%">|</th>
							<td style="width: 18%">状态</td>
							<th width="1%">|</th>
							<td style="width: *%">操作</td>
						</tr>
					</table>
				</td>
				<td style="width: 17px; background: #2aa1d9"></td>
			</tr>
		</table>
	</div>
	<div id="bodyDiv" style="top:76px;">
		<table class="datatable">
			<c:forEach var="data" items="${batchList}" varStatus="status">
				<tr class="dataRow">
					<td style="width: 10px;">&nbsp;</td>
					<td style="width: 18%">${data.planCode}</td>
					<td width="1%">&nbsp;</td>
					<td style="width: 18%">${data.planName}</td>
					<td width="1%">&nbsp;</td>
					<td style="width: 18%">${data.batchNo}</td>
					<td width="1%">&nbsp;</td>
					<td style="width: 18%">${data.statusen}</td>
					<td width="1%">&nbsp;</td>
					<td style="width: *%">
					<c:if test="${data.status==1||data.status==2 }">
					<span><a href="#" onclick="initTerBatch('${data.planCode}','${data.batchNo}','${data.planName}');">终结</a></span>&nbsp;|
					<span>
					<a href="#"	onclick="showBox('termination.do?method=detailsBatch&planCode=${data.planCode}&batchNo=${data.batchNo}','批次详情',380,650)">详情</a></span>&nbsp;|
					<span style="color:gray">打印</span>
					</c:if>
					<c:if test="${data.status==3 }">
					<span style="color:gray">终结</span>&nbsp;|
					<span>
					<a href="#"	onclick="showBox('termination.do?method=detailsBatch&planCode=${data.planCode}&batchNo=${data.batchNo}','批次详情',366,680)">详情</a></span>&nbsp;|
					<span><a href="#" onclick="showPage('termination.do?method=print&planCode=${data.planCode}&batchNo=${data.batchNo}&planName=${data.planName}','打印')">打印</a></span>
					</c:if>
				</tr>
			</c:forEach>
		</table>
		${pageStr}
	</div>
</body>
</html>
