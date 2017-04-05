<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/views/common/taglibs.jsp"%>
<html>
<head>

<title>Sales Report By Plan</title>

<%@ include file="/views/common/meta.jsp" %>
<link rel="stylesheet" type="text/css" href="${basePath}/css/style.css" />
<link rel="stylesheet" href="${basePath}/component/messageBox/myJsBox.css" type="text/css"/>

<script type="text/javascript" src="${basePath}/component/messageBox/myJsBox_zh.js"></script>
<script type="text/javascript" src="${basePath}/component/My97DatePicker/WdatePicker.js"></script>
<script type="text/javascript" src="${basePath}/js/jquery/jquery-1.9.1.js"></script>

</head>
<body>
    <!-- 顶部标题块 -->
    <div id="title">    拒绝记录    </div>
    <!-- 列表表头块 -->
    <div id="headDiv">
        <table width="100%" border="0" cellpadding="0" cellspacing="0">
            <tr>
                <td>
                    <table class="datatable" id="exportPdf">
                        <tr class="headRow">
                       		<td style="width:10px;" noExp="true">&nbsp;</td>
                            <td style="width:12%">日期</td>
                            <td width="1%" noExp="true">|</td>
	                        <td style="width:12%">部门</td>
	                        <td width="1%" noExp="true">|</td>
                            <td style="width:20%">票号</td>
                            <td width="1%" noExp="true">|</td>
                            <td style="width:*%">操作人员</td>
                        </tr>
                    </table>
                 </td>
                 <!-- 表头和下方数据对齐 -->
                 <td style="width:17px;background:#2aa1d9"></td>
             </tr>
        </table>
    </div>
    
    <!-- 列表内容块 -->
    <div id="bodyDiv" style="top:76px;">
        <table class="datatable" id="exportPdfData">
        
        <c:forEach var="obj" items="${listchek}">
            <tr class="dataRow">
            	<td style="width:10px;" noExp="true">&nbsp;</td>
                <td style="width:12%"><fmt:formatDate  value="${obj.paidDay}"  pattern="yyyy-MM-dd HH:mm:ss" /></td>
                <td width="1%" noExp="true">&nbsp;</td>
                <td style="width:12%">${obj.orgName }</td>
                <td width="1%" noExp="true">&nbsp;</td>
                <td style="width:20%">${obj.tickNo }</td>
                <td width="1%" noExp="true">&nbsp;</td>
                <td style="width:*%;">${obj.operName }</td>
            </tr>
          </c:forEach>
        </table>
    </div>
</body>
</html>