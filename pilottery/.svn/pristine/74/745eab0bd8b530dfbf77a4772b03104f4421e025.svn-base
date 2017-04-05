<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8"%>
<%@ include file="/views/common/taglibs.jsp"%>
<%@ include file="/views/common/meta.jsp"%>

<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>无标题文档</title>
<link rel="stylesheet" type="text/css" href="${basePath}/css/style.css" />
<script type="text/javascript" src="${basePath}/js/myJs.js"></script>
<script type="text/javascript"
	src="${basePath}/js/jquery/jquery-1.9.1.js"></script>
<link rel="stylesheet" href="${basePath}/component/messageBox/myJsBox.css" type="text/css"/>
<script type="text/javascript" src="${basePath}/component/messageBox/myJsBox.js"></script>
<script type="text/javascript"
	src="${basePath}/views/inventory/goodsReceipts/js/TransCodeHandler.js"></script>
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

select {
	outline: none;
}

ul {
	list-style: none;
}

a {
	text-decoration: none;
}
</style>
<script>
$(document).ready(function(){	
	
	 $("#again").click(function(){	
		 $("#checkPointParmat").attr("action", "inventory.do?method=checkPointNext");
		 $('#checkPointParmat').submit();	 	
	  }); 

});

function prompt() {
	showDialog("submitInfo()","Confirm","Are you sure that you have completed?");
}

function submitInfo()
{
	switch_obj("submitok","waitBtn");
	$("#checkPointParmat").attr("action", "inventory.do?method=checkPointComplete");
	$('#checkPointParmat').submit();
}

function findObj(id) {
	var obj = document.getElementById(id);
	return obj;
}
function switch_obj(btnId1, btnId2) {
	var btnObj1 = findObj(btnId1);
	btnObj1.style.display = "none";
	var btnObj2 = findObj(btnId2);
	btnObj2.style.display = "inline";
}


</script>
</head>

<body>
	<form method="post" action="" id="checkPointParmat" name="checkPointParmat">
		<input type="hidden" name="cpNo" id="cpNo" value="${result.cpNo}">

		<div id="container">
			<!--header-->
			<div class="header">
				<!--用户信息区开始-->
				<!--用户信息区结束-->
				<div id="title">Process Inventory Check</div>
			</div>
			<!--header end-->
			<!--开奖开始-->
			<div id="main">
				<div class="jdt">
					<img src="views/inventory/goodsReceipts/images/jdt3_2.png" width="1000" height="30" />
					 <div class="xd">
					 	<span class="zi">1.Scan Goods Inventory</span>
					 	<span class="zi">2.Complete Goods Check</span>
					 	<span>3.Finish Goods Check</span>
					 </div>
				</div>
			
				<div class="bd">
					<table width="100%" border="0" align="center" cellpadding="0" cellspacing="0">
						<tr>
							<td>
								<div class="tab">
									<div class="tabn">
										<table border="0" cellpadding="0" cellspacing="0" width="100%" valign="top">
											<tr>
												<td>
													<table width="90%" border="0" align="center" cellpadding="0" cellspacing="0" style="margin-top: 30px;">
														<tr>
															<td width="30%" style="border-bottom: 1px dashed #ccc; padding-bottom: 15px;" class="hoz">
																Differences :<span class="lz2"> <fmt:formatNumber value='${result.cbeforeNum-result.cafterNum}'  type='number'/></span>tickets
															</td>
															<td width="30%" style="border-bottom: 1px dashed #ccc; padding-bottom: 15px;">
																Before Check : <span class="lz2">  <fmt:formatNumber value='${result.cbeforeNum}'  type='number'/></span>tickets
															</td>
															<td style="border-bottom: 1px dashed #ccc; padding-bottom: 15px;">
																After Check : <span class="lz2"> <fmt:formatNumber value='${result.cafterNum}'  type='number'/></span>tickets
															</td>
														</tr>
														<tr>
															<td>
																Profit and loss : <span class="lz2"><fmt:formatNumber value='${result.cbeforeNum-result.cafterNum}'  type='number'/></span>tickets									
															</td>
															<td colspan="2">
																Resulst : 
																<span class="lz2">
																	<c:choose>
																		<c:when test="${result.cresult==1}">Balanced</c:when>
																		<c:when test="${result.cresult==2}">Deficit</c:when>
																		<c:otherwise>Overage</c:otherwise>
																	</c:choose>
																</span>
															</td>
														</tr>																																				
													</table>
												</td>
											</tr>
											<tr>
												<td>
													<div style="margin: 10px 40px; float: right;">
														<button id="again" type="button"  class="gl-btn2">Continue</button>
														<button id="submitok" type="button"  class="gl-btn2" onclick="prompt();" >Complete</button>
														 <img id="waitBtn"  class="gl-btn2"  style="display:none" src="views/inventory/goodsReceipts/images/wait.gif" height="25px" width="35px"/>
													</div>
												</td>
											</tr>
										</table>
									</div>
								</div>
							</td>
						</tr>
					</table>
				</div>

			</div>
			<!--开奖结束-->

		</div>
	</form>
</body>
</html>
