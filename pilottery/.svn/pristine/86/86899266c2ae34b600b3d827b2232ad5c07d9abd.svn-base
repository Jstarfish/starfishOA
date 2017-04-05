<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/views/common/taglibs.jsp"%>
<html>
<head>

<title>代理商资金报表</title>

<%@ include file="/views/common/meta.jsp" %>
<link rel="stylesheet" type="text/css" href="${basePath}/css/style.css" />
<link rel="stylesheet" href="${basePath}/component/messageBox/myJsBox.css" type="text/css"/>

<script type="text/javascript" src="${basePath}/component/messageBox/myJsBox_zh.js"></script>
<script type="text/javascript" src="${basePath}/component/My97DatePicker/WdatePicker.js"></script>
<script type="text/javascript" src="${basePath}/js/jquery/jquery-1.9.1.js"></script>

</head>
<body>
    <!-- 顶部标题块 -->
    <div id="title">代理商资金报表(根据彩票类型统计)</div>
   
    <!-- 查询条件块 -->
    <div class="queryDiv">
        <form action="analysis.do?method=agentFundReportByLotType" id="queryForm" method="post">
            <div class="left">
            	<span>类型:
            		<select class="select-normal" name="tjType">
            			<option value="0" <c:if test="${form.tjType==0}">selected="selected"</c:if> >--全部--</option>
            			<option value="1" <c:if test="${form.tjType==1}">selected="selected"</c:if> >即开票</option>
            			<option value="2" <c:if test="${form.tjType==2}">selected="selected"</c:if> >电脑票</option>
            		</select>
            	</span>
            	<span>代理商:
            		<select class="select-normal" name="institutionCode" >
            			<option value="">--全部--</option>
                   	   <c:forEach var="obj" items="${institutionList}" varStatus="plan">
                   	   		<c:if test="${obj.institutionCode == form.institutionCode && obj.orgType == 2} ">
                   	   			<option value="${obj.institutionCode}" selected="selected">${obj.institutionName}</option>
                   	   		</c:if>
                   	   		<c:if test="${obj.institutionCode != form.institutionCode && obj.orgType == 2}">
                   	   			<option value="${obj.institutionCode}">${obj.institutionName}</option>
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
	        		<input type="hidden" id="reportTitle" name="reportTitle" value="代理商资金报表(根据彩票类型统计)">
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
                        	<td style="width:7%" title="日期">日期</td>
                            <td width="1%" noExp="true">|</td>
                            <td style="width:9%" title="代理商">代理商</td>
                            <td width="1%" noExp="true">|</td>
                            <td style="width:7%" title="调拨入库">调拨入库</td>
                            <td width="1%" noExp="true">|</td>
                            <td style="width:7%" title="销售佣金">销售佣金</td>
                            <td width="1%" noExp="true">|</td>
                            <td style="width:7%" title="调拨出库">调拨出库</td>
                            <td width="1%" noExp="true">|</td>
                            <td style="width:7%" title="退还佣金">退还佣金</td>
                            <td width="1%" noExp="true">|</td>
                            <td style="width:7%" title="兑奖金额">兑奖金额</td>
                            <td width="1%" noExp="true">|</td>
                            <td style="width:7%" title="兑奖佣金">兑奖佣金</td>
                            <td width="1%" noExp="true">|</td>
                            <td style="width:7%" title="中心退票">中心退票</td>
                            <td width="1%" noExp="true">|</td>
                            <td style="width:7%" title="退票佣金">退票佣金</td>
                            <td width="1%" noExp="true">|</td>
                            <td style="width:7%" title="中心兑奖">中心兑奖</td>
                            <td width="1%" noExp="true">|</td>
                            <td style="width:*%" title="兑奖佣金">中心兑奖佣金</td>
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
            	<td style="width:7%">总计</td>
                <td width="1%" noExp="true">&nbsp;</td>
                <td style="width:9%">&nbsp;</td>
                <td width="1%" noExp="true">&nbsp;</td>
                <td style="width:7%;text-align: right;"><fmt:formatNumber value="${sum.saleAmount }" /></td>
                <td width="1%" noExp="true">&nbsp;</td>
                <td style="width:7%;text-align: right;"><fmt:formatNumber value="${sum.saleComm }" /></td>
                <td width="1%" noExp="true">&nbsp;</td>
                <td style="width:7%;text-align: right;"><fmt:formatNumber value="${sum.returnAmount }" /></td>
                <td width="1%" noExp="true">&nbsp;</td>
                <td style="width:7%;text-align: right;"><fmt:formatNumber value="${sum.returnComm }" /></td>
                <td width="1%" noExp="true">&nbsp;</td>
                <td style="width:7%;text-align: right;"><fmt:formatNumber value="${sum.payout }" /></td>
                <td width="1%" noExp="true">&nbsp;</td>
                <td style="width:7%;text-align: right;"><fmt:formatNumber value="${sum.payoutComm }" /></td>
                <td width="1%" noExp="true">&nbsp;</td>
                <td style="width:7%;text-align: right;"><fmt:formatNumber value="${sum.cancelAmount }" /></td>
                <td width="1%" noExp="true">&nbsp;</td>
                <td style="width:7%;text-align: right;"><fmt:formatNumber value="${sum.agencyCancelComm }" /></td>
                <td width="1%" noExp="true">&nbsp;</td>
                <td style="width:7%;text-align: right;"><fmt:formatNumber value="${sum.centerPayAmount }" /></td>
                <td width="1%" noExp="true">&nbsp;</td>
                <td style="width:*%;text-align: right;"><fmt:formatNumber value="${sum.centerPayComm }" /></td>
            </tr>
        </c:if>
        <c:forEach var="obj" items="${list}" varStatus="status" >
            <tr class="dataRow">
            	<td style="width:10px;" noExp="true">&nbsp;</td>
            	<td style="width:7%">${obj.balanceDate }</td>
                <td width="1%" noExp="true">&nbsp;</td>
                <td style="width:9%" title="${obj.orgName }">${obj.orgName }</td>
                <td width="1%" noExp="true">&nbsp;</td>
                <td style="width:7%;text-align: right;"><fmt:formatNumber value="${obj.saleAmount }" /></td>
                <td width="1%" noExp="true">&nbsp;</td>
                <td style="width:7%;text-align: right;"><fmt:formatNumber value="${obj.saleComm }" /></td>
                <td width="1%" noExp="true">&nbsp;</td>
                <td style="width:7%;text-align: right;"><fmt:formatNumber value="${obj.returnAmount }" /></td>
                <td width="1%" noExp="true">&nbsp;</td>
                <td style="width:7%;text-align: right;"><fmt:formatNumber value="${obj.returnComm }" /></td>
                <td width="1%" noExp="true">&nbsp;</td>
                <td style="width:7%;text-align: right;"><fmt:formatNumber value="${obj.payout }" /></td>
                <td width="1%" noExp="true">&nbsp;</td>
                <td style="width:7%;text-align: right;"><fmt:formatNumber value="${obj.payoutComm }" /></td>
                <td width="1%" noExp="true">&nbsp;</td>
                <td style="width:7%;text-align: right;"><fmt:formatNumber value="${obj.cancelAmount }" /></td>
                <td width="1%" noExp="true">&nbsp;</td>
                <td style="width:7%;text-align: right;"><fmt:formatNumber value="${obj.agencyCancelComm }" /></td>
                <td width="1%" noExp="true">&nbsp;</td>
                <td style="width:7%;text-align: right;"><fmt:formatNumber value="${obj.centerPayAmount }" /></td>
                <td width="1%" noExp="true">&nbsp;</td>
                <td style="width:*%;text-align: right;"><fmt:formatNumber value="${obj.centerPayComm }" /></td>
            </tr>
          </c:forEach>
        </table>
    </div>
</body>
</html>