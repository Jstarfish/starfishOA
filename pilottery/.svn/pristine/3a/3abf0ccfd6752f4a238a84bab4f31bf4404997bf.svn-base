<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/views/common/taglibs.jsp"%>
<script type="text/javascript" src="${basePath}/js/jquery/jquery-1.9.1.js"></script>
<script type="text/javascript" src="${basePath}/js/jquery/jquery.form.js"></script>
<link rel="stylesheet" type="text/css" href="${basePath}/css/game.css"/>
<link rel="stylesheet" type="text/css" href="${basePath}/css/style.css"/>
<link rel="stylesheet" href="${basePath}/component/messageBox/myJsBox.css" type="text/css"/>
<script type="text/javascript" src="${basePath}/component/messageBox/myJsBox_zh.js"></script>
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
	$('input[type=checkbox]').tzCheckbox({labels:['开','关']});
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
		showWarn('单行最大倍数不能为空');return false;
	}else if(singleLineMaxAmount >100 || singleLineMaxAmount <1){
		showWarn('单行最大倍数：输入范围1-100');return false;
	}
	var singleTicketMaxLine = $("div#gameParameter [name='normalRuleParameter.singleTicketMaxLine']").val();
	if(singleTicketMaxLine == '' || singleTicketMaxLine == 'undefined'){
		showWarn('单票最大投注行数不能为空');return false;
	}else if(singleTicketMaxLine >10 || singleTicketMaxLine < 1){
		showWarn('单票最大投行数：输入范围1-10');return false;
	}
	var singleTicketMaxAmount = $("div#gameParameter [name='normalRuleParameter.singleTicketMaxAmount']").val();
	if(singleTicketMaxAmount == '' || singleTicketMaxAmount == 'undefined'){
		showWarn('单票最大销售限额不能为空');return false;
	}else if(singleTicketMaxAmount >100000000 || singleTicketMaxAmount <1){
		showWarn('单票最大销售限额：输入范围1-1亿');return false;
	}
	var msg = "你确定要修改该项吗?";
	showDialog("updateGameParam()","确认",msg);
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
		showWarn('允许退票时间不能为空');return false;
	}else if(cancelSec >1200 || cancelSec < 0){
		showWarn('允许退票时间：输入范围0-1200');return false;
	}
	var issueCloseAlertTime = $("div#gameControlParameter [name='controlParameter.issueCloseAlertTime']").val();
	if(issueCloseAlertTime == '' || issueCloseAlertTime == 'undefined'){
		showWarn('销售关闭倒数时间不能为空');return false;
	}else if(issueCloseAlertTime >300 || issueCloseAlertTime < 1){
		showWarn('销售关闭倒数时间：范围1-300');return false;
	}
	/*
	var salerPayLimit = $("div#gameControlParameter [name='controlParameter.salerPayLimit']").val();
	if(salerPayLimit == '' || salerPayLimit == 'undefined'){
		showWarn('兑奖限额不能为空');return false;
	}else if(salerPayLimit >16000000 || salerPayLimit < 1){
		showWarn('兑奖限额：范围1-16000000');return false;
	}
	var salerCancelLimit = $("div#gameControlParameter [name='controlParameter.salerCancelLimit']").val();
	if(salerCancelLimit == '' || salerCancelLimit == 'undefined'){
		showWarn('退票限额不能为空');return false;
	}else if(salerCancelLimit >16000000 || salerCancelLimit < 1){
		showWarn('退票限额：范围1-16000000');return false;
	}
	var limitPayment2 = $("div#gameControlParameter [name='controlParameter.limitPayment2']").val();
	if(limitPayment2 == '' || limitPayment2 == 'undefined'){
		showWarn('一级区域兑奖限额不能为空');return false;
	}else if(limitPayment2 >80000000 || limitPayment2 < 1){
		showWarn('一级区域兑奖限额：范围1-80000000');return false;
	}
	var limitCancel2 = $("div#gameControlParameter [name='controlParameter.limitCancel2']").val();
	if(limitCancel2 == '' || limitCancel2 == 'undefined'){
		showWarn('一级区域退票限额不能为空');return false;
	}else if(limitCancel2 >80000000 || limitCancel2 < 1){
		showWarn('一级区域退票限额：范围1-80000000');return false;
	}
	*/
	var msg = "你确定要修改该项吗?";
	showDialog("updateGameControlParameter()","确认",msg);
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
				showWarn('修改前置条件：存在游戏期时不可修改');
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
		showWarn('保底金额不能为空');return false;
	}
	if(fdfd == '' || fdfd == 'undefined'){
		showWarn('修改前置条件：存在游戏期时不可修改');return false;
	}
	if(Number(fdfd) < Number(fdbd) && fdbd != 0 && fdfd != 0){
		showWarn('封顶金额不能小于保底金额');return false;
	}
	if(fdmin == '' || fdmin == 'undefined'){
		showWarn('抹零金额不能为空');return false;
	}else if(fdmin == 0){
		showWarn('抹零金额不能为0');return false;
	}
	var msg = "你确定要修改该项吗?";
	showDialog("updateGamePrizeRule()","确认",msg);
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
				showWarn('修改前置条件：存在游戏期时不可修改');
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
	var msg = "你确定要修改该项吗?";
	showDialog("updateRiskControl("+gameCode+")","确认",msg);
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
							showWarn('修改前置条件：存在游戏期时不可修改');
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
<div id="title">游戏参数</div>
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
													<td width="51%">游戏基本参数</td>
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
													<td>游戏编码：${gameManagementForm.gameInfo.gameCode}</td>
												</tr>
												<tr>
													<td>游戏标识：${gameManagementForm.gameInfo.gameMark}</td>
												</tr>
												<tr>
													<td>游戏名称：${gameManagementForm.gameInfo.fullName}</td>
												</tr>
												<tr>
													<td>游戏缩写：${gameManagementForm.gameInfo.shortName}</td>
												</tr>
												<tr>
													<td>游戏类型：
														<c:if test="${gameManagementForm.gameInfo.basicType==1}">基诺</c:if>
														<c:if test="${gameManagementForm.gameInfo.basicType==2}">乐透</c:if>
														<c:if test="${gameManagementForm.gameInfo.basicType==3}">数字</c:if>
														<c:if test="${gameManagementForm.gameInfo.basicType==4}">竞彩</c:if>
													</td>
												</tr>
												<tr>
													<td>发行单位名称：${gameManagementForm.gameInfo.issuingOrganization}</td>
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
													<td width="51%">政策参数</td>
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
													<td>理论返奖率：${gameManagementForm.gamePolicyParam.theoryRate} ‰</td>
												</tr>
												<tr>
													<td>公益金比例：${gameManagementForm.gamePolicyParam.fundRate} ‰</td>
												</tr>
												<tr>
													<td>调节基金比例：${gameManagementForm.gamePolicyParam.adjRate} ‰</td>
												</tr>
												<tr>
													<td>中奖缴税起征点：<fmt:formatNumber value="${gameManagementForm.gamePolicyParam.taxThreshold}" type="number"/> 瑞尔
													</td>
												</tr>
												<tr>
													<td>中奖缴税比例：${gameManagementForm.gamePolicyParam.taxRate} ‰</td>
												</tr>
												<tr>
													<td>兑奖期：${gameManagementForm.gamePolicyParam.drawLimitDay} 天</td>
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
													<td>普通规则参数</td>
													<td align="right"><a href="#"
														onclick="editGameParam(${gameManagementForm.normalRuleParameter.gameCode});"
														onmouseout="MM_swapImgRestore()"
														onmouseover="MM_swapImage('Image11','','${basePath}/img/edit-hover.png',1)"><img
															src="${basePath}/img/edit.png" width="32" height="42" title="编辑"
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
													<td>开奖模式：
															<c:if test="${gameManagementForm.normalRuleParameter.drawMode==1}">快开</c:if>
															<c:if test="${gameManagementForm.normalRuleParameter.drawMode==2}">内部算奖</c:if>
															<c:if test="${gameManagementForm.normalRuleParameter.drawMode==3}">外部算奖</c:if>
													</td>
												</tr>
												<tr>
													<td>单注投注金额：<fmt:formatNumber value="${gameManagementForm.normalRuleParameter.singleBetAmount}" type="number"/> 瑞尔</td>
												</tr>
												<tr>
													<td>多期销售限制：${gameManagementForm.normalRuleParameter.singleTicketMaxIssues} 期</td>
												</tr>
												<tr>
													<td>单票最大投注行数：${gameManagementForm.normalRuleParameter.singleTicketMaxLine} 行</td>
												</tr>
												<tr>
													<td>单行最大倍数：${gameManagementForm.normalRuleParameter.singleLineMaxAmount} 倍</td>
												</tr>
												<tr>
													<td>单票最大销售限额：<fmt:formatNumber value="${gameManagementForm.normalRuleParameter.singleTicketMaxAmount}" type="number"/> 瑞尔</td>
												</tr>
												<tr>
													<td>
													弃奖去处：
															<c:if test="${gameManagementForm.normalRuleParameter.abandonRewardCollect==1}">奖池</c:if> 
															<c:if test="${gameManagementForm.normalRuleParameter.abandonRewardCollect==2}">调节基金</c:if> 
															<c:if test="${gameManagementForm.normalRuleParameter.abandonRewardCollect==3}">公益金</c:if> 
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
													<td>游戏控制参数</td>
													<td align="right"><a href="#"
														onclick="editGameControlParameter(${gameManagementForm.controlParameter.gameCode});"
														onmouseout="MM_swapImgRestore()"
														onmouseover="MM_swapImage('Image21','','${basePath}/img/edit-hover.png',1)"><img
															src="${basePath}/img/edit.png" width="32" height="42" title="编辑"
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
													<td>大奖金额：<fmt:formatNumber type="number" value="${gameManagementForm.controlParameter.limitBigPrize}" /> 瑞尔</td>
												</tr>
												<tr>
													<td>游戏兑奖限额：<fmt:formatNumber type="number" value="${gameManagementForm.controlParameter.limitPayment}" /> 瑞尔</td>
												</tr>
												<tr>
													<td>允许退票时间：${gameManagementForm.controlParameter.cancelSec} 秒</td>
												</tr>
												<tr>
													<td>销售关闭倒数提醒：${gameManagementForm.controlParameter.issueCloseAlertTime} 秒</td>
												</tr>
												<!-- 
												<tr>
													<td>普通销售员兑奖限额：<fmt:formatNumber type="number" value="${gameManagementForm.controlParameter.salerPayLimit}" /> 瑞尔</td>
												</tr>
												<tr>
													<td>普通销售员退票限额：<fmt:formatNumber type="number" value="${gameManagementForm.controlParameter.salerCancelLimit}" /> 瑞尔</td>
												</tr>
												<tr>
													<td>分公司兑奖限额：<fmt:formatNumber type="number" value="${gameManagementForm.controlParameter.limitPayment2}" /> 瑞尔</td>
												</tr>
												<tr>
													<td>分公司退票限额：<fmt:formatNumber type="number" value="${gameManagementForm.controlParameter.limitCancel2}" /> 瑞尔</td>
												</tr>
												 -->
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
													<td>玩法规则</td>
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
													<td width="40%">玩法名称</td><td>规则描述</td>
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
													<td>游戏中奖规则</td>
												</tr>
											</table></td>
									</tr>
									<tr>
										<td class="nr">
										<div style="height:210px; overflow:auto;">
											<table width="100%" border="0" cellspacing="0"
												cellpadding="0" style="font-size:14px; color:#5e6d81; line-height:30px;">
												<tr>
													<td width="40%">规则名称</td>
													<td>规则描述</td>
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
													<td>奖级规则</td>
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
										          	<td colspan="3">启用特殊奖级： 
											            <c:if test="${gameManagementForm.isSpecial==1}">是</c:if>
											            <c:if test="${gameManagementForm.isSpecial==0}">否</c:if>
										       	 	</td>
										       	</tr>
												</c:if>
												<c:if test="${gameManagementForm.gameInfo.gameCode == 7}">
												<tr>
										          	<td colspan="3">保底金额： 
										          		<fmt:formatNumber type="number" value="${gameManagementForm.fdbd}" /> 瑞尔
										       	 	</td>
										       	</tr>
										       	<tr>
										          	<td colspan="3">封顶金额： 
										          		<fmt:formatNumber type="number" value="${gameManagementForm.fdfd}" /> 瑞尔
										       	 	</td>
										       	</tr>
										       	<tr>
										          	<td colspan="3">抹零金额： 
										          		<fmt:formatNumber type="number" value="${gameManagementForm.fdmin}" /> 瑞尔
										       	 	</td>
										       	</tr>
												</c:if>
												<tr>
													<td width="33%">奖级名称</td>
													<td width="33%">奖级奖金</td>
													<td width="34%">奖级描述</td>
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
													<td width="58%">游戏风控</td>
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
													<td width="33%">玩法名称</td>
													<td width="33%">初始限制投注数</td>
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
													<td width="58%">游戏风控</td>
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
													<td width="33%">玩法名称</td>
													<td width="33%">风控阈值</td>
													<td width="34%">最大赔付</td>
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
													<td width="58%">游戏风控</td>
													<td width="31%" align="right"><input type="checkbox" id="ch_emails" name="ch_emails" data-on="开" data-off="关" checked="checked" /></td>
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
													<td>风控阈值</td>
													<td><fmt:formatNumber type="number" value="${riskControlK3.paramA}" /></td>
												</tr>
												<tr>
													<td>最大赔付</td>
													<td><fmt:formatNumber type="number" value="${riskControlK3.paramB}" /></td>
												</tr>
											</table>
										</div>
										</td>
									</tr>
								</table>
							</div>
							</c:if>
							<c:if test="${gameManagementForm.gameParameterHistory.gameCode==12 or gameManagementForm.gameParameterHistory.gameCode==13 }">
							<div class="bg">
								<table width="100%" border="0" cellspacing="0" cellpadding="0">
									<tr>
										<td class="title4">
											<table id="butt" width="100%" border="0" cellspacing="0" cellpadding="0" style="color:#fff;font-size:18px;">
												<tr>
													<td width="58%">游戏风控</td>
													<td width="31%" align="right"><input type="checkbox" id="ch_emails" name="ch_emails" data-on="开" data-off="关" checked="checked" /></td>
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
													<td>风控阈值</td>
													<td><fmt:formatNumber type="number" value="${riskControl11X5.paramA}" /></td>
												</tr>
												<tr>
													<td>最大赔付</td>
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
													<td>游戏奖池参数</td>
												</tr>
											</table></td>
									</tr>
									<tr>
										<td class="nr">
										<div style="height:210px; overflow:auto;">
											<table width="100%" border="0" cellspacing="0"
												cellpadding="0" style="font-size:14px; color:#5e6d81; line-height:30px;">
												<tr>
													<td>奖池名称：${gameManagementForm.gamePool.poolName}</td>
												</tr>
												<tr>
													<td>奖池描述：${gameManagementForm.gamePool.poolDesc}</td>
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