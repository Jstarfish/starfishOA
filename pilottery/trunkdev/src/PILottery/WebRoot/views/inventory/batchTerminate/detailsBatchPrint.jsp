<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/views/common/taglibs.jsp"%>
<html>
<head>
<title>Details Batch</title>
<%@ include file="/views/common/meta.jsp" %>
<link rel="stylesheet" type="text/css" href="${basePath}/css/style.css" />
<link rel="stylesheet" type="text/css" href="${basePath}/css/pop-up.css" />
<script type="text/javascript" src="${basePath}/js/myJs.js"></script>
<script type="text/javascript" src="${basePath}/js/jquery/jquery-1.9.1.js"></script>
<script type="text/javascript">
function doSubmit(){
	$('#terBatch').attr("action","termination.do?method=terBatch&planCode="+$("#planCode").val()+"&planName="+$("#planName").val()+"&batchCode="+$("#batchNo").val());
	$('#terBatch').submit();
}
function doClose() {
	window.parent.closeBox();
}
	

</script>
</head>
<body>
<form action="" id="terBatch" method="POST">
	<div id="tck">
		<div class="mid">
			<table width="100%" border="0" cellspacing="0" cellpadding="0">
				<tr>
					<td align="right" width="25%">Total Tickets(tickets)：</td>
					<td align="left" width="25%">${tickets.total}</td>
		<input type="hidden" id="planCode" name="planCode" value="${planCode}" > 
		<input type="hidden" id="planName" name="planName" value="${planName}" >
		<input type="hidden" id="batchNo"  name="batchNo"  value="${batchNo}"  >
				</tr>
				<tr>
					<td align="right">Tickets Sold(tickets)：</td>
					<td align="left">${tickets.sales}</td>
				</tr>
				<tr>
					<td align="right">Tickets Onroad(tickets)：</td>
					<td align="left">${tickets.road}</td>
				</tr>
				<tr>
					<td align="right">Damaged Tickets(tickets)：</td>
					<td align="left">${tickets.damages}</td>
				</tr>
				<tr>
					<td align="right">Storage Quantity(tickets)：</td>
					<td align="left">${tickets.stock}</td>
				</tr>
				<tr>
					<td align="right">Manager Storage Quantity(tickets)：</td>
					<td align="left">${tickets.manager}</td>
				</tr>
				<tr>
					<td align="right"></td>
					<td align="left"></td>
				</tr>
				<tr>
					<td align="right"></td>
					<td align="left"></td>
				</tr>
			</table>
		</div>
		
		<div class="pop-footer">
			<span class="left"> <input id="query" type="button" value='Termination'
				class="button-normal" onclick="doSubmit();"></input>
			</span> <span class="right"> <input type="button" value="Cancel"
				onclick="doClose();" class="button-normal"></input>
			</span>
		</div>
	</div>
</form>
</body>
</html>