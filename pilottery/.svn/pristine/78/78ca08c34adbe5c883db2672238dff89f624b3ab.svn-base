<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/views/common/taglibs.jsp"%>
<html>
<head>

<title>Sales Report By Plan</title>

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
    <div id="title">Validate Winning Report</div>
    
    <!-- 查询条件块 -->
    <div class="queryDiv">
        <form action="checktickets.do?method=querystatisticalReports" id="queryForm" method="post">
            <div class="left">
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
					<input type="hidden" id="reportTitle" name="reportTitle" value="Validate Winning Report">
	            	<er:exportReport url="${pageContext.request.contextPath }/er/exportReportServlet" types="excel" classs="icon-lz" tableId="exportPdf"  title="exportPdf"></er:exportReport>
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
                         
           
                            <td style="width:9%">Date</td>
                            <td width="1%" noExp="true">|</td>
	                        <td style="width:12%">Institution</td>
	                        <td width="1%" noExp="true">|</td>
                            <td style="width:9%">Quantity</td>
                            <td width="1%" noExp="true">|</td>
                            <td style="width:9%">Amount</td>
                            <td width="1%" noExp="true">|</td>
                            <td style="width:9%">Love</td>
                            <td width="1%" noExp="true">|</td>
                            <td style="width:9%">Gongxi</td>
                            <td width="1%" noExp="true">|</td>
                            <td style="width:9%">Ball</td>
                            <td width="1%" noExp="true">|</td>
                            <td style="width:9%">Iphone</td>
                            <td width="1%" noExp="true">|</td>
                            <td style="width:*%">DGL</td>
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
        
        <c:forEach var="obj" items="${listchek}">
            <tr class="dataRow">
            	<td style="width:10px;" noExp="true">&nbsp;</td>
              
                <td style="width:9%"><fmt:formatDate  value="${obj.paidDay}"  pattern="yyyy-MM-dd" /></td>
                <td width="1%" noExp="true">&nbsp;</td>
                <td style="width:12%">${obj.orgName }</td>
                <td width="1%" noExp="true">&nbsp;</td>
                <td style="width:9%;"><fmt:formatNumber value="${obj.totalTickets }" /></td>
                <td width="1%" noExp="true">&nbsp;</td>
                <td style="width:9%;text-align: right;"><fmt:formatNumber value="${obj.totalAmount }" /></td>
                <td width="1%" noExp="true">&nbsp;</td>
                <td style="width:9%;text-align: right;">[<fmt:formatNumber value="${obj.loveTickets }" />] &nbsp;&nbsp;<fmt:formatNumber value="${obj.loveAmount}" /></td>
                <td width="1%" noExp="true">&nbsp;</td>
                <td style="width:9%;text-align: right;">[<fmt:formatNumber value="${obj.gongxiTickets }" />] &nbsp;&nbsp;<fmt:formatNumber value="${obj.gongxiAmount}" /></td>
                <td width="1%" noExp="true">&nbsp;</td>
                <td style="width:9%;text-align: right;">[<fmt:formatNumber value="${obj.ballTickets }" />] &nbsp;&nbsp;<fmt:formatNumber value="${obj.ballAmount}" /></td>
                <td width="1%" noExp="true">&nbsp;</td>
                 <td style="width:9%;text-align: right;">[<fmt:formatNumber value="${obj.iphoneTickets }" />] &nbsp;&nbsp;<fmt:formatNumber value="${obj.iphoneAmount}" /></td>
                <td width="1%" noExp="true">&nbsp;</td>
                <td style="width:*%;text-align: right;">[<fmt:formatNumber value="${obj.dglTickets}" />] &nbsp;&nbsp;<fmt:formatNumber value="${obj.dglAmount}" /></td>
            </tr>
          </c:forEach>
        </table>
    </div>
</body>
</html>