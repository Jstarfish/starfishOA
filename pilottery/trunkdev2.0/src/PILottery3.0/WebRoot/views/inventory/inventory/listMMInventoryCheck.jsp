<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/views/common/taglibs.jsp"%>
<html>
<head>

<title>MM Inventory Checks</title>

<%@ include file="/views/common/meta.jsp" %>
<link rel="stylesheet" type="text/css" href="${basePath}/css/style.css" />
<link rel="stylesheet" href="${basePath}/component/messageBox/myJsBox.css" type="text/css"/>
<script type="text/javascript" src="${basePath}/component/messageBox/myJsBox.js"></script>
<script type="text/javascript" src="${basePath}/component/My97DatePicker/WdatePicker.js"></script>
<script type="text/javascript" src="${basePath}/js/jquery/jquery-1.9.1.js"></script>

<script type="text/javascript" charset="UTF-8">
function updateQuery() {
    $("#checkPointForm").submit();
}
</script>

</head>
<body>
    <!-- 顶部标题块 -->
    <div id="title">MM Inventory Check</div>
    
    <!-- 查询条件块 -->
    <div class="queryDiv">
		<form action="inventory.do?method=listMMInventoryCheck" id="checkPointForm" method="post">
			<div class="left">
				<span>
					Date: 
					<input id="cpDate" class="Wdate text-normal" name="cpDate" value="${checkPointForm.cpDate }" onfocus="WdatePicker({lang:'en',dateFmt:'yyyy-MM-dd',readOnly:true})"/>
				</span> 
				<span>Institution:
            		<select class="select-normal" id="institutionCode" name="institutionCode"  onchange="getWhByInst();">
            			<option value="">--All--</option>
                   	    <c:forEach var="obj" items="${institutionList}" varStatus="plan">
                   	   		<c:if test="${obj.institutionCode == checkPointForm.institutionCode}">
                   	   			<option value="${obj.institutionCode}" selected="selected">${obj.institutionName}</option>
                   	   		</c:if>
                   	   		<c:if test="${obj.institutionCode != checkPointForm.institutionCode}">
                   	   			<option value="${obj.institutionCode}">${obj.institutionName}</option>
                   	   		</c:if>
                   	    </c:forEach>
                    </select>
            	</span>
				<span>
					Result:
					<select name="result" id="result" class="select-normal">
                        <option value="">All</option>    
                        <option value="1" <c:if test="${checkPointForm.result ==1 }">selected="selected"</c:if>>Balanced</option>   
                        <option value="0" <c:if test="${checkPointForm.result ==0 }">selected="selected"</c:if>>Different</option>                       
                    </select>
				</span>
				<input type="button" value="Query" onclick="updateQuery();" class="button-normal"></input>
			</div>
		</form>
	</div>
    
    <!-- 列表表头块 -->
    <div id="headDiv">
        <table width="100%" border="0" cellpadding="0" cellspacing="0">
            <tr>
                <td>
                    <table class="datatable">
                        <tr class="headRow">
                          <td style="width:10px;">&nbsp;</td>
                            <td style="width:15%">Check Code</td>
                            <td width="1%" >|</td>
                            <td style="width:20%">Institution</td>
                            <td width="1%" >|</td>
                            <td style="width:15%">Market Manager</td>
                            <td width="1%" >|</td>
                            <td style="width:15%">Date of Check</td>
                            <td width="1%" >|</td>
                            <td style="width:15%">Result</td>
                            <td width="1%" >|</td>
                            <td style="width:*%">Operation</td>
                        </tr>
                    </table>
                 </td>
                 <!-- 表头和下方数据对齐 -->
                 <td style="width:17px;background:#2aa1d9"></td>
             </tr>
        </table>
    </div>
    
    <!-- 列表内容块 -->
    <div id="bodyDiv">
        <table class="datatable">
        <c:forEach var="data" items="${pageDataList}" varStatus="status" >
            <tr class="dataRow">
	            <td style="width:10px;">&nbsp;</td>
				<td style="width: 15%">${data.cpNo }</td>
				<td width="1%">&nbsp;</td>
				<td style="width: 20%" >${data.orgName }</td>
				<td width="1%">&nbsp;</td>
				<td style="width: 15%" >${data.managerName}</td>
				<td width="1%">&nbsp;</td>
				<td style="width: 15%"><fmt:formatDate value="${data.cpDate}" pattern="yyyy-MM-dd HH:mm:ss" /></td>
				<td width="1%">&nbsp;</td>
				<td style="width: 15%">
					<c:choose>
						<c:when test="${data.result == 1}">
							Balanced
						</c:when>
						<c:when test="${data.result == 0}">
							Different
						</c:when>
					</c:choose>
				</td>
				<td width="1%">&nbsp;</td>
				<td style="width:*%">
                    <span>
                    	<c:if test="${data.result != 1}">
                    		<a href="#" onclick="showBox('inventory.do?method=getMMInventoryCheckDetail&cpNo=${data.cpNo}','Check Detail', 600, 980);">Detail</a>
                    	</c:if> 
                    	<c:if test="${data.result == 1}">
                    		Detail
                    	</c:if>
                    </span>                    
                </td>
            </tr>
        </c:forEach>
        </table>
     ${pageStr} 
    </div>
</body>
</html>
