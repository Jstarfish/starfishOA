<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/views/common/taglibs.jsp"%>
<%@ include file="/views/common/meta.jsp" %>
<html>
<head>
<title>用户列表</title>

<link rel="stylesheet" type="text/css" href="${basePath}/css/style.css" />
<link rel="stylesheet" href="${basePath}/component/messageBox/myJsBox.css" type="text/css"/>
<script type="text/javascript" src="${basePath}/component/messageBox/myJsBox.js"></script>
<script type="text/javascript" src="${basePath}/js/jquery/jquery-1.9.1.js"></script>
<script type="text/javascript" src="${basePath}/js/myJs.js"></script>

<script type="text/javascript" charset="UTF-8" > 

function prompt(userid, action) {
	switch(action){
	case 0:
		var msg = "Are you sure you want to reset the password?";
		showDialog("resetPassword("+userid+")","Reset Password",msg);
		break;
	case 1:
		var msg = "Are you sure you want to lock the user?";
		showDialog("lockUser("+userid+")","Lock",msg);
		break;
	case 2:
		var msg = "Are you sure you want to unlock the user?";
		showDialog("unlockUser("+userid+")","Unlock",msg);
		break;
	case 3:
		var msg = "Are you sure you want to delete the user?";
		showDialog("deleteUser("+userid+")","Delete",msg);
		break;
	default: 
		break;
	
	}
	
};
function resetPassword(userid) {
	var url = "user.do?method=resetPwd&userId=" + userid;
	 //alert(url);
	
	/* $.get("sysUser.do?method=resetPwd&userId=" + userid, */
 			$.get(url,	
			function(result){
				closeDialog();
				showRight();
			});
	
};

function lockUser(userid) {
	//sysUser.do?method=changeUserActive&fl=confirm&userId=${u.id}&active=0
	var url = "sysUser.do?method=changeUserActive&userId="+userid+"&active=0";
	 //alert(url);
	
	/* $.get("sysUser.do?method=resetPwd&userId=" + userid, */
 			$.get(url,	
			function(result){
 				//alert(result);
				closeDialog();	
				window.location.reload(); 
				//showRight();
				/* showBox('_common/successTip','',400,500); */
				
			});
	
};
function unlockUser(userid) {
	//sysUser.do?method=changeUserActive&fl=confirm&userId=${u.id}&active=0
	var url = "sysUser.do?method=changeUserActive&userId="+userid+"&active=1";
	 //alert(url);
	
	/* $.get("sysUser.do?method=resetPwd&userId=" + userid, */
 			$.get(url,	
			function(result){
 				//alert(result);
				closeDialog();				
				window.location.reload(); 
				//showRight();
			});
	
};
function deleteUser(userid) {
	
	var url = "user.do?method=deleteUser&userId=" + userid;
	 //alert(url);
	
	/* $.get("sysUser.do?method=resetPwd&userId=" + userid, */
 			$.get(url,	
			function(result){
				closeDialog();				
				window.location.reload(); 
			});
	
};
</script>

</head>
<body>
<div id="title">用户管理</div>


	<div class="queryDiv">
	<form:form modelAttribute="userForm" action="user.do?method=list">
		<div class="cx">
			<div class="left">
				<span>所属机构：
			   	 	<form:input path="institutionCode" maxlength="20" class="text-normal"/>
			    </span>
			    <span>用户名称：
			    	<form:input path="loginId" maxlength="20" class="text-normal"/>
			    </span>
			    <span>用户状态:
			   	 	<form:select path="status"  class="select-normal">
			   	 		<option value="0">--ALL--</option>
						<form:options items="${userStatusMap}"/>
					</form:select>
			    </span>
			    <button class="button-normal">Query</button>
		    </div>
		    <div class="right"> 
  				<table width="100" border="0" cellspacing="0" cellpadding="0" style="margin-top:2px;">
				  <tr style="height:50px;line-height:50px">
				    <td><input type="button" class="button-normal" value="新增用户" 
				    onclick="showBox('sysUser.do?method=editUser','New User',350,700)"/></td>
<%-- 				    <td><a href="sysUser.do?method=editUser" rel="facebox" rev="New User">
<input type="button" class="button-normal" value="New User"></button></a></td> --%>
				    <td align="right">
						&nbsp;
	               	</td>
				  </tr>
				</table>
		    </div>
		</div>
	</form:form>
	</div>
	<div id="headDiv" style="position:fixed;width:100%;z-index: 2;">
	<table width="100%"  border="0" cellpadding="0" cellspacing="0">
       <tr><td>
		<table id="row" style="float:left;" class="datatable">
		<thead>
		<tr class="headRow">
		<td style="width:10%" scope="col">用户编号</td> 
		<td style="width:12%" scope="col">登录名称</td> 
		<td style="width:12%" scope="col">真实姓名</td> 
		<td style="width:12%" scope="col">所属机构</td> 
		<td style="width:16%" scope="col">移动电话</td>
		<td style="width:8%" scope="col">用户状态</td>
		<td style="width:*%" scope="col"></td> 
		</tr>
		</thead>
        </table>
        <td style="width:17px;background:#2aa1d9;"></td></tr>
    </table>
	</div>
	

    <div id="bodyDiv">
        <table class="datatable" id="exportPdfData">
        	<%int i = 0;%>
        	<%--pageDataList.list --%>
            <c:forEach var="u" items="${pageDataList}" varStatus="status" >
            
            <tr class="dataRow">
            	<td style="width:10%">${u.id}</td> 
				<td style="width:12%" scope="col">${u.loginId}</td> 
				<td style="width:12%" scope="col">${u.realName}</td> 
				<td style="width:12%" scope="col">${u.institutionName}</td> 
				<td style="width:16%" scope="col">${u.mobilePhone}</td>
				<td style="width:8%" scope="col">${userStatusMap[u.status]}</td> 
				<td style="width:*%" scope="col">
	
					<a href="#" onclick="showBox('sysUser.do?method=editUser&userId=${u.id}','Modify',350,700)" >修改</a></span>
					 |
					<a href="#" onclick="prompt('${u.id}', 0)">重置密码</a>
					 |
					<a href="#" onclick="prompt('${u.id}', 3)">删除</a>			
				</td> 
            </tr>

		</c:forEach>
        </table>
        ${pageStr }
    </div>
</html>
