<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/views/common/taglibs.jsp"%>
<html>
<head>

<title>Operation Type List</title>

<%@ include file="/views/common/meta.jsp" %>
<link rel="stylesheet" type="text/css" href="${basePath}/css/style.css" />
<link rel="stylesheet" href="${basePath}/component/messageBox/myJsBox.css" type="text/css"/>
<script type="text/javascript" src="${basePath}/component/messageBox/myJsBox_zh.js"></script>
<script type="text/javascript" src="${basePath}/component/My97DatePicker/WdatePicker.js"></script>
<script type="text/javascript" src="${basePath}/js/myJs.js"></script>
<script type="text/javascript" src="${basePath}/js/jquery/jquery-1.9.1.js"></script>
<script type="text/javascript" src="${basePath}/js/regexEnum.js"></script>

</head>
<body>
    <!-- 顶部标题块 -->
    <div id="title">Operation Type List</div>
    
    <!-- 列表表头块 -->
    <div id="headDiv">
        <table width="100%" border="0" cellpadding="0" cellspacing="0">
            <tr>
                <td>
                    <table class="datatable">
                        <tr class="headRow">
                        <td style="width:10px;">&nbsp;</td>
                            <td style="width:20%">No.</td>
                             <td width="1%" >|</td>
                            <td style="width:20%">Operation Type</td>
                             <td width="1%" >|</td>
                            <td style="width:20%">Alarm Threshold</td>
                             <td width="1%" >|</td>
                            <td style="width:20%">Description</td>
                             <td width="1%" >|</td>
                            <td style="width:*%">Operation</td>
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
        
         <c:forEach var="data" items="${pageDataList}" varStatus="status" >
            <tr class="dataRow">
            <td style="width:10px;">&nbsp;<input type="hidden" value="${data.operModeId }"></td>
                <td style="width:20%">${status.index + 1 }</td>
                 <td width="1%" >&nbsp;</td>
                <td style="width:20%" title="${data.operModeName }">${data.operModeName }</td>
                 <td width="1%" >&nbsp;</td>
                <td style="width:20%" title="${data.operModeThreshold }">${data.operModeThreshold }</td>
                 <td width="1%" >&nbsp;</td>
                <td style="width:20%">${data.operContents }</td>
                 <td width="1%" >&nbsp;</td>
                <td style="width:*%">
                    <span><a href="#" onclick="showBox('operateLog.do?method=initModifyOperateType&operModeId=${data.operModeId }','Edit',350,550);">Edit</a></span>
                </td>
            </tr>
            </c:forEach>
        </table>
      ${pageStr} 
    </div>
</body>
</html>