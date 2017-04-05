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
    <div id="title">Institution Outlets Statistics(USD)</div>
   
    <!-- 查询条件块 -->
    <div class="queryDiv">
        <form action="saleReport.do?method=institutionFundReportUSD" id="queryForm" method="post">
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
                    <input name="beginDate" value="${form.beginDate }" class="Wdate text-normal" onfocus="WdatePicker({lang:'en',dateFmt:'yyyy-MM-dd',readOnly:true})"/> 
                    	-
                    <input name="endDate" value="${form.endDate }" class="Wdate text-normal" onfocus="WdatePicker({lang:'en',dateFmt:'yyyy-MM-dd',readOnly:true})"/>
                </span>
                <input type="submit" value="Query" class="button-normal"></input>
            </div>
             <div style="overflow: right;">
	        	<span style="position: absolute;right: 80px;">
	        		<input type="hidden" id="reportTitle" name="reportTitle" value="Institution Outlets Statistics(USD)">
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
                        	<td style="width:5%">Date</td>
                            <td width="1%" noExp="true">|</td>
                            <td style="width:5%" title="Institution">Institution</td>
                            <td width="1%" noExp="true">|</td>
                            <td style="width:5%" title="Begin Arrears">Begin Arrears</td>
                            <td width="1%" noExp="true">|</td>
                            <td style="width:5%" title="Top Up">Top Up</td>
                            <td width="1%" noExp="true">|</td>
                            <td style="width:5%" title="Withdraw">Withdraw</td>
                            <td width="1%" noExp="true">|</td>
                            <td style="width:5%" title="Sales Amount">Sales Amount</td>
                            <td width="1%" noExp="true">|</td>
                            <td style="width:5%" title="Sales Comm">Sales Comm</td>
                            <td width="1%" noExp="true">|</td>
                            <td style="width:5%" title="Payout Amount">Payout Amount</td>
                            <td width="1%" noExp="true">|</td>
                            <td style="width:5%" title="Payout Comm">Payout Comm</td>
                            <td width="1%" noExp="true">|</td>
                            <td style="width:5%" title="Return Amount">Return Amount</td>
                            <td width="1%" noExp="true">|</td>
                            <td style="width:5%" title="Return Comm">Return Comm</td>
                            <td width="1%" noExp="true">|</td>
                            <td style="width:5%" title="End Arrears">End Arrears</td>
                            <td width="1%" noExp="true">|</td>
                            <td style="width:5%" title="Center Payout">Center Payout</td>
                            <td width="1%" noExp="true">|</td>
                            <td style="width:5%" title="Center Comm">Center Comm</td>
                            <td width="1%" noExp="true">|</td>
                            <td style="width:5%" title="Center Cancel">Center Cancel</td>
                            <td width="1%" noExp="true">|</td>
                            <td style="width:4%" title="CCancel Comm">CCancel Comm</td>
                            <td width="1%" noExp="true">|</td>
                            <td style="width:*%" title="Income">Income</td>
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
                <td style="width:5%">&nbsp;</td>
                <td width="1%" noExp="true">&nbsp;</td>
                <td style="width:5%;text-align: right;">&nbsp;</td>
                <td width="1%" noExp="true">&nbsp;</td>
                <td style="width:5%;text-align: right;"><fmt:formatNumber value="${sum.topUp }" /></td>
                <td width="1%" noExp="true">&nbsp;</td>
                <td style="width:5%;text-align: right;"><fmt:formatNumber value="${sum.withdraw }" /></td>
                <td width="1%" noExp="true">&nbsp;</td>
                <td style="width:5%;text-align: right;"><fmt:formatNumber value="${sum.saleAmount }" /></td>
                <td width="1%" noExp="true">&nbsp;</td>
                <td style="width:5%;text-align: right;"><fmt:formatNumber value="${sum.saleComm }" /></td>
                <td width="1%" noExp="true">&nbsp;</td>
                <td style="width:5%;text-align: right;"><fmt:formatNumber value="${sum.payout }" /></td>
                <td width="1%" noExp="true">&nbsp;</td>
                <td style="width:5%;text-align: right;"><fmt:formatNumber value="${sum.payoutComm }" /></td>
                <td width="1%" noExp="true">&nbsp;</td>
                <td style="width:5%;text-align: right;"><fmt:formatNumber value="${sum.returnAmount }" /></td>
                <td width="1%" noExp="true">&nbsp;</td>
                <td style="width:5%;text-align: right;"><fmt:formatNumber value="${sum.returnComm }" /></td>
                <td width="1%" noExp="true">&nbsp;</td>
                <td style="width:5%;text-align: right;">&nbsp;</td>
                <td width="1%" noExp="true">&nbsp;</td>
                <td style="width:5%;text-align: right;"><fmt:formatNumber value="${sum.centerPayAmount }" /></td>
                <td width="1%" noExp="true">&nbsp;</td>
                <td style="width:5%;text-align: right;"><fmt:formatNumber value="${sum.centerPayComm }" /></td> 
                <td width="1%" noExp="true">&nbsp;</td>
                <td style="width:5%;text-align: right;"><fmt:formatNumber value="${sum.cancelAmount }" /></td> 
                <td width="1%" noExp="true">&nbsp;</td>
                <td style="width:4%;text-align: right;"><fmt:formatNumber value="${sum.centerCancelComm }" /></td> 
                <td width="1%" noExp="true">&nbsp;</td>
                <td style="width:*%;text-align: right;"><fmt:formatNumber value="${sum.income }" /></td>
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
                <td style="width:5%;text-align: right;"><fmt:formatNumber value="${obj.payout }" /></td>
                <td width="1%" noExp="true">&nbsp;</td>
                <td style="width:5%;text-align: right;"><fmt:formatNumber value="${obj.payoutComm }" /></td>
                <td width="1%" noExp="true">&nbsp;</td>
                <td style="width:5%;text-align: right;"><fmt:formatNumber value="${obj.returnAmount }" /></td>
                <td width="1%" noExp="true">&nbsp;</td>
                <td style="width:5%;text-align: right;"><fmt:formatNumber value="${obj.returnComm }" /></td>
                <td width="1%" noExp="true">&nbsp;</td>
                <td style="width:5%;text-align: right;"><fmt:formatNumber value="${obj.finalBalance }" /></td>
                <td width="1%" noExp="true">&nbsp;</td>
                <td style="width:5%;text-align: right;"><fmt:formatNumber value="${obj.centerPayAmount }" /></td>
                <td width="1%" noExp="true">&nbsp;</td>
                <td style="width:5%;text-align: right;"><fmt:formatNumber value="${obj.centerPayComm }" /></td> 
                <td width="1%" noExp="true">&nbsp;</td>
                <td style="width:5%;text-align: right;"><fmt:formatNumber value="${obj.cancelAmount }" /></td> 
                <td width="1%" noExp="true">&nbsp;</td>
                <td style="width:4%;text-align: right;"><fmt:formatNumber value="${obj.centerCancelComm }" /></td> 
                <td width="1%" noExp="true">&nbsp;</td>
                <td style="width:*%;text-align: right;"><fmt:formatNumber value="${obj.income }" /></td>
            </tr>
          </c:forEach>
        </table>
    </div>
</body>
</html>