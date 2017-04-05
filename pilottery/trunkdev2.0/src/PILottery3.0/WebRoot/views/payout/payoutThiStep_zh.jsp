<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/views/common/taglibs.jsp"%>
<%@ include file="/views/common/meta.jsp"%>

<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>兑奖</title>
<link rel="stylesheet" type="text/css" href="${basePath}/css/style.css" />
<link rel="stylesheet" type="text/css" href="${basePath}/css/pop-up.css" />
<link rel="stylesheet" type="text/css" href="${basePath}/css/validate.css" />
<link rel="stylesheet" href="${basePath}/component/messageBox/myJsBox.css"
	type="text/css" />
<script type="text/javascript" src="${basePath}/component/messageBox/myJsBox_zh.js"></script>
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
			ckSetFormOjbErrMsg('winnerName','不能为空.');
			canSubmit = false;
		}else{
			var tipObj = findObj("winnerNameTip");
			if(!isNullObj(tipObj)&&tipObj.className!="tip_error")
			{
				tipObj.innerText = '*';
			}
		}
		if (isNull(trim($("#contact").val()))) {
			ckSetFormOjbErrMsg('contact','不能为空');
			canSubmit = false;
		}else{
			var tipObj = findObj("contactTip");
			if(!isNullObj(tipObj)&&tipObj.className!="tip_error"){
				tipObj.innerText = '*';
			}
		}
		if (isNull(trim($("#personalId").val()))) {
			ckSetFormOjbErrMsg('personalId','不能为空');
			canSubmit = false;
		}else{
			var tipObj = findObj("personalIdTip");
			if(!isNullObj(tipObj)&&tipObj.className!="tip_error"){
				tipObj.innerText = '*';
			}
		}

		if (!doCheck("age", !isNull(trim($("#age").val())), '不能为空')) {
			canSubmit = false;
		} else {
			if (!doCheck("age", !isRangeIn($("#age").val()),
					"年龄不能超过200.")) {
				canSubmit = false;
			}
		}
		if (canSubmit) {
			var url = "payout.do?method=thirdStep&winnerName="
					+ $("#winnerName").val() + "&sex=" + $(":radio[name='sex']:checked ").val()
					+ "&age=" + $("#age").val() + "&contact=" + $("#contact").val()
					+ "&personalId=" + $("#personalId").val()+ "&remark=" + $("#remark").val();
			$("#okBtn").hide();
			showPage(url, "打印");
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
				<div id="title">兑奖</div>
			</div>
			<div id="main">
				<div class="jdt">
					<img src="views/inventory/goodsReceipts/images/jdt3_3.png" width="1000"
						height="30" />
					<div class="xd">
						<span class="zi" style="padding-left:200px; ">1.扫描安全码</span>
						<span class="zi" style="padding-left:165px; ">2.中奖票信息</span>
						<span class="zi" style="padding-left:185px; ">3.完善个人资料</span>
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
															<td class="lz1">中奖人姓名:</td>
															<td width="35%"><input class="text-big" name="winnerName" style="width:300px;"
																id="winnerName" type="text"  isCheckSpecialChar="true" cMaxByteLength="50"/></td>
															<td width="25%"><span id="winnerNameTip" class="tip_init">*1~50 字节</span></td>
														</tr>
														<tr>
															<td class="lz1">性别:</td>
															<td width="35%"><input name="sex" id="sex" type="radio" value="1" checked/>男<input
																name="sex" id="sex" type="radio" value="2" />女</td>
															<td width="25%"><span id="sexTip" class="tip_init">*</span></td>
														</tr>
														<tr>
															<td class="lz1">年龄:</td>
															<td width="35%"><input class="text-big" name="age" id="age"
																type="text" maxlength="3" style="width:300px;"
																oninput="this.value=this.value.replace(/[^\d,]/g,'')" /></td>
															<td width="25%"><span id="ageTip" class="tip_init">*1-200 岁</span></td>
														</tr>
														<tr>
															<td class="lz1">联系方式:</td>
															<td width="35%"><input class="text-big" name="contact"
																id="contact" type="text"  isCheckSpecialChar="true" cMaxByteLength="15" style="width:300px;"/></td>
															<td width="25%"><span id="contactTip" class="tip_init">*1~15 字节</span></td>
														</tr>
														<tr>
															<td class="lz1">身份证号:</td>
															<td width="35%"><input class="text-big" name="personalId"
																id="personalId" type="text" isCheckSpecialChar="true" cMaxByteLength="30" style="width:300px;"/></td>
															<td width="25%"><span id="personalIdTip" class="tip_init">*1~30 字节</span></td>
														</tr>
														<tr>
															<td class="lz1">备注:</td>
															<td width="35%">
																<textarea id="remark" name="remark" class="text-big remark" cMaxByteLength="500" isCheckSpecialChar="true" style="height:50px;width:300px;"></textarea>
															</td>
															<td width="25%"><span id="remarkTip" class="tip_init">0~500 字节</span></td>
														</tr>
														<tr>
															<td colspan="4">
																<div style="margin-top: 10px;margin-right:40px; float: right;">
																	<input type="button" class="gl-btn2" onclick="Back();"
																		id="okBack" value="返回  " />
																	<input type="button" class="gl-btn2" onclick="doSubmit();"
																		id="okBtn" value="提交" />
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
