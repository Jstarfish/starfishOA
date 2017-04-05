<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/views/common/taglibs.jsp"%>
<html>
<head>

<title>总部物品出库报表</title>


<%@ include file="/views/common/meta.jsp" %>
<link rel="stylesheet" type="text/css" href="${basePath}/css/style.css" />
<link rel="stylesheet" href="${basePath}/component/messageBox/myJsBox.css" type="text/css"/>

<script type="text/javascript" src="${basePath}/component/messageBox/myJsBox_zh.js"></script>
<script type="text/javascript" src="${basePath}/component/My97DatePicker/WdatePicker.js"></script>
<script type="text/javascript" src="${basePath}/js/jquery/jquery-1.9.1.js"></script>

</head>
<body>
    <!-- 顶部标题块 -->
    <div id="title">总部物品出库报表</div>

    <!-- 查询条件块 -->
    <div class="queryDiv">
    	<form id="hqItemIssueReportForm" name="hqItemIssueReportForm" method="post" action="hqItemIssueReport.do?method=initHQItemIssueReport">
	    	<div class="left">
	    		<span>总部仓库:
	    			<select name="warehouseCode" id="warehouseCode" class="select-normal">
	    				<option value="">全部</option>
	    				<c:forEach var="wh" items="${hqWarehouseList}">
	    					<option value="${wh.warehouseCode}" <c:if test="${wh.warehouseCode == hqItemIssueReportForm.warehouseCode}">selected="selected"</c:if>>${wh.warehouseName}</option>
	    				</c:forEach>
	    			</select>
	    		</span>
	    		<span>开始日期: <input id="startDate" name="startDate" value="${hqItemIssueReportForm.startDate}" class="Wdate text-normal" onfocus="WdatePicker({lang:'zh-cn',dateFmt:'yyyy-MM-dd',readOnly:true,isShowClear:true,isShowToday:true})" maxlength="40"/></span>
	    		<span>结束日期: <input id="endDate" name="endDate" value="${hqItemIssueReportForm.endDate}" class="Wdate text-normal" onfocus="WdatePicker({lang:'zh-cn',dateFmt:'yyyy-MM-dd',readOnly:true,isShowClear:true,isShowToday:true})" maxlength="40"/></span>
	    		<input type="submit" value="查询" class="button-normal"></input>
	    	</div>
	    	<div class="right">
	    		<span style="position:absolute;right:80px;">
	    			<input type="hidden" id="reportTitle" name="reportTitle" value="总部物品出库报表">
	    			<er:exportReport url="${pageContext.request.contextPath}/er/exportReportServlet" types="excel" classs="icon-lz" tableId="exportPdf" title="exportPdf"></er:exportReport>
	    		</span>
	    	</div>
    	</form>
    </div>
    
    <!-- 列表表头块 -->
    <div id="headDiv">
    	<table width="100%" border="0" cellpadding="0" cellspacing="0">
    		<tr>
    			<td>
    				<table class="datatable" id="exportPdf">
                        <tr class="headRow">
                        	<td style="width:10px;" noExp="true">&nbsp;</td>
                        	<td style="width:11%">出库单编号</td>
                        	<td width="1%" noExp="true">|</td>
                        	<td style="width:12%">出库人</td>
                        	<td width="1%" noExp="true">|</td>
                        	<td style="width:14%">出库日期</td>
                        	<td width="1%" noExp="true">|</td>
                        	<td style="width:14%">出库仓库</td>
                        	<td width="1%" noExp="true">|</td>
                        	<td style="width:14%">收货单位</td>
                        	<td width="1%" noExp="true">|</td>
                        	<td style="width:13%">物品名称</td>
                        	<td width="1%" noExp="true">|</td>
                        	<td style="width:*%">物品数量</td>
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
    	<table class="datatable" id="exportPdfData">
    		<c:forEach var="obj" items="${reportVoList}" varStatus="status">
    			<tr class="dataRow">
    				<td style="width:10px;" noExp="true">&nbsp;</td>
    				<td style="width:11%">${obj.issueCode}</td>
                   	<td width="1%" noExp="true">&nbsp;</td>
                   	<td style="width:12%">${obj.operatorName}</td>
                   	<td width="1%" noExp="true">&nbsp;</td>
                   	<td style="width:14%">${obj.issueDate}</td>
                   	<td width="1%" noExp="true">&nbsp;</td>
                   	<td style="width:14%">${obj.sendWhName}</td>
                   	<td width="1%" noExp="true">&nbsp;</td>
                   	<td style="width:14%">${obj.receiveOrgName}</td>
                   	<td width="1%" noExp="true">&nbsp;</td>
                   	<td style="width:13%">${obj.itemName}</td>
                   	<td width="1%" noExp="true">&nbsp;</td>
                   	<td style="width:*%">${obj.quantity}</td>
    			</tr>
    		</c:forEach>
    	</table>
    </div>
</body>
</html>