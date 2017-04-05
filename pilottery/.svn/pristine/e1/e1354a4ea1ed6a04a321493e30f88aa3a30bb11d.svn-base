
<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8"%>
<%@ include file="/views/common/taglibs.jsp"%>
<%@ include file="/views/common/meta.jsp"%>
<html>
<head>
<title>Edit Institution Log</title>
<link rel="stylesheet" type="text/css" href="${basePath}/css/style.css" />
<link rel="stylesheet" type="text/css" href="${basePath}/css/pop-up.css" />
<link rel="stylesheet" href="${basePath}/component/messageBox/myJsBox.css" type="text/css" />
<link rel="stylesheet" type="text/css" href="${basePath}/css/validate.css" />

<script type="text/javascript" src="${basePath}/component/messageBox/myJsBox_zh.js"></script>
<script type="text/javascript" src="${basePath}/component/My97DatePicker/WdatePicker.js"></script>
<script type="text/javascript" src="${basePath}/js/myJs.js"></script>
<script type="text/javascript" src="${basePath}/js/jquery/jquery-1.9.1.js"></script>
<script type="text/javascript" src="${basePath}/js/regexEnum.js"></script>

</head>
<body>
	<form>
		<div class="pop-body">
		<table width="100%" border="0" cellspacing="0" cellpadding="0">
			<tr>
				<td align="right" >Institution Code：</td>
				<td align="left">${OrgAccts[0].orgCode }</td>
				<td><span id="orgCodeTip" class="tip_init"></span></td>
			</tr>
			
			<tr>
				<td align="right">Institution Name：</td>
				<td align="left" id="orgName">${OrgAccts[0].orgName }</td>
				<td><span id="orgNameTip" class="tip_init"></span></td>
			</tr>

			<tr>
				<td align="right">Credit Limit：</td>
				<td align="left">${OrgAccts[0].creditLimit }</td>
				<td><span id="creditLimitTip" class="tip_init"></span></td>
			</tr>
	   </table>
	<div style="padding: 0 20px; margin-top: 15px;">
		<div style="position: relative; z-index: 1000px;">
			<table class="datatable" id="table1_head" width="100%">
				<tbody>
					<tr>
						<th width="25%">Plan Name</th>
						<th width="2%">|</th>
						<th width="25%">Sales Commission Rate</th>
						<th width="2%">|</th>
						<th width="25%">Payout Commission Rate</th>
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

							<td width="25%">${rate.saleComm}&nbsp; ‰ <input type="hidden"
								name="iCommRateList[${s.index}].orgCode"
								value="${OrgAccts[0].orgCode }" /></td>
							<td width="2%">&nbsp;</td>
							<td width="25%">${rate.payComm}&nbsp; ‰</td>
						</tr>
				</c:if> 
					</c:forEach>
				</tbody>
			</table>
		</div>
	</div>
	</div>
	</form>
</body>
</html>