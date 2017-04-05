<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8"%>
<%@ include file="/views/common/taglibs.jsp"%>
<html>
<head>
<title></title>

<%@ include file="/views/common/meta.jsp"%>
<link rel="stylesheet" type="text/css" href="${basePath}/css/style.css" />
<link rel="stylesheet"	href="${basePath}/component/messageBox/myJsBox.css" type="text/css" />
<link rel="stylesheet" type="text/css" href="${basePath}/css/pop-up.css" />
<script type="text/javascript"	src="${basePath}/component/messageBox/myJsBox.js"></script>
<script type="text/javascript"	src="${basePath}/component/My97DatePicker/WdatePicker.js"></script>
<script type="text/javascript"	src="${basePath}/js/myJs.js"></script>
<script type="text/javascript"	src="${basePath}/js/jquery/jquery-1.9.1.js"></script>

<script type="text/javascript">
function sumPlan(obj,orderNo){
	if (obj.checked){	
		obj.value=orderNo;
	}else{
		obj.value="";
	}
	//获取选中订单明细的方案明细
	var crtHidden = $(obj).parent().find("input:hidden");
	for(var i=0;i<crtHidden.length;i++){
		//获得某个方案对应的信息
		var planCode = $(crtHidden[i]).attr('planCode');
		var pack = $(crtHidden[i]).attr('package');
		var tickets = $(crtHidden[i]).attr('tickets');
		var amount = $(crtHidden[i]).attr('amount');

		//获取出货单的方案列表 var slctPlan = $('#fatable input[name=plan1]');
		var slctPlan = $('#optable input[class=plan1]');
		for(var k=0;k<slctPlan.length;k++){
			if($(slctPlan[k]).attr('code') == planCode){
				//获得出货单当前方案对应的金额和数量
				var inputs = $(slctPlan[k]).parent().parent().find("input");
				var ipack = inputs[1].value;
				var itickets = inputs[2].value;
				var iamount = inputs[3].value;
				if (obj.checked){	//判断checkBox选中
					//inputs[0].value = ipack + pack;
					inputs[1].value = parseInt(ipack) + parseInt(pack);
					inputs[2].value = parseInt(itickets) + parseInt(tickets);
					inputs[3].value = parseInt(iamount) + parseInt(amount);
				}else{	//取消选中
					inputs[1].value = parseInt(ipack) - parseInt(pack);
					inputs[2].value = parseInt(itickets) - parseInt(tickets);
					inputs[3].value = parseInt(iamount) - parseInt(amount);
				}
			}
		}
	}
}

function addTr(obj){
	var index = $("#fatable tr:last input[type=hidden]").attr('index');
    var tr = $(obj).parent().parent().clone(); 
    tr.appendTo("#fatable"); 
    $("#fatable tr:last input[type=text]").val(0);

    //重新根据序号重命名明细列的name属性，实现与后台实体的自动绑定
    index = parseInt(index)+1;
    $("#fatable tr:last input[type=hidden]").attr('index',index);
    $("#fatable tr:last select")[0].name='deliveryDetail['+index+'].planCode';
    $("#fatable tr:last input[type=text]")[0].name='deliveryDetail['+index+'].packages';
    $("#fatable tr:last input[type=text]")[1].name='deliveryDetail['+index+'].tickets';
    $("#fatable tr:last input[type=text]")[2].name='deliveryDetail['+index+'].amount';
}
function delTr(obj){
	var trlen = $("#fatable tr").length;
	if(trlen==1){
		showError('Cannot Be Deleted');
		return false;
	}
	$(obj).parent().parent().remove(); 
	sumPacks(obj);
}
function sumPacks(obj){
	var crttr = $(obj).parent().parent();
	var ticketAmount = crttr.find("option:selected").attr('ticketAmount');	//当前方案的每张金额
	var packTickets = crttr.find("option:selected").attr('packTickets');	//每本张数
	var crtPackNum = crttr.find("input[alias=packages]").val();
	if(crtPackNum!=''){
		var crtTickets = parseInt(crtPackNum)*packTickets;
		//crttr.find("input[alias=amount]").val(toThousands(crtMoney));
		crttr.find("input[alias=tickets]").val(crtTickets);
		crttr.find("input[alias=amount]").val(crtTickets*ticketAmount);
	}
	var tickets = $("#fatable input[alias=tickets]");
	var amts = $("#fatable input[alias=amount]");
	var totalTickets = 0;
	var totalAmount = 0;
	for(var i=0;i<tickets.length;i++){
		if(tickets[i].value != ''){
			totalTickets += parseInt(tickets[i].value);
			//totalAmount += parseInt(amts[i].value.replace(/,/g, ''));
			totalAmount += parseInt(amts[i].value);
		}
	}
	$("#totalTickets").val(totalTickets);
	//$("#applyAmount").val(toThousands(totalAmount));
	$("#totalAmount").val(totalAmount);
}

