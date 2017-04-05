<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/views/common/taglibs.jsp"%>
<html>
<head>
<title>New Terminal</title>

<link rel="stylesheet" type="text/css" href="${basePath}/css/style.css" />
<link rel="stylesheet" type="text/css" href="${basePath}/css/pop-up.css" />
<link rel="stylesheet" type="text/css" href="${basePath}/css/validate.css" />
<script type="text/javascript" src="${basePath}/js/oms/myJs.js"></script>
<script type="text/javascript" src="${basePath}/js/jquery/jquery-1.9.1.js"></script>

<style type="text/css">
</style>
<script type="text/javascript" charset="UTF-8" >

var hint1 = '* Not empty, digit, length not longer than 10!';//非空，数字，长度不超过10!
var hint2 = '* The code does not exist or invalid, please enter a valid code!';//此编码不存在，请输入有效编码!
var hint3 = '* Not empty, digit, length not longer than 2!';//非空，数字，长度不超过2!
var hint4 = '* Not empty, digit or English character, length not longer than 20!';//非空，数字或英文字符，长度不超过20!
var hint5 = '* MAC format: AA:BB:CC:DD:EE:FF';//请按AA:BB:CC:DD:EE:FF格式输入!
var hint6 = '* Please select!';//请选择！
var hint7 = '* MAC conflict exists, please re-enter!';//MAC地址冲突，请重新输入！
var select = '* Please select';
function doSubmit(){
	var result = true;

	var agencyCode = '${agencyCode}';
	if (agencyCode=='' || agencyCode== undefined) {
		if (!doCheck("agencyCode",/^[0-9]\d{1,10}$/,hint1)) {
			result = false;
		} else {
			if (!doCheck("agencyCode",ifAgencyCodeExist(),hint2)) {
				result = false;
			}
		}
	}

	if (!doCheck("afterTwoNum",/^[0-9]\d{1,2}$/,hint3)) {
		result = false;
	}

	if (!doCheck("uniquecode",/^[a-zA-Z0-9]{1,20}$/,hint4)) {
		result = false;
	}

	if (!doCheck("macaddress",/^[0-9A-Fa-f]{2,2}:[0-9A-Fa-f]{2,2}:[0-9A-Fa-f]{2,2}:[0-9A-Fa-f]{2,2}:[0-9A-Fa-f]{2,2}:[0-9A-Fa-f]{2,2}$/, hint5)) {
		result = false;
	}

	if (!doCheck("terminalType",/^[^0]$/,hint6)) {
		result = false;
	}

	if (!doCheck("terminalstatus",/^[^0]$/,hint6)) {
		result = false;
	}

	$("#terminalCode").val($("#preTenNum").text()+$("#afterTwoNum").val());
	if (!doCheck("softNo",/^\d{1}\.\d{1}\.\d{1,1}\d{1,1}$/,select)) {
		result = false;
	}
	

	if (!doCheck("softNo",/^\d{1}\.\d{1}\.\d{1,1}\d{1,1}$/,select)) {
		result = false;
	}
	if(result) {
		button_off("okBtn");
		$("#addterminal").submit();
	}
}

