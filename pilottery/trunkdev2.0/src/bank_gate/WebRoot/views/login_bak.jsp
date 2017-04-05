<%@ page language="java" contentType="text/html; charset=UTF-8"   pageEncoding="UTF-8"%>
<%@ include file="/views/common/taglibs.jsp" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>

<head>
    <title>无纸化管理平台 - 登陆页</title>

    <link href="${basePath}/css/bootstrap.min.css?v=3.3.6" rel="stylesheet">
    <link href="${basePath}/css/font-awesome.min.css?v=4.4.0" rel="stylesheet">
    <link href="${basePath}/css/animate.css" rel="stylesheet">
    <link href="${basePath}/css/style.css?v=4.1.0" rel="stylesheet">
    <link href="${basePath}/css/cncp/login.css" rel="stylesheet">
    
    <script src="${basePath}/js/jquery.min.js?v=2.1.4"></script>
    <script src="${basePath}/js/bootstrap.min.js?v=3.3.6"></script>
    <script src="${basePath}/js/plugins/validate/jquery.validate.min.js"></script>

	<script type="text/javascript">
		$().ready(function() {
			if (window.top !== window.self) {
				window.top.location = window.location;
			}
			$("#loginForm").validate({
				onsubmit : true,
				onfocusout : false,
				onkeyup : false
			});
		});
	</script>
</head>
<body class="signin">
    <div class="signinpanel">
        <div class="row">
            <div class="col-sm-6">
                <form method="post" action="login.do" id="loginForm">
                    <h4 class="no-margins">登录：</h4>
                    <p class="m-t-md">登录到无纸化管理平台</p>
                    <input type="text" name="regAcct" class="form-control uname" placeholder="用户名" required/>
                    <input type="password" name="regPwd" class="form-control pword m-b" placeholder="密码" required/>
                     <p><input type="radio" name="userLang" value="ZH"/>&nbsp;中文	
                     &nbsp;&nbsp;&nbsp;&nbsp;<input type="radio" name="userLang" value="EN" checked="checked"/>&nbsp;English
                     </p>
                    <button class="btn btn-success btn-block">登录</button>
                </form>
            </div>
        </div>
        <div class="signup-footer">
            <div class="pull-left">
                &copy; 2016 All Rights Reserved. 
            </div>
        </div>
    </div>
</body>

</html>
