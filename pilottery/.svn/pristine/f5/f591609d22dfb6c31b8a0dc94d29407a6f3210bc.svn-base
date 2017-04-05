<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/views/common/taglibs.jsp"%>
<html>
<head>
<title></title>
<%@ include file="/views/common/meta.jsp"%>

<link rel="stylesheet" type="text/css" href="${basePath}/css/style.css" />
<link rel="stylesheet" type="text/css" href="${basePath}/css/pop-up.css" />
<link rel="stylesheet" type="text/css" href="${basePath}/css/validate.css" />
<link rel="stylesheet" href="${basePath}/component/messageBox/myJsBox.css"
	type="text/css" />
<script type="text/javascript" src="${basePath}/component/messageBox/myJsBox_zh.js"></script>
<script type="text/javascript" src="${basePath}/js/myJs_zh.js"></script>
<script type="text/javascript" src="${basePath}/js/jquery/jquery-1.9.1.js"></script>

<script type="text/javascript">
	function isNull(data) {
		return (data == "" || data == null);
	}
	function updateView() {
		var canSubmit = true;
		
		if (!doCheck("password0", !isNull($("#password0").val()), "请输入旧密码")) {
			return false;
		}
		
		if (!doCheck("password0", /^[0-9]{6}$/,
				'您的密码必须是6位数字')) {
			canSubmit = false;
		}

		var v1 = $("#password0").val() != $("#password1").val();
		var v2 = $("#password1").val() == $("#password2").val();
		if (!doCheck("password1", v1, '请输入与原密码不一致的密码')) {
			canSubmit = false;
		} else if (!doCheck("password1", /^[0-9]{6}$/,
				'您的密码必须是6位数字')) {
			canSubmit = false;
		} else if (!doCheck("password2", v2,
				'新密码和确认新密码两次输入结果不同')) {
			canSubmit = false;
		} else if (!doCheck("password2", /^[0-9]{6}$/,
				'您的密码必须是6位数字')) {
			canSubmit = false;
		} else if (!doCheck("password1", $("#password1").val() != "111111",
				'新密码不能为 "111111"')) {
			canSubmit = false;
		}

		if (canSubmit) {
			var url = "user.do?method=confirmPass&pass="
					+ $("#password0").val();
			$.ajax({
				url : url,
				dataType : "",
				async : false,
				success : function(r) {
					if (r == 'error') {
						doCheck("password0", false,
								"您的旧密码输入错误");
						canSubmit = false;
					}
				}
			});
		}
		if (canSubmit) {
			button_off("okButton");
			$("#changePwd").submit();
		}

	}
</script>
</head>
<body>
	<form action="user.do?method=ChangePwd" id="changePwd" method="POST">
		<div class="pop-body">
			<table width="100%" border="0" cellspacing="0" cellpadding="0">
				<div id="title">修改密码</div>
				<tr>
					<td align="right" width="25%">用户名称:</td>
					<td align="left" width="30%"><input type="text"
						id="username" class="text-big-noedit" disabled="disabled" value="${loginId
							}" /></td>
				</tr>
				<tr>
					<td align="right">旧密码:</td>
					<td align="left"><input type="password" id="password0" class="text-big"></input>
						<span id="password0Tip" class="tip_init">*</span></td>
				</tr>
				<tr>
					<td align="right">新密码:</td>
					<td align="left"><input type="password" name="password1" id="password1"
						class="text-big"></input> <span id="password1Tip" class="tip_init">*</span></td>
				</tr>
				<tr>
					<td align="right">确认新密码:</td>
					<td align="left"><input type="password" id="password2" name="password2" class="text-big"></input>
						<span id="password2Tip" class="tip_init">*</span></td>
				</tr>
				<tr>
					<td align="right"></td>
					<td align="left"><input id="okButton" type="button" value='提交'
						class="button-normal" onclick="updateView();" /></td>
				</tr>
			</table>
		</div>
	</form>
</body>
</html>