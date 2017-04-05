<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/views/common/taglibs.jsp"%>
<html>
<head>

<title>站点信息统计报表</title>

<%@ include file="/views/common/meta.jsp" %>
<link rel="stylesheet" type="text/css" href="${basePath}/css/style.css" />
<link rel="stylesheet" href="${basePath}/component/messageBox/myJsBox.css" type="text/css"/>

<script type="text/javascript" src="${basePath}/component/messageBox/myJsBox_zh.js"></script>
<script type="text/javascript" src="${basePath}/component/My97DatePicker/WdatePicker.js"></script>
<script type="text/javascript" src="${basePath}/js/jquery/jquery-1.9.1.js"></script>
<script type="text/javascript" src="${basePath}/js/mydate.js"></script>
<script type="text/javascript">
$(function() {
	$('#selDate').change(function(){
		var select = $('#selDate').val();
		if(select == 0){
			$("input[name='beginDate']").val(getToday());
			$("input[name='endDate']").val(getToday());
		}
		if(select == 1){
			$("input[name='beginDate']").val(getYestoday(getToday()));
			$("input[name='endDate']").val(getYestoday(getToday()));
			
		}
		if(select == 2){
			$("input[name='beginDate']").val(getWeekStartDate());
			$("input[name='endDate']").val(getToday());
		}
		if(select == 3){
			$("input[name='beginDate']").val(getLastWeekStartDate());
			$("input[name='endDate']").val(getLastWeekEndDate());
		}
		if(select == 4){
			$("input[name='beginDate']").val(getMonthStartDate());
			$("input[name='endDate']").val(getToday());
		}
		if(select == 5){
			$("input[name='beginDate']").val(getLastMonthStartDate());
			$("input[name='endDate']").val(getLastMonthEndDate());
		}
	});
	var selDate = '${form.selDate }';
    $('#selDate').val(selDate);
});
</script>
</head>
<body>
    <!-- 顶部标题块 -->
    <div id="title">站点信息统计报表</div>
    
    <!-- 查询条件块 -->
    <div class="queryDiv">
        <form action="analysis.do?method=outletStatistics" id="queryForm" method="post">
            <div class="left">
            	<span>组织机构:
            		<select class="select-normal" name="institutionCode" >
            			<option value="">--全部--</option>
                   	   <c:forEach var="obj" items="${institutionList}" varStatus="plan">
                   	   		<c:if test="${obj.institutionCode == form.institutionCode}">
                   	   			<option value="${obj.institutionCode}" selected="selected">${obj.institutionName}</option>
                   	   		</c:if>
                   	   		<c:if test="${obj.institutionCode != form.institutionCode}">
                   	   			<option value="${obj.institutionCode}">${obj.institutionName}</option>
                   	   		</c:if>
                   	   </c:forEach>
                    </select>
            	</span>
            	<span>站点编码:
            		<input name="outletCode" value="${form.outletCode }" class="text-normal" />
            	</span>
                <span>日期:
                    <input name="beginDate" value="${form.beginDate }" class="Wdate text-normal" onfocus="WdatePicker({lang:'zh-cn',dateFmt:'yyyy-MM-dd',readOnly:true})"/> 
                    	-
                    <input name="endDate" value="${form.endDate }" class="Wdate text-normal" onfocus="WdatePicker({lang:'zh-cn',dateFmt:'yyyy-MM-dd',readOnly:true})"/>
                </span>
                <span>
	              <select name="selDate" id="selDate" class="select-normal" style="width:180px" >
						<option value="0">--请选择日期--</option>
						<option	value="1">昨天</option>
						<option	value="2" >本周</option>
						<option	value="3" >上周</option>
						<option	value="4" >本月</option>
						<option	value="5" >上月</option>
					</select>
				</span>
                <span>状态:
            		<select class="select-normal" name="status" id="status">
            			<option value="">--全部--</option>
            			<option value="1" <c:if test="${form.status == 1}">selected</c:if>>可用</option>
            			<option value="2" <c:if test="${form.status == 2}">selected</c:if>>已禁用</option>
            			<option value="3" <c:if test="${form.status == 3}">selected</c:if>>已清退</option>
                    </select>
            	</span>
                <input type="submit" value="查询" class="button-normal"></input>
            </div>
             <div style="overflow: right;">
	        	<span style="position: absolute;right: 80px;">
	        		<input type="hidden" id="reportTitle" name="reportTitle" value="站点信息统计报表">
	            	<er:exportReport url="${pageContext.request.contextPath }/er/exportReportServlet" types="excel" classs="icon-lz" tableId="exportPdf"  title="exportPdf"></er:exportReport>
	            </span>
        	</div>
        </form>
    </div>
    
    <!-- 列表表头块 -->
    <div id="headDiv">
        <table width="100%" border="0" cellpadding="0" cellspacing="0">
            <tr>
                <td>
                    <table class="datatable" id="exportPdf">
                        <tr class="headRow">
                       		<td style="width:10px;" noExp="true">&nbsp;</td>
                            <td style="width:6%">创建日期</td>
                            <td width="1%" noExp="true">|</td>
                            <td style="width:8%">组织机构</td>
                            <td width="1%" noExp="true">|</td>
                            <td style="width:8%">站点名称</td>
                            <td width="1%" noExp="true">|</td>
                            <td style="width:6%">站点编码</td>
                            <td width="1%" noExp="true">|</td>
                            <td style="width:8%">联系人</td>
                            <td width="1%" noExp="true">|</td>
                            <td style="width:8%">电话号码</td>
                            <td width="1%" noExp="true">|</td>
                            <td style="width:8%">合同编号</td>
                            <td width="1%" noExp="true">|</td>
                            <td style="width:6%">信用额度</td>
                            <td width="1%" noExp="true">|</td>
                            <td style="width:6%">状态</td>
                            <td width="1%" noExp="true">|</td>
                            <td style="width:8%">地址</td>
                            <td width="1%" noExp="true">|</td>
                            <td style="width:*%" noExp="true">佣金详情</td>
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
        <c:forEach var="obj" items="${list}">
            <tr class="dataRow">
            	<td style="width:10px;" noExp="true">&nbsp;</td>
                <td style="width:6%">${obj.addTime}</td>
                <td width="1%" noExp="true">&nbsp;</td>
                <td style="width:8%">${obj.orgName }</td>
                <td width="1%" noExp="true">&nbsp;</td>
                <td style="width:8%">${obj.agencyName }</td>
                <td width="1%" noExp="true">&nbsp;</td>
                <td style="width:6%">${obj.agencyCode }</td>
                <td width="1%" noExp="true">&nbsp;</td>
                <td style="width:8%">${obj.contactPerson }</td>
                <td width="1%" noExp="true">&nbsp;</td>
                <td style="width:8%">${obj.telephone }</td>
                <td width="1%" noExp="true">&nbsp;</td>
                <td style="width:8%;">${obj.contractNo}</td>
                <td width="1%" noExp="true">&nbsp;</td>
                <td style="width:6%;text-align: right"><fmt:formatNumber value="${obj.credit}" /></td>
                <td width="1%" noExp="true">&nbsp;</td>
                <td style="width:6%;">
                	<c:if test="${obj.status == 1}">
                		可用
                	</c:if>
                	<c:if test="${obj.status == 2}">
                		已禁用
                	</c:if>
                	<c:if test="${obj.status == 3}">
                		已清退
                	</c:if>
                </td>
                <td width="1%" noExp="true">&nbsp;</td>
                <td style="width:8%;" title="${obj.address}">${obj.address}</td>
                <td width="1%" noExp="true">&nbsp;</td>
                <td style="width:*%;" noExp="true">
                	<c:if test="${applicationScope.useCompany == 2}">
	                	<span>
	                		<a href="#" onclick="showBox('analysis.do?method=pilAuthDetail&agencyCode=${obj.agencyCode }','即开票详情',500,800)">即开票</a>
	                	</span>&nbsp;|
						<span>
							<a href="#" onclick="showBox('analysis.do?method=ctgAuthDetail&agencyCode=${obj.agencyCode }','电脑票详情',450,900)">电脑票</a>
						</span>
					</c:if>
					<c:if test="${applicationScope.useCompany == 1}">
						<span>
							<a href="#" onclick="showBox('analysis.do?method=ctgAuthDetail&agencyCode=${obj.agencyCode }','佣金详情',450,900)">佣金详情</a>
						</span>
					</c:if>
                </td>
            </tr>
          </c:forEach>
        </table>
    </div>
</body>
</html>