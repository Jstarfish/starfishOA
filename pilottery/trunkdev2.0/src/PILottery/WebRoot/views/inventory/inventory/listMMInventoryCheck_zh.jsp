<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/views/common/taglibs.jsp"%>
<html>
<head>

<title>	市场管理员盘点列表</title>

<%@ include file="/views/common/meta.jsp" %>
<link rel="stylesheet" type="text/css" href="${basePath}/css/style.css" />
<link rel="stylesheet" href="${basePath}/component/messageBox/myJsBox.css" type="text/css"/>
<script type="text/javascript" src="${basePath}/component/messageBox/myJsBox_zh.js"></script>
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
    <div id="title">市场管理员盘点列表查询</div>
    
    <!-- 查询条件块 -->
    <div class="queryDiv">
		<form action="inventory.do?method=listMMInventoryCheck" id="checkPointForm" method="post">
			<div class="left">
				<span>日期: 
					<input id="cpDate" class="Wdate text-normal" name="cpDate" value="${checkPointForm.cpDate }" onfocus="WdatePicker({lang:'zh-cn',dateFmt:'yyyy-MM-dd',readOnly:true})"/>
				</span> 
				<span>机构:
            		<select class="select-normal" id="institutionCode" name="institutionCode"  onchange="getWhByInst();">
            			<option value="">--全部--</option>
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
				<span>盘点结果:
					<select name="result" id="result" class="select-normal">
                        <option value="">-全部-</option>                        
                        <option value="1" <c:if test="${checkPointForm.result ==1 }">selected="selected"</c:if>>一致</option>
                        <option value="0" <c:if test="${checkPointForm.result ==0 }">selected="selected"</c:if>>不一致</option>
                    </select>
				</span>
				
				<input type="button" value="查询" onclick="updateQuery();" class="button-normal"></input>
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
                            <td style="width:15%">盘点编号</td>
                            <td width="1%" >|</td>
                            <td style="width:20%">所属部门</td>
                            <td width="1%" >|</td>
                            <td style="width:15%">市场管理员</td>
                            <td width="1%" >|</td>
                            <td style="width:15%">盘点日期</td>
                            <td width="1%" >|</td>
                            <td style="width:15%">盘点结果</td>
                            <td width="1%" >|</td>
                            <td style="width:*%">操作</td>
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
						一致
					</c:when>
					<c:when test="${data.result == 0}">
						不一致
					</c:when>
				</c:choose>
				</td>
				<td width="1%">&nbsp;</td>
				<td style="width:*%">
                    <span>
                    	<c:if test="${data.result != 1}">
                    		<a href="#" onclick="showBox('inventory.do?method=getMMInventoryCheckDetail&cpNo=${data.cpNo}','盘点详情', 600, 980);">详情</a>
                    	</c:if> 
                    	<c:if test="${data.result == 1}">
                    		详情
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
