<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/views/common/taglibs.jsp"%>
<html>
<head>
<title></title>
<link rel="stylesheet" type="text/css" href="${basePath}/css/style.css" />
<link rel="stylesheet" type="text/css" href="${basePath}/css/pop-up.css" />
<link rel="stylesheet" type="text/css" href="${basePath}/css/validate.css" />
<script type="text/javascript" src="${basePath}/js/jquery/jquery-1.9.1.js"></script>
<script type="text/javascript" src="${basePath}/js/jquery/jquery.form.js"></script>
<link rel="stylesheet" href="${basePath}/component/messageBox/myJsBox.css" type="text/css"/>
<script type="text/javascript" src="${basePath}/component/messageBox/myJsBox.js"></script>
<script type="text/javascript" src="${basePath}/js/oms/myJs.js"></script>
<script type="text/javascript" charset="UTF-8" >
jQuery(document).ready(function($) { 
    $("input[type='text']").each(  
          function(){  
              $(this).keypress( function(e) {  
                      var key = window.event ? e.keyCode : e.which;  
                      if(key.toString() == "13"){  
                      	  return false;  
                      }  
              });  
    	 }
    );  
});
function maxValue(val){ 
	var unPubIssCnt = $("#unPubCnt").val();
	if(val == ''){
		showWarn("Please fill in issues to publish！"); 
		$("#publishNumbers").val(unPubIssCnt);
	}else if(Number(val)>300){
		showWarn("Maximum 300 issues！");
		$("#publishNumbers").val(unPubIssCnt);
	}else if(Number(val)>Number(unPubIssCnt)){
		if(Number(unPubIssCnt)==0)
			showWarn("No pre-arranged issues exist！");
		else
			showWarn("Issues published cannot be greater than issues unpublished！");
		$("#publishNumbers").val(unPubIssCnt);
	}
}

function getUnPublishCount(gameCode){
	$().ajaxSubmit({
		type : 'POST',
		url : 'issueManagement.do?method=getUnPublishCount&gameCode='+gameCode,
		success : function(data) { 
			$("#publishNumbers").val(data);
			$("#unPubCnt").val(data);
		}
	});
}
function doSubmit() {
	$("#issuePublishForm").attr("action","issueManagement.do?method=submitPublish");
	button_off("okBtn");
	$("#issuePublishForm").submit();
}
</script>
</head>
<body>
	<form:form modelAttribute="issuePublishForm" id="issuePublishForm" method="post">
		<div class="pop-body">
        <table width="100%" border="0" cellspacing="0" cellpadding="0" style="height: 120px;">
	         <tr>
			    <td align="right" width="30%">Game Name：</td>
			    <td>
			    	<form:select path="gameCode" id="gameCode" class="select-normal" onchange="getUnPublishCount(this.value);">
						<c:forEach items="${games}" var="s">
							<form:option value="${s.gameCode}">${s.shortName}</form:option>
						</c:forEach>
					</form:select>
			    </td>
			    <td width="200px"><span></span></td>
			</tr>
		 	<tr>
			    <td align="right" width="30%">Issues to Publish：</td>
			    <td colspan="2"><input type="hidden" id="unPubCnt" name="unPubCnt" value="${issuePublishForm.publishNumber}"/>
			    	<form:input path="publishNumber" id="publishNumbers" class="text-normal" onblur="value=value.replace(/[^0-9]/g,'');maxValue(this.value);" cssStyle="width:80px;"/>
			    	<span id="publishNumbersTip" style="color:#CDC9C9">*Maximum issues to publish</span>
			    </td>
			</tr>
		 </table>
   	 </div>
   	 <div class="pop-footer">
        <span class="left"><input id="okBtn" type="button" value="Submit" onclick="doSubmit();" class="button-normal"></input></span>
        <span class="right"><input type="reset" value="Reset" class="button-normal"></input></span>
     </div>
	 </form:form>
</body>
</html>