String.prototype.trim = function()
{
    return this.replace(/(^\s*)|(\s*$)/g, "");
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

function getTerminalCode(){
	var url = "terminal.do?method=getTerminalCode&areaType=5&agencyCode="+$("#agencyCode").val();
	$.ajax({
		url : url,
		dataType : "text",
		async : false,
		success : function(result){
			if (result!='' && result!=null) {
				var len = result.length;
				if (len > 2) {
					var preNum = result.substring(0,len-2);
					var aftNum = result.substring(len-2);
					$("#preTenNum").text(preNum);
					$("#afterTwoNum").val(aftNum).removeAttr("disabled").css("width","119px");
				}
			}
		}
	});
}

function judgeExist(){
	if (!ifAgencyCodeExist()) {
		$("#agencyCodeTip").removeClass("tip_init").addClass("tip_error");
		$("#agencyCodeTip").text(hint2);
		return;
	} else {
		$("#agencyCodeTip").removeClass("tip_error").addClass("tip_init");
		$("#agencyCodeTip").text("*");
		if ($("#agencyCode").val().length < 8) {
			var num = fixNum($("#agencyCode").val(),8);
			$("#agencyCode").val(num);
		}
		getTerminalCode();
	}
}

/**
 * 长度小于len的数前加len-num.length个数的0
 */
function fixNum(num,len){
	if (num.length<10) {
		var fixLen = len-num.length;
		var fixnum = "0";
		for (var i=1; i<fixLen; i++) {
			fixnum += "0";
		}
		num = fixnum + num;
	}
	return num;
}

/**
 * 判断是否MAC地址重复：返回ture为重复
 * 目前系统是在存储过程校验重复，这个函数未被使用
 */
function isRepeatedMacId(){
	var flag = false;
	var url = "terminal.do?method=isRepeatedMacId&macAddress="+$("#macaddress").val();
	$.ajax({
		url : url,
		dataType : "text",
		async : false,
		success : function(result){
			if (result==1)
				flag = true;
		}
	});

	if ($("#macaddress").val().trim()!='') {
		if (flag) {
			$("#macaddressTip").removeClass("onCorrect").addClass("onError");
			$("#macaddressTip").text(hint7);
		} else {
			$("#macaddressTip").removeClass("onError");
			$("#macaddressTip").text("");
		}
	}

	return flag;
}
</script>
<script type="text/javascript">
$(function(){
	var version = 'Select version';

	//异步更新软件包版本列表
	$("#terminalType").bind("change",function(){
			
		$.get("tmversionPackage.do?method=getpackvers",
			  {
			    termtype:$("#terminalType").val(),
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
	<form action="terminal.do?method=addTerminal" id="addterminal" method="POST">
		<div class="pop-body">
	        <table width="100%" border="0" cellspacing="0" cellpadding="0" >
	            <tr>
					<c:if test="${agencyCode!=null}">
						<td align="right" width="25%">Outlet：</td>
						<td align="center" width="35%">
							<input type="hidden"  name="agencyParent.code"  value="${agencyCode }">
							<input class="text-big" style="border: none;" disabled="disabled" type="text" value="${agencyCode }"/>
						</td>
					</c:if>
					<c:if test="${agencyCode==null}">
						<td align="right" width="25%">Outlet Code：</td>
						<td align="center" width="35%"><input name="agencyParent.code" class="text-big" id="agencyCode" maxlength="10" onkeyup="this.value=this.value.replace(/[^\d,]/g,'')" onchange="judgeExist();"/></td>
						<td width="*%">
							<span id="agencyCodeTip" class="tip_init">* Not empty, digit, length not longer than 10!</span>
							<input type="hidden" name="flag" value="refresh"/><!-- 提交后立马刷新 -->
						</td>
					</c:if>
				</tr>
				<tr>
					<c:if test="${agencyCode!=null}">
						<td align="right">Terminal Code：</td>
						<td align="center"><div style="margin-left: 20px;"><span id="preTenNum">${preRecomendId}</span><input class="text-big" type="text" id="afterTwoNum" value="${afRecomendId}" style="width:119px;margin-left: 0;" maxlength="2" onkeyup="this.value=this.value.replace(/[^\d,]/g,'')"/></div></td>
						<td><span id="afterTwoNumTip" class="tip_init"></span><input type="hidden" id="terminalCode" name="terminalCode"/></td>
					</c:if>
					<c:if test="${agencyCode==null}">
						<td align="right">Terminal Code：</td>
						<td align="center"><div><span id="preTenNum"></span><input class="text-big" type="text" id="afterTwoNum" value="" disabled="disabled" style="margin-left: 0;" maxlength="2" onkeyup="this.value=this.value.replace(/[^\d,]/g,'')"/></div></td>
						<td><span id="afterTwoNumTip" class="tip_init"></span><input type="hidden" id="terminalCode" name="terminalCode"/></td>
					</c:if>
				</tr>
				<tr>
					<td align="right">UID：</td>
					<td align="center"><input name="uniqueCode" class="text-big" id="uniquecode" type="text"/></td>
					<td><span id="uniquecodeTip" class="tip_init">* Not empty, digit or English character, length not longer than 20!</span></td>
				</tr>
				<tr>
					<td align="right">MAC Address：</td>
					<td align="center"><input name="macAddress" class="text-big" id="macaddress" type="text" /></td>
					<td><span id="macaddressTip" class="tip_init">* AA:BB:CC:DD:EE:FF</span></td>
				</tr>
				<tr>
					<td align="right">Machine Model：</td>
					<td align="center">
						<select name="terminalType" class="select-big" id="terminalType">
							<option value="-1" selected="selected">Select model</option>
							<c:forEach var="types" items="${terminalTypes}">
								<option value="${types.typeCode}">${types.typeName}</option>
							</c:forEach>
						</select>
					</td>
					<td><span id="terminalTypeTip" class="tip_init"></span></td>
				</tr>
				<tr>
					<td align="right">Terminal Status：</td>
					<td align="center">
						<select name="terminalStatus.value" class="select-big" id="terminalstatus" >
							<c:forEach items="${terminalStatusForm}" var="s">
								<option value="${s.key}">${s.value }</option>
							</c:forEach>
					     </select>
					</td>
					<td><span id="terminalstatusTip" class="tip_init"></span></td>
				</tr>
				<tr>
				    <td align="right">Version：</td>
				    <td align="center">
						<select name="softNo" id="softNo" class="select-big">
							<option value="-1">Select version</option>
						</select>
					</td>
					<td><span id="softNoTip" class="tip_init">*</span> </td>
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