function doSubmit(){
	var totalTickets = $('#totalTickets').val();
	if(totalTickets == '' || totalTickets == 0){
		showError('The Quantity Cannot Be <br/> Empty');
		return false;
	}
	if (!checkSpecialChars('remark')) {
		showError('Remark contains illegal<br/> characters.');
    	return false;
	}
	if (!checkMaxLength('remark')) {
		showError('Remark exceeds length<br/> limit.');
    	return false;
	}
	button_off("okBtn");
	$('#editForm').submit();
}
</script>

</head>
<body style="text-align:center">
	<form  id="editForm" method="post" action="delivery.do?method=saveDeliveryOrder">
		<div class="pop-body">
			<table width="100%" border="0" cellspacing="0" cellpadding="0">
				<tr>
					<td  align="right">Delivery Order：</td>
					<td  align="left">
						<input name="doNo" class="text-big" maxLength="8" value="${doNo}"/>
					</td>
					<td  align="right">Submitted By：</td>
					<td  align="left">
						<input class="text-big" value="${sessionScope.current_user.realName}"/>
					</td>
				</tr>
				<tr>
					<td  align="right">Quantity (tickets)：</td>
					<td  align="left">
						<input id="totalTickets" name="totalTickets" class="text-big-noedit" readonly="readonly"/>
					</td>
					<td  align="right">Total Amount (riels)：</td>
					<td  align="left">
						<input id="totalAmount" name="totalAmount" class="text-big-noedit" readonly="readonly"/>
					</td>
				</tr>
				<tr>
					<td  align="right">Remark：</td>
					<td  align="left" colspan="3">
						<textarea id="remark" name="remark" cMaxByteLength="500" class="text-big" style="height:50px;width:603px;"></textarea>
					</td>
				</tr>
			</table>
			<div style="padding:0 20px; margin-top:10px; ">
                 <div style="position:relative; z-index:1000px;">
                   <table class="datatable" id="table1_head" width="100%">
                     <tbody><tr>
                       <th width="21%">Purchase Order</th>
                       <th width="4%;padding-left: 10px;">&nbsp;</th>
                       <th width="2%">|</th>
                       <th width="23%">Date of Order</th>
                       <th width="2%">|</th>
                       <th width="23%">Quantity(tickets)</th>
                       <th width="2%">|</th>
                       <th width="*%">Amount(riels)</th>
                     </tr>
                   </tbody></table>
                 </div>
                 <div id="box" style="border:1px solid #ccc;">
                   <table id="oltable" class="datatable" cellpadding="0" cellspacing="0" width="100%">
                     <tbody>
                      <c:forEach var="item"	items="${orderList}" varStatus="i">
	                     <tr>
	                       <td style="width:4%;padding-left: 10px;">
	                       		<input type="checkbox" name="doRelation[${i.index}].orderNo" value="" onchange="sumPlan(this,'${item.orderNo}');">
	                       		<c:forEach var="detail" items="${item.orderDetail}" varStatus="k">
	                       			<input type="hidden" planCode="${detail.planCode}" package="${detail.packages}" tickets="${detail.tickets}" amount="${detail.amount}"/>
	                       		</c:forEach>
	                       </td>
	                       <td style="width:21%">${item.orderNo}</td>
	                       <td style="width:2%">&nbsp;</td>
	                       <td style="width:23%"><fmt:formatDate value="${item.applyDate}" pattern="yyyy-MM-dd HH:mm:ss"/></td>
	                       <td style="width:2%">&nbsp;</td>
	                       <td style="width:23%">${item.applyTickets}</td>
	                       <td style="width:2%">&nbsp;</td>
	                       <td style="width:*%;text-align: right"><fmt:formatNumber value="${item.applyAmount}" /></td>
	                     </tr>
                     </c:forEach>
                   </tbody></table>
                 </div>
                 
                 <div style="position:relative; z-index:1000px;margin-top: 10px">
                   <table class="datatable" id="table1_head" width="100%">
                     <tbody><tr>
                       <th width="20%">Plan</th>
                       <th width="2%">|</th>
                       <th width="23%">Total Quantity (packs)</th>
                       <th width="2%">|</th>
                       <th width="23%">Total Quantity (tickets)</th>
                       <th width="2%">|</th>
                       <th width="*%">Total Amount (riels)</th>
                     </tr>
                   </tbody></table>
                 </div>
                 <div id="box" style="border:1px solid #ccc;">
                   <table id="optable" class="datatable" cellpadding="0" cellspacing="0" width="100%">
                     <tbody>
                     	<c:forEach var="opl" items="${orderPlanList}" varStatus="s">
	                     <tr>
	                       <td style="width:20%">
	                       	   <input class="plan1" type="text" size="18" code="${opl.planCode}" value="${opl.planName}" readonly="readonly"/>
	                       </td>
	                       <td style="width:2%">&nbsp;</td>
	                       <td style="width:23%"><input type="text" size="15" value="0" readonly="readonly"/></td>
	                       <td style="width:2%">&nbsp;</td>
	                       <td style="width:23%"><input type="text" size="15" value="0" readonly="readonly"/></td>
	                       <td style="width:2%">&nbsp;</td>
	                       <td style="width:*%"><input type="text" size="15" value="0" readonly="readonly"/></td>
	                     </tr>
	                    </c:forEach>
                   </tbody></table>
                 </div>
           </div>
           
           <div style="padding:0 20px; margin-top:15px;margin-bottom: 20px; ">
           		<p align="left">Delivery Order</p>
                 <div style="position:relative; z-index:1000px;margin-top: 10px;">
                   <table class="datatable" id="table1_head" width="100%">
                     <tbody><tr>
                       <th width="20%">Plan </th>
                       <th width="2%">|</th>
                       <th width="22%">Quantity(packs)</th>
                       <th width="2%">|</th>
                       <th width="22%">Quantity(tickets)</th>
                       <th width="2%">|</th>
                       <th width="22%">Amount(riels)</th>
                       <th width="*%">&nbsp;</th>
                     </tr>
                   </tbody></table>
                 </div>
                 <div id="box" style="border:1px solid #ccc;">
                   <table id="fatable" class="datatable" cellpadding="0" cellspacing="0" width="100%">
                     <tbody>
                     <tr>
                       <td width="20%">
                       	   <input type="hidden" index="0">
                       	   <select style="width: 130px" name="deliveryDetail[0].planCode" onchange="sumPacks(this)">
	                       	   <c:forEach var="obj" items="${planList}" varStatus="plan">
	                       	   		<option value="${obj.planCode}" ticketAmount="${obj.ticketAmount}" packTickets="${obj.packTickets}" selected="selected">${obj.planName}</option>
	                       	   </c:forEach>
	                       </select>
                       </td>
                       <td width="2%">&nbsp;</td>
                       <td width="22%"><input type="text" alias="packages" name="deliveryDetail[0].packages"  value="0" size="15" maxLength="6" onkeyup="this.value=this.value.replace(/[^\d,]/g,'')" onblur="sumPacks(this)"/></td>
                       <td width="2%">&nbsp;</td>
                       <td width="22%"><input type="text" alias="tickets" name="deliveryDetail[0].tickets"  value="0" size="15" readonly="readonly"/> </td>
                       <td width="2%">&nbsp;</td>
                       <td width="22%"><input type="text" alias="amount" name="deliveryDetail[0].amount"  value="0" size="15" readonly="readonly"/> </td>
                       <td width="4%">
                       		<img src="${basePath}/img/add.png"  onclick="addTr(this);" height="16px" width="16px"/>
                       </td>
                       <td width="*%">
                       		<img src="${basePath}/img/cross.png"  onclick="delTr(this);" height="16px" width="16px"/>
                       </td>
                     </tr>
                   </tbody></table>
                 </div>
           </div>
		</div>
		<div class="pop-footer">
			<span class="left"><input id="okBtn" type="button" onclick="doSubmit();" value="Submit" class="button-normal"></input></span>
			<span class="right"><input type="Reset" value="Reset" class="button-normal"></input></span>
		</div>
	</form>

</body>
</html>