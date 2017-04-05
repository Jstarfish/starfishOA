<%@ page language="java" contentType="text/html; charset=UTF-8"   pageEncoding="UTF-8"%>
<%@ include file="/views/common/taglibs.jsp" %>
<%@ include file="/views/common/meta.jsp" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<title>Top Up</title>
<link rel="stylesheet" href="${basePath}/css/bootstrap.min.css?v=3.3.6">
<link rel="stylesheet" href="${basePath}/css/cncp/common.css">
<link rel="stylesheet" href="${basePath}/css/plugins/sweetalert/sweetalert.css">

<script src="${basePath}/js/jquery.min.js"></script>
<script src="${basePath}/js/bootstrap.min.js"></script>
<script src="${basePath}/js/plugins/validate/jquery.validate.min.js"></script>
<script src="${basePath}/js/plugins/sweetalert/sweetalert.min.js"></script>
<script src="${basePath}/js/cncp/common.js"></script>
<script type="text/javascript">

 function initSelect(value){
	var url="capital.do?method=getDealerInfoByCode&dealerCode=" + value;
			$.ajax({
				url : url,
				dataType : "json",
				async : false,
				success : function(r){
				$("#dealerName").val(r.dealerName);
			}
			});
} 


 
$().ready(function () {
	var val=$('#dealerCode').val();
	initSelect(val);
	  $("#dealerCode").change(function() { 
		  var val=$('#dealerCode').val();
			initSelect(val);
	  });
	  
	  jQuery.validator.addMethod("nonnegative", function(value, element) {   
		    var nonnegative = /^([1-9]\d*)$/;
		    return this.optional(element) || (nonnegative.test(value));
		}, "The amount must be an integer");
	  
	  //校验格式
	  $("#editForm").validate({
		  submitHandler: function(form){   
	             form.submit();   //提交表单   
	         }, 
		 rules:{
			 operAmount:{
				 required: true,
				 number:true,
				 nonnegative:"nonnegative",
				 maxlength:15,
			 },
			 remark:{
				 required: true,
				 maxlength:200
			}
		 } 
	  });
});

</script>
</head>
<body style="overflow-x:hidden;">
	<div class="ibox-content ">
        <form action="capital.do?method=topup" method="POST" class="form-horizontal m-t" id="editForm" novalidate="novalidate">
        	<div class="form-group">
                <label class="col-sm-3 control-label">Dealer Code：</label>
                <div class="col-sm-8" style="width:50%;">
                    <select class="form-control" id="dealerCode" name="dealerCode">	
					<c:forEach var="data" items="${usableDealerList}">
						<option value="${data.dealerCode }">${data.dealerCode }</option>
					</c:forEach>
				</select>
                </div>
            </div>
            <div class="form-group">
                <label class="col-sm-3 control-label">Dealer Name：</label>
                <div class="col-sm-8" style="width:50%;">
                    <input id="dealerName" name="dealerName" type="text" class="form-control" readonly="readonly">
                </div>
            </div>
            <div class="form-group">
                <label class="col-sm-3 control-label">Top Up Amount：</label>
                <div class="col-sm-8" style="width:50%;">
                    <input type="text" class="form-control" id="operAmount" name="operAmount">
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