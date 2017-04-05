<%@ page language="java" contentType="text/html; charset=UTF-8"   pageEncoding="UTF-8"%>
<%@ include file="/views/common/taglibs.jsp" %>
<%@ include file="/views/common/meta.jsp" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<title>Withdraw</title>
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

 function initSelect(value){
	var url="capital.do?method=getDealerInfoByCode&dealerCode=" + value;
			$.ajax({
				url : url,
				dataType : "json",
				async : false,
				success : function(r){
				$("#dealerName").val(r.dealerName);
				$("#beforeAccountBalance").val(r.beforeAccountBalance);
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
		}, "提现金额必须是整数");
	  
     $("#editForm").validate({
    	rules:{
    		operAmount:{
				 required: true,
				 number:true,
				 maxlength:15,
				 nonnegative:"nonnegative"
			 },
			 remark:{
				 required: true,
				 maxlength:200
			}
    	},
    	onsubmit:true,
    	onfocusout:false,
    	onkeyup :false,
    	submitHandler: doSubmit
    }); 
});

 /* function doSubmit(){
	$.ajax({
	   type: "POST",
	   url: "withdraw.do?method=withdraw",
	   data: $('#editForm').serialize(),
	   success: function(msg){
		   
		   var fundNo = msg.substring(7);
		   var result = msg.substr(0,7);
	     if(result=='success'){
	    	 var a = parent.layer.open({
				  type: 2,
				  title: '提现成功',
				  maxmin: true,
				  shadeClose: true, //点击遮罩关闭层
				  area : ['800px' , '520px'],
				  content: 'withdraw.do?method=withdrawSuccess&fundNo='+fundNo,
				  end:function close(){
					 // layer.closeAll();
					  parent.layer.close(a);
				  }
			  });
	    	 
	     }else if(msg = -1){
	    	 sweetAlert("提现金额不能大于账户余额","error");
	     }
	     else{
	    	 sweetAlert("提现出现错误", msg, "error");
	     }
	     
	   }
	});
} */

</script>
</head>
<body style="overflow-x:hidden;">
	<div class="ibox-content ">
        <form action="withdraw.do?method=withdraw" method="POST" class="form-horizontal m-t" id="editForm" novalidate="novalidate">
        	<div class="form-group">
                <label class="col-sm-3 control-label">渠道编码：</label>
                <div class="col-sm-8" style="width:50%;">
                    <select class="form-control" id="dealerCode" name="dealerCode">	
					<c:forEach var="data" items="${usableDealerList}">
						<option value="${data.dealerCode }">${data.dealerCode }</option>
					</c:forEach>
				</select>
                </div>
            </div>
            <div class="form-group">
                <label class="col-sm-3 control-label">渠道商名称：</label>
                <div class="col-sm-8" style="width:50%;">
                    <input id="dealerName" name="dealerName" type="text" class="form-control" readonly="readonly">
                </div>
            </div>
            <div class="form-group">
                <label class="col-sm-3 control-label">当前账户余额：</label>
                <div class="col-sm-8" style="width:50%;">
                    <input  class="form-control" id="beforeAccountBalance"  name="beforeAccountBalance" readonly="readonly">
                </div>
            </div>
            <div class="form-group">
                <label class="col-sm-3 control-label">提现金额：</label>
                <div class="col-sm-8" style="width:50%;">
                    <input type="text" class="form-control" id="operAmount" name="operAmount" maxlength="15">
                </div>
            </div>
            
            <div class="form-group" >
                <label class="col-sm-3 control-label">备注：</label>
                <div class="col-sm-8" style="width:50%;">
                    <textarea id="remark" name="remark" class="form-control"></textarea>
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