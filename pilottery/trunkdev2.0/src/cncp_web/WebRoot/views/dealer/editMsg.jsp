<%@ page language="java" contentType="text/html; charset=UTF-8"   pageEncoding="UTF-8"%>
<%@ include file="/views/common/taglibs.jsp" %>
<%@ include file="/views/common/meta.jsp" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<title>Edit Msg</title>
<link rel="stylesheet" href="${basePath}/css/bootstrap.min.css?v=3.3.6">
<link rel="stylesheet" href="${basePath}/css/cncp/common.css">
<link rel="stylesheet" href="${basePath}/css/plugins/sweetalert/sweetalert.css">

<script src="${basePath}/js/jquery.min.js"></script>
<script src="${basePath}/js/bootstrap.min.js"></script>
<script src="${basePath}/js/plugins/validate/jquery.validate.min.js"></script>
<script src="${basePath}/js/plugins/sweetalert/sweetalert.min.js"></script>
<script src="${basePath}/js/cncp/common.js"></script>
<style type="text/css">
.form-horizontal .form-group {
     margin-right: -2px; 
     margin-left: 10px; 
}
	.form-group {
	margin-top: 20px;
    margin-right: -2px;
    margin-left: 10px;
    margin-bottom: 40px;
}
textarea.form-control {
    height: 100px;
    width: 350px;
}

button {
    overflow: visible;
    margin-left: 300px;
}
</style>
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
	   url: "dealer.do?method=updateMsg",
	   data: $('#editForm').serialize(),
	   success: function(msg){
	     if(msg=='success'){
	    	 var index = parent.layer.getFrameIndex(window.name); 
	    	 parent.layer.close(index);  
	     }else{
	    	 sweetAlert("Security information access error", msg, "error");
	     }
	   }
	});
} 
</script>
</head>
<body style="overflow-x:hidden;">
	<div class="ibox-content ">
        <form class="form-horizontal m-t" id="editForm" novalidate="novalidate">
        <input type="hidden" value="${security.dealerCode }" name="dealerCode">
             <div class="form-group" >
                <label class="col-sm-3 control-label">public key：</label>
                <div class="col-sm-8" style="width:50%;">
                    <textarea id="publicKey" name="publicKey" class="form-control" required>${security.publicKey }</textarea>
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