<%@ page language="java" contentType="text/html; charset=UTF-8"   pageEncoding="UTF-8"%>
<%@ include file="/views/common/taglibs.jsp" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<title>Demo Table</title>
<link rel="stylesheet" href="${basePath}/css/bootstrap.min.css?v=3.3.6">
<link rel="stylesheet" href="${basePath}/css/cncp/common.css">
<link rel="stylesheet" href="${basePath}/css/plugins/sweetalert/sweetalert.css">
<%@ include file="/views/common/meta.jsp" %>

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
});
function doSubmit(){
	$.ajax({
	   type: "POST",
	   url: "demo.do?method=saveUser",
	   data: $('#editForm').serialize(),
	   success: function(msg){
	     if(msg=='success'){
	    	 var index = parent.layer.getFrameIndex(window.name); 
	    	 parent.layer.close(index);  
	     }else{
	    	 sweetAlert("新增用户错误", msg, "error");
	     }
	   }
	});
}
</script>
</head>
<body style="overflow-x:hidden;">
	<div class="ibox-content ">
        <form class="form-horizontal m-t" id="editForm" novalidate="novalidate">
        	<input type="hidden" id="id" name="id" value="${user.id }">
            <div class="form-group">
                <label class="col-sm-3 control-label">登陆名：</label>
                <div class="col-sm-8" style="width:50%;">
                    <input id="loginId" name="loginId" type="text" class="form-control">
                </div>
            </div>
            <div class="form-group">
                <label class="col-sm-3 control-label">姓名：</label>
                <div class="col-sm-8" style="width:50%;">
                    <input  type="text" class="form-control" id="realName"name="realName" required>
                </div>
            </div>
            <div class="form-group">
                <label class="col-sm-3 control-label">所属部门：</label>
                <div class="col-sm-8" style="width:50%;">
                    <select class="form-control" id="institutionCode" name="institutionCode">	
					<option value="">默认选择</option>
					<c:forEach var="data" items="${orgList}">
						<option value="${data.orgCode }">${data.orgName }</option>
					</c:forEach>
				</select>
                </div>
            </div>
            <div class="form-group" >
                <label class="col-sm-3 control-label">说明：</label>
                <div class="col-sm-8" style="width:50%;">
                    <textarea id="remark" name="remark" class="form-control" required></textarea>
                </div>
            </div>
            <div class="form-group">
                <div class="col-sm-8 col-sm-offset-3">
                    <div class="checkbox">
                        <label>
                            <input type="checkbox" class="checkbox" id="isCollector" name="isCollector" value="1"> 是否市场管理员
                        </label>
                    </div>
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