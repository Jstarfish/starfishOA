<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/views/common/taglibs.jsp"%>
<html>
<head>
<meta http-equiv="refresh" content="120;url=${basePath}/monitor.do?method=outletRankings&areaCode=${form.areaCode}&planCode=${form.planCode}">
<title>Outlet Ranking</title>

<%@ include file="/views/common/meta.jsp" %>
<link rel="stylesheet" type="text/css" href="${basePath}/css/style.css" />
<link rel="stylesheet" href="${basePath}/component/messageBox/myJsBox.css" type="text/css"/>

<script type="text/javascript" src="${basePath}/component/messageBox/myJsBox_zh.js"></script>
<script type="text/javascript" src="${basePath}/component/My97DatePicker/WdatePicker.js"></script>
<script type="text/javascript" src="${basePath}/js/jquery/jquery-1.9.1.js"></script>

</head>
<body>
    <!-- 顶部标题块 -->
    <div id="title">销售站排行</div>
    
    <!-- 查询条件块 -->
    <div class="queryDiv">
        <form action="monitor.do?method=outletRankings" id="queryForm" method="post">
            <div class="left">
                <span>区域:
                	<select class="select-normal"  name="areaCode" id="areaCode">
						<option value=""> -- 所有 --</option>
						<c:forEach var="item" items="${areasList}" varStatus="s2">
                   	   		<option value="${item.areaCode }" <c:if test="${form.areaCode==item.areaCode }">selected</c:if>>${item.areaName }</option>
                   	    </c:forEach>
                    </select>
                </span>
                <span>方案:
                    <select name="planCode" id="planCode" class="select-normal">
						<option value="">--所有--</option>
					   <c:forEach var="item" items="${planMap}">
					      <option value="${item.key}" <c:if test="${form.planCode==item.key }">selected</c:if>>${item.value}</option>
					   </c:forEach>
					</select>
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
                            <td style="width:5%">序号</td>
                            <td width="1%">|</td>
                            <td style="width:15%">站点编码</td>
                            <td width="1%">|</td>
                            <td style="width:15%">站点名称</td>
                            <td width="1%">|</td>
                            <td style="width:15%">部门</td>  
                            <td width="1%">|</td>
                            <td style="width:15%">销售总额</td>
                            <td width="1%">|</td>
                            <td style="width:15%">退票金额</td>
                            <td width="1%">|</td>
                            <td style="width:*%">兑奖金额</td>
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
                <td style="width:5%">${status.index+1 }</td>
                <td width="1%">&nbsp;</td>
                <td style="width:15%">${obj.agencyCode }</td>
                <td width="1%">&nbsp;</td>
                <td style="width:15%">${obj.agencyName }</td>
                <td width="1%">&nbsp;</td>
                <td style="width:15%">${obj.orgName }</td> 
                <td width="1%">&nbsp;</td>
                <td style="width:15%;text-align: right;"><fmt:formatNumber value="${obj.saleAmount }" /></td>
                <td width="1%">&nbsp;</td>
                <td style="width:15%;text-align: right;"><fmt:formatNumber value="${obj.cancelAmount }" /></td>
                <td width="1%">&nbsp;</td>
                <td style="width:*%;text-align: right;"><fmt:formatNumber value="${obj.payAmount }" /></td>
            </tr>
          </c:forEach>
        </table>
        ${pageStr}
    </div>
</body>
</html>