<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/views/common/taglibs.jsp"%>
<html>
<head>
<title>区域列表</title>

<link rel="stylesheet" type="text/css" href="${basePath}/css/city-list.css" />

<link rel="stylesheet" type="text/css" href="${basePath}/css/style.css" />
<link rel="stylesheet" href="${basePath}/component/messageBox/myJsBox.css" type="text/css"/>
<script type="text/javascript" src="${basePath}/component/messageBox/myJsBox_zh.js"></script>
<script type="text/javascript" src="${basePath}/js/jquery/jquery-1.9.1.js"></script>
<script type="text/javascript" src="${basePath}/js/oms/myJs.js"></script>

<script type="text/javascript" charset="UTF-8" > 
function updateQuery(){
    var req= /^[-_\~!@#\$%\^&\*\.\(\)\[\]\{\}<>\?\\\/\'\"]/;
    var str=$("#agencyNameQuery").val();
   
    var result = true;
    if(req.test(str)){
      doCheckMsg("agencyNameQuery",false,"含有特殊字符")
		result = false;
    
    }
   // if(req.test(agencyNameQuery))
   if(result){
    $("#queryForm").submit();
   }
}
function switchCity(cityCode,cityName)
{
	$('#curcitycode').val(cityCode);
	$('#curcityname').val(cityName);
	updateQuery();
} 
function prompt(areaCode,areaName,msg,msg1,url) {
	
	var msgbox =msg1+"\r\n"+areaName+"?";
	//button_off("ok_button");
	showDialog("operAte('"+url+"')",msg,msgbox);
}
function operAte(url) {
	button_off("ok_button");

	$.ajax({
		url : url,
		dataType : "json",
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
function doCheckMsg(id,regex,msg) {
	if(!regex) {
		$("#"+id+"Tip").text("");
		$("#"+id+"Tip").text(msg);
		$("#"+id+"Tip").removeClass("tip_init").addClass("tip_error");
	} else {
		$("#"+id+"Tip").text("");
		$("#"+id+"Tip").text("*");
	    $("#"+id+"Tip").removeClass("tip_error").addClass("tip_init");
	}
}
function onclear(){
	 $('#agencyCodeQuery').val('');
	 $('#agencyNameQuery').val('');

	 $("#areaCode option:first").prop("selected", 'selected');
	 $("#agencyStatus option:first").prop("selected", 'selected');
	 $("#agencytype option:first").prop("selected", 'selected');
}
function doclear(areaName,url) {
	var delmsg='您确认清退';
	var msg =delmsg+"\r\n"+areaName+"?";
	showDialog("showClear('"+url+"')",'清退',msg);
}

function showClear(url){
	button_off("ok_button");
	closeDialog();
	// showBox(url,'清退',600,800)
	showPage(url,'清退');
}
</script>

</head>
<body>
    <div id="title">
        <span  id="curdisplay">销售站管理 </span> 
    </div>
    <div class="queryDiv">
       <form:form modelAttribute="agencyForm" action="agency.do?method=listAgency" method="POST" id="queryForm">
       		<div class="left">
                     <span>机构:
                       <select name="areaCode" class="select-normal" id="areaCode">
						    <option value="">--全部--</option>
						    <c:forEach var="data" items="${orgList}">
						     <option value="${data.orgCode}" <c:if test="${agencyForm.areaCode==data.orgCode }">selected</c:if>>${data.orgName }</option>
						    </c:forEach>
						</select>
				  </span>
                     <span>站点编码:
                     <form:input path="agencyCode" id="agencyCodeQuery" class="text-normal" maxlength="10" onkeyup="this.value=this.value.replace(/\D/g,'')" onafterpaste="this.value=this.value.replace(/\D/g,'')" autocomplete="off"/>
                     </span>
                     <span>站点名称:
                      		<form:input path="agencyName" id="agencyNameQuery" maxlength="100" class="text-normal"/>
                      </span>
                      <span>站点状态:
                          <select name="agencyStatus.value" class="select-normal" id="agencyStatus">
					    <option value="0">--全部--</option>
					   <c:forEach var="data" items="${agencyStatusItems}">
					     <option value="${data.key}" <c:if test="${agencyForm.agencyStatus.value==data.key }">selected</c:if>>${data.value }</option>
					    </c:forEach>
					</select>
				</span>
                   <span>站点类型:
                      	<select name="agencytype" id="agencytype" class="select-normal"> 
					    <option value="0">--全部--</option>
						<option value="1" <c:if test="${agencyForm.agencytype==1}">selected</c:if>>传统终端</option>
						<option value="2" <c:if test="${agencyForm.agencytype==2}">selected</c:if>>受信终端</option>							       		
						<option value="4" <c:if test="${agencyForm.agencytype==4}">selected</c:if>>中心销售站</option>		
			     	</select>
			    </span>
			    </div>
			 <div class="right"> 
			 	 <input type="button" value="查询" onclick="updateQuery();" class="button-normal"></input>
                 <input type="button"  class="button-normal" value="清除" onclick="onclear();">
             </div>     
         </form:form>
    </div>
    <div id="headDiv">
        <table width="100%" border="0" cellpadding="0" cellspacing="0">
            <tr><td>
            <table class="datatable" id="exportPdf">
                <tr class="headRow">
                     <td style="width: 10px;">&nbsp;</td>
               		 <td style="width:10%" title="销售站编码">销售站编码</td>
               		 <th width="1%">|</th>
					<td style="width:10%" title="销售站名称">销售站名称</td>
					 <th width="1%">|</th>
					<td style="width:10%" title="区域名称">区域名称</td>
					 <th width="1%">|</th>
					<td style="width:10%" title="销售站状态">销售站状态</td>
					 <th width="1%">|</th>
					<td style="width:10%">销售站类型</td>
					 <th width="1%">|</th>
					<td style="width:10%" title="信用额度">信用额度</td>
					 <th width="1%">|</th>
					<td style="width:10%" title="账户余额">账户余额</td>
					 <th width="1%">|</th>
					<td style="width:*%" class="no-print">操作</td>
                </tr>
            </table>
           </td><td style="width:17px;background:#2aa1d9"></td></tr>
       </table>
    </div>

    <div id="bodyDiv">
        <table class="datatable" id="exportPdfData">
            <c:forEach var="data" items="${pageDataList}" varStatus="status" >
			<tr class="dataRow">
			    <td style="width: 10px;">&nbsp;</td>
				<td style="width:10%"> ${data.agencyCode}</td>
                <td width="1%">&nbsp;</td>
				<td style="width:10%"  title="${data.agencyName}">${data.agencyName}</td>
				<td width="1%">&nbsp;</td>
				<td style="width:10%"  title="${data.orgName}">${data.orgName}</td>
				<td width="1%">&nbsp;</td>
				<td style="width:10%">
				   <c:forEach var="data1" items="${agencyStatusItems}">
				     <c:if test="${data1.key==data.agencyStatus.value}">${data1.value}</c:if>
				   </c:forEach>
				</td>
				<td width="1%">&nbsp;</td>
				<td style="width:10%">
					<c:choose>
					 	<c:when test="${data.agencyType.value==1}">预缴款</c:when>
				  		<c:when test="${data.agencyType.value==2}">后缴款</c:when>
				        <c:otherwise>直属站</c:otherwise>
					</c:choose>
				</td>
				<td width="1%">&nbsp;</td>
				<td style="width:10%" align="right"><fmt:formatNumber value="${data.creditLimit}" /></td>
				<td width="1%">&nbsp;</td>
				<td style="width:10%" align="right"><fmt:formatNumber value="${data.accountBalance}" /></td>
				<td width="1%">&nbsp;</td>
				<td style="width:*%" class="no-print">
                 	<c:if test="${data.agencyStatus.value == 1 && data.agencyType.value != 4}">
						<span><a href="#" onclick="prompt('${data.agencyCode}','${data.agencyName}','禁用','您确认禁用','agency.do?method=disableAgencyByCode&agencycode=${data.agencyCode}')" >禁用</a></span> |
						<span><a href="#" onclick="doclear('${data.agencyName}','agency.do?method=returnAgency&agencycode=${data.agencyCode}')" >清退</a></span> |				
						<span><a href="#" onclick="showBox('agency.do?method=gameAuthen&agencycode=${data.agencyCode}&areaCode=${data.orgCode}','游戏授权',300,1000)">游戏授权</a></span> |
						<span><a href="#" onclick="showBox('agency.do?method=detailAgency&agencycode=${data.agencyCode}','详情',550,930)">详情</a></span> |
						<span><a href="#" onclick="showBox('terminal.do?method=addTerminal&agencycode=${data.agencyCode}&agencyCodeTochar=${data.agencyCodeToChar}&fatherArea=${data.agencyCode}&areaType=5','新增终端',400,700)"><img src="img/add-zdj.png" width="21" height="16" title="新增终端"/></a></span> |
						<span><a href="#" onclick="showBox('teller.do?method=addTeller&agencycode=${data.agencyCode}&agencyCodeTochar=${data.agencyCodeToChar}','新增销售员',300,700)"><img src="img/add-xsy.png" width="21" height="16" title="新增销售员"/></a></span>
					</c:if>
					<c:if test="${data.agencyStatus.value == 1 && data.agencyType.value == 4}">
						<span>启用</span> |
						<span>清退</span> |
						<span>游戏授权</span> |
						<span><a href="#" onclick="showBox('agency.do?method=detailAgency&agencycode=${data.agencyCode}&agencyCodeTochar=${data.agencyCodeToChar}&agencyname=${data.agencyName}','详情',550,930)">详情</a></span> 
					</c:if>
					<c:if test="${data.agencyStatus.value == 2 && data.agencyType.value != 4}">
						<span><a href="#" onclick="prompt('${data.agencyCode}','${data.agencyName}','启用','您确认启用','agency.do?method=enableAgencyBycode&agencycode=${data.agencyCode}')">启用</a></span> |						
						<span><a href="#" onclick="doclear('${data.agencyName}','agency.do?method=returnAgency&agencycode=${data.agencyCode}')" >清退</a></span> |								
						<span><a href="#" onclick="showBox('agency.do?method=gameAuthen&agencycode=${data.agencyCode}&agencyname=${data.agencyName}&areaCode=${data.orgCode}','游戏授权',300,1000)">游戏授权</a></span> |
						<span><a href="#" onclick="showBox('agency.do?method=detailAgency&agencycode=${data.agencyCode}&agencyname=${data.agencyName}','详情',550,930)">详情</a></span> |
						<span><a href="#" onclick="showBox('terminal.do?method=addTerminal&agencycode=${data.agencyCode}&agencyCodeTochar=${data.agencyCodeToChar}&fatherArea=${data.agencyCode}&areaType=5','新增终端',400,700)"><img src="img/add-zdj.png" width="21" height="16" title="新增终端"/></a></span> |
						<span><a href="#" onclick="showBox('teller.do?method=addTeller&agencycode=${data.agencyCode}','新增销售员',300,700)"><img src="img/add-xsy.png" width="21" height="16" title="新增销售员"/></a></span>
					</c:if>
					<c:if test="${data.agencyStatus.value == 2 && data.agencyType.value == 4}">
						<span>启用</span> |
						<span>清退</span> |
						<span>游戏授权</span> |
						<span><a href="#" onclick="showBox('agency.do?method=detailAgency&agencycode=${data.agencyCode}&agencyname=${data.agencyName}','详情',550,930)" >详情</a></span> 
					</c:if>
					<c:if test="${data.agencyStatus.value == 3}">
						<span>启用</span> |
						<span>清退</span> |
						<span>游戏授权</span> |
						<%-- <span><a href="#" onclick="showPage('agency.do?method=getRefunce&agencyCode=${data.agencyCode}','打印')">打印</a></span> | --%>
						<span><a href="#" onclick="showBox('agency.do?method=detailAgency&agencycode=${data.agencyCode}&agencyname=${data.agencyName}','详情',550,930)">详情</a></span>
					</c:if>
					
				</td>
			</tr>
		</c:forEach>
        </table>
        ${pageStr }
    </div>
</body>
</html>