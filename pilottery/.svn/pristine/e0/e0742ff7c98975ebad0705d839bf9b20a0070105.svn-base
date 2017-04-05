<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/views/common/taglibs.jsp"%>
<html>
<head>
<title>Upgrade Plan</title>

<link rel="stylesheet" type="text/css" href="${basePath}/css/style.css" />
<link rel="stylesheet" type="text/css" href="${basePath}/css/pop-up.css" />
<link rel="stylesheet" type="text/css" href="${basePath}/css/validate.css" />
<link rel="stylesheet" href="${basePath}/component/messageBox/myJsBox.css" type="text/css"/>
<script type="text/javascript" src="${basePath}/js/jquery/jquery-1.9.1.js"></script>
<script type="text/javascript" src="${basePath}/component/messageBox/myJsBox.js"></script>
<script type="text/javascript" src="${basePath}/js/oms/myJs.js"></script>
<script type="text/javascript" src="${basePath}/component/My97DatePicker/WdatePicker.js"></script>

<script type="text/javascript" charset="UTF-8" > 

//true为有重复，false为不重复
function isRepeatPlanNameInEdit(){
	var flag = true;
	var oPlanName = '${updatePlan.planName}';
	var url = "updatePlan.do?method=ifRepeat&planName="+encodeURI($("#planName").val())+"&oPlanName="+encodeURI(oPlanName);
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

function repeatNameInEdit(){
	var flag = true;
	if (isRepeatPlanNameInEdit()) {//升级计划是否重复，返回true为重复
        $("#planNameTip").removeClass("onCorrect").addClass("onError");
		$("#planNameTip").text(existName);
		flag = false;
    } else {
        if ($("#planName").val()=='') {
        	$("#planNameTip").removeAttr("class");
        	$("#planNameTip").attr("class","onFocus");
        	$("#planNameTip").text(charactValid);
        } else {
	    	$("#planNameTip").removeClass("onError").addClass("onCorrect");
			$("#planNameTip").text(correct);
        }
    }
	return flag;
}

$(function(){
	//软件包版本赋值
	var softNo = '${updatePlan.softNo}';
	$("#softNo").val(softNo);
});

var charactValid = '* Not empty, Chinese, English, digit, and no special characters';//非空，中文，英文，数字，不允许输入符号
var select = '* Please select';

function doSubmit(){
	var result = true;

	if (!doCheck("planName",/^[A-Za-z0-9\u4e00-\u9fa5]+$/,charactValid)) {
		result = false;
	}

	if (!doCheck("softNo",/^\d{1}\.\d{1}\.\d{1,1}\d{1,1}$/,select)) {
		result = false;
	}
	
	if(result) {
		button_off("okBtn");
		$("#editPlan").submit();
	}
}
</script>

</head>
<body>
	<form action="updatePlan.do?method=editPlan" id="editPlan" method="post">
		<div class="pop-body">
			<table width="100%" border="0" cellspacing="0" cellpadding="0" >
				<tr>
				    <td align="right" width="25%">Plan：</td>
				    <td align="center" width="35%">	    	
				    	<input id="planName" name="planName" value="${updatePlan.planName}" class="text-big" type="text" maxlength="20"/><%--onchange="repeatNameInEdit()()" --%>
				    	<input type="hidden"  name="planId" value="${updatePlan.planId}">
				    </td>
				    <td width="*%"><span id="planNameTip" class="tip_init">* Not empty, Chinese, English, digit, and no special characters</span></td>
				  </tr>
		
				  <tr>
				    <td align="right">Version：</td>
				    <td align="center">
				    	<select id="softNo" name="softNo"  class="select-big" >
				    	 <option value="-1">Please select</option>					   
						   <c:forEach var="pver" items="${packvers}">
						   	<option value="${pver.packageVersion}">${pver.packageVersion}</option>
						   </c:forEach>	
						</select>
					</td>
					<td><span id="softNoTip" class="tip_init">*</span></td>
				  </tr>
				  <tr>
				    <td align="right">Upgrade Time：</td>
				    <td align="center">
				   		<!--<input id="updateDate" name="updateDate" value="${updatePlan.updateDate}" class="in" type="text"/>-->
				   		<input id="updateDate" name="updateDate" class="Wdate text-big" value="${updatePlan.updateDate}" onfocus="WdatePicker({dateFmt:'yyyy-MM-dd HH:mm:ss',readOnly:true})"/>
				    </td>
				    <td><span id="updateDateTip" class="tip_init"></span></td>
				  </tr>
			</table>
		</div>
		<div class="pop-footer">
            <span class="left"><input id="okBtn" type="button" value="Submit" onclick="doSubmit();" class="button-normal"></input></span>
            <span class="right"><input type="reset" value="Reset" class="button-normal"></input></span>
        </div>
	</form>
</body>
</html>
