<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/views/common/taglibs.jsp"%>
<html>
<head>

<title>还款记录列表</title>

<%@ include file="/views/common/meta.jsp" %>
<link rel="stylesheet" type="text/css" href="${basePath}/css/style.css" />
<link rel="stylesheet" href="${basePath}/component/messageBox/myJsBox.css" type="text/css"/>

<script type="text/javascript" src="${basePath}/component/messageBox/myJsBox.js"></script>
<script type="text/javascript" src="${basePath}/component/My97DatePicker/WdatePicker.js"></script>
<script type="text/javascript" src="${basePath}/js/jquery/jquery-1.9.1.js"></script>

</head>
<body>
    <!-- 顶部标题块 -->
    <div id="title">还款记录</div>
    
    <!-- 查询条件块 -->
    <div class="queryDiv">
        <form action="repaymentRecord.do?method=listRepaymentRecords" id="queryForm" method="post">
            <div class="left">
                <span>Date:
                    <input name="queryDate" value="${form.queryDate }" class="Wdate text-normal" onfocus="WdatePicker({dateFmt:'yyyy-MM-dd',readOnly:true})"/>
                </span>
                <input type="submit" value="查询" class="button-normal"></input>
            </div>
        </form>
    </div>
    
    <!-- 列表表头块 -->
    <div id="headDiv">
        <table width="100%" border="0" cellpadding="0" cellspacing="0">
            <tr>
                <td>
                    <table class="datatable">
                        <tr class="headRow">
                        	<td style="width:10px;">&nbsp;</td>
                            <td style="width:8%">编号</td>
                            <td width="1%">|</td>
                            <td style="width:20%">还款金额</td>
                            <td width="1%">|</td>
                            <td style="width:20%">还款后账户余额</td>
                            <td width="1%">|</td>
                            <td style="width:*%">还款时间</td>
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
        <table class="datatable">
        <c:forEach var="obj" items="${pageDataList}" varStatus="status" >
            <tr class="dataRow">
            	<td style="width:10px;">&nbsp;</td>
                <td style="width:8%">${status.index+1 }</td>
                <td width="1%">&nbsp;</td>
                <td style="width:20%;text-align: right;"><fmt:formatNumber value="${obj.amount }" /></td>
                <td width="1%">&nbsp;</td>
                <td style="width:20%;text-align: right;"><fmt:formatNumber value="${obj.afterBalance }" /></td>
                <td width="1%">&nbsp;</td>
                <td style="width:*%"><fmt:formatDate value="${obj.repayDate }" pattern="yyyy-MM-dd HH:mm:ss"/></td>
            </tr>
          </c:forEach>
        </table>
        ${pageStr}
    </div>
</body>
</html>