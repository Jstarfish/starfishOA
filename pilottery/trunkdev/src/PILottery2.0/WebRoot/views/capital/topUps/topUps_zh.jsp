<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8"%>
	<%@ include file="/views/common/taglibs.jsp"%>
<%@ include file="/views/common/meta.jsp" %>
<html>
<head>
<title>充值</title>
<link rel="stylesheet" type="text/css" href="${basePath}/css/style.css" />
<link rel="stylesheet" type="text/css" href="${basePath}/css/pop-up.css" />
<link rel="stylesheet" href="${basePath}/component/messageBox/myJsBox.css" type="text/css" />
<link rel="stylesheet" type="text/css" href="${basePath}/css/validate.css" />
<script type="text/javascript" src="${basePath}/component/messageBox/myJsBox.js"></script>
<script type="text/javascript" src="${basePath}/component/My97DatePicker/WdatePicker.js"></script>
<script type="text/javascript" src="${basePath}/js/myJs.js"></script>
<script type="text/javascript" src="${basePath}/js/jquery/jquery-1.9.1.js"></script>
<script type="text/javascript" src="${basePath}/js/regexEnum.js"></script>
<script type="text/javascript" charset="UTF-8">
//二级联动
$(document).ready(function(){
	var val=$('#orgName').val();
	initSelect(val);
	  $("#orgName").change(function() { 
		  var val=$('#orgName').val();
			initSelect(val);
	  });
	 
	  $("#operAmount").blur(function(){
		  get_num();
		});
});

function initSelect(value){
	var arry= new Array();   
	var url="topUps.do?method=getOrgsCode&orgCode=" + value;
			$.ajax({
				url : url,
				dataType : "json",
				async : false,
				success : function(r){
				$("#orgCode").val(r.orgCode);
				$("#accountBalance").val(r.accountBalance);
			}
			});
			
			/* var url1 = "topUps.do?method=getOrgsBalance&orgCode=" + value;
			$.ajax({
				url : url1,
				dataType : "json",
				async : false,
				success : function(r){
				$("#accountBalance").val(r.accountBalance);
			}
			});  */
}

function isNull(data) {
	return (data == "" || data == 0 || data == null);
}
//充值并判断
 function doSubmit(){
	 var result = true;
	 if (!doCheck("operAmount", !isNull($("#operAmount").val()), '充值金额不能为0')) {
		result = false;
	}
	 if (result) {
		button_off("okButton");
		$("#topUpsForm").submit();
		$("#afterBalance").submit();
	 }
} 
//计算充值后账户余额

function get_num() {
	var num2 = $("#operAmount").val();
	if (num2) {
		var num1 = $("#accountBalance").val();
		$("#afterBalance").val(parseInt(num1) + parseInt(num2));
	}
}

	function doClose() {
		window.parent.closeBox();
	}
	function doReset(){
		$("#operAmount").val('');
		$("#afterBalance").val('');
	}
	
	function filterInput(obj) {
		var cursor = obj.selectionStart;
		obj.value = obj.value.replace(/[^\d]/g,'');
		obj.selectionStart = cursor;
		obj.selectionEnd = cursor;
	}
</script>
</head>
<body>
	<form action="topUps.do?method=topUps" id="topUpsForm" method="POST">
		<div class="pop-body">
		<table width="100%" border="0" cellspacing="0" cellpadding="0">
			<tr>
				<td class="td" align="right" width="30%">部门名称：</td>
				<td class="td" align="left" width="30%">
				<select name="orgName" id="orgName" class="select-big" onchange="doReset();">
					   <c:forEach var="item" items="${orgsMap}">
					      <option value="${item.key}">${item.value}</option>
					   </c:forEach>
				</select>
				<td><span id="orgNameTip" class="tip_init"></span></td>
	    	</tr>
	    	
	    	<tr>
				<td class="td" align="right">部门编码：</td>
				<td class="td" align="left"><input type="text" name="orgCode" class="text-big-noedit"  id="orgCode" readonly="readonly"/>
				<td><span id="orgCodeTip" class="tip_init"></span></td>
			</tr>
			
			<tr>
				<td class="td" align="right">当前余额：</td>
				<td class="td" align="left"><input type="text" name="accountBalance" class="text-big-noedit"  id="accountBalance" readonly="readonly"/>
				<td><span id="accountBalanceTip" class="tip_init"></span></td>
			</tr>
			
			<tr>
				<td class="td" align="right">充值金额：</td>
				<td class="td" align="left"><input name="operAmount" class="text-big" id="operAmount" onchange="get_num()"
					oninput="filterInput(this)" maxLength="10"/>
				</td>
				<td><span id="operAmountTip" class="tip_init">*</span></td>
			</tr>
			
			<tr>
				<td class="td" align="right">充值后账户金额：</td>
				<td class="td" align="left"> <input name="afterBalance" class="text-big-noedit" id="afterBalance"  readonly="readonly" type="text" />
						</td>
				<td><span id="afterBalanceTip" class="tip_init"></span></td>
			</tr>
		</table>
	</div>
		
	<div class="pop-footer">
		<span class="left">
			<input id="okButton" type="button" value='充值' onclick="doSubmit();" class="button-normal"></input>
		</span> 
		<span class="right">			
			<input type="button" value="取消" onclick="doClose();" class="button-normal"></input>
		</span>
	</div>
</form>
</body>
</html>
