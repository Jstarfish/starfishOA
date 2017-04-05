<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/views/common/taglibs.jsp"%>
<html>
<head>

<title>库存列表</title>

<%@ include file="/views/common/meta.jsp" %>
<link rel="stylesheet" type="text/css" href="${basePath}/css/style.css" />
<link rel="stylesheet" href="${basePath}/component/messageBox/myJsBox.css" type="text/css"/>

<script type="text/javascript" src="${basePath}/component/messageBox/myJsBox.js"></script>
<script type="text/javascript" src="${basePath}/component/My97DatePicker/WdatePicker.js"></script>
<script type="text/javascript" src="${basePath}/js/jquery/jquery-1.9.1.js"></script>
</head>
<body>
    <!-- 顶部标题块 -->
    <div id="title">库存列表</div>
    
    <!-- 列表表头块 -->
    <div id="headDiv">
    	<!-- 汇总信息 
        <div style="float: left;width: 1800px;margin-top: 26px" id="boardDiv">
        	<span style="font-size: 18px;">Summary of Inventory</span> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
			<span>Total Quantity(tickets) : <fmt:formatNumber value="${total.tickets}" /> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span>
			<span>Total Value(riels) : <fmt:formatNumber value="${total.amount}" /> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span>
		</div>-->
        <table width="100%" border="0" cellpadding="0" cellspacing="0">
            <tr>
                <td>
                    <table class="datatable">
                        <tr class="headRow">
                        	<td style="width:10px;">&nbsp;</td>
                            <td style="width:8%">编号</td>
                            <td width="1%">|</td>
                            <td style="width:20%">方案 编码</td>
                            <td width="1%">|</td>
                            <td style="width:20%">方案名称</td>
                            <td width="1%">|</td>
                            <td style="width:20%">库存数量 (张)</td>
                            <td width="1%">|</td>
                            <td style="width:*%">金额 (瑞尔)</td>
                        </tr>
                    </table>
                 </td>
                 <!-- 表头和下方数据对齐 -->
                 <td style="width:17px;background:#2aa1d9"></td>
             </tr>
        </table>
    </div>
    
    <!-- 列表内容块 -->
    <div id="bodyDiv" style="top: 76px;">
        <table class="datatable">
        <c:forEach var="obj" items="${pageDataList}" varStatus="status" >
            <tr class="dataRow">
            	<td style="width:10px;">&nbsp;</td>
                <td style="width:8%">${status.index+1 }</td>
                <td width="1%">&nbsp;</td>
                <td style="width:20%">${obj.planCode }</td>
                <td width="1%">&nbsp;</td>
                <td style="width:20%">${obj.planName }</td>
                <td width="1%">&nbsp;</td>
                <td style="width:20%"><fmt:formatNumber value="${obj.tickets }" /></td>
                <td width="1%">&nbsp;</td>
                <td style="width:*%;text-align: right;"><fmt:formatNumber value="${obj.amount }" /></td>
            </tr>
          </c:forEach>
          <tr class="dataRow">
          		<td>&nbsp;</td>
                <td colspan="6">总计</td>
                <td><fmt:formatNumber value="${total.tickets}" /></td>
                <td>&nbsp;</td>
                <td style="text-align: right;"><fmt:formatNumber value="${total.amount}" /></td>
            </tr>
        </table>
    </div>
</body>
</html>