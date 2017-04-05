<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/views/common/taglibs.jsp"%>
<html>
<head>

<title></title>

<%@ include file="/views/common/meta.jsp" %>
<link rel="stylesheet" type="text/css" href="${basePath}/css/style.css" />
<link rel="stylesheet" href="${basePath}/component/messageBox/myJsBox.css" type="text/css"/>

<script type="text/javascript" src="${basePath}/component/messageBox/myJsBox_zh.js"></script>
<script type="text/javascript" src="${basePath}/component/My97DatePicker/WdatePicker.js"></script>
<script type="text/javascript" src="${basePath}/js/jquery/jquery-1.9.1.js"></script>

</head>
<body>
    <!-- 顶部标题块 -->
    <div id="title">总部方案出库报表</div>
    
   
    <!-- 查询条件块 -->
    <div class="queryDiv">
        <form action="goodsReceiptsReport.do?method=initGoodsOutReport" id="form" method="post">
            <div class="left">
            	<span>仓库:
            		<select class="select-normal" name="whouseCode" >
            			<option value="">--全部--</option>
                   	   <c:forEach var="obj" items="${listhouse}">
                   	   		<c:if test="${obj.warehouseCode == form.whouseCode}">
                   	   			<option value="${obj.warehouseCode}" selected="selected">${obj.warehouseName}</option>
                   	   		</c:if>
                   	   		<c:if test="${obj.warehouseCode != form.whouseCode}">
                   	   			<option value="${obj.warehouseCode}">${obj.warehouseName}</option>
                   	   		</c:if>
                   	   </c:forEach>
                    </select>
            	</span>
                <span>日期:
                    <input name="begDate" value="${form.begDate }" class="Wdate text-normal" onfocus="WdatePicker({lang:'zh-cn',dateFmt:'yyyy-MM-dd',readOnly:true})"/> 
                    	-
                    <input name="endDate" value="${form.endDate}" class="Wdate text-normal" onfocus="WdatePicker({lang:'zh-cn',dateFmt:'yyyy-MM-dd',readOnly:true})"/>
                </span>
                <input type="submit" value="查询" class="button-normal"></input>
            </div>
             <div style="overflow: right;">
	        	<span style="position: absolute;right: 80px;">
	        		<input type="hidden" id="reportTitle" name="reportTitle" value="总部方案出库报表">
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
                            <td style="width:10%">出库时间</td>
                            <td width="1%" noExp="true">|</td>
                            <td style="width:10%">出库人</td>
                            <td width="1%" noExp="true">|</td>
                            <td style="width:13%">出库仓库</td>
                            <td width="1%" noExp="true">|</td>
                            <td style="width:13%">收货机构</td>
                            <td width="1%" noExp="true">|</td>
                            <td style="width:10%">方案名称</td>
                            <td width="1%" noExp="true">|</td>
                            <td style="width:10%">数量(张)</td>
                            <td width="1%" noExp="true">|</td>
                            <td style="width:10%">金额(瑞尔)</td>
                            <td width="1%" noExp="true">|</td>
                            <td style="width:*%">金额(美金)</td>
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

        <c:forEach var="obj" items="${receiptsList}" varStatus="status" >
            <tr class="dataRow">
            	<td style="width:10px;" noExp="true">&nbsp;</td>
            	<td style="width:10%;"><fmt:formatDate value="${obj.rereceiptTime }" pattern="yyyy-MM-dd HH:mm:ss"/></td>
                <td width="1%" noExp="true">&nbsp;</td>
                <td style="width:10%">${obj.deliverName }</td>
                <td width="1%" noExp="true">&nbsp;</td>
                <td style="width:13%;">${obj.whouseName }</td>
                <td width="1%" noExp="true">&nbsp;</td>
                <td style="width:13%;">${obj.insName }</td>
                <td width="1%" noExp="true">&nbsp;</td>
                <td style="width:10%;">${obj.planName }</td>
                <td width="1%" noExp="true">&nbsp;</td>
                <td style="width:10%;">${obj.tickets }</td>
                <td width="1%" noExp="true">&nbsp;</td>
                <td style="width:10%;text-align: right;"><fmt:formatNumber value="${obj.amount }" /></td>
                <td width="1%" noExp="true">&nbsp;</td>
                <td style="width:*%;text-align: right;"><fmt:formatNumber value="${obj.amountDollar }" /></td>
               
            </tr>
          </c:forEach>
           <tr class="dataRow">
            	<td style="width:10px;" noExp="true">&nbsp;</td>
            	<td style="width:10%">总计</td>
                <td width="1%" noExp="true"></td>
            	<td style="width:10	%"></td>
                <td width="1%" noExp="true">&nbsp;</td>
            	<td style="width:13	%"></td>
                <td width="1%" noExp="true">&nbsp;</td>
            	<td style="width:13	%"></td>
                <td width="1%" noExp="true">&nbsp;</td>
                <td style="width:10%;text-align: center;">&nbsp;</td>
                <td width="1%" noExp="true">&nbsp;</td>
                <td style="width:10%;">${goodsReceiptsReportSum.tickets }</td>
                <td width="1%" noExp="true">&nbsp;</td>
                <td style="width:10%;text-align: right;"><fmt:formatNumber value="${goodsReceiptsReportSum.amount }" /></td>
                <td width="1%" noExp="true">&nbsp;</td>
                <td style="width:*%;text-align: right;"><fmt:formatNumber value="${goodsReceiptsReportSum.amountDollar }" /></td>
               
            </tr>
        </table>
    </div>
</body>
</html>