<%@ page language="java" contentType="text/html; charset=UTF-8"   pageEncoding="UTF-8"%>
<%@ include file="/views/common/taglibs.jsp" %>
<%@ include file="/views/common/meta.jsp" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>

<head>
    <title>无纸化管理平台 - 登录页</title>

    <link href="${basePath}/css/bootstrap.min.css?v=3.3.6" rel="stylesheet">
    <link href="${basePath}/css/font-awesome.min.css?v=4.4.0" rel="stylesheet">
    <link href="${basePath}/css/animate.css" rel="stylesheet">
    <link href="${basePath}/css/style.css?v=4.1.0" rel="stylesheet">
    
    <script src="${basePath}/js/jquery.min.js?v=2.1.4"></script>
    <script src="${basePath}/js/bootstrap.min.js?v=3.3.6"></script>
    <script src="${basePath}/js/plugins/validate/jquery.validate.min.js"></script>

	<script type="text/javascript">
		$().ready(function() {
			if (window.top !== window.self) {
				window.top.location = window.location;
			}
			
			var errorMsg = "${errorMsg}";
			if(errorMsg){
				$("#error").append(errorMsg);
			}
			
			$("#loginBtn").click(function(){
				var regAcct=$('#regAcct').val();
				var regPwd=$('#regPwd').val();
				var userLan=$('#zhRadio:checked').val();
				$("#error").empty();
				if($.trim(regAcct) == ''){
					if(userLan == 'ZH'){
						$("#error").append("请输入用户名");
					}else{
						$("#error").append("Please input your user name");
					}
					return false;
				}
				if($.trim(regPwd) == ''){
					if(userLan == 'ZH'){
						$("#error").append("请输入密码");
					}else{
						$("#error").append("Please input your password");
					}
					return false;
				}
				
				$("#loginForm").submit();
			})
			
		    $("#enRadio").change(function(){
		       var val=$('#enRadio:checked').val();
		       if(val != null){
		    	   $('#welcomeTitle').text('Welcome to CNCP management platform');
		    	   $('#regAcct').attr('placeholder','Username');
		    	   $('#regPwd').attr('placeholder','Password');
		    	   //$('#validatorCode').attr('placeholder','Verification Code');
		    	   $('#loginBtn').text('Login');
		    	   
		       }
		    });

		    $("#zhRadio").change(function(){
		        var val=$('#zhRadio:checked').val();
		        if(val != null){
		        	$('#welcomeTitle').text('欢迎使用泰山无纸化管理平台');
		     	    $('#regAcct').attr('placeholder','用户名');
		     	    $('#regPwd').attr('placeholder','密码');
		     	    //$('#validatorCode').attr('placeholder','验证码');
		     	    $('#loginBtn').text('登录');
		        }
		     });
		});
	</script>
	<style>
		body{
			background-color:#383943;
		 /*
			background:url(${basePath}/img/login-background1.jpg) top left ;
			background-size:100% 100%;
			overflow:hidden;*/
		}
	</style>
</head>

<body>
    <div class="middle-box text-center loginscreen  animated fadeInDown">
        <div>
        	<div>
                <h1 class=""><!-- <img src="${basePath}/img/LOGO.png"> -->&nbsp;</h1>
            </div>
            <h3 class="text-nowrap" style="color:#fff;" id="welcomeTitle" >欢迎使用泰山无纸化管理平台</h3>
			<br/>
            <form method="post" action="login.do" id="loginForm">
            	<div class="form-group" style="display:block;">
                	<input type="text" id="regAcct" name="regAcct" class="form-control uname" placeholder="用户名"/>
                </div>
                <div class="form-group" style="display:block;">
                    <input type="password" id="regPwd" name="regPwd" class="form-control pword m-b" placeholder="密码"/>
                </div>
                <div class="form-group" style="display:block;">
                     <p style="color:#fff;"><input type="radio" id="zhRadio" name="userLang" value="ZH" checked="checked"/>&nbsp;中文	
                     &nbsp;&nbsp;&nbsp;&nbsp;<input type="radio" id="enRadio" name="userLang" value="EN" />&nbsp;English
                     </p>
                </div>
                <label id="error" class="error"></label>
                <button class="btn btn-success btn-block" id="loginBtn">登录</button>
            </form>
        </div>
    </div>
    
</body>

</html>
