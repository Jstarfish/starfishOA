<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/views/common/taglibs.jsp"%>
<html>
<head>

<title>Agent Fund Report(USD)</title>

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
			$("input[name='beginDate']").val(getToday());
			$("input[name='endDate']").val(getToday());
		}
		if(select == 1){
			$("input[name='beginDate']").val(getYestoday(getToday()));
			$("input[name='endDate']").val(getYestoday(getToday()));
			
		}
		if(select == 2){
			$("input[name='beginDate']").val(getWeekStartDate());
			$("input[name='endDate']").val(getToday());
		}
		if(select == 3){
			$("input[name='beginDate']").val(getLastWeekStartDate());
			$("input[name='endDate']").val(getLastWeekEndDate());
		}
		if(select == 4){
			$("input[name='beginDate']").val(getMonthStartDate());
			$("input[name='endDate']").val(getToday());
		}
		if(select == 5){
			$("input[name='beginDate']").val(getLastMonthStartDate());
			$("input[name='endDate']").val(getLastMonthEndDate());
		}
	});
	var selDate = '${form.selDate }';
    $('#selDate').val(selDate);
});
</script>
</head>
<body>
    <!-- 顶部标题块 -->
    <div id="title">Agent Fund Report(USD)</div>
   
    <!-- 查询条件块 -->
    <div class="queryDiv">
        <form action="saleReport.do?method=agentFundReportUSD" id="queryForm" method="post">
            <div class="left">
            	<span>Institution:
            		<select class="select-normal" name="institutionCode" >
            			<option value="">--All--</option>
                   	   <c:forEach var="obj" items="${institutionList}" varStatus="plan">
                   	   		<c:if test="${obj.institutionCode == form.institutionCode && obj.orgType == 2}">
                   	   			<option value="${obj.institutionCode}" selected="selected">${obj.institutionName}</option>
                   	   		</c:if>
                   	   		<c:if test="${obj.institutionCode != form.institutionCode && obj.orgType == 2}">
                   	   			<option value="${obj.institutionCode}">${obj.institutionName}</option>
                   	   		</c:if>
                   	   </c:forEach>
                    </select>
            	</span>
                <span>Date:
                    <input name="beginDate" value="${form.beginDate }" class="Wdate text-normal" onfocus="WdatePicker({lang:'en',dateFmt:'yyyy-MM-dd',readOnly:true})"/> 
                    	-
                    <input name="endDate" value="${form.endDate }" class="Wdate text-normal" onfocus="WdatePicker({lang:'en',dateFmt:'yyyy-MM-dd',readOnly:true})"/>
                </span>
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
             <div style="overflow: right;">
	        	<span style="position: absolute;right: 80px;">
	        		<input type="hidden" id="reportTitle" name="reportTitle" value="Agent Fund Report(USD)">
	            	<er:exportReport url="${pageContext.request.contextPath }/er/exportReportServlet" types="excel" classs="icon-lz" tableId="exportPdf"  title="exportPdf"></er:exportReport>
	            </span>
        	</div>
        </form>
    </div>
    
    <!-- 列表表头块 -->
    <div id="headDiv">
        <table width="100%" border="0" cellpadding="0" cellspacing="0" >
            <tr>
                <td>
                    <table class="datatable" id="exportPdf">
                        <tr class="headRow">
                        	<td style="width:10px;" noExp="true">&nbsp;</td>
                        	<td style="width:5%" title="Date">Date</td>
                            <td width="1%" noExp="true">|</td>
                            <td style="width:7%" title="Agent Name">Agent Name</td>
                            <td width="1%" noExp="true">|</td>
                            <td style="width:5%" title="Begin Balance">Begin Balance</td>
                            <td width="1%" noExp="true">|</td>
                            <td style="width:5%" title="Top Up">Top Up</td>
                            <td width="1%" noExp="true">|</td>
                            <td style="width:5%" title="Withdraw">Withdraw</td>
                            <td width="1%" noExp="true">|</td>
                            <td style="width:5%" title="Transfer In">Transfer In</td>
                            <td width="1%" noExp="true">|</td>
                            <td style="width:5%" title="Sales Comm">Sales Comm</td>
                            <td width="1%" noExp="true">|</td>
                            <td style="width:5%" title="Transfer Out">Transfer Out</td>
                            <td width="1%" noExp="true">|</td>
                            <td style="width:5%" title="Return Comm">Return Comm</td>
                            <td width="1%" noExp="true">|</td>
                            <td style="width:5%" title="Payout">Payout</td>
                            <td width="1%" noExp="true">|</td>
                            <td style="width:5%" title="Payout Comm">Payout Comm</td>
                            <td width="1%" noExp="true">|</td>
                            <td style="width:5%" title="Center Cancel">Center Cancel</td>
                            <td width="1%" noExp="true">|</td>
                            <td style="width:5%" title="Cancel Comm">Cancel Comm</td>
                            <td width="1%" noExp="true">|</td>
                            <td style="width:5%" title="Center Payout">Center Payout</td>
                            <td width="1%" noExp="true">|</td>
                            <td style="width:6%" title="CPayout Comm">CPayout Comm</td>
                            <td width="1%" noExp="true">|</td>
                            <td style="width:*%" title="End Balance">End Balance</td>
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
        <c:if test="${fn:length(list) > 0}">
        	<tr class="dataRow">
            	<td style="width:10px;" noExp="true">&nbsp;</td>
            	<td style="width:5%">Total</td>
                <td width="1%" noExp="true">&nbsp;</td>
                <td style="width:7%">&nbsp;</td>
                <td width="1%" noExp="true">&nbsp;</td>
                <td style="width:5%">&nbsp;</td>
                <td width="1%" noExp="true">&nbsp;</td>
                <td style="width:5%;text-align: right;"><fmt:formatNumber value="${sum.topUp }" /></td>
                <td width="1%" noExp="true">&nbsp;</td>
                <td style="width:5%;text-align: right;"><fmt:formatNumber value="${sum.withdraw }" /></td>
                <td width="1%" noExp="true">&nbsp;</td>
                <td style="width:5%;text-align: right;"><fmt:formatNumber value="${sum.saleAmount }" /></td>
                <td width="1%" noExp="true">&nbsp;</td>
                <td style="width:5%;text-align: right;"><fmt:formatNumber value="${sum.saleComm }" /></td>
                <td width="1%" noExp="true">&nbsp;</td>
                <td style="width:5%;text-align: right;"><fmt:formatNumber value="${sum.returnAmount }" /></td>
                <td width="1%" noExp="true">&nbsp;</td>
                <td style="width:5%;text-align: right;"><fmt:formatNumber value="${sum.returnComm }" /></td>
                <td width="1%" noExp="true">&nbsp;</td>
                <td style="width:5%;text-align: right;"><fmt:formatNumber value="${sum.payout }" /></td>
                <td width="1%" noExp="true">&nbsp;</td>
                <td style="width:5%;text-align: right;"><fmt:formatNumber value="${sum.payoutComm }" /></td>
                <td width="1%" noExp="true">&nbsp;</td>
                <td style="width:5%;text-align: right;"><fmt:formatNumber value="${sum.cancelAmount }" /></td>
                <td width="1%" noExp="true">&nbsp;</td>
                <td style="width:5%;text-align: right;"><fmt:formatNumber value="${sum.agencyCancelComm }" /></td>
                <td width="1%" noExp="true">&nbsp;</td>
                <td style="width:5%;text-align: right;"><fmt:formatNumber value="${sum.centerPayAmount }" /></td>
                <td width="1%" noExp="true">&nbsp;</td>
                <td style="width:6%;text-align: right;"><fmt:formatNumber value="${sum.centerPayComm }" /></td>
                <td width="1%" noExp="true">&nbsp;</td>
                <td style="width:*%">&nbsp;</td>
            </tr>
        </c:if>
        <c:forEach var="obj" items="${list}" varStatus="status" >
            <tr class="dataRow">
            	<td style="width:10px;" noExp="true">&nbsp;</td>
            	<td style="width:5%">${obj.balanceDate }</td>
                <td width="1%" noExp="true">&nbsp;</td>
                <td style="width:5%" title="${obj.orgName }">${obj.orgName }</td>
                <td width="1%" noExp="true">&nbsp;</td>
                <td style="width:5%;text-align: right;"><fmt:formatNumber value="${obj.initialBalance }" /></td>
                <td width="1%" noExp="true">&nbsp;</td>
                <td style="width:5%;text-align: right;"><fmt:formatNumber value="${obj.topUp }" /></td>
                <td width="1%" noExp="true">&nbsp;</td>
                <td style="width:5%;text-align: right;"><fmt:formatNumber value="${obj.withdraw }" /></td>
                <td width="1%" noExp="true">&nbsp;</td>
                <td style="width:5%;text-align: right;"><fmt:formatNumber value="${obj.saleAmount }" /></td>
                <td width="1%" noExp="true">&nbsp;</td>
                <td style="width:5%;text-align: right;"><fmt:formatNumber value="${obj.saleComm }" /></td>
                <td width="1%" noExp="true">&nbsp;</td>
                <td style="width:5%;text-align: right;"><fmt:formatNumber value="${obj.returnAmount }" /></td>
                <td width="1%" noExp="true">&nbsp;</td>
                <td style="width:5%;text-align: right;"><fmt:formatNumber value="${obj.returnComm }" /></td>
                <td width="1%" noExp="true">&nbsp;</td>
                <td style="width:5%;text-align: right;"><fmt:formatNumber value="${obj.payout }" /></td>
                <td width="1%" noExp="true">&nbsp;</td>
                <td style="width:5%;text-align: right;"><fmt:formatNumber value="${obj.payoutComm }" /></td>
                <td width="1%" noExp="true">&nbsp;</td>
                <td style="width:5%;text-align: right;"><fmt:formatNumber value="${obj.cancelAmount }" /></td>
                <td width="1%" noExp="true">&nbsp;</td>
                <td style="width:5%;text-align: right;"><fmt:formatNumber value="${obj.agencyCancelComm }" /></td>
                <td width="1%" noExp="true">&nbsp;</td>
                <td style="width:5%;text-align: right;"><fmt:formatNumber value="${obj.centerPayAmount }" /></td>
                <td width="1%" noExp="true">&nbsp;</td>
                <td style="width:6%;text-align: right;"><fmt:formatNumber value="${obj.centerPayComm }" /></td>
                <td width="1%" noExp="true">&nbsp;</td>
                <td style="width:*%;text-align: right;"><fmt:formatNumber value="${obj.finalBalance }" /></td>
            </tr>
          </c:forEach>
        </table>
    </div>
</body>
</html>