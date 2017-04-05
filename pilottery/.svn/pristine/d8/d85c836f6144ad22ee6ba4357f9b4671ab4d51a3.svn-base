<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/views/common/taglibs.jsp"%>
<html>
<head>
<title>Edit Terminal</title>

<link rel="stylesheet" type="text/css" href="${basePath}/css/style.css" />
<link rel="stylesheet" type="text/css" href="${basePath}/css/pop-up.css" />
<link rel="stylesheet" type="text/css" href="${basePath}/css/validate.css" />
<script type="text/javascript" src="${basePath}/js/oms/myJs.js"></script>
<script type="text/javascript" src="${basePath}/js/jquery/jquery-1.9.1.js"></script>

<script type="text/javascript" charset="UTF-8" >
var hint4 = '* Not empty, digit or English character, length not longer than 20!';//非空，数字或英文字符，长度不超过20!
var hint5 = '* MAC format: AA:BB:CC:DD:EE:FF';//请按AA:BB:CC:DD:EE:FF格式输入!
var hint6 = '* Please select!';//请选择！
function doSubmit(){
	var result = true;

	if (!doCheck("uniquecode",/^[a-zA-Z0-9]{1,20}$/,hint4)) {
		result = false;
	}

	if (!doCheck("terminalType",/^[^0]$/,hint6)) {
		result = false;
	}

	if (!doCheck("macaddress",/^[0-9A-Fa-f]{2,2}:[0-9A-Fa-f]{2,2}:[0-9A-Fa-f]{2,2}:[0-9A-Fa-f]{2,2}:[0-9A-Fa-f]{2,2}:[0-9A-Fa-f]{2,2}$/, hint5)) {
		result = false;
	}

	if(result) {
		button_off("okBtn");
		$("#editTerminal").submit();
	}
}
$(function(){
	$.get("terminal.do?method=terminaltypes",
		{
			abc:123
		},function(data,textStatus){
			var jsonObj = eval( data );
			var len = jsonObj.parentlist.length;
			var label;
			var value;
			var str;
			//删除原来下拉列表框的内容
			$('#terminalType').html('');
			/*$options = $('#terminalType').children();
			for(var i=0;i<$options.length;i++){
				$options[i].remove();
			}*/
			var sel =  $('#terminalTypeHiden').val();
			for(var i =0;i<len;i++){
				label = jsonObj.parentlist[i].name;
				value  = jsonObj.parentlist[i].code;
				if( sel == value)
					str =  '<option value="'+value+'" selected="selected">'+label +'</option>';
				else
					str =  '<option value="'+value+'">'+label +'</option>';
				$('#terminalType').append($(str));  //增加子节点
			}
		}
	);

});
</script>
</head>
<body>
	<form action="terminal.do?method=editTerminal" id="editTerminal" method="POST">
		<div class="pop-body">
			<table width="100%" border="0" cellspacing="0" cellpadding="0" >
				<tr>
					<td align="right" width="25%">Outlet：</td>
					<td align="center" width="35%"><input class="text-big" style="border: none;" disabled="disabled" type="text" value="${terminal.agencyName }"/></td>
					<td width="*%"><input type="hidden" name="agencyCode" value="${terminal.agencyCode }"/></td>
				</tr>
				<tr>
					<td align="right">Terminal Code：</td>
					<td align="center"><input class="text-big" style="border: none;" disabled="disabled" type="text" value="${terminal.terminalCodeToChar}"/></td>
					<td><input type="hidden" name="terminalCode" value="${terminal.terminalCode }"/></td>
				</tr>
				<tr>
					<td align="right">UID：</td>
					<td align="center"><input name="uniqueCode" class="text-big" id="uniquecode" value="${terminal.uniqueCode }"/></td>
					<td><span id="uniquecodeTip" class="tip_init">* Not empty, digit or English character, length not longer than 20!</span><input type="hidden" value="${terminal.terminalType}" id="terminalTypeHiden"/></td>
				</tr>
				<tr>
					<td align="right">MAC Address：</td>
					<td align="center"><input name="macAddress" class="text-big" id="macaddress" value="${terminal.macAddress }"/></td>
					<td><span id="macaddressTip" class="tip_init">* AA:BB:CC:DD:EE:FF</span></td>
				</tr>
				<tr>
					<td align="right">Machine Model：</td>
					<td align="center">
						<select name="terminalType" class="select-big" id="terminalType">
							<option value="1" label="选择终端型号"/>
						</select>
					</td>
					<td><span id="terminalTypeTip" class="tip_init"></span></td>
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
