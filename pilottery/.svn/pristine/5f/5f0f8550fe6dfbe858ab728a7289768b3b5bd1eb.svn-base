<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/views/common/taglibs.jsp"%>
<html>
<head>
<title>New Outlet</title>

<link rel="stylesheet" type="text/css" href="${basePath}/css/style.css" />
<link rel="stylesheet" type="text/css" href="${basePath}/css/pop-up.css" />
<link rel="stylesheet" type="text/css" href="${basePath}/css/validate.css" />
<link rel="stylesheet" href="${basePath}/component/messageBox/myJsBox.css"
	type="text/css" />
<script type="text/javascript" src="${basePath}/component/messageBox/myJsBox.js"></script>
<script type="text/javascript" src="${basePath}/js/myJs.js"></script>
<script type="text/javascript" src="${basePath}/js/jquery/jquery-1.9.1.js"></script>


<script type="text/javascript" charset="UTF-8">
	//var selel;
	function doSubmit() {
		var result = true;
		if (!checkFormComm('theArea')) {
			result = false;
		}

		if (!doCheck("orgCode", !isNull($("#orgCode").val()), 'Cannot be empty')) {
			result = false;
		}
		if (isNull(trim($("#agencyName").val()))) {
			ckSetFormOjbErrMsg('agencyName','Not empty, start with an English letter or a Chinese character');
			result = false;
		}
		if (isNull(trim($("#contactPerson").val()))) {
			ckSetFormOjbErrMsg('contactPerson','Not empty, start with an English letter or a Chinese character');
			result = false;
		}
	
		if (!doCheck("telephone", !isNull(trim($("#telephone").val())),
				'Cannot be empty')) {
			result = false;
		}
		if (!doCheck("personalId", !isNull(trim($("#personalId").val())),
				'Cannot be empty')) {
			result = false;
		}
		if (!doCheck("contractNo", !isNull(trim($("#contractNo").val())),
				'Cannot be empty')) {
			result = false;
		}
		if (!doCheck("areaCode", !isNull($("#areaCode").val()),
				'Cannot be empty')) {
			result = false;
		}
		if (!doCheck("marketManagerId", !isNull($("#marketManagerId").val()),
				'Cannot be empty')) {
			result = false;
		}
		if (!doCheck("storetypeId", !isNull($("#storetypeId").val()),
				'Cannot be empty')) {
			result = false;
		}
		if (!doCheck("agencyType", !isNull($("#agencyType").val()),
				'Cannot be empty')) {
			result = false;
		}
		if(!isNull($("#pass").val())){
			var passlen=$("#pass").val().length;
			if (!doCheck("pass", passlen==6,
			'Password length must be 6 digital')) {
		result = false;
	}
		}

		if (result) {
			button_off("okButton");
			$('#theArea').submit();
		}
	}

	function isNull(data) {
		return (data == "" || data == undefined || data == null);
	}

	function doClose() {
		window.parent.closeBox();
	}
	$(document).ready(function() {
		var val = $('#orgCode').val();
		initSelect(val);
		$("#orgCode").change(function() {
			var val = $('#orgCode').val();
			initSelect(val);
		});
	});
	function initSelect(value) {

		var url = "outlets.do?method=liandong&code=" + value;

		$.ajax({
			url : url,
			dataType : "json",
			async : false,
			success : function(r) {
				$("#areaCode").empty();
				for ( var i = 0; i < r.length; i++) {

					var option = $("<option>").val(r[i].areaCode).text(
							r[i].areaName);
					$("#areaCode").append(option);
				}
			}
		});

		var url1 = "outlets.do?method=liandong1&code=" + value;
		$.ajax({
			url : url1,
			dataType : "json",
			async : false,
			success : function(r) {
				$("#marketManagerId").empty();
				for ( var i = 0; i < r.length; i++) {

					var option = $("<option>").val(r[i].market).text(
							r[i].realName);
					$("#marketManagerId").append(option);
				}
			}
		});

	}
</script>

