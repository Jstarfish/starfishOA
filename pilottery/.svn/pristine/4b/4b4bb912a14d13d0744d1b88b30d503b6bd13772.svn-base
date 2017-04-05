<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/views/common/taglibs.jsp"%>
<script type="text/javascript" src="${basePath}/js/jquery/jquery-1.9.1.js"></script>
<script type="text/javascript" src="${basePath}/js/jquery/jquery.form.js"></script>
<link rel="stylesheet" type="text/css" href="${basePath}/css/game.css"/>
<link rel="stylesheet" type="text/css" href="${basePath}/css/style.css"/>
<link rel="stylesheet" href="${basePath}/component/messageBox/myJsBox.css" type="text/css"/>
<script type="text/javascript" src="${basePath}/component/messageBox/myJsBox.js"></script>
<script type="text/javascript" src="${basePath}/js/myJs.js"></script>
<html>
<head>
<%@ include file="/views/common/meta.jsp" %>
<title></title>
<script type="text/javascript">
var checkFlag = false;
if('${gameManagementForm.gameParameterHistory.isOpenRisk}'=='1'){
	checkFlag = true;
}
</script>
<script type="text/javascript">
$(document).ready(function(){
	if(checkFlag){
		$("#riskButtonTd").show();
		$("#riskNULL").hide();
	}
	else{
		$("#riskButtonTd").hide();
		$("#riskNULL").show();
	}
	$('input[type=checkbox]').tzCheckbox({labels:['On','Off']});
});
function loadParam(gameCode){
	$("#gameManagementForm").attr("action","gameManagement.do?method=param&gameCode="+gameCode);
	$("#gameManagementForm").submit();
};

