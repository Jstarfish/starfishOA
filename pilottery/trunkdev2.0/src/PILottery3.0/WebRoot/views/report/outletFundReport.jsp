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
    <div id="title">Outlet Fund Report</div>
    
    <!-- 查询条件块 -->
    <div class="queryDiv">
        <form action="saleReport.do?method=outletFundReport" id="queryForm" method="post">
            <div class="left">
            	<span>Outlet Code:
            		<input type="text" name="outletCode" value="${form.outletCode }" class="text-normal" ></input>
            	</span>
            	<span>Institution:
            		<select class="select-normal" name="institutionCode" >
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
                <span>Date:
                    <input name="beginDate" value="${form.beginDate }" class="Wdate text-normal" onfocus="WdatePicker({lang:'en',dateFmt:'yyyy-MM-dd',readOnly:true})"/> 
                    	-
                    <input name="endDate" value="${form.endDate }" class="Wdate text-normal" onfocus="WdatePicker({lang:'en',dateFmt:'yyyy-MM-dd',readOnly:true})"/>
                </span>
                <input type="submit" value="Query" class="button-normal"></input>
            </div>
             <div style="overflow: right;">
	        	<span style="position: absolute;right: 80px;">
	        		<input type="hidden" id="reportTitle" name="reportTitle" value="Outlet Fund Report">
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
                        	<td style="width:6%">Date</td>
                            <td width="1%" noExp="true">|</td>
                            <td style="width:7%">Outlet Code</td>
                            <td width="1%" noExp="true">|</td>
                            <td style="width:7%">Begin Balance</td>
                            <td width="1%" noExp="true">|</td>
                            <td style="width:7%">Top Up</td>
                            <td width="1%" noExp="true">|</td>
                            <td style="width:7%">Withdraw</td>
                            <td width="1%" noExp="true">|</td>
                            <td style="width:7%">Sales Amount</td>
                            <td width="1%" noExp="true">|</td>
                            <td style="width:7%">Sales Comm</td>
                            <td width="1%" noExp="true">|</td>
                            <td style="width:7%">Payout Amount</td>
                            <td width="1%" noExp="true">|</td>
                            <td style="width:7%">Payout Comm</td>
                            <td width="1%" noExp="true">|</td>
                            <td style="width:7%">Return Amount</td>
                            <td width="1%" noExp="true">|</td>
                            <td style="width:7%">Return Comm</td>
                            <td width="1%" noExp="true">|</td>
                            <td style="width:7%">Income</td>
                            <td width="1%" noExp="true">|</td>
                            <td style="width:7%">End Balance</td>
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
            	<td style="width:6%">Total</td>
                <td width="1%" noExp="true">&nbsp;</td>
                <td style="width:7%">&nbsp;</td>
                <td width="1%" noExp="true">&nbsp;</td>
                <td style="width:7%;text-align: right;">&nbsp;</td>
                <td width="1%" noExp="true">&nbsp;</td>
                <td style="width:7%;text-align: right;"><fmt:formatNumber value="${sum.topUp }" /></td>
                <td width="1%" noExp="true">&nbsp;</td>
                <td style="width:7%;text-align: right;"><fmt:formatNumber value="${sum.withdraw }" /></td>
                <td width="1%" noExp="true">&nbsp;</td>
                <td style="width:7%;text-align: right;"><fmt:formatNumber value="${sum.saleAmount }" /></td>
                <td width="1%" noExp="true">&nbsp;</td>
                <td style="width:7%;text-align: right;"><fmt:formatNumber value="${sum.saleComm }" /></td>
                <td width="1%" noExp="true">&nbsp;</td>
                <td style="width:7%;text-align: right;"><fmt:formatNumber value="${sum.payout }" /></td>
                <td width="1%" noExp="true">&nbsp;</td>
                <td style="width:7%;text-align: right;"><fmt:formatNumber value="${sum.payoutComm }" /></td>
                <td width="1%" noExp="true">&nbsp;</td>
                <td style="width:7%;text-align: right;"><fmt:formatNumber value="${sum.returnAmount }" /></td>
                <td width="1%" noExp="true">&nbsp;</td>
                <td style="width:7%;text-align: right;"><fmt:formatNumber value="${sum.returnComm }" /></td>
                <td width="1%" noExp="true">&nbsp;</td>
                <td style="width:7%;text-align: right;"><fmt:formatNumber value="${sum.income }" /></td>
                <td width="1%" noExp="true">&nbsp;</td>
                <td style="width:7%;text-align: right;">&nbsp;</td>
            </tr>
         </c:if>
        
        <c:forEach var="obj" items="${list}" varStatus="status" >
            <tr class="dataRow">
            	<td style="width:10px;" noExp="true">&nbsp;</td>
            	<td style="width:6%">${obj.balanceDate }</td>
                <td width="1%" noExp="true">&nbsp;</td>
                <td style="width:7%">${obj.agencyCode }</td>
                <td width="1%" noExp="true">&nbsp;</td>
                <td style="width:7%;text-align: right;"><fmt:formatNumber value="${obj.initialBalance }" /></td>
                <td width="1%" noExp="true">&nbsp;</td>
                <td style="width:7%;text-align: right;"><fmt:formatNumber value="${obj.topUp }" /></td>
                <td width="1%" noExp="true">&nbsp;</td>
                <td style="width:7%;text-align: right;"><fmt:formatNumber value="${obj.withdraw }" /></td>
                <td width="1%" noExp="true">&nbsp;</td>
                <td style="width:7%;text-align: right;"><fmt:formatNumber value="${obj.saleAmount }" /></td>
                <td width="1%" noExp="true">&nbsp;</td>
                <td style="width:7%;text-align: right;"><fmt:formatNumber value="${obj.saleComm }" /></td>
                <td width="1%" noExp="true">&nbsp;</td>
                <td style="width:7%;text-align: right;"><fmt:formatNumber value="${obj.payout }" /></td>
                <td width="1%" noExp="true">&nbsp;</td>
                <td style="width:7%;text-align: right;"><fmt:formatNumber value="${obj.payoutComm }" /></td>
                <td width="1%" noExp="true">&nbsp;</td>
                <td style="width:7%;text-align: right;"><fmt:formatNumber value="${obj.returnAmount }" /></td>
                <td width="1%" noExp="true">&nbsp;</td>
                <td style="width:7%;text-align: right;"><fmt:formatNumber value="${obj.returnComm }" /></td>
                <td width="1%" noExp="true">&nbsp;</td>
                <td style="width:7%;text-align: right;"><fmt:formatNumber value="${obj.income }" /></td>
                <td width="1%" noExp="true">&nbsp;</td>
                <td style="width:7%;text-align: right;"><fmt:formatNumber value="${obj.finalBalance }" /></td>
            </tr>
          </c:forEach>
        </table>
    </div>
</body>
</html>