</head>
<body>
	<form action="outlets.do?method=addOutlet" id="theArea" method="POST">
		<input type="hidden" name="areaType" id="areaType" value="4" />
		<div class="pop-body">
			<table width="100%" border="0" cellspacing="0" cellpadding="0">
				<tr>
					<td align="right" width="25%">Institution：</td>
					<td align="left" width="30%">
						<select name="orgCode" class="select-big" id="orgCode">
							<option value="">Please Select</option>
							<c:forEach items="${institution}" var="item">
								<c:if test="${item.orgCode != '00'}">
									<option value="${item.orgCode}">${item.orgName}</option>
								</c:if>
							</c:forEach>
						</select>
					</td>
					<td><span id="orgCodeTip" class="tip_init">*</span></td>
				</tr>
				<tr>
					<td align="right">Administrative Area：</td>
					<td align="left"><select name="areaCode" class="select-big" id="areaCode">

					</select></td>
					<td><span id="areaCodeTip" class="tip_init">*</span></td>
				</tr>
				<tr>
					<td align="right">Market Managers：</td>
					<td align="left"><select name="marketManagerId" class="select-big"
						id="marketManagerId">
					</select></td>
					<td><span id="marketManagerIdTip" class="tip_init">*</span></td>
				</tr>
				<tr>
					<td align="right">Store Type：</td>
					<td align="left"><select name="storetypeId" class="select-big"
						id="storetypeId">
							<c:forEach items="${allStoreType}" var="item">
								<option value="${item.storeId}">${item.storeName}</option>
							</c:forEach>
					</select></td>
					<td><span id="storetypeIdTip" class="tip_init">*</span></td>
				</tr>

				<tr>
					<td align="right">Outlet Type：</td>
					<td align="left">
						<select name="agencyType" class="select-big" id="agencyType">
							<option value="1">Prepaid Outlet</option>
							<c:if test="${sessionScope.current_user.id == 0}">
								<option value="2">Accredited Outlet</option>
								<option value="3">Paperles Outlet</option>
							</c:if>
						</select></td>
					<td><span id="agencyTypeTip" class="tip_init">*</span></td>
				</tr>
				<tr>
					<td align="right">Outlet Name：</td>
					<td align="left"><input type="text" name="agencyName" class="text-big"
						id="agencyName" value="" maxLength="500" isCheckSpecialChar="true"
						cMaxByteLength="500" /></td>
					<td><span id="agencyNameTip" class="tip_init">*1~500 characters</span></td>
				</tr>
				<tr>
					<td align="right">Partnership Bank：</td>
					<td align="left"><select name="bankId" class="select-big" id="bankId">
							<option value="">Empty</option>
							<c:forEach items="${allBank}" var="item">
								<option value="${item.bankId}">${item.bankName}</option>
							</c:forEach>
					</select></td>
					<td><span id="bankIdTip" class="tip_init"></span></td>
				</tr>
				<tr>
					<td align="right">Bank Account ID：</td>
					<td align="left"><input name="bankAccount" class="text-big"
						id="bankAccount" maxlength="32"
						oninput="this.value=this.value.replace(/[^\d,]/g,'')" /></td>
					<td><span id="bankAccountTip" class="tip_init">0~32 characters</span></td>
				</tr>
				<tr>
					<td align="right">Contact Person：</td>
					<td align="left"><input name="contactPerson" class="text-big"
						id="contactPerson" maxlength="200" isCheckSpecialChar="true"
						cMaxByteLength="200" /></td>
					<td><span id="contactPersonTip" class="tip_init">*1~200 characters</span></td>
				</tr>
				<tr>
					<td align="right">Contact Phone：</td>
					<td align="left"><input name="telephone" class="text-big" id="telephone"
						oninput="this.value=this.value.replace(/[^\d\-,]/g,'')" /></td>
					<td><span id="telephoneTip" class="tip_init">*</span></td>
				</tr>
				<tr>
					<td align="right">Personal ID：</td>
					<td align="left"><input name="personalId" class="text-big" id="personalId"
						maxlength="50" oninput="this.value=this.value.replace(/[^\d,]/g,'')" /></td>
					<td><span id="personalIdTip" class="tip_init">*1~50 characters</span></td>
				</tr>
				<tr>
					<td align="right">Contract No：</td>
					<td align="left"><input name="contractNo" class="text-big" id="contractNo"
						maxlength="50" oninput="this.value=this.value.replace(/[^\d,]/g,'')" /></td>
					<td><span id="contractNoTip" class="tip_init">*1~50 characters</span></td>
				</tr>
				<tr>
					<td align="right">Outlet Address：</td>
					<td align="left"><input name="address" class="text-big" id="address"
						maxlength="500" isCheckSpecialChar="true" cMaxByteLength="500" /></td>
					<td><span id="addressTip" class="tip_init">0~500 characters</span></td>
				</tr>
				<tr>
					<td align="right">Password：</td>
					<td align="left"><input name="pass" class="text-big" id="pass"
						type="password" oninput="this.value=this.value.replace(/[^\d,]/g,'')" maxlength="6"/></td>
					<td><span id="passTip" class="tip_init"></span></td>
				</tr>
				<tr>
					<td align="right">Glatlng_n：</td>
					<td align="left"><input name="glatlng_n" class="text-big" id="glatlng_n"
						isCheckSpecialChar="true" cMaxByteLength="50" /></td>
					<td><span id="glatlng_nTip" class="tip_init"></span></td>
				</tr>
				<tr>
					<td align="right">Glatlng_e：</td>
					<td align="left"><input name="glatlng_e" class="text-big" id="glatlng_e"
						isCheckSpecialChar="true" cMaxByteLength="50" /></td>
					<td><span id="glatlng_eTip" class="tip_init"></span></td>
				</tr>
				<tr>
					<td align="right"></td>
					<td align="left"></td>
				</tr>
			</table>
		</div>
		<div class="pop-footer">
			<span class="left"> <input id="okButton" type="button" value='Submit'
				class="button-normal" onclick="doSubmit();"></input>
			</span> <span class="right"> <input type="button" value="Cancel"
				onclick="doClose();" class="button-normal"></input>
			</span>
		</div>
	</form>
</body>
</html>