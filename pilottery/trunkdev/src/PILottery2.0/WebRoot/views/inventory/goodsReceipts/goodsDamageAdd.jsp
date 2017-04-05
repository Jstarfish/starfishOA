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
<script type="text/javascript" src="${basePath}/component/My97DatePicker/WdatePicker.js"></script>

    <script type="text/javascript" src="${basePath}/js/myJs.js"></script>
	<script type="text/javascript" src="${basePath}/js/jquery/jquery-1.9.1.js"></script>
	<script type="text/javascript" src="${basePath}/js/regexEnum.js"></script>
<script type="text/javascript" charset="UTF-8">


$(document).ready(function(){
	
	
	$("#okBtn").bind("click",function(){
		var result=true;
	
		 
		
	
		   if(result) {
			   button_off("okBtn");
		     $('#goodIssuesParamt').submit();	 
			 
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
function doClose(){
	window.parent.closeBox();
}
</script>


</head>
<body>
	<form action="goodsIssues.do?method=addDama" name="goodIssuesParamt" id="goodIssuesParamt" method="POST">
		<input type="hidden" name="sgrNO" id="${param.sgrNo}"/>
		<div class="pop-body">
			<table width="700" border="0" cellspacing="0" cellpadding="0" height="220px">
				
				   <tr>
						<td width="25%" align="right">Plan Code:</td>
						<td width="35%" align="center">
					       ${param.planCode }
						</td>
					   <td></td>
			   
			  </tr>
			    <tr>
						<td width="25%" align="right">Plan Name:</td>
						<td width="35%" align="center">
					  ${param.planName}
						</td>
					   <td></td>
			   
			  </tr>
				
				   <tr>
						<td width="25%" align="right">Batch:</td>
						<td width="35%" align="center">
					   ${param.batchNo}
					
						</td>
					   <td></td>
			   
			  </tr>
			  <tr>
						<td style="padding-top:20px; " colspan="3">Remarks:<br/>
                            <textarea name="remark" rows="5" class="edui-editor1"></textarea></td>
			   
			  </tr>

			</table>
		</div>
		<div class="pop-footer">
			<span class="left"><input id="okBtn" type="button"
				value="Submit"
				class="button-normal"></input></span> <span
				class="right"><input type="button"
				value="Cancel" onclick="doClose();"
				class="button-normal"></input></span>
		</div>
	</form>
</body>
</html>