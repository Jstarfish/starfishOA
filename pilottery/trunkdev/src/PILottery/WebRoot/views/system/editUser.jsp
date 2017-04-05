<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8"%>
<%@ include file="/views/common/taglibs.jsp"%>
<html>
<head>
<title>edit user</title>
<link rel="stylesheet" type="text/css" href="${basePath}/css/style.css" />
<link rel="stylesheet" type="text/css" href="${basePath}/css/pop-up.css" />
<link rel="stylesheet" type="text/css" href="${basePath}/css/validate.css" />
<script type="text/javascript" src="${basePath}/js/myJs.js"></script>
<script type="text/javascript" src="${basePath}/js/jquery/jquery-1.9.1.js"></script>
<script type="text/javascript" src="${basePath}/component/My97DatePicker/WdatePicker.js"></script>
<script type="text/javascript">

	function isNull(data) {
		return (data == "" || data == null);
	}
	function doSubmit() {
		var result = true;
		
		if (!checkFormComm('editForm')) {
			result = false;
			return false;
		}
		if (!doCheck("loginId", !isNull($("#loginId").val()), "Can not empty")) {
			result = false;
		}
		 /* else if($("#loginId").val().length != 0
				&& !doCheck("loginId", /^[a-zA-Z0-9]+$/,
				"loginId format is incorrect")){
			result = false;
		} */
		
		
		if (!doCheck("realName", !isNull($("#realName").val()), "Can not empty")) {
			result = false;
		} 
		
		if ($("#email").val().length != 0
				&& !doCheck("email", /^[\w-]+(\.[\w-]+)*@[\w-]+(\.[\w-]+)+$/,
						"Email format is incorrect")) {
			result = false;
		}
		
		/*if (!doCheck("mobilePhone", /^[0-9\-]*$/,"Telephone format is incorrect")) {
			result = false;
		}
		
		if ($("#officePhone").val().length != 0
				&& !doCheck("officePhone", /^[0-9\-]*$/,
						"Telephone format is incorrect")) {
			result = false;
		}
		if ($("#homePhone").val().length != 0
				&& !doCheck("homePhone", /^[0-9\-]*$/,
						"Telephone format is incorrect")) {
			result = false;
		} */
		
	//	console.log(result); 
		if (result) {
			button_off("okBtn");   // 防止按钮重复点击,myJs.js中定义的
			$('#editForm').submit();
		}
	}
