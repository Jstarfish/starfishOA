<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/views/common/taglibs.jsp"%>
<html>
<head>
<title>Institution Management</title>
<%@ include file="/views/common/meta.jsp" %>

<link rel="stylesheet" type="text/css" href="${basePath}/css/city-list.css" />
<link rel="stylesheet" type="text/css" href="${basePath}/css/style.css" />

<link rel="stylesheet" href="${basePath}/component/messageBox/myJsBox.css" type="text/css"/>
<script type="text/javascript" src="${basePath}/component/messageBox/myJsBox.js"></script>
<script type="text/javascript" src="${basePath}/js/jquery/jquery-1.9.1.js"></script>
<script type="text/javascript" src="${basePath}/js/oms/myJs.js"></script>

<script type="text/javascript" charset="UTF-8" > 
function updateQuery() {
	var areaCode = $("#areaCode").val();
	var areaName = $("#areaName").val();
	console.log('areaCode: ' + areaCode);
	console.log('areaName: ' + areaName);
	
	var result = true;
	
	if (result) {
		$("#omsAreaQueryForm").submit();
	}
}
</script>

</head>
<body>
	<div id="title">Institution Authorization</div>

	<div class="queryDiv">
		<form:form modelAttribute="omsAreaQueryForm" action="omsarea.do?method=listOMSArea" id="omsAreaQueryForm">
            <div class="left">                      
				<span>Institution Code：<form:input id="areaCode" path="areaCode" value="${omsAreaQueryForm.areaCode}" class="text-normal" maxlength="10"/></span>
				<span>Institution Name：<form:input id="areaName" path="areaName" value="${omsAreaQueryForm.areaName}" class="text-normal" maxlength="100"/></span>
				<input type="button" value="Query" onclick="updateQuery();" class="button-normal"></input>
            </div>
		</form:form>
    </div>
    
    <div id="headDiv">
        <table width="100%" border="0" cellpadding="0" cellspacing="0">
            <tr>
            	<td>
            		<table class="datatable">
                		<tr class="headRow">
                			<td style="width:10px;">&nbsp;</td>
							<td>Institution Code</td>
							<td width="1%">|</td>
	                        <td>Institution Name</td>
	                        <td width="1%">|</td>
	                        <td>Type</td>
	                        <td width="1%">|</td>
	                        <td>No. of Outlets</td>
	                        <td width="1%">|</td>
	                        <td>No. of Terminals</td>
	                        <td width="1%">|</td>
	                        <td>No. of Tellers</td>
	                        <td width="1%">|</td>
	                        <td style="width:20%">Operation</td>
		                </tr>
		            </table>
           		</td>
           		<td style="width:17px;background:#2aa1d9"></td>
           	</tr>
		</table>
    </div>

    <div id="bodyDiv">
        <table class="datatable">
        	<c:forEach var="data" items="${pageDataList}" varStatus="status">
	        	<tr class="dataRow">
	        		<td style="width:10px;">&nbsp;</td>
	        		<td>${data.areaCode}</td>
	        		<td width="1%">&nbsp;</td>
	        		<td>${data.areaName}</td>
	                <td width="1%">&nbsp;</td>
	                <c:if test="${data.areaType==1}">
	                	<td>Company</td>
	                </c:if>
	                <c:if test="${data.areaType==2}">
	                	<td>Agent</td>
	                </c:if>
	                <td width="1%">&nbsp;</td>
	                <td>${data.agencyNumberLimitString}</td>
	                <td width="1%">&nbsp;</td>
	                <td>${data.terminalNumberLimitString}</td>
	                <td width="1%">&nbsp;</td>
	                <td>${data.tellerNumberLimitString}</td>
	                <td width="1%">&nbsp;</td>
	                <td style="width:20%">
	                	<span><a href="#" onclick="showBox('omsarea.do?method=gameAuthen&areaCode=${data.areaCode}', 'Game Authentication', 500, 1000)">Game Auth</a></span>
	                </td>
	        	</tr>
        	</c:forEach>
        </table>
        ${pageStr}
    </div>
</body>
</html>