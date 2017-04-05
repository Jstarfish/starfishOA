<%@ page language="java" contentType="text/html; charset=UTF-8"   pageEncoding="UTF-8"%>
<%@ include file="/views/common/taglibs.jsp" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<title>New Institution</title>
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
    		orgCode:{
				 required: true,
				 number:true,
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
				 digits: "Please input the two Numbers"                    
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
	    	 sweetAlert("New institution error", "institution exist", "error");
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
        	<input type="hidden" id="id" name="id" value="${user.id }">
            <div class="form-group">
                <label class="col-sm-3 control-label">Institution Code：</label>
                <div class="col-sm-8" style="width:50%;">
                    <input id="orgCode" name="orgCode" type="text" class="form-control"  maxlength="2">
                </div>
            </div>
            <div class="form-group">
                <label class="col-sm-3 control-label">Institution Name：</label>
                <div class="col-sm-8" style="width:50%;">
                    <input  type="text" class="form-control" id="orgName"name="orgName" required maxlength="50">
                </div>
            </div>
            <div class="form-group">
                <label class="col-sm-3 control-label">Head of Institution：</label>
                <div class="col-sm-8" style="width:50%;">
                    <select class="form-control" id="directorAdmin" name="directorAdmin" required>	
						<c:forEach var="data" items="${userList}">
							<option value="${data.id }">${data.realName }</option>
						</c:forEach>
					</select>
                </div>
            </div>
            <div class="form-group">
                <label class="col-sm-3 control-label">Contact Phone：</label>
                <div class="col-sm-8" style="width:50%;">
                    <input  type="text" class="form-control" id="phone"name="phone" required>
                </div>
            </div>
            <div class="form-group">
                <label class="col-sm-3 control-label">Number of Employees：</label>
                <div class="col-sm-8" style="width:50%;">
                    <input type="text" class="form-control" id="persons"name="persons" maxlength="5">
                </div>
            </div>
            <div class="form-group">
                <label class="col-sm-3 control-label">Address：</label>
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
                <label class="col-sm-3 control-label">Type of Institution：</label>
                <div class="col-sm-8" style="width:50%;">
                    <select class="form-control" id="orgType" name="orgType" required>	
						<option value="1">Company</option>
						<option value="2">Agent</option>
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