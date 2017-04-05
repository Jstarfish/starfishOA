<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/views/common/taglibs.jsp"%>
<html>
<head>
<title>终端软件查询</title>
<%-- <%@ include file="/views/common/meta.jsp" %>
<script type="text/javascript" src="${basePath}/js/jquery/jquery-1.9.1.js"></script>
<link rel="stylesheet" href="${basePath}/component/messageBox/myJsBox.css" type="text/css"/>
<script type="text/javascript" src="${basePath}/component/messageBox/myJsBox_zh.js"></script>
<script type="text/javascript" src="${basePath}/js/oms/myJs.js"></script>
<script type="text/javascript" src="${basePath}/component/My97DatePicker/WdatePicker.js"></script>
<link rel="stylesheet" type="text/css" href="${basePath}/css/style.css" /> --%>

<%@ include file="/views/common/meta.jsp" %>
<script type="text/javascript" src="${basePath}/js/jquery/jquery-1.9.1.js"></script>
    <link rel="stylesheet" href="${basePath}/component/messageBox/myJsBox.css" type="text/css"/>
    <script type="text/javascript" src="${basePath}/component/messageBox/myJsBox_zh.js"></script>
    <script type="text/javascript" src="${basePath}/js/oms/myJs.js"></script>
    <script type="text/javascript" src="${basePath}/component/My97DatePicker/WdatePicker.js"></script>
    <link rel="stylesheet" type="text/css" href="${basePath}/css/style.css"/>
<script type="text/javascript" charset="UTF-8" > 

function updateQuery(){
	var obj = document.getElementById("terminalSoftWare.tCode");
	obj.value=obj.value.replace(/[^\d]/g,'');
	$("#queryForm").submit();
}
function clearValue(){
	$(".text-normal").val('');
	$("#termType").val(-1);
}
</script>
</head>
<body>
	<div id="title">
		<span>终端软件查询</span>
	</div>
	<div class="queryDiv" style="height: 78px;">
		<form:form  modelAttribute="terminalSoftWareForm" action="terminalSoftWare.do?method=terminalSoftWareList" id="queryForm">
			<div class="left">
				<div style="height: 33px;">
					<span>
						终端机编码:<form:input path="terminalSoftWare.tCode" class="text-normal" maxlength="100" onkeyup="this.value=this.value.replace(/[^\d]/g,'')"/>
					</span>
					<span>
					终端机型号:
			         <form:select path="terminalSoftWare.termType" class="select-normal" id="termType">	
								<form:option value="-1" selected="selected">选择终端型号</form:option>
								<form:options items="${terminalTypes}" itemValue="typeCode" itemLabel="typeName"/>
						</form:select>
					</span>
					<span>当前运行软件包版本:<form:input path="terminalSoftWare.runningPkgVer" class="text-normal" maxlength="100"/></span>
					<span>正在下载的软件版本:<form:input path="terminalSoftWare.downingPkgVer" class="text-normal" maxlength="100"/></span>
				</div>
				<div style="height: 45px;">
					<span>
						最近升级时间区间:
			         <input readonly="readonly" type="text" id="upgradeStartTime" name="upgradeStartTime" value="${terminalSoftWareForm.upgradeStartTime }" class="Wdate text-normal" onFocus="var upgradeEndTime=$dp.$('upgradeEndTime');WdatePicker({onpicked:function(){upgradeEndTime.focus();},maxDate:'#F{$dp.$D(\'upgradeEndTime\')}'})"/>
					 	-
					 <input readonly="readonly" type="text" id="upgradeEndTime" name="upgradeEndTime" value="${terminalSoftWareForm.upgradeEndTime }" class="Wdate text-normal" onFocus="WdatePicker({minDate:'#F{$dp.$D(\'upgradeStartTime\')}'})"/>
					</span>
					 &nbsp;
					<span>
						最近上报日期区间:
						<input readonly="readonly" type="text" id="reportStartTime" name="reportStartTime" value="${terminalSoftWareForm.reportStartTime }" class="Wdate text-normal" onFocus="var reportEndTime=$dp.$('reportEndTime');WdatePicker({onpicked:function(){reportEndTime.focus();},maxDate:'#F{$dp.$D(\'reportEndTime\')}'})"/>
						-
						<input readonly="readonly" type="text" id="reportEndTime" name="reportEndTime" value="${terminalSoftWareForm.reportEndTime }" class="Wdate text-normal" onFocus="WdatePicker({minDate:'#F{$dp.$D(\'reportStartTime\')}'})"/>
					</span>
					&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
					<input type="button" value="查询" onclick="updateQuery();" class="button-normal"></input>
					<input type="button" value="清空" class="button-normal" onclick="clearValue()"></input>
				</div>
			</div>
		</form:form>
	</div>
	<div id="headDiv">
        <table width="100%" border="0" cellpadding="0" cellspacing="0">
        	<tr><td>
            <table class="datatable">
                <tr class="headRow">
                	<td style="width: 10px;">&nbsp;</td>
                   <td style="width:10%" class="nowrap">终端机编码</td>
                   <th width="1%">|</th>
                   <td style="width:10%" class="nowrap">终端机型号</td>
                   <th width="1%">|</th>
                   <td style="width:10%" class="nowrap">当前运行软件包版本</td>
                   <th width="1%">|</th>
                   <td style="width:10%" class="nowrap">最近升级日期</td>
                   <th width="1%">|</th>
                   <td style="width:10%" class="nowrap">最近上报日期</td>
                   <th width="1%">|</th>
                   <td style="width:*%" class="nowrap">正在下载的软件版本</td>
                </tr>
            </table>
           </td>
           <td style="width:17px;background:#2aa1d9"></td>
          </tr>
        </table>
    </div>
	<div id="bodyDiv" style="top: 154px;">
    	<table class="datatable">
    		<c:forEach var="data" items="${pageDataList}" varStatus="status" >
    			<tr class="dataRow">
    				<td style="width: 10px;">&nbsp;</td>
    				<td style="width:10%">${data.tCode }</td>
    				<td width="1%">&nbsp;</td>
                   <td style="width:10%">${data.terminalTypes.typeName}</td>
                   <td width="1%">&nbsp;</td>
                   <td style="width:10%">${data.runningPkgVer }</td>
                   <td width="1%">&nbsp;</td>
                   <td style="width:10%">${data.lastUpgradeDateToChar}</td>
                   <td width="1%">&nbsp;</td>
                   <td style="width:10%">${data.lastReportDateToChar }</td>
                   <td width="1%">&nbsp;</td>
                   <td style="width:*%">${data.downingPkgVer }</td>
    			</tr>
    		</c:forEach>
    	</table>
    	${pageStr }
    </div>
</body>
</html>
