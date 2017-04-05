<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/views/common/taglibs.jsp"%>
<html>
<head>
<title>销售站列表</title>

<link rel="stylesheet" type="text/css" href="${basePath}/css/city-list.css" />
<link rel="stylesheet" type="text/css" href="${basePath}/css/style.css" />

<script type="text/javascript" src="${basePath}/js/jquery/jquery-1.9.1.js"></script>
<link rel="stylesheet" href="${basePath}/component/messageBox/myJsBox.css" type="text/css"/>
<script type="text/javascript" src="${basePath}/component/messageBox/myJsBox_zh.js"></script>
<script type="text/javascript" src="${basePath}/js/oms/myJs.js"></script>
<script type="text/javascript" src="${basePath}/js/oms/city-list.js"></script>
<script type="text/javascript" charset="UTF-8" > 
jQuery(document).ready(function($) { 
	$('#queryType').val('${tellerForm.queryType}');
	initQueryCondition("#queryType","#queryString",'10','100');
});
function initQueryCondition(typeid,stringid,min,max){
	 var initval = $(typeid).val();
	 if((initval == 1 )||( initval == 3)){
		 $(stringid).unbind("keyup");
    	 $(stringid).unbind("afterpaste");
		 $(stringid).bind("keyup",function(){
			 this.value=this.value.replace(/[^\d]/g,'');
		 });
		 $(stringid).bind("afterpaste",function(){
			 this.value=this.value.replace(/[^\d]/g,'');
		 });
		 $(stringid).attr("maxLength",min);
	 } else if((initval == 2 )||( initval == 4)){
		 $(stringid).unbind("keyup");
    	 $(stringid).unbind("afterpaste");
		 $(stringid).bind("keyup",function(){
			 this.value=this.value.replace(/[^A-Za-z0-9\u4e00-\u9fa5]/g,'');
		 });
		 $(stringid).bind("afterpaste",function(){
			 this.value=this.value.replace(/[^A-Za-z0-9\u4e00-\u9fa5]/g,'');
		 });
		 $(stringid).attr("maxLength",max);
     } else{
		 $(stringid).unbind("keyup");
    	 $(stringid).unbind("afterpaste");
    	 $(stringid).attr("maxLength",max);
	 }
	 $(typeid).bind("change",function(){
		 $(stringid).val("");
		 var val = $(this).val();
		 if(val == 1 || val == 3){
			 $(stringid).unbind("keyup");
	    	 $(stringid).unbind("afterpaste");
			 $(stringid).bind("keyup",function(){
				 this.value=this.value.replace(/[^\d]/g,'');
			 });
			 $(stringid).bind("afterpaste",function(){
				 this.value=this.value.replace(/[^\d]/g,'');
			 });
			 $(stringid).attr("maxLength",min);
	     } else if(val == 2 || val==4){
			 $(stringid).unbind("keyup");
	    	 $(stringid).unbind("afterpaste");
			 $(stringid).bind("keyup",function(){
				 this.value=this.value.replace(/[^A-Za-z0-9\u4e00-\u9fa5]/g,'');
			 });
			 $(stringid).bind("afterpaste",function(){
				 this.value=this.value.replace(/[^A-Za-z0-9\u4e00-\u9fa5]/g,'');
			 });
			 $(stringid).attr("maxLength",max);
	     }else{
	    	 $(stringid).unbind("keyup");
	    	 $(stringid).unbind("afterpaste");
	    	 $(stringid).attr("maxLength",max);
	     }		 
	 });	 
 }
function updateQuery(){
	var typeId = document.getElementById("queryType");
	var obj = document.getElementById("queryString");
	if (typeId.value == 1 || typeId.value == 3) {
		obj.value=obj.value.replace(/[^\d]/g,'');
	}
	
	$("#queryForm").attr("action", "teller.do?method=queryTeller");
	$("#queryForm").submit();
}

var confirmDisable = '您确认禁用销售员';//您确认禁用销售员
var disableTeller = '禁用销售员';
var confirmDel = '您确认删除销售员';
var delTeller = '删除销售员';
var confirmEnable = '您确认启用销售员';
var enableTeller = '启用销售员';
var resetPassword = '重置密码';
var confirmResetPass = '您确认重置密码吗?';

