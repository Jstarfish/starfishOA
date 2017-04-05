<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/views/common/taglibs.jsp"%>
<html>
<head>
<title>New Version </title>
<link rel="stylesheet" type="text/css" href="${basePath}/css/style.css" />
<link rel="stylesheet" type="text/css" href="${basePath}/css/pop-up.css" />
<link rel="stylesheet" type="text/css" href="${basePath}/css/validate.css" />
<script type="text/javascript" src="${basePath}/js/oms/myJs.js"></script>
<script type="text/javascript" src="${basePath}/js/jquery/jquery-1.9.1.js"></script>

<script type="text/javascript" charset="UTF-8" > 

String.prototype.trim = function(){  
    return this.replace(/(^\s*)|(\s*$)/g, "");  
}
var correct = 'Congratulations, you have entered correctly';
var select = 'Please select';
var nonEmpty = '* Non empty, format：1.0.23';
var errorLength = 'Not empty, not more than 20 characters';
var errorLength2 = 'No more than 200 bytes';
var incorrect = 'Incorrect version format';
var character = '* Maximum 200 characters';
var pleaseSel = '* Please select';
function doSubmit(){
	var result = true;

	if (!doCheck("packageVersion",/^\d{1}\.\d{1}\.\d{1,1}\d{1,1}$/,nonEmpty)) {
		result = false;
	} else {
		if (!doCheck("packageVersion",ifExistSoftWareNo(),"The version exists under this machine model, please re-enter")) {
			result = false;
		} else {
			var array = ifIsBiggerNo();
			if (!doCheck("packageVersion",array[0],"Please enter a version greater than"+array[1]+"!")) {
				result = false;
			} else {
				if (!doCheck("packageVersion",!isFullNum(),"More than 10 enabled versions under this machine model, please modify your machine model!")) {
					result = false;
				}
			}
		}
	}

	/* if (!doCheck("packageDescription",/^(.){0,200}$/,character)) {
		result = false;
	} */

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
				    <td align="right" width="25%">Version：</td>
				    <td align="center" width="35%">
				    	<input name="packageVersion" id="packageVersion" value="" class="text-big" type="text" maxlength="20" onkeyup="this.value=this.value.replace(/[^\d.]/g,'')"/>
				    </td>
				    <td width="*%">
				    	<span id="packageVersionTip" class="tip_init">* Non empty, format：1.0.23</span>
				    </td>
			  </tr>
			  <tr>
			    <td align="right">Machine：</td>
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
			    <td align="right">Description：</td>
			    <td align="center">
			    	<textarea id="packageDescription" rows="4" cols="30" name="packageDescription" class="text-area"></textarea>
			    </td>
			    <td><span id="packageDescriptionTip" class="tip_init">&nbsp;&nbsp;Maximum 200 characters</span></td>
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
