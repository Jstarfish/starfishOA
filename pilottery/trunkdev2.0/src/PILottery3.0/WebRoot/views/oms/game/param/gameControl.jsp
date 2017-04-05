<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8"%>
<%@ include file="/views/common/taglibs.jsp"%>
<html>
<head>
<title></title>
<%@ include file="/views/common/meta.jsp"%>
<link rel="stylesheet" type="text/css" href="${basePath}/css/style.css" />
<link rel="stylesheet" type="text/css" href="${basePath}/css/game.css" />
<link rel="stylesheet"
	href="${basePath}/component/messageBox/myJsBox.css" type="text/css" />
<script type="text/javascript"
	src="${basePath}/js/jquery/jquery-1.9.1.js"></script>
<script type="text/javascript"
	src="${basePath}/js/jquery/jquery.form.js"></script>
<script type="text/javascript"
	src="${basePath}/component/messageBox/myJsBox.js"></script>
<script type="text/javascript" src="${basePath}/js/myJs.js"></script>
<script type="text/javascript">
	$(document).ready(function() {
		var isSale = $('#isSaleFlg').val();
		var isPay = $('#isPayFlg').val();
		var isCancel = $('#isCancelFlg').val();
		var isAutoDraw = $('#isAutoDrawFlg').val();
		onLoadBtn('isSaleBtn', isSale);
		onLoadBtn('isPayBtn', isPay);
		onLoadBtn('isCancelBtn', isCancel);
		onLoadBtn('isAutoDrawBtn', isAutoDraw);
	})

	function loadParam(gameCode) {
		$("#gameManagementForm").attr("action",
				"gameManagement.do?method=control&gameCode=" + gameCode);
		$("#gameManagementForm").submit();
	};

	//异步编辑
	function editGameParameter(gameCode, d) {
		$('#gameManagementForm')
				.ajaxSubmit(
						{
							type : 'POST',
							url : 'gameManagement.do?method=editControlParameter&gameCode='
									+ gameCode + '&d=' + d,
							success : function(data) {
								$("#gameParameter" + d).html(data);
							}
						});
	};
	function cancelEditGameParameter(gameCode, d) {
		$('#gameManagementForm')
				.ajaxSubmit(
						{
							type : 'POST',
							url : 'gameManagement.do?method=updateControlParameter&gameCode_='
									+ gameCode + '&d=' + d,
							success : function(data) {
								$("#gameParameter" + d).html(data);
							}
						});
	};
	//异步存储（数据库非空项判断）
	function prompt(d) {
		var msg = "Are you sure you want to update it?";
		showDialog("updateGameParameter(" + d + ")", "Confirm", msg);
	}
	function updateGameParameter(d) {
		button_off("ok_button");
		$('#gameManagementForm').ajaxSubmit(
				{
					type : 'POST',
					url : 'gameManagement.do?method=updateControlParameter'
							+ '&d=' + d,
					success : function(data) {
						$("#gameParameter" + d).html(data);
						closeDialog();
					}
				});
	};

	function onLoadBtn(btnId, flgValue) {
		if (flgValue == 1)
			document.getElementById(btnId).src = "${basePath}/img/on_en.png";
		if (flgValue == 0)
			document.getElementById(btnId).src = "${basePath}/img/off_en.png";
	}
	// 开关按钮，btnId（按钮Id）,flgId(状态Id)
	function doChange(btnId, flgId) {
		var msg = "Are you sure you want to change it?";
		showDialog("on_off('" + btnId + "','" + flgId + "')", "Confirm", msg);
	}
	function on_off(btnId, flgId) {
		closeDialog();
		if (document.getElementById(flgId).value == 1) {
			document.getElementById(btnId).src = "${basePath}/img/off_en.png";
			document.getElementById(flgId).value = 0;
		} else {
			document.getElementById(btnId).src = "${basePath}/img/on_en.png";
			document.getElementById(flgId).value = 1;
		}
		var sURL = "";
		if ("isSaleFlg" == flgId) {
			var isSale = $('#isSaleFlg').val();
			sURL = 'gameManagement.do?method=changeStatus&gameCode=${gameManagementForm.gameParameterDynamic.gameCode}&isSale='
					+ isSale;
		}
		if ("isCancelFlg" == flgId) {
			var isCancel = $('#isCancelFlg').val();
			sURL = 'gameManagement.do?method=changeStatus&gameCode=${gameManagementForm.gameParameterDynamic.gameCode}&isCancel='
					+ isCancel;
		}
		if ("isPayFlg" == flgId) {
			var isPay = $('#isPayFlg').val();
			sURL = 'gameManagement.do?method=changeStatus&gameCode=${gameManagementForm.gameParameterDynamic.gameCode}&isPay='
					+ isPay;
		}
		if ("isAutoDrawFlg" == flgId) {
			var isAutoDraw = $('#isAutoDrawFlg').val();
			sURL = 'gameManagement.do?method=changeStatus&gameCode=${gameManagementForm.gameParameterDynamic.gameCode}&isAutoDraw='
					+ isAutoDraw;
		}
		$('#gameManagementForm').ajaxSubmit({
			type : 'POST',
			url : sURL,
			success : function(data) {
			}
		});
		return false;
	}
	function MM_swapImgRestore() { //v3.0
		var i, x, a = document.MM_sr;
		for (i = 0; a && i < a.length && (x = a[i]) && x.oSrc; i++)
			x.src = x.oSrc;
	}
	function MM_preloadImages() { //v3.0
		var d = document;
		if (d.images) {
			if (!d.MM_p)
				d.MM_p = new Array();
			var i, j = d.MM_p.length, a = MM_preloadImages.arguments;
			for (i = 0; i < a.length; i++)
				if (a[i].indexOf("#") != 0) {
					d.MM_p[j] = new Image;
					d.MM_p[j++].src = a[i];
				}
		}
	}

	function MM_findObj(n, d) { //v4.01
		var p, i, x;
		if (!d)
			d = document;
		if ((p = n.indexOf("?")) > 0 && parent.frames.length) {
			d = parent.frames[n.substring(p + 1)].document;
			n = n.substring(0, p);
		}
		if (!(x = d[n]) && d.all)
			x = d.all[n];
		for (i = 0; !x && i < d.forms.length; i++)
			x = d.forms[i][n];
		for (i = 0; !x && d.layers && i < d.layers.length; i++)
			x = MM_findObj(n, d.layers[i].document);
		if (!x && d.getElementById)
			x = d.getElementById(n);
		return x;
	}

	function MM_swapImage() { //v3.0
		var i, j = 0, x, a = MM_swapImage.arguments;
		document.MM_sr = new Array;
		for (i = 0; i < (a.length - 2); i += 3)
			if ((x = MM_findObj(a[i])) != null) {
				document.MM_sr[j++] = x;
				if (!x.oSrc)
					x.oSrc = x.src;
				x.src = a[i + 2];
			}
	}
	//校验服务时间格式
	function checkRegex(id) {
		var value = $('#' + id).val();
		var patrn = /^([1]?[0-9]|2[0-3]):[0-5][0-9]-([1]?[0-9]|2[0-3]):[0-5][0-9]$/;
		if (value != '' && !patrn.test(value)) {
			showWarn("Invalid time format!");
		}
	}
