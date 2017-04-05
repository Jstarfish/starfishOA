<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/views/common/taglibs.jsp"%>
<html>
<head>

<title>Sales Report By Plan</title>

<%@ include file="/views/common/meta.jsp" %>
<link rel="stylesheet" type="text/css" href="${basePath}/css/style.css" />
<link rel="stylesheet" href="${basePath}/component/messageBox/myJsBox.css" type="text/css"/>

<script type="text/javascript" src="${basePath}/component/messageBox/myJsBox_zh.js"></script>
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
    <div id="title">市场管理员库存日结报表</div>
    
    <!-- 查询条件块 -->
    <div class="queryDiv">
        <form action="saleReport.do?method=querymmInventoryDaliyReport" id="queryForm" method="post">
            <div class="left">
            	<span>机构:
            		<select class="select-normal" id="institutionCode" name="institutionCode"  onchange="getWhByInst();">
            			<option value="">--全部--</option>
                   	    <c:forEach var="obj" items="${institutionList}" varStatus="plan">
                   	   		<c:if test="${obj.institutionCode == form.institutionCode}">
                   	   			<option value="${obj.institutionCode}" selected="selected">${obj.institutionName}</option>
                   	   		</c:if>
                   	   		<c:if test="${obj.institutionCode != form.institutionCode}">
                   	   			<option value="${obj.institutionCode}">${obj.institutionName}</option>
                   	   		</c:if>
                   	    </c:forEach>
                    </select>
            	</span>
            	<span>市场管理员姓名:
            	 <input name="marketName" value="${form.marketName }" class="text-normal"/> 
            	</span>
                <span>日期:
                    <input name="beginDate" value="${form.beginDate }" class="Wdate text-normal" onfocus="WdatePicker({lang:'zh-cn',dateFmt:'yyyy-MM-dd',readOnly:true})"/> 
                    	-
                    <input name="endDate" value="${form.endDate }" class="Wdate text-normal" onfocus="WdatePicker({lang:'zh-cn',dateFmt:'yyyy-MM-dd',readOnly:true})"/>
                </span>
                <span>
	              <select name="selDate" id="selDate" class="select-normal" style="width:180px" >
						<option value="0">--请选择日期--</option>
						<option	value="1">昨天</option>
						<option	value="2" >本周</option>
						<option	value="3" >上周</option>
						<option	value="4" >本月</option>
						<option	value="5" >上月</option>
					</select>
				</span>
                <input type="submit" value="查询" class="button-normal"></input>
            </div>
             <div style="overflow: right;">
	        	<span style="position: absolute;right: 80px;">
	        		<input type="hidden" id="reportTitle" name="reportTitle" value="市场管理员库存日结报表">
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
                            <td style="width:9%">日期</td>
                            <td width="1%" noExp="true">|</td>
                            <td style="width:12%">市场管理员</td>
                            <td width="1%" noExp="true">|</td>
                            <td style="width:9%">方案名称</td>
                            <td width="1%" noExp="true">|</td>
                            <td style="width:9%">期初数量</td>
                            <td width="1%" noExp="true">|</td>
                            <td style="width:9%">收货数量</td>
                            <td width="1%" noExp="true">|</td>
                            <td style="width:9%">还货数量</td>
                            <td width="1%" noExp="true">|</td>
                            <td style="width:9%">销售数量</td>
                            <td width="1%" noExp="true">|</td>
                            <td style="width:9%">退货数量</td>
                            <td width="1%" noExp="true">|</td>
                            <td style="width:9%">损毁数量</td>
                            <td width="1%" noExp="true">|</td>
                            <td style="width:*%">期末数量</td>
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
        
        <c:forEach var="obj" items="${listreport}">
            <tr class="dataRow">
            	<td style="width:10px;" noExp="true">&nbsp;</td>
                <td style="width:9%">${obj.calcDate}</td>
                <td width="1%" noExp="true">&nbsp;</td>
                <td style="width:12%">${obj.marketAdmin }</td>
                <td width="1%" noExp="true">&nbsp;</td>
                <td style="width:9%">${obj.planName}</td>
                <td width="1%" noExp="true">&nbsp;</td>
                <td style="width:9%"><fmt:formatNumber value="${obj.openInv }" /></td>
                <td width="1%" noExp="true">&nbsp;</td>
                <td style="width:9%"><fmt:formatNumber value="${obj.gotTickets }" /></td>
                <td width="1%" noExp="true">&nbsp;</td>
                <td style="width:9%"><fmt:formatNumber value="${obj.returnTickets }" /></td>
                <td width="1%" noExp="true">&nbsp;</td>
                <td style="width:9%"><fmt:formatNumber value="${obj.saledTickets }" /></td>
                <td width="1%" noExp="true">&nbsp;</td>
                <td style="width:9%"><fmt:formatNumber value="${obj.canceledTickets}" /></td>
                <td width="1%" noExp="true">&nbsp;</td>
                <td style="width:9%"><fmt:formatNumber value="${obj.brokenTickets }" /></td>
                <td width="1%" noExp="true">&nbsp;</td>
                <td style="width:*%"><fmt:formatNumber value="${obj.closeInv }"/></td>
            </tr>
          </c:forEach>
        </table>
    </div>
</body>
</html>