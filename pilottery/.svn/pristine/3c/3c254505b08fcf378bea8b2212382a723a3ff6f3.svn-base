<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/views/common/taglibs.jsp"%>
<html>
<head>
<title>新增销售员</title>

<link rel="stylesheet" type="text/css" href="${basePath}/css/style.css" />
<link rel="stylesheet" type="text/css" href="${basePath}/css/pop-up.css" />
<link rel="stylesheet" type="text/css" href="${basePath}/css/validate.css" />
<script type="text/javascript" src="${basePath}/js/oms/myJs.js"></script>
<script type="text/javascript" src="${basePath}/js/jquery/jquery-1.9.1.js"></script>

<script type="text/javascript" charset="UTF-8" > 
var originalTellerCode = "";

function toReset(){
	$("#agencyCode, #tellername").val("");
	$("#tellerCode").val(originalTellerCode);
	$("#tellertype").val(1);
}

function addZero(val, id){
	var len = val.length;
	var tempLen = 6 - len;
	var preVal = "";
	if (len < 6) {
		for (var i=0; i<tempLen; i++) {
			preVal = '0' + preVal;
		}
	}
	return preVal;
}

String.prototype.trim = function()  
{  
    return this.replace(/(^\s*)|(\s*$)/g, "");  
}

var hint1 = '* 非空，数字，长度不超过10!';
var notExist = '* 此编码不存在或非可用状态，请输入有效编码!';
var hint2 = '* 非空，数字，长度不超过6';
var exist = '* 已存在此销售员编码，请输入其他编码!';
var hint3 = '* 非空，长度不超过20';
var hint6 = '* 请选择！';

function doSubmit(){
	var result = true;

	var agencyCode = '${agencyCode}';
	if (agencyCode=='' || agencyCode== undefined) {
		if (!doCheck("agencyCode",/^[0-9]\d{1,10}$/,hint1)) {
			result = false;
		} else {
			if (!doCheck("agencyCode",ifAgencyCodeExist(),notExist)) {
				result = false;
			}
		}
	}

	if (!doCheck("tellerCode",/^[0-9]\d{1,10}$/,hint2)) {
		result = false;
	} else {
		if (!doCheck("tellerCode",!isRepeatTellerNo(),exist)) {
			result = false;
		}
	}

	if (!doCheck("tellername",/^[a-zA-Z0-9\u4e00-\u9fa5]{1,20}$/,hint3)) {
		result = false;
	}

	if (!doCheck("tellertype",/^[^0]$/,hint6)) {
		result = false;
	}

	if(result) {
		button_off("okBtn");
		$("#addteller").submit();
	}
}

function ifAgencyCodeExist(){
	var flag = false;
	var url = "agency.do?method=ifAgencyCodeExist&agencyCode="+$("#agencyCode").val();
	$.ajax({
		url : url,
		dataType : "text",
		async : false,
		success : function(result){
			if (result==1) {
				var flag2 = ifAgencyCodeEnable();
				if (flag2==1) {
					flag = true;
				}
			}
		}
	});
	return flag;
}

function ifAgencyCodeEnable(){
	var flag = 0;
	var url = "agency.do?method=ifAgencyCodeEnable&agencyCode="+$("#agencyCode").val();
	$.ajax({
		url : url,
		dataType : "text",
		async : false,
		success : function(result){
			flag = result;
		}
	});
	return flag;
}

/**
 * 在一个销售站是否已存在将要添加的用户
 */
function isRepeatTellerNo(){
	var flag = false;
	var url = "teller.do?method=isRepeatTellerNo&tellerCode="+$("#tellerCode").val();
	$.ajax({
		url : url,
		dataType : "text",
		async : false,
		success : function(result){
			if (result==1)
				flag = true;
		}
	});
	return flag;
}
</script>
</head>
<body>
	<form action="teller.do?method=addTeller" id="addteller" method="POST">
		<div class="pop-body">
		    <table width="100%" border="0" cellspacing="0" cellpadding="0" >
		    	<tr>
		    		<td  align="right" width="25%">归属销售站：</td>				
					<td  align="center"  width="35%">
						<c:if test="${agencyCode!=null}">
							<input  type="text" class="text-big" style="border: none;" disabled="disabled" value="${agencyCode }"/>
							<input type="hidden" name = "agencyCode" value="${agencyCode }"/>
							<input type="hidden" name="flag" value="nonrefresh"/><!-- 不刷新 -->
						</c:if>
						<c:if test="${agencyCode==null}">
							<input name="agencyCode" class="text-big" id="agencyCode" maxlength="6" onkeyup="this.value=this.value.replace(/[^\d,]/g,'')"/>
							<input type="hidden" name="flag" value="refresh"/><!-- 提交后立马刷新 -->
						</c:if>
					</td>
					<td width="*%">
						<c:if test="${agencyCode==null}">
							<span id="agencyCodeTip" class="tip_init">* 非空，数字，长度不超过10!</span>
						</c:if>
					</td>
		    	</tr>
		    	<tr>
					<td align="right">销售员编码：</td>				
					<td align="center">
						<input class="text-big" name="tellerCode" id="tellerCode" value="" maxlength="10" onkeyup="this.value=this.value.replace(/[^\d,]/g,'')"/>
					</td>
					<td><span id="tellerCodeTip"></span></td>
				</tr>
				<tr>
					<td align="right">销售员名称：</td>
					<td align="center"><input name="tellerName" class="text-big" id="tellername" value="${teller.tellerName }" maxlength="20"/></td>
					<td><span id="tellernameTip" class="tip_init">* 非空，长度不超过20</span></td>
				</tr>
				<tr>
					<td align="right">销售员状态：</td>
					<td align="center">
						<select name="tellerType.value" class="select-big" id="tellertype">
							<c:forEach items="${tellerTypes}" var="teller">
								<option value="${teller.key}">${teller.value}</option>
							</c:forEach>
					     </select>
					</td>
					<td><span id="tellertypeTip" class="tip_init">*</span></td>
				</tr>
		    </table>
		</div>
		<div class="pop-footer">
            <span class="left"><input id="okBtn" type="button" value="提交" onclick="doSubmit();" class="button-normal"></input></span>
            <span class="right"><input type="button" value="重置" class="button-normal" onclick="toReset()"></input></span>
        </div>
	</form>
</body>
</html>