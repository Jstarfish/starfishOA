<%@ page language="java" contentType="text/html; charset=UTF-8"   pageEncoding="UTF-8"%>
<%@ include file="/views/common/taglibs.jsp" %>
<%@ include file="/views/common/meta.jsp" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<title>Edit Dealer</title>
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
	   url: "dealer.do?method=updateDealer",
	   data: $('#editForm').serialize(),
	   success: function(msg){
	     if(msg=='success'){
	    	 var index = parent.layer.getFrameIndex(window.name); 
	    	 parent.layer.close(index);  
	     }else{
	    	 sweetAlert("Edit dealer error", msg, "error");
	     }
	   }
	});
}
</script>
</head>
<body style="overflow-x:hidden;">
	<div class="ibox-content ">
        <form class="form-horizontal m-t" id="editForm" novalidate="novalidate">
            <div class="form-group">
                <label class="col-sm-3 control-label">Dealer Code：</label>
                <div class="col-sm-8" style="width:50%;">
                    <input id="dealerCode" name="dealerCode" type="text" class="form-control"
                    value="${dealer.dealerCode }" readonly="readonly">
                </div>
            </div>
            <div class="form-group">
                <label class="col-sm-3 control-label">Dealer Name：</label>
                <div class="col-sm-8" style="width:50%;">
                    <input  type="text" class="form-control" id="dealerName" name="dealerName"
                    value="${dealer.dealerName }" maxlength="100" required>
                </div>
            </div>
            <div class="form-group">
                <label class="col-sm-3 control-label">Contact Name：</label>
                <div class="col-sm-8" style="width:50%;">
                    <input  type="text" class="form-control" id="dealerContact" name="dealerContact"
                    value="${dealer.dealerContact }" maxlength="100" required>
                </div>
            </div>
            <div class="form-group">
                <label class="col-sm-3 control-label">Contact Phone：</label>
                <div class="col-sm-8" style="width:50%;">
                    <input  type="text" class="form-control" id="dealerPhone" name="dealerPhone"
                    value="${dealer.dealerPhone }" maxlength="15" required>
                </div>
            </div>
            <div class="form-group">
                <label class="col-sm-3 control-label">Email：</label>
                <div class="col-sm-8" style="width:50%;">
                    <input  type="text" class="form-control" id="dealerMail" name="dealerMail"
                    value="${dealer.dealerMail }" maxlength="50" required>
                </div>
            </div>
             <div class="form-group" >
                <label class="col-sm-3 control-label">Message Address：</label>
                <div class="col-sm-8" style="width:50%;">
                    <textarea id="msgUrl" name="msgUrl" class="form-control" maxlength="30" required>${dealer.msgUrl }</textarea>
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