<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/views/common/taglibs.jsp"%>
<html>
<head>

<title>Outlet Info Statistics</title>

<%@ include file="/views/common/meta.jsp" %>
<link rel="stylesheet" type="text/css" href="${basePath}/css/style.css" />
<link rel="stylesheet" href="${basePath}/component/messageBox/myJsBox.css" type="text/css"/>

<script type="text/javascript" src="${basePath}/component/messageBox/myJsBox.js"></script>
<script type="text/javascript" src="${basePath}/component/My97DatePicker/WdatePicker.js"></script>
<script type="text/javascript" src="${basePath}/js/jquery/jquery-1.9.1.js"></script>

</head>
<body>
    <!-- 顶部标题块 -->
    <div id="title">No Sale Outlets Statistics</div>
    
    <!-- 查询条件块 -->
    <div class="queryDiv">
        <form action="analysis.do?method=getNoSaleOutlets" id="queryForm" method="post">
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
	        		<input type="hidden" id="reportTitle" name="reportTitle" value="No Sale Outlets Statistics">
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
                            <td style="width:6%">Create Date</td>
                            <td width="1%" noExp="true">|</td>
                            <td style="width:8%">Institution</td>
                            <td width="1%" noExp="true">|</td>
                            <td style="width:8%">Outlet Name</td>
                            <td width="1%" noExp="true">|</td>
                            <td style="width:6%">Outlet Code</td>
                            <td width="1%" noExp="true">|</td>
                            <td style="width:8%">Contact Person</td>
                            <td width="1%" noExp="true">|</td>
                            <td style="width:8%">Phone Number</td>
                            <td width="1%" noExp="true">|</td>
                            <td style="width:8%">Contract No.</td>
                            <td width="1%" noExp="true">|</td>
                            <td style="width:8%">Sale Comm(‰)</td>
                            <td width="1%" noExp="true">|</td>
                            <td style="width:8%">Payout Comm(‰)</td>
                            <td width="1%" noExp="true">|</td>
                            <td style="width:6%">Credit</td>
                            <td width="1%" noExp="true">|</td>
                            <td style="width:6%">Status</td>
                            <td width="1%" noExp="true">|</td>
                            <td style="width:*%">Address</td>
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
                <td style="width:6%">${obj.addTime}</td>
                <td width="1%" noExp="true">&nbsp;</td>
                <td style="width:8%">${obj.orgName }</td>
                <td width="1%" noExp="true">&nbsp;</td>
                <td style="width:8%">${obj.agencyName }</td>
                <td width="1%" noExp="true">&nbsp;</td>
                <td style="width:6%">${obj.agencyCode }</td>
                <td width="1%" noExp="true">&nbsp;</td>
                <td style="width:8%">${obj.contactPerson }</td>
                <td width="1%" noExp="true">&nbsp;</td>
                <td style="width:8%" title="${obj.telephone }">${obj.telephone }</td>
                <td width="1%" noExp="true">&nbsp;</td>
                <td style="width:8%;">${obj.contractNo}</td>
                <td width="1%" noExp="true">&nbsp;</td>
                <td style="width:8%;">${obj.saleComm}</td>
                <td width="1%" noExp="true">&nbsp;</td>
                <td style="width:8%;">${obj.payComm}</td>
                <td width="1%" noExp="true">&nbsp;</td>
                <td style="width:6%;text-align: right"><fmt:formatNumber value="${obj.credit}" /></td>
                <td width="1%" noExp="true">&nbsp;</td>
                <td style="width:6%;">
                	<c:if test="${obj.status == 1}">
                		Enable
                	</c:if>
                	<c:if test="${obj.status == 2}">
                		Disable
                	</c:if>
                	<c:if test="${obj.status == 3}">
                		Deleted
                	</c:if>
                </td>
                <td width="1%" noExp="true">&nbsp;</td>
                <td style="width:*%;" title="${obj.address}">${obj.address}</td>
            </tr>
          </c:forEach>
        </table>
    </div>
</body>
</html>