//异步编辑 (三)
function editGameParam(gameCode){
	$('#gameManagementForm').ajaxSubmit({
		type : 'POST',
		url : 'gameManagement.do?method=editGameParameter&gameCode='+gameCode,
		success : function(data) {
			$("#gameParameter").html(data);
		}
	});
};
//取消编辑（三）
function cancelEditGameParam(gameCode){
	$('#gameManagementForm').ajaxSubmit({
		type : 'POST',
		url : 'gameManagement.do?method=updateGameParameter&gameCode_='+gameCode,
		success : function(data) {
			$("#gameParameter").html(data);
		}
	});
};
//异步存储 (三)
function prompt3() {
	var singleLineMaxAmount = $("div#gameParameter [name='normalRuleParameter.singleLineMaxAmount']").val();
	if(singleLineMaxAmount == '' || singleLineMaxAmount == 'undefined'){
		showWarn('Maximum multiplier per betline cannot be empty');return false;
	}else if(singleLineMaxAmount >100 || singleLineMaxAmount <1){
		showWarn('Maximum multiplier per betline: range 1-100');return false;
	}
	var singleTicketMaxLine = $("div#gameParameter [name='normalRuleParameter.singleTicketMaxLine']").val();
	if(singleTicketMaxLine == '' || singleTicketMaxLine == 'undefined'){
		showWarn('Maximum betline number cannot be empty');return false;
	}else if(singleTicketMaxLine >10 || singleTicketMaxLine < 1){
		showWarn('Maximum betline number: range 1-10');return false;
	}
	var singleTicketMaxAmount = $("div#gameParameter [name='normalRuleParameter.singleTicketMaxAmount']").val();
	if(singleTicketMaxAmount == '' || singleTicketMaxAmount == 'undefined'){
		showWarn('Maximum sales limit per ticket cannot be empty');return false;
	}else if(singleTicketMaxAmount >100000000 || singleTicketMaxAmount <1){
		showWarn('Maximum sales limit per ticket: range 1-100,000,000');return false;
	}
	var msg = "Are you sure you want to update it?";
	showDialog("updateGameParam()","Confirm",msg);
}
function updateGameParam(){
	button_off("ok_button");
	$('#gameManagementForm').ajaxSubmit({
		type : 'POST',
		url : 'gameManagement.do?method=updateGameParameter',
		success : function(data) {
			$("#gameParameter").html(data);
			closeDialog();
		}
	});
};
//异步编辑 (四)
function editGameControlParameter(gameCode){
	$('#gameManagementForm').ajaxSubmit({
		type : 'POST',
		url : 'gameManagement.do?method=editGameControlParameter&gameCode='+gameCode,
		success : function(data) {
			$("#gameControlParameter").html(data);
		}
	});
};
//取消编辑（四）
function cancelEditGameControlParameter(gameCode){
	$('#gameManagementForm').ajaxSubmit({
		type : 'POST',
		url : 'gameManagement.do?method=updateGameControlParameter&gameCode_='+gameCode,
		success : function(data) {
			$("#gameControlParameter").html(data);
		}
	});
};
//异步存储  (四)
function prompt4() {
	var cancelSec = $("div#gameControlParameter [name='controlParameter.cancelSec']").val();
	if(cancelSec == '' || cancelSec == 'undefined'){
		showWarn('Allowable refund time cannot be empty');return false;
	}else if(cancelSec >1200 || cancelSec < 0){
		showWarn('Allowable refund time: range 0-1200');return false;
	}
	var issueCloseAlertTime = $("div#gameControlParameter [name='controlParameter.issueCloseAlertTime']").val();
	if(issueCloseAlertTime == '' || issueCloseAlertTime == 'undefined'){
		showWarn('Sales countdown cannot be empty');return false;
	}else if(issueCloseAlertTime >300 || issueCloseAlertTime < 1){
		showWarn('Sales countdown: range 1-300');return false;
	}
	/*
	var salerPayLimit = $("div#gameControlParameter [name='controlParameter.salerPayLimit']").val();
	if(salerPayLimit == '' || salerPayLimit == 'undefined'){
		showWarn('Payout limit cannot be empty');return false;
	}else if(salerPayLimit >16000000 || salerPayLimit < 1){
		showWarn('Payout limit: range 1-16000000');return false;
	}
	var salerCancelLimit = $("div#gameControlParameter [name='controlParameter.salerCancelLimit']").val();
	if(salerCancelLimit == '' || salerCancelLimit == 'undefined'){
		showWarn('Refund limit cannot be empty');return false;
	}else if(salerCancelLimit >16000000 || salerCancelLimit < 1){
		showWarn('Refund limit: range 1-16000000');return false;
	}
	var limitPayment2 = $("div#gameControlParameter [name='controlParameter.limitPayment2']").val();
	if(limitPayment2 == '' || limitPayment2 == 'undefined'){
		showWarn('Payout limit in 1st-level region cannot be empty');return false;
	}else if(limitPayment2 >80000000 || limitPayment2 < 1){
		showWarn('1st-level region payout limit: range 1-80000000');return false;
	}
	var limitCancel2 = $("div#gameControlParameter [name='controlParameter.limitCancel2']").val();
	if(limitCancel2 == '' || limitCancel2 == 'undefined'){
		showWarn('Refund limit in 1st-level region cannot be empty');return false;
	}else if(limitCancel2 >80000000 || limitCancel2 < 1){
		showWarn('1st-level region refund limit: range 1-80000000');return false;
	}*/
	var msg = "Are you sure you want to update it?";
	showDialog("updateGameControlParameter()","Confirm",msg);
}
function updateGameControlParameter(){ 
	button_off("ok_button");
	$('#gameManagementForm').ajaxSubmit({
		type : 'POST',
		url : 'gameManagement.do?method=updateGameControlParameter',
		success : function(data) {
			$("#gameControlParameter").html(data);
			closeDialog();
		}
	});
};
//异步编辑(六)
function editGamePrizeRule(gameCode){
	$('#gameManagementForm').ajaxSubmit({
		type : 'POST',
		url : 'gameManagement.do?method=checkIssueExist&gameCode='+gameCode,
		success : function(data) {
			if("true"==data){ 
				showWarn('Cannot edit when issue exists');
			}else{
				$('#gameManagementForm').ajaxSubmit({
					type : 'POST',
					url : 'gameManagement.do?method=editGamePrizeRule&gameCode='+gameCode,
					success : function(data) {
						$("#gamePrizeRule").html(data);
					}
				});
			}
		}
	});
};
//取消编辑（六）
function cancelEditGamePrizeRule(gameCode){
	$('#gameManagementForm').ajaxSubmit({
		type : 'POST',
		url : 'gameManagement.do?method=updateGamePrizeRule&gameCode_='+gameCode,
		success : function(data) {
			$("#gamePrizeRule").html(data);
		}
	});
};
//异步存储 (六)
function prompt6() {
	var fdbd = $("div#gamePrizeRule [name='fdbd']").val();
	var fdfd = $("div#gamePrizeRule [name='fdfd']").val();
	var fdmin = $("div#gamePrizeRule [name='fdmin']").val();
	if(fdbd == '' || fdbd == 'undefined'){
		showWarn('First-prize lower limit cannot be empty');return false;
	}
	if(fdfd == '' || fdfd == 'undefined'){
		showWarn('Cannot edit when issue exists');return false;
	}
	if(Number(fdfd) < Number(fdbd) && fdbd != 0 && fdfd != 0){
		showWarn('First-prize lower limit cannot be less than first-prize upper limit');return false;
	}
	if(fdmin == '' || fdmin == 'undefined'){
		showWarn('Chump change cannot be empty');return false;
	}else if(fdmin == 0){
		showWarn('Chump change cannot be zero');return false;
	}
	var msg = "Are you sure you want to update it?";
	showDialog("updateGamePrizeRule()","Confirm",msg);
}
function updateGamePrizeRule(){
	button_off("ok_button");
	$('#gameManagementForm').ajaxSubmit({
		type : 'POST',
		url : 'gameManagement.do?method=updateGamePrizeRule',
		success : function(data) {
			$("#gamePrizeRule").html(data);
			closeDialog();
		}
	});
};
//异步编辑(七)
function editRiskControl(gameCode){
	$('#gameManagementForm').ajaxSubmit({
		type : 'POST',
		url : 'gameManagement.do?method=checkIssueExist&gameCode='+gameCode,
		success : function(data) {
			if("true"==data){ 
				showWarn('Cannot edit when issue exists');
			}else{
				$('#gameManagementForm').ajaxSubmit({
					type : 'POST',
					url : 'gameManagement.do?method=editRiskControl&gameCode='+gameCode,
					success : function(data) {
						$("#riskControl").html(data);
					}
				});
			}
		}
	});
};
//取消编辑（七）
function cancelEditRiskControl(gameCode){
	$('#gameManagementForm').ajaxSubmit({
		type : 'POST',
		url : 'gameManagement.do?method=updateRiskControl&gameCode_='+gameCode,
		success : function(data) {
			$("#riskControl").html(data);
			$("#gameManagementForm").attr("action","gameManagement.do?method=param&gameCode="+gameCode);
			$("#gameManagementForm").submit();
		}
	});
};
//异步存储 (七)
function prompt7(gameCode) {
	var msg = "Are you sure you want to update it?";
	showDialog("updateRiskControl("+gameCode+")","Confirm",msg);
}
function updateRiskControl(gameCode){
	button_off("ok_button");
	$('#gameManagementForm').ajaxSubmit({
		type : 'POST',
		url : 'gameManagement.do?method=updateRiskControl',
		success : function(data) {
			$("#riskControl").html(data);
			closeDialog();
			$("#gameManagementForm").attr("action","gameManagement.do?method=param&gameCode="+gameCode);
			$("#gameManagementForm").submit();
		}
	});
};
function closeRisk(flag){
	var f ;
	if(flag){
		f=1;
		$("#riskButtonTd").show();
		$("#riskNULL").hide();
	}
	else{
		f=0;
		$("#riskButtonTd").hide();
		$("#riskNULL").show();
	}
	$('#gameManagementForm').ajaxSubmit({
		type : 'POST',
		url : 'gameManagement.do?method=closeRisk&gameCode=${gameManagementForm.gameParameterHistory.gameCode}&isOpenRisk='+f,
		success : function(data) {
		}
	});
}
(function($){
	$.fn.tzCheckbox = function(options){
		// Default On / Off labels:
		options = $.extend({
			labels : ['ON','OFF']
		},options);
		return this.each(function(){
			var originalCheckBox = $(this),
				labels = [];
			// Checking for the data-on / data-off HTML5 data attributes:
			if(originalCheckBox.data('on')){
				labels[0] = originalCheckBox.data('on');
				labels[1] = originalCheckBox.data('off');
			}
			else labels = options.labels;
			this.checked = checkFlag;
			// Creating the new checkbox markup:
			var checkBox = $('<span>',{
				className	: 'tzCheckBox '+(this.checked?'checked':''),
				id : 'tzCheckBox',
				html:	'<span class="tzCBContent">'+labels[this.checked?0:1]+
						'</span><span class="tzCBPart"></span>'
			});
			if(checkFlag){
				checkBox.toggleClass('checked');
				originalCheckBox.attr('checked',checkFlag);
				checkBox.find('.tzCBContent').html(labels[checkFlag?0:1]);
				document.getElementById('riskTab').style.display="";
			}else{
				document.getElementById('riskTab').style.display="none";
			}
			// Inserting the new checkbox, and hiding the original:
			checkBox.insertAfter(originalCheckBox.hide());
			checkBox.click(function(){
				$('#gameManagementForm').ajaxSubmit({
					type : 'POST',
					url : 'gameManagement.do?method=checkIssueExist&gameCode=${gameManagementForm.gameParameterHistory.gameCode}',
					success : function(data) {
						if("true"==data){ 
							showWarn('Cannot edit when issue exists');
						}else{
							checkBox.toggleClass('checked');
							
							var isChecked = checkBox.hasClass('checked');
							closeRisk(isChecked);
							if(isChecked){
								document.getElementById('riskTab').style.display="";
							}else{
								document.getElementById('riskTab').style.display="none";
							}
							
							originalCheckBox.attr('checked',isChecked);
							checkBox.find('.tzCBContent').html(labels[isChecked?0:1]);
						}
					}
				});
				
			});
			// Listening for changes on the original and affecting the new one:
			originalCheckBox.bind('change',function(){
				checkBox.click();
			});
		});
	};
})(jQuery);
function MM_swapImgRestore() { //v3.0
  var i,x,a=document.MM_sr; for(i=0;a&&i<a.length&&(x=a[i])&&x.oSrc;i++) x.src=x.oSrc;
}
function MM_preloadImages() { //v3.0
  var d=document; if(d.images){ if(!d.MM_p) d.MM_p=new Array();
    var i,j=d.MM_p.length,a=MM_preloadImages.arguments; for(i=0; i<a.length; i++)
    if (a[i].indexOf("#")!=0){ d.MM_p[j]=new Image; d.MM_p[j++].src=a[i];}}
}

