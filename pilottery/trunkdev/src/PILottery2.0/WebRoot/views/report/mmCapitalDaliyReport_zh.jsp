<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/views/common/taglibs.jsp"%>
<html>
<head>

<title>市场管理员资金日结报表</title>

<%@ include file="/views/common/meta.jsp" %>
<link rel="stylesheet" type="text/css" href="${basePath}/css/style.css" />
<link rel="stylesheet" href="${basePath}/component/messageBox/myJsBox.css" type="text/css"/>

<script type="text/javascript" src="${basePath}/component/messageBox/myJsBox.js"></script>
<script type="text/javascript" src="${basePath}/component/My97DatePicker/WdatePicker.js"></script>
<script type="text/javascript" src="${basePath}/js/jquery/jquery-1.9.1.js"></script>

</head>
<body>
    <!-- 顶部标题块 -->
    <div id="title">市场管理员资金日结报表</div>
    
    <!-- 查询条件块 -->
    <div class="queryDiv">
        <form action="saleReport.do?method=querymmCapitalDaliyReport" id="queryForm" method="post">
            <div class="left">
            	<span>市场管理员姓名:
            		<input type="text" name="marketName" value="${form.marketName }" class="text-normal" ></input>
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
	        		<input type="hidden" id="reportTitle" name="reportTitle" value="市场管理员资金日结报表">
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
                        	<td style="width:12%">日期</td>
                            <td width="1%" noExp="true">|</td>
                            <td style="width:12%">管理员姓名</td>
                            <td width="1%" noExp="true">|</td>
                            <td style="width:12%">期初金额</td>
                            <td width="1%" noExp="true">|</td>
                            <td style="width:12%">充值</td>
                            <td width="1%" noExp="true">|</td>
                            <td style="width:12%">提现</td>
                            <td width="1%" noExp="true">|</td>
                            <td style="width:12%">上缴金额</td>
                            <td width="1%" noExp="true">|</td>
                            <td style="width:*%">期末金额</td>
                            <td width="1%" noExp="true">|</td>
                            <td style="width:*%">应缴款</td>
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
        
        <c:forEach var="obj" items="${listreport}">
            <tr class="dataRow">
            	<td style="width:10px;" noExp="true">&nbsp;</td>
              
                <td style="width:11%">${obj.calcDate}</td>
                <td width="1%" noExp="true">&nbsp;</td>
                <td style="width:11%">${obj.marketName }</td>
                <td width="1%" noExp="true">&nbsp;</td>
                <td style="width:11%;text-align: right;"><fmt:formatNumber value="${obj.initialBalance }" /></td>
                <td width="1%" noExp="true">&nbsp;</td>
                <td style="width:11%;text-align: right;"><fmt:formatNumber value="${obj.topUp }" /></td>
                <td width="1%" noExp="true">&nbsp;</td>
                <td style="width:11%;text-align: right;"><fmt:formatNumber value="${obj.withdrawn }" /></td>
                <td width="1%" noExp="true">&nbsp;</td>
                <td style="width:11%;text-align: right;"><fmt:formatNumber value="${obj.paid }" /></td>
                <td width="1%" noExp="true">&nbsp;</td>
                <td style="width:11%;text-align: right;"><fmt:formatNumber value="${obj.finalBalance }" /></td>
                 <td width="1%" noExp="true">&nbsp;</td>
                  <td style="width:*%;text-align: right;">
                	<c:if test="${obj.topUp  - obj.withdrawn  <= obj.initialBalance }">
                		0
                	</c:if>
                	<c:if test="${obj.topUp  - obj.withdrawn  > obj.initialBalance }">
                		<fmt:formatNumber value="${obj.topUp  - obj.withdrawn  - obj.initialBalance }" />
                	</c:if>
                	
                </td>
            </tr>
          </c:forEach>
        </table>
    </div>
</body>
</html>