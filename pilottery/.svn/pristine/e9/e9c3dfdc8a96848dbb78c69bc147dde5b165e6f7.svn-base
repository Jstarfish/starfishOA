<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/views/common/taglibs.jsp"%>
<html>
<head>
<title>修改站点</title>

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
		if (!doCheck("agencyName", !isNull(trim($("#agencyName").val())),
				'不能为空')) {
			result = false;
		}
		if (!doCheck("contactPerson", !isNull(trim($("#contactPerson").val())),
				'不能为空')) {
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

		

		if (result) {
			button_off("okBtn");
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
	});
	function initSelect(value) {

		var url1 = "outlets.do?method=liandong1&code=" + value;
		$
				.ajax({
					url : url1,
					dataType : "json",
					async : false,
					success : function(r) {
						var selectVal = $("#marketManagerId").val();
						for ( var i = 0; i < r.length; i++) {
							if (r[i].market != selectVal) {
								var option = $(
										"<option <c:if test='"+r[i].market+" == "+${listForm.marketManagerId}+"}'>selected='selected'</c:if>>")
										.val(r[i].market).text(r[i].realName);
								$("#marketManagerId").append(option);
							}
						}
					}
				});

	}
</script>

</head>
<body>
	<form action="outlets.do?method=modify" id="theArea" method="POST">
		<input type="hidden" name="areaType" id="areaType" value="4" />
		<div class="pop-body">
			<table width="100%" border="0" cellspacing="0" cellpadding="0">
				<tr>
					<td align="right" width="25%">所属机构：</td>
					<td align="center" width="35%"><input name="org" class="text-big-noedit"
						id="org" value="${listForm.orgName}" maxLength="500" />
					<td width="*%"><span id="orgTip" class="tip_init"></span></td>
				</tr>
				<input name="orgCode" class="text-big" id="orgCode" value="${listForm.orgCode}"
					type="hidden" />
				<input name="areaCode" class="text-big" id="areaCode"
					value="${listForm.areaCode}" type="hidden" />
				<tr>
					<td align="right" width="25%">所属区域：</td>
					<td align="center" width="35%"><input name="area" class="text-big-noedit"
						id="area" value="${listForm.areaName}" maxLength="500" /></td>
					<td width="*%"><span id="areaTip" class="tip_init"></span></td>
				</tr>
				<tr>
					<td align="right" width="25%">市场管理员：</td>
					<td align="center" width="35%"><select name="marketManagerId"
						class="select-big" id="marketManagerId">
							<option value="${listForm.marketManagerId}">${listForm.marketName}</option>
					</select></td>
					<td width="*%"><span id="marketManagerIdTip" class="tip_init">*</span></td>
				</tr>
				<tr>
					<td align="right" width="25%">商店类型：</td>
					<td align="center" width="35%"><select name="storetypeId"
						class="select-big" id="storetypeId">
							<c:forEach items="${allStoreType}" var="item">
								<option value="${item.storeId}"
									<c:if test="${item.storeId == listForm.storetypeId}">selected="selected"</c:if>>${item.storeName}</option>
							</c:forEach>
					</select></td>
					<td width="*%"><span id="storetypeIdTip" class="tip_init">*</span></td>
				</tr>

				<tr>
					<td align="right" width="25%">站点类型：</td>
					<td align="center" width="35%"><select name="agencyType" class="select-big"
						id="agencyType">
							<c:forEach items="${agencyTypee}" var="item">
								<option value="${item.key}"
									<c:if test="${item.key==typeNum }">selected</c:if>>${item.value}</option>
							</c:forEach>
					</select></td>
					<td width="*%"><span id="agencyTypeTip" class="tip_init">*</span></td>
				</tr>
				<tr>
					<td align="right">站点名称：</td>
					<td align="center"><input name="agencyName" class="text-big"
						id="agencyName" value="${listForm.agencyName }" maxLength="500" /></td>
					<td width="*%"><span id="agencyNameTip" class="tip_init">*1~500
							字符</span></td>
				</tr>
				<tr>
					<td align="right" width="25%">所属银行：</td>
					<td align="center" width="35%"><select name="bankId" class="select-big"
						id="bankId">
							<c:forEach items="${allBank}" var="item">
								<option value="${item.bankId}"
									<c:if test="${item.bankId==listForm.bankId }">selected</c:if>>${item.bankName}</option>
							</c:forEach>
					</select></td>
					<td width="*%"><span id="bankIdTip" class="tip_init"></span></td>
				</tr>
				<tr>
					<td align="right">银行账号：</td>
					<td align="center"><input name="bankAccount" class="text-big"
						id="bankAccount" value="${listForm.bankAccount }" maxlength="32"
						oninput="this.value=this.value.replace(/[^\d,]/g,'')" /></td>
					<td><span id="bankAccountTip" class="tip_init">0~32 字符</span></td>
				</tr>
				<tr>
					<td align="right">联系人：</td>
					<td align="center"><input name="contactPerson" class="text-big"
						id="contactPerson" value="${listForm.contactPerson }" maxlength="200" /></td>
					<td><span id="contactPersonTip" class="tip_init">*1~200 字符</span></td>
				</tr>
				<tr>
					<td align="right">联系电话：</td>
					<td align="center"><input name="telephone" class="text-big" id="telephone"
						value="${listForm.telephone }"
						oninput="this.value=this.value.replace(/[^\d\-,]/g,'')" /><input
						name="c_outlet_code" class="text-big" id="c_outlet_code" value="${outletCode }"
						type="hidden" /></td>
					<td><span id="telephoneTip" class="tip_init">*</span></td>
				</tr>
				<tr>
					<td align="right">证件号码：</td>
					<td align="center"><input name="personalId" class="text-big"
						id="personalId" value="${listForm.personalId}"
						oninput="this.value=this.value.replace(/[^\d,]/g,'')" maxlength="50" /></td>
					<td><span id="personalIdTip" class="tip_init">*1~50 字符</span></td>
				</tr>
				<tr>
					<td align="right">合同编号：</td>
					<td align="center"><input name="contractNo" class="text-big"
						id="contractNo" value="${listForm.contractNo }"
						oninput="this.value=this.value.replace(/[^\d,]/g,'')" maxlength="50" /></td>
					<td><span id="contractNoTip" class="tip_init">*1~50 字符</span></td>
				</tr>
				<tr>
					<td align="right">地址：</td>
					<td align="center"><input name="address" class="text-big" id="address"
						value="${listForm.address}" maxlength="500" /></td>
					<td><span id="addressTip" class="tip_init">0~500 字符</span></td>
				</tr>
				<tr>
					<td align="right">经度：</td>
					<td align="center"><input name="glatlng_n" class="text-big" id="glatlng_n"
						value="${listForm.glatlng_n }" /></td>
					<td><span id="glatlng_nTip" class="tip_init"></span></td>
				</tr>
				<tr>
					<td align="right">纬度：</td>
					<td align="center"><input name="glatlng_e" class="text-big" id="glatlng_e"
						value="${listForm.glatlng_e }" /></td>
					<td><span id="glatlng_eTip" class="tip_init"></span></td>
				</tr>
				<tr>
					<td align="right"></td>
					<td align="left"></td>
				</tr>
			</table>
		</div>
		<div class="pop-footer">
			<span class="left"><input id="okBtn" type="button" value="修改"
				onclick="doSubmit();" class="button-normal"></input></span> <span class="right"><input
				type="button" value="关闭" onclick="doClose();" class="button-normal"></input></span>
		</div>
	</form>
</body>
</html>