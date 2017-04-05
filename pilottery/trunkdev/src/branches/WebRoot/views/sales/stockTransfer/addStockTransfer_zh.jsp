<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8"%>
<%@ include file="/views/common/taglibs.jsp"%>
<html>
<head>

<title>新增调拨单</title>

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
			showError('无法删除');
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
		//$("#applyAmount").val(toThousands(totalAmount));
		$("#applyAmount").val(totalAmount);
	}
	
	function doSubmit(){
		var applyTickets = $('#applyTickets').val();
		var sendOrg = $('#sendOrg').val();
		var receiveOrg = $('#receiveOrg').val();

		if(!sendOrg){
			showError('请选择发货<br/> 单位!');
			return false;
		}
		if(!receiveOrg){
			showError('请选择收货 <br/>单位!');
			return false;
		}
		if(sendOrg == receiveOrg){
			showError('收货单位和 <br/>发货单位不能<br/> 相同!');
			return false;
		}
		if(applyTickets == '' || applyTickets == 0){
			showError('张数不能为 <br/> 空!');
			return false;
		}
		if (!checkSpecialChars('remark')) {
			showError('备注包含非法<br/> 字符');
	    	return false;
		}
		if (!checkMaxLength('remark')) {
			showError('备注超过长度<br/> 限制');
	    	return false;
		}
		button_off("okBtn");
		$('#editForm').submit();
	}
</script>

</head>
<body style="text-align:center">
	<form  id="editForm" method="post" action="transfer.do?method=saveStockTransfer">
		<div class="pop-body">
			<table width="100%" border="0" cellspacing="0" cellpadding="0">
				<tr>
					<td  align="right">发货单位：</td>
					<td  align="left">
						<select class="select-big"  name="sendOrg" id="sendOrg">
							<option value=""> -- 请选择 --</option>
                       	    <c:forEach var="item" items="${orgList}" varStatus="s1">
                       	   		<option value="${item.orgCode }">${item.orgName }</option>
                       	    </c:forEach>
                        </select>
					</td>
					<td  align="right">收货单位：</td>
					<td  align="left">
						<select class="select-big"  name="receiveOrg" id="receiveOrg">
							<option value=""> -- 请选择 --</option>
							<c:if test="${sessionScope.current_user.institutionCode != '00'}">
								<c:forEach var="item" items="${orgList}" varStatus="s2">
									<c:if test="${sessionScope.current_user.institutionCode == item.orgCode}">
	                       	   			<option value="${item.orgCode }">${item.orgName }</option>
	                       	   		</c:if>
	                       	    </c:forEach>
							</c:if>
							<c:if test="${sessionScope.current_user.institutionCode == '00'}">
								<c:forEach var="item" items="${orgList}" varStatus="s2">
	                       	   		<option value="${item.orgCode }">${item.orgName }</option>
	                       	    </c:forEach>
							</c:if>
                        </select>
					</td>
				</tr>
				<tr>
					<td  align="right">总张数 (张)：</td>
					<td  align="left">
						<input id="applyTickets" name="tickets" class="text-big-noedit" readonly="readonly"/>
					</td>
					<td  align="right">总金额 (瑞尔)：</td>
					<td  align="left">
						<input id="applyAmount" name="amount" class="text-big-noedit" readonly="readonly"/>
					</td>
				</tr>
				<tr>
					<td align="right">备注：</td>
					<td align="left" colspan="3">
						<textarea id="remark" name="remark" cMaxByteLength="500" class="text-big" style="height:50px;width: 611px;"></textarea>
					</td>
				</tr>
			</table>
			<div style="padding:0 20px; margin-top:10px;margin-bottom: 20px; ">
                 <div style="position:relative; z-index:1000px;">
                   <table class="datatable" id="table1_head" width="100%">
                     <tbody><tr>
                       <th width="20%">方案名称 </th>
                       <th width="2%">|</th>
                       <th width="20%">数量 (本)</th>
                       <th width="2%">|</th>
                       <th width="20%">数量 (张)</th>
                       <th width="2%">|</th>
                       <th width="20%">金额 (瑞尔)</th>
                       <th width="8%">&nbsp;</th>
                     </tr>
                   </tbody></table>
                 </div>
                 <div id="box" style="border:1px solid #ccc;">
                   <table id="fatable" class="datatable" cellpadding="0 " cellspacing="0" width="100%">
                     <tbody>
                     <tr>
                       <td width="20%">
                       	   <input type="hidden" index="0">
                       	   <select style="width: 130px" name="transferDetail[0].planCode" onchange="sumPacks(this)">
	                       	   <c:forEach var="obj" items="${planList}" varStatus="plan">
	                       	   		<option value="${obj.planCode}" ticketAmount="${obj.ticketAmount}" packTickets="${obj.packTickets}" selected="selected">${obj.planName}</option>
	                       	   </c:forEach>
	                       </select>
                       </td>
                       <td width="2%">&nbsp;</td>
                       <td width="22%"><input type="text" alias="packages" name="transferDetail[0].packages"  value="0" size="15" maxLength="6" onkeyup="this.value=this.value.replace(/[^\d,]/g,'')" onblur="sumPacks(this)"/> </td>
                       <td width="2%">&nbsp;</td>
                       <td width="22%"><input type="text" alias="tickets" name="transferDetail[0].detailTickets"  value="0" size="15" readonly="readonly"/> </td>
                       <td width="2%">&nbsp;</td>
                       <td width="22%"><input type="text" alias="amount" name="transferDetail[0].detailAmount"  value="0" size="15" readonly="readonly"/> </td>
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
		<div class="pop-footer" style="margin-top: 30px">
			<span class="left"><input id="okBtn" type="button" onclick="doSubmit();"  value="提交" class="button-normal"></input></span>
			<span class="right"><input type="Reset" value="重置" class="button-normal"></input></span>
		</div>
	</form>

</body>
</html>