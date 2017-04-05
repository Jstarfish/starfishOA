<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/views/common/taglibs.jsp"%>
<html>
<head>

<title>Sales Report By Plan</title>

<%@ include file="/views/common/meta.jsp" %>
<link rel="stylesheet" type="text/css" href="${basePath}/css/style.css" />
<link rel="stylesheet" href="${basePath}/component/messageBox/myJsBox.css" type="text/css"/>

<script type="text/javascript" src="${basePath}/component/messageBox/myJsBox.js"></script>
<script type="text/javascript" src="${basePath}/component/My97DatePicker/WdatePicker.js"></script>
<script type="text/javascript" src="${basePath}/js/jquery/jquery-1.9.1.js"></script>

</head>
<body>
    <!-- 顶部标题块 -->
    <div id="title">
    	验证中奖报表
    </div>
    
    <!-- 查询条件块 -->
    <div class="queryDiv">
        <form action="checktickets.do?method=querystatisticalReports" id="queryForm" method="post">
            <div class="left">
                <span>日期:
                    <input name="beginDate" value="${form.beginDate }" class="Wdate text-normal" onfocus="WdatePicker({lang:'zh-cn',dateFmt:'yyyy-MM-dd',readOnly:true})"/> 
                    	-
                    <input name="endDate" value="${form.endDate }" class="Wdate text-normal" onfocus="WdatePicker({lang:'zh-cn',dateFmt:'yyyy-MM-dd',readOnly:true})"/>
                </span>
                <input type="submit" value="查询" class="button-normal"></input>
            </div>
             <div style="overflow: right;">
	        	<span style="position: absolute;right: 80px;">
					<input type="hidden" id="reportTitle" name="reportTitle" value="验证中奖报表">
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
                         
           
                            <td style="width:9%">日期</td>
                            <td width="1%" noExp="true">|</td>
	                        <td style="width:12%">部门</td>
	                        <td width="1%" noExp="true">|</td>
                            <td style="width:9%">兑奖数量</td>
                            <td width="1%" noExp="true">|</td>
                            <td style="width:9%">兑奖金额</td>
                            <td width="1%" noExp="true">|</td>
                            <td style="width:9%">爱心</td>
                            <td width="1%" noExp="true">|</td>
                            <td style="width:9%">恭喜发财</td>
                            <td width="1%" noExp="true">|</td>
                            <td style="width:9%">天下足球</td>
                            <td width="1%" noExp="true">|</td>
                            <td style="width:9%">寻宝Iphone6</td>
                            <td width="1%" noExp="true">|</td>
                            <td style="width:*%">幸运大灌篮</td>
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
        
        <c:forEach var="obj" items="${listchek}">
            <tr class="dataRow">
            	<td style="width:10px;" noExp="true">&nbsp;</td>
              
                <td style="width:9%"><fmt:formatDate  value="${obj.paidDay}"  pattern="yyyy-MM-dd" /></td>
                <td width="1%" noExp="true">&nbsp;</td>
                <td style="width:12%">${obj.orgName }</td>
                <td width="1%" noExp="true">&nbsp;</td>
                <td style="width:9%;"><fmt:formatNumber value="${obj.totalTickets }" /></td>
                <td width="1%" noExp="true">&nbsp;</td>
                <td style="width:9%;text-align: right;"><fmt:formatNumber value="${obj.totalAmount }" /></td>
                <td width="1%" noExp="true">&nbsp;</td>
                <td style="width:9%;text-align: right;">[<fmt:formatNumber value="${obj.loveTickets }" />] &nbsp;&nbsp;<fmt:formatNumber value="${obj.loveAmount}" /></td>
                <td width="1%" noExp="true">&nbsp;</td>
                <td style="width:9%;text-align: right;">[<fmt:formatNumber value="${obj.gongxiTickets }" />] &nbsp;&nbsp;<fmt:formatNumber value="${obj.gongxiAmount}" /></td>
                <td width="1%" noExp="true">&nbsp;</td>
                <td style="width:9%;text-align: right;">[<fmt:formatNumber value="${obj.ballTickets }" />] &nbsp;&nbsp;<fmt:formatNumber value="${obj.ballAmount}" /></td>
                <td width="1%" noExp="true">&nbsp;</td>
                 <td style="width:9%;text-align: right;">[<fmt:formatNumber value="${obj.iphoneTickets }" />] &nbsp;&nbsp;<fmt:formatNumber value="${obj.iphoneAmount}" /></td>
                <td width="1%" noExp="true">&nbsp;</td>
                <td style="width:*%;text-align: right;">[<fmt:formatNumber value="${obj.dglTickets}" />] &nbsp;&nbsp;<fmt:formatNumber value="${obj.dglAmount}" /></td>
            </tr>
          </c:forEach>
        </table>
    </div>
</body>
</html>