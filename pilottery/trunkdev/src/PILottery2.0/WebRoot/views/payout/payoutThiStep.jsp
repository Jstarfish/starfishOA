<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/views/common/taglibs.jsp"%>
<%@ include file="/views/common/meta.jsp"%>

<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>Payout</title>
<link rel="stylesheet" type="text/css" href="${basePath}/css/style.css" />
<link rel="stylesheet" type="text/css" href="${basePath}/css/pop-up.css" />
<link rel="stylesheet" type="text/css" href="${basePath}/css/validate.css" />
<link rel="stylesheet" href="${basePath}/component/messageBox/myJsBox.css"
	type="text/css" />
<script type="text/javascript" src="${basePath}/component/messageBox/myJsBox.js"></script>
<script type="text/javascript" src="${basePath}/js/myJs.js"></script>
<script type="text/javascript" src="${basePath}/js/jquery/jquery-1.9.1.js"></script>
<link href="${basePath}/views/inventory/goodsReceipts/css/style3.css"
	rel="stylesheet" type="text/css" />

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
#main .bd .tabn .tip_init{
    color: gray;
    font-size: 18px;
}
#main .bd .tabn .tip_error{
    color: red;
    font-size: 18px;
}
.querymy_input {
	width: 310px;
	height: 31px;
	border: 1px solid ;
	font-size: 18px;
	line-height: 30px;
	background-color: #FFF;
	font-family: "微软雅黑";
	padding-left: 3px;
}
ul {
	list-style: none;
}

a {
	text-decoration: none;
}
</style>
<script type="text/javascript" charset="UTF-8">

function Back(){
	window.location.href="payout.do?method=initProcessPayout";
}
	function doSubmit() {
		var canSubmit = true;
		if (!checkFormComm('goodReceiptParamt')) {
			canSubmit = false;
		}
		
		if (isNull(trim($("#winnerName").val()))) {
			ckSetFormOjbErrMsg('winnerName','Not empty.');
			canSubmit = false;
		}else{
			var tipObj = findObj("winnerNameTip");
			if(!isNullObj(tipObj)&&tipObj.className!="tip_error")
			{
				tipObj.innerText = '*';
			}
		}
		if (isNull(trim($("#contact").val()))) {
			ckSetFormOjbErrMsg('contact','Not empty.');
			canSubmit = false;
		}else{
			var tipObj = findObj("contactTip");
			if(!isNullObj(tipObj)&&tipObj.className!="tip_error"){
				tipObj.innerText = '*';
			}
		}
		if (isNull(trim($("#personalId").val()))) {
			ckSetFormOjbErrMsg('personalId','Not empty.');
			canSubmit = false;
		}else{
			var tipObj = findObj("personalIdTip");
			if(!isNullObj(tipObj)&&tipObj.className!="tip_error"){
				tipObj.innerText = '*';
			}
		}

		if (!doCheck("age", !isNull(trim($("#age").val())), 'Not empty.')) {
			canSubmit = false;
		} else {
			if (!doCheck("age", !isRangeIn($("#age").val()),
					"Age can not exceed 200.")) {
				canSubmit = false;
			}
		}
		if (canSubmit) {
			var url = "payout.do?method=thirdStep&winnerName="
					+ $("#winnerName").val() + "&sex=" + $(":radio[name='sex']:checked ").val()
					+ "&age=" + $("#age").val() + "&contact=" + $("#contact").val()
					+ "&personalId=" + $("#personalId").val()+ "&remark=" + $("#remark").val();
			$("#okBtn").hide();
			showPage(url, "Print");
		}
	}
	function isNull(data) {
		return (data == "" || data == undefined || data == null);
	}
	
	function isRangeIn(target) {
		var num = parseFloat(target);
		console.log(num);
		if (num<0 || num>200) {
			return true;
		}
		return false;
	}
</script>
</head>

<body>
	<form method="post" id="goodReceiptParamt" name="goodReceiptParamt"
		action="payout.do?method=thirdStep">

		<div id="container">
			<!--header-->
			<div class="header">
				<div id="title">Payout</div>
			</div>
			<div id="main">
				<div class="jdt">
					<img src="views/inventory/goodsReceipts/images/jdt3_3.png" width="1000"
						height="30" />
					<div class="xd">
						<span></span><span class="zi">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;1.Input Security Code</span><span class="zi">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;2.Ticket Information</span><span class="zi">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;3.Complete Personal Information</span>
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
															<td class="lz1">Name of Winner:</td>
															<td width="35%"><input class="querymy_input" name="winnerName"
																id="winnerName" type="text"  isCheckSpecialChar="true" cMaxByteLength="50"/></td>
															<td width="25%"><span id="winnerNameTip" class="tip_init">*1~50 characters</span></td>
														</tr>
														<tr>
															<td class="lz1">Gender:</td>
															<td width="35%"><input name="sex" id="sex" type="radio" value="1" checked/>Male<input
																name="sex" id="sex" type="radio" value="2" />Female</td>
															<td width="25%"><span id="sexTip" class="tip_init">*</span></td>
														</tr>
														<tr>
															<td class="lz1">Age:</td>
															<td width="35%"><input class="querymy_input" name="age" id="age"
																type="text" maxlength="3"
																oninput="this.value=this.value.replace(/[^\d,]/g,'')" /></td>
															<td width="25%"><span id="ageTip" class="tip_init">*1-200 years</span></td>
														</tr>
														<tr>
															<td class="lz1">Contact of Winner:</td>
															<td width="35%"><input class="querymy_input" name="contact"
																id="contact" type="text"  isCheckSpecialChar="true" cMaxByteLength="15"/></td>
															<td width="25%"><span id="contactTip" class="tip_init">*1~15 characters</span></td>
														</tr>
														<tr>
															<td class="lz1">Personal ID:</td>
															<td width="35%"><input class="querymy_input" name="personalId"
																id="personalId" type="text" isCheckSpecialChar="true" cMaxByteLength="30"/></td>
															<td width="25%"><span id="personalIdTip" class="tip_init">*1~30 characters</span></td>
														</tr>
														<tr>
															<td class="lz1">Remark:</td>
															<td width="35%">
																<textarea id="remark" name="remark" class="querymy_input" cMaxByteLength="500" isCheckSpecialChar="true" style="height:70px;width:310px;"></textarea>
															</td>
															<td width="25%"><span id="remarkTip" class="tip_init">0~500 characters</span></td>
														</tr>
														<tr>
															<td colspan="4">
																<div style="margin-top: 10px;margin-right:40px; float: right;">
																	<input type="button" class="gl-btn2" onclick="Back();"
																		id="okBack" value="Back  " />
																	<input type="button" class="gl-btn2" onclick="doSubmit();"
																		id="okBtn" value="Submit" />
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
