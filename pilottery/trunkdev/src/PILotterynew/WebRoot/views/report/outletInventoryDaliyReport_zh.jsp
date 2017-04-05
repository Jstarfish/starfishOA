<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/views/common/taglibs.jsp"%>
<html>
<head>

<title></title>

<%@ include file="/views/common/meta.jsp" %>
<link rel="stylesheet" type="text/css" href="${basePath}/css/style.css" />
<link rel="stylesheet" href="${basePath}/component/messageBox/myJsBox.css" type="text/css"/>

<script type="text/javascript" src="${basePath}/component/messageBox/myJsBox.js"></script>
<script type="text/javascript" src="${basePath}/component/My97DatePicker/WdatePicker.js"></script>
<script type="text/javascript" src="${basePath}/js/jquery/jquery-1.9.1.js"></script>

</head>
<body>
    <!-- 顶部标题块 -->
    <div id="title">站点库存日结报表</div>
    
    <!-- 查询条件块 -->
    <div class="queryDiv">
        <form action="saleReport.do?method=outletInventoryDaliyReport" id="queryForm" method="post">
            <div class="left">
            	<span>站点编号:
            	 <input name="outletCode" value="${form.outletCode }" class="text-normal"/> 
            	</span>
                <span>日期:
                    <input name="beginDate" value="${form.beginDate }" class="Wdate text-normal" onfocus="WdatePicker({lang:'en',dateFmt:'yyyy-MM-dd',readOnly:true})"/> 
                    	-
                    <input name="endDate" value="${form.endDate }" class="Wdate text-normal" onfocus="WdatePicker({lang:'en',dateFmt:'yyyy-MM-dd',readOnly:true})"/>
                </span>
                <input type="submit" value="Query" class="button-normal"></input>
            </div>
             <div style="overflow: right;">
	        	<span style="position: absolute;right: 80px;">
	        		<input type="hidden" id="reportTitle" name="reportTitle" value="站点库存日结报表">
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
                            <td style="width:13%">日期</td>
                            <td width="1%" noExp="true">|</td>
                            <td style="width:13%">站点名称</td>
                            <td width="1%" noExp="true">|</td>
                            <td style="width:13%">站点编码</td>
                            <td width="1%" noExp="true">|</td>
                            <td style="width:13%">方案名称</td>
                            <td width="1%" noExp="true">|</td>
                            <td style="width:13%">收货数量(张)</td>
                            <td width="1%" noExp="true">|</td>
                            <td style="width:13%">退货数量(张)</td>
                            <td width="1%" noExp="true">|</td>
                            <td style="width:*%">库存数量(张)</td>
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
        
        <c:forEach var="obj" items="${list}">
            <tr class="dataRow">
            	<td style="width:10px;" noExp="true">&nbsp;</td>
                <td style="width:13%">${obj.calcDate}</td>
                <td width="1%" noExp="true">&nbsp;</td>
                <td style="width:13%">${obj.outletName }</td>
                <td width="1%" noExp="true">&nbsp;</td>
                <td style="width:13%">${obj.outletCode }</td>
                <td width="1%" noExp="true">&nbsp;</td>
                <td style="width:13%;">${obj.planName}</td>
                <td width="1%" noExp="true">&nbsp;</td>
                <td style="width:13%;text-align: right;"><fmt:formatNumber value="${obj.receiptTickets }" /></td>
                <td width="1%" noExp="true">&nbsp;</td>
                <td style="width:13%;text-align: right;"><fmt:formatNumber value="${obj.returnTickets }" /></td>
                <td width="1%" noExp="true">&nbsp;</td>
                <td style="width:*%;text-align: right;"><fmt:formatNumber value="${obj.inventoryTickets }"/></td>
            </tr>
          </c:forEach>
        </table>
    </div>
</body>
</html>