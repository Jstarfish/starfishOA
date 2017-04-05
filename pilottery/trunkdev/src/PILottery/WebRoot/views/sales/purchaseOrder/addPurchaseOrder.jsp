<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8"%>
<%@ include file="/views/common/taglibs.jsp"%>
<html>
<head>

<title>List of Purchase Orders</title>

<%@ include file="/views/common/meta.jsp"%>
<link rel="stylesheet" type="text/css" href="${basePath}/css/style.css" />
<link rel="stylesheet" type="text/css" href="${basePath}/css/pop-up.css" />
<link rel="stylesheet"	href="${basePath}/component/messageBox/myJsBox.css" type="text/css" />
<script type="text/javascript"	src="${basePath}/component/messageBox/myJsBox.js"></script>
<script type="text/javascript"	src="${basePath}/js/myJs.js"></script>
<script type="text/javascript"	src="${basePath}/component/My97DatePicker/WdatePicker.js"></script>
<script type="text/javascript"	src="${basePath}/js/jquery/jquery-1.9.1.js"></script>

<script type="text/javascript" charset="UTF-8">

	function addTr(obj){
		 var index = $("#fatable tr:last input[type=hidden]").attr('index');
	     var tr = $(obj).parent().parent().clone(); 
	     tr.appendTo("#fatable"); 
	     $("#fatable tr:last input[type=text]").val(0);

	     //重新根据序号重命名明细列的name属性，实现与后台实体的自动绑定
	     index = parseInt(index)+1;
	     $("#fatable tr:last input[type=hidden]").attr('index',index);
	     $("#fatable tr:last select")[0].name='orderDetail['+index+'].planCode';
	     $("#fatable tr:last input[type=text]")[0].name='orderDetail['+index+'].packages';
	     $("#fatable tr:last input[type=text]")[1].name='orderDetail['+index+'].tickets';
	     $("#fatable tr:last input[type=text]")[2].name='orderDetail['+index+'].amount';
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
		$("#applyTickets").val(totalTickets);
		$("#applyAmount").val(totalAmount);
	}

	function doSubmit(){
		var applyTickets = $('#applyTickets').val();
		var applyAgency = $('#applyAgency').val();
		if(trim(applyAgency) == ''){
			showError('The outlet code cannot be<br/> empty');
			return false;
		}

		if (!checkSpecialChars('applyContact')) {
			showError('Contact phone contains<br/> illegal characters.');
        	return false;
		}
		if (!checkMaxLength('applyContact')) {
			showError('Contact phone exceeds<br/> length limit.');
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
		
		var flag = "";			
		$.ajax({
			url : "order.do?method=checkOutletCodeExsit&outletCode=" + applyAgency,
			dataType : "",
			type : "get",
			async : false,
			success : function(result){
				flag = result;
			}
		});	

		if(flag == "" || flag == "false"){
			showError('The Outlet Code Not Exsit</br> Or Permission Denied!');
        	return false;
		}
		
		if(applyTickets == '' || applyTickets == 0){
			showError('The Quantity Cannot Be <br/> Empty');
			return false;
		}
		
		button_off("okBtn");
		$('#editForm').submit();
	}

</script>

</head>
<body style="text-align:center">
	<form id="editForm" method="post" action="order.do?method=savePurchaseOrder">
		<div class="pop-body">
			<table width="100%" border="0" cellspacing="0" cellpadding="0">
				<tr>
					<td  align="right">Outlet Code：</td>
					<td  align="left">
						<input id="applyAgency" name="applyAgency" class="text-big" maxLength="8" value=""/>
					</td>
					<td  align="right">Contact Phone：</td>
					<td  align="left">
						<input name="applyContact" id="applyContact" class="text-big" value="" cMaxByteLength="15" />
					</td>
				</tr>
				<tr>
					<td  align="right">Quantity (tickets)：</td>
					<td  align="left">
						<input id="applyTickets" name="applyTickets" class="text-big-noedit" readonly="readonly"/>
					</td>
					<td  align="right">Total Amount (riels)：</td>
					<td  align="left">
						<input id="applyAmount" name="applyAmount" class="text-big-noedit" readonly="readonly"/>
					</td>
				</tr>
				<tr>
					<td  align="right">Remark：</td>
					<td  align="left" colspan="3">
						<textarea id="remark" name="remark" class="text-big" cMaxByteLength="500" style="height:50px;width:611px;"></textarea>
					</td>
				</tr>
			</table>
			<div style="padding:0 20px; margin-top:10px;margin-bottom: 20px;">
                 <div style="position:relative; z-index:1000px;">
                   <table class="datatable" id="table1_head" width="100%">
                     <tbody><tr>
                       <th width="22%">Plan </th>
                       <th width="2%">|</th>
                       <th width="22%">Quantity (packs)</th>
                       <th width="2%">|</th>
                       <th width="22%">Quantity (tickets)</th>
                       <th width="2%">|</th>
                       <th width="22%">Amount (riels)</th>
                       <th width="8%">&nbsp;</th>
                     </tr>
                   </tbody></table>
                 </div>
                 <div id="box" style="border:1px solid #ccc;">
                   <table id="fatable" class="datatable" cellpadding="0 " cellspacing="0" width="100%">
                     <tbody>
                     <tr>
                       <td width="22%">
                       	   <input type="hidden" index="0">
                       	   <select style="width: 130px" name="orderDetail[0].planCode" onchange="sumPacks(this)">
	                       	   <c:forEach var="obj" items="${planList}" varStatus="plan">
	                       	   		<option value="${obj.planCode}" ticketAmount="${obj.ticketAmount}" packTickets="${obj.packTickets}" selected="selected">${obj.planName}</option>
	                       	   </c:forEach>
	                       </select>
                       </td>
                       <td width="2%">&nbsp;</td>
                       <td width="22%"><input type="text" alias="packages" name="orderDetail[0].packages"  value="0" size="15" maxLength="6" onkeyup="this.value=this.value.replace(/[^\d,]/g,'')" onblur="sumPacks(this)"/></td>
                       <td width="2%">&nbsp;</td>
                       <td width="22%"><input type="text" alias="tickets" name="orderDetail[0].tickets"  value="0" size="15" readonly="readonly"/> </td>
                       <td width="2%">&nbsp;</td>
                       <td width="22%"><input type="text" alias="amount" name="orderDetail[0].amount"  value="0" size="15" readonly="readonly"/> </td>
                       <td width="4%">
                       		<img src="${basePath}/img/add.png"  onclick="addTr(this);" height="16px" width="16px"/>
                       </td>
                       <td width="4%">
                       		<img src="${basePath}/img/cross.png"  onclick="delTr(this);" height="16px" width="16px"/>
                       </td>
                     </tr>
                   </tbody></table>
                 </div>
           </div>
		</div>
		<div class="pop-footer">
			<span class="left"><input id="okBtn" type="button" onclick="doSubmit()" value="Submit" class="button-normal"></input></span>
			<span class="right"><input type="Reset" value="Reset" class="button-normal"></input></span>
		</div>
	</form>

</body>
</html>