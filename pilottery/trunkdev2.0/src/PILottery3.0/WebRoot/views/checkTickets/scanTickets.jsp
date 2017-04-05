<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8"%>
<%@ include file="/views/common/taglibs.jsp"%>

<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<title>Scan Tickets</title>

<link rel="stylesheet" href="${basePath}/component/messageBox/myJsBox.css" type="text/css"/>
<script type="text/javascript" src="${basePath}/js/myJs.js"></script>
<script type="text/javascript" src="${basePath}/component/messageBox/myJsBox.js"></script>
<script type="text/javascript" src="${basePath}/js/jquery/jquery-1.9.1.js"></script>
<link rel="stylesheet" type="text/css" href="${basePath}/css/style.css"/>
<link href="${basePath}/views/inventory/goodsReceipts/css/style3.css" rel="stylesheet" type="text/css"/>
<script type="text/javascript" src="${basePath}/views/checkTickets/js/TransCodeHandlerForSC.js"></script>

<script type="text/javascript">

var planQuantityMap = {}; //store the summary info
var index = 0; //index of the ticketData

$(document).ready(function(){
	
	/*
	var listBatchInfo;
	
	[{
		"amount":2001,
		"batchNo":"00001",
		"planCode":"J0001",
		"planName":"SPY J0001",
		"ticketsEveryGroup":100,
		"ticketsEveryPack":100
	}]
	
	var url = "checktickets.do?method=getGameBatchInfo";
	$.ajax({
		url: url,
		dataType: "json",
		async: false,
		success: function(r) {
			listBatchInfo = eval(r);
		}
	});
	
	J0002	Iphone		15906	4000	1000000 -
	J0003	Football	15904	2000	1000000 -
	J0003	Football	15907	2000	1000000 -
	J0004	GongXi		15905	2000	400000
	J0004	GongXi		15910	2000	400000
	J0005	大灌篮DGL		15908	4000	1000000
	
	*/
	var listBatchInfo= [
		{
			"amount":4000,
			"batchNo":"15906",
			"planCode":"J0002",
			"planName":"Iphone",
			"ticketsEveryGroup":1000000,
			"ticketsEveryPack":100
		},
		{
			"amount":4000,
			"batchNo":"15903",
			"planCode":"J0002",
			"planName":"Iphone",
			"ticketsEveryGroup":1000000,
			"ticketsEveryPack":100
		},
		{
			"amount":4000,
			"batchNo":"00001",
			"planCode":"J2015",
			"planName":"Iphone",
			"ticketsEveryGroup":1000000,
			"ticketsEveryPack":100
		},
		{
			"amount":2000,
			"batchNo":"15904",
			"planCode":"J0003",
			"planName":"Ball",
			"ticketsEveryGroup":1000000,
			"ticketsEveryPack":100
		},
		{
			"amount":2000,
			"batchNo":"15907",
			"planCode":"J0003",
			"planName":"Ball",
			"ticketsEveryGroup":1000000,
			"ticketsEveryPack":100
		},
		{
			"amount":2000,
			"batchNo":"00002",
			"planCode":"J2015",
			"planName":"Ball",
			"ticketsEveryGroup":1000000,
			"ticketsEveryPack":100
		},
		{
			"amount":4000,
			"batchNo":"15905",
			"planCode":"J0004",
			"planName":"GongXi",
			"ticketsEveryGroup":400000,
			"ticketsEveryPack":100
		},
		{
			"amount":2000,
			"batchNo":"15910",
			"planCode":"J0004",
			"planName":"GongXi",
			"ticketsEveryGroup":400000,
			"ticketsEveryPack":100
		},
		{
			"amount":4000,
			"batchNo":"15908",
			"planCode":"J0005",
			"planName":"DGL",
			"ticketsEveryGroup":1000000,
			"ticketsEveryPack":100
		},
		{
			"amount":2000,
			"batchNo":"00001",
			"planCode":"J2014",
			"planName":"Love",
			"ticketsEveryGroup":1000000,
			"ticketsEveryPack":100
		}
	];
	
	SJZPrinterForSC.initInfoForPlans(listBatchInfo);
	
	$("#barcode").keydown(function(e){
		if (e.keyCode == 13) {
			e.preventDefault(); //do not submit form when pressing enter
			var obj = SJZPrinterForSC.getPackInfo($("#barcode").val());

			if (typeof(obj) == "undefined" || obj == null) {
				return;
			}
			if (obj.errCode != 0) {
				//window.top.mainform.audio_play(3);
				showError(obj.errMessage);
				$('#barcode').val('');
				$("#barcode").focus();
				return;
			}

			insertTicketData(obj);
			updateSummary(obj);
			$('#barcode').val('');
			$("#barcode").focus();
		}
	});
	
	$("#clearData").click(function(){
		SJZPrinterForSC.clearObjects();
		$("#ticketData").html('');
		planQuantityMap = {};
		index = 0;
		$("#summaryInfo").find("tr:gt(0)").remove();

	});
	
	$("#okButton").click(function(){
		var ticketData = $('#ticketData').text();
		if($.trim(ticketData)==''){
			showError('Please input the barcode!');
			return false;
		}
		button_off("okButton");
		$("#scanTicketDataForm").submit();
	});
});

