<%@ page language="java" contentType="text/html; charset=UTF-8"   pageEncoding="UTF-8"%>
<%@ include file="/views/common/taglibs.jsp" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<%@ include file="/views/common/meta.jsp" %>
<title>Add Dealer</title>
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
    		dealerPhone:{
				 required: true,
				 number:true
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
	   url: "dealer.do?method=addDealer",
	   data: $('#editForm').serialize(),
	   success: function(msg){
	     if(msg=='success'){
	    	 var index = parent.layer.getFrameIndex(window.name); 
	    	 parent.layer.close(index);  
	     }else if(msg='exist'){
	    	 sweetAlert("New dealer error", "Dealer exist", "error");
	     }else{
	    	 sweetAlert("New dealer error", msg, "error");
	     }
	   }
	});
}
</script>
</head>
<body style="overflow-y:auto">
	<div class="ibox-content ">
        <form class="form-horizontal m-t" id="editForm" novalidate="novalidate">
            <div class="form-group">
                <label class="col-sm-3 control-label">Dealer Code：</label>
                <div class="col-sm-8" style="width:50%;">
                    <input id="dealerCode" name="dealerCode" type="text" class="form-control" maxlength="4" minlength="4" required range="1000,9999">
                </div>
            </div>
            <div class="form-group">
                <label class="col-sm-3 control-label">Dealer Name：</label>
                <div class="col-sm-8" style="width:50%;">
                    <input  type="text" class="form-control" id="dealerName"name="dealerName" maxlength="20" required>
                </div>
            </div>
            <div class="form-group">
                <label class="col-sm-3 control-label">Contact name：</label>
                <div class="col-sm-8" style="width:50%;">
                    <input  type="text" class="form-control" id="dealerContact"name="dealerContact" maxlength="30" required>
                </div>
            </div>
            <div class="form-group">
                <label class="col-sm-3 control-label">Contact Phone：</label>
                <div class="col-sm-8" style="width:50%;">
                    <input  type="text" class="form-control" id="dealerPhone"name="dealerPhone" number maxlength="15" required>
                </div>
            </div>
            <div class="form-group">
                <label class="col-sm-3 control-label">Email：</label>
                <div class="col-sm-8" style="width:50%;">
                    <input  type="text" class="form-control" id="dealerMail"name="dealerMail" maxlength="50" required>
                </div>
            </div>
            <div class="form-group" >
                <label class="col-sm-3 control-label">Message Address：</label>
                <div class="col-sm-8" style="width:50%;">
                    <textarea id="msgUrl" name="msgUrl" class="form-control" maxlength="30" required></textarea>
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