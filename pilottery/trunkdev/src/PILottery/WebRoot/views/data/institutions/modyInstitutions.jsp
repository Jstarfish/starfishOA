<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8"%>
	<%@ include file="/views/common/taglibs.jsp"%>
<%@ include file="/views/common/meta.jsp" %>
<html>
<head>
<title>Edit Institution</title>
<link rel="stylesheet" type="text/css" href="${basePath}/css/style.css" />
<link rel="stylesheet" type="text/css" href="${basePath}/css/pop-up.css" />

<link rel="stylesheet" href="${basePath}/component/messageBox/myJsBox.css" type="text/css"/>
<link rel="stylesheet" type="text/css" href="${basePath}/css/validate.css" />
<link rel="stylesheet" href="${basePath}/css/zTreeStyle/zTreeStyle.css" type="text/css">


<script type="text/javascript" src="${basePath}/component/messageBox/myJsBox.js"></script>
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
		
		$("#okBtn").bind("click",function(){
			var result=true;
			  var areaCode=""; 
			  
			  if(!doCheck("orgCode",checkNotnull($("#orgCode").val()),"Can't be empty")){
				  result = false;
			  }
			  var org=$("#orgCode").val();
			  if(org.length==1){
				  doCheckmessage("orgCode",false,"Can't enter a character");
						  result = false;
			  }
			  //验证管理名称
	          if(!doCheck("orgName",checkNotnull($("#orgName").val()),"Can't be empty")){
	        	  result= false;
			  }
			  if(checkNotnull($("#orgName").val())){
				  if (!checkFormComm('modyinstitutionsForm')) {
						result = false;
					}
			  } 
			  //验证电话
			  if(!doCheck("phone",checkNotnull($("#phone").val()),"Can't be empty")){
				  result= false;
			  }
			  //验证人数
			 	 /* if(!doCheck("persons",checkNotnull($("#persons").val()),"Can't be empty")){
			 		result= false;
				  } */
			  
			 	
			  //验证地址
			 /*   if(!doCheck("address",checkNotnull($("#address").val()),"Can't be empty")){
				   result= false;
				  } */
			   if(checkNotnull($("#address").val())){
				   if (!checkFormComm('modyinstitutionsForm')) {
						result = false;
					}
			   }
			
			  //验证树形控件选择中
			  var nodes = treeObj.getCheckedNodes(true);
			  //判断未选择时
		      if(nodes.length==0){
		    	  showError('Choose one');
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

			   if(result) {
				   button_off("okBtn");
			     $('#modyinstitutionsForm').submit();	 
				  
			   }
			  
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
function doClose(){
	window.parent.closeBox();
}
</script>


</head>
<body>
	<form action="institutions.do?method=modyInstitutions" id="modyinstitutionsForm" method="POST">
		<input type="hidden" name="areaCode" id="areaCode">
		<input type="hidden" name="oldorgCode" id="oldorgCode" value="${infOrgs.orgCode}">
		<input type="hidden" name="superOrg" id="superOrg" value="00">

		<div class="pop-body">
			<table width="100%" border="0" cellspacing="0" cellpadding="0" style="padding-top: 0px;padding-bottom: 0px;">
				<tr>
					<td>
						<div>
							<table width="100%" border="0" cellspacing="0" cellpadding="0" style="padding-top: 10px;padding-bottom: 0px;">
								<tr>
									<td class="td" align="right" width="37%">Institution Code：</td>
									<td class="td" align="left" width="63%">
										<input name="orgCode" id="orgCode" type="text"  value="${infOrgs.orgCode }" readonly="readonly" class="text-big-noedit" maxLength="2" />
										<span id="orgCodeTip" class="tip_init">*</span>
									</td>

								</tr>
								<tr>
									<td class="td" align="right">Institution Name：</td>
									<td class="td" align="left"><input name="orgName" type="text" id="orgName"  isCheckSpecialChar="true" cMaxByteLength="500" value="${infOrgs.orgName}" readonly="readonly" class="text-big-noedit" />
										<span id="orgNameTip" class="tip_init">* 1~500 characters</span>
									</td>

								</tr>
								<tr>
									<td class="td" align="right">Head of Institution：</td>
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
									<td class="td" align="right">Contact Phone：</td>
									<td class="td" align="left">
										<input name="phone" id="phone" type="text" value="${infOrgs.phone}" class="text-big" maxlength="15"/>
										<span id="phoneTip" class="tip_init">*</span>
									</td>
								</tr>
								<tr>
									<td class="td" align="right">Number of Employees：</td>
									<td class="td" align="left">
										<input name="persons" id="persons" type="text" value="${infOrgs.persons}"
										maxLength="6" class="text-big" oninput="filterInput(this)"  />
										<span id="personsTip" class="tip_init">0~6 characters</span>
									</td>
								</tr>

								<tr>
									<td class="td" align="right">address：</td>
									<td class="td" align="left"><input name="address"
										id="address" type="text" value="${infOrgs.address }" isCheckSpecialChar="true" cMaxByteLength="500"
										class="text-big" /><span id="addressTip" class="tip_init">0~500 characters</span></td>
								</tr>

								<tr>
									<td class="td" align="right">Parent Institution：</td>
									<td class="td" align="left">
											<c:forEach items="${orgsList}" var="orgInfo">
												
													<c:if test="${orgInfo.orgCode=='00'}"><input name="superorgName" id="superorgName" type="text" value="${orgInfo.orgName}" readonly="readonly" class="text-big-noedit" /></c:if>
												
											</c:forEach>
										
										<span id="superOrgTip" class="tip_init"></span>
									</td>
								</tr> 

								<tr>
									<td class="td" align="right">Type of Institution：</td>
									<td class="td" align="left">
										<select name="orgType" class="select-big">
											<c:forEach var="item" items="${maporgType}">
												<option value="${item.key}"
													<c:if test="${infOrgs.orgType==item.key}">selected</c:if>>${item.value}</option>
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
								Administrative Area
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
					<input id="okBtn" type="button" value='Submit' class="button-normal"></input>
				</span> 
				<span class="right">			
					<input type="button" value="Cancel" onclick="doClose();" class="button-normal"></input>
				</span>
		</div>
	</form>
</body>
</html>