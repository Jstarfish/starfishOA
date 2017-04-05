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
function delet(roleId){
	var msg = "Are you sure you want to delete ?";
	showDialog("deleteRole('"+roleId+"')","Delete",msg);
	//deleteRole();
}

function deleteRole(roleId) {
	var url = "role.do?method=deleteRole&roleId=" + roleId;
		$.get(url,	
				function(result){
	 				if(result.message!='' && result.message!=null){
	 				    closeDialog();
		            	showError(result.message);
			        }
		            else{
		            	closeDialog();	
		            	window.location.reload(); 
			       }
				});
}
</script>
</head>
<body>
<div id="title">List of Roles</div>
	<div class="queryDiv">
    	<div class="right"> 
			<table width="100" border="0" cellspacing="0" cellpadding="0" style="margin-top:2px;">
			  <tr style="height:50px;line-height:50px">
			    <td><a href="#" onclick="showBox('role.do?method=editRole','New Role',300,650)" ><button class="button-normal">New Role</button></a></td>
			    <td align="right">
					&nbsp;
               	</td>
			  </tr>
			</table>
       </div>
	</div>
	<div id="headDiv">
	<table width="100%"  border="0" cellpadding="0" cellspacing="0">
		<tr>
			<td>
				<table class="datatable">
				<tr class="headRow">
					<td style="width:10px;">&nbsp;</td>
					<td style="width:15%" scope="col">Role Code</td>
					<th width="1%">|</th> 
					<td style="width:18%" scope="col">Role Name</td> 
					<th width="1%">|</th> 
					<td style="width:18%" scope="col">Role Description</td> 
					<th width="1%">|</th> 
					<td style="width:*%" scope="col">Operation</td>
				</tr>
				</table>
		<td style="width:17px;background:#2aa1d9;"></td></tr>
	</table>
</div>
	
<div id="bodyDiv">
	<table class="datatable">
	 <c:forEach var="u" items="${pageDataList}" varStatus="status" > 
		<tr class="dataRow">
			<td style="width:10px;">&nbsp;</td>
			<td style="width:15%">${u.id} </td>
			<td width="1%">&nbsp;</td>
			<td style="width:18%" title="${u.name}">${u.name} </td>
			<td width="1%">&nbsp;</td>
			<td style="width:18%" title="${u.comment}">${u.comment} </td>
			<td width="1%">&nbsp;</td>
			<td style="width:*%" scope="col">
				<!-- 修改角色下边弄角色授权，下边同时又有功能树列表可以选择 -->
				<a href="#" onclick="showBox('role.do?method=editRole&roleId=${u.id}', 'Edit Role',300,650);">Edit Role</a>
				|
				<a href="#" onclick="showBox('role.do?method=addRoleUser&roleId=${u.id}', 'Add Users',650,820);">Add Users</a>
				|
				<a href="#" onclick="showBox('role.do?method=rolePermissions&roleId=${u.id}', 'Role Permissions',650,800);">Permissions</a>
				|
				<a href="#" onclick="delet('${u.id}')">Delete</a>
			</td> 
		</tr>
	</c:forEach> 
	</table>
		${pageStr }
</div>
</body>
</html>
