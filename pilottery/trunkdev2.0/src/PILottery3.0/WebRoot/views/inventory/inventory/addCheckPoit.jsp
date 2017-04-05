<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8"%>
	<%@ include file="/views/common/taglibs.jsp"%>
<%@ include file="/views/common/meta.jsp" %>
<html>
<head>
<title>New Institution</title>

<link rel="stylesheet" type="text/css" href="${basePath}/css/style.css" />
<link rel="stylesheet" type="text/css" href="${basePath}/css/pop-up.css" />
<link rel="stylesheet" href="${basePath}/component/messageBox/myJsBox.css" type="text/css"/>
<link rel="stylesheet" type="text/css" href="${basePath}/css/validate.css" />
<script type="text/javascript" src="${basePath}/component/messageBox/myJsBox.js"></script>
<script type="text/javascript" src="${basePath}/js/myJs.js"></script>
<script type="text/javascript" src="${basePath}/js/jquery/jquery-1.9.1.js"></script>
<script type="text/javascript" src="${basePath}/js/regexEnum.js"></script>
<script type="text/javascript" charset="UTF-8">

$(document).ready(function(){
	var batchNo=$("#planCode").val();
	initBatchInfo(batchNo);
	
	var cpAdmins=$("#cpAdmins").val();
	cpOpert(cpAdmins);
	$('#planCode').change(function(){ 
		var batchNo=$("#planCode").val();
		initBatchInfo(batchNo);
		
		
	});
	
	$('#cpAdmins').change(function(){ 
		var cpAdmins=$("#cpAdmins").val();
		cpOpert(cpAdmins);
	});
	$("#okBtn").bind("click",function(){
		var result=true;
		    
		  if(!doCheck("cpName",checkNotnull($("#cpName").val()),"Can't be empty")){
			  result = false;
		  }	 
		  if(checkNotnull($("#cpName").val())){
			  if (!checkFormComm('checkPointParmat')) {
					result = false;
				}
		  }  

		  if(result) {
			   button_off("okBtn");
		     $('#checkPointParmat').submit();	 
			 
		   }
		  
	});
	
});
function initBatchInfo(val){
	if(val!=''){
		initSelect(val);
	}
	else{
		$("#batchNo").empty();
         
          $("#batchNo").append($("<option>").val('').text('--All--')); 
	}
}
function cpOpert(value){
	var attr= new Array();
	attr=value.split("@");
	$("#cpAdmin").val(attr[0]);
	$("#houseCode").val(attr[1]);
}
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
function initSelect(value){
	

	var url="inventory.do?method=getBatchList&planCode=" + value;
	  
	 
			$.ajax({
				url : url,
				dataType : "json",
				async : false,
				success : function(r){
			          $("#batchNo").empty();
			         
			          $("#batchNo").append($("<option>").val('').text('--All--')); 
			          for(var i = 0; i < r.length; i++) { 
	
                          var option = $("<option>").val(r[i].batchNo).text(r[i].batchNo);  
                          $("#batchNo").append(option);  
                      }
			}
			});
			
			
}
function doClose(){
	window.parent.closeBox();
}
</script>


</head>
<body>
	<form action="inventory.do?method=addCheckPoint"
		name="checkPointParmat" id="checkPointParmat" method="POST">
		<div class="pop-body">
			<input type="hidden" name="cpAdmin" id="cpAdmin" /> <input
				type="hidden" name="houseCode" id="houseCode" />

			<table width="100%" border="0" cellspacing="0" cellpadding="0">
				<tr>
					<td align="right" width="25%">Check Name :</td>
					<td align="left" width="30%"><input name="cpName"
						id="cpName" isCheckSpecialChar="true" cMaxByteLength="500" class="text-big" /></td>
					<td><span id="cpNameTip" class="tip_init">* 1~500 characters</span></td>

				</tr>

				<tr>
					<td width="25%" align="right">Checked By :</td>
					<td width="30%" align="left"><select name="cpAdmins"
						id="cpAdmins" class="select-big">
							<c:forEach items="${listuser}" var="user">
								<option value="${user.id}@${user.warehouseCode}">${user.realName}</option>
							</c:forEach>
					</select></td>
					<td><span id="cpAdminTip" class="tip_init">*</span></td>

				</tr>
				<tr>
					<td width="25%" align="right">Plan Name :</td>
					<td align="left" width="30%"><select name="planCode"
						id="planCode" class="select-big">
							<option value="">--All--</option>
							<c:forEach items="${listplan}" var="plan">
								<option value="${plan.planCode}">${plan.fullName}</option>
							</c:forEach>
					</select></td>
					<td><span id="planCodeTip" class="tip_init"></span></td>
				</tr>
				<tr>
					<td width="25%" align="right">Batch : </td>
					<td align="left" width="30%"><select name="batchNo"
						id="batchNo" class="select-big">
							<%--     <c:forEach items ="${listplan}"  var ="plan">
					         <option value="${plan.planCode}">${plan.fullName}</option>
					    </c:forEach> --%>
					</select></td>
					<td><span id="batchNoTip" class="tip_init"></span></td>
				</tr>
			</table>
		</div>
		<div class="pop-footer">
			<span class="left"><input id="okBtn" type="button"
				value="Submit" class="button-normal"></input></span> <span class="right"><input
				type="button" value="Cancel" onclick="doClose();"
				class="button-normal"></input></span>
		</div>
	</form>
</body>
</html>