function MM_findObj(n, d) { //v4.01
  var p,i,x;  if(!d) d=document; if((p=n.indexOf("?"))>0&&parent.frames.length) {
    d=parent.frames[n.substring(p+1)].document; n=n.substring(0,p);}
  if(!(x=d[n])&&d.all) x=d.all[n]; for (i=0;!x&&i<d.forms.length;i++) x=d.forms[i][n];
  for(i=0;!x&&d.layers&&i<d.layers.length;i++) x=MM_findObj(n,d.layers[i].document);
  if(!x && d.getElementById) x=d.getElementById(n); return x;
}

function MM_swapImage() { //v3.0
  var i,j=0,x,a=MM_swapImage.arguments; document.MM_sr=new Array; for(i=0;i<(a.length-2);i+=3)
   if ((x=MM_findObj(a[i]))!=null){document.MM_sr[j++]=x; if(!x.oSrc) x.oSrc=x.src; x.src=a[i+2];}
}
</script>
<style>

#tzCheckBox{
	background:url('${basePath}/img/background.png') no-repeat right bottom;
	display:inline-block;
	min-width:50px;
	height:20px;
	white-space:nowrap;
	position:relative;
	cursor:pointer;
	margin-left:14px;
    
}
#tzCheckBox.checked{
	background-position:top left;
	margin:0 14px 0 0;
}

