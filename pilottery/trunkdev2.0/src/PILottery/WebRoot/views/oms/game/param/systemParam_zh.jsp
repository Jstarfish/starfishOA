<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/views/common/taglibs.jsp"%>
<html>
<head>
<title></title>
<script type="text/javascript" src="${basePath}/js/jquery/jquery-1.9.1.js"></script>
<script type="text/javascript" src="${basePath}/js/jquery/jquery.form.js"></script>
<link rel="stylesheet" type="text/css" href="${basePath}/css/style.css" />
<link rel="stylesheet" type="text/css" href="${basePath}/css/game.css"/>
<link rel="stylesheet" href="${basePath}/component/messageBox/myJsBox.css" type="text/css"/>
<script type="text/javascript" src="${basePath}/component/messageBox/myJsBox_zh.js"></script>
<script type="text/javascript" src="${basePath}/js/myJs.js"></script>
<script type="text/javascript">

function edit(area){
	$('#gameManagementForm').ajaxSubmit({
		type : 'POST',
		url : 'gameManagement.do?method=editSystemParam&area='+area,
		success : function(data) {
			$("#"+area).html(data);
		}
	});
};
//取消编辑
function cancel(area){
	$('#gameManagementForm').ajaxSubmit({
		type : 'POST',
		url : 'gameManagement.do?method=updateSystemParam&area='+area+'&fl=cancel',
		success : function(data) {
			$("#"+area).html(data);
		}
	});
};
//异步存储
function prompt(area) {
	if(area=='sale'){
		var str_sysParamValue0 = $("div#sale [name='str_sysParamValue0']").val();
		if(str_sysParamValue0 == '' || str_sysParamValue0 == 'undefined'){
			showWarn('销售站每天退票告警票数不能为空');return false;
		}
		var str_sysParamValue1 = $("div#sale [name='str_sysParamValue1']").val();
		if(str_sysParamValue1 == '' || str_sysParamValue1 == 'undefined'){
			showWarn('销售站每天退票告警金额不能为空');return false;
		}
		var str_sysParamValue2 = $("div#sale [name='str_sysParamValue2']").val();
		if(str_sysParamValue2 == '' || str_sysParamValue2 == 'undefined'){
			showWarn('销售站每天兑奖告警票数不能为空');return false;
		}
		var str_sysParamValue3 = $("div#sale [name='str_sysParamValue3']").val();
		if(str_sysParamValue3 == '' || str_sysParamValue3 == 'undefined'){
			showWarn('销售站每天兑奖告警金额不能为空');return false;
		}
	}else{
		var str_sysParamValue4 = $("div#agency [name='str_sysParamValue4']").val();
		if(str_sysParamValue4 == '' || str_sysParamValue4 == 'undefined'){
			showWarn('销售站默认兑奖佣金比例不能为空');return false;
		}
		var str_sysParamValue5 = $("div#agency [name='str_sysParamValue5']").val();
		if(str_sysParamValue5 == '' || str_sysParamValue5 == 'undefined'){
			showWarn('销售站默认销售佣金比例不能为空');return false;
		}
		var str_sysParamValue7 = $("div#agency [name='str_sysParamValue7']").val();
		if(str_sysParamValue7 == '' || str_sysParamValue7 == 'undefined'){
			showWarn('销售站默认永久授信额度不能为空');return false;
		}
	}
	var msg = "Are you sure you want to update it?";
	showDialog("update('"+area+"')","Confirm",msg);
}
function update(area){
	button_off("ok_button");
	$('#gameManagementForm').ajaxSubmit({
		type : 'POST',
		url : 'gameManagement.do?method=updateSystemParam&area='+area,
		success : function(data) {
			$("#"+area).html(data);
			closeDialog();
		}
	});
};
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
</head>
<body>
<div id="title">系统参数</div>
<form:form modelAttribute="gameManagementForm">
<div id="right2" style="height:100%; width:85%;">
	<table width="100%" border="0" cellspacing="0" cellpadding="0">
		<tr>
			<td>
				<div style="float: left; position: relative; top: 50%; left: 10%;"></div>
			</td>
			<td><div class="game">
				  <div id="sale">
					<div class="bg" style="width: 460px;">
						<table width="100%" border="0" cellspacing="0" cellpadding="0">
							<tr>
								<td class="title"><table width="100%" border="0" cellspacing="0" cellpadding="0" style="color:#fff;font-size:18px;">
										<tr>
											<td>销售站告警阈值</td>
											<td align="right"><a href="#"
												onclick="edit('sale');"
												onmouseout="MM_swapImgRestore()"
												onmouseover="MM_swapImage('Image11','','${basePath}/img/edit-hover.png',1)"><img
													src="${basePath}/img/edit.png" width="32" height="42" title="编辑"
													id="Image11" /></a></td>
										</tr>
									</table></td>
							</tr>
							<tr>
								<td class="nr" style="height:220px">
									<table width="100%" border="0" cellspacing="0"
										cellpadding="0" style="font-size:14px; color:#5e6d81; line-height:30px;">
										<tr>
											<td>销售站每天退票告警票数：${gameManagementForm.str_sysParamValue0}</td>
										</tr>
										<tr>
											<td>销售站每天退票告警金额：<fmt:formatNumber type="number" value="${gameManagementForm.str_sysParamValue1}" /> KHR</td>
										</tr>
										<tr>
											<td>销售站每天兑奖告警票数：${gameManagementForm.str_sysParamValue2}</td>
										</tr>
										<tr>
											<td>销售站每天兑奖告警金额：<fmt:formatNumber type="number" value="${gameManagementForm.str_sysParamValue3}" /> KHR</td>
										</tr>
									</table>
								</td>
							</tr>
						</table>
					</div>
				  </div>
				  <div id="agency">
					<div class="bg" style="width:460px" >
						<table width="100%" border="0" cellspacing="0" cellpadding="0">
							<tr>
								<td class="title1"><table width="100%" border="0" cellspacing="0" cellpadding="0" style="color:#fff;font-size:18px;">
										<tr>
											<td>销售站默认参数</td>
											<td align="right"><a href="#"
												onclick="edit('agency');"
												onmouseout="MM_swapImgRestore()"
												onmouseover="MM_swapImage('Image21','','${basePath}/img/edit-hover.png',1)"><img
													src="${basePath}/img/edit.png" width="32" height="42" title="编辑"
													id="Image21" /></a></td>
										</tr>
									</table></td>
							</tr>
							<tr>
								<td class="nr" style="height:220px">
									<table width="100%" border="0" cellspacing="0"
										cellpadding="0" style="font-size:14px; color:#5e6d81; line-height:30px;">
										<tr>
											<td>销售站默认兑奖佣金比例：${gameManagementForm.str_sysParamValue4}‰</td>
										</tr>
										<tr>
											<td>销售站默认销售佣金比例：${gameManagementForm.str_sysParamValue5}‰</td>
										</tr>
										<tr>
											<td>销售站默认兑奖范围：
												<c:if test="${gameManagementForm.str_sysParamValue6==1}">中心</c:if> 
												<c:if test="${gameManagementForm.str_sysParamValue6==2}">一级区域</c:if> 
												<c:if test="${gameManagementForm.str_sysParamValue6==3}">二级区域</c:if> 
												<c:if test="${gameManagementForm.str_sysParamValue6==4}">销售站</c:if> 
											</td>
										</tr>
										<tr>
											<td>销售站默认永久授信额度：<fmt:formatNumber type="number" value="${gameManagementForm.str_sysParamValue7}" /> KHR</td>
										</tr>
									</table>
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
</form:form>
</body>
</html>