<%@ page language="java" contentType="text/html; charset=UTF-8"   pageEncoding="UTF-8"%>
<%@ include file="/views/common/taglibs.jsp" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<title>Edit Institution</title>
<link rel="stylesheet" href="${basePath}/css/bootstrap.min.css?v=3.3.6">
<link rel="stylesheet" href="${basePath}/css/cncp/common.css">
<link rel="stylesheet" href="${basePath}/css/plugins/sweetalert/sweetalert.css">

<script src="${basePath}/js/jquery.min.js"></script>
<script src="${basePath}/js/bootstrap.min.js"></script>
<script src="${basePath}/js/plugins/validate/jquery.validate.min.js"></script>
<script src="${basePath}/js/plugins/sweetalert/sweetalert.min.js"></script>
<script src="${basePath}/js/cncp/common.js"></script>
<script type="text/javascript">
$().ready(function () {
    $("#editForm").validate({
    	rules:{
			 persons:{
				 required:true,
				 digits:true,
				 min:0
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
	   url: "institution.do?method=updateOrg",
	   data: $('#editForm').serialize(),
	   success: function(msg){
	     if(msg=='success'){
	    	 var index = parent.layer.getFrameIndex(window.name); 
	    	 parent.layer.close(index);  
	     }else{
	    	 sweetAlert("New institution error", msg, "error");
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
                <label class="col-sm-3 control-label">Institution Code：</label>
                <div class="col-sm-8" style="width:50%;">
                    <input id="orgCode" name="orgCode" type="text" class="form-control" value="${orgInfo.orgCode }" readonly="readonly">
                </div>
            </div>
            <div class="form-group">
                <label class="col-sm-3 control-label">Institution Name：</label>
                <div class="col-sm-8" style="width:50%;">
                    <input  type="text" class="form-control" id="orgName" name="orgName" value="${orgInfo.orgName }" readonly="readonly">
                </div>
            </div>
            <div class="form-group">
                <label class="col-sm-3 control-label">Head of Institution：</label>
                <div class="col-sm-8" style="width:50%;">
                    <select class="form-control" id="directorAdmin" name="directorAdmin" required>	
						<c:forEach items="${userList}" var="user">
							<option value="${user.id}"
								<c:if test="${orgInfo.directorAdmin==user.id }">selected</c:if>>${user.realName}</option>
						</c:forEach>
					</select>
                </div>
            </div>
            <div class="form-group">
                <label class="col-sm-3 control-label">Contact Phone：</label>
                <div class="col-sm-8" style="width:50%;">
                    <input  type="text" class="form-control" id="phone"name="phone" value="${orgInfo.phone }" required>
                </div>
            </div>
            <div class="form-group">
                <label class="col-sm-3 control-label">Number of Employees：</label>
                <div class="col-sm-8" style="width:50%;">
                    <input  type="text" class="form-control" id="persons"name="persons" value="${orgInfo.persons }" maxlength="5">
                </div>
            </div>
            <div class="form-group">
                <label class="col-sm-3 control-label">Address：</label>
                <div class="col-sm-8" style="width:50%;">
                    <textarea  class="form-control" id="address"name="address" required>${orgInfo.address}</textarea>
                </div>
            </div>
            <div class="form-group">
                <label class="col-sm-3 control-label">Type of Institution：</label>
                <div class="col-sm-8" style="width:50%;">
                    <select class="form-control" id="orgType" name="orgType"  required>	
						<option value="1"<c:if test="${orgInfo.orgType==1}">selected='selected' </c:if>>Company</option>
						<option value="2"<c:if test="${orgInfo.orgType==2}">selected='selected' </c:if>>Agent</option>
					</select>
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