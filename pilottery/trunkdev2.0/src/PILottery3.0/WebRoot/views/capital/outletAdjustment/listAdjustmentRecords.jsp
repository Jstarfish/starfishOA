<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/views/common/taglibs.jsp"%>
<html>
<head>

<title></title>
<%@ include file="/views/common/meta.jsp" %>
<link rel="stylesheet" type="text/css" href="${basePath}/css/style.css" />
<link rel="stylesheet" href="${basePath}/component/messageBox/myJsBox.css" type="text/css"/>
<script type="text/javascript" src="${basePath}/component/messageBox/myJsBox.js"></script>
<script type="text/javascript" src="${basePath}/component/My97DatePicker/WdatePicker.js"></script>
<script type="text/javascript" src="${basePath}/js/jquery/jquery-1.9.1.js"></script>
<script type="text/javascript">
function print(obj){
	showPage('account.do?method=certificate&fundNo=' + obj,'Print');
}
</script>
</head>
<body>
   <!-- 顶部标题块 -->
    <div id="title">Adjustment Record</div>
    <!-- 查询条件块 -->
    <div class="queryDiv">
        <form action="account.do?method=listAdjustmentRecords" method="POST" id="outletAcctForm">
            <div class="left">
            	<span>机构:
            		<select class="select-normal" name="orgCode" >
            			<option value="">--All--</option>
                   	   <c:forEach var="obj" items="${institutionList}" varStatus="plan">
                   	   		<c:if test="${obj.institutionCode == form.orgCode}">
                   	   			<option value="${obj.institutionCode}" selected="selected">${obj.institutionName}</option>
                   	   		</c:if>
                   	   		<c:if test="${obj.institutionCode != form.orgCode}">
                   	   			<option value="${obj.institutionCode}">${obj.institutionName}</option>
                   	   		</c:if>
                   	   </c:forEach>
                    </select>
            	</span>
                <span>Date:
                    <input name="beginDate" value="${form.beginDate }" class="Wdate text-normal" onfocus="WdatePicker({lang:'en',dateFmt:'yyyy-MM-dd',readOnly:true})"/> 
                    	-
                    <input name="endDate" value="${form.endDate }" class="Wdate text-normal" onfocus="WdatePicker({lang:'en',dateFmt:'yyyy-MM-dd',readOnly:true})"/>
                </span>
                <span>Outlet Code: <input id="agencyCode" name="agencyCode" value="${form.agencyCode }" class="text-normal" maxlength="10"/></span>
                <input type="submit" value="Query" class="button-normal"></input>
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
                            <td style="width:10%">Operate Time</td>
                            <th width="1%">|</th>
                            <td style="width:8%">Outlet Code</td>
                            <th width="1%">|</th>
                            <td style="width:8%">Outlet Name</td>
                            <th width="1%">|</th>
                            <td style="width:10%">Credit</td>
                            <th width="1%">|</th>
                            <td style="width:10%">Before Balance</td>
                            <th width="1%">|</th>
                            <td style="width:8%">Adjust Amount</td>
                            <th width="1%">|</th>
                            <td style="width:10%">After Balance</td>
                            <th width="1%">|</th>
                            <td style="width:10%">Operator</td>
                            <th width="1%">|</th>
                            <td style="width:*%">Reason</td>
                        </tr>
                    </table>
                 </td>
                 <!-- 表头和下方数据对齐 -->
                 <td style="width:17px;background:#2aa1d9"></td>
             </tr>
        </table>
    </div>
    
    <!-- 列表内容块 -->
    <div id="bodyDiv" >
        <table class="datatable">
         <c:forEach var="data" items="${pageDataList}" varStatus="status" >
            <tr class="dataRow">
            	<td style="width:10px;">&nbsp;</td>
            	<td style="width:10%"><fmt:formatDate value="${data.operTime }" pattern="yyyy-MM-dd HH:mm:ss"/></td>
                <td width="1%">&nbsp;</td>
                <td style="width:8%">${data.agencyCode }</td>
                <td width="1%">&nbsp;</td>
                <td style="width:8%" title="${data.agencyName }">${data.agencyName }</td>
                <td width="1%">&nbsp;</td>
                <td style="width:10%;text-align:right; title="${data.credit }"><fmt:formatNumber value="${data.credit }" /></td>
                <td width="1%">&nbsp;</td>
                <td style="width:10%;text-align:right; title="${data.beforeBalance }"><fmt:formatNumber value="${data.beforeBalance }" /></td>
                <td width="1%">&nbsp;</td>
                <td style="width:8%;text-align:right; title="${data.adjustAmount }"><fmt:formatNumber value="${data.adjustAmount }" /></td>
                <td width="1%">&nbsp;</td>
                <td style="width:10%;text-align:right; title="${data.afterBalance }"><fmt:formatNumber value="${data.afterBalance }" /></td>
                <td width="1%">&nbsp;</td>
                <td style="width:10%" title="${data.operAdminName }">${data.operAdminName }</td>
                <td width="1%">&nbsp;</td>
                <td style="width:10%" title="${data.reason }">${data.reason }</td>
                <td width="1%">&nbsp;</td>
				<td style="width:*%">
                <span><a href="#" onclick="print('${data.fundNo}')">Print</a></span>
            </tr>
            </c:forEach>
        </table>
      ${pageStr} 
    </div>
</body> 

</html>