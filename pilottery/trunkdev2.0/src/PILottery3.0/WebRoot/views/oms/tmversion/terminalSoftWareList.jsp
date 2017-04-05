<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/views/common/taglibs.jsp"%>
<html>
<head>
<title>Terminal Software Inquiry</title>
<%@ include file="/views/common/meta.jsp" %>
<script type="text/javascript" src="${basePath}/js/jquery/jquery-1.9.1.js"></script>
    <link rel="stylesheet" href="${basePath}/component/messageBox/myJsBox.css" type="text/css"/>
    <script type="text/javascript" src="${basePath}/component/messageBox/myJsBox.js"></script>
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
		<span>Terminal Software Inquiry</span>
	</div>
	<div class="queryDiv" style="height: 78px;">
		<form:form  modelAttribute="terminalSoftWareForm" action="terminalSoftWare.do?method=terminalSoftWareList" id="queryForm">
			<div class="left">
				<div style="height: 33px;">
					<span>
						Terminal Code:<form:input path="terminalSoftWare.tCode" class="text-normal" maxlength="100" onkeyup="this.value=this.value.replace(/[^\d]/g,'')"/>
					</span>
					<span>
					Machine:<!--
			         --><form:select path="terminalSoftWare.termType" class="select-normal" id="termType">	
								<form:option value="-1" selected="selected">Select model</form:option>
								<form:options items="${terminalTypes}" itemValue="typeCode" itemLabel="typeName"/>
						</form:select>
					</span>
					<span>Current Version:<form:input path="terminalSoftWare.runningPkgVer" class="text-normal" maxlength="100"/></span>
					<span>Download Version:<form:input path="terminalSoftWare.downingPkgVer" class="text-normal" maxlength="100"/></span>
				</div>
				<div style="height: 45px;">
					<span>
						Upgrade Time:<!--
			         --><input readonly="readonly" type="text" id="upgradeStartTime" name="upgradeStartTime" value="${terminalSoftWareForm.upgradeStartTime }" class="Wdate text-normal" onFocus="var upgradeEndTime=$dp.$('upgradeEndTime');WdatePicker({onpicked:function(){upgradeEndTime.focus();},maxDate:'#F{$dp.$D(\'upgradeEndTime\')}'})"/>
							 -
						<input readonly="readonly" type="text" id="upgradeEndTime" name="upgradeEndTime" value="${terminalSoftWareForm.upgradeEndTime }" class="Wdate text-normal" onFocus="WdatePicker({minDate:'#F{$dp.$D(\'upgradeStartTime\')}'})"/>
						<!--<form:input id="upgradeEndTime" path="upgradeEndTime" class="Wdate bdinput" onfocus="WdatePicker({dateFmt:'yyyy-MM-dd',readOnly:true})"/>-->
					</span>
					 &nbsp;
					<span>
						Last Report Time:
			         <input readonly="readonly" type="text" id="reportStartTime" name="reportStartTime" value="${terminalSoftWareForm.reportStartTime }" class="Wdate text-normal" onFocus="var reportEndTime=$dp.$('reportEndTime');WdatePicker({onpicked:function(){reportEndTime.focus();},maxDate:'#F{$dp.$D(\'reportEndTime\')}'})"/>
					-
						<input readonly="readonly" type="text" id="reportEndTime" name="reportEndTime" value="${terminalSoftWareForm.reportEndTime }" class="Wdate text-normal" onFocus="WdatePicker({minDate:'#F{$dp.$D(\'reportStartTime\')}'})"/>
						<!--<form:input id="reportEndTime" path="reportEndTime" class="Wdate bdinput" onfocus="WdatePicker({dateFmt:'yyyy-MM-dd',readOnly:true})"/>-->
					</span>
					&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
					<input type="button" value="Query" onclick="updateQuery();" class="button-normal"></input>
					<input type="button" value="Clear" class="button-normal" onclick="clearValue()"></input>
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
                   <td style="width:10%" class="nowrap">Terminal Code</td>
                   <th width="1%">|</th>
                   <td style="width:10%" class="nowrap">Machine</td>
                   <th width="1%">|</th>
                   <td style="width:10%" class="nowrap">Current Version</td>
                   <th width="1%">|</th>
                   <td style="width:10%" class="nowrap">Last Update Time</td>
                   <th width="1%">|</th>
                   <td style="width:10%" class="nowrap">Last Report Time</td>
                   <th width="1%">|</th>
                   <td style="width:*%" class="nowrap">Download Version</td>
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
