<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/views/common/taglibs.jsp"%>
<html>
<head>

<title>Inventory Report</title>

<%@ include file="/views/common/meta.jsp" %>
<link rel="stylesheet" type="text/css" href="${basePath}/css/style.css" />
<link rel="stylesheet" href="${basePath}/component/messageBox/myJsBox.css" type="text/css"/>

<script type="text/javascript" src="${basePath}/component/messageBox/myJsBox_zh.js"></script>
<script type="text/javascript" src="${basePath}/component/My97DatePicker/WdatePicker.js"></script>
<script type="text/javascript" src="${basePath}/js/jquery/jquery-1.9.1.js"></script>
<script type="text/javascript">
	$(document).ready(function(){
		$('#warehouseCode').val('${form.warehouseCode}');
	});

	function getWhByInst(){
		var orgCode = $('#institutionCode').val();
		$('#warehouseCode').empty();
		if(orgCode == ''){
			$('#warehouseCode').append("<option value=''>--全部--</option>"); 
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
    <div id="title">库存报表</div>
    
    <!-- 查询条件块 -->
    <div class="queryDiv">
        <form action="saleReport.do?method=getInventoryReport" id="queryForm" method="post">
            <div class="left">
            	<span>方案:
            		<select name="planCode" class="select-normal">
            			<option value="">--全部--</option>
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
            	<span>仓库:
            		<select name="warehouseCode" id="warehouseCode" class="select-normal">
            			<option value="">--全部--</option>
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
                <span>日期:
                    <input name="beginDate" value="${form.beginDate }" class="Wdate text-normal" onfocus="WdatePicker({lang:'zh-cn',dateFmt:'yyyy-MM-dd',readOnly:true})"/> 
                    	-
                    <input name="endDate" value="${form.endDate }" class="Wdate text-normal" onfocus="WdatePicker({lang:'zh-cn',dateFmt:'yyyy-MM-dd',readOnly:true})"/>
                </span>
                <input type="submit" value="查询" class="button-normal"></input>
            </div>
            <div style="overflow: right;">
	        	<span style="position: absolute;right: 80px;">
	        		<input type="hidden" id="reportTitle" name="reportTitle" value="库存报表">
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
                            <td style="width:10%">编号.</td>
                            <td width="1%" noExp="true">|</td>
                            <td style="width:20%">日期</td>
                            <td width="1%" noExp="true">|</td>
                            <td style="width:20%">方案名称</td>
                            <td width="1%" noExp="true">|</td>
                            <td style="width:20%">票数</td>
                            <td width="1%" noExp="true">|</td>
                            <td style="width:20%">金额</td>
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
                <td style="width:20%"><fmt:formatNumber value="${obj.tickets }" /></td>
                <td width="1%" noExp="true">&nbsp;</td>
                <td style="width:20%;text-align: right;"><fmt:formatNumber value="${obj.amount }" /></td>
            </tr>
          </c:forEach>
        </table>
    </div>
</body>
</html>