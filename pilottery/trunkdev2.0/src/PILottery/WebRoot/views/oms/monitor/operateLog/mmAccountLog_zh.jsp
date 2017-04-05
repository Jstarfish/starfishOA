
<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8"%>
<%@ include file="/views/common/taglibs.jsp"%>
<%@ include file="/views/common/meta.jsp"%>
<html>
<head>
<title>编辑市场管理员账户日志</title>
<link rel="stylesheet" type="text/css" href="${basePath}/css/style.css" />
<link rel="stylesheet" type="text/css" href="${basePath}/css/pop-up.css" />
<link rel="stylesheet" type="text/css" href="${basePath}/css/validate.css" />
<link rel="stylesheet" href="${basePath}/component/messageBox/myJsBox.css" type="text/css" />
<script type="text/javascript" src="${basePath}/component/messageBox/myJsBox_zh.js"></script>
<script type="text/javascript" src="${basePath}/js/myJs.js"></script>
<script type="text/javascript" src="${basePath}/js/jquery/jquery-1.9.1.js"></script>

</head>
<body>
	<form>
		<div class="pop-body">
			<table width="100%" border="0" cellspacing="0" cellpadding="0">
				<tr>
					<td align="right" width="35%">市场管理员编号：</td>
					<td align="left" width="25%">${managerAccts.marketAdmin }</td>
					<td><span id="marketAdminTip" class="tip_init"></span></td>
				</tr>
				
				<tr>
					<td align="right">市场管理员姓名：</td>
					<td align="left">${managerAccts.realName }</td>
					<td><span id="realNameTip" class="tip_init"></span></td>
				</tr>

				<tr>
					<td align="right">信用额度：</td>
					<td align="left">${managerAccts.creditLimit }</td>
					<td><span id="creditLimitTip" class="tip_init"></span></td>
				</tr>
				
				<tr>
					<td align="right">佘票金额：</td>
					<td align="left">${managerAccts.maxAmountTickets }</td>
					<td><span id="maxAmountTicketsTip" class="tip_init"></span></td>
				</tr>
			</table>
		</div>
	</form>
</body>
</html>