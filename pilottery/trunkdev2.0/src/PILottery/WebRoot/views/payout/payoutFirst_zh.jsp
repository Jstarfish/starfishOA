<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/views/common/taglibs.jsp"%>
<%@ include file="/views/common/meta.jsp"%>
<%@page import="java.util.Date"%>
<%
	Date date = new Date();
%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>兑奖第一步</title>
<link rel="stylesheet" href="${basePath}/component/messageBox/myJsBox.css"
	type="text/css" />
<link rel="stylesheet" type="text/css" href="${basePath}/css/style.css" />
<script type="text/javascript" src="${basePath}/component/messageBox/myJsBox_zh.js"></script>
<script type="text/javascript" src="${basePath}/js/myJs.js"></script>
<script type="text/javascript" src="${basePath}/js/jquery/jquery-1.9.1.js"></script>
<script type="text/javascript"
	src="${basePath}/views/inventory/goodsReceipts/js/TransCodeHandler_zh.js?d=<%=date%>"></script>
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
<script type="text/javascript">
	function subCode() {
		var result = false;
			
			$.post("payout.do?method=firstStep", {
				"safeCode" : trim($("#safeCode").val())
			}, function(data) {
				if (data == "error") {
					result = false;
					showError(decodeURI("请扫描正确的条形码."));
					$('#safeCode').val('');	
					$("#safeCode").blur();
				} else if (data == "already") {
					result = false;
					showError(decodeURI("这张票已经被兑过奖."));
					$('#safeCode').val('');	
					$("#safeCode").blur();
				}
				else if (data == "out") {
					result = false;
					showError(decodeURI("不存在这张票."));
					$('#safeCode').val('');	
					$("#safeCode").blur();
				}
				 else if (data == "no") {
					result = false;
					showError(decodeURI("这张票未中奖."));
					$('#safeCode').val('');	
					$("#safeCode").blur();
				}
				 else if (data == "nosale") {
					result = false;
					showError(decodeURI("这张票还未销售或不合法 ."));
					$('#safeCode').val('');	
					$("#safeCode").blur();
				}else if (data == "terminated") {
					result = false;
					showError(decodeURI("批次已经终结."));
					$('#safeCode').val('');	
					$("#safeCode").blur();
				}else
				{
					result = true;
					$("#payout").submit();
				}
				
			});

	/* 		setTimeout(function() {
				if (result) {
					$("#payout").submit();
				}
			}, 100); */

		}
	
	  
   /*  document.onkeydown=keyDownSearch;  
      
    function keyDownSearch(e) {    
        // 兼容FF和IE和Opera    
        var theEvent = e || window.event;    
        var code = theEvent.keyCode || theEvent.which || theEvent.charCode;    
        if (code == 13) {    
           $("#payoutSub").click();
        }    
    }   */
	
</script>

</head>

<body>
	<form method="post" action="payout.do?method=initSecStep" id="payout" name="payout">

		<div id="container">
			<!--header-->
			<div class="header">
				<!--用户信息区开始-->
				<!--用户信息区结束-->
				<div id="title">兑奖</div>
			</div>
			<!--header end-->
			<!--开奖开始-->
			<div id="main">
				<div class="jdt">

					<img src="views/inventory/goodsReceipts/images/jdt3_1.png" width="1000"
						height="30" />
					<div class="xd">
						<span></span>
						<span class="zi" style="padding-left:60px; ">1.扫描安全码</span>
						<span style="padding-left:145px; ">2.中奖票信息</span>
						<span style="padding-left:185px; ">3.完善个人资料</span>
					</div>
				</div>

				<div class="bd">
					<table width="100%" border="0" align="center" cellpadding="0" cellspacing="0">
						<tr>

							<td align="center" valign="middle"><div class="tab">
									<div class="tabn">
										<table border="0" cellpadding="0" cellspacing="0" width="100%" valign="top">

											<tr>
												<td><div class="nr">
														<div class="title-mbx">安全码</div>
														<div class="nr"></div>

														<div>
															<table width="100%" border="0" cellspacing="0" cellpadding="0">
																<tr>

																	<td><input class="edui-editor" name="safeCode" id="safeCode"
																		type="text" value="请扫描条形码或手动输入条形码"
																		onfocus="this.value=''"
																		onblur="if(this.value==''){this.value='请扫描条形码或手动输入条形码'}" />
																		<input type="text" name="hi" style="display:none"/>
																		
																		</td>
																</tr>
															</table>
														</div>
													</div> <!--列表开始--> <!--列表结束-->

													<div style="margin-top: 10px; margin-right: 20px; float: right;">
														<input id="payoutSub" class="gl-btn2" type="button" id="okbtn" onclick="subCode();"
															value="提交" />
													</div></td>
											</tr>
										</table>
									</div>
								</div></td>

						</tr>
					</table>
				</div>

			</div>
			<!--开奖结束-->
		</div>
	</form>
</body>
</html>