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
	case 4:
		var msg = "Are you sure you want to reset the TransPassword?";
		showDialog("resetTransPassword("+userid+")","Reset TransPassword",msg);
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
<div id="title">User Management</div>
	<div class="queryDiv">
	<form:form modelAttribute="userForm" action="user.do?method=listUsers">
		<div class="cx">
			<div class="left">
				<span>Institution:
            		<select class="select-normal" name="institutionCode" >
            			<option value="">--All--</option>
                   	  <c:forEach var="obj" items="${orgsList}" varStatus="plan">
                   	   		<c:if test="${obj.orgCode == form.institutionCode}">
                   	   			<option value="${obj.orgCode}" selected="selected">${obj.orgName}</option>
                   	   		</c:if>
                   	   		<c:if test="${obj.orgCode != form.institutionCode}">
                   	   			<option value="${obj.orgCode}">${obj.orgName}</option>
                   	   		</c:if>
                   	   </c:forEach>
                    </select>
            	</span>
			    <span>User Name：
			    	<form:input path="loginId" maxlength="20" class="text-normal"/>
			    </span>
			    <span>User Status：
			   	 	<form:select path="status"  class="select-normal">
			   	 		<option value="0">--All--</option>
						<form:options items="${userStatusMap}"/>
					</form:select>
			    </span>
			    <button class="button-normal">Query</button>
		    </div>
		    <div class="right"> 
  				<table width="100" border="0" cellspacing="0" cellpadding="0" style="margin-top:2px;">
				  <tr style="height:50px;line-height:50px">
				    <td><input type="button" class="button-normal" value="New User" 
				    onclick="showBox('user.do?method=editUser','New User',550,800)"/></td>
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
						<td style="width:14%" scope="col">User Name</td>
						<th width="1%">|</th> 
						<td style="width:14%" scope="col">Real Name</td> 
						<th width="1%">|</th> 
						<td style="width:14%" scope="col">Institution</td> 
						<th width="1%">|</th> 
						<td style="width:14%" scope="col">Contact Phone</td>
						<th width="1%">|</th> 
						<td style="width:*%" scope="col">Operation</td> 
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
				    <a href="#" onclick="showBox('user.do?method=userDetail&userId=${u.id}','Detail',550,800)">Details</a>
				    |
				    <!-- note: 这里的userId就是和UserController的Long userId绑定的 -->
					<a href="#" onclick="showBox('user.do?method=editUser&userId=${u.id}','Edit',550,800)" >Edit</a>
					|
					<a href="#" onclick="prompt('${u.id}', 0)">Reset Password</a>
					|
					
						<c:if test="${u.isCollector==1}">
	                    		<a href="#" onclick="prompt('${u.id}', 4)">Reset TransPassword</a>
	                    	</c:if>
	                    	<c:if test="${u.isCollector!=1}">
	                    		<span style="color:#CDC9C9">Reset TransPassword</span>
	                    </c:if>
						
					|
					<a href="#" onclick="showBox('user.do?method=setManageInst&userId=${u.id}','Institution Setting',550,800)">Institution Setting</a>
					|
					<c:if test="${u.status==1}">
					<a href="#" onclick="prompt('${u.id}', 1)">Lock</a>
					|
					<span style="color:green">Activated</span>
					|
					</c:if>
					<c:if test="${u.status==3}">
					<span style="color:#CDC9C9">Locked</span> 
					|
					<a href="#" onclick="prompt('${u.id}', 2)">Unlock</a>
					|
					</c:if>
					<a href="#" onclick="prompt('${u.id}', 3)">Delete</a>			
				</td> 
            </tr>

		</c:forEach>
     </table>
        ${pageStr }
    </div>
</html>
