<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/views/common/taglibs.jsp"%>
<html>
<head>
<title>New Plan </title>
<link type="text/css" rel="stylesheet" href="${basePath}/css/zTreeStyle.css">

<link rel="stylesheet" type="text/css" href="${basePath}/css/style.css" />
<link rel="stylesheet" type="text/css" href="${basePath}/css/pop-up.css" />
<link rel="stylesheet" type="text/css" href="${basePath}/css/validate.css" />
<link type="text/css" rel="stylesheet" href="${basePath}/css/jquery-county.css"/>
<link rel="stylesheet" href="${basePath}/component/messageBox/myJsBox.css" type="text/css"/>
<script type="text/javascript" src="${basePath}/js/jquery/jquery-1.9.1.js"></script>
<script type="text/javascript" src="${basePath}/component/messageBox/myJsBox.js"></script>
<script type="text/javascript" src="${basePath}/js/oms/myJs.js"></script>
<script type="text/javascript" src="${basePath}/component/My97DatePicker/WdatePicker.js"></script>
<script type="text/javascript" src="${basePath}/js/ztree/jquery.ztree.core-3.5.js"></script>
<script type="text/javascript" src="${basePath}/js/ztree/jquery.ztree.excheck-3.5.js"></script>

<script type="text/javascript" charset="UTF-8" > 
var hint = '* Please select a terminal or a institution!';//选择区域或输入终端机编码
var hint2 = '* Please select a terminal or a institution!';
var charactValid = '* Not empty, Chinese, English, digit, and no special characters';//非空，中文，英文，数字，不允许输入符号
var select = '* Please select';
var version = 'Select version';
var region = 'Institution';
function doSubmit(){

	/*if (isRepeatPlanName()) {//升级计划是否重复，返回true为重复
    $("#planNameTip").removeClass("onCorrect").addClass("onError");
	$("#planNameTip").text(existName);
	return;
}*/

	var result = true;

	if (!doCheck("planName",/^[A-Za-z0-9\u4e00-\u9fa5]+$/,charactValid)) {
		result = false;
	}

	if (!doCheck("termType",/^[^0]$/,select)) {
		result = false;
	}

	if (!doCheck("softNo",/^\d{1}\.\d{1}\.\d{1,1}\d{1,1}$/,select)) {
		result = false;
	}

	if($("#termCodes").val() != ''){
		if (!doCheck("termCodes",numFix(),"Terminal Code is 10-digit long!")) {
			result = false;
		}
	}else{
		var flag = ($("#areaCode").val()=='' && $("#termCodes").val()=='');
		if (!doCheck("termCodes",!flag,hint)) {
			result = false;
		} 
	}

	if(result) {
		button_off("okBtn");
		$("#addPlan").submit();
	}
}

//true为有重复，false为不重复
function isRepeatPlanName(){
	var flag = true;
	var url = "updatePlan.do?method=ifRepeat&planName="+encodeURI($("#planName").val());
	$.ajax({
		url : url,
		dataType : "text",
		async : false,
		success : function(result){
			if (result!=1)
				flag = false;
		}
	});
	return flag;
}

//输入的终端编码与终端型号是否匹配(true为匹配)
function isCorrectTerminalNo(){
	var flag = true;
	var termType = $("#termType").val().trim();
	var termCodes = $("#termCodes").val().trim();
	if (termCodes != '') {
		var termCodesArray = termCodes.split(",");
		var len = termCodesArray.length;
		for (var i=0; i<len; i++) {
			var url = "updatePlan.do?method=isCorrectTerminalNo&termType=" + termType + "&termNo=" + termCodesArray[i];
			$.ajax({
				url : url,
				dataType : "text",
				async : false,
				success : function(result){
					if (result==1)
						flag = true;
					else
						flag = false;
				}
			});

			if (!flag) {
				break;
			}
		}
	}
	
	return flag;
}

function repeatName(){
	if (isRepeatPlanName()) {//升级计划是否重复，返回true为重复
        $("#planNameTip").removeClass("onCorrect").addClass("onError");
		$("#planNameTip").text(existName);
		return;
    } else {
    	$("#planNameTip").removeClass("onError");
		$("#planNameTip").text("");
    }
}

//选择区域
function selectCounty(){
	$("#countyDiv").county({title:region, idTarget:'cityCode', nameTarget:'cityName', url:'sysUser.do?method=selectUserCity'}).show();
}

String.prototype.trim = function()  
{  
    return this.replace(/(^\s*)|(\s*$)/g, "");  
}
/**
 * 判断输入的终端机编码是否12位
 */
