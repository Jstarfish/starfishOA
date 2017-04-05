<%@ page language="java" contentType="text/html; charset=UTF-8"   pageEncoding="UTF-8"%>
<%@ include file="/views/common/taglibs.jsp" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<title>新增用户</title>
<link rel="stylesheet" href="${basePath}/css/bootstrap.min.css?v=3.3.6">
<link rel="stylesheet" href="${basePath}/css/cncp/common.css">
<link rel="stylesheet" href="${basePath}/css/plugins/bootstrap-select/css/bootstrap-select.min.css">
<link rel="stylesheet" href="${basePath}/css/plugins/sweetalert/sweetalert.css">

<script src="${basePath}/js/jquery.min.js"></script>
<script src="${basePath}/js/bootstrap.min.js"></script>
<script src="${basePath}/js/plugins/validate/jquery.validate.min.js"></script>
<script src="${basePath}/js/plugins/validate/messages_zh.min.js"></script>
<script src="${basePath}/js/plugins/sweetalert/sweetalert.min.js"></script>
<script src="${basePath}/js/plugins/bootstrap-select/js/bootstrap-select.min.js"></script>
<script src="${basePath}/js/plugins/bootstrap-select/js/i18n/defaults-zh_CN.min.js"></script>
<script src="${basePath}/js/cncp/common.js"></script>
<script type="text/javascript">
$().ready(function () {
    $("#editForm").validate({
    	rules:{
    		phone:{
				 required: true,
				 number:true,
				 maxlength:15,
			 },
    	},
    	onsubmit:true,
    	onfocusout:false,
    	onkeyup :false,
    	submitHandler: doSubmit
    });
});
function doSubmit(){
	$.ajax({
	   type: "POST",
	   url: "user.do?method=saveUser",
	   data: $('#editForm').serialize(),
	   success: function(msg){
	     if(msg=='success'){
	    	 var index = parent.layer.getFrameIndex(window.name); 
	    	 parent.layer.close(index);  
	     }else if(msg=='exist'){
	    	 sweetAlert("新增用户错误", "用户已存在", "error");
	     }else{
	    	 sweetAlert("新增用户错误", msg, "error");
	     }
	   }
	});
}
</script>
</head>
<body style="overflow-y:auto;margin: 15px;">
	<div class="ibox-content ">
        <form class="form-horizontal m-t" id="editForm" novalidate="novalidate">
        	<input type="hidden" id="id" name="id" value="${user.id }">
            <div class="form-group">
                <label class="col-sm-3 control-label">登录名：</label>
                <div class="col-sm-8" style="width:50%;">
                    <input id="loginId" name="loginId" type="text" class="form-control" required>
                </div>
            </div>
            <div class="form-group">
                <label class="col-sm-3 control-label">姓名：</label>
                <div class="col-sm-8" style="width:50%;">
                    <input  type="text" class="form-control" id="realName"name="realName" required>
                </div>
            </div>
            <div class="form-group">
            	<label class="col-sm-3 control-label">性别：</label>
            	<div class="col-sm-8 "> 
					<label class="checkbox-inline">
						<input type="radio" name="gender" value="1"  checked="checked"> 男
					</label>
					<label class="checkbox-inline">
						<input type="radio" name="gender" value="2">女
					</label>
				</div>
            </div>
            <div class="form-group">
                <label class="col-sm-3 control-label">所属部门：</label>
                <div class="col-sm-8" style="width:50%;">
                    <select class="form-control" id="orgCode" name="orgCode" required>	
						<option value="">请选择</option>
						<c:forEach var="data" items="${orgList}">
							<option value="${data.orgCode }">${data.orgName }</option>
						</c:forEach>
					</select>
                </div>
            </div>
            
            <div class="form-group">
                <label class="col-sm-3 control-label"></label>
                <div class="col-sm-8" style="width:50%;">
                </div>
            </div>
            
            <div class="form-group">
                <label class="col-sm-3 control-label">角色：</label>
                <div class="col-sm-8" style="width:50%;">
                    <select id="roleId" name="roleId" class="selectpicker show-tick form-control" multiple>	
						<c:forEach var="data" items="${roleList}">
							<option value="${data.roleId }">${data.roleName }</option>
						</c:forEach>
					</select>
                </div>
            </div>
            
            <div class="form-group">
                <label class="col-sm-3 control-label">联系电话：</label>
                <div class="col-sm-8" style="width:50%;">
                    <input  type="text" class="form-control" id="phone" name="phone" required>
                </div>
            </div>
            <div class="form-group">
                <label class="col-sm-3 control-label">联系地址：</label>
                <div class="col-sm-8" style="width:50%;">
                    <input  type="text" class="form-control" id="address" name="address" required>
                </div>
            </div>
            <div class="form-group" >
                <label class="col-sm-3 control-label">备注：</label>
                <div class="col-sm-8" style="width:50%;">
                    <textarea id="remark" name="remark" class="form-control"></textarea>
                </div>
            </div>
            <div class="form-group" >
                <div class="col-sm-4 col-sm-offset-3" style="width:50%;">
                    <button class="btn btn-primary" type="submit">提交</button>
                </div>
            </div>
        </form>
    </div>
</body>
</html>