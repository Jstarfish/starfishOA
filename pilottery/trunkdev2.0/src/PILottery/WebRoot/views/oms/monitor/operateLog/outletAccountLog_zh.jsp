<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8"%>
<%@ include file="/views/common/taglibs.jsp"%>
<%@ include file="/views/common/meta.jsp"%>
<html>
<head>
<title>站点账户日志详情</title>

<link rel="stylesheet" type="text/css" href="${basePath}/css/style.css" />
<link rel="stylesheet" type="text/css" href="${basePath}/css/pop-up.css" />
<link rel="stylesheet"
	href="${basePath}/component/messageBox/myJsBox.css" type="text/css" />
<link rel="stylesheet" type="text/css" href="${basePath}/css/validate.css" />
<script type="text/javascript" src="${basePath}/component/messageBox/myJsBox_zh.js"></script>
<script type="text/javascript" src="${basePath}/js/myJs.js"></script>
<script type="text/javascript" src="${basePath}/js/jquery/jquery-1.9.1.js"></script>
<script type="text/javascript" src="${basePath}/js/regexEnum.js"></script>

</head>
<body style="text-align: center">
	<form>
		<div class="pop-body">
			<table width="100%" border="0" cellspacing="0">
				<tr>
					<td align="right">站点编码：</td>
					<td align="left">${OutletAccts[0].agencyCode }</td>
					<td><span id="agencyCodeTip" class="tip_init"></span></td>
				</tr>

				<tr>
					<td align="right">站点名称：</td>
					<td align="left" id="agencyName">${OutletAccts[0].agencyName }</td>
					<td><span id="agencyNameTip" class="tip_init"></span></td>
				</tr>

				<tr>
					<td align="right">信用额度：</td>
					<td align="left">${OutletAccts[0].creditLimit }</td>
					<td><span id="creditLimitTip" class="tip_init"></span></td>
				</tr>
			</table>

			 <c:if test="${applicationScope.useCompany == 2}">
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

							<td width="25%">${rate.saleComm}&nbsp;‰</td>
							<td width="2%">&nbsp;</td>
							<td width="25%">${rate.payComm}&nbsp;‰</td>
					</tr>
					</c:if>
					</c:forEach>
				</tbody>
			</table>
		</div>
	</div>
	</c:if>
	</div>
	</form>
</body>
</html>