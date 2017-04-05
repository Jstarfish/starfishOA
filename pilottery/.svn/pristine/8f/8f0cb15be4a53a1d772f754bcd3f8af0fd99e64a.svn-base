<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/views/common/taglibs.jsp"%>
<html>
<head>
<title>角色列表</title>
<%@ include file="/views/common/meta.jsp" %>
<link rel="stylesheet" type="text/css" href="${basePath}/css/style.css" />
<link rel="stylesheet" href="${basePath}/component/messageBox/myJsBox.css" type="text/css"/>
<script type="text/javascript" src="${basePath}/component/messageBox/myJsBox.js"></script>
<script type="text/javascript" src="${basePath}/js/jquery/jquery-1.9.1.js"></script>
<script type="text/javascript">
</script>
</head>
<body>
<div id="title">List of System Parameter</div>
	<div id="headDiv">
	<input id="deliveryOrderNo" type="hidden" name="id" value="${form.id }"/>
	<table width="100%"  border="0" cellpadding="0" cellspacing="0">
		<tr>
			<td>
				<table class="datatable">
				<tr class="headRow">
					<td style="width:10px;">&nbsp;</td>
					<td style="width:15%" scope="col">System Parameter Code</td>
					<th width="1%">|</th> 
					<td style="width:18%" scope="col">System Parameter Description</td> 
					<th width="1%">|</th> 
					<td style="width:18%" scope="col">System Parameter Value</td> 
					<th width="1%">|</th> 
					<td style="width:*%" scope="col">Operation</td>
				</tr>
				</table>
				</td>
				<td style="width:17px;background:#2aa1d9"></td>
             </tr>
	</table>
</div>
	
<div id="bodyDiv" style="top:76px;">
	<table class="datatable">
	 <c:forEach var="u" items="${pageDataList}" varStatus="status" > 
		<tr class="dataRow">
			<td style="width:10px;">&nbsp;</td>
			<td style="width:15%">${u.id} </td>
			<td width="1%">&nbsp;</td>
			<td style="width:18%" title="${u.desc}">${u.desc} </td>
			<td width="1%">&nbsp;</td>
			<td style="width:18%" title="${u.value}">${u.value} </td>
			<td width="1%">&nbsp;</td>
			<td style="width:*%" scope="col">
				<!-- 修改角色下边弄角色授权，下边同时又有功能树列表可以选择 -->
				<a href="#" onclick="showBox('sysParameter.do?method=editSysParameter&id=${u.id}', 'Edit',300,650);">Edit</a>
		   </td> 
		</tr>
	</c:forEach> 
	</table>
		${pageStr }
</div>
</body>
</html>