function numFix(){
	var flag = true;
	var termCodes = $("#termCodes").val().trim();
	if (termCodes != '') {
		var termCodesArray = termCodes.trim().split(",");
		var len = termCodesArray.length;
		for (var i=0; i<len; i++) {
			if (termCodesArray[i].trim().length!=10) {
				flag = false;
				break;
			}
		}
	}
	
	return flag;
}

$(function(){
	$("#planStatus").val(1);

	//异步更新软件包版本列表
	$("#termType").bind("change",function(){
			
		$.get("tmversionPackage.do?method=getpackvers",
			  {
			    termtype:$("#termType").val(),
				abc:123
			  },function(data,textStatus){						
				
				  var jsonObj = eval( data );
				
				  var len = jsonObj.datalist.length;	
				
				  var label;
				  var value;
				  var str;
				  
				  //删除原来下拉列表框的内容
				  $('#softNo').html("");
				  
				  str =  '<option value="-1">'+version+'</option>';				  
				  $('#softNo').append($(str)); 
				  for(var i =0;i<len;i++)
				  {
					  label = jsonObj.datalist[i].label;
					  value  = jsonObj.datalist[i].value.trim();
					  str =  '<option value="'+value+'">'+label +'</option>';
					  
					  $('#softNo').append($(str));  //增加子节点
			      }
				  
			  }
	    );		
	})
})
</script>
</head>
<body>
	<form:form action="updatePlan.do?method=addPlan" modelAttribute="planQueryForm" id="addPlan">
		<div class="pop-body">
			<table width="100%" border="0" cellspacing="0" cellpadding="0" >
				<tr>
				    <td align="right" width="25%">Plan：</td>
				    <td align="center" width="35%">
				    	<form:input path="updatePlan.planName" id="planName" class="text-big" maxlength="20"/><%--onchange="repeatName()" --%>
				    </td>
				    <td width="*%"><span id="planNameTip" class="tip_init">* Not empty, Chinese, English, digit, and no special characters</span></td>
				  </tr>
				  <tr>
				    <td align="right">Institution：</td>
				   <td align="center">
				    <select name="areaCode" class="select-big" id="areaCode">
					    <option value="">Please Select</option>
						<c:forEach items="${orgsList}" var="item">
							<option value="${item.areaCode}">${item.areaName }</option>
							<%-- <c:if test="${orgInfo.orgCode == editForm.user.institutionCode}">selected="selected"</c:if>>${orgInfo.orgName}</option> --%>
						</c:forEach>
					</select>
				    </td>
				  </tr>
				  <tr>
				    <td align="right">Upgrade Terminal：</td>
				    <td align="center">
				    	<form:input path="updatePlan.termCodes" id="termCodes" class="text-big" onkeyup="this.value=this.value.replace(/[^\d,]/g,'')"/>
				    </td>
				     <td><span id="termCodesTip" class="tip_init"> 10-digit integer, separated by comma for multiple terminals</span></td>
				  </tr>
				  <tr>
				    <td align="right">Machine Model：</td>
				    <td align="center">
						<form:select path="updatePlan.termType" id="termType" class="select-big">
							<form:option value="-1" selected="selected">Select model</form:option>
							<form:options items="${terminalTypes}" itemValue="typeCode" itemLabel="typeName"/>
						</form:select>
					</td>
					<td><span id="termTypeTip" class="tip_init">*</span></td>
				  </tr>
				  <tr>
				    <td align="right">Version：</td>
				    <td align="center">
						<select name="updatePlan.softNo" id="softNo" class="select-big">
							<option value="-1">Select version</option>
						</select>
					</td>
					<td><span id="softNoTip" class="tip_init">*</span><form:hidden path="updatePlan.planStatus" id="planStatus"/> </td>
				  </tr>
				  <tr>
				    <td align="right">Upgrade Time：</td>
				    <td align="center">
				    	<form:input id="updateDate" path="updatePlan.updateDate" class="Wdate text-big" onfocus="WdatePicker({dateFmt:'yyyy-MM-dd HH:mm:ss',readOnly:true})" />
				    </td>
				    <td><span id="updateDateTip" class="tip_init"></span></td>
				  </tr>
			</table>
		</div>
		<div class="pop-footer">
            <span class="left"><input id="okBtn" type="button" value="Submit" onclick="doSubmit();" class="button-normal"></input></span>
            <span class="right"><input type="reset" value="Reset" class="button-normal" onclick="document.getElementById('cityCode').value=''"></input></span>
        </div>
	</form:form>
</body>
</html>
