<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/views/common/taglibs.jsp"%>
<html>
<head>

<title>损毁列表1</title>

<%@ include file="/views/common/meta.jsp"%>
<link rel="stylesheet" type="text/css" href="${basePath}/css/style.css" />
<link rel="stylesheet" href="${basePath}/component/messageBox/myJsBox.css"
	type="text/css" />
<script type="text/javascript" src="${basePath}/component/messageBox/myJsBox_zh.js"></script>
<script type="text/javascript"
	src="${basePath}/component/My97DatePicker/WdatePicker.js"></script>
<script type="text/javascript" src="${basePath}/js/jquery/jquery-1.9.1.js"></script>

<script type="text/javascript" charset="UTF-8">
	function doSubmit() {
		document.getElementById("queryForm").submit();
	}
	$(document).ready(function() {
		var val = $("#planCodeQuery").val();
		initSelect(val);
	});
	function initSelect(value) {
		var url = "damagedGoods.do?method=liandong&planCode=" + value;
		
		$.ajax({
			url : url,
			dataType : "",
			async : false,
			success : function(r) {
				$("#batchNoQuery").empty();
				if(value == ''){
					$("#batchNoQuery").append("<option	value=''>全部</option>");
				}
				for ( var i = 0; i < r.length; i++) {
					var option;
					if (r[i] == '${planForm.batchNoQuery}') {
						option = $("<option selected='selected'>").val(r[i]).text(r[i]);
					} else {
						option = $("<option>").val(r[i]).text(r[i]);
					}
					$("#batchNoQuery").append(option);
				}
			}
		});
	}
</script>

</head>
<body>
	<!-- 顶部标题块 -->
	<div id="title">损毁列表</div>
	<!-- 查询条件块 -->
	<div class="queryDiv">
		<form action="damagedGoods.do?method=listDamagedGoods" id="queryForm" method="POST">
			<div class="left">
				<span>方案名称: <select name="planCodeQuery" id="planCodeQuery"
					class="select-normal" onchange="initSelect($('#planCodeQuery').val());">
					<option	value=''>全部</option>
						<c:forEach items="${planList}" var="plan">
							<option value="${plan.planCode}"
								<c:if test="${plan.planCode==planForm.planCodeQuery }">selected</c:if>>${plan.fullName}</option>
						</c:forEach></select></span>
				 <span>批次编号: 
					 <select name="batchNoQuery" id="batchNoQuery" class="select-normal">
						<option	value=''>全部</option>
					 </select>
				 </span> 
				 <input type="button" value="查询" onclick="doSubmit();" class="button-normal"></input>
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
							<td style="width: 12%">记录编号</td>
							<th width="1%">|</th>
							<td style="width: 12%">损毁张数(张)</td>
							<th width="1%">|</th>
							<td style="width: 13%">金额(瑞尔)</td>
							<th width="1%">|</th>
							<td style="width: 13%">登记人</td>
							<th width="1%">|</th>
							<td style="width: 13%">日期</td>
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
			<c:forEach var="items" items="${pageDataList }" varStatus="status">
				<tr class="dataRow">
					<td style="width: 10px;">&nbsp;</td>
					<td style="width: 12%">${items.recordCode}</td>
					<td width="1%">&nbsp;</td>
					<td style="width: 12%"><fmt:formatNumber value="${items.damageNum}" /></td>
					<td width="1%">&nbsp;</td>
					<td style="width: 13%; text-align: right"><fmt:formatNumber
							value="${items.amount}" /></td>
					<td width="1%">&nbsp;</td>
					<td style="width: 13%">${items.outPerson}</td>
					<td width="1%">&nbsp;</td>
					<td style="width: 13%"><fmt:formatDate value="${items.regDate}"
							pattern="yyyy-MM-dd HH:mm:ss" /></td>
					<td width="1%">&nbsp;</td>
					<td style="width: *%"><span><a href="#"
							onclick="showBox('damagedGoods.do?method=detailsDamaged&record=${items.recordCode }','损毁详情',550,980)">详情</a></span>
					</td>
				</tr>
			</c:forEach>
		</table>
		${pageStr}
	</div>
</body>
</html>