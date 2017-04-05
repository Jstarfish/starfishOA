<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/views/common/taglibs.jsp"%>
<html>
<head>
<title>List of Game Issues</title>
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
	$(function() {    
	    //定时请求刷新  
	    setInterval(doSubmit,120*1000);   
	});  
	function doSubmit(){
		$('#queryForm').submit();
	}
	   // 详情弹出框
	function showDetails(url) {
	    showBox(url,"Issue Details",700,900);
	};
 
</script>
</head>
<body>
	 <div id="title">List of Game Issues</div>
	 <div class="queryDiv">
    <form action="gameIssue.do?method=listGameIssue" method="POST" id="queryForm">
		<div class="left">        
            <span>Game: 
                <select id="gameCode" name="gameCode" class="select-normal">
                    <c:forEach var="item" items="${gameList}" varStatus="status">
                            <option value="${item.gameCode}" <c:if test="${item.gameCode==queryInfo.gameCode}">selected="selected"</c:if>>${item.shortName}</option>
                    </c:forEach>
                </select>
            </span>
            <input type="button" value="Query" class="button-normal" onclick="doSubmit();"></input>
        </div>
    </form>
    </div>
    
    <div id="headDiv">
    <table width="100%"  border="0" cellpadding="0" cellspacing="0">
       <tr><td>
            <table class="datatable">
            	<tr class="headRow">
            	  <td style="width:10px;">&nbsp;</td>
	              <td width="10%">Issue </td>
	              <td width="1%">|</td>
	              <td  width="10%">Status </td>
	              <td width="1%">|</td>
	              <td  width="10%">Open Time </td>
	              <td width="1%">|</td>
	              <td  width="10%">Close Time </td>
	              <td width="1%">|</td>
	              <td  width="10%">Draw Time </td>
	              <td width="1%">|</td>
	              <td  width="10%">Sales Amount </td>
	              <td width="1%">|</td>
	              <td  width="10%">Draw Numbers </td>
	              <td width="1%">|</td>
	              <td width="10%">Prize Won </td>
	              <td width="1%">|</td>
	              <td style="width:*%">Operation </td>
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
						<c:when test="${data.issueStatus == 1}">Presale</c:when>
						<c:when test="${data.issueStatus == 2}">Opened</c:when>
						<c:when test="${data.issueStatus == 3}">Closing</c:when>
						<c:when test="${data.issueStatus == 4}">Closed</c:when>
						<c:when test="${data.issueStatus == 5}">Sealed</c:when>
						<c:when test="${data.issueStatus == 6}">Drawing</c:when>
						<c:when test="${data.issueStatus == 7}">Drawing</c:when>
						<c:when test="${data.issueStatus == 8}">Drawing</c:when>
						<c:when test="${data.issueStatus == 9}">Drawing</c:when>
						<c:when test="${data.issueStatus == 10}">Drawing</c:when>
						<c:when test="${data.issueStatus == 11}">Drawing</c:when>
						<c:when test="${data.issueStatus == 12}">Drawing</c:when>
						<c:when test="${data.issueStatus == 13}">Ended</c:when>
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
				<td width="10%" title="${data.finalDrawNumber}">${data.finalDrawNumber}</td>
				<td width="1%">&nbsp;</td>
				<td style="width: 10%; text-align:right"><fmt:formatNumber value="${data.winningAmount}" /></td>
				<td width="1%">&nbsp;</td>
				<td width="*%" class="xqzi">
					<span><a href="#" id="issueOperate" onclick="showDetails('gameIssue.do?method=details&issueNumber=${data.issueNumber}&gameCode=${data.gameCode}')">Details</a></span>
				</td>
			</tr>
		</c:forEach>
		</table>
        <div>${pageStr }</div>
	</div>
</body>
</html>