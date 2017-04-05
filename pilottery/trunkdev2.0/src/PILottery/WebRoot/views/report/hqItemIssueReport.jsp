<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/views/common/taglibs.jsp"%>
<html>
<head>

<title>Headquarter Item Issue Report</title>


<%@ include file="/views/common/meta.jsp" %>
<link rel="stylesheet" type="text/css" href="${basePath}/css/style.css" />
<link rel="stylesheet" href="${basePath}/component/messageBox/myJsBox.css" type="text/css"/>

<script type="text/javascript" src="${basePath}/component/messageBox/myJsBox.js"></script>
<script type="text/javascript" src="${basePath}/component/My97DatePicker/WdatePicker.js"></script>
<script type="text/javascript" src="${basePath}/js/jquery/jquery-1.9.1.js"></script>
<script type="text/javascript" src="${basePath}/js/mydate.js"></script>
<script type="text/javascript">
$(function() {
	$('#selDate').change(function(){
		var select = $('#selDate').val();
		if(select == 0){
			$("input[name='startDate']").val(getToday());
			$("input[name='endDate']").val(getToday());
		}
		if(select == 1){
			$("input[name='startDate']").val(getYestoday(getToday()));
			$("input[name='endDate']").val(getYestoday(getToday()));
			
		}
		if(select == 2){
			$("input[name='startDate']").val(getWeekStartDate());
			$("input[name='endDate']").val(getToday());
		}
		if(select == 3){
			$("input[name='startDate']").val(getLastWeekStartDate());
			$("input[name='endDate']").val(getLastWeekEndDate());
		}
		if(select == 4){
			$("input[name='startDate']").val(getMonthStartDate());
			$("input[name='endDate']").val(getToday());
		}
		if(select == 5){
			$("input[name='startDate']").val(getLastMonthStartDate());
			$("input[name='endDate']").val(getLastMonthEndDate());
		}
	});
	var selDate = '${hqItemIssueReportForm.selDate }';
    $('#selDate').val(selDate);
});
</script>
</head>
<body>
    <!-- 顶部标题块 -->
    <div id="title">Headquarter Item Issue Report</div>

    <!-- 查询条件块 -->
    <div class="queryDiv">
    	<form id="hqItemIssueReportForm" name="hqItemIssueReportForm" method="post" action="hqItemIssueReport.do?method=initHQItemIssueReport">
	    	<div class="left">
	    		<span>Headquarter Warehouse:
	    			<select name="warehouseCode" id="warehouseCode" class="select-normal">
	    				<option value="">All</option>
	    				<c:forEach var="wh" items="${hqWarehouseList}">
	    					<option value="${wh.warehouseCode}" <c:if test="${wh.warehouseCode == hqItemIssueReportForm.warehouseCode}">selected="selected"</c:if>>${wh.warehouseName}</option>
	    				</c:forEach>
	    			</select>
	    		</span>
	    		<span>Start Date: <input id="startDate" name="startDate" value="${hqItemIssueReportForm.startDate}" class="Wdate text-normal" onfocus="WdatePicker({lang:'en',dateFmt:'yyyy-MM-dd',readOnly:true,isShowClear:true,isShowToday:true})" maxlength="40"/></span>
	    		<span>End Date: <input id="endDate" name="endDate" value="${hqItemIssueReportForm.endDate}" class="Wdate text-normal" onfocus="WdatePicker({lang:'en',dateFmt:'yyyy-MM-dd',readOnly:true,isShowClear:true,isShowToday:true})" maxlength="40"/></span>
	    		<span>
	              <select name="selDate" id="selDate" class="select-normal" style="width:180px" >
						<option value="0">--Please Select--</option>
						<option	value="1">Yesterday</option>
						<option	value="2" >This Week</option>
						<option	value="3">Last Week</option>
						<option	value="4">This Month</option>
						<option	value="5">Last Month</option>
					</select>
				</span>
	    		<input type="submit" value="Query" class="button-normal"></input>
	    	</div>
	    	<div class="right">
	    		<span style="position:absolute;right:80px;">
	    			<input type="hidden" id="reportTitle" name="reportTitle" value="Headquarter Item Issue Report">
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
                        	<td style="width:11%">Issue Code</td>
                        	<td width="1%" noExp="true">|</td>
                        	<td style="width:12%">Operator</td>
                        	<td width="1%" noExp="true">|</td>
                        	<td style="width:14%">Issue Date</td>
                        	<td width="1%" noExp="true">|</td>
                        	<td style="width:14%">Delivering Warehouse</td>
                        	<td width="1%" noExp="true">|</td>
                        	<td style="width:14%">Receiving Unit</td>
                        	<td width="1%" noExp="true">|</td>
                        	<td style="width:13%">Item Name</td>
                        	<td width="1%" noExp="true">|</td>
                        	<td style="width:*%">Quantity</td>
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