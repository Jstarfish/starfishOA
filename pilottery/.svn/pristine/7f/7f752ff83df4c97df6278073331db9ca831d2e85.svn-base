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
window.onload = function(){
    initPop();
};
jQuery(document).ready(function($) { 
	initinfo();
	 initQueryCondition("#queryType","#queryString",'10','100');

	 //$(".fy1").parent().find("div:last").addClass("docExport").hide();//给导出加class名
}) 
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
	initinfo();
	var typeId = document.getElementById("queryType");
	var obj = document.getElementById("queryString");
	if (typeId.value == 1 || typeId.value == 3) {
		obj.value=obj.value.replace(/[^\d]/g,'');
	}
	
	$("#queryForm").attr("action", "teller.do?method=queryTeller");
	//$('#curcityname').val(encodeURI($('#curcityname').val()));
	$("#queryForm").submit();
}
function initinfo(){
	var areaCode=$('#agencyStatus option:selected').text();
	var areaName=$('#tellerStatus option:selected').text();
	
	var title = "销售员管理|"
		+"销售站状态:"+areaCode
		+",销售员状态:"+areaName;
	
	$("#reportTitle").val(title);
}
function switchCity(cityCode,cityName){
	$('#curcitycode').val(cityCode);
	//var nameString = addParentPrefix(cityCode,cityName);
	$('#curcityname').val(cityName);	
	$("#curdisplay").html(cityName);	
	updateQuery();
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

function doExport(){
	location.href = $('.docExport a').attr('href');
}
function clearValue(){
	$(".text-normal").val('');
	$(".select-normal").val(0);
}
function exportcsv(){
	$("#queryForm").attr("action", "teller.do?method=exportCSV");
	$("#queryForm").submit();
}
</script>
</head>
<body>
	<div id="title">
		<span>销售员管理</span>
		
		
		<!-- city-list -->
		
		</div>
	</div>

	<div class="queryDiv">
		<form:form modelAttribute="tellerForm" action="teller.do?method=queryTeller" method="POST" id="queryForm">
				<input type="hidden" id="reportTitle" name="reportTitle" value="">
				<input type="hidden" id="pageIndex1" name="pageIndex1" value="${pageIndex1}">
			<div class="left">
			   <span> 区域编码:
			   <select name="areaCode" class="select-normal" id="areaCode">
						    <option value="0">请选择</option>
						    <c:forEach var="data" items="${orgList}">
						   
						     <option value="${data.orgCode}" <c:if test="${tellerForm.areaCode==data.orgCode }">selected</c:if>>${data.orgName }</option>
						    </c:forEach>
						</select>
			   </span>
				<span>	
				    					
					<form:select path="tellerQueryType.typeValue" class="select-normal" id="queryType">
						<%--<form:options items="${tellerForm.tellerQueryTypes}" itemValue="typeValue" itemLabel="typeName"/>--%>
						<form:options items="${tellerQueryTypes}"/>
					</form:select>
				</span>	
				<span><form:input path="tellerQueryString" id="queryString"  class="text-normal" autocomplete="off"/></span>
				<span>销售站状态：						
					<form:select path="agencyStatus.value" class="select-normal" id="agencyStatus">
						<form:option value="0">请选择</form:option>
						<form:options items="${agencyStatusItems}"/>
					</form:select>
				</span>          
				                    
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
				<form:hidden path="curCityCode" id="curcitycode"  />
				<form:hidden path="curCityName" id="curcityname"/>
			</div>
			<div class="right">
   				<table width="290" border="0" cellspacing="0" cellpadding="0">
                    <tr style="height:50px;line-height:50px">
                      <td align="right">
                      
                        <input type="button" value='新增销售员' onclick="showBox('teller.do?method=addTeller','新增销售员',300,700)" class="button-normal"></input>
                      </td>
                      
                      <td align="right">
                       <er:exportReport url="${pageContext.request.contextPath }/er/exportReportServlet"  classs="icon-lz" types="pdfList" tableId="exportPdf"  title="exportPdf"></er:exportReport>
                         
                      </td>
                      <td style="width:30px"></td>
                      <td align="right">

                       <a href="#" class="icon-lz" onclick="exportcsv();"><img src="img/daochu.png" width="21" height="16" />下载</a> 
                      </td>
                    </tr>
                  </table>
   			</div>
		</form:form>
	</div>


	<div id="headDiv">
		<table width="100%" border="0" cellpadding="0" cellspacing="0">
			<tr>
				<td>
					<table class="datatable" id="exportPdf">
		                <tr class="headRow">
		                   <td style="width:80px">销售员编码</td>
		                   <td style="width:100px">销售员姓名</td>
		                   <td style="width:100px">销售站编码</td>
		                   <td style="width:120px">销售站名称</td>
		                   <td style="width:80px">销售员状态</td>
		                   <td style="width:100px">销售员类型</td>
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
				<td style="width:80px">${data.tellerCodeToChar }</td>
				<td style="width:100px" title="${data.tellerName }">${data.tellerName }</td>
				<td style="width:100px">${data.agencyCodeToChar }</td>
				<td style="width:120px" title="${data.agencyParent.name }">${data.agencyParent.name }</td>
				<td style="width:80px">${data.tellerStatus.name }</td>
				<td style="width:100px">${data.tellerType.name }</td>
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