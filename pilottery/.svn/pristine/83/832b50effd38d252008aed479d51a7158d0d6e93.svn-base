<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/views/common/taglibs.jsp"%>
<html>
<head>

<title>站点资金报表</title>

<%@ include file="/views/common/meta.jsp" %>
<link rel="stylesheet" type="text/css" href="${basePath}/css/style.css" />
<link rel="stylesheet" href="${basePath}/component/messageBox/myJsBox.css" type="text/css"/>

<script type="text/javascript" src="${basePath}/component/messageBox/myJsBox_zh.js"></script>
<script type="text/javascript" src="${basePath}/component/My97DatePicker/WdatePicker.js"></script>
<script type="text/javascript" src="${basePath}/js/jquery/jquery-1.9.1.js"></script>

</head>
<body>
    <!-- 顶部标题块 -->
    <div id="title">Outlet Integrated Report</div>
    
    <!-- 查询条件块 -->
    <div class="queryDiv">
        <form action="saleReport.do?method=listOutletIntegrated" id="queryForm" method="post">
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
            	<span>Market Manager:
            		<input type="text" name="marketAdmin" value="${form.marketAdmin }" class="text-normal" ></input>
            	</span>
                <span>Date:
                    <input name="beginDate" value="${form.beginDate }" class="Wdate text-normal" style="width:130px;height:24px;" onfocus="WdatePicker({lang:'en',dateFmt:'yyyy-MM-dd',readOnly:true})"/> 
                </span>
                <span>Type:
            		<select class="select-normal" name="tjType">
            			<option value="0" <c:if test="${form.tjType==0}">selected="selected"</c:if> >--All--</option>
            			<option value="1" <c:if test="${form.tjType==1}">selected="selected"</c:if> >PIL</option>
            			<option value="2" <c:if test="${form.tjType==2}">selected="selected"</c:if> >CTG</option>
            		</select>
            	</span>
                <input type="submit" value="Query" class="button-normal"></input>
            </div>
             <div style="overflow: right;">
	        	<span style="position: absolute;right: 80px;">
	        		<input type="hidden" id="reportTitle" name="reportTitle" value="Outlet Integrated Report">
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
                        	<td style="width:9%">Date</td>
                            <td width="1%" noExp="true">|</td>
                            <td style="width:9%">Outlet Code</td>
                            <td width="1%" noExp="true">|</td>
                            <td style="width:9%">Institution</td>
                            <td width="1%" noExp="true">|</td>
                            <td style="width:9%">Market Manager</td>
                            <td width="1%" noExp="true">|</td>
                            <td style="width:9%">Top Up</td>
                            <td width="1%" noExp="true">|</td>
                            <td style="width:9%">Withdraw</td>
                            <td width="1%" noExp="true">|</td>
                            <td style="width:9%">Sales Amount</td>
                            <td width="1%" noExp="true">|</td>
                            <td style="width:9%">Payout Amount</td>
                            <td width="1%" noExp="true">|</td>
                            <td style="width:9%">Cancel Amount</td>
                            <td width="1%" noExp="true">|</td>
                            <td style="width:*%">Net Sales Amount</td>
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
            	<td style="width:9%">Total</td>
                <td width="1%" noExp="true">&nbsp;</td>
                <td style="width:9%">&nbsp;</td>
                <td width="1%" noExp="true">&nbsp;</td>
                <td style="width:9%;">&nbsp;</td>
                <td width="1%" noExp="true">&nbsp;</td>
                <td style="width:9%">&nbsp;</td>
                <td width="1%" noExp="true">&nbsp;</td>
                <td style="width:9%;text-align: right;"><fmt:formatNumber value="${sum.topUp }" /></td>
                <td width="1%" noExp="true">&nbsp;</td>
                <td style="width:9%;text-align: right;"><fmt:formatNumber value="${sum.withdraw }" /></td>
                <td width="1%" noExp="true">&nbsp;</td>
                <td style="width:9%;text-align: right;"><fmt:formatNumber value="${sum.saleAmount }" /></td>
                <td width="1%" noExp="true">&nbsp;</td>
                <td style="width:9%;text-align: right;"><fmt:formatNumber value="${sum.payout }" /></td>
                <td width="1%" noExp="true">&nbsp;</td>
                <td style="width:9%;text-align: right;"><fmt:formatNumber value="${sum.returnAmount }" /></td>
                <td width="1%" noExp="true">&nbsp;</td>
                <td style="width:*%;text-align: right;"><fmt:formatNumber value="${sum.saleAmount - sum.returnAmount}" /></td>
            </tr>
         </c:if>
        
        <c:forEach var="obj" items="${list}" varStatus="status" >
            <tr class="dataRow">
            	<td style="width:10px;" noExp="true">&nbsp;</td>
            	<td style="width:9%">${obj.balanceDate }</td>
                <td width="1%" noExp="true">&nbsp;</td>
                <td style="width:9%">${obj.agencyCode }</td>
                <td width="1%" noExp="true">&nbsp;</td>
                <td style="width:9%">${obj.orgName }</td>
                <td width="1%" noExp="true">&nbsp;</td>
                <td style="width:9%">${obj.marketManager }</td>
                <td width="1%" noExp="true">&nbsp;</td>
                <td style="width:9%;text-align: right;"><fmt:formatNumber value="${obj.topUp }" /></td>
                <td width="1%" noExp="true">&nbsp;</td>
                <td style="width:9%;text-align: right;"><fmt:formatNumber value="${obj.withdraw }" /></td>
                <td width="1%" noExp="true">&nbsp;</td>
                <td style="width:9%;text-align: right;"><fmt:formatNumber value="${obj.saleAmount }" /></td>
                <td width="1%" noExp="true">&nbsp;</td>
                <td style="width:9%;text-align: right;"><fmt:formatNumber value="${obj.payout }" /></td>
                <td width="1%" noExp="true">&nbsp;</td>
                <td style="width:9%;text-align: right;"><fmt:formatNumber value="${obj.returnAmount }" /></td>
                <td width="1%" noExp="true">&nbsp;</td>
                <td style="width:*%;text-align: right;"><fmt:formatNumber value="${obj.saleAmount - obj.returnAmount}" /></td>
            </tr>
          </c:forEach>
        </table>
    </div>
</body>
</html>