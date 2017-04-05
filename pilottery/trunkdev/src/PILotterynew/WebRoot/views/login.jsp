<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/views/common/taglibs.jsp"%>
<html>
<head>
<title></title>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<script type="text/javascript" src="${basePath}/js/jquery/jquery-1.9.1.js"></script>
<link rel="stylesheet" type="text/css" href="${basePath}/css/style.css" />

<script type="text/javascript">
//跳出框架
if (window!=top){
	top.location=window.location;
}

//页面加载
window.onload = function(){
	//提示信息
	var sessionInvalidateMsg = "${sessionInvalidateMsg}";
	if (sessionInvalidateMsg != "") alert(sessionInvalidateMsg);
	var errorAccountMsg = "${errorAccountMsg}";
	var errorValidatorCodeMsg ="${errorValidatorCodeMsg}";
	if (errorAccountMsg != ""){
		$("#mail-tip").html(errorAccountMsg);
	}
	if (errorValidatorCodeMsg !=""){
		$("#mail-tip").html(errorValidatorCodeMsg);
	}
	document.forms[0].regAcct.focus();
};

//提交登录
function doSubmit(){
	if (doCheck()){
		document.forms[0].submit();
	}
}

//提交校验
function doCheck(){
	$("#mail-tip").html("");
	var acct= document.forms[0].regAcct.value;
	var pwd = document.forms[0].regPwd.value;
	var code = document.forms[0].validatorCode.value;
	var lang = $('#cnRadio:checked').val();
	if(lang != null){
		if (acct == ""){
			$("#mail-tip").html("请输入登录用户名！");
			return false;
		}else if (pwd == ""){
			$("#mail-tip").html("请输入登录密码！");
			return false;
		}else if (code == "" ||code.length != 4){
			$("#mail-tip").html("请输入有效的验证码！");
			return false;
		}
	}else{
		if (acct == ""){
			$("#mail-tip").html("Please enter your username!");
			return false;
		}else if (pwd == ""){
			$("#mail-tip").html("Please enter your password!");
			return false;
		}else if (code == "" ||code.length != 4){
			$("#mail-tip").html("Please enter a valid verification code!");
			return false;
		}
	}
	return true;
}
//处理回车事件
function doEenterEvent(evt){
	var evt = evt || window.event;
	var keyCode = evt.keyCode;
	//移动fucus
	if(keyCode==13){
		var src = evt.srcElement || evt.target;
		if(src.value != ""){
			var tabIndex = src.tabIndex;
			if (tabIndex < 3){
				document.forms[0].elements[tabIndex].focus();
			}else{
				doSubmit();
			}
		}
	}
}

$(function(){
    $("#enRadio").change(function(){
       var val=$('#enRadio:checked').val();
       if(val != null){
    	   $('#regAcct').attr('placeholder','Username');
    	   $('#regPwd').attr('placeholder','Password');
    	   $('#validatorCode').attr('placeholder','Verification Code');
    	   $('#loginBtn').text('Login');
    	   
       }
    });

    $("#cnRadio").change(function(){
        var val=$('#cnRadio:checked').val();
        if(val != null){
     	   $('#regAcct').attr('placeholder','用户名');
     	   $('#regPwd').attr('placeholder','密码');
     	   $('#validatorCode').attr('placeholder','验证码');
     	  $('#loginBtn').text('登陆');
        }
     });
});
</script>

<style>
body {padding: 0; margin: 0;}
body,html{
	height:100%;
   font-family:"microsoft yahei";
}
#outer {
    height:100%;
    overflow: hidden;
    position:relative;
    width:100%;
    background:#3f99d3;
	}
#outer[id] {
    display:table;
    position:static;}
#middle {
	position: absolute;
	top:50%;
	left:0;}
#middle[id] {
	display: table-cell;
	vertical-align: middle;
	position: static;}
