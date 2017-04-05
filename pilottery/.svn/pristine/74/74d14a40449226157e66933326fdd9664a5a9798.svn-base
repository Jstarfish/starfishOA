<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/views/common/taglibs.jsp"%>
<html>
<head>
<title>泰山日志列表</title>
<meta http-equiv="refresh" content="120">
<%@ include file="/views/common/meta.jsp"%>
<link rel="stylesheet" type="text/css" href="${basePath}/css/style.css" />
<link rel="stylesheet" href="${basePath}/component/messageBox/myJsBox.css" type="text/css" />
<script type="text/javascript" src="${basePath}/component/messageBox/myJsBox.js"></script>
<script type="text/javascript" src="${basePath}/component/My97DatePicker/WdatePicker.js"></script>
<script type="text/javascript" src="${basePath}/js/jquery/jquery-1.9.1.js"></script>
<script type="text/javascript" charset="UTF-8">

function addTrace(){
    showBox("trace.do?method=toAddPage","Log Uploading List",250,600);
}

</script>
</head>
<body>
    <div id="title">Log Uploading List</div>
    <div class="queryDiv">
		<form action="trace.do?method=listTrace" id="UploadTraceForm" method="post">
			<%-- <div class="left">
                <span>No.: <input id="seq" name="seq" value="${form.seq}" class="text-normal" maxlength="8"/></span>
                <input type="submit" value="Query" class="button-normal"></input>
            </div> --%>
    <div class="right">
				<table width="260" border="0" cellspacing="0" cellpadding="0">
					<tr style="height: 50px; line-height: 50px">
						<td align="right">
							<input type="button" value="New"
									onclick="addTrace();" class="button-normal">
							</input>
						</td>
					</tr>
				</table>
			</div>
		</form>
	</div>
    
	
    <div id="headDiv">
		<table width="100%" border="0" cellpadding="0" cellspacing="0">
			<tr>
				<td>
					<table class="datatable">
						<tr class="headRow">
							<td style="width:10px;">&nbsp;</td>
							<td style="width: 10%">No.</td>
							<th width="1%">|</th>
							<td style="width: 10%">Date</td>
							<th width="1%">|</th>
							<td style="width: 10%">Terminal Code</td>
							<th width="1%">|</th>
							<td style="width: 10%">Type</td>
							<th width="1%">|</th>
							<td style="width: 10%">Parameter</td>
							<th width="1%">|</th>
							<td style="width: 10%">Status</td>
							<th width="1%">|</th>
							<td style="width: 10%">Completion Time</td>
							<th width="1%">|</th>
							<td style="width: *%">File Name</td>
						</tr>
					</table>
				</td>  
				<td style="width: 17px; background: #2aa1d9"></td>  		
    		</tr>
    	</table>
    	</div>
    	
    	<div id="bodyDiv">
		<table class="datatable">
			<c:forEach var="data" items="${pageDataList}" varStatus="status">
				<tr class="dataRow">
					<td style="width:10px;">&nbsp;</td>
					<td style="width: 10%" title="${data.seq}">${data.seq}</td>
					<td width="1%">&nbsp;</td>
					<td style="width: 10%" title="${data.applyTime}"><fmt:formatDate value="${data.applyTime}"  pattern="yyyy-MM-dd HH:mm:ss"/></td></td>
					<td width="1%">&nbsp;</td>
					<td style="width: 10%" title="${data.terminalCode}">${data.terminalCode}</td>
					<td width="1%">&nbsp;</td>
					<td style="width: 10%" title="${data.applyType}">
						<c:choose>
							<c:when test="${data.applyType == 1}">terminal-gui日志</c:when>
							<c:when test="${data.applyType == 1}">terminal-server日志</c:when>
							<c:when test="${data.applyType == 1}">指定目录文件</c:when>
							<c:otherwise>指定目录</c:otherwise>
						</c:choose>
					</td>
					<td width="1%">&nbsp;</td>
					<td style="width: 10%" title="${data.applyArg1}">${data.applyArg1}</td>
					<td width="1%">&nbsp;</td>
					<td style="width: 10%" title="${data.applyStatus}">
						<c:if test="${data.applyStatus == 1}">待处理</c:if>
						<c:if test="${data.applyStatus == 2}">已完成</c:if>
						
					</td>
					<td width="1%">&nbsp;</td>
					<td style="width: 10%" title="${data.succTime}"><fmt:formatDate value="${data.succTime}"  pattern="yyyy-MM-dd HH:mm:ss"/></td></td>
					<td width="1%">&nbsp;</td>
					<td style="width: *%" title="${data.uploadFile}">${data.uploadFile}</td>
					<td width="1%">&nbsp;</td>
				</tr>
			</c:forEach>
		</table>
		${pageStr}
	</div>
</body>
</html>