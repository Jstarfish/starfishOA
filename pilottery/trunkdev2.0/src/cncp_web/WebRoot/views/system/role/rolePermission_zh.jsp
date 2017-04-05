<%@ page language="java" contentType="text/html; charset=UTF-8"   pageEncoding="UTF-8"%>
<%@ include file="/views/common/taglibs.jsp" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<title>Demo Table</title>
<link rel="stylesheet" href="${basePath}/css/bootstrap.min.css?v=3.3.6">
<link rel="stylesheet" href="${basePath}/css/cncp/common.css">
<link rel="stylesheet" href="${basePath}/css/plugins/sweetalert/sweetalert.css">
<link rel="stylesheet" href="${basePath}/css/plugins/ztree/zTreeStyle.css">
<link rel="stylesheet" href="${basePath}/css/style.css">

<script src="${basePath}/js/jquery.min.js"></script>
<script src="${basePath}/js/bootstrap.min.js"></script>
<script src="${basePath}/js/plugins/sweetalert/sweetalert.min.js"></script>
<script src="${basePath}/js/plugins/ztree/jquery.ztree.all.min.js"></script>
<script src="${basePath}/js/cncp/common.js"></script>
<script type="text/javascript">
	var setting = {
		check: {
			enable: true
		},
		data: {
			simpleData: {
				enable: true
			},
			key:{
				name:"remark"
			}
		}
	};

	$(document).ready(function(){
		var treeObj ;
		$.ajax({
	            type: 'post',
	            url: 'role.do?method=getMenuTree&roleId=${role.roleId }',
	            dataType: "json", 
	            success: function (data) {
	            	treeObj = $.fn.zTree.init($("#treeview"), setting, data);
	        		treeObj.setting.check.chkboxType = {  "Y" : "ps", "N" : "ps" };
	            },
	            error: function (msg) {
	            	sweetAlert("菜单列表加载失败", msg, "error");
	            }
	      });
		 
		 
		 $("#saveBtn").bind("click",function(){
			var result=true;
			var privilegeId=""; 
			//验证树形控件选择中
			var nodes = treeObj.getCheckedNodes(true);
			//判断未选择时
		    if(nodes.length==0){
		    	sweetAlert("您必须选择一个权限", "", "error");
		   		return false;
		    }
			for (var i=0; i<nodes.length; i++) {
			    privilegeId+=nodes[i].id+",";
			}
				  
			privilegeId=privilegeId.substr(0,privilegeId.length-1);
		    $("#menuIds").val(privilegeId);
		    
		    //$('#roleForm').submit();
		    doSubmit();
		  });
	});
	
	function doSubmit(){
		$.ajax({
		   type: "POST",
		   url: "role.do?method=saveRolePermission",
		   data: $('#roleForm').serialize(),
		   success: function(msg){
		     if(msg=='success'){
		    	 var index = parent.layer.getFrameIndex(window.name); 
		    	 parent.layer.close(index);  
		     }else{
		    	 sweetAlert("保存角色权限错误", msg, "error");
		     }
		   }
		});
	}
</script>
</head>
<body style="margin: 15px;">
		<%-- <form class="form-horizontal m-t" id="editForm">
        	<input type="hidden" id="id" name="id" value="${role.roleId }">
             <div class="form-group">
                <label class="col-sm-3 control-label">角色名：</label>
                <div class="col-sm-8" style="width:50%;">
                    ${role.roleName }
                </div>
            </div>
            <div class="form-group" >
                <label class="col-sm-3 control-label">说明：</label>
                <div class="col-sm-8" style="width:50%;">
                  ${role.remark }
                </div>
            </div>
            <p class="navbar-text">菜单功能树</p>
		    <div class="ibox-content" style="border-width: 1px 1px;height:300px;">
				<ul id="treeview" class="ztree"></ul>
			</div>
		
             <div class="col-sm-4 col-sm-offset-3" style="width:50%;">
                 <button class="btn btn-primary" type="submit">提交</button>
             </div>
        </form> --%>
      <form action="" id="roleForm" method="post">
      		<input type="hidden" id="roleId" name="roleId" value="${role.roleId }">
      		<input type="hidden" id="menuIds" name="menuIds" value="">
      </form>
     <div class="row" style="padding-top: 7px;">
		   <label class="col-sm-3 control-label">角色名：</label>
           <div class="col-sm-8" style="width:50%;">
               ${role.remark }
           </div>
	 </div>
	 <div  class="row"  style="padding-top: 7px;">
			<label class="col-sm-3 control-label">说明：</label>
            <div class="col-sm-8" style="width:50%;">
                ${role.roleName }
            </div>
	 </div>
	 <div class="row">
		<div class="col-sm-11">
		    <div class="panel panel-success">
		        <div class="panel-heading">
		                              功能菜单
		        </div>
		        <div class="panel-body"  style="overflow-y:auto;height:300px;padding-top: 0px;">
		            <ul id="treeview" class="ztree"></ul>
		        </div>
		    </div>
		</div>
	</div>
	<div  class="row col-sm-11 col-sm-offset-5">
		<button class="btn btn-primary" id="saveBtn">提交</button>
	</div>
</body>
</html>