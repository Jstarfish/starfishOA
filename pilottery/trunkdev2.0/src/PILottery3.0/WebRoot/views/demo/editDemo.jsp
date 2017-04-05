<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/views/common/taglibs.jsp"%>
<html>
<head>
<title>编辑用户</title>

<link rel="stylesheet" type="text/css" href="${basePath}/css/style.css" />
<link rel="stylesheet" type="text/css" href="${basePath}/css/pop-up.css" />
<link rel="stylesheet" type="text/css" href="${basePath}/css/validate.css" />

<script type="text/javascript" src="${basePath}/js/oms/myJs.js"></script>
<script type="text/javascript" src="${basePath}/js/jquery/jquery-1.9.1.js"></script>

<script type="text/javascript" src="${basePath}/js/ztree/jquery.ztree.core-3.5.js"></script>
<script type="text/javascript" src="${basePath}/js/ztree/jquery.ztree.excheck-3.5.js"></script>
<script type="text/javascript" src="${basePath}/js/ztree/jquery-county.js" charset="utf-8"></script>
<link type="text/css" rel="stylesheet" href="${basePath}/css/zTreeStyle.css">

<link type="text/css" rel="stylesheet" href="${basePath}/css/jquery-county.css"/>

<style type="text/css">


</style>
<script type="text/javascript">

	function doSubmit() {
		if(!doCheck("realName",/.+$/,"Real Name Is Not Null!")){
            result = false;
        }

		if(!doCheck("telephone",/.+$/,"Telephone Is Not Null!")){
            result = false;
        }else if(!doCheck("telephone",/^.{1,20}$/,"Telephone Must Be Number!")) {
            result = false;
        }
		if($("#email").val().length != 0 && !doCheck("email",/^[\w-]+(\.[\w-]+)*@[\w-]+(\.[\w-]+)+$/,"Email Format Error！")) {
	        result = false;
	    }
	    
		if (result) {
			button_off("okBtn");
			$('#editForm').submit();
		}
	}

	function doReset() {
		
		$('#editForm')[0].reset();
	}
</script>
</head>
<body style="text-align:center">
	<form:form modelAttribute="demoForm" id="editForm" method="post" action="demo.do?method=saveDemo">
		<form:hidden path="userId" id="userId"/>
		<form:hidden path="oper" id="oper" />
		<div class="pop-body">
		<table width="100%" border="0" cellspacing="0" cellpadding="0"
			height="220px">
			<tr>
				<td width="25%" align="right">User Name:</td>
				<td width="35%" align="center"><form:input path="userName"
					id="userName" class="text-big" maxLength="20" value="${user.account }"/></td>
			</tr>
			<tr>
				<td align="right">Real Name:</td>
				<td align="center"><form:input path="realName" id="realName"
					class="text-big" maxLength="20" value="${user.realname }"/></td>
				<td><span id="realnameTip" class="tip_init">* Not Empty</span></td>
			</tr>
			<tr>
				<td align="right">Telephone:</td>
				<td align="center"><form:input path="telephone" id="telephone"
					class="text-big" value="${user.tel }"/></td>
				<td><span id="telTip" class="tip_init">* Not Empty And Must Number</span></td>
			</tr>
			<tr>
				<td align="right">Email:</td>
				<td align="center"><form:input path="email" id="email"
					class="text-big" value="${user.email }"/></td>
				<td><span id="emailTip" class="tip_init">* abc123@xxx.zzz</span></td>
			</tr>
			<tr>
				<td align="right">Address:</td>
				<td align="center"><form:input path="address" id="address"
					class="text-big" />${user.address }</td>
				<td><span id="addressTip" class="tip_init"></span></td>
			</tr>
		</table>
		</div>
	
		<div class="pop-footer">
			<span class="left">
				<input id="okBtn" type="button" value="Submit" onclick="doSubmit()"
				class="button-normal"></input>
			</span> 
			<span class="right">
				<input type="Reset" value="Reset" class="button-normal" onclick="doReset();"></input>
			</span>
		</div>
	</form:form>

</body>
</html>