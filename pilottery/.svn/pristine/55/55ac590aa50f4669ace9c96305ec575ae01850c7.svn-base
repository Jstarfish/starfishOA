<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/views/common/taglibs.jsp"%>
<html>
<head>
<title>区域列表</title>
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
	<div id="title">区域管理</div>

	<div class="queryDiv">
		<form:form modelAttribute="omsAreaQueryForm" action="omsarea.do?method=listOMSArea" id="omsAreaQueryForm">
            <div class="left">                      
				<span>区域编码：<form:input id="areaCode" path="areaCode" value="${omsAreaQueryForm.areaCode}" class="text-normal" maxlength="10"/></span>
				<span>区域名称：<form:input id="areaName" path="areaName" value="${omsAreaQueryForm.areaName}" class="text-normal" maxlength="100"/></span>
				<input type="button" value="查询" onclick="updateQuery();" class="button-normal"></input>
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
							<td>编码</td>
							<td width="1%">|</td>
	                        <td>区域名称</td>
	                        <td width="1%">|</td>
	                        <td>区域级别</td>
	                        <td width="1%">|</td>
	                        <td>销售站数量</td>
	                        <td width="1%">|</td>
	                        <td>终端机数量</td>
	                        <td width="1%">|</td>
	                        <td>销售员数量</td>
	                        <td width="1%">|</td>
	                        <td style="width:20%">操作</td>
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
	                <c:if test="${data.areaType==0}">
   	                	<td>中心</td>
	                </c:if>
	                <c:if test="${data.areaType==1}">
	                	<td>一级区域</td>
	                </c:if>
	                <c:if test="${data.areaType==2}">
	                	<td>二级区域</td>
	                </c:if>
	                <td width="1%">&nbsp;</td>
	                <td>${data.agencyNumberLimitString}</td>
	                <td width="1%">&nbsp;</td>
	                <td>${data.tellerNumberLimitString}</td>
	                <td width="1%">&nbsp;</td>
	                <td>${data.terminalNumberLimitString}</td>
	                <td width="1%">&nbsp;</td>
	                <td style="width:20%">
	                	<span><a href="#" onclick="showBox('omsarea.do?method=gameAuthen&areaCode=${data.areaCode}', '游戏授权', 500, 1000)">游戏授权</a></span>
	                </td>
	        	</tr>
        	</c:forEach>
        </table>
        ${pageStr}
    </div>
</body>
</html>