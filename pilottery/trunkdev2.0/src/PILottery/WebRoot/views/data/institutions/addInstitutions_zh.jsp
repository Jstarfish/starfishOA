<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8"%>
	<%@ include file="/views/common/taglibs.jsp"%>
<%@ include file="/views/common/meta.jsp" %>
<html>
<head>
<title>新增部门</title>

<link rel="stylesheet" type="text/css" href="${basePath}/css/style.css" />
<link rel="stylesheet" type="text/css" href="${basePath}/css/pop-up.css" />

<link rel="stylesheet" href="${basePath}/component/messageBox/myJsBox.css" type="text/css"/>
<link rel="stylesheet" type="text/css" href="${basePath}/css/validate.css" />
<link rel="stylesheet" href="${basePath}/css/zTreeStyle/zTreeStyle.css" type="text/css">


<script type="text/javascript" src="${basePath}/component/messageBox/myJsBox_zh.js"></script>
<script type="text/javascript" src="${basePath}/component/My97DatePicker/WdatePicker.js"></script>

   <script type="text/javascript" src="${basePath}/js/myJs.js"></script>
	<script type="text/javascript" src="${basePath}/js/jquery/jquery-1.9.1.js"></script>
	<script type="text/javascript" src="${basePath}/js/ztree/jquery.ztree.core-3.5.js"></script>
	<script type="text/javascript" src="${basePath}/js/ztree/jquery.ztree.excheck-3.5.js"></script>
	<script type="text/javascript" src="${basePath}/js/regexEnum.js"></script>
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
		var treeObj =$.fn.zTree.init($("#refeuse"), setting, zNodes);
		type= { "Y" : "s", "N" : "s" };
		treeObj.setting.check.chkboxType = type;
		
		$("#okButton").bind("click",function(){
			var result=true;
			  var areaCode="";
			
			  if(!doCheck("orgCode",checkNotnull($("#orgCode").val()),"不能为空")){
				  result = false;
			  }
			  var org=$("#orgCode").val();
			  if(org.length==1){
				  doCheckmessage("orgCode",false,"不能输入字符");
						  result = false;
			  }
			  //验证管理名称
	          if(!doCheck("orgName",checkNotnull($("#orgName").val()),"不能为空")){
	        	  result = false;
			  }
			  if(checkNotnull($("#orgName").val())){
					if (!checkFormComm('institutionsForm')) {
						result = false;
					}
			  } 
			  //验证电话
			  if(!doCheck("phone",checkNotnull($("#phone").val()),"不能为空")){
				  result = false;
			  }
			  //验证人数
			 	/*  if(!doCheck("persons",checkNotnull($("#persons").val()),"Can't be empty")){
			 		result = false;
				  } */
			  
			 	
			  //验证地址
			  /*  if(!doCheck("address",checkNotnull($("#address").val()),"Can't be empty")){
				 
				   result = false;
				  } */

				
			  if(checkNotnull($("#address").val())){
				  if (!checkFormComm('institutionsForm')) {
						result = false;
					}
			  }
					var url="institutions.do?method=getAddOrgNameCount&orgName=" + encodeURI(encodeURI($("#orgName").val()));
					  
					$.ajax({
						url : url,
						dataType : "json",
						async : false,
						success : function(r){
						
					           if(r==true){
					        		
					        	   doCheckmessage("orgName",false,"部门名称已经存在");
										result = false;
					        		
								   
					           }
					}
					});
			 
			
			  //验证树形控件选择中
			  var nodes = treeObj.getCheckedNodes(true);
			  //判断未选择时
		      if(nodes.length==0){
		    	  showError('请选择一个区域');
				    return false;
		      
		      }
		      for (var i=0; i<nodes.length; i++) {
				     if(parseInt(nodes[i].id)<100){
				    	 areaCode+="000"+nodes[i].id+","; 
				     }
				 
		             if(100<parseInt(nodes[i].id) && parseInt(nodes[i].id)<1000){
		            	  areaCode+="0"+nodes[i].id+","; 
		             }
		             if(parseInt(nodes[i].id)>1000){
		            	  areaCode+=nodes[i].id+",";
		             }
		        
		    }
		     
			areaCode=areaCode.substr(0,areaCode.length-1);
			  $("#areaCode").val(areaCode);

			  
				setTimeout(function(){
					
					 if(result) {
						 $(this).attr("disabled","disabled");
						   button_off("okButton");
					     $('#institutionsForm').submit();	 
						  
					   }
				},100);  
		});
		
	});
//验证非空
function checkNotnull(value){
	if(value!=''){
		return true;
	}

	return false;
}
//验证字段长度
function checkleng(value,length){
	
	if(getStrlen(value)>length){
		return false;
	}
	return true;
}
//验证数字
function checknum(value){
    var reg=regexEnum.regex1;
    if(!reg.test(value)){  
       return false;
    }  
    return true;
}
function getStrlen(str){
    var realLength = 0, len = str.length, charCode = -1;
    for (var i = 0; i < len; i++) {
        charCode = str.charCodeAt(i);
        if (charCode >= 0 && charCode <= 128) realLength += 1;
        else realLength += 2;
    }
    return realLength;
}

