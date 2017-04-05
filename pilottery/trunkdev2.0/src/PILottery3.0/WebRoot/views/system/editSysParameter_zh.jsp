<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8"%>
<%@ include file="/views/common/taglibs.jsp"%>
<html>
<head>
<title>编辑角色</title>
<%@ include file="/views/common/meta.jsp"%>
<link rel="stylesheet" type="text/css" href="${basePath}/css/style.css" />
<link rel="stylesheet" type="text/css" href="${basePath}/css/pop-up.css" />
<link rel="stylesheet" type="text/css" href="${basePath}/css/validate.css" />
<link rel="stylesheet" href="${basePath}/component/messageBox/myJsBox_zh.css" type="text/css" />
<script type="text/javascript" src="${basePath}/component/messageBox/myJsBox_zh.js"></script>
<script type="text/javascript" src="${basePath}/js/jquery/jquery-1.9.1.js"></script>
<script type="text/javascript" src="${basePath}/js/myJs_zh.js"></script>
<script type="text/javascript" src="${basePath}/js/oms/city-list.js"></script>

<script type="text/javascript">
	function updateParameter() {
		button_off("okBtn");
		$("#sysParameter").submit();
	}

	function doClose(){
		window.parent.closeBox();
	}
</script>
</head>
<body>
		<form  id="sysParameter" name="sysParameter" method="post" action="sysParameter.do?method=updateSysParameter">
		<input type="hidden" name="id" value="${sysParameter.id}">
		<div class="pop-body">
			<table width="100%" border="0" cellspacing="0" cellpadding="0">
				<tr>
					<td align="right" width="30%">参数描述：</td>
					<td align="center" width="35%"><textarea id="desc" name="desc"  class="text-big-noedit" readonly="readonly" style="height:112px;width: 198px;">${sysParameter.desc}</textarea></td>
					<td><span id="descTip" class="tip_init"></span></td>
				</tr>
				<tr>
					<td align="right">参数值：</td>
					<td align="center"><input id="value" name="value" value="${sysParameter.value}" class="text-big" cols="36" rows="6" maxlength="502"  isCheckSpecialChar="true" cMaxByteLength="500"></td>
					<td><span id=""value"Tip" class="tip_init"></span></td>
				</tr>
			</table>
		</div>
		<div class="pop-footer">
			<span class="left"><input id="okBtn" type="button"
				value='提交' onclick="updateParameter()" class="button-normal"></input>
			</span> 
			<span class="right"><input type="button" value="取消" onclick="doClose();"
				class="button-normal"></input>
			</span>
		</div>
		</form>
</body>
</html>