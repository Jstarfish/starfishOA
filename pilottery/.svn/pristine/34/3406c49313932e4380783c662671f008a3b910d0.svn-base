<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/views/common/taglibs.jsp"%>
<html>
<head>
<title>修改销售员</title>
<link rel="stylesheet" type="text/css" href="${basePath}/css/style.css" />
<link rel="stylesheet" type="text/css" href="${basePath}/css/pop-up.css" />
<link rel="stylesheet" type="text/css" href="${basePath}/css/validate.css" />
<script type="text/javascript" src="${basePath}/js/oms/myJs.js"></script>
<script type="text/javascript" src="${basePath}/js/jquery/jquery-1.9.1.js"></script>

<script type="text/javascript" charset="UTF-8" > 
jQuery(document).ready(function($) { 
	var tellerType = '${teller.tellerType.value}';
	$("#tellertype").val(tellerType);

	jQuery("#tellertype option[value=0]").remove();
});


var hint1 = '* 非空，长度不超过20';
var hint6 = '* 请选择！';
function doSubmit(){
	var result = true;

	if (!doCheck("tellername",/^[a-zA-Z0-9\u4e00-\u9fa5]{1,20}$/,hint1)) {
		result = false;
	}

	if (!doCheck("tellertype",/^[^0]$/,hint6)) {
		result = false;
	}

	if(result) {
		button_off("okBtn");
		$("#editTeller").submit();
	}
}
</script>
</head>
<body>
	<form action="teller.do?method=editTeller" id="editTeller" method="POST">
		<div class="pop-body">
			<table width="100%" border="0" cellspacing="0" cellpadding="0" >
				<tr>
					<td align="right" width="25%">归属销售站：</td>		
					<td align="center" width="35%"><input class="text-big" style="border: none;" disabled="disabled" type="text" value="${teller.agencyCode}"/></td>
					<td width="*%"></td>		
				</tr>
				<tr>
					<td align="right">销售员编码：</td>
					<td align="center"><input class="text-big" style="border: none;" disabled="disabled" type="text" value="${teller.tellerCode}"/></td>
					<td>
						<input type="hidden" name="tellerCode"  value="${teller.tellerCode}"/>
						<input type="hidden" name="tellerPassword" value="${teller.tellerPassword}">
						<input type="hidden" name="agencyCode" value="${teller.agencyCode}">
					</td>	
				</tr>
				<tr>
					<td align="right">销售员名称：</td>
					<td align="center"><input name="tellerName" class="text-big" id="tellername" value="${teller.tellerName }"/></td>
					<td><span id="tellernameTip" class="tip_init">* 非空，长度不超过20</span></td>
				</tr>
				<tr>
					<td align="right">销售员类型：</td>
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
            <span class="right"><input type="reset" value="重置" class="button-normal"></input></span>
        </div>
	</form>
</body>
</html>