function checkformat(val){
	var result=true;
	//var areaName=$("#areaName").val();
	var pattern = new RegExp("[`~!@$^&*()=|{}':;'\\[\\]<>/?~！@￥……&*（）——|{}【】；：”“'。，？]") ;
	if(pattern.exec(val)!=null){
		result=false;
	}
	return result;
	
}
function filterInput(obj) {
	var cursor = obj.selectionStart;
	obj.value = obj.value.replace(/[^\d]/g,'');
	obj.selectionStart = cursor;
	obj.selectionEnd = cursor;
}
function doCheckmessage(id,r,msg) {
    var result;
    var value = findObj(id).value;
    var tipObj = findObj(id+"Tip");

    result=r;

    if(!result) {
    	tipObj.innerText = msg;
    	tipObj.className="tip_error";
    } else {
    	tipObj.innerText="";
    	tipObj.innerText = "*";
        tipObj.className="tip_init";
    }
    return result;
}
function doClose(){
	window.parent.closeBox();
}
</script>


</head>
<body>
	<form action="institutions.do?method=addInstitutions" id="institutionsForm" method="POST">
		<input type="hidden" name="areaCode" id="areaCode">
		 <input type="hidden" name="superOrg" id="superOrg" value="00">
		<div class="pop-body">
			<table width="100%" border="0" cellspacing="0" cellpadding="0" style="padding-top: 0px;padding-bottom: 0px;">
				<tr>
					<td>
						<div>
							<table width="100%" border="0" cellspacing="0" cellpadding="0" style="padding-top: 10px;padding-bottom: 0px;">
								<tr>
									<td class="td" align="right" width="37%">部门编码：</td>
									<td class="td" align="left" width="63%">
										<input name="orgCode" id="orgCode" type="text" value="" class="text-big" maxLength="2" />
										<span id="orgCodeTip" class="tip_init">*</span>
									</td>

								</tr>
								<tr>
									<td class="td" align="right">部门名称：</td>
									<td class="td" align="left"><input name="orgName" type="text" id="orgName" isCheckSpecialChar="true" cMaxByteLength="500" value="" class="text-big" />
										<span id="orgNameTip" class="tip_init">*1~500 字符</span>
									</td>

								</tr>
								<tr>
									<td class="td" align="right">负责人：</td>
									<td class="td" align="left">
										<select name="directorAdmin" class="select-big">
											<c:forEach items="${userList}" var="user">
												<option value="${user.id}"
													<c:if test="${infOrgs.directorAdmin==user.id }">selected</c:if>>${user.realName}</option>
											</c:forEach>
										</select>
										<span id="directorAdminTip" class="tip_init">*</span>
									</td>
								</tr>
								<tr>
									<td class="td" align="right">联系电话：</td>
									<td class="td" align="left">
										<input name="phone" id="phone" type="text" value="${infOrgs.phone}" class="text-big" maxlength="15"/>
										<span id="phoneTip" class="tip_init">* 1~15 字符</span>
									</td>
								</tr>
								<tr>
									<td class="td" align="right">部门人数：</td>
									<td class="td" align="left">
										<input name="persons" id="persons" type="text" value="${infOrgs.persons}"
										maxLength="6" class="text-big" oninput="filterInput(this)" />
										<span id="personsTip" class="tip_init">0~6 字符</span>
									</td>
								</tr>

								<tr>
									<td class="td" align="right">地址：</td>
									<td class="td" align="left"><input name="address" id="address" isCheckSpecialChar="true" cMaxByteLength="500" type="text" value="${infOrgs.address }"class="text-big" />
									<span id="addressTip" class="tip_init">0~500 字符</span></td>
								</tr>

								 <tr>
									<td class="td" align="right">上一级部门：</td>
									<td class="td" align="left">
										
											<c:forEach items="${orgsList}" var="orgInfo">
												
													<c:if test="${orgInfo.orgCode=='00'}"><input name="superorgName" id="superorgName" type="text" value="${orgInfo.orgName}" readonly="readonly" class="text-big-noedit" /></c:if>
												
											</c:forEach>
										
										
									</td>
								</tr> 

								<tr>
									<td class="td" align="right">部门类型：</td>
									<td class="td" align="left">
										<select name="orgType" class="select-big">
											<c:forEach var="item" items="${maporgType}">
												<option value="${item.key}"
													<c:if test="${orgInfo.orgType==item.key}">selected</c:if>>${item.value}</option>
											</c:forEach>
										</select>
										<span id="orgTypeTip" class="tip_init">*</span>
									</td>
								</tr>
							</table>
						</div>
					</td>
				</tr>
				<tr>
					<td>
						<div class="zTreeDemoBackground left"
							style="padding: 8px; width: 547px; overflow: no;">
							<div style="font-size: 18px; background: #2aa1d9; color: #fff; padding: 8px; width: 547px;">
								行政区域
							</div>
							<ul id="refeuse" class="ztree">
							</ul>
						</div>
					</td>
				</tr>
			</table>
		</div>
		
		<div class="pop-footer">
			<span class="left">
				<input id="okButton" type="button" value='提交' class="button-normal"></input>
			</span> 
			<span class="right">			
				<input type="button" value="取消" onclick="doClose();" class="button-normal"></input>
			</span>
		</div>
	</form>
</body>
</html>