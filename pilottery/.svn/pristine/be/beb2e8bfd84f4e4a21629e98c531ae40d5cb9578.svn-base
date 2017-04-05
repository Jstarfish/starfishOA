<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/views/common/taglibs.jsp"%>
<html>
<head>
<title>期次监控列表</title>
<meta http-equiv="refresh" content="120">
<%@ include file="/views/common/meta.jsp" %>
<%@ include file="/views/oms/monitor/js/comm_function.jsp"%>


<link rel="stylesheet" type="text/css" href="${basePath}/css/style.css" />
<link rel="stylesheet" type="text/css" href="${basePath}/component/messageBox/myJsBox.css" />

<script type="text/javascript" src="${basePath}/js/jquery/jquery-1.9.1.js"></script> 
<script type="text/javascript" src="${basePath}/component/messageBox/myJsBox.js"></script> 
<script type="text/javascript" src="${basePath}/js/oms/myJs.js"></script>
<script type="text/javascript" src="${basePath}/views/oms/monitor/js/thead.js"></script> 
<script type="text/javascript" src="${basePath}/views/oms/monitor/js/regexEnum.js"></script> 
<script type="text/javascript" src="${basePath}/views/oms/monitor/js/myJs.js"></script> 

<script type="text/javascript" charset="UTF-8" >
     
	   // 详情弹出框
	function showDetails(url) {
	    showBox(url,"期次监控详情",600,900);
	};
	
	
	 function conditionQuery() {
	    $("#queryForm").submit();
	}; 
 
</script>
</head>
<body>
	 <div id="title">期次监控列表</div>
	 <div class="queryDiv">
    <form action="gameIssue.do?method=listGameIssue" method="POST" id="queryForm">
		<div class="left">        
            <span>游戏： 
                <select id="gameCode" name="gameCode" class="select-normal">
                    <c:forEach var="item" items="${gameList}" varStatus="status">
                            <option value="${item.gameCode}" <c:if test="${item.gameCode==queryInfo.gameCode}">selected="selected"</c:if>>${item.shortName}</option>
                    </c:forEach>
                </select>
            </span>
            <input type="button" value="查询" class="button-normal" onclick="conditionQuery();"></input>
        </div>
    </form>
    </div>
    
    <div id="headDiv">
    <table width="100%"  border="0" cellpadding="0" cellspacing="0">
       <tr><td>
            <table class="datatable">
            	<tr class="headRow">
            	  <td style="width:10px;">&nbsp;</td>
	              <td width="10%">游戏期号 </td>
	              <td width="1%">|</td>
	              <td  width="10%">期次状态 </td>
	              <td width="1%">|</td>
	              <td  width="10%">开始时间 </td>
	              <td width="1%">|</td>
	              <td  width="10%">结束时间 </td>
	              <td width="1%">|</td>
	              <td  width="10%">开奖时间 </td>
	              <td width="1%">|</td>
	              <td  width="10%">销售金额 </td>
	              <td width="1%">|</td>
	              <td  width="10%">开奖号码 </td>
	              <td width="1%">|</td>
	              <td width="10%">中奖金额 </td>
	              <td width="1%">|</td>
	              <td style="width:*%">操作 </td>
          </tr>
			</table>
		</td><td style="width:17px;background:#2aa1d9"></td></tr>
    </table>
</div>

        <div id="bodyDiv">
	<table class="datatable" id="dataRows">
    	<c:forEach var="data" items="${pageDataList}" varStatus="status" >
        <tr class="dataRow">
        	<td style="width:10px;">&nbsp;</td>
				<td width="10%">${data.issueNumber}</td>
				<td width="1%">&nbsp;</td>
				<td width="10%">
					<c:choose>
						<c:when test="${data.issueStatus == 1}">预售</c:when>
						<c:when test="${data.issueStatus == 2}">游戏期开始</c:when>
						<c:when test="${data.issueStatus == 3}">期即将关闭</c:when>
						<c:when test="${data.issueStatus == 4}">游戏期关闭</c:when>
						<c:when test="${data.issueStatus == 5}">数据封存完毕</c:when>
						<c:when test="${data.issueStatus == 6}">开奖号码已录入</c:when>
						<c:when test="${data.issueStatus == 7}">销售已经匹配</c:when>
						<c:when test="${data.issueStatus == 8}">已录入奖级奖金</c:when>
						<c:when test="${data.issueStatus == 9}">本地算奖完成</c:when>
						<c:when test="${data.issueStatus == 10}">奖级已确认</c:when>
						<c:when test="${data.issueStatus == 11}">开奖确认</c:when>
						<c:when test="${data.issueStatus == 12}">中奖数据已录入数据库</c:when>
						<c:when test="${data.issueStatus == 13}">期结全部完成</c:when>
					</c:choose>
				</td>
				<td width="1%">&nbsp;</td>
				<td width="10%" title="${data.realStartTime}">${data.realStartTime}</td>
				<td width="1%">&nbsp;</td>
				<td width="10%">${data.realCloseTime}</td>
				<td width="1%">&nbsp;</td>
				<td width="10%">${data.realRewardTime}</td>
				<td width="1%">&nbsp;</td>
				<td style="width: 10%; text-align:right"><fmt:formatNumber value="${data.issueSaleAmount}" /></td>
				<td width="1%">&nbsp;</td>
				<td width="10%" title="${data.winningResult}">${data.winningResult}</td>
				<td width="1%">&nbsp;</td>
				<td style="width: 10%; text-align:right"><fmt:formatNumber value="${data.winningAmount}" /></td>
				<td width="1%">&nbsp;</td>
				<td width="*%" class="xqzi">
					<span><a href="#" id="issueOperate" onclick="showDetails('gameIssue.do?method=details&issueNumber=${data.issueNumber}&gameCode=${data.gameCode}')">详情</a></span>
				</td>
			</tr>
		</c:forEach>
		</table>
        <div>${pageStr }</div>
	</div>
</body>
</html>