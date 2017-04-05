
<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8"%>
<%@ include file="/views/common/taglibs.jsp"%>
<%@ include file="/views/common/meta.jsp"%>
<html>
<head>
<title>编辑部门账户</title>
<link rel="stylesheet" type="text/css" href="${basePath}/css/style.css" />
<link rel="stylesheet" type="text/css" href="${basePath}/css/pop-up.css" />
<link rel="stylesheet" href="${basePath}/component/messageBox/myJsBox.css" type="text/css" />
<link rel="stylesheet" type="text/css" href="${basePath}/css/validate.css" />

<script type="text/javascript" src="${basePath}/component/messageBox/myJsBox_zh.js"></script>
<script type="text/javascript" src="${basePath}/component/My97DatePicker/WdatePicker.js"></script>
<script type="text/javascript" src="${basePath}/js/myJs.js"></script>
<script type="text/javascript" src="${basePath}/js/jquery/jquery-1.9.1.js"></script>
<script type="text/javascript" src="${basePath}/js/regexEnum.js"></script>

<script type="text/javascript" charset="UTF-8">
	function doSubmit() {
		button_off("okBtn");
		$('#editInstitutionAccountForm').submit();
	}
	
	function filterInput(obj) {
		var cursor = obj.selectionStart;
		obj.value = obj.value.replace(/[^\d]/g,'');
		obj.selectionStart = cursor;
		obj.selectionEnd = cursor;
	}
	
	function paste(obj){
		var saleComm1 = document.getElementsByName("iCommRateList[0].saleComm")[0].value;
		var payComm1 = document.getElementsByName("iCommRateList[0].payComm")[0].value;
		var tr = $(obj).parent().parent();
		
		tr[0].childNodes[5].firstChild.value = saleComm1;
		tr[0].childNodes[9].firstChild.value = payComm1; 
	}
	
	function pasteAll(obj){
		var saleComm1 = document.getElementsByName("iCommRateList[0].saleComm")[0].value;
		var payComm1 = document.getElementsByName("iCommRateList[0].payComm")[0].value;
		$("#fatable tr input[type=text]:even").val(saleComm1);
		$("#fatable tr input[type=text]:odd").val(payComm1);
	}
</script>

</head>
<body>
	<form action="account.do?method=modifyInstitutionAcct" id="editInstitutionAccountForm" method="POST">
		<div class="pop-body">
		<table width="100%" border="0" cellspacing="0" cellpadding="0">
			<tr>
				<td align="right" >部门编码：</td>
				<td align="left"><input class="text-big-noedit" name="orgCode"
					value="${OrgAccts[0].orgCode }" readonly="readonly"></td>
				<td><span id="orgCodeTip" class="tip_init"></span></td>
			</tr>
			
			<tr>
				<td align="right">部门名称：</td>
				<td align="left" id="orgName"><input class="text-big-noedit"
					name="orgName" value="${OrgAccts[0].orgName }" readonly="readonly"></td>
				<td><span id="orgNameTip" class="tip_init"></span></td>
			</tr>

			<tr>
				<td align="right">信用额度：</td>
				<td align="left"><input name="creditLimit" class="text-big"
					id="creditLimit" value="${OrgAccts[0].creditLimit }" 
					maxlength="10" oninput="filterInput(this)"/></td>
				<td><span id="creditLimitTip" class="tip_init"></span></td>
			</tr>
	   </table>
	   <c:if test="${applicationScope.useCompany == 2}">
	<div style="padding: 0 20px; margin-top: 15px;">
		<div style="position: relative; z-index: 1000px;">
			<table class="datatable" id="table1_head" width="100%">
				<tbody>
					<tr>
						<th width="25%">方案名称</th>
						<th width="2%">|</th>
						<th width="25%">销售提成比例</th>
						<th width="2%">|</th>
						<th width="25%">兑奖提成比例</th>
						<th width="2%">|</th>
						<th width="25%">操作</th>
					</tr>
				</tbody>
			</table>
		</div>
		<div id="box" style="border: 1px solid #ccc;">
			<table id="fatable" class="datatable" cellpadding="0" cellspacing="0" width="100%">
				<tbody>
				
					<c:forEach var="rate" items="${OrgAccts}" varStatus="s">
					  <c:if test="${not empty rate.planCode}">
						<tr>
							<td width="25%">${rate.planName}  <%-- ${rate.planCode} --%>
								<input type="hidden" name="iCommRateList[${s.index}].planCode"
								value="${rate.planCode }" /> 
							</td>

							<td width="2%">&nbsp;</td>

							<td width="25%"><input type="text"
								name="iCommRateList[${s.index}].saleComm"
								value="${rate.saleComm}" size="10" maxlength="4"
								oninput="filterInput(this)"/> ‰ <input type="hidden"
								name="iCommRateList[${s.index}].orgCode"
								value="${OrgAccts[0].orgCode }" /></td>
							<td width="2%">&nbsp;</td>
							<td width="25%"><input type="text"
								name="iCommRateList[${s.index}].payComm"
								value="${rate.payComm}" size="10" maxlength="4"
								oninput="filterInput(this)"/> ‰
							</td>
							<td width="2%">&nbsp;</td>
							<td width="25%">
								<c:if test="${s.index == 0 }">
									<img alt="复制到所有" title="复制到所有" src="views/capital/outletAccounts/img/copy-btn.png" width="20" height="20" onclick="pasteAll(this);">
								</c:if>
								<c:if test="${s.index > 0 }">
									<img alt="复制第一行" title="复制第一行" src="views/capital/outletAccounts/img/copy-btn.png" width="20" height="20" onclick="paste(this);">
								</c:if>
							</td>
						</tr>
				</c:if> 
					</c:forEach>
					
				</tbody>
			</table>
		</div>
	</div>
	</c:if>
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