#content{
	width:100%;
	height:410px;
	background:url(./img/login-bj.png) repeat-x;
	margin: 0 auto;
	text-align:center;
	border-top:1px solid #72c5fd;
	border-bottom:1px solid #72c5fd;
	}
.btn:hover {
  background: #9bdb03;

}
.btn:active:after {
  content: "";
  display:block;
  width: 2px;
  height: 2px;
  position:absolute;
  border-radius:2px;
  top:50%;
  left: 50%;
  margin: -1px 0 0 -1px;
  z-index:2;

}

input:-moz-placeholder,
textarea:-moz-placeholder，placeholder{
	color:#e2e0e0;
	}
input {
 	border:none;
	background:none;
	float:left;
	outline:none;
	font-family:"microsoft yahei";
	line-height:23px;
	margin-left:25px;
}
img{
	float:right;
	padding-right:10px;}
.inputbj{
	background:url(./img/login-input.png) no-repeat;
	width:350px;
	height:180px;
	margin-left:40px;
	}
.inputbj p{
	padding-top:12px;
	padding-bottom:10px;
	margin-left:30px;
	text-algin:left;
	}
.forget a{
	color:#000;
	text-decoration:none;
	}
.forget a:hover{
	color:#000;
	text-decoration:underline;
	}
.btn{
	font-family:"microsoft yahei", "微软雅黑";
	position: relative;
	display: inline-block;
	line-height: 25px;
	padding: 6px 148px;
	margin-top:10px ;
	transition: all .3s ease-out;
	text-transform: uppercase;
	border: 1px solid #90cd00;
	color: #fff;
	cursor: pointer;
	border-radius: 2px;
	-moz-border-radius: 2px;
	-webkit-border-radius: 2px;
	background-color: #90cd00;
	font-size:18px;
	width: 350px;
}

</style>

</head>
<body>
 <div id="outer">
     <div id="middle">
       <div id="content">
  		 <table width="800" border="0" align="center" cellpadding="0" cellspacing="0">
   			 <tr>
    			<td><img src="./img/login-logo.png" style="margin-top: 15px;"/></td>
    			<td width="15px"></td>
    			<td>
    				<div class="inputbj">
    					<form action="login.do" method="post" id="loginForm">
							<p>
	 							<input id="regAcct" name="regAcct"  type="text" placeholder="Username" tabindex="1" onkeydown="doEenterEvent(event);"/>
							</p>

							<p style="padding-top:45px;">
								<input class="inpnut" type="password"  id="regPwd"  name="regPwd"  placeholder="Password" tabindex="2" onkeydown="doEenterEvent(event);"/>
							</p>

							<p style="padding-top:40px;">
								<input class="inpnut" type="text" id="validatorCode" name="validatorCode" placeholder="Verification Code" tabindex="3" onkeydown="doEenterEvent(event);"/>
								<img src="validator.do?method=validator" width="81" height="32" onclick="javascript:this.src=('validator.do?method=validator&t=' + new Date().getTime());"  title="Can not see clearly, click to change"/>
							</p>

							<p id="mail-tip" style="padding-top:30px;color:red;"></p>
							<!-- <p>
							 <input type="radio" name="userLang" value="ZH"/><font color="#4495cd">中文</font>
							 <input type="radio" name="userLang" value="EN" /><font color="#4495cd">English</font>
							</p> -->
							<label style="float:right;">
								<table>
									<tr>
										<td><input type="radio" id="cnRadio"  name="userLang" value="ZH"/><font color="#4495cd">中文</font></td>
										<td><input type="radio" id="enRadio" checked="checked" name="userLang" value="EN"/><font color="#4495cd">English</font></td>
									</tr>
								</table> 
							</label>
						</form>
					</div>
	    			<div align="center"><a href="#" id="imgSubmit" onclick="javascript:doSubmit();"><button class="btn" id="loginBtn">Login</button></a></div>
	    		</td>
	 		 </tr>
	  		</table>
		</div>
	</div>
 </div>

</body>
</html>