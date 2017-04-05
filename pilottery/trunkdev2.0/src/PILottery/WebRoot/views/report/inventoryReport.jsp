<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/views/common/taglibs.jsp"%>
<html>
<head>

<title>Inventory Report</title>

<%@ include file="/views/common/meta.jsp" %>
<link rel="stylesheet" type="text/css" href="${basePath}/css/style.css" />
<link rel="stylesheet" href="${basePath}/component/messageBox/myJsBox.css" type="text/css"/>

<script type="text/javascript" src="${basePath}/component/messageBox/myJsBox.js"></script>
<script type="text/javascript" src="${basePath}/component/My97DatePicker/WdatePicker.js"></script>
<script type="text/javascript" src="${basePath}/js/jquery/jquery-1.9.1.js"></script>
<script type="text/javascript" src="${basePath}/js/mydate.js"></script>
<script type="text/javascript">
	$(document).ready(function(){
		$('#warehouseCode').val('${form.warehouseCode}');
		
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

	function getWhByInst(){
		var orgCode = $('#institutionCode').val();
		$('#warehouseCode').empty();
		if(orgCode == ''){
			$('#warehouseCode').append("<option value=''>--All--</option>"); 
			return false;
		}
		
		$.ajax({
			url : "saleReport.do?method=getWarehouseByInst&orgCode=" + orgCode,
			dataType : "json",
			async : false,
			success : function(result){
	            if(result != '' && result !=null){
		            for(var i=0;i<result.length;i++){
		            	 $('#warehouseCode').append("<option value='"+result[i].warehouseCode+"'>"+result[i].warehouseName+"</option>"); 
		            }
		        }
			}
		});	
	}
</script>
</head>
<body>
    <!-- 顶部标题块 -->
    <div id="title">Inventory Report</div>
    
    <!-- 查询条件块 -->
    <div class="queryDiv">
        <form action="saleReport.do?method=getInventoryReport" id="queryForm" method="post">
            <div class="left">
            	<span>Plan:
            		<select name="planCode" class="select-normal">
            			<option value="">--All--</option>
                   	   <c:forEach var="obj" items="${planList}" varStatus="plan">
                   	   		<c:if test="${obj.planCode == form.planCode}">
                   	   			<option value="${obj.planCode}" selected="selected">${obj.planName}</option>
                   	   		</c:if>
                   	   		<c:if test="${obj.planCode != form.planCode}">
                   	   			<option value="${obj.planCode}">${obj.planName}</option>
                   	   		</c:if>
                   	   </c:forEach>
                     </select>
            	</span>
            	<span>Institution:
            		<select class="select-normal" name="institutionCode" id="institutionCode"  onchange="getWhByInst();">
            			<option value="">--All--</option>
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
            	<span>Warehouses:
            		<select name="warehouseCode" id="warehouseCode" class="select-normal">
            			<option value="">--All--</option>
            			<c:forEach var="obj" items="${warehouseList}" varStatus="plan">
                   	   		<c:if test="${obj.warehouseCode == form.warehouseCode}">
                   	   			<option value="${obj.warehouseCode}" selected="selected">${obj.warehouseName}</option>
                   	   		</c:if>
                   	   		<c:if test="${obj.warehouseCode != form.warehouseCode}">
                   	   			<option value="${obj.warehouseCode}">${obj.warehouseName}</option>
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
	        		<input type="hidden" id="reportTitle" name="reportTitle" value="Inventory Report">
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
                            <td style="width:10%">No.</td>
                            <td width="1%" noExp="true">|</td>
                            <td style="width:20%">Date</td>
                            <td width="1%" noExp="true">|</td>
                            <td style="width:20%">Plan Name</td>
                            <td width="1%" noExp="true">|</td>
                            <td style="width:20%">Tickets</td>
                            <td width="1%" noExp="true">|</td>
                            <td style="width:20%">Amount</td>
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
        <c:forEach var="obj" items="${pageDataList}" varStatus="status" >
            <tr class="dataRow">
           	 	<td style="width:10px;" noExp="true">&nbsp;</td>
                <td style="width:10%">${status.index+1 }</td>
                <td width="1%" noExp="true">&nbsp;</td>
                <td style="width:20%">${obj.calcDate }</td>
                <td width="1%" noExp="true">&nbsp;</td>
                <td style="width:20%">${obj.gameName }</td>
                <td width="1%" noExp="true">&nbsp;</td>
                <td style="width:20%;"><fmt:formatNumber value="${obj.tickets }" /></td>
                <td width="1%" noExp="true">&nbsp;</td>
                <td style="width:20%;text-align: right;"><fmt:formatNumber value="${obj.amount }" /></td>
            </tr>
          </c:forEach>
        </table>
    </div>
</body>
</html>