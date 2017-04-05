<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/views/common/taglibs.jsp"%>
<html>
<head>

<title>游戏销售报表</title>

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
    <div id="title">游戏销售报表</div>
    
    <!-- 查询条件块 -->
    <div class="queryDiv">
        <form action="saleReport.do?method=getGameSalesReport" id="queryForm" method="post">
            <div class="left">
            	<span>机构:
            		<select class="select-normal" name="institutionCode" >
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
            	<span>方案:
            		<select name="planCode" class="select-normal">
            			<option value="">--全部--</option>
                   	   <c:forEach var="obj" items="${planList}" varStatus="plan">
                   	   		<c:if test="${obj.planCode == form.planCode}">
                   	   			<option value="${obj.planCode}" selected="selected">${obj.planCode}</option>
                   	   		</c:if>
                   	   		<c:if test="${obj.planCode != form.planCode}">
                   	   			<option value="${obj.planCode}">${obj.planCode}</option>
                   	   		</c:if>
                   	   </c:forEach>
                     </select>
            	</span>
                <span>日期:
                    <input name="beginDate" id="beginDate" value="${form.beginDate }" class="Wdate text-normal" onfocus="WdatePicker({lang:'zh-cn',dateFmt:'yyyy-MM-dd',readOnly:true,maxDate:'#F{$dp.$D(\'endDate\')||\'%y-%M-{%d}\'}'})"/> 
                    	-
                    <input name="endDate" id="endDate" value="${form.endDate }" class="Wdate text-normal" onfocus="WdatePicker({lang:'zh-cn',dateFmt:'yyyy-MM-dd',readOnly:true,minDate:'#F{$dp.$D(\'beginDate\')}',maxDate:'%y-%M-{%d}'})"/>
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
	        		<input type="hidden" id="reportTitle" name="reportTitle" value="游戏销售报表">
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
                            <td style="width:6%">序号</td>
                            <td width="1%" noExp="true">|</td>
                            <td style="width:15%">方案名称</td>
                            <td width="1%" noExp="true">|</td>
                            <td style="width:15%">日期	</td>
                            <td width="1%" noExp="true">|</td>
                            <td style="width:15%">销售金额</td>
                            <td width="1%" noExp="true">|</td>
                            <td style="width:15%">兑奖金额</td>
                            <td width="1%" noExp="true">|</td>
                            <td style="width:*%">退票金额</td>
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
        	<c:if test="${fn:length(pageDataList) > 0}">
        		<tr class="dataRow">
        		<td style="width:10px;" noExp="true">&nbsp;</td>
                <td style="width:6%">总计</td>
                <td width="1%" noExp="true">&nbsp;</td>
                <td style="width:15%">&nbsp;</td>
                <td width="1%" noExp="true">&nbsp;</td>
                <td style="width:15%">&nbsp;</td>
                <td width="1%" noExp="true">&nbsp;</td>
                <td style="width:15%;text-align: right;"><fmt:formatNumber value="${sum.salesAmount }" /></td>
                <td width="1%" noExp="true">&nbsp;</td>
                <td style="width:15%;text-align: right;"><fmt:formatNumber value="${sum.payoutAmount }" /></td>
                <td width="1%" noExp="true">&nbsp;</td>
                <td style="width:*%;text-align: right;"><fmt:formatNumber value="${sum.returnAmount }" /></td>
           		</tr>
        	</c:if>
        <c:forEach var="obj" items="${pageDataList}" varStatus="status" >
            <tr class="dataRow">
            	<td style="width:10px;" noExp="true">&nbsp;</td>
                <td style="width:6%">${status.index+1 }</td>
                <td width="1%" noExp="true">&nbsp;</td>
                <td style="width:15%">${obj.gameName }</td>
                <td width="1%" noExp="true">&nbsp;</td>
                <td style="width:15%">${obj.saleDate }</td>
                <td width="1%" noExp="true">&nbsp;</td>
                <td style="width:15%;text-align: right;"><fmt:formatNumber value="${obj.salesAmount }" /></td>
                <td width="1%" noExp="true">&nbsp;</td>
                <td style="width:15%;text-align: right;"><fmt:formatNumber value="${obj.payoutAmount }" /></td>
                <td width="1%" noExp="true">&nbsp;</td>
                <td style="width:*%;text-align: right;"><fmt:formatNumber value="${obj.returnAmount }" /></td>
            </tr>
          </c:forEach>
        </table>
    </div>
</body>
</html>