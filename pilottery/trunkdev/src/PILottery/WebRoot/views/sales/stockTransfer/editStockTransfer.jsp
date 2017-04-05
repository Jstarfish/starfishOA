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
	     $("#fatable tr:last select")[0].name='transferDetail['+index+'].planCode';
	     $("#fatable tr:last input[type=text]")[0].name='transferDetail['+index+'].packages';
	     $("#fatable tr:last input[type=text]")[1].name='transferDetail['+index+'].detailTickets';
	     $("#fatable tr:last input[type=text]")[2].name='transferDetail['+index+'].detailAmount';
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
		var sendOrg = $('#sendOrg').val();
		var receiveOrg = $('#receiveOrg').val();

		if(!sendOrg){
			showError('Please Select Delivering<br/> Unit!');
			return false;
		}
		if(!receiveOrg){
			showError('Please Select Receiving <br/>Unit!');
			return false;
		}
		if(sendOrg == receiveOrg){
			showError('Receiving Unit And <br/>Delivering Unit Cannot Be<br/> The Same!');
			return false;
		}
		if(applyTickets == '' || applyTickets == 0){
			showError('The Quantity Cannot Be <br/> Empty!');
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

	function doReset(){
		$("#applyTickets").val(0);
		$("#applyAmount").val(0);
		$("#box input").val(0);
	}
</script>

</head>
<body style="text-align:center">
	<form  id="editForm" method="post" action="transfer.do?method=updateStockTransfer">
		<div class="pop-body">
			<table width="100%" border="0" cellspacing="0" cellpadding="0">
				<tr>
					<td align="right">Stock Transfer：</td>
					<td align="left">
						<input type="hidden" name="stbNo" value="${order.stbNo}"/>
						${order.stbNo}
					</td>
					<td align="right">Date of Order：</td>
					<td align="left"><fmt:formatDate value='${order.applyDate}' pattern='yyyy-MM-dd HH:mm:ss'/></td>
				</tr>
				<tr>
					<td align="right">Submitted By：</td>
					<td align="left">${order.applyName}</td>
				</tr>
				<tr>
					<td  align="right">Delivering Unit：</td>
					<td  align="left">
						<select class="select-big"  name="sendOrg" id="sendOrg">
							<option value=""> -- Please Select --</option>
                       	   <c:forEach var="item" items="${orgList}" varStatus="s1">
                       	   		<c:if test="${item.orgCode == order.sendOrg}">
                       	   			<option value="${item.orgCode }" selected="selected">${item.orgName }</option>
                       	   		</c:if>
                       	   		<c:if test="${item.orgCode != order.sendOrg}">
                       	   			<option value="${item.orgCode }">${item.orgName }</option>
                       	   		</c:if>
                       	   </c:forEach>
                        </select>
					</td>
					<td  align="right">Receiving Unit：</td>
					<td  align="left">
						<select class="select-big" name="receiveOrg" id="receiveOrg">
							<option value=""> -- Please Select --</option>
							<c:if test="${sessionScope.current_user.institutionCode != '00'}">
								<c:forEach var="item" items="${orgList}" varStatus="s2">
									<c:if test="${sessionScope.current_user.institutionCode == item.orgCode && item.orgCode == order.receiveOrg}">
	                       	   			<option value="${item.orgCode }" selected="selected">${item.orgName }</option>
	                       	   		</c:if>
	                       	    </c:forEach>
							</c:if>
							<c:if test="${sessionScope.current_user.institutionCode == '00'}">
								<c:forEach var="item" items="${orgList}" varStatus="s2">
	                       	  	 	<c:if test="${item.orgCode == order.receiveOrg}">
	                       	   			<option value="${item.orgCode }" selected="selected">${item.orgName }</option>
	                       	   		</c:if>
	                       	   		<c:if test="${item.orgCode != order.receiveOrg}">
	                       	   			<option value="${item.orgCode }">${item.orgName }</option>
	                       	   		</c:if>
                       	   		</c:forEach>
							</c:if>
                        </select>
					</td>
				</tr>
				<tr>
					<td  align="right">Quantity (tickets)：</td>
					<td  align="left">
						<input id="applyTickets" name="tickets" class="text-big-noedit" readonly="readonly" value="${order.tickets }"/>
					</td>
					<td  align="right">Total Amount (riels)：</td>
					<td  align="left">
						<input id="applyAmount" name="amount" class="text-big-noedit" readonly="readonly" value="${order.amount }"/>
					</td>
				</tr>
				<tr>
					<td align="right">Remark：</td>
					<td align="left" colspan="3">
						<textarea id="remark" name="remark" cMaxByteLength="500" class="text-big" style="height:50px;width: 611px;">${order.remark}</textarea>
					</td>
				</tr>
			</table>
			<div style="padding:0 20px; margin-top:10px;margin-bottom: 20px; ">
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
                     <c:forEach var="detail" items="${order.transferDetail}" varStatus="s">
                     <tr>
                       <td width="20%">
                       	   <input type="hidden" index="${s.index}">
                       	   <select style="width: 130px" name="transferDetail[${s.index}].planCode" onchange="sumPacks(this)">
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
                       <td width="22%"><input type="text" alias="packages" name="transferDetail[${s.index}].packages" maxLength="6" 
                       						onkeyup="this.value=this.value.replace(/[^\d,]/g,'')" value="${detail.packages}" size="15" onchange="sumPacks(this)"/></td>
                       <td width="2%">&nbsp;</td>
                       <td width="22%"><input type="text" alias="tickets" name="transferDetail[${s.index}].detailTickets"  value="${detail.detailTickets}" size="15" readonly="readonly"/> </td>
                       <td width="2%">&nbsp;</td>
                       <td width="22%"><input type="text" alias="amount" name="transferDetail[${s.index}].detailAmount"  value="${detail.detailAmount}" size="15" readonly="readonly"/></td>
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
			<span class="left"><input id="okBtn" type="button" onclick="doSubmit();" value="Submit" class="button-normal"></input></span>
			<span class="right"><input type="button" value="Reset" class="button-normal" onclick="doReset()"></input></span>
		</div>
	</form>

</body>
</html>