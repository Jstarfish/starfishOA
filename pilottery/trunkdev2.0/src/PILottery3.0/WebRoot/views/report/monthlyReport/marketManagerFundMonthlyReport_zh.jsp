<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/views/common/taglibs.jsp"%>
<html>
<head>

<title>市场管理员销售月报表</title>

<%@ include file="/views/common/meta.jsp" %>
<link rel="stylesheet" type="text/css" href="${basePath}/css/style.css" />
<link rel="stylesheet" href="${basePath}/component/messageBox/myJsBox.css" type="text/css"/>

<script type="text/javascript" src="${basePath}/component/messageBox/myJsBox_zh.js"></script>
<script type="text/javascript" src="${basePath}/component/My97DatePicker/WdatePicker.js"></script>
<script type="text/javascript" src="${basePath}/js/jquery/jquery-1.9.1.js"></script>

</head>
<body>
    <!-- 顶部标题块 -->
    <div id="title">市场管理员销售月报表</div>
   
    <!-- 查询条件块 -->
    <div class="queryDiv">
        <form action="monthlyReport.do?method=listMktManagerMonthlyReport" id="queryForm" method="post">
            <div class="left">
            	<span>类型:
            		<select class="select-normal" name="tjType">
            			<option value="0" <c:if test="${form.tjType==0}">selected="selected"</c:if> >--全部--</option>
            			<option value="1" <c:if test="${form.tjType==1}">selected="selected"</c:if> >即开票</option>
            			<option value="2" <c:if test="${form.tjType==2}">selected="selected"</c:if> >电脑票</option>
            		</select>
            	</span>
            	<span>部门:
            		<select class="select-normal" name="institutionCode" >
            			<option value="">--全部--</option>
                   	   <c:forEach var="obj" items="${institutionList}" varStatus="status">
                   	   		<c:if test="${obj.institutionCode == form.institutionCode}">
                   	   			<option value="${obj.institutionCode}" selected="selected">${obj.institutionName}</option>
                   	   		</c:if>
                   	   		<c:if test="${obj.institutionCode != form.institutionCode}">
                   	   			<option value="${obj.institutionCode}">${obj.institutionName}</option>
                   	   		</c:if>
                   	   </c:forEach>
                    </select>
            	</span>
            	<span>市场管理员姓名:
            		<input type="text" name="realName" value="${form.realName }" class="text-normal" ></input>
            	</span>
                <span>日期:
                    <input name="beginDate" value="${form.beginDate }" class="Wdate text-normal" style="width: 130px;height:24px;" onfocus="WdatePicker({lang:'zh-cn',dateFmt:'yyyy-MM',maxDate:'%y-{%M}',readOnly:true})"/> 
                    	-
                    <input name="endDate" value="${form.endDate }" class="Wdate text-normal" style="width: 130px;height:24px;" onfocus="WdatePicker({lang:'zh-cn',dateFmt:'yyyy-MM',maxDate:'%y-{%M}',readOnly:true})"/>
                </span>
                <input type="submit" value="查询" class="button-normal"></input>
            </div>
             <div style="overflow: right;">
	        	<span style="position: absolute;right: 80px;">
	        		<input type="hidden" id="reportTitle" name="reportTitle" value="市场管理员销售月报表">
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
                        	<td style="width:9%" title="月份">月份</td>
                            <td width="1%" noExp="true">|</td>
                        	<td style="width:10%" title="市场管理员">市场管理员</td>
                            <td width="1%" noExp="true">|</td>
                        	<td style="width:10%" title="所属部门">所属部门</td>
                            <td width="1%" noExp="true">|</td>
                            <td style="width:10%" title="充值金额">充值金额</td>
                            <td width="1%" noExp="true">|</td>
                            <td style="width:10%" title="提现金额">提现金额</td>
                            <td width="1%" noExp="true">|</td>
                            <td style="width:10%" title="销售金额">销售金额</td>
                            <td width="1%" noExp="true">|</td>
                            <td style="width:10%" title="兑奖金额">兑奖金额</td>
                            <td width="1%" noExp="true">|</td>
                            <td style="width:10%" title="退货金额">退货金额</td>
                            <td width="1%" noExp="true">|</td>
                            <td style="width:*%" title="净销售额">净销售额</td>
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
            	<td style="width:9%">总计</td>
                <td width="1%" noExp="true">&nbsp;</td>
                <td style="width:10%">&nbsp;</td>
                <td width="1%" noExp="true">&nbsp;</td>
                <td style="width:10%">&nbsp;</td>
                <td width="1%" noExp="true">&nbsp;</td>     <!-- 所属部门 -->
                <td style="width:10%;text-align: right;"><fmt:formatNumber value="${sum.topup }" /></td>
                <td width="1%" noExp="true">&nbsp;</td>
                <td style="width:10%;text-align: right;"><fmt:formatNumber value="${sum.withdraw }" /></td>
                <td width="1%" noExp="true">&nbsp;</td>
                <td style="width:10%;text-align: right;"><fmt:formatNumber value="${sum.saleAmount }" /></td>
                <td width="1%" noExp="true">&nbsp;</td>
                <td style="width:10%;text-align: right;"><fmt:formatNumber value="${sum.payout }" /></td>
                <td width="1%" noExp="true">&nbsp;</td>
                <td style="width:10%;text-align: right;"><fmt:formatNumber value="${sum.returnAmount }" /></td>
                <td width="1%" noExp="true">&nbsp;</td>
                <td style="width:*%;text-align: right;"><fmt:formatNumber value="${sum.netSales }" /></td>
            </tr>
        </c:if>
        <c:forEach var="obj" items="${list}" varStatus="status" >
            <tr class="dataRow">
            	<td style="width:10px;" noExp="true">&nbsp;</td>
                <td style="width:9%" title="${obj.showDate }">${obj.showDate }</td>
                <td width="1%" noExp="true">&nbsp;</td>
                <td style="width:10%" title="${obj.realName }">${obj.realName }</td>
                <td width="1%" noExp="true">&nbsp;</td>
                <td style="width:10%" title="${obj.institutionName }">${obj.institutionName }</td>
                <td width="1%" noExp="true">&nbsp;</td>
                <td style="width:10%;text-align: right;"><fmt:formatNumber value="${obj.topup }" /></td>
                <td width="1%" noExp="true">&nbsp;</td>
                <td style="width:10%;text-align: right;"><fmt:formatNumber value="${obj.withdraw }" /></td>
                <td width="1%" noExp="true">&nbsp;</td>
                <td style="width:10%;text-align: right;"><fmt:formatNumber value="${obj.saleAmount }" /></td>
                <td width="1%" noExp="true">&nbsp;</td>
                <td style="width:10%;text-align: right;"><fmt:formatNumber value="${obj.payout }" /></td>
                <td width="1%" noExp="true">&nbsp;</td>
                <td style="width:10%;text-align: right;"><fmt:formatNumber value="${obj.returnAmount }" /></td>
                <td width="1%" noExp="true">&nbsp;</td>
                <td style="width:*%;text-align: right;"><fmt:formatNumber value="${obj.netSales }" /></td>
            </tr>
          </c:forEach>
        </table>
    </div>
</body>
</html>