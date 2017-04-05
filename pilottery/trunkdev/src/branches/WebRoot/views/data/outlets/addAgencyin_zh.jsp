<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/views/common/taglibs.jsp"%>
<html>
<head>
<title>新建站点</title>

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

		if (!doCheck("orgCode", !isNull($("#orgCode").val()), '不能为空')) {
			result = false;
		}
		if (isNull(trim($("#agencyName").val()))) {
			ckSetFormOjbErrMsg('agencyName','不能为空');
			result = false;
		}
		if (isNull(trim($("#contactPerson").val()))) {
			ckSetFormOjbErrMsg('contactPerson','不能为空');
			result = false;
		}
	
		if (!doCheck("telephone", !isNull(trim($("#telephone").val())),
				'不能为空')) {
			result = false;
		}
		if (!doCheck("personalId", !isNull(trim($("#personalId").val())),
				'不能为空')) {
			result = false;
		}
		if (!doCheck("contractNo", !isNull(trim($("#contractNo").val())),
				'不能为空')) {
			result = false;
		}
		if (!doCheck("areaCode", !isNull($("#areaCode").val()),
				'不能为空')) {
			result = false;
		}
		if (!doCheck("marketManagerId", !isNull($("#marketManagerId").val()),
				'不能为空')) {
			result = false;
		}
		if (!doCheck("storetypeId", !isNull($("#storetypeId").val()),
				'不能为空')) {
			result = false;
		}
		if (!doCheck("agencyType", !isNull($("#agencyType").val()),
				'不能为空')) {
			result = false;
		}
		if(!isNull($("#pass").val())){
			var passlen=$("#pass").val().length;
			if (!doCheck("pass", passlen==6,
			'密码必须为6位')) {
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
					<td align="right" width="25%">所属部门：</td>
					<td align="left" width="30%"><select name="orgCode" class="select-big"
						id="orgCode">
							<c:forEach items="${institution}" var="item">
								<option value="${item.orgCode}">${item.orgName}</option>
							</c:forEach>
					</select></td>
					<td><span id="orgCodeTip" class="tip_init">*</span></td>
				</tr>
				<tr>
					<td align="right">所属区域：</td>
					<td align="left"><select name="areaCode" class="select-big" id="areaCode">

					</select></td>
					<td><span id="areaCodeTip" class="tip_init">*</span></td>
				</tr>
				<tr>
					<td align="right">市场管理员：</td>
					<td align="left"><select name="marketManagerId" class="select-big"
						id="marketManagerId">
					</select></td>
					<td><span id="marketManagerIdTip" class="tip_init">*</span></td>
				</tr>
				<tr>
					<td align="right">商店类型：</td>
					<td align="left"><select name="storetypeId" class="select-big"
						id="storetypeId">
							<c:forEach items="${allStoreType}" var="item">
								<option value="${item.storeId}">${item.storeName}</option>
							</c:forEach>
					</select></td>
					<td><span id="storetypeIdTip" class="tip_init">*</span></td>
				</tr>

				<tr>
					<td align="right">站点类型：</td>
					<td align="left"><select name="agencyType" class="select-big"
						id="agencyType">
							<c:forEach items="${agencyTypee}" var="item">
								<option value="${item.key}">${item.value}</option>
							</c:forEach>
					</select></td>
					<td><span id="agencyTypeTip" class="tip_init">*</span></td>
				</tr>
				<tr>
					<td align="right">站点名称：</td>
					<td align="left"><input type="text" name="agencyName" class="text-big"
						id="agencyName" value="" maxLength="500" isCheckSpecialChar="true"
						cMaxByteLength="500" /></td>
					<td><span id="agencyNameTip" class="tip_init">*1~500 字符</span></td>
				</tr>
				<tr>
					<td align="right">所属银行：</td>
					<td align="left"><select name="bankId" class="select-big" id="bankId">
							<option value="">空</option>
							<c:forEach items="${allBank}" var="item">
								<option value="${item.bankId}">${item.bankName}</option>
							</c:forEach>
					</select></td>
					<td><span id="bankIdTip" class="tip_init"></span></td>
				</tr>
				<tr>
					<td align="right">银行账号：</td>
					<td align="left"><input name="bankAccount" class="text-big"
						id="bankAccount" maxlength="32"
						oninput="this.value=this.value.replace(/[^\d,]/g,'')" /></td>
					<td><span id="bankAccountTip" class="tip_init">0~32 字符</span></td>
				</tr>
				<tr>
					<td align="right">负责人：</td>
					<td align="left"><input name="contactPerson" class="text-big"
						id="contactPerson" maxlength="200" isCheckSpecialChar="true"
						cMaxByteLength="200" /></td>
					<td><span id="contactPersonTip" class="tip_init">*1~200 字符</span></td>
				</tr>
				<tr>
					<td align="right">联系电话：</td>
					<td align="left"><input name="telephone" class="text-big" id="telephone"
						oninput="this.value=this.value.replace(/[^\d\-,]/g,'')" /></td>
					<td><span id="telephoneTip" class="tip_init">*</span></td>
				</tr>
				<tr>
					<td align="right">证件号码：</td>
					<td align="left"><input name="personalId" class="text-big" id="personalId"
						maxlength="50" oninput="this.value=this.value.replace(/[^\d,]/g,'')" /></td>
					<td><span id="personalIdTip" class="tip_init">*1~50 字符</span></td>
				</tr>
				<tr>
					<td align="right">合同编号：</td>
					<td align="left"><input name="contractNo" class="text-big" id="contractNo"
						maxlength="50" oninput="this.value=this.value.replace(/[^\d,]/g,'')" /></td>
					<td><span id="contractNoTip" class="tip_init">*1~50 字符</span></td>
				</tr>
				<tr>
					<td align="right">地址：</td>
					<td align="left"><input name="address" class="text-big" id="address"
						maxlength="500" isCheckSpecialChar="true" cMaxByteLength="500" /></td>
					<td><span id="addressTip" class="tip_init">0~500 字符</span></td>
				</tr>
				<tr>
					<td align="right">站点登录密码：</td>
					<td align="left"><input name="pass" class="text-big" id="pass"
						type="password" oninput="this.value=this.value.replace(/[^\d,]/g,'')" maxlength="6"/></td>
					<td><span id="passTip" class="tip_init"></span></td>
				</tr>
				<tr>
					<td align="right">经度坐标：</td>
					<td align="left"><input name="glatlng_n" class="text-big" id="glatlng_n"
						isCheckSpecialChar="true" cMaxByteLength="50" /></td>
					<td><span id="glatlng_nTip" class="tip_init"></span></td>
				</tr>
				<tr>
					<td align="right">维度坐标：</td>
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
			<span class="left"> <input id="okButton" type="button" value='提交'
				class="button-normal" onclick="doSubmit();"></input>
			</span> <span class="right"> <input type="button" value="取消"
				onclick="doClose();" class="button-normal"></input>
			</span>
		</div>
	</form>
</body>
</html>