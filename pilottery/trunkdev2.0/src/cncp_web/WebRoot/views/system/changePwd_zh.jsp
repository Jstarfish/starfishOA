<%@ page language="java" contentType="text/html; charset=UTF-8"   pageEncoding="UTF-8"%>
<%@ include file="/views/common/taglibs.jsp" %>
<%@ include file="/views/common/meta.jsp" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<title>修改密码</title>
<link rel="stylesheet" href="${basePath}/css/bootstrap.min.css?v=3.3.6">
<link rel="stylesheet" href="${basePath}/css/cncp/common.css">
<link rel="stylesheet" href="${basePath}/css/plugins/sweetalert/sweetalert.css">

<script src="${basePath}/js/jquery.min.js"></script>
<script src="${basePath}/js/bootstrap.min.js"></script>
<script src="${basePath}/js/plugins/validate/jquery.validate.min.js"></script>
<script src="${basePath}/js/plugins/validate/messages_zh.min.js"></script>
<script src="${basePath}/js/plugins/sweetalert/sweetalert.min.js"></script>
<script src="${basePath}/js/cncp/common.js"></script>
<script type="text/javascript">
$().ready(function () {
	
	// 验证两次输入值是否不相同  
	jQuery.validator.addMethod("notEqualTo", function(value, element, param) {  
	return value != $(param).val();  
	}, $.validator.format("不能与原密码相同!"));  
	
	jQuery.validator.addMethod("notEqual", function(value, element,param) {
		return value != "111111";
		}, $.validator.format("新密码不能修改为初始密码"));
	
	$("#login").hide();
    $("#editForm").validate({
    	onsubmit:true,
    	onfocusout:false,
    	onkeyup :false,
    	submitHandler: doSubmit,
    	rules:{
    		oldPwd:{
                required:true,
                minlength:6
            },
            newPwd:{
            	required:true,
                minlength:6,
                notEqualTo:'#oldPwd',
                notEqual:"notEqual"
            },
            newPwdConfirm:{
            	required:true,
            	minlength:6,
            	equalTo:'#newPwd'
            }                   
        },
        messages:{
            oldPwd:{
                required:"必填",
                minlength:"长度不能小于6位"
            },
            newPwd:{
                required: "必填",
                minlength:"长度不能小于6位",
                notEqualTo:'不能与原密码相同'
            },
            newPwdConfirm:{
            	required: "必填",
            	minlength:"长度不能小于6位",
            	equalTo:'两次密码不一致'
            }                                    
        }
    });
});
function doSubmit(){
	$.ajax({
	   type: "POST",
	   url: "login.do?method=changePwd",
	   data: $('#editForm').serialize(),
	   success: function(msg){
	     if(msg=='1'){
	    	 $("#login").show();
	    	 sweetAlert("密码修改成功", "", "success");
	     }else if(msg=="-1"){
	    	 sweetAlert("密码修改失败", "原密码输入错误", "error");
	     }else if(msg=="-2"){
	    	 sweetAlert("密码修改失败", "服务器异常", "error");
	     }
	   }
	}); 
}

function doLogin(){
	window.top.location.href="${basePath}";
}
</script>
</head>
<body style="overflow-x:hidden;">
	<div class="ibox-content " style="margin-top: 50px;">
        <form class="form-horizontal m-t" id="editForm"  method="post">
        	<div class="form-group">
                <label class="col-sm-3 control-label" style="width:40%;">用户名：</label>
                <div class="col-sm-4" style="width:50%;">
                    <input id="loginId" name="loginId" type="text" class="form-control" value="${loginId }" style="width:50%;" readonly="readonly">
                </div>
            </div>
            <div class="form-group">
                <label class="col-sm-3 control-label" style="width:40%;">原密码：</label>
                <div class="col-sm-4" style="width:50%;">
                    <input id="oldPwd" name="oldPwd" type="password" class="form-control" style="width:50%;">
                </div>
            </div>
            <div class="form-group">
                <label class="col-sm-3 control-label" style="width:40%;">新密码：</label>
                <div class="col-sm-4" style="width:50%;">
                    <input  type="password" class="form-control" id="newPwd" name="newPwd"  style="width:50%;">
                </div>
            </div>
            <div class="form-group">
                <label class="col-sm-3 control-label" style="width:40%;">确认新密码：</label>
                <div class="col-sm-4" style="width:50%;">
                    <input  type="password" class="form-control" id="newPwdConfirm"name="newPwdConfirm" style="width:50%;">
                </div>
            </div>
            <div class="form-group" >
                <div class="col-sm-4 col-sm-offset-5" style="width:50%;">
                    <button class="btn btn-primary" type="submit">提交</button>
                    <button class="btn btn-primary" type="button" onclick="doLogin();" id="login">重新登录</button>
                </div>
            </div>
        </form>
    </div>
</body>
</html>