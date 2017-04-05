<%@ page language="java" contentType="text/html; charset=UTF-8"   pageEncoding="UTF-8"%>
<%@ include file="/views/common/taglibs.jsp" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<title>Demo Table</title>
<link rel="stylesheet" href="${basePath}/css/bootstrap.min.css?v=3.3.6">
<link rel="stylesheet" href="${basePath}/css/cncp/common.css">
<link rel="stylesheet" href="${basePath}/css/plugins/bootstrap-select/css/bootstrap-select.min.css">
<link rel="stylesheet" href="${basePath}/css/plugins/sweetalert/sweetalert.css">


<script src="${basePath}/js/jquery.min.js"></script>
<script src="${basePath}/js/bootstrap.min.js"></script>
<script src="${basePath}/js/plugins/validate/jquery.validate.min.js"></script>
<script src="${basePath}/js/plugins/sweetalert/sweetalert.min.js"></script>
<script src="${basePath}/js/plugins/bootstrap-select/js/bootstrap-select.min.js"></script>
<script src="${basePath}/js/plugins/bootstrap-select/js/i18n/defaults-en_US.min.js"></script>
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
	    	 sweetAlert("New user error", "User exist", "error");
	     }else{
	    	 sweetAlert("New user error", msg, "error");
	     }
	   }
	});
}
</script>
</head>
<body style="overflow-y:auto;margin: 15px;">
	<div class="ibox-content ">
        <form class="form-horizontal m-t" id="editForm" novalidate="novalidate">
            <div class="form-group">
                <label class="col-sm-3 control-label">User Name：</label>
                <div class="col-sm-8" style="width:50%;">
                    <input id="loginId" name="loginId" type="text" class="form-control" required>
                </div>
            </div>
            <div class="form-group">
                <label class="col-sm-3 control-label">Real Name：</label>
                <div class="col-sm-8" style="width:50%;">
                    <input  type="text" class="form-control" id="realName"name="realName" required>
                </div>
            </div>
            <div class="form-group">
            	<label class="col-sm-3 control-label">Gender：</label>
            	<div class="col-sm-8 "> 
					<label class="checkbox-inline">
						<input type="radio" name="gender" value="1" checked>Male
					</label>
					<label class="checkbox-inline">
						<input type="radio" name="gender" value="2">Female
					</label>
				</div>
            </div>
            <div class="form-group">
                <label class="col-sm-3 control-label">Institution：</label>
                <div class="col-sm-8" style="width:50%;">
                    <select class="form-control" id="orgCode" name="orgCode" required>	
						<option value="">Please select</option>
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
                <label class="col-sm-3 control-label">Role：</label>
                <div class="col-sm-11" style="width:50%;">
                    <select id="roleId" name="roleId" class="selectpicker show-tick form-control" multiple data-live-search="false">	
						<c:forEach var="data" items="${roleList}">
							<option value="${data.roleId }">${data.roleName }</option>
						</c:forEach>
					</select>
                </div>
            </div>
            
            
            <div class="form-group">
                <label class="col-sm-3 control-label">Contact Phone：</label>
                <div class="col-sm-8" style="width:50%;">
                    <input  type="text" class="form-control" id="phone" name="phone" required>
                </div>
            </div>
            <div class="form-group">
                <label class="col-sm-3 control-label">Contact Address：</label>
                <div class="col-sm-8" style="width:50%;">
                    <input  type="text" class="form-control" id="address" name="address" required>
                </div>
            </div>
            <div class="form-group" >
                <label class="col-sm-3 control-label">Remark：</label>
                <div class="col-sm-8" style="width:50%;">
                    <textarea id="remark" name="remark" class="form-control"></textarea>
                </div>
            </div>
            <div class="form-group" >
                <div class="col-sm-4 col-sm-offset-3" style="width:50%;">
                    <button class="btn btn-primary" type="submit">Submit</button>
                </div>
            </div>
        </form>
    </div>
</body>
</html>