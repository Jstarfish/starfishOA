<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/views/common/taglibs.jsp"%>
<%@ include file="/views/common/meta.jsp"%>

<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>Payout</title>
<link rel="stylesheet" href="${basePath}/component/messageBox/myJsBox.css" type="text/css"/>
<link rel="stylesheet" type="text/css" href="${basePath}/css/validate.css" />
<script type="text/javascript"
	src="${basePath}/views/inventory/goodsReceipts/js/myJs.js"></script>
<script type="text/javascript" src="${basePath}/js/jquery/jquery-1.9.1.js"></script>
<script type="text/javascript" src="${basePath}/component/messageBox/myJsBox_zh.js"></script>
<link rel="stylesheet" type="text/css" href="${basePath}/css/style.css" />
<link href="${basePath}/views/inventory/goodsReceipts/css/style3.css" rel="stylesheet" type="text/css" />

<style type="text/css">
body {
	margin: 0;
	padding: 0;
	margin: 0px;
	padding: 0px;
	font: 14px/20px "微软雅黑", Arial, Helvetica, sans-serif;
	background: #f2f1f1;
	width: 100%;
	height: 100%;
}

.querymy_input {
	border: 1px solid #40a7da;
	background-color: #FFF;
	width: 200px;
	height: 28px;
	line-height: 28px;
	color: #000;
	font-size: 14px;
}

ul {
	list-style: none;
}

a {
	text-decoration: none;
}
</style>
<script type="text/javascript">
	function doSubmit() {
		
		$("#goodReceiptParamt").submit();
	
	}
</script>
</head>

<body>
	<form method="post"  id="goodReceiptParamt" name="goodReceiptParamt" action="payout.do?method=secStep">

		<div id="container">
			<!--header-->
			<div class="header">
				<div id="title">兑奖</div>
			</div>
			<div id="main">
				<div class="jdt">
					<img src="views/inventory/goodsReceipts/images/jdt3_2.png" width="1000"
						height="30" />
					<div class="xd">
						<span></span><span class="zi">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;1.扫描安全码</span><span class="zi">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;2.中奖票信息</span><span>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;3.完善个人资料</span>
					</div>
				</div>
				<div class="bd">
					<table width="100%" border="0" align="center" cellpadding="0" cellspacing="0">
						<tr>
							<td><div class="tab">
									<div class="tabn">
										<table border="0" cellpadding="0" cellspacing="0" width="100%;"
											valign="top">
											<tr>
												<td>
													<table border="0" cellpadding="0" cellspacing="0" height="100%"
														width="100%">
														<tr>
														<td class="lz1">&nbsp;</td>
															<td width="35%">&nbsp;
															<td width="13%"></td>
														</tr>
														<tr>
															<td class="lz1" width="35%">方案名称和批次编号:</td>
															<td width="35%">${packInfo.planName}&nbsp;&nbsp;&nbsp;${packInfo.batchCode}
															<td width="13%"></td>
														</tr>
														<tr>
															<td class="lz1">中奖票信息 :</td>
															<td width="35%">${trunkBox}
															<td width="13%"></td>
														</tr>
														<tr>
															<td class="lz1">中奖金额 :</td>
															<td width="35%">${amount}
															<td width="13%"></td>
														</tr>
														<tr>
															<td colspan="4">
																<div style="margin-top: 10px;margin-right:40px; float: right;">
																	<button type="button" class="gl-btn2" onclick="doSubmit()">下一步</button>
																</div>
															</td>
														</tr>
													</table>
										</table>
									</div>
								</div></td>
						</tr>
					</table>
				</div>
			</div>
		</div>
	</form>
</body>
</html>
