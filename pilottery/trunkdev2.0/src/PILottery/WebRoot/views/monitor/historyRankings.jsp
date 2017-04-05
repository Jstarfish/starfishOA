<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/views/common/taglibs.jsp"%>
<html>
<head>
<title>Outlet History Ranking</title>

<%@ include file="/views/common/meta.jsp" %>
<link rel="stylesheet" type="text/css" href="${basePath}/css/style.css" />
<link rel="stylesheet" href="${basePath}/component/messageBox/myJsBox.css" type="text/css"/>

<script type="text/javascript" src="${basePath}/component/messageBox/myJsBox.js"></script>
<script type="text/javascript" src="${basePath}/component/My97DatePicker/WdatePicker.js"></script>
<script type="text/javascript" src="${basePath}/js/jquery/jquery-1.9.1.js"></script>

</head>
<body>
    <div id="title">Outlet History Ranking</div>
    
    <div class="queryDiv">
        <form action="monitor.do?method=historyRankings" id="queryForm" method="post">
            <div class="left">
            	<c:if test="${applicationScope.useCompany == 2}">
                <span>Type:
            		<select class="select-normal" name="tjType">
            			<option value="0" <c:if test="${form.tjType==0}">selected="selected"</c:if> >--All--</option>
            			<option value="1" <c:if test="${form.tjType==1}">selected="selected"</c:if> >PIL</option>
            			<option value="2" <c:if test="${form.tjType==2}">selected="selected"</c:if> >CTG</option>
            		</select>
            	</span>
            	</c:if>
            	<span>Institution:
            		<select class="select-normal" name="orgCode" >
            			<option value="">--All--</option>
                   	   <c:forEach var="obj" items="${institutionList}" varStatus="status">
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
                            <td style="width:5%">No.</td>
                            <td width="1%">|</td>
                            <td style="width:13%">Outlet Code</td>
                            <td width="1%">|</td>
                            <td style="width:13%">Outlet Name</td>
                            <td width="1%">|</td>
                            <td style="width:13%">Institution</td>  
                            <td width="1%">|</td>
                            <td style="width:13%">Telephone</td>  
                            <td width="1%">|</td>
                            <td style="width:13%">Sale Amount</td>
                            <td width="1%">|</td>
                            <td style="width:13%">Cancel Amount</td>
                            <td width="1%">|</td>
                            <td style="width:*%">Payout Amount</td>
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
                <td style="width:13%">${obj.agencyCode }</td>
                <td width="1%">&nbsp;</td>
                <td style="width:13%">${obj.agencyName }</td>
                <td width="1%">&nbsp;</td>
                <td style="width:13%">${obj.orgName }</td>
                <td width="1%">&nbsp;</td>
                <td style="width:13%">${obj.telephone }</td>
                <td width="1%">&nbsp;</td>
                <td style="width:13%;text-align: right;"><fmt:formatNumber value="${obj.saleAmount }" /></td>
                <td width="1%">&nbsp;</td>
                <td style="width:13%;text-align: right;"><fmt:formatNumber value="${obj.returnAmount }" /></td>
                <td width="1%">&nbsp;</td>
                <td style="width:*%;text-align: right;"><fmt:formatNumber value="${obj.payoutAmount }" /></td>
            </tr>
          </c:forEach>
        </table>
        ${pageStr}
    </div>
</body>
</html>