#tzCheckBox .tzCBContent{
	color: white;
	line-height: 20px;
	padding-right: 38px;
	text-align: right;
	font-size:12px;
	font-family:"microsoft yahei";
}

#tzCheckBox.checked .tzCBContent{
	text-align:left;
	padding:0 0 0 38px;
}

.tzCBPart{
	background:url('${basePath}/img/background.png') no-repeat left bottom;
	width:14px;
	position:absolute;
	top:0;
	left:-14px;
	height:20px;
	overflow: hidden;
}

#tzCheckBox.checked .tzCBPart{
	background-position:top right;
	left:auto;
	right:-14px;
}

</style>
</head>
<body style="overflow-y:hidden;overflow-x:hidden;">
<div id="title">Game Parameters</div>
	<form:form modelAttribute="gameManagementForm">
	<div style="height:100%; width:100%;">
		<div id="left2">
			<ul>
				<c:forEach var="game" items="${games}">
					<c:if test="${gameManagementForm.styleId==game.gameCode}">
						<li class="demo">${game.shortName}</li>
					</c:if>
					<c:if test="${gameManagementForm.styleId!=game.gameCode}">
						<li><a href="#" onclick="loadParam(${game.gameCode});">${game.shortName}</a></li>
					</c:if>
				</c:forEach>
			</ul>
		</div>
		<div id="right2">
			<table width="100%" border="0" cellspacing="0" cellpadding="0">
				<tr>
					<td>
						<div style="float: left; position: relative; top: 50%; left: 10%;"></div>
					</td>
					<td><div class="game">
						  <div id="gameInfo">
							<div class="bg">
								<table width="100%" border="0" cellspacing="0" cellpadding="0" >
									<tr>
										<td class="title">
											<table width="100%" border="0" cellspacing="0" cellpadding="0" style="color:#fff;font-size:18px;">
												<tr>
													<td width="51%">Basic Parameters</td>
													<!-- td width="37%" align="right"><a href="#"
														onclick="editGameInfo(${gameManagementForm.gameInfo.gameCode});"
														onmouseout="MM_swapImgRestore()"
														onmouseover="MM_swapImage('Image7','','${basePath}/img/edit-hover.png',1)"><img
															src="${basePath}/img/edit.png" width="32" height="42" title="编辑"
															id="Image7" /></a></td --> 
												</tr>
											</table></td>
									</tr>
									<tr>
										<td class="nr" >
										<div style="height:210px; overflow:auto;">
											<table width="100%" border="0" cellspacing="0"
												cellpadding="0" style="font-size:14px; color:#5e6d81; line-height:30px;">
												<tr>
													<td>Game Code：${gameManagementForm.gameInfo.gameCode}</td>
												</tr>
												<tr>
													<td>Game Tag：${gameManagementForm.gameInfo.gameMark}</td>
												</tr>
												<tr>
													<td>Game Name：${gameManagementForm.gameInfo.fullName}</td>
												</tr>
												<tr>
													<td>Game Abbr：${gameManagementForm.gameInfo.shortName}</td>
												</tr>
												<tr>
													<td>Game Type：
														<c:if test="${gameManagementForm.gameInfo.basicType==1}">Keno</c:if>
														<c:if test="${gameManagementForm.gameInfo.basicType==2}">Lotto</c:if>
														<c:if test="${gameManagementForm.gameInfo.basicType==3}">Digit</c:if>
														<c:if test="${gameManagementForm.gameInfo.basicType==4}">Sports</c:if>
													</td>
												</tr>
												<tr>
													<td>Issuance Company：${gameManagementForm.gameInfo.issuingOrganization}</td>
												</tr>
											</table>
										</div>
										</td>
									</tr>
								</table>
							</div>
							</div>
							<div id="gamePolicyParam">
							<div class="bg">
								<table width="100%" border="0" cellspacing="0" cellpadding="0">
									<tr>
										<td class="title1"><table width="100%" border="0" cellspacing="0" cellpadding="0" style="color:#fff;font-size:18px;">
												<tr>
													<td width="51%">Policy Parameters</td>
													<!-- td width="37%" align="right"><a href="#"
														onclick="editGamePolicyParam(${gameManagementForm.gamePolicyParam.gameCode});"
														onmouseout="MM_swapImgRestore()"
														onmouseover="MM_swapImage('Image9','','${basePath}/img/edit-hover.png',1)"><img
															src="${basePath}/img/edit.png" width="32" height="42" title="编辑"
															id="Image9" /></a></td --> 
												</tr>
											</table></td>
									</tr>
									<tr>
										<td class="nr">
										<div style="height:210px; overflow:auto;">
											<table width="100%" border="0" cellspacing="0"
												cellpadding="0" style="font-size:14px; color:#5e6d81; line-height:30px;">
												<tr>
													<td>Theoretical Payback Rate：${gameManagementForm.gamePolicyParam.theoryRate} ‰</td>
												</tr>
												<tr>
													<td>Charity Fund Rate：${gameManagementForm.gamePolicyParam.fundRate} ‰</td>
												</tr>
												<tr>
													<td>Adjustment Fund Rate：${gameManagementForm.gamePolicyParam.adjRate} ‰</td>
												</tr>
												<tr>
													<td>Tax Exemption Threshold：<fmt:formatNumber value="${gameManagementForm.gamePolicyParam.taxThreshold}" type="number"/> KHR
													</td>
												</tr>
												<tr>
													<td>Tax Rate：${gameManagementForm.gamePolicyParam.taxRate} ‰</td>
												</tr>
												<tr>
													<td>Payout Period：${gameManagementForm.gamePolicyParam.drawLimitDay} Days</td>
												</tr>
											</table>
										</div>
										</td>
									</tr>
								</table>
							</div>
							</div>
							<div id="gameParameter">
							<div class="bg">
								<table width="100%" border="0" cellspacing="0" cellpadding="0">
									<tr>
										<td class="title2"><table width="100%" border="0" cellspacing="0" cellpadding="0" style="color:#fff;font-size:18px;">
												<tr>
													<td>Rule Parameters</td>
													<td align="right"><a href="#"
														onclick="editGameParam(${gameManagementForm.normalRuleParameter.gameCode});"
														onmouseout="MM_swapImgRestore()"
														onmouseover="MM_swapImage('Image11','','${basePath}/img/edit-hover.png',1)"><img
															src="${basePath}/img/edit.png" width="32" height="42" title="Edit"
															id="Image11" /></a></td>
												</tr>
											</table></td>
									</tr>
									<tr>
										<td class="nr">
										<div style="height:210px; overflow:auto;">
											<table width="100%" border="0" cellspacing="0"
												cellpadding="0" style="font-size:14px; color:#5e6d81; line-height:30px;">
												<tr>
													<td>Draw Mode：
															<c:if test="${gameManagementForm.normalRuleParameter.drawMode==1}">Quick-draw</c:if>
															<c:if test="${gameManagementForm.normalRuleParameter.drawMode==2}">Internal</c:if>
															<c:if test="${gameManagementForm.normalRuleParameter.drawMode==3}">External</c:if>
													</td>
												</tr>
												<tr>
													<td>Cost per Bet：<fmt:formatNumber value="${gameManagementForm.normalRuleParameter.singleBetAmount}" type="number"/> Riels</td>
												</tr>
												<tr>
													<td>Max. Issues per Ticket：${gameManagementForm.normalRuleParameter.singleTicketMaxIssues}</td>
												</tr>
												<tr>
													<td>Max. Betlines per Ticket：${gameManagementForm.normalRuleParameter.singleTicketMaxLine}</td>
												</tr>
												<tr>
													<td>Max. Multiplier per Betline：${gameManagementForm.normalRuleParameter.singleLineMaxAmount}</td>
												</tr>
												<tr>
													<td>Max. Sales Amount per Ticket：<fmt:formatNumber value="${gameManagementForm.normalRuleParameter.singleTicketMaxAmount}" type="number"/> Riels</td>
												</tr>
												<tr>
													<td>
													Abandoned Award Destination：
															<c:if test="${gameManagementForm.normalRuleParameter.abandonRewardCollect==1}">Pool</c:if> 
															<c:if test="${gameManagementForm.normalRuleParameter.abandonRewardCollect==2}">Adjustment fund</c:if> 
															<c:if test="${gameManagementForm.normalRuleParameter.abandonRewardCollect==3}">Charity fund</c:if> 
													</td>
												</tr>
											</table>
										</div>
										</td>
									</tr>
								</table>
							</div>
							</div>
							<div id="gameControlParameter">
							<div class="bg">
								<table width="100%" border="0" cellspacing="0" cellpadding="0">
									<tr>
										<td class="title4"><table width="100%" border="0" cellspacing="0" cellpadding="0" style="color:#fff;font-size:18px;">
												<tr>
													<td>Control Parameters</td>
													<td align="right"><a href="#"
														onclick="editGameControlParameter(${gameManagementForm.controlParameter.gameCode});"
														onmouseout="MM_swapImgRestore()"
														onmouseover="MM_swapImage('Image21','','${basePath}/img/edit-hover.png',1)"><img
															src="${basePath}/img/edit.png" width="32" height="42" title="Edit"
															id="Image21" /></a></td>
												</tr>
											</table></td>
									</tr>
									<tr>
										<td class="nr">
										<div style="height:210px; overflow:auto;">
											<table width="100%" border="0" cellspacing="0"
												cellpadding="0" style="font-size:14px; color:#5e6d81; line-height:30px;">
												<tr>
													<td>Big-Prize Amount：<fmt:formatNumber type="number" value="${gameManagementForm.controlParameter.limitBigPrize}" /> Riels</td>
												</tr>
												<tr>
													<td>Payout Limit：<fmt:formatNumber type="number" value="${gameManagementForm.controlParameter.limitPayment}" /> Riels</td>
												</tr>
												<tr>
													<td>Allowable Refund Time：${gameManagementForm.controlParameter.cancelSec} Seconds</td>
												</tr>
												<tr>
													<td>Sales Countdown：${gameManagementForm.controlParameter.issueCloseAlertTime} Seconds</td>
												</tr>
												<!-- 
												<tr>
													<td>Common Teller Payout Limit：<fmt:formatNumber type="number" value="${gameManagementForm.controlParameter.salerPayLimit}" /> Riels</td>
												</tr>
												<tr>
													<td>Common Teller Refund Limit：<fmt:formatNumber type="number" value="${gameManagementForm.controlParameter.salerCancelLimit}" /> Riels</td>
												</tr>
												<tr>
													<td>Institution Payout Limit：<fmt:formatNumber type="number" value="${gameManagementForm.controlParameter.limitPayment2}" /> Riels</td>
												</tr>
												<tr>
													<td>Institution Refund Limit：<fmt:formatNumber type="number" value="${gameManagementForm.controlParameter.limitCancel2}" /> Riels</td>
												</tr> -->
											</table>
										</div>
										</td>
									</tr>
								</table>
							</div>
							</div>
							<div id="gameRule">
							<div class="bg">
								<table width="100%" border="0" cellspacing="0" cellpadding="0">
									<tr>
										<td class="title3"><table width="100%" border="0" cellspacing="0" cellpadding="0" style="color:#fff;font-size:18px;">
												<tr>
													<td>Subtype Rules</td>
													<!-- td align="right"><a href="#"
														onclick="editGameRule(${gameManagementForm.gameInfo.gameCode});"
														onmouseout="MM_swapImgRestore()"
														onmouseover="MM_swapImage('Image13','','${basePath}/img/edit-hover.png',1)"><img
															src="${basePath}/img/edit.png" width="32" height="42" title="编辑"
															id="Image13" /></a></td -->
												</tr>
											</table></td>
									</tr>
									<tr>
										<td class="nr">
										<div style="height:210px; overflow:auto;">
											<table width="100%" border="0" cellspacing="0"
												cellpadding="0" style="font-size:14px; color:#5e6d81; line-height:30px;" >
												<tr>
													<td width="40%">Subtype Name</td><td>Details</td>
												</tr>
												<c:forEach var="gameRule" items="${gameManagementForm.gameRuleList}" >
												<tr>
													<td>${gameRule.ruleName}</td>
													<td>${gameRule.ruleDesc}</td>
												</tr>
												</c:forEach>
											</table>
											</div>
										</td>
									</tr>
								</table>
							</div>
							</div>
							<div id="gameWinRule">
							<div class="bg">
								<table width="100%" border="0" cellspacing="0" cellpadding="0">
									<tr>
										<td class="title5"><table width="100%" border="0" cellspacing="0" cellpadding="0" style="color:#fff;font-size:18px;">
												<tr>
													<td>Winning Rules</td>
												</tr>
											</table></td>
									</tr>
									<tr>
										<td class="nr">
										<div style="height:210px; overflow:auto;">
											<table width="100%" border="0" cellspacing="0"
												cellpadding="0" style="font-size:14px; color:#5e6d81; line-height:30px;">
												<tr>
													<td width="40%">Rule Name</td>
													<td>Details</td>
												</tr>
												<c:forEach var="gameWinRule" items="${gameManagementForm.gameWinRuleList}">
												<tr>
													<td>${gameWinRule.wRuleName}</td>
													<td>${gameWinRule.wRuleDesc}</td>
												</tr>
												</c:forEach>
											</table>
										</div>
										</td>
									</tr>
								</table>
							</div>
							</div>
							<div id="gamePrizeRule">
							<div class="bg">
								<table width="100%" border="0" cellspacing="0" cellpadding="0">
									<tr>
										<td class="title">
											<table width="100%" border="0" cellspacing="0" cellpadding="0" style="color:#fff;font-size:18px;">
												<tr>
													<td>Prize Levels</td>
												</tr>
											</table></td>
									</tr>
									<tr>
										<td class="nr">
										<div style="height:210px; overflow:auto;">
											<table width="100%" border="0" cellspacing="0"
												cellpadding="0" style="font-size:14px; color:#5e6d81; line-height:30px;">
												<c:if test="${gameManagementForm.gameInfo.gameCode == 6}">
												<tr>
													<td colspan="3">Special Award Enabled：
														<c:if test="${gameManagementForm.isSpecial==1}">Yes</c:if>
														<c:if test="${gameManagementForm.isSpecial==0}">No</c:if>
													</td>
												</tr>
												</c:if>
												<c:if test="${gameManagementForm.gameInfo.gameCode == 7}">
												<tr>
										          	<td colspan="3">1st-Prize Lower Limit： 
										          		<fmt:formatNumber type="number" value="${gameManagementForm.fdbd}" /> Riels
										       	 	</td>
										       	</tr>
										       	<tr>
										          	<td colspan="3">1st-Prize Upper Limit： 
										          		<fmt:formatNumber type="number" value="${gameManagementForm.fdfd}" /> Riels
										       	 	</td>
										       	</tr>
										       	<tr>
										          	<td colspan="3">Chump Change： 
										          		<fmt:formatNumber type="number" value="${gameManagementForm.fdmin}" /> Riels
										       	 	</td>
										       	</tr>
												</c:if>
												<tr>
													<td width="33%">Prize</td>
													<td width="33%">Amount</td>
													<td width="34%">Details</td>
												</tr>
												<c:forEach var="prizeRule" items="${gameManagementForm.gamePrizeRuleList}" >
												<tr>
													<td>${prizeRule.pruleName}</td>
													<td><fmt:formatNumber type="number" value="${prizeRule.levelPrize}" /></td>
													<td>${prizeRule.pruleDesc}</td>
												</tr>
												</c:forEach>
											</table>
										</div>
										</td>
									</tr>
								</table>
							</div>
							</div>
							<div id="riskControl">
							<c:if test="${gameManagementForm.gameParameterHistory.gameCode==5}">
							<div class="bg">
								<table width="100%" border="0" cellspacing="0" cellpadding="0">
									<tr>
										<td class="title4"><table id="butt" width="100%" border="0" cellspacing="0" cellpadding="0" style="color:#fff;font-size:18px;">
												<tr>
													<td width="58%">Risk Control</td>
											        <td width="31%" align="right" ><input type="checkbox" id="ch_emails" name="ch_emails" data-on="开" data-off="关" checked="checked" /></td>
											        <td width="11%" align="right"><a href="#" onmouseout="MM_swapImgRestore()" onmouseover="MM_swapImage('Image19','','${basePath}/img/edit-hover.png',1)"></a></td>
													<td align="right" id="riskButtonTd"><a href="#"
														onclick="editRiskControl(${gameManagementForm.gameParameterHistory.gameCode});"
														onmouseout="MM_swapImgRestore()"
														onmouseover="MM_swapImage('Image15','','${basePath}/img/edit-hover.png',1)"><img
															src="${basePath}/img/edit.png" width="32" height="42" title="编辑"
															id="Image15" /></a></td>
													<td align="right" id="riskNULL"><p width="32" height="42"/></td>
												</tr>
											</table>
										</td>
									</tr>
									<tr>
										<td class="nr">
										<div style="height:210px; overflow:auto;">
											<table id="riskTab" width="100%" border="0" cellspacing="0" cellpadding="0" style="font-size:14px; color:#5e6d81; line-height:30px;">
												<tr>
													<td width="33%">Subtype</td>
													<td width="33%">Limited Number Of Bets</td>
												</tr>
												<c:forEach var="s" items="${riskControlListSSC}" >
												<tr>
													<td>${ruleMap[s.paramA]}</td>
													<td><fmt:formatNumber type="number" value="${s.paramB}" /></td>
												</tr>
												</c:forEach>
											</table>
										</div>
										</td>
									</tr>
								</table>
							</div>
							</c:if>
							<c:if test="${gameManagementForm.gameParameterHistory.gameCode==6}">
							<div class="bg">
								<table width="100%" border="0" cellspacing="0" cellpadding="0">
									<tr>
										<td class="title4"><table id="butt" width="100%" border="0" cellspacing="0" cellpadding="0" style="color:#fff;font-size:18px;">
												<tr>
													<td width="58%">Risk Control</td>
											        <td width="31%" align="right" ><input type="checkbox" id="ch_emails" name="ch_emails" data-on="On" data-off="Off" checked="checked" /></td>
											        <td width="11%" align="right"><a href="#" onmouseout="MM_swapImgRestore()" onmouseover="MM_swapImage('Image19','','${basePath}/img/edit-hover.png',1)"></a></td>
													<td align="right" id="riskButtonTd"><a href="#"
														onclick="editRiskControl(${gameManagementForm.gameParameterHistory.gameCode});"
														onmouseout="MM_swapImgRestore()"
														onmouseover="MM_swapImage('Image15','','${basePath}/img/edit-hover.png',1)"><img
															src="${basePath}/img/edit.png" width="32" height="42" title="Edit"
															id="Image15" /></a></td>
													<td align="right" id="riskNULL"><p width="32" height="42"/></td>
												</tr>
											</table>
										</td>
									</tr>
									<tr>
										<td class="nr">
										<div style="height:210px; overflow:auto;">
											<table id="riskTab" width="100%" border="0" cellspacing="0" cellpadding="0" style="font-size:14px; color:#5e6d81; line-height:30px;">
												<tr>
													<td width="33%">Subtype</td>
													<td width="33%">Threshold</td>
													<td width="34%">Compensation</td>
												</tr>
												<c:forEach var="s" items="${riskControlListTTY}" >
												<tr>
													<td>${ruleMap[s.temp_ruleCode]}</td>
													<td><fmt:formatNumber type="number" value="${s.temp_riskThreshold}" /></td>
													<td><fmt:formatNumber type="number" value="${s.temp_maxClaimsAmount}" /></td>
												</tr>
												</c:forEach>
											</table>
										</div>
										</td>
									</tr>
								</table>
							</div>
							</c:if>
							<c:if test="${gameManagementForm.gameParameterHistory.gameCode==11}">
							<div class="bg">
								<table width="100%" border="0" cellspacing="0" cellpadding="0">
									<tr>
										<td class="title4">
											<table id="butt" width="100%" border="0" cellspacing="0" cellpadding="0" style="color:#fff;font-size:18px;">
												<tr>
													<td width="58%">Risk Control</td>
													<td width="31%" align="right" ><input type="checkbox" id="ch_emails" name="ch_emails" data-on="On" data-off="Off" checked="checked" /></td>
													<td width="11%" align="right"><a href="#" onmouseout="MM_swapImgRestore()" onmouseover="MM_swapImage('Image19','','${basePath}/img/edit-hover.png',1)"></a></td>
													<td align="right" id="riskButtonTd"><a href="#"
														onclick="editRiskControl(${gameManagementForm.gameParameterHistory.gameCode});"
														onmouseout="MM_swapImgRestore()"
														onmouseover="MM_swapImage('Image15','','${basePath}/img/edit-hover.png',1)"><img
														src="${basePath}/img/edit.png" width="32" height="42" title="Edit"
														id="Image15" /></a></td>
													<td align="right" id="riskNULL"><p width="32" height="42"/></td>
												</tr>
											</table>
										</td>
									</tr>
									<tr>
										<td class="nr">
										<div style="height:210px; overflow:auto;">
											<table id="riskTab" width="100%" border="0" cellspacing="0" cellpadding="0" style="font-size:14px; color:#5e6d81; line-height:30px;">
												<tr>
													<td>Threshold</td>
													<td><fmt:formatNumber type="number" value="${riskControlK3.paramA}" /></td>
												</tr>
												<tr>
													<td>Compensation</td>
													<td><fmt:formatNumber type="number" value="${riskControlK3.paramB}" /></td>
												</tr>
											</table>
										</div>
										</td>
									</tr>
								</table>
							</div>
							</c:if>
							<c:if test="${gameManagementForm.gameParameterHistory.gameCode==12 or gameManagementForm.gameParameterHistory.gameCode==13}">
							<div class="bg">
								<table width="100%" border="0" cellspacing="0" cellpadding="0">
									<tr>
										<td class="title4">
											<table id="butt" width="100%" border="0" cellspacing="0" cellpadding="0" style="color:#fff;font-size:18px;">
												<tr>
													<td width="58%">Risk Control</td>
													<td width="31%" align="right" ><input type="checkbox" id="ch_emails" name="ch_emails" data-on="On" data-off="Off" checked="checked" /></td>
													<td width="11%" align="right"><a href="#" onmouseout="MM_swapImgRestore()" onmouseover="MM_swapImage('Image19','','${basePath}/img/edit-hover.png',1)"></a></td>
													<td align="right" id="riskButtonTd"><a href="#"
														onclick="editRiskControl(${gameManagementForm.gameParameterHistory.gameCode});"
														onmouseout="MM_swapImgRestore()"
														onmouseover="MM_swapImage('Image15','','${basePath}/img/edit-hover.png',1)"><img
														src="${basePath}/img/edit.png" width="32" height="42" title="Edit"
														id="Image15" /></a></td>
													<td align="right" id="riskNULL"><p width="32" height="42"/></td>
												</tr>
											</table>
										</td>
									</tr>
									<tr>
										<td class="nr">
										<div style="height:210px; overflow:auto;">
											<table id="riskTab" width="100%" border="0" cellspacing="0" cellpadding="0" style="font-size:14px; color:#5e6d81; line-height:30px;">
												<tr>
													<td>Threshold</td>
													<td><fmt:formatNumber type="number" value="${riskControl11X5.paramA}" /></td>
												</tr>
												<tr>
													<td>Compensation</td>
													<td><fmt:formatNumber type="number" value="${riskControl11X5.paramB}" /></td>
												</tr>
											</table>
										</div>
										</td>
									</tr>
								</table>
							</div>
							</c:if>
							</div>
							<div id="gamePool">
							<div class="bg">
								<table width="100%" border="0" cellspacing="0" cellpadding="0">
									<tr>
										<td class="title2"><table width="100%" border="0" cellspacing="0" cellpadding="0" style="color:#fff;font-size:18px;">
												<tr>
													<td>Pool Parameters</td>
												</tr>
											</table></td>
									</tr>
									<tr>
										<td class="nr">
										<div style="height:210px; overflow:auto;">
											<table width="100%" border="0" cellspacing="0"
												cellpadding="0" style="font-size:14px; color:#5e6d81; line-height:30px;">
												<tr>
													<td>Pool Name：${gameManagementForm.gamePool.poolName}</td>
												</tr>
												<tr>
													<td>Pool Details：${gameManagementForm.gamePool.poolDesc}</td>
												</tr>
											</table>
										</div>
										</td>
									</tr>
								</table>
							</div>
							</div>
						</div>
					</td>
				</tr>
			</table>
		</div>
	</div>
	</form:form>
</body>
</html>