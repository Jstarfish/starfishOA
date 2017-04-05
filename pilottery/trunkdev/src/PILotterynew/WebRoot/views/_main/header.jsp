<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/views/common/taglibs.jsp"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title></title>
<link rel="stylesheet" type="text/css" href="${basePath}/css/style.css" />
<link rel="stylesheet" type="text/css" href="${basePath}/css/menu.css" />
<link rel="stylesheet" type="text/css" href="${basePath}/css/superfish.css" />

<link rel="stylesheet" href="${basePath}/component/messageBox/myJsBox.css" type="text/css"/>

<script type="text/javascript" src="${basePath}/component/messageBox/myJsBox.js"></script>
<style type="text/css">

.info {
    width:100%;
    height: 36px;
	line-height: 36px;
	background: #fff;
	border-bottom: 2px solid #363a40;
	clear: both;
}
.info .left {
	color: #363a40;
	font-size: 12px;
	font-family: Verdana, Geneva, sans-serif;
	padding-left:15px;
}

.info .left span{
	color: #f79222;
	font-weight: bold;
	margin-right: 15px;
}
.info .right img{
    vertical-align: middle;
    margin-left:10px;
    opacity: 0.8;
    cursor: pointer;
}
.info .right img:hover{
    opacity: 1.0;
}

</style>

<script language="javascript" src="${basePath}/js/menu.js"></script>
<script type="text/javascript">
<c:forEach items="${user_privilege_list}" var="p">
	menu_add('${p.id}','${p.parentId}','${p.name}','${p.url}','ifmain','');
</c:forEach>
function logout(){
    window.top.location.href = "${basePath}";
}

function logoutDialog(){
	showDialog('logout()',"Exit System","Are you sure you want to logout?");
}

</script>
</head>
<body onload="make_menu(0);">
	<div id="container">
		<div class="header">
			<div class="header-nav-bg">
				<div id ="menus" class="header-nav">					
					<div style="float: right; margin-top: 0px;">
						<img src="${basePath}/img/logo.png" width="134" height="52" />
					</div>
				</div>
			</div>
			<!--用户信息区开始-->
			<div class="info">
				<table width="100%" border="0" cellspacing="0" cellpadding="0">
				<tr><td width="*%" class="left">
					Welcome, <span></span>
					User:${sessionScope.current_user.realName}
					<span></span> 
					<span><c:forEach items="${sessionScope.user_role_list}" var="r">${r.name} &nbsp;&nbsp;</c:forEach></span>
				    <span class="exit"><a href="javascript:logoutDialog();">[Exit]</a></span>
				</td>
				</tr>
                </table>
			</div>
			<!--用户信息区结束-->
			<!--  <div id="title">已申请事项</div>		-->	
		</div>
	</div>
</body>
</html>
