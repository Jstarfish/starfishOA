<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/views/common/taglibs.jsp"%>
<html>
<head>
<title>退票</title>


<link type="text/css" rel="stylesheet" href="${basePath}/views/oms/game-draw/css/myStyle.css" />
<script type="text/javascript" src="${basePath}/views/oms/game-draw/js/myJs.js"></script>
<link rel="stylesheet" href="${basePath}/component/messageBox/myJsBox.css" type="text/css"/>
<script type="text/javascript" src="${basePath}/component/messageBox/myJsBox_zh.js"></script>
<script type="text/javascript" src="${basePath}/js/jquery/jquery-1.9.1.js"></script>
<link rel="stylesheet" type="text/css" href="${basePath}/css/style.css" />


<style type="text/css">
.querymy_input{
    width:310px;
    height: 31px;
    border: 1px solid #40a7da;
    font-size: 18px;
    line-height: 30px;
    background-color: #FFF;
    font-family: "微软雅黑";
    padding-left: 3px;
}
</style>
<script type="text/javascript">
window.onload=function(){
	<c:if test="${not empty reservedSuccessMsg}">
		doChecquerykMsg("reqtsn",'${reservedSuccessMsg}');
	</c:if>
}

function doSubmit() {     
	//var bool = findObj("reqtsn").value!="";
	var result=true;
	if(!doCheck("reqtsn",checktsnNotnull(),'TSN不能为空')) {
		result=false;
	
    }

	 var  regex1 =/^[A-Za-z0-9\u4e00-\u9fa5]{1,}$/;
	if(checktsnNotnull()){
		if(!doCheck("reqtsn",regex1,'不能含有特殊字符!')) {
			result=false;
	
	    }
		if (!doCheck("reqtsn", /^[a-zA-Z0-9]{24}|[0-9]{16}$/, '请输入正确tsn')) {
            result = false;
        }
	}
	  var tsnval = $("#reqtsn").val();
	 	if(getStrlen(tsnval)!=16 && getStrlen(tsnval)!=24){
	 		result= false;
	 		doCheckMsg("reqtsn",false,'请输入正确tsn');
	 		
	 	}
    if(result){
    	switch_obj("nextBtn","waitBtn");
		refundForm.submit();
       }
    return result;

}
function checktsnNotnull(){
	if($("#reqtsn").val()==''){
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
function doCheckMsg(id,regex,msg) {

	if(!regex) {
		$("#"+id+"Tip").text("");
		$("#"+id+"Tip").text(msg);
		
		$("#"+id+"Tip").removeClass("tip_init").addClass("tip_error");
		
	} else {

			$("#"+id+"Tip").text("");

		$("#"+id+"Tip").text("*");
	  
	    $("#"+id+"Tip").removeClass("tip_error").addClass("tip_init");
	}

}


function doChecquerykMsg(id,msg) {
	$("#"+id+"Tip").text("");
	$("#"+id+"Tip").text(msg);
	$("#"+id+"Tip").removeClass("tip_init").addClass("tip_error");
}
</script>
</head>

<body>
<form:form modelAttribute="refundForm" action="refundquery.do?method=refund" method="post" id="refundForm" name="refundForm" onsubmit="return doSubmit();">
<div id="title">中心退票  </div>
<div id="mainDiv">
    <div class="jdt" style="background: url(views/oms/game-draw/img/zxtpbj-1.png) no-repeat left top;width:700px;">
    </div>
    <div class="xd" style="width:600px">
        <span class="zi">1.退票</span>
        <span>2.退票信息</span>
        <span>3.打印退票信息</span>
    </div>
    <div class="CPage">
        <table width="900" border="0" cellpadding="0" cellspacing="0">
            <tr>
                <td width="820" align="left" valign="middle">
                    <div class="tab">
                        <table border="0" cellpadding="0" cellspacing="0" height="100%" width="100%">
                            <tr>
                            	<td width="35%" class="lz"> 彩票TSN:</td>
                                <td width="35%">
                                    <form:input path="reqtsn" id="reqtsn" name="reqtsn"  value="" class="querymy_input" maxlength="24" />
                                </td>
                                <td width="*%"><span id="reqtsnTip" class="tip_init">*</span></td>
                            </tr>
                            <tr><td colspan="3"></td></tr>
                        </table>
                    </div>
                </td>
                <td align="right">
                    <img id="nextBtn"  onclick="javascript:doSubmit()" src="views/oms/game-draw/img/right-hover.png" alt="下一步"/>
                    <img id="waitBtn" style="display:none" src="views/oms/game-draw/img/wait.gif" height="60px" width="60px"/>
                </td>
            </tr>
            <tr height="60"></tr>
        </table>
    </div>

</div>

</form:form>
</body>
</html>