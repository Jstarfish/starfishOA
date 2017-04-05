<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/views/common/taglibs.jsp"%>
<html>
<head>

<title>New Plan</title>

<%@ include file="/views/common/meta.jsp"%>
<link rel="stylesheet" type="text/css" href="${basePath}/css/style.css" />
<link rel="stylesheet" type="text/css" href="${basePath}/css/pop-up.css" />
<link rel="stylesheet" href="${basePath}/component/messageBox/myJsBox.css"
	type="text/css" />
<link rel="stylesheet" type="text/css" href="${basePath}/css/validate.css" />

<script type="text/javascript" src="${basePath}/js/myJs.js"></script>
<script type="text/javascript" src="${basePath}/component/messageBox/myJsBox.js"></script>
<script type="text/javascript"
	src="${basePath}/component/My97DatePicker/WdatePicker.js"></script>
<script type="text/javascript" src="${basePath}/js/jquery/jquery-1.9.1.js"></script>
<script type="text/javascript" src="${basePath}/js/regexEnum.js"></script>

<script type="text/javascript" charset="UTF-8">
	function doClose() {
		window.parent.closeBox();
	}

	//验证非空
	function isNotEmptyString(value) {
		return value != '' ? true : false;
	}

	function isSelected(value) {
		return value != 0 ? true : false;
	}

	$(document).ready(
			function() {
			$("#showBatch").hide();
				$("#okButton").bind(
						"click",
						function() {
							var result = true;

							if (!doCheck("batch", isNotEmptyString($("#batch")
									.val()), "Can't be empty")) {
								result = false;
							}

							if (result) {
								//$("#importBatch").submit();
								$.post("plans.do?method=importBatch", {
									"planCode" : "${planCode}","batch":$("#batch").val()
								}, function(data) {
										if(data.message!=""){
											showError(data.message);
											return;
											
										}else{
											$("#importBatch").remove();
											$("#okButton").remove();
											$("#counts").val(data.counts);
											$("#planCode").val(data.planCode);
											$("#lotteryType").val(data.lotteryType);
											$("#lotteryName").val(data.lotteryName);
											$("#boxEveryTrunk").val(data.boxEveryTrunk);
											$("#batchNo").val(data.batchNo);
											$("#trunkEveryGroup").val(data.trunkEveryGroup);
											$("#packsEveryTrunk").val(data.packsEveryTrunk);
											$("#ticketEveryPack").val(data.ticketEveryPack);
											$("#ticketEveryGroup").val(data.ticketEveryGroup);
											$("#firstRewardGroupNo").val(data.firstRewardGroupNo);
											$("#publisherName").val(data.publisherName);
											$("#showBatch").show();
										}
								});
							}
							;
						});
			});
</script>
</head>
<body>
	<form action="plans.do?method=importBatch&planCode=${planCode}" 
		method="POST">
		<!-- TODO -->
	<div id="importBatch">
		<div class="pop-body">
			<table width="100%" border="0" cellspacing="0" cellpadding="0"
				style="margin-top: 20px;">
			
					<input	name="planCode" value="${planCode}" hidden="true"  />
					
				
				<tr>
					<td align="center" class="fontzz" style="width: 50%">Batch: <input
						id="batch" name="batch" class="text-big" maxLength="60" />
					</td>
					<td align="center" style="width: *%">&nbsp;<span id="batchTip"
						class="tip_init"></span>
					</td>
				</tr>
			</table>
		</div>
		</div>
		
		<table width="100%" border="0" cellspacing="0" cellpadding="0"
				style="margin-top: 10px;"  id="showBatch" >
				<tr>
					<td align="center" class="fontzz" style="width: 50%" >奖符构成表：导入结果显示: 
					</td>
				</tr>
				<tr>
					<td align="center" class="fontzz" style="width: 50%">数量: 
					<input  name="batch" class="text-big" id="counts" value="" readonly="true"/>
					</td>
				</tr>
				<tr>
					<td align="center" class="fontzz" style="width: 50%">彩票批次信息：导入结果显示: 
					</td>
				</tr>
				<tr>
					<td align="center" class="fontzz" style="width: 50%">方案代码： 
					<input  name="batch" class="text-big" id="planCode" readonly="true"/>
					</td>
				</tr>
				<tr>
					<td align="center" class="fontzz" style="width: 50%"> 彩票分类： 
					<input  name="batch" class="text-big" id="lotteryType" readonly="true"/>
					</td>
				</tr>
				<tr>
					<td align="center" class="fontzz" style="width: 50%"> 彩票名称：
					<input  name="batch" class="text-big" id="lotteryName" readonly="true"/>
					</td>
				</tr>
				<tr>
					<td align="center" class="fontzz" style="width: 50%">生产批次： 
					<input  name="batch" class="text-big" id="batchNo" readonly="true"/>
					</td>
				</tr>
				<tr>
					<td align="center" class="fontzz" style="width: 50%">每箱盒数： 
					<input  name="batch" class="text-big" id="boxEveryTrunk" readonly="true"/>
					</td>
				</tr>
				<tr>
					<td align="center" class="fontzz" style="width: 50%">每组箱数：
					<input  name="batch" class="text-big" id="trunkEveryGroup" readonly="true"/>
					</td>
				</tr>
				<tr>
					<td align="center" class="fontzz" style="width: 50%">每箱本数：
					<input  name="batch" class="text-big" id="packsEveryTrunk" readonly="true"/>
					</td>
				</tr>
				<tr>
					<td align="center" class="fontzz" style="width: 50%">每本张数：
					<input  name="batch" class="text-big" id="ticketEveryPack" readonly="true"/>
					</td>
				</tr>
				<tr>
					<td align="center" class="fontzz" style="width: 50%">奖组张数（万张）：
					<input  name="batch" class="text-big" id="ticketEveryGroup" readonly="true"/>
					</td>
				</tr>
				<tr>
					<td align="center" class="fontzz" style="width: 50%">首分组号：
					<input  name="batch" class="text-big" id="firstRewardGroupNo" readonly="true"/>
					</td>
				</tr>
				<tr>
					<td align="center" class="fontzz" style="width: 50%">生产厂家：
					<input  name="batch" class="text-big" id="publisherName" readonly="true"/>
					</td>
				</tr>
			</table>
		<div class="pop-footer">
			<span class="left"> <input id="okButton" type="button" value="Submit"
				class="button-normal"></input>
			</span> <span class="right"> <input id="cancelButton" type="button" value="Cancel"
				class="button-normal" onclick="doClose();"></input>
			</span>
		</div>

	</form>
</body>
</html>