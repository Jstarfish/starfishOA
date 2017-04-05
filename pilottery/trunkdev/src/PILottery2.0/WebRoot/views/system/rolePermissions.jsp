<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8"%>
<%@ include file="/views/common/taglibs.jsp"%>
<%@ include file="/views/common/meta.jsp"%>
<html>
<head>
<title>Role Permissions</title>

<link rel="stylesheet" type="text/css" href="${basePath}/css/style.css" />
<link rel="stylesheet" type="text/css" href="${basePath}/css/pop-up.css" />
<link rel="stylesheet"	href="${basePath}/component/messageBox/myJsBox.css" type="text/css" />
<link rel="stylesheet" type="text/css"	href="${basePath}/css/validate.css" />
<link rel="stylesheet" href="${basePath}/css/zTreeStyle/zTreeStyle.css"	type="text/css">

<script type="text/javascript"	src="${basePath}/component/messageBox/myJsBox.js"></script>
<script type="text/javascript"	src="${basePath}/component/My97DatePicker/WdatePicker.js"></script>
<script type="text/javascript"  src="${basePath}/js/myJs.js"></script>
<script type="text/javascript"	src="${basePath}/js/jquery/jquery-1.9.1.js"></script>
<script type="text/javascript"	src="${basePath}/js/ztree/jquery.ztree.core-3.5.js"></script>
<script type="text/javascript"	src="${basePath}/js/ztree/jquery.ztree.excheck-3.5.js"></script>
<script type="text/javascript"  src="${basePath}/js/regexEnum.js"></script>
<script type="text/javascript" charset="UTF-8">
var setting = {
		check: {
			enable: true
		},
		data: {
			simpleData: {
				enable: true
			}
		}
	};
    var jsonStr='${jsonStr}';
   
	var zNodes =eval("("+jsonStr+")");
	
	var code;

	$(document).ready(function(){
		var treeObj =$.fn.zTree.init($("#privtree"), setting, zNodes);
		type= {  "Y" : "ps", "N" : "ps" };
		treeObj.setting.check.chkboxType = type;
		$("#okBtn").bind("click",function(){
			var result=true;
			  var privilegeId=""; 
			  //验证树形控件选择中
			  var nodes = treeObj.getCheckedNodes(true);
			  //判断未选择时
		      if(nodes.length==0){
		    	  showError('You must select an permissions');
				    return false;
		      }
			  for (var i=0; i<nodes.length; i++) {
		          privilegeId+=nodes[i].id+",";
		    }
			  
			privilegeId=privilegeId.substr(0,privilegeId.length-1);
			  $("#privilegeId").val(privilegeId);
			   if(result) {
				  button_off("okBtn");
				  $('#roleForm').submit();	 
			   }
		});
	});


function doClose(){
	window.parent.closeBox();
}
</script>
</head>
<body>
<form action="role.do?method=modyRolePermissions" id="roleForm" method="POST">
<input type="hidden" name="privilegeId" id="privilegeId" />
<input type="hidden" name="id" id="id" value="${role.id} " >
<div class="pop-body"> 
	<table width="100%" border="0" cellspacing="0" cellpadding="0" style="padding-top: 0px;padding-bottom: 0px;">
		<tr>
			<td>
				<div>
					<table width="100%" border="0" cellspacing="0" cellpadding="0" style="padding-top: 10px;padding-bottom: 0px;">
 						<tr>
							<td class="td" align="right" width="20%">Role Name:</td>
							<td class="td" align="left" width="60%">${role.name }</td>
							<td><span id="nameTip" class="tip_init"></span></td>
						</tr>
						
						<tr>
							<td class="td" align="right">Role Description:</td>
							<td class="td" align="left">${role.comment }</td>
							<td><span id="commentTip" class="tip_init"></span></td>
						</tr> 
					</table>
				</div>
			</td>
		</tr>
				
		<tr>
			<td>
				<div class="zTreeDemoBackground left" style="padding: 8px; width: 547px; ">
					<div style="font-size: 18px; background: #2aa1d9; color: #fff; padding: 8px; width: 758px;">
						Function Tree
					</div>
					<ul id="privtree" class="ztree"></ul>
				</div>
			</td>
		</tr>
	</table>
</div> 
	<div class="pop-footer">
		<span class="left"><input id="okBtn" type="button"	value="Submit" class="button-normal"></input></span>
		<span class="right"><input type="button" value="Cancel" onclick="doClose();" class="button-normal"></input></span>
	</div>
</form>
</body>
</html>