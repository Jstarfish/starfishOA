<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/views/common/taglibs.jsp"%>

<html>
<head>
<title>Damage Detail</title>
<link rel="stylesheet" type="text/css" href="${basePath}/css/pop-up.css" />
<script type="text/javascript" src="${basePath}/js/jquery/jquery-1.9.1.js"></script>
<style type="text/css">
.datatable td {
	border-bottom: 1px solid rgb(228, 229, 229);
	height: 15px;
	line-height: 15px;
	text-align: left;
	padding-left: 10px;
}
.edui-editor1 {
	border: 1px solid #DDD;
	border-top: 1px solid #EBEBEB;
	border-bottom: 1px solid #B7B7B7;
	background-color: #fff;
	position: relative;
	overflow: visible;
	border-radius: 4px;
	-moz-border-radius: 4px;
	-webkit-border-radius: 4px;
	box-shadow: 0 1px 1px #d3d1d1;
	margin-top: 0px;
	width: 100%;
	font-family: "微软雅黑";
	color: #000;
	font-size: 14px;
	padding: 5px;
}

</style>
</head>

<body style="margin: 0;">
	<div id="tck">
		<div class="mid">
			<table width="100%" border="0" cellspacing="0" cellpadding="0" id="total">
				<tr>
					<td align="right" class="td" width="15%">Record Code：</td>
					<td align="left" class="td" width="20%">${record}</td>
					<td class="td" align="right" width="35%">Quantity Damaged(tickets)：</td>
					<td class="td" align="left"><fmt:formatNumber value="${totalNum}" /></td>
				</tr>
			</table>

			<div style="padding: 0 5px;">
				<!-- table header -->
				<div style="position: relative; z-index: 1000px; margin-top: 10px;">
					<table class="datatable" id="table1_head" width="100%">
						<tbody>
							<tr>
								<th width="10%">Plan Code</th>
								<th width="2%">|</th>
								<th width="10%">Plan Name</th>
								<th width="2%">|</th>
								<th width="10%">Batch No</th>
								<th width="2%">|</th>
								<th width="10%">Pecification</th>
								<th width="2%">|</th>
								<th width="15%">Barencoding</th>
								<th width="2%">|</th>
								<th width="15%">Total Tickets</th>
							</tr>
						</tbody>
					</table>
				</div>
				<!-- table header end-->

				<!-- table list -->
				<div id="box" style="border: 1px solid #ccc;">
					<table id="fatable" class="datatable" cellpadding="0" cellspacing="0"
						width="100%">
						<tbody>
							<c:forEach var="item" items="${damageList}" varStatus="status">
								<tr>
									<td width="10%">${item.planCode}</td>
									<td width="2%">&nbsp;</td>
									<td width="10%">${item.planName}</td>
									<td width="2%">&nbsp;</td>
									<td width="10%">${item.batchNo}</td>
									<td width="2%">&nbsp;</td>
									<td width="10%">${item.pecificationValue}</td>
									<td width="2%">&nbsp;</td>
									<td width="15%">${item.barEncoding}</td>
									<td width="2%">&nbsp;</td>
									<td width="15%"><fmt:formatNumber value="${item.unitNum}" /></td>
								</tr>
							</c:forEach>
						</tbody>
					</table>
				</div>
			</div>
		</div>
		<div class="mid">
				<table width="100%" border="0" cellspacing="0" cellpadding="0">
					<c:if test="${!empty backup}">
						<tr>
							<td style="padding-top: 20px;" colspan="4" >Remarks : <textarea
									name="remarks" rows="5" readonly="readonly" class="edui-editor1">${backup}</textarea></td>
						</tr>
					</c:if>

					<tr>
						<td><div style="margin: 10px 40px; float: right;"></div></td>
					</tr>
				</table>
			</div>
	</div>
</html>
