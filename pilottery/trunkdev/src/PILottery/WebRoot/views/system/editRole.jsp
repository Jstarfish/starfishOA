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
<link rel="stylesheet" href="${basePath}/component/messageBox/myJsBox.css" type="text/css" />
<script type="text/javascript" src="${basePath}/component/messageBox/myJsBox.js"></script>
<script type="text/javascript" src="${basePath}/js/jquery/jquery-1.9.1.js"></script>
<script type="text/javascript" src="${basePath}/js/myJs.js"></script>
<script type="text/javascript" src="${basePath}/js/oms/city-list.js"></script>

<script type="text/javascript">
	function updateRole() {
		var result = true;
		if (!checkFormComm('roleForm')) {
			result = false;
		}
		
		else{
			if (!doCheck("roleName", /.+$/, "Can not empty")) {
				result = false;
			}
			
		}
		
		if (result) {
			button_off("okBtn");
			$("#roleForm").submit();
		}
	}

	function doClose(){
		window.parent.closeBox();
	}
</script>
</head>
<body>
	<form:form modelAttribute="roleForm" id="roleForm"
		action="role.do?method=saveRole&operFlag=${operFlag}">
		<form:hidden path="role.id" />
		<div class="pop-body">
			<table width="100%" border="0" cellspacing="0" cellpadding="0">
				<tr>
					<td align="right" width="30%">Role Name：</td>
					<td align="center" width="35%"><form:input path="role.name"
						id="roleName" class="text-big"  isCheckSpecialChar="true" cMaxByteLength="50" maxlength="55"/></td>
					<td><span id="roleNameTip" class="tip_init">*</span></td>
				</tr>
				<tr>
					<td align="right">Role Description：</td>
					<td align="center"><form:textarea path="role.comment" id="comment"  class="text-big"
					cols="36" rows="6" maxlength="502"  isCheckSpecialChar="true" cMaxByteLength="500" style="height:112px;width: 198px;"></form:textarea></td>
					<td><span id="commentTip" class="tip_init"></span></td>
				</tr>
			</table>
		</div>
		<div class="pop-footer">
			<span class="left"><input id="okBtn" type="button"
				value='Submit' onclick="updateRole()" class="button-normal"></input>
			</span> 
			<span class="right"><input type="button" value="Cancel" onclick="doClose();"
				class="button-normal"></input>
			</span>
		</div>
	</form:form>
</body>
</html>