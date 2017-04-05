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
     <div id="title">终端机在线时长</div>
    
    <div class="queryDiv">
        <form action="onlineStatistics.do?method=listOnlineRecords" id="form" method="post">
            <div class="left">
            	
            	<span>部门: 
            		<select class="select-normal" name="institutionCode" >
            		 	<c:if test="${sessionScope.current_user.institutionCode == '00'}">
            		 		<option value="">--全部--</option>
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
            	
            	<span>站点编号:
            		<input type="text" name="agencyCode" value="${form.agencyCode }" class="text-normal" ></input>
            	</span>
            	<!-- <span>在线时长:
            		<select id="onlineTime" name="onlineTime" class="select-normal" style="width:160px">
						<option value="0">未开机</option>
						<option value="1">1小时以上</option>
						<option value="2">2小时以上</option>
						<option value="3">3小时以上</option>
						<option value="4" selected="selected">4小时以上</option>
						<option value="5">5小时以上</option>
						<option value="6">6小时以上</option>
						<option value="7">7小时以上</option>
						<option value="8">8小时以上</option>
					</select>
                </span> -->
                <span>日期:
                     <input name="beginDate" value="${form.beginDate }" class="Wdate text-normal" onfocus="WdatePicker({lang:'zh-cn',dateFmt:'yyyy-MM-dd',readOnly:true})"/> 
                    	-
                    <input name="endDate" value="${form.endDate }" class="Wdate text-normal" onfocus="WdatePicker({lang:'zh-cn',dateFmt:'yyyy-MM-dd',readOnly:true})"/>
                </span>
               
                <input type="submit" value="查询" class="button-normal"></input>
            </div>
            <div style="overflow: right;">
	        	<span style="position: absolute;right: 80px;">
	        		<input type="hidden" id="reportTitle" name="reportTitle" value="终端机在线时长">
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
                        	<td style="width:10%">记录时间</td>
                            <th width="1%" noExp="true">|</th>
                        	<td style="width:10%">终端机编码</td>
                            <th width="1%" noExp="true">|</th>
                            <td style="width:10%">站点编码</td>
                            <th width="1%" noExp="true">|</th>
                            <td style="width:10%">站点名称</td>
                            <th width="1%" noExp="true">|</th>
                            <td style="width:10%">联系电话</td>
                            <th width="1%" noExp="true">|</th>
                            <td style="width:10%">所属分公司</td>
                            <th width="1%" noExp="true">|</th>
                            <td style="width:10%">管辖市场管理员</td>
                            <th width="1%" noExp="true">|</th>
                            <td style="width:*%">在线时长</td>
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