function promptDisable(url,tellerName) {
	var msg = confirmDisable+": "+tellerName+"?";
	showDialog("operTeller('"+url+"')",disableTeller,msg);
}

function promptDelete(url,tellerName) {
	
	var msg = confirmDel+": "+tellerName+" ?";
	showDialog("operTeller('"+url+"')",delTeller,msg);
}

function promptEnable(url,tellerName) {
	
	var msg = confirmEnable+": "+tellerName+" ?";
	showDialog("operTeller('"+url+"')",enableTeller,msg);
}

function promptResetPs(url,tellerName) {
	
	var msg = confirmResetPass;
	showDialog("operTeller('"+url+"')",resetPassword,msg);
}

function operTeller(url){
	button_off("ok_button");
	$.ajax({
		url : url,
		dataType : "json",
		method : "post",
		async : false,
		success : function(r){
	            if(r.reservedSuccessMsg!='' && r.reservedSuccessMsg!=null){
		            closeDialog();
	            	showError(decodeURI(r.reservedSuccessMsg));
		        }
	            else{
	            	window.location.reload(); 
		       }
		}
	});
}
function clearValue(){
	$(".text-normal").val('');
	$(".select-normal").val(0);
}
</script>
</head>
<body>
	<div id="title">
		<span>销售员管理</span>
	</div>

	<div class="queryDiv">
		<form:form modelAttribute="tellerForm" action="teller.do?method=queryTeller" method="POST" id="queryForm">
			<div class="left">
			   <span>机构:
                    <select name="areaCode" class="select-normal" id="areaCode">
					    <option value="">--全部--</option>
					    <c:forEach var="data" items="${orgList}">
					     <option value="${data.orgCode}" <c:if test="${tellerForm.areaCode==data.orgCode }">selected</c:if>>${data.orgName }</option>
					    </c:forEach>
			 	     </select>
		  	   </span>
				<span>	
					<select id="queryType" name="queryType" class="select-normal">
						<option value="1">销售站编码</option>
						<option value="2">销售站名称</option>
						<option value="3">销售员编码</option>
						<option value="4">销售员名称</option>
					</select>
				</span>	
				<span><form:input path="tellerQueryString" id="queryString"  class="text-normal" /></span>
	            <span>销售员状态：
					<form:select path="tellerStatus.value" class="select-normal" id="tellerStatus">  
						<form:options items="${tellerStatus}"/>     		
					</form:select>
				</span>
				<span>销售员类型：
					<form:select path="tellerType.value" class="select-normal" id="tellerType">
						<form:options items="${tellerTypes}"/>				       		
					</form:select>
				</span>		
				<input type="button" value='查询' onclick="updateQuery();" class="button-normal"></input>
				<input type="button" value='清空' class="button-normal" onclick="clearValue()"></input>
			</div>
			<div class="right">
                <table width="260" border="0" cellspacing="0" cellpadding="0">
                    <tbody><tr style="height:50px;line-height:50px">
                        <td align="right">
                            <input type="button" value='新增销售员' onclick="showBox('teller.do?method=addTeller','新增销售员',300,700)" class="button-normal"></input>
                        </td>
                    </tr>
                </tbody></table>
            </div>
		</form:form>
	</div>

	<div id="headDiv">
		<table width="100%" border="0" cellpadding="0" cellspacing="0">
			<tr>
				<td>
					<table class="datatable" id="exportPdf">
		                <tr class="headRow">
		                <td style="width: 10px;">&nbsp;</td>
		                   <td style="width:10%">销售员编码</td>
		                   <th width="1%">|</th>
		                   <td style="width:10%">销售员名称</td>
		                   <th width="1%">|</th>
		                   <td style="width:10%">销售站编码</td>
		                   <th width="1%">|</th>
		                   <td style="width:10%">销售站名称</td>
		                   <th width="1%">|</th>
		                   <td style="width:10%">销售员状态</td>
		                   <th width="1%">|</th>
		                   <td style="width:10%">销售员类型</td>
		                   <th width="1%">|</th>
		                   <td style="width:*%" class="no-print">操作</td>
		                </tr>
		            </table>
				</td>
				<td style="width:17px;background:#2aa1d9"></td>
			</tr>
		</table>
	</div>
	
	<div id="bodyDiv">
	    <table class="datatable" id="exportPdfData">
			<c:forEach var="data" items="${pageDataList}" varStatus="status" >
			<tr class="dataRow">
			<td style="width: 10px;">&nbsp;</td>
				<td style="width:10%">${data.tellerCode}</td>
				<td width="1%">&nbsp;</td>
				<td style="width:10%" title="${data.tellerName }">${data.tellerName }</td>
				  <td width="1%">&nbsp;</td>
				<td style="width:10%">${data.agencyCode }</td>
				  <td width="1%">&nbsp;</td>
				<td style="width:10%" title="${data.agencyName }">${data.agencyName }</td>
				<td width="1%">&nbsp;</td>
				<td style="width:10%">
				 <c:forEach var="sta" items="${tellerStatus}">
				   <c:if test="${data.tellerStatus.value ==sta.key }">${sta.value }</c:if>
				 </c:forEach>
				</td>
				  <td width="1%">&nbsp;</td>
				<td style="width:10%">
				 <c:forEach var="ty" items="${tellerTypes}">
				   <c:if test="${data.tellerType.value==ty.key }">${ty.value }</c:if>
				 </c:forEach>
				</td>
				 <td width="1%">&nbsp;</td>
				<td style="width:*%" class="no-print">
					<c:choose>
						<c:when test="${data.tellerStatus.value == 1}">
							<span><a href="#" onclick="promptDisable('teller.do?method=disableTellerByCode&tellercode=${data.tellerCode}&tellerCodeToChar=${data.tellerCodeToChar}&tellername=${data.tellerName}','${data.tellerName}')">禁用</a></span> |
							<span><a href="#" onclick="promptDelete('teller.do?method=deleteTellerByCode&tellercode=${data.tellerCode}&tellerCodeToChar=${data.tellerCodeToChar}&tellername=${data.tellerName}','${data.tellerName}')">删除</a></span> |
							<span><a href="#" onclick="showBox('teller.do?method=editTeller&tellercode=${data.tellerCode}&tellerCodeToChar=${data.tellerCodeToChar}&tellername=${data.tellerName}','修改销售员',300,700)">修改</a></span> |
							<span><a href="#" onclick="promptResetPs('teller.do?method=resetPasswordByCode&tellercode=${data.tellerCode}&tellerCodeToChar=${data.tellerCodeToChar}&tellername=${data.tellerName}','${data.tellerName}')">重置密码</a></span>
						</c:when>
						<c:when test="${data.tellerStatus.value == 2}">
							<span><a href="#"  onclick="promptEnable('teller.do?method=enableTellerByCode&tellercode=${data.tellerCode}&tellerCodeToChar=${data.tellerCodeToChar}&tellername=${data.tellerName}','${data.tellerName}')">启用</a></span> |
							<span><a href="#" onclick="promptDelete('teller.do?method=deleteTellerByCode&tellercode=${data.tellerCode}&tellerCodeToChar=${data.tellerCodeToChar}&tellername=${data.tellerName}','${data.tellerName}')">删除</a></span> |
							<span><a href="#" onclick="showBox('teller.do?method=editTeller&tellercode=${data.tellerCode}&tellerCodeToChar=${data.tellerCodeToChar}&tellername=${data.tellerName}','修改销售员',300,700)">修改</a></span> |
							<span>重置密码</span>										
						</c:when>
						<c:when test="${data.tellerStatus.value == 3}">
							<span>启用</span> |
							<span>删除</span> |
							<span>修改</span> |
							<span>重置密码</span>
						</c:when>
					</c:choose>
				</td>
			</tr>
	    	</c:forEach>
	    </table>
	    ${pageStr }
    </div>
</body>
</html>