function insertTicketData(obj) {
	var barcode = obj.planCode+obj.batchCode+obj.firstPkgCode+obj.ticketCode+obj.safetyCode+obj.paySign;

	var dataRow = barcode;
	dataRow += '<input type="hidden" value="'+barcode+'" name="ticketData['+index+']">';
	dataRow += '<input type="hidden" value="'+obj.planCode+'" name="para['+index+'].planCode">';
	dataRow += '<input type="hidden" value="'+obj.batchCode+'" name="para['+index+'].batchNo">';
	dataRow += '<input type="hidden" value="'+obj.firstPkgCode+'" name="para['+index+'].packageNo">';
	dataRow += '<input type="hidden" value="'+obj.ticketCode+'" name="para['+index+'].ticketNo">';
	dataRow += '<input type="hidden" value="'+obj.safetyCode+obj.paySign+'" name="para['+index+'].securityCode">';
	index++;
	dataRow += "<br/>";
	$("#ticketData").append(dataRow);
}

function updateSummary(obj) {
	var key = obj.planCode+obj.batchCode;
	if (key in planQuantityMap) {
		planQuantityMap[key] += 1;
		$("#"+key).html(planQuantityMap[key]);
	} else {
		planQuantityMap[key] = 1;
		var row = '<tr>';
		row += "<td width='49%'>" + obj.planName + "</td>";
		row += "<td width='1%'>&nbsp;</td>";
		row += "<td width='50%' id='"+key+"'>1</td>";
		row += "</tr>";
		$("#summaryInfo").append(row);
	}
}

</script>
</head>
<body>
<form method="post" id="scanTicketDataForm" name="scanTicketDataForm" action="checktickets.do?method=submitTicketData">
	<div class="header">
		<div id="title">Scan Tickets</div>
	</div>
	<div id="main">
		<div class="bd">
		<table width="100%" border="0" align="center" cellpadding="0" cellspacing="0">
		<tr>
		<td align="center" valign="middle">
		<div class="tab">
			<div class="tabn">
				<table border="0" cellpadding="0" cellspacing="0" width="100%" valign="top">
				<tr>
				<td>
					<!-- summary info -->
					<div class="nr">
						<div class="title-mbx">Summary Information</div>
						<div style="position:relative;">
							<table class="datatable" cellpadding= "0" cellspacing= "0" id="summaryInfo" width="100%" >
								<tr>
									<th width="49%">Plan Name</th>
									<th width="1%">|</th>
									<th width="50%">Quantity</th>
								</tr>
							</table>
						</div>
					</div>
					<!-- barcode -->
					<div class="nr">
						<div class="title-mbx">Barcode</div>
						<div>
                          <table width="100%" border="0" cellspacing="0" cellpadding="0">
                            <tr>
                              <td><input class="edui-editor" id="barcode" type="text" value="Input barcode here" onfocus="this.value=''" onblur="if(this.value==''){this.value='Input barcode here'}"/></td>
                            </tr>
                          </table>
                        </div>
					</div>
					<!-- ticket data -->
					<div class="nr">	
						<div class="title-mbx">Ticket Data</div>
						<div class="border" id="ticketData">
							<!-- J0004159050009295100AAKRVJSGHANTCMAHAH034<input type="hidden" value="J0004159050009295100AAKRVJSGHANTCMAHAH034"><br/> -->
                      	</div>
					</div>
					<div style="margin-top:10px; float:right; padding:0 20px;">
						<button class="gl-btn2" type="button" id="clearData">Clear</button>
						<button class="gl-btn2" type="button" id="okButton">Submit</button>
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
</form>
</body>
</html>