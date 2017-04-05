<%@ page language="java" contentType="text/html; charset=UTF-8"   pageEncoding="UTF-8"%>
<%@ include file="/views/common/taglibs.jsp" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<title>新增部门</title>
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
    	rules:{
    		orgCode:{
				 required: true,
				 digits:true,
				 maxlength:2,
				 minlength:2
			 },
			 persons:{
				 required:true,
				 digits:true,
				 min:0
			 }
		 },
		 messages:{  
			 orgCode:{  
				 digits: "只能输入两位数字"                    
             }
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
	   url: "institution.do?method=saveInstitution",
	   data: $('#editForm').serialize(),
	   success: function(msg){
	     if(msg=='success'){
	    	 var index = parent.layer.getFrameIndex(window.name); 
	    	 parent.layer.close(index);  
	     }else if(msg=='exist'){
	    	 sweetAlert("新增部门错误", "部门编码已存在", "error");
	     }else{
	    	 sweetAlert("新增部门错误", msg, "error");
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
                <label class="col-sm-3 control-label">部门编码：</label>
                <div class="col-sm-8" style="width:50%;">
                    <input id="orgCode" name="orgCode" type="text" class="form-control" maxlength="2"/>
                </div>
            </div>
            <div class="form-group">
                <label class="col-sm-3 control-label">部门名称：</label>
                <div class="col-sm-8" style="width:50%;">
                    <input  type="text" class="form-control" id="orgName"name="orgName" required maxlength="50">
                </div>
            </div>
            <div class="form-group">
                <label class="col-sm-3 control-label">负责人：</label>
                <div class="col-sm-8" style="width:50%;">
                    <select class="form-control" id="directorAdmin" name="directorAdmin" required>	
						<c:forEach var="data" items="${userList}">
							<option value="${data.id }">${data.realName }</option>
						</c:forEach>
					</select>
                </div>
            </div>
            <div class="form-group">
                <label class="col-sm-3 control-label">联系电话：</label>
                <div class="col-sm-8" style="width:50%;">
                    <input  type="text" class="form-control" id="phone"name="phone" required>
                </div>
            </div>
            <div class="form-group">
                <label class="col-sm-3 control-label">部门人数：</label>
                <div class="col-sm-8" style="width:50%;">
                    <input type="text" class="form-control" id="persons"name="persons" maxlength="5">
                </div>
            </div>
            <div class="form-group">
                <label class="col-sm-3 control-label">联系地址：</label>
                <div class="col-sm-8" style="width:50%;">
                    <textarea  type="text" class="form-control" id="address"name="address" required></textarea>
                </div>
            </div>
            <div class="form-group">
                <div class="col-sm-8" style="width:50%;">
                     <input  type="hidden" class="form-control" id="superOrg" name="superOrg" value="00" readonly="readonly">
                </div>
            </div>
            <div class="form-group">
                <label class="col-sm-3 control-label">部门类型：</label>
                <div class="col-sm-8" style="width:50%;">
                    <select class="form-control" id="orgType" name="orgType" required>	
						<option value="1">公司</option>
						<option value="2">代理</option>
					</select>
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