</script>
</head>
<body>
	<div id="title">Game Controls</div>
	<form:form modelAttribute="gameManagementForm">
		<div id="left2">
			<ul>
				<c:forEach var="game" items="${games}">
					<c:if test="${gameManagementForm.styleId==game.gameCode}">
						<li class="demo">${game.shortName}</li>
					</c:if>
					<c:if test="${gameManagementForm.styleId!=game.gameCode}">
						<li><a href="#" onclick="loadParam('${game.gameCode}');">${game.shortName}</a></li>
					</c:if>
				</c:forEach>
			</ul>
		</div>
		<div id="right2">
			<table width="100%" border="0" cellspacing="0" cellpadding="0">
				<tr>
					<td></td>
					<td><div
							style="height: 80px; margin-top: 20px; margin-left: 2%; margin-right: 6%; background: lightgray;">

							<table width="100%" border="0" cellspacing="0" cellpadding="0"
								style="height: 70px;">
								<tr style="height: 10px">
									<td></td>
									<td></td>
								</tr>
								<c:choose>
									<c:when test="${gameManagementForm.gameIssue.gameCode == 14 }">
										<c:if
											test="${gameManagementForm.gameIssue.issueNumber == null}">
											<tr>
												<td rowspan="3" width="30%"><h3
														style="margin-top: 20px;">&nbsp;&nbsp;&nbsp;&nbsp;No
														current issue</h3></td>
											</tr>
										</c:if>
										<c:if
											test="${gameManagementForm.gameIssue.issueNumber != null}">
											<tr>
												<td rowspan="2" width="30%"><h3
														style="margin-top: 20px;">&nbsp;&nbsp;${gameInfoMap[gameManagementForm.gameIssue.gameCode]}:&nbsp;${gameManagementForm.gameIssue.issueNumber}</h3></td>
												<td>Issue Start Time：<fmt:formatDate
														value="${gameManagementForm.gameIssue.realStartTime}"
														pattern="yyyy-MM-dd HH:mm:ss" /></td>
											</tr>
											<tr>
												<td>Issue End Time： <c:if
														test="${gameManagementForm.gameIssue.realCloseTime!=null}">
														<fmt:formatDate
															value="${gameManagementForm.gameIssue.realCloseTime}"
															pattern="yyyy-MM-dd HH:mm:ss" />
													</c:if> <c:if
														test="${gameManagementForm.gameIssue.realCloseTime==null}">
														<fmt:formatDate
															value="${gameManagementForm.gameIssue.planCloseTime}"
															pattern="yyyy-MM-dd HH:mm:ss" />
													</c:if>
												</td>
											</tr>
										</c:if>
									</c:when>
									<c:otherwise>
										<c:if
											test="${gameManagementForm.gameIssue.issueNumber == null}">
											<tr>
												<td rowspan="3" width="30%"><h3
														style="margin-top: 20px;">&nbsp;&nbsp;&nbsp;&nbsp;No
														current issue</h3></td>
											</tr>
										</c:if>
										<c:if
											test="${gameManagementForm.gameIssue.issueNumber != null}">
											<tr>
												<td rowspan="2" width="30%"><h3
														style="margin-top: 20px;">&nbsp;&nbsp;${gameInfoMap[gameManagementForm.gameIssue.gameCode]}:&nbsp;${gameManagementForm.gameIssue.issueNumber}</h3></td>
												<td>Issue Start Time：<fmt:formatDate
														value="${gameManagementForm.gameIssue.realStartTime}"
														pattern="yyyy-MM-dd HH:mm:ss" /></td>
												<td>Current Issue Status：${issueStatusValue}</td>
											</tr>
											<tr>
												<td>Issue End Time： <c:if
														test="${gameManagementForm.gameIssue.realCloseTime!=null}">
														<fmt:formatDate
															value="${gameManagementForm.gameIssue.realCloseTime}"
															pattern="yyyy-MM-dd HH:mm:ss" />
													</c:if> <c:if
														test="${gameManagementForm.gameIssue.realCloseTime==null}">
														<fmt:formatDate
															value="${gameManagementForm.gameIssue.planCloseTime}"
															pattern="yyyy-MM-dd HH:mm:ss" />
													</c:if>
												</td>
												<td>Pool
													Amount：${gameManagementForm.gamePool.poolAmountAfter}</td>
											</tr>
										</c:if>
									</c:otherwise>

								</c:choose>
							</table>
						</div></td>
				</tr>
				<tr>
					<td><div
							style="float: left; position: relative; top: 50%; left: 10%;"></div></td>
					<td><div style="margin-left: 2%; margin-top: 20px">
							<div id="gameParameter1">
								<div class="bg" style="margin-right: 2%">
									<table width="100%" border="0" cellspacing="0" cellpadding="0">
										<tr>
											<td class="title">
												<table width="100%" border="0" cellspacing="0"
													cellpadding="0" style="color: #fff; font-size: 18px;">
													<tr>
														<td width="51%">Transaction Control</td>
													</tr>
												</table>
											</td>
										</tr>
										<tr>
											<td class="nr" style="height: 200px">
												<table width="100%" border="0" cellspacing="0"
													cellpadding="0"
													style="font-size: 14px; color: #5e6d81; line-height: 30px;">
													<tr>
														<td>Sale：&nbsp; &nbsp; &nbsp; <img id="isSaleBtn"
															src="${basePath}/img/on_en.png"
															style="vertical-align: middle;"
															onclick="return doChange('isSaleBtn', 'isSaleFlg') " /> <form:hidden
																path="gameParameterDynamic.isSale" id="isSaleFlg" />
														</td>
													</tr>
													<tr>
														<td>Payout： <img id="isPayBtn"
															src="${basePath}/img/on_en.png"
															style="vertical-align: middle;"
															onclick="return doChange('isPayBtn', 'isPayFlg') " /> <form:hidden
																path="gameParameterDynamic.isPay" id="isPayFlg" />
														</td>
													</tr>
													<tr>
														<td>Refund： <img id="isCancelBtn"
															src="${basePath}/img/on_en.png"
															style="vertical-align: middle;"
															onclick="return doChange('isCancelBtn', 'isCancelFlg') " />
															<form:hidden path="gameParameterDynamic.isCancel"
																id="isCancelFlg" />
														</td>
													</tr>

												</table>
											</td>
										</tr>
									</table>
								</div>
							</div>

							<div id="gameParameter2">
								<div class="bg" style="margin-right: 2%">
									<table width="100%" border="0" cellspacing="0" cellpadding="0">
										<tr>
											<td class="title1">
												<table width="100%" border="0" cellspacing="0"
													cellpadding="0" style="color: #fff; font-size: 18px;">
													<tr>
														<td width="51%">Warning Limit</td>
														<td width="37%" align="right"><a href="#"
															onclick="editGameParameter('${gameManagementForm.gameParameterDynamic.gameCode}',2);"
															onmouseout="MM_swapImgRestore()"
															onmouseover="MM_swapImage('Image7','','${basePath}/img/edit-hover.png',1)"><img
																src="${basePath}/img/edit.png" width="32" height="42"
																id="Image7" /></a></td>
													</tr>
												</table>
											</td>
										</tr>
										<tr>
											<td class="nr" style="height: 200px">
												<table width="100%" border="0" cellspacing="0"
													cellpadding="0"
													style="font-size: 14px; color: #5e6d81; line-height: 30px;">
													<tr>
														<td>Ticket Sales Limit：<fmt:formatNumber
																type="number"
																value="${gameManagementForm.gameParameterDynamic.auditSingleTicketSale}" />
															KHR
														</td>
													</tr>
													<tr>
														<td>Ticket Payout Limit：<fmt:formatNumber
																type="number"
																value="${gameManagementForm.gameParameterDynamic.auditSingleTicketPay}" />
															KHR
														</td>
													</tr>
													<tr>
														<td>Ticket Refund Limit：<fmt:formatNumber
																type="number"
																value="${gameManagementForm.gameParameterDynamic.auditSingleTicketCancel}" />
															KHR
														</td>
													</tr>
												</table>
											</td>
										</tr>
									</table>
								</div>
							</div>

							<div id="gameParameter3">
								<div class="bg" style="margin-right: 2%">
									<table width="100%" border="0" cellspacing="0" cellpadding="0">
										<tr>
											<td class="title2">
												<table width="100%" border="0" cellspacing="0"
													cellpadding="0" style="color: #fff; font-size: 18px;">
													<tr>
														<td width="51%">Service Period</td>
														<td width="37%" align="right"><a href="#"
															onclick="editGameParameter('${gameManagementForm.gameParameterDynamic.gameCode}',3);"
															onmouseout="MM_swapImgRestore()"
															onmouseover="MM_swapImage('Image7','','${basePath}/img/edit-hover.png',1)"><img
																src="${basePath}/img/edit.png" width="32" height="42"
																id="Image7" /></a></td>
													</tr>
												</table>
											</td>
										</tr>
										<tr>
											<td class="nr" style="height: 200px">
												<table width="100%" border="0" cellspacing="0"
													cellpadding="0"
													style="font-size: 14px; color: #5e6d81; line-height: 30px;">
													<tr>
														<td>Service Period
															1：${gameManagementForm.gameParameterDynamic.serviceTime1}</td>
													</tr>
													<tr>
														<td>Service Period
															2：${gameManagementForm.gameParameterDynamic.serviceTime2}</td>
													</tr>
												</table>
											</td>
										</tr>
									</table>
								</div>
							</div>
							<c:if
								test="${gameManagementForm.gameParameterDynamic.gameCode==12 || gameManagementForm.gameParameterDynamic.gameCode==11 || gameManagementForm.gameParameterDynamic.gameCode==5}">
								<div id="gameParameter4">
									<div class="bg" style="margin-right: 2%">
										<table width="100%" border="0" cellspacing="0" cellpadding="0">
											<tr>
												<td class="title3">
													<table width="100%" border="0" cellspacing="0"
														cellpadding="0" style="color: #fff; font-size: 18px;">
														<tr>
															<td width="51%">Auto Drawing</td>
														</tr>
													</table>
												</td>
											</tr>
											<tr>
												<td class="nr" style="height: 200px;">
													<table width="100%" border="0" cellspacing="0"
														cellpadding="0"
														style="font-size: 14px; color: #5e6d81; line-height: 30px;">
														<tr>
															<td>Auto-Draw Enabled： <img id="isAutoDrawBtn"
																src="${basePath}/img/on_en.png"
																style="vertical-align: middle;"
																onclick="return doChange('isAutoDrawBtn', 'isAutoDrawFlg') " />
																<form:hidden path="gameParameterDynamic.isAutoDraw"
																	id="isAutoDrawFlg" />
															</td>
														</tr>
													</table>
												</td>
											</tr>
										</table>
									</div>
								</div>
							</c:if>
						</div></td>
				</tr>
			</table>
		</div>
	</form:form>
</body>
</html>