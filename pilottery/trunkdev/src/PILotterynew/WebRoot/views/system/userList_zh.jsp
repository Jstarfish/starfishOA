<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/views/common/taglibs.jsp"%>
<%@ include file="/views/common/meta.jsp" %>
<html>
<head>
<title>用户列表</title>

<link rel="stylesheet" type="text/css" href="${basePath}/css/style.css" />
<link rel="stylesheet" href="${basePath}/component/messageBox/myJsBox.css" type="text/css"/>
<script type="text/javascript" src="${basePath}/component/messageBox/myJsBox_zh.js"></script>
<script type="text/javascript" src="${basePath}/js/jquery/jquery-1.9.1.js"></script>
<script type="text/javascript" src="${basePath}/js/myJs_zh.js"></script>
<script type="text/javascript" charset="UTF-8" > 

function prompt(userid, action) {
	switch(action){
	case 0:
		var msg = "你确定要重置密码吗?";
		showDialog("resetPassword("+userid+")","重置密码",msg);
		break;
	case 1:
		var msg = "你确定要锁定该用户吗?";
		showDialog("lockUser("+userid+")","锁定",msg);
		break;
	case 2:
		var msg = "你确定要解锁该用户吗?";
		showDialog("unlockUser("+userid+")","解锁",msg);
		break;
	case 3:
		var msg = "你确定要删除该用户吗?";
		showDialog("deleteUser("+userid+")","删除",msg);
		break;
	case 4:
		var msg = "你确定要重置交易密码吗?";
		showDialog("resetTransPassword("+userid+")","重置交易密码",msg);
		break;
	default: 
		break;
	}
};

function deleteUser(userid) {
	var url = "user.do?method=deleteUser&userId=" + userid;
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
};

function resetPassword(userid) {
	var url = "user.do?method=resetPwd&userId=" + userid;
 		$.get(url,	
			function(result){
				closeDialog();
				showRight();
			});
};

function resetTransPassword(userid) {
	var url = "user.do?method=resetTransPwd&userId=" + userid;
 		$.get(url,	
			function(result){
				closeDialog();
				showRight();
			});
};

function lockUser(userid) {
	var url = "user.do?method=changeUserActive&userId="+userid+"&status=3";
 			$.get(url,	
			function(result){
				closeDialog();
				window.location.reload(); 
			});
	
};

function unlockUser(userid) {
	var url = "user.do?method=changeUserActive&userId="+userid+"&status=1";
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
	<form:form modelAttribute="userForm" action="user.do?method=listUsers">
		<div class="cx">
			<div class="left">
				<span>所属机构：
			   	 	<form:input path="institutionName" maxlength="20" class="text-normal"/>
			    </span>
			    <span>用户名称：
			    	<form:input path="loginId" maxlength="20" class="text-normal"/>
			    </span>
			    <span>用户状态：
			   	 	<form:select path="status"  class="select-normal">
			   	 		<option value="0">--所有--</option>
						<form:options items="${userStatusMap}"/>
					</form:select>
			    </span>
			    <button class="button-normal">查询</button>
		    </div>
		    <div class="right"> 
  				<table width="100" border="0" cellspacing="0" cellpadding="0" style="margin-top:2px;">
				  <tr style="height:50px;line-height:50px">
				    <td><input type="button" class="button-normal" value="新建用户" 
				    onclick="showBox('user.do?method=editUser','新建用户',650,800)"/></td>
				    <td align="right">
						&nbsp;
	               	</td>
				  </tr>
				</table>
		    </div>
		</div>
	</form:form>
	</div>
	<div id="headDiv">
	<table width="100%"  border="0" cellpadding="0" cellspacing="0">
       <tr>
       		<td>
				<table class="datatable">
					<tr class="headRow">
						<td style="width:10px;">&nbsp;</td>
						<td style="width:14%" scope="col">登录名称</td>
						<th width="1%">|</th> 
						<td style="width:14%" scope="col">真实姓名</td> 
						<th width="1%">|</th> 
						<td style="width:14%" scope="col">所属机构</td> 
						<th width="1%">|</th> 
						<td style="width:14%" scope="col">移动电话</td>
						<th width="1%">|</th> 
						<td style="width:*%" scope="col">操作</td> 
					</tr>
        		</table>
        <td style="width:17px;background:#2aa1d9;"></td></tr>
    </table>
	</div>

    <div id="bodyDiv">
        <table class="datatable" id="exportPdfData">
            <c:forEach var="u" items="${pageDataList}" varStatus="status" >
            <tr class="dataRow">
            	<td style="width:10px;">&nbsp;</td>
				<td style="width:14%" scope="col">${u.loginId}</td>
				<td width="1%">&nbsp;</td> 
				<td style="width:14%" scope="col">${u.realName}</td> 
				<td width="1%">&nbsp;</td> 
				<td style="width:14%" scope="col">${u.institutionName}</td> 
				<td width="1%">&nbsp;</td> 
				<td style="width:14%" scope="col">${u.mobilePhone}</td>
				<td width="1%">&nbsp;</td> 
				<td style="width:*%" scope="col">
				    <a href="#" onclick="showBox('user.do?method=userDetail&userId=${u.id}','详情',650,800)">详情</a>
				    |
				    <!-- note: 这里的userId就是和UserController的Long userId绑定的 -->
					<a href="#" onclick="showBox('user.do?method=editUser&userId=${u.id}','编辑',650,800)" >编辑</a>
					|
					<a href="#" onclick="prompt('${u.id}', 0)">重置密码</a>
					|
					
						<c:if test="${u.isCollector==1}">
	                    		<a href="#" onclick="prompt('${u.id}', 4)">重置交易密码</a>
	                    	</c:if>
	                    	<c:if test="${u.isCollector!=1}">
	                    		<span style="color:#CDC9C9">重置交易密码</span>
	                    </c:if>
						
					|
					<c:if test="${u.status==1}">
					<a href="#" onclick="prompt('${u.id}', 1)">锁定</a>
					|
					<span style="color:green">可用</span>
					|
					</c:if>
					<c:if test="${u.status==3}">
					<span style="color:#CDC9C9">锁定</span> 
					|
					<a href="#" onclick="prompt('${u.id}', 2)">解锁</a>
					|
					</c:if>
					<a href="#" onclick="prompt('${u.id}', 3)">删除</a>			
				</td> 
            </tr>

		</c:forEach>
     </table>
        ${pageStr }
    </div>
</html>
