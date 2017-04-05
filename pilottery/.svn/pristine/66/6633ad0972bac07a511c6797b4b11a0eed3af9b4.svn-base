<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/views/common/taglibs.jsp"%>
<html>
<head>
<title>游戏授权</title>

<link rel="stylesheet" type="text/css" href="${basePath}/css/style.css" />
<link rel="stylesheet" type="text/css" href="${basePath}/css/pop-up.css" />
<link rel="stylesheet" type="text/css" href="${basePath}/css/validate.css" />

<link rel="stylesheet" href="${basePath}/component/messageBox/myJsBox.css" type="text/css"/>
<script type="text/javascript" src="${basePath}/component/messageBox/myJsBox.js"></script>

<script type="text/javascript" src="${basePath}/js/oms/myJs.js"></script>
<script type="text/javascript" src="${basePath}/js/jquery/jquery-1.9.1.js"></script>
<style type="text/css">
.datatable {
    border-collapse: collapse;
    border:1px solid #ccc;
    background: #fff;
    font-family: "微软雅黑";
    font-size: 12px;
}
.datatable img {
    line-height: 20px;
    vertical-align: middle;
    display:block;
}
.datatable th {
    background-color: #2aa1d9;
    height: 35px;
    line-height: 35px;
    color: #fff;
    text-align: left;
    padding-left: 8px;
    font-size: 12px;
}
.datatable td {
    border-bottom: 1px solid #e4e5e5;
    height: 35px;
    line-height: 35px;
    text-align: left;
    padding-left: 10px;
    font-size: 12px;
}
.datatable caption {
    color: #33517A;
    padding-top: 3px;
    padding-bottom: 8px;
}
.datatable tr:hover, .datatable tr.hilite {
    background-color: #f3f4f4;
    color: #000000;
}
.address-area {
    border:1px solid #40a7da;
    background-color:#FFF;
    width:91.9%;
    color:#000;
    font-size:14px;
    vertical-align:middle;
}
</style>

<script type="text/javascript" charset="UTF-8" >
function doSubmit() {
    var result = true;

    if (!myCheck()) {
    	result = false;
    }
		
    if (result) {
		button_off("okButton");
		$('#omsAreaAuthForm').submit();
    }
}

function myCheck() {
	var $txt = $("input[type='text']");
	
	for (var i = 0; i < $txt.length; i++) {
		$txt.eq(i).focus(function() {
			$(this).css("borderColor","");
			$(this).unbind("focus");
		});
	}
	
	var flag = true;
	for (var i = 0; i < $txt.length; i++) {
		if (!isValidNumber($txt[i].value, 0, 3)) {
			$txt.eq(i).css("borderColor","red");
			flag = false;
		}
	}
	return flag;
}

function isValidNumber(str,minlen,maxlen) {
	var len = str.length;
	if (len < minlen || len > maxlen) {
		return false;
	}
	var charCode;
	for (var i = 0; i < len; i++) { 
	    charCode = str.charCodeAt(i); 
		if (charCode < 48 || charCode > 57) {
			return false;
		}
	}
	return true;
}

function doClose(){
	window.parent.closeBox();
}
</script>

</head>
<body>
	<form:form id="omsAreaAuthForm" modelAttribute="omsAreaAuthForm" action="omsarea.do?method=gameAuthen" method="POST">
	    <div class="pop-body">
	    	<div style="padding:0 20px; margin-top:10px;margin-bottom:10px;">
	    		<table class="datatable" border="0">
				 	<tr class="headRow">
				 		<th width="1px">&nbsp;</th>
						<th width="15%" align="left">游戏名称</th>
						<th width="2%" align="left">|</th>
						<th width="7%" align="left">游戏类型</th>
						<!-- <th width="2%" align="left">|</th>
						<th width="9%" align="left">授权</th> -->
						<th width="2%" align="left">|</th>
						<th width="9%" align="left">是否可销售</th>
						<th width="2%" align="left">|</th>
						<th align="left">销售代销费（‰）</th>
						<th width="2%" align="left">|</th>
						<th width="9%" align="left">是否可兑奖</th>
						<th width="2%" align="left">|</th>
						<th align="left">兑奖代销费（‰）</th>
						<th width="2%" align="left">|</th>
						<th width="9%" align="left">是否可退票</th>
					</tr>
					<c:forEach var="game" items="${games}" varStatus="s">
						<tr class="dataRow">
							<input type="hidden" name="gameAuth[${s.index}].areaCode" value="${areaCode}" />
							<input type="hidden" name="gameAuth[${s.index}].gameCode" value="${game.gameCode}" />
							<td width="1px">&nbsp;</td>
							<td width="15%" title="${game.gameName}"><c:out value="${game.gameName}"/></td>
							<td width="2%">&nbsp;</td>
							<td width="7%">
								<c:choose>
									<c:when test="${game.gameType == 1}">基诺</c:when>
									<c:when test="${game.gameType == 2}">乐透</c:when>
									<c:when test="${game.gameType == 3}">数字</c:when>
									<c:otherwise>其他</c:otherwise>
								</c:choose>
							</td>
							<!-- <td width="2%">&nbsp;</td>
							<td width="9%">
								<c:choose>
									<c:when test="${game.enabled == 1}"><input type="checkbox" name="gameAuth[${s.index}].enabled" value="1" checked="checked" /></c:when>
									<c:otherwise><input type="checkbox" name="gameAuth[${s.index}].enabled" value="1" /></c:otherwise>
								</c:choose>
							</td> -->
							<td width="2%">&nbsp;</td>
							<td width="9%">
								<c:choose>
									<c:when test="${game.allowSale == 1}"><input type="checkbox" name="gameAuth[${s.index}].allowSale" value="1" checked="checked" /></c:when>
									<c:otherwise><input type="checkbox" name="gameAuth[${s.index}].allowSale" value="1" /></c:otherwise>
								</c:choose>
							</td>
							<td width="2%">&nbsp;</td>
							<td><input type="text" name="gameAuth[${s.index}].saleCommissionRate" style="width:80px;" value="${game.saleCommissionRate}"/></td>
							<td width="2%">&nbsp;</td>
							<td width="9%">
								<c:choose>
									<c:when test="${game.allowPay == 1}"><input type="checkbox" name="gameAuth[${s.index}].allowPay" value="1" checked="checked" /></c:when>
									<c:otherwise><input type="checkbox" name="gameAuth[${s.index}].allowPay" value="1" /></c:otherwise>
								</c:choose>
							</td>
							<td width="2%">&nbsp;</td>
							<td><input type="text" name="gameAuth[${s.index}].payCommissionRate" style="width:80px;" value="${game.payCommissionRate}"/></td>
							<td width="2%">&nbsp;</td>
							<td width="9%">
								<c:choose>
									<c:when test="${game.allowCancel == 1}"><input type="checkbox" name="gameAuth[${s.index}].allowCancel" value="1" checked="checked" /></c:when>
									<c:otherwise><input type="checkbox" name="gameAuth[${s.index}].allowCancel" value="1" /></c:otherwise>
								</c:choose>
							</td>
						</tr>
					</c:forEach>
				</table>
			</div>		
        </div>
        
        <div class="pop-footer">
            <span class="left">
            	<input id="okButton" type="button" value="提交" onclick="doSubmit();" class="button-normal"></input>
            </span>
            <span class="right">
            	<input id="cancelButton" type="button" value="关闭" onclick="doClose();" class="button-normal"></input>
            </span>
        </div>
	</form:form>
</body>
</html>