</script>
</head>
<body style="text-align: center">
	<form:form modelAttribute="editForm" id="editForm" method="post" action="user.do?method=saveUser">
	<form:hidden path="user.id" id="id" />
	<form:hidden path="oper" id="oper" />
		<form:hidden path="user.password" id="password" />
	<div class="pop-body">
		<table width="100%" border="0" cellspacing="0" cellpadding="0">
			<tr>
				<td align="right" width="25%">UserName：</td>
				<td align="center" width="30%">
				<c:choose>
					<c:when test="${editForm.oper=='2' }">
						<form:input path="user.loginId" id="loginId" class="text-big-noedit" readonly="true" />
					</c:when>
					<c:otherwise>
						<form:input path="user.loginId" id="loginId" class="text-big" maxLength="25" isCheckSpecialChar="true" cMaxByteLength="20"/>
					</c:otherwise>
				</c:choose>
				</td>
				<td><span id="loginIdTip" class="tip_init">*</span></td>
			</tr>
			
			<tr>
				<td align="right">RealName：</td>
				<td align="center"><form:input path="user.realName" id="realName" class="text-big" maxLength="52" isCheckSpecialChar="true"	cMaxByteLength="50"/></td>
				<td><span id="realNameTip" class="tip_init">*</span></td>
			</tr>

			<tr>
				<td align="right">Gender：</td>
				<td align="center">
				<c:choose>
					<c:when test="${editForm.user.gender==1}">
					     <form:input path="user.gender" type="radio" name="gender" value="1" checked="checked" /> Male 
					     <form:input path="user.gender" type="radio" name="gender" value="2" />Female
				     </c:when>
				     <c:when test="${editForm.user.gender==2}">
					     <form:input path="user.gender" type="radio" name="gender" value="1"  /> Male 
					     <form:input path="user.gender" type="radio" name="gender" value="2" checked="checked" />Female
				     </c:when>
				     <c:otherwise>
						 <form:input path="user.gender" type="radio" name="gender" value="1" checked="checked" /> Male 
						 <form:input path="user.gender" type="radio" name="gender" value="2" />Female
				     </c:otherwise>
				</c:choose>
				<td><span id="genderTip" class="tip_init">*</span></td>
			</tr>

			<tr>
				<td align="right">Institution：</td>
				<td align="center">
				<form:select path="user.institutionCode"	id="orgCode" name="orgCode" class="select-big">
					<option value="">Please select...</option>
					<c:forEach items="${orgsList}" var="orgInfo">
						<option value="${orgInfo.orgCode}"
						<c:if test="${orgInfo.orgCode == editForm.user.institutionCode}">selected="selected"</c:if>>${orgInfo.orgName}</option>
					</c:forEach>
				</form:select></td>
				<td><span id="institutionCodeTip" class="tip_init"></span></td>
			</tr>

			<tr>
				<td align="right">Market Manager：</td>
				<td align="center"><form:checkbox path="user.isCollectorB" /></td>
				<td><span id="marketManagerTip" class="tip_init"></span></td>
			</tr>

			<tr>
				<td align="right">Date of Birth：</td>
				<td align="center">
				<form:input type="text" path="user.birthday" id="birthday" name="birthday"
					value="${user.birthday}" class="Wdate text-big" onfocus="WdatePicker({dateFmt:'yyyy-MM-dd',readOnly:true})" /></td>
				<td><span id="birthdayTip" class="tip_init"></span></td>
			</tr>

			<tr>
				<td align="right">Mobile Phone：</td>
				<td align="center"><form:input path="user.mobilePhone"
					id="mobilePhone" class="text-big" maxLength="15" isCheckSpecialChar="true"
						cMaxByteLength="15"/></td>
				<td><span id="mobilePhoneTip" class="tip_init">1~15 characters</span></td>
			</tr>

			<tr>
				<td align="right">Office Phone：</td>
				<td align="center"><form:input path="user.officePhone"
					id="officePhone" class="text-big" maxLength="15" isCheckSpecialChar="true"
						cMaxByteLength="15"/></td>
				<td><span id="officePhoneTip" class="tip_init">1~15 characters</span></td>
			</tr>

			<tr>
				<td align="right">Home Phone：</td>
				<td align="center"><form:input path="user.homePhone" id="homePhone"
					class="text-big" maxLength="15" isCheckSpecialChar="true"
						cMaxByteLength="15"/></td>
				<td><span id="homePhoneTip" class="tip_init">1~15 characters</span></td>
			</tr>

			<tr>
				<td align="right">Email：</td>
				<td align="center"><form:input path="user.email" id="email"
					class="text-big" maxLength="50"/></td>
				<td><span id="emailTip" class="tip_init">1~50 characters</span></td>
			</tr>

			<tr>
				<td align="right">Home Address：</td>
				<td align="center"><form:input path="user.homeAddress"
					id="homeAddress" class="text-big" maxLength="502" isCheckSpecialChar="true"
						cMaxByteLength="500"/></td>
				<td><span id="homeAddressTip" class="tip_init">1~500 characters</span></td>
			</tr>

			<tr>
				<td align="right" >Remarks：</td>
				<td align="center"><form:textarea path="user.remark" id="remark" class="text-big" 
					style="height:64px;width: 198px;" maxLength="500" isCheckSpecialChar="true" cMaxByteLength="500"/></td>
				<td><span id="remarkTip" class="tip_init">1~500 characters</span></td>
			</tr>
		</table>
	</div>
	<div class="pop-footer">
		<span class="left"><input id="okBtn" type="button" value='Submit' onclick="doSubmit()" class="button-normal"></input></span>
		<span class="right"><input type="Reset" value="Reset" class="button-normal"></input></span>
	</div>
</form:form>
</body>
</html>