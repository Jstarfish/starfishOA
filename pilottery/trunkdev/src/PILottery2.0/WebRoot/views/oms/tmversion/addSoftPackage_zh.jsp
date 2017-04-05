<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/views/common/taglibs.jsp"%>
<html>
<head>
<title>新增软件版本 </title>
<link rel="stylesheet" type="text/css" href="${basePath}/css/style.css" />
<link rel="stylesheet" type="text/css" href="${basePath}/css/pop-up.css" />
<link rel="stylesheet" type="text/css" href="${basePath}/css/validate.css" />
<script type="text/javascript" src="${basePath}/js/oms/myJs.js"></script>
<script type="text/javascript" src="${basePath}/js/jquery/jquery-1.9.1.js"></script>

<script type="text/javascript" charset="UTF-8" > 

String.prototype.trim = function(){  
    return this.replace(/(^\s*)|(\s*$)/g, "");  
}
var correct = '恭喜你,你输对了';
var select = '请选择';
var nonEmpty = '* 非空，格式：1.0.23';
var errorLength = '不能为空，不要超过20字符';
var errorLength2 = '长度不正确，不要超过200字符，汉字占2到3字节';
var incorrect = '您输入的版本格式不正确';
var character = '* 限制200个字符';
var pleaseSel = '* 请选择';
function doSubmit(){
	var result = true;

	if (!doCheck("packageVersion",/^\d{1}\.\d{1}\.\d{1,1}\d{1,1}$/,nonEmpty)) {
		result = false;
	} else {
		if (!doCheck("packageVersion",ifExistSoftWareNo(),"在此终端类型下已存在此软件版本号，请重新输入")) {
			result = false;
		} else {
			var array = ifIsBiggerNo();
			if (!doCheck("packageVersion",array[0],"请重新输入比"+array[1]+"更高的版本号！")) {
				result = false;
			} else {
				if (!doCheck("packageVersion",!isFullNum(),"此终端机型号下已存在10个有效软件版本，请更换终端机型号！")) {
					result = false;
				}
			}
		}
	}

	if (!doCheck("packageDescription",/^(.){0,200}$/,character)) {
		result = false;
	}

	if(result) {
		button_off("okBtn");
		$("#addSoftVersion").submit();
	}
}


/**
 * 每一个终端机型号最多有10个有效软件版本
 */
function isFullNum(){
	var flag = false;
	var terminalType = $("#terminalType").val().trim();
	var url = "tmversionPackage.do?method=isFullNum&terminalType="+terminalType;
	if (terminalType!='') {
		$.ajax({
			url : url,
			dataType : "text",
			async : false,
			success : function(result){
				if (result==1)
					flag = true;
			}
		});
	}
	return flag;
}

/**
 * 是否已存在软件版本号
 * true为不存在，false为已存在
 */
function ifExistSoftWareNo(){
	var flag = true;
	var terminalType = $("#terminalType").val().trim();
	var packageVersion = $("#packageVersion").val().trim();
	if (terminalType!='' && packageVersion!='') {
		var url = "tmversionPackage.do?method=ifExist&terminalType="+terminalType+"&packageVersion="+packageVersion;
		$.ajax({
			url : url,
			dataType : "text",
			async : false,
			success : function(result){
				if (result==1)
					flag = false;
			}
		});
	}
	return flag;
}

/**
 * 输入的软件包版本号是否比数据表里的任何一个都大
 * true为大，false为不大
 */
function ifIsBiggerNo(){
	var flag = true;
	var terminalType = $("#terminalType").val().trim();
	var packageVersion = $("#packageVersion").val().trim();
	var maxPackVersion = "";
	if (terminalType!='' && packageVersion!='') {
		var url = "tmversionPackage.do?method=ifBiggerThanOther&terminalType="+terminalType+"&packageVersion="+packageVersion;
		$.ajax({
			url : url,
			async : false,
			dataType : "json",
			success : function(result){
				if (result.flag==1) {
					flag = false;
					maxPackVersion = result.maxPackVersion;
				}
			}
		});
	}
	var array = [flag,maxPackVersion];
	return array;
}


</script>
<style type="text/css">
.text-area {
border: 1px solid #40a7da;
background-color: #FFF;
width: 200px;
line-height: 24px;
}
</style>
</head>
<body>
	<form id="addSoftVersion" action="tmversionPackage.do?method=addSoftVerPackage" method="post" onkeydown="if(event.keyCode==13){return false;}">
		<div class="pop-body">
			<table width="100%" border="0" cellspacing="0" cellpadding="0" >
				<tr>
				    <td align="right" width="25%">软件版本号：</td>
				    <td align="center" width="35%">
				    	<input name="packageVersion" id="packageVersion" value="" class="text-big" type="text" maxlength="20" onkeyup="this.value=this.value.replace(/[^\d.]/g,'')"/>
				    </td>
				    <td width="*%">
				    	<span id="packageVersionTip" class="tip_init">* 非空，格式：1.0.23</span>
				    </td>
			  </tr>
			  <tr>
			    <td align="right">终端机型号：</td>
			    <td align="center">
					<select name="terminalType" class="select-big" id="terminalType">
						<c:forEach var="types" items="${terminalTypes}">
							<option value="${types.typeCode}">${types.typeName}</option>
						</c:forEach>
					</select>
				</td>
				<td><span id="terminalTypeTip" class="tip_init">*</span></td>
			  </tr>
			  <tr>
			    <td align="right">描述：</td>
			    <td align="center">
			    	<textarea id="packageDescription" rows="4" cols="30" name="packageDescription" class="text-area"></textarea>
			    </td>
			    <td><span id="packageDescriptionTip" class="tip_init">* 限制200个字符</span></td>
			  </tr>
			</table>
		</div>
		<div class="pop-footer">
            <span class="left"><input id="okBtn" type="button" value="提交" onclick="doSubmit();" class="button-normal"></input></span>
            <span class="right"><input type="reset" value="重置" class="button-normal"></input></span>
        </div>
	</form>
</body>
</html>
