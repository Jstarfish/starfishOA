<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8"%>
<%@ include file="/views/common/taglibs.jsp"%>
<html>
<head>
<meta http-equiv="refresh" content="120">
<title>事件控制台</title>
<%@ include file="/views/common/meta.jsp"%>
<link rel="stylesheet" type="text/css" href="${basePath}/css/style.css" />
<link rel="stylesheet" href="${basePath}/component/messageBox/myJsBox.css" type="text/css" />
<script type="text/javascript" src="${basePath}/component/messageBox/myJsBox.js"></script>
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
	<!-- 充值查询 -->
	<div id="title">Events Monitor</div>
	 <div class="queryDiv">
		<form action="event.do?method=listEvents" id="form"
			method="post">
			<div class="left">
            	<span>Level:
            		<select id="eventLevel" name="eventLevel" class="select-normal">
						<option value="">--All--</option>
						<option value="1" <c:if test="${form.eventLevel==1}">selected</c:if>>info</option>
						<option value="2" <c:if test="${form.eventLevel==2}">selected</c:if>>warn</option>
						<option value="3" <c:if test="${form.eventLevel==3}">selected</c:if>>error</option>
						<option value="4" <c:if test="${form.eventLevel==4}">selected</c:if>>fetal</option>
					</select>
                </span>
                <span>Time:
                     <input name="beginDate" value="${form.beginDate }" class="Wdate text-normal" onfocus="WdatePicker({lang:'zh-cn',dateFmt:'yyyy-MM-dd',readOnly:true})"/> 
                    	-
                    <input name="endDate" value="${form.endDate }" class="Wdate text-normal" onfocus="WdatePicker({lang:'zh-cn',dateFmt:'yyyy-MM-dd',readOnly:true})"/>
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
							<td style="width: 12%">Time</td>
							<th width="1%">|</th>
							<td style="width: 12%">Level</td>
							<th width="1%">|</th>
							<td style="width: 12%">Event Type</td>
							<th width="1%">|</th>
							<td style="width: 15%">IP Address</td>
							<th width="1%">|</th>
							<td style="width:*%">Event Description</td>
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
					<td style="width:10px;">&nbsp;</td>
					<td style="width: 12%" title="${data.eventTime}"><fmt:formatDate value="${data.eventTime}"  pattern="yyyy-MM-dd HH:mm:ss"/></td>
					<td style="width: 12%" title="${data.eventLevel}">
						 <c:choose>
				            <c:when test="${data.eventLevel == 1}">dataRow info</c:when>
				            <c:when test="${data.eventLevel == 2}">dataRow warn</c:when>
				            <c:when test="${data.eventLevel == 3}">dataRow error</c:when>
         					   <c:otherwise>dataRow fetal</c:otherwise>
						</c:choose> 
					</td>
					<td width="1%">&nbsp;</td>
					<td style="width: 12%" title="${data.eventType}">${data.eventType}</td>
					<td width="1%">&nbsp;</td>
					<td style="width: 15%" title="${data.serverAddr}">${data.serverAddr}</td>
					<td width="1%">&nbsp;</td>
					<td style="width: *%; title="${data.eventContent}">${data.eventContent}</td>
					<td width="1%">&nbsp;</td>
				</tr>
			</c:forEach>
		</table>
		${pageStr}
	</div>
</body>
</html>