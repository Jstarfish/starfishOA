<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8"%>
<%@ include file="/views/common/taglibs.jsp"%>
<%@ include file="/views/common/meta.jsp"%>
<html>
<head>
<title>站点账户编辑</title>

<link rel="stylesheet" type="text/css" href="${basePath}/css/style.css" />
<link rel="stylesheet" type="text/css" href="${basePath}/css/pop-up.css" />
<link rel="stylesheet"
	href="${basePath}/component/messageBox/myJsBox.css" type="text/css" />
<link rel="stylesheet" type="text/css" href="${basePath}/css/validate.css" />
<script type="text/javascript" src="${basePath}/component/messageBox/myJsBox_zh.js"></script>
<script type="text/javascript" src="${basePath}/js/myJs.js"></script>
<script type="text/javascript" src="${basePath}/js/jquery/jquery-1.9.1.js"></script>
<script type="text/javascript" src="${basePath}/js/regexEnum.js"></script>
<script type="text/javascript" charset="UTF-8">
	function doSubmit() {
		button_off("okBtn");
		$('#editOutletAccountForm').submit();
	}
	
	function filterInput(obj) {
		var cursor = obj.selectionStart;
		obj.value = obj.value.replace(/[^\d]/g,'');
		obj.selectionStart = cursor;
		obj.selectionEnd = cursor;
	}
</script>

</head>
<body style="text-align: center">
	<form action="account.do?method=modifyOutletAcct"
		id="editOutletAccountForm" method="POST">
		<div class="pop-body">
			<table width="100%" border="0" cellspacing="0">
				<tr>
					<td align="right">站点编码：</td>
					<td align="left"><input class="text-big-noedit" name="agencyCode"
						value="${OutletAccts[0].agencyCode }" readonly="readonly"></td>
					<td><span id="agencyCodeTip" class="tip_init"></span></td>
				</tr>

				<tr>
					<td align="right">站点名称：</td>
					<td align="left" id="agencyName"><input class="text-big-noedit"
						name="agencyName" value="${OutletAccts[0].agencyName }" readonly="readonly"></td>
					<td><span id="agencyNameTip" class="tip_init"></span></td>
				</tr>

				<tr>
					<td align="right">信用额度：</td>
					<td align="left"><input name="creditLimit" class="text-big"
						id="creditLimit" value="${OutletAccts[0].creditLimit }" 
						maxlength="10" oninput="filterInput(this)"/></td>
					<td><span id="creditLimitTip" class="tip_init"></span></td>
				</tr>
			</table>

			<div style="padding:0 20px; margin-top:10px;margin-bottom: 20px; ">
                 <div style="position:relative; z-index:1000px;">
                   <table class="datatable" id="table1_head" width="100%">
                     <tbody><tr>
								<th width="25%">方案名称</th>
								<th width="2%">|</th>
								<th width="25%">销售提成比例</th>
								<th width="2%">|</th>
								<th width="25%">兑奖提成比例</th>
							</tr>
						</tbody>
					</table>
				</div>

			<div id="box" style="border: 1px solid #ccc;">
				<table id="fatable" class="datatable" cellpadding="0" cellspacing="0" width="100%">
					<tbody>
						<c:forEach var="rate" items="${OutletAccts}" varStatus="s">
						<c:if test="${not empty rate.planCode}">
						<tr>
							<td width="25%">${rate.planName} <input type="hidden"
								name="outletCommRate[${s.index}].planCode"
								value="${rate.planCode }" />
							</td>

							<td width="2%">&nbsp;</td>

							<td width="25%"><input type="text"
								name="outletCommRate[${s.index}].saleComm"
								value="${rate.saleComm}" size="10" maxlength="4"
								oninput="filterInput(this);"/> ‰ <input type="hidden"
								name="outletCommRate[${s.index}].orgCode"
								value="${OutletAccts[0].agencyCode }" />
							</td>
							<td width="2%">&nbsp;</td>
							<td width="25%"><input type="text"
								name="outletCommRate[${s.index}].payComm"
								value="${rate.payComm}" size="10" maxlength="4"
								oninput="filterInput(this);initQuantity();"/> ‰
					</tr>
					</c:if>
					</c:forEach>
				</tbody>
			</table>
		</div>
	</div>
	</div>
	<div class="pop-footer">
		<span class="left"><input id="okBtn" type="button"
			value="修改" onclick="doSubmit();" class="button-normal"></input></span>
		<span class="right"><input type="Reset" value="重置"
			class="button-normal"></input></span>
	</div>
	</form>
</body>
</html>