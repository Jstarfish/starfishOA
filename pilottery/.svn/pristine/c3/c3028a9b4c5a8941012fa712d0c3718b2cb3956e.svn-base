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
<script type="text/javascript"	src="${basePath}/js/jquery/jquery-1.9.1.js"></script>
<script type="text/javascript"	src="${basePath}/js/myJs.js"></script>
<script type="text/javascript" charset="UTF-8">
function addTr(obj){
	 var index = $("#fatable tr:last input[type=hidden]").attr('index');
    var tr = $(obj).parent().parent().clone(); 
    tr.appendTo("#fatable"); 
    $("#fatable tr:last input[type=text]").val(0);

    //重新根据序号重命名明细列的name属性，实现与后台实体的自动绑定
    index = parseInt(index)+1;
    $("#fatable tr:last input[type=hidden]").attr('index',index);
    $("#fatable tr:last select")[0].name='rdDetail['+index+'].planCode';
    $("#fatable tr:last input[type=text]")[0].name='rdDetail['+index+'].packages';
    $("#fatable tr:last input[type=text]")[1].name='rdDetail['+index+'].tickets';
    $("#fatable tr:last input[type=text]")[2].name='rdDetail['+index+'].amount';
}
function delTr(obj){
	var trlen = $("#fatable tr").length;
	if(trlen==1){
		showError('不能删除!');
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
	if(applyTickets == '' || applyTickets == 0){
		showError('数量不能为空!');
		return false;
	}
	button_off("okBtn");
	$('#editForm').submit();
}
</script>

</head>
<body style="text-align:center">
	<form  id="editForm" method="post" action="returnDelivery.do?method=updateReturnDelivery">
		<div class="pop-body">
			<table width="100%" border="0" cellspacing="0" cellpadding="0">
				<tr>
					<td width="20%" align="right">还货编号：</td>
					<td width="30%" align="left">
						<input type="hidden" name="returnNo" value="${order.returnNo}"/>
						${order.returnNo}
					</td>
					<td width="20%" align="right">订单日期：</td>
					<td width="30%" align="left"><fmt:formatDate value='${order.applyDate}' pattern='yyyy-MM-dd HH:mm:ss'/></td>
				</tr>
				<tr>
					<td  align="right">数量 (张)：</td>
					<td  align="left">
						<input id="applyTickets" name="applyTickets" class="text-big-noedit" value="${order.applyTickets }" readonly="readonly"/>
					</td>
					<td  align="right">金额 (瑞尔)：</td>
					<td  align="left">
						<input id="applyAmount" name="applyAmount" class="text-big-noedit" value="${order.applyAmount }" readonly="readonly"/>
					</td>
				</tr>
			</table>
			<div style="padding:0 20px;margin-top: 10px;">
                 <div style="position:relative; z-index:1000px;">
                   <table class="datatable" id="table1_head" width="100%">
                     <tbody><tr>
                       <th width="22%">方案 </th>
                       <th width="2%">|</th>
                       <th width="22%">数量 (本)</th>
                       <th width="2%">|</th>
                       <th width="22%">数量 (张)</th>
                       <th width="2%">|</th>
                       <th width="22%">金额 (瑞尔)</th>
                       <th width="8%">&nbsp;</th>
                     </tr>
                   </tbody></table>
                 </div>
                 <div id="box" style="border:1px solid #ccc;">
                   <table id="fatable" class="datatable" cellpadding="0 " cellspacing="0" width="100%">
                     <tbody>
                     <c:forEach var="detail" items="${order.rdDetail}" varStatus="s">
                     <tr>
                       <td width="20%">
                       	   <input type="hidden" index="${s.index}">
                       	   <select style="width: 130px" name="rdDetail[${s.index}].planCode" onchange="sumPacks(this)">
	                       	   <c:forEach var="obj" items="${planList}" varStatus="plan">
	                       	   		<c:if test="${obj.planCode==detail.planCode}">
	                       	   			<option value="${obj.planCode}" ticketAmount="${obj.ticketAmount}" packTickets="${obj.packTickets}" selected="selected">${obj.planName}</option>
	                       	   		</c:if>
	                       	   		<c:if test="${obj.planCode!=detail.planCode}">
	                       	   			<option value="${obj.planCode}" ticketAmount="${obj.ticketAmount}" packTickets="${obj.packTickets}">${obj.planName}</option>
	                       	   		</c:if>
	                       	   </c:forEach>
	                       </select>
                       </td>
                       <td width="2%">&nbsp;</td>
                       <td width="22%"><input type="text" alias="packages" name="rdDetail[${s.index}].packages" maxLength="6" onkeyup="this.value=this.value.replace(/[^\d,]/g,'')" value="${detail.packages}" size="15" onblur="sumPacks(this)"/></td>
                       <td width="2%">&nbsp;</td>
                       <td width="22%"><input type="text" alias="tickets" name="rdDetail[${s.index}].tickets"  value="${detail.tickets}" size="15" /></td>
                       <td width="2%">&nbsp;</td>
                       <td width="22%"><input type="text" alias="amount" name="rdDetail[${s.index}].amount"  value="${detail.amount}" size="15"/></td>
                       <td width="4%">
                       		<img src="${basePath}/img/add.png"  onclick="addTr(this);" height="16px" width="16px"/>
                       </td>
                       <td width="4%">
                       		<img src="${basePath}/img/cross.png"  onclick="delTr(this);" height="16px" width="16px"/>
                       </td>
                     </tr>
                     </c:forEach>
                   </tbody></table>
                 </div>
           </div>
		</div>
		<div class="pop-footer" style="margin-top: 30px">
			<span class="left"><input id="okBtn" type="button" onclick="doSubmit();"  value="提交" class="button-normal"></input></span>
			<span class="right"><input type="Reset" value="重置" class="button-normal"></input></span>
		</div>
	</form>

</body>
</html>