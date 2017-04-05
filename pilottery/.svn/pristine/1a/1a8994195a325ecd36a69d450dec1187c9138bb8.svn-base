<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/views/common/taglibs.jsp"%>
<html>
<head>
<title>泰山日志列表</title>
<%@ include file="/views/common/meta.jsp"%>
<link rel="stylesheet" type="text/css" href="${basePath}/css/style.css" />
<link rel="stylesheet" href="${basePath}/component/messageBox/myJsBox.css" type="text/css" />
<script type="text/javascript" src="${basePath}/component/messageBox/myJsBox_zh.js"></script>
<script type="text/javascript" src="${basePath}/component/My97DatePicker/WdatePicker.js"></script>
<script type="text/javascript" src="${basePath}/js/jquery/jquery-1.9.1.js"></script>
<style type="text/css">
#refreshBtn{
    position: relative;
    display: inline-block;
    line-height: 24px;
    color: #fff;
    cursor: pointer;
    border:1px;
    background-color: #90cd00;
    font-size:12px;
    margin-top:12px;
    margin-right:20px;
    float:right;
}
#refreshBtn:hover {
  background-color: #9bdb03;

}

</style>
</head>
<body>
	<div id="title">结算日志</div>
	<div class="queryDiv">
	<form  action="taishanLog.do?method=listLog" method="POST" id="form">
	<div class="left">
	<span>生成时间:
	<input id="startTime" name="logDate" type="text"  value="${form.logDate}" class="Wdate _input" onfocus="WdatePicker({qsEnabled:false,readOnly:true,lang:'zh-cn',isShowOK:true,isShowClear:true,autoPickDate:true})"/>
      </span>
      	<input type="submit" value="查询" class="button-normal"></input>
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
							<td style="width: 12%">日志编号</td>
							<th width="1%">|</th>
							<td style="width: 12%">日志类型</td>
							<th width="1%">|</th>
							<td style="width: 15%">生成时间</td>
							<th width="1%">|</th>
							<td style="width:*%">描述</td>
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
					<td style="width: 12%" title="${data.logId}">${data.logId}</td>
					<td width="1%">&nbsp;</td>
					<td style="width: 12%" title="${data.logType}">
						 <c:choose>
				            <c:when test="${data.logType == 1}">日结</c:when>
         					   <c:otherwise>期结</c:otherwise>
						</c:choose> 
						</td>
					<td width="1%">&nbsp;</td>
					<td style="width: 15%" title="${data.logDate}"><fmt:formatDate value="${data.logDate}"  pattern="yyyy-MM-dd HH:mm:ss"/></td>
					<td width="1%">&nbsp;</td>
					<td style="width: *%" title="${data.logDesc}">${data.logDesc}</td>
					<td width="1%">&nbsp;</td>
				</tr>
			</c:forEach>
		</table>
		${pageStr}
	</div>
</body>
</html>