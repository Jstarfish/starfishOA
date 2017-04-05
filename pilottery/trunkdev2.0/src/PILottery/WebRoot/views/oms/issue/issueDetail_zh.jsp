<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/views/common/taglibs.jsp"%>
<html>
<head>
<title> </title>
<link rel="stylesheet" type="text/css" href="${basePath}/css/style.css" />
<link rel="stylesheet" type="text/css" href="${basePath}/css/pop-up.css" />
<link rel="stylesheet" type="text/css" href="${basePath}/css/validate.css" />
<style type="text/css">
#tck{
	margin:0;
	padding:0;
	font-family:"microsoft yahei", "微软雅黑";
	background:#fff;
	font-size:12px;
	color:#333333;}
.title{
	background:#e4e5e5 ;
	height:50px;
	line-height:50px;
	border-bottom:1px solid #b2b2b2;
	padding:0 20px;
	font-size:14px;
	}
.float-left{
	float:left;
	font-size:16px;}

.float-right{
	width:22px;
	height:20px;
	position:absolute; 
	top:20px; 
	right:20px; 
	z-index:101;}
.float-right a{
	display:block;   
	overflow:hidden;
	width:22px;
	height:20px;
	background:url(../images/tck-close.png) no-repeat top right;}
.float-right a:hover{
	background-position:0px -20px}
#nr{
	margin-top:30px;
	padding:0 20px;}
#nr .title-mbx{
	margin-bottom:10px;
	font-size:16px;}
#nr .border{
	border-radius:4px;
	border:1px solid #e4e5e5;
	padding:20px;
	line-height:30px;}
#nr table{
    font-size:14px;
    line-height:25px;}
.datatable tr:hover, .datatable tr.hilite {
	    background-color: #2aa1d9;
	    color: #ffffff;
	}
</style>
</head>
<body>
	<div id="nr">
		<div class="title-mbx">交易信息</div>
		<div class="border">
			<table width="100%" border="0" cellspacing="0" cellpadding="0">
				<tr>
					<td width="33%">销售金额:<fmt:formatNumber type="number" value="${gameIssue.issueSaleAmount+gameIssue.issueCancelAmount}" /> </td>
					<td width="27%">销售张数:<fmt:formatNumber type="number" value="${gameIssue.issueSaleTickets+gameIssue.issueCancelTickets}" /> </td>
					<td width="40%">退票总额:<fmt:formatNumber type="number" value="${gameIssue.issueCancelAmount}" /> </td>
				</tr>
				<tr>
					<td>退票张数 : <fmt:formatNumber type="number" value="${gameIssue.issueCancelTickets}" /></td>
					<td>风控限制金额 : <fmt:formatNumber type="number" value="${gameIssue.issueRickAmount}" /></td>
					<td>风控限制票数:<fmt:formatNumber type="number" value="${gameIssue.issueRickTickets}" /></td>
				</tr>
			</table>
		</div>
	</div>
	<div id="nr">
		<div class="title-mbx">开奖信息</div>
		<div class="border">
			<table width="100%" border="0" cellspacing="0" cellpadding="0">
				<tr>
					<td width="33%">净销售额:<fmt:formatNumber type="number" value="${gameIssue.issueSaleAmount}" /> </td>
					<td width="27%">开奖号码:${gameIssue.finalDrawNumber} </td>
					<td width="40%">期初奖池:<fmt:formatNumber type="number" value="${gameIssue.poolStartAmount}" /> </td>
				</tr>
				<tr>
					<td>期末奖池 : <fmt:formatNumber type="number" value="${gameIssue.poolCloseAmount}" /></td>
					<td>录入人1: ${gameIssue.firstDrawUserName}</td>
					<td>录入人2:${gameIssue.secondDrawUserName}</td>
				</tr>
			</table>
		</div>
	</div>
	<div id="nr">
		<div class="title-mbx">奖级列表</div>
		<div>
		<c:if test="${drawNoticeSize == 0}">
	  		<table border="0" cellspacing="0" cellpadding="0" style="font-size:14px;table-layout:fixed;height: 100px;"><tr><td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;无数据</td></tr></table>
        </c:if>	
        <c:if test="${drawNoticeSize > 0}">
        	<table class="datatable" width="95%" border="0" cellspacing="0" cellpadding="5" style="font-size:14px;table-layout:fixed">
			    <tr class="headRow">
			       <td align="center">奖等</td>
			       <td align="center">中奖注数</td>
			       <td align="center">中奖金额</td>
			    </tr>
			<c:forEach items="${drawNotice.lotteryDetails}" var="i">
			    <tr class="dataRow">
			        <td align="center">${i.prizeLevel}</td>
			        <td align="center">${i.betCount}</td>
			        <td align="right"><fmt:formatNumber type="number" value="${i.awardAmount}" /></td>
			    </tr>
			</c:forEach>
			</table>
		  </c:if>
		</div>
	</div>
	<div id="nr">
		<div class="title-mbx">中奖信息</div>
		<div>
			<c:if test="${drawInfoSize == 0}">
			  	<table border="0" cellspacing="0" cellpadding="0"style="font-size:14px;table-layout:fixed;height: 100px;"><tr><td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;无数据</td></tr></table>
	          </c:if>	
			  <c:if test="${drawInfoSize > 0}">
	        	<table class="datatable" width="95%" border="0" cellspacing="0" cellpadding="5" style="font-size:14px;table-layout:fixed">
		        	<tr class="headRow">
			        	<td width="20%" align="center">销售站编码</td>
			        	<td width="20%" align="center">销售站名称</td>
			        	<td width="20%" align="center">所属机构</td>
			        	<td width="20%" align="center">奖等名称</td>
			        	<td width="20%" align="center">注数</td>
		        	</tr>
	        		<c:forEach items="${drawInfo}" var="s">
		        	<tr class="dataRow">
			        	<td align="center">${s.agencyCode}</td>
			        	<td align="center">${s.agencyName}</td>
			        	<td align="center">${s.areaName}</td>
			        	<td align="center">${s.prizeName}</td>
			        	<td align="center">${s.winningCount}</td>
		        	</tr>
		        	</c:forEach>
	        	</table>
	          </c:if>
		</div>
	</div>
	<div style="height: 30px;"/>
</div>
</body>
</html>
