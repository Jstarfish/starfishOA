<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/views/common/taglibs.jsp"%>
<html>
<head>
<title></title>

<%@ include file="/views/common/meta.jsp" %>
<link rel="stylesheet" type="text/css" href="${basePath}/css/style.css" />
<link rel="stylesheet" href="${basePath}/component/messageBox/myJsBox.css" type="text/css"/>
<script type="text/javascript" src="${basePath}/component/messageBox/myJsBox_zh.js"></script>
<script type="text/javascript" src="${basePath}/component/My97DatePicker/WdatePicker.js"></script>
<script type="text/javascript" src="${basePath}/js/jquery/jquery-1.9.1.js"></script>
<script type="text/javascript">
$(document).ready(function() { 
	var onlineTime = '${form.onlineTime}';
	$('#onlineTime').val(onlineTime);
});
	
</script>
</head>
<body>
     <div id="title">Terminal Online Time</div>
    
    <div class="queryDiv">
        <form action="onlineStatistics.do?method=listOnlineRecords" id="form" method="post">
            <div class="left">
            	
            	<span>Institution: 
            		<select class="select-normal" name="institutionCode" >
            		 	<c:if test="${sessionScope.current_user.institutionCode == '00'}">
            		 		<option value="">--All--</option>
            		 		<c:forEach var="obj" items="${orgList}" varStatus="s">
	                   	   		<c:if test="${obj.orgCode != form.institutionCode}">
	                   	   			<option value="${obj.orgCode}">${obj.orgName}</option>
	                   	   		</c:if>
	                   	   		<c:if test="${obj.orgCode == form.institutionCode}">
	                   	   			<option value="${obj.orgCode}" selected="selected">${obj.orgName}</option>
	                   	   		</c:if>
                   	  		</c:forEach>
            		 	</c:if>
            			<c:if test="${sessionScope.current_user.institutionCode != '00'}">
            				<c:forEach var="obj" items="${orgList}" varStatus="s">
	                   	   		<c:if test="${obj.orgCode == form.cuserOrg}">
	                   	   			<option value="${obj.orgCode}" selected="selected">${obj.orgName}</option>
	                   	   		</c:if>
                   	  		</c:forEach>
            		 	</c:if>
                    </select>
            	</span>
            	
            	<span>Outlet Code:
            		<input type="text" name="agencyCode" value="${form.agencyCode }" class="text-normal" ></input>
            	</span>
            	<!-- <span>Online Time:
            		<select id="onlineTime" name="onlineTime" class="select-normal" style="width:160px">
						<option value="0">Not Boot</option>
						<option value="1">More than 1 hours</option>
						<option value="2">More than 2 hours</option>
						<option value="3">More than 3 hours</option>
						<option value="4" selected="selected">More than 4 hours</option>
						<option value="5">More than 5 hours</option>
						<option value="6">More than 6 hours</option>
						<option value="7">More than 7 hours</option>
						<option value="8">More than 8 hours</option>
					</select>
                </span> -->
                <span>Date:
                     <input name="beginDate" value="${form.beginDate }" class="Wdate text-normal" onfocus="WdatePicker({lang:'zh-cn',dateFmt:'yyyy-MM-dd',readOnly:true})"/> 
                    	-
                    <input name="endDate" value="${form.endDate }" class="Wdate text-normal" onfocus="WdatePicker({lang:'zh-cn',dateFmt:'yyyy-MM-dd',readOnly:true})"/>
                </span>
               
                <input type="submit" value="Query" class="button-normal"></input>
            </div>
            <div style="overflow: right;">
	        	<span style="position: absolute;right: 80px;">
	        		<input type="hidden" id="reportTitle" name="reportTitle" value="Terminal Online Time">
	            	<er:exportReport url="${pageContext.request.contextPath }/er/exportReportServlet" types="excel" classs="icon-lz" tableId="exportPdf"  title="exportPdf"></er:exportReport>
	            </span>
        	</div>
        </form>
    </div>
    <div id="headDiv">
        <table width="100%" border="0" cellpadding="0" cellspacing="0">
            <tr>
                <td>
                    <table class="datatable" id="exportPdf">
                        <tr class="headRow">
                        	<td style="width:10px;" noExp="true">&nbsp;</td>
                        	<td style="width:10%">Record Time</td>
                            <th width="1%" noExp="true">|</th>
                        	<td style="width:10%">Terminal Code</td>
                            <th width="1%" noExp="true">|</th>
                            <td style="width:10%">Outlet Code</td>
                            <th width="1%" noExp="true">|</th>
                            <td style="width:10%">Outlet Name</td>
                            <th width="1%" noExp="true">|</th>
                            <td style="width:10%">Telephone</td>
                            <th width="1%" noExp="true">|</th>
                            <td style="width:10%">Department</td>
                            <th width="1%" noExp="true">|</th>
                            <td style="width:10%">Market Manager</td>
                            <th width="1%" noExp="true">|</th>
                            <td style="width:*%">Online Time</td>
                        </tr>
                    </table>
                 </td>
                 <td style="width:17px;background:#2aa1d9"></td>
             </tr>
        </table>
    </div>
    <div id="bodyDiv">
        <table class="datatable" id="exportPdfData">
        <c:forEach var="obj" items="${pageDateList}" varStatus="status" >
            <tr class="dataRow">
            	<td style="width:10px;" noExp="true">&nbsp;</td>
            	<td style="width:10%">${obj.recordDay}</td>
                <td width="1%" noExp="true">&nbsp;</td>
            	<td style="width:10%">${obj.terminalCode }</td>
                <td width="1%" noExp="true">&nbsp;</td>
                <td style="width:10%">${obj.agencyCode }</td>
                <td width="1%" noExp="true">&nbsp;</td>
                <td style="width:10%">${obj.agencyName}</td>
                <td width="1%" noExp="true">&nbsp;</td>
                <td style="width:10%" >${obj.phone}</td>
                <td width="1%" noExp="true">&nbsp;</td>
                <td style="width:10%" >${obj.institutionName}</td>
                <td width="1%" noExp="true">&nbsp;</td>
                <td style="width:10%;">${obj.adminRealName }</td>
                <td width="1%" noExp="true">&nbsp;</td>
                <td style="width:*%;"><fmt:formatNumber value="${obj.onlineTime }"/></td>
            </tr>   
          </c:forEach>
        </table>
    </div>
</body> 
</html>