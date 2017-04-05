<%@ page language="java" contentType="text/html; charset=UTF-8"   pageEncoding="UTF-8"%>
<%@ include file="/views/common/taglibs.jsp" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<title>Demo Table</title>
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
    $("#editForm").validate({
    	onsubmit:true,
    	onfocusout:false,
    	onkeyup :false,
    	submitHandler: doSubmit
    });
    $("#orgCode").val('${user.orgCode}');
    $("#gender").val('${user.gender}');
});
function doSubmit(){
	$.ajax({
	   type: "POST",
	   url: "role.do?method=updateRole",
	   data: $('#editForm').serialize(),
	   success: function(msg){
	     if(msg=='success'){
	    	 var index = parent.layer.getFrameIndex(window.name); 
	    	 parent.layer.close(index);  
	     }else{
	    	 sweetAlert("修改角色错误", msg, "error");
	     }
	   }
	});
}
</script>
</head>
<body style="overflow-y:auto;margin: 15px;">
	<div class="ibox-content">
        <form class="form-horizontal m-t" id="editForm" novalidate="novalidate">
        	<input type="hidden" id="roleId" name="roleId" value="${role.roleId }">
             <div class="form-group">
                <label class="col-sm-3 control-label">角色名：</label>
                <div class="col-sm-8" style="width:50%;">
                    <input  type="text" class="form-control" id="roleName"name="roleName" value="${role.roleName }" maxlength="50" required>
                </div>
            </div>
            <div class="form-group" >
                <label class="col-sm-3 control-label">说明：</label>
                <div class="col-sm-8" style="width:50%;">
                    <textarea id="remark" name="remark" class="form-control" maxlength="500" required>${role.remark }</textarea>
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