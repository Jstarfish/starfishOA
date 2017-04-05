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
	var msg = "你确定要删除该角色?";
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
<div id="title">角色管理</div>
	<div class="queryDiv">
    	<div class="right"> 
			<table width="100" border="0" cellspacing="0" cellpadding="0" style="margin-top:2px;">
			  <tr style="height:50px;line-height:50px">
			    <td><a href="#" onclick="showBox('role.do?method=editRole','新建角色',300,650)" ><button class="button-normal">新建角色</button></a></td>
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
					<td style="width:15%" scope="col">角色编号</td>
					<th width="1%">|</th> 
					<td style="width:18%" scope="col">角色名称</td> 
					<th width="1%">|</th> 
					<td style="width:18%" scope="col">角色描述</td> 
					<th width="1%">|</th> 
					<td style="width:*%" scope="col">操作</td>
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
				<a href="#" onclick="showBox('role.do?method=editRole&roleId=${u.id}', '编辑角色',300,650);">编辑角色</a>
				|
				<a href="#" onclick="showBox('role.do?method=addRoleUser&roleId=${u.id}', '添加用户',650,820);">添加用户</a>
				|
				<a href="#" onclick="showBox('role.do?method=rolePermissions&roleId=${u.id}', '角色权限',650,800);">权限</a>
				|
				<a href="#" onclick="delet('${u.id}')">删除</a>
			</td> 
		</tr>
	</c:forEach> 
	</table>
		${pageStr }
</div>
</body>
</html>
