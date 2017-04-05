<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/views/common/taglibs.jsp"%>
<html>
<head>

<title>Sales Report By Institution</title>

<%@ include file="/views/common/meta.jsp" %>
<link rel="stylesheet" type="text/css" href="${basePath}/css/style.css" />
<link rel="stylesheet" href="${basePath}/component/messageBox/myJsBox.css" type="text/css"/>

<script type="text/javascript" src="${basePath}/component/messageBox/myJsBox.js"></script>
<script type="text/javascript" src="${basePath}/component/My97DatePicker/WdatePicker.js"></script>
<script type="text/javascript" src="${basePath}/js/jquery/jquery-1.9.1.js"></script>

</head>
<body>
    <!-- 顶部标题块 -->
    <div id="title">Sales Report By Institution</div>
    
   
    <!-- 查询条件块 -->
    <div class="queryDiv">
        <form action="saleReport.do?method=getInstitutionSalesReport" id="queryForm" method="post">
            <div class="left">
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
                    <input name="beginDate" value="${form.beginDate }" class="Wdate text-normal" onfocus="WdatePicker({dateFmt:'yyyy-MM-dd',readOnly:true})"/> 
                    	-
                    <input name="endDate" value="${form.endDate }" class="Wdate text-normal" onfocus="WdatePicker({dateFmt:'yyyy-MM-dd',readOnly:true})"/>
                </span>
                <input type="submit" value="Query" class="button-normal"></input>
            </div>
             <div style="overflow: right;">
	        	<span style="position: absolute;right: 80px;">
	        		<input type="hidden" id="reportTitle" name="reportTitle" value="Sales Report By Institution">
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
                            <td style="width:6%">No.</td>
                            <td width="1%" noExp="true">|</td>
                            <td style="width:15%">Insititution Name</td>
                            <td width="1%" noExp="true">|</td>
                            <td style="width:15%">Plan Name</td>
                            <td width="1%" noExp="true">|</td>
                            <td style="width:15%">Sales Amount</td>
                            <!-- <td width="1%" noExp="true">|</td>
                            <td style="width:9%">Sales Commission</td> -->
                            <td width="1%" noExp="true">|</td>
                            <td style="width:15%">Payout Amount</td>
                            <!--<td width="1%" noExp="true">|</td>
                            <td style="width:9%">Payout Commission</td> -->
                            <td width="1%" noExp="true">|</td>
                            <td style="width:*%">Return Amount</td>
                            <!-- <td width="1%" noExp="true">|</td>
                            <td style="width:9%">Return Commission</td>
                            <td width="1%" noExp="true">|</td>
                            <td style="width:*%">Income</td> -->
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
               <td style="width:6%">Total</td>
               <td width="1%" noExp="true">&nbsp;</td>
               <td style="width:15%">&nbsp;</td>
               <td width="1%" noExp="true">&nbsp;</td>
               <td style="width:15%">&nbsp;</td>
               <td width="1%" noExp="true">&nbsp;</td>
               <td style="width:15%;text-align: right;"><fmt:formatNumber value="${sum.salesAmount }" /></td>
               <!--<td width="1%" noExp="true">&nbsp;</td>
               <td style="width:9%;text-align: right;"><fmt:formatNumber value="${sum.salesCommission }" /></td>-->
               <td width="1%" noExp="true">&nbsp;</td>
               <td style="width:15%;text-align: right;"><fmt:formatNumber value="${sum.payoutAmount }" /></td>
               <!-- <td width="1%" noExp="true">&nbsp;</td>
               <td style="width:9%;text-align: right;%"><fmt:formatNumber value="${sum.payoutCommission }" /></td> -->
               <td width="1%" noExp="true">&nbsp;</td>
               <td style="width:*%;text-align: right;"><fmt:formatNumber value="${sum.returnAmount }" /></td>
               <!-- <td width="1%" noExp="true">&nbsp;</td>
               <td style="width:9%;text-align: right;%"><fmt:formatNumber value="${sum.returnCommission }" /></td> 
               <td width="1%" noExp="true">&nbsp;</td>
               <td style="width:*%;text-align: right;"><fmt:formatNumber value="${sum.cashIncome }"/></td>-->
          	</tr>
       	</c:if>
        <c:forEach var="obj" items="${pageDataList}" varStatus="status" >
            <tr class="dataRow">
            	<td style="width:10px;" noExp="true">&nbsp;</td>
                <td style="width:6%">${status.index+1 }</td>
                <td width="1%" noExp="true">&nbsp;</td>
                <td style="width:15%">${obj.orgName }</td>
                <td width="1%" noExp="true">&nbsp;</td>
                <td style="width:15%">${obj.gameName }</td>
                <td width="1%" noExp="true">&nbsp;</td>
                <td style="width:15%;text-align: right;"><fmt:formatNumber value="${obj.salesAmount }" /></td>
                <!-- <td width="1%" noExp="true">&nbsp;</td>
                <td style="width:9%;text-align: right;"><fmt:formatNumber value="${obj.salesCommission }" /></td>-->
                <td width="1%" noExp="true">&nbsp;</td>
                <td style="width:15%;text-align: right;"><fmt:formatNumber value="${obj.payoutAmount }" /></td>
                <!-- <td width="1%" noExp="true">&nbsp;</td>
                <td style="width:9%;text-align: right;"><fmt:formatNumber value="${obj.payoutCommission }" /></td>-->
                <td width="1%" noExp="true">&nbsp;</td>
                <td style="width:*%;text-align: right;"><fmt:formatNumber value="${obj.returnAmount }" /></td>
               <!--  <td width="1%" noExp="true">&nbsp;</td>
                <td style="width:9%;text-align: right;"><fmt:formatNumber value="${obj.returnCommission }" /></td>
                <td width="1%" noExp="true">&nbsp;</td>
                <td style="width:*%;text-align: right;"><fmt:formatNumber value="${obj.cashIncome }"/></td>-->
            </tr>
          </c:forEach>
        </table>
    </div>
</body>
</html>