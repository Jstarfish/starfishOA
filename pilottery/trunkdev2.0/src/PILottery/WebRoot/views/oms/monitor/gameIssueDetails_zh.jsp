<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/views/common/taglibs.jsp"%>
<html>
<head>
<title>期次监控详情 </title>
<%@ include file="/views/common/meta.jsp" %>
<link rel="stylesheet" type="text/css" href="${basePath}/css/style.css"/>
<link rel="stylesheet" type="text/css" href="${basePath}/css/pop-up.css"/>
<link rel="stylesheet" href="${basePath}/component/messageBox/myJsBox.css" type="text/css"/>
<link rel="stylesheet" type="text/css" href="${basePath}/css/validate.css"/>

<script type="text/javascript" src="${basePath}/js/myJs.js"></script>
<script type="text/javascript" src="${basePath}/component/messageBox/myJsBox_zh.js"></script>
<script type="text/javascript" src="${basePath}/component/My97DatePicker/WdatePicker.js"></script>
<script type="text/javascript" src="${basePath}/js/jquery/jquery-1.9.1.js"></script>
<script type="text/javascript" src="${basePath}/js/regexEnum.js"></script>

<style type="text/css">
	table {
		border-color:#f2f1f1;
	}
    #div1 span{
        color:#2aa1d9;
    }
    #div2 ul span{
        color:#2aa1d9;
    }
    #boardDiv table{
	    font-size: 14px;
	}
    #menu div{
        /**height:30px;**/
        line-height:30px;
        background-color:#e4e5e5;
        margin-top:2px;
        padding-left:10px;
    }
    #menu div:hover{
        background-color:#2aa1d9;
    }
    ul{
        padding-left:30px;
        padding-top:10px;
    }
    ul li {
        height:50px;
        line-height:50px;
    }
    .datatable tr:hover, .datatable tr.hilite {
	    background-color: #2aa1d9;
	    color: #ffffff;
	}
</style>

<script type="text/javascript" charset="UTF-8" > 
    function menulink(obj) {
        div1.style.display="none";
        div2.style.display="none";
        div3.style.display="none";

        obj.style.display="block";
    }
</script>

</head>
<body>
<div id="boardDiv" style="background-color:#fff;">
	<table width="100%" height="100%" border="1" cellspacing="0" cellpadding="0">
	    <tr>
	        <td width="20%">
	            <div id="menu" style="height:100%;">
	                <div onclick="menulink(div1)">交易类数据</div>
	                <div onclick="menulink(div2)">开奖数据</div>
	                <div onclick="menulink(div3)">销售站高等中奖数据</div>
	            </div>
	        </td>
	        <td width="*%">
	           <div id="div1" style="height:100%;">
	               <ul>
	                   <li>销售金额(瑞尔) :<span id="issueSaleAmount">&nbsp;&nbsp;<fmt:formatNumber value="${gameIssue.issueSaleAmount}" pattern="#,###"/></span></li>
	                   <li>销售票数 (张) :<span id="issueSaleTickets">&nbsp;&nbsp;${gameIssue.issueSaleTickets}</span></li>
	                   <li>退票金额(瑞尔) :<span id="issueCancelAmount">&nbsp;&nbsp;<fmt:formatNumber value="${gameIssue.issueCancelAmount}" pattern="#,###"/></span></li>
	                   <li>退票票数(张) :<span id="issueCancelTickets">&nbsp;&nbsp;${gameIssue.issueCancelTickets}</span></li>
	                   <li>是否启用风险控制 :<span id="isOpenRisk">&nbsp;&nbsp;
	                   	<c:if test="${gameIssue.isOpenRisk == 1}">是</c:if>
	                   	<c:if test="${gameIssue.isOpenRisk == 0}">否</c:if></span></li>
	                   <li>风险控制拒绝金额(瑞尔) :<span id="issueRickAmount">&nbsp;&nbsp;<fmt:formatNumber value="${gameIssue.issueRickAmount}" pattern="#,###"/></span></li>
	                   <li>风险控制拒绝次数(次) :<span id="issueRickTickets">&nbsp;&nbsp;${gameIssue.issueRickTickets}</span></li>
	               </ul>
	            </div>

	            <div id="div2" style="height:100%;display:none">
					<ul>
	                   <li>净销售额(瑞尔) :&nbsp;&nbsp;<fmt:formatNumber value="${gameIssue.issueSaleAmount}" pattern="#,###"/></span></li>
	                   <li>期初奖池金额(瑞尔) :<span id="poolStartAmount">&nbsp;&nbsp;<fmt:formatNumber value="${gameIssue.poolStartAmount}" pattern="#,###"/></span></li>
	                   <li>录入人1 :<span id="firstDrawUser">&nbsp;&nbsp;${gameIssue.firstUserName}</span></li>
	                   <li>录入人2 :<span id="secondDrawUser">&nbsp;&nbsp;${gameIssue.secondUserName}</span></li>
	                   <li>期末奖池余额(瑞尔) :<span id="poolCloseAmount">&nbsp;&nbsp;<fmt:formatNumber value="${gameIssue.poolCloseAmount}" pattern="#,###"/></span></li>
	                   <li>开奖号码 :<span id="winningResult">&nbsp;&nbsp;${gameIssue.finalDrawNumber}</span></li>
	               </ul>
	               
	        <!-- 高等级数据 -->
			<table style="width:100%" class="datatable">
				<tr>
					<th width="1px">&nbsp;</th>
					<th width="30%">奖级</th>
					<th width="2%">|</th>
					<th width="30%">奖金(瑞尔)</th>
					<th width="2%">|</th>
					<th width="30%">注数</th>
				</tr>
					<c:forEach var="item" items="${issuePrizelist}">
				            <tr class="dataRow">
				            	<td width="1px">&nbsp;</td>
				            	<td width="30%">${item.prize_name}</td>
				                <td width="2%">&nbsp;</td>
				                <td width="30%"><fmt:formatNumber value="${item.prize_amount}" pattern="#,###"/></td>
				                <td width="2%">&nbsp;</td>
				                <td width="30%">${item.prize_num}</td>
				            </tr>
				        </c:forEach>
				        </table>
				</div>
	              
	            <!-- 销售站高等中奖数据 -->
	            <div id="div3" style="height:100%;display:none">
					<table id="dataRows" class="datatable">
			            <tr class="headRow">
			            	<td style="width:10px;">&nbsp;</td>
			                <td style="width:15%">奖级名称</td>
			                <th width="1%">|</th>
			                <td style="width:15%">中奖注数</td>
			                <th width="1%">|</th>
			                <td style="width:15%">销售站编码</td>
			                <th width="1%">|</th>
			                <td style="width:15%">销售站名称</td>
			                <th width="1%">|</th>
			                <td style="width:15%">销售站地址</td>
			                <th width="1%">|</th>
			                <td style="width:*%">销售站中奖注数</td>
			            </tr>
				          <c:forEach var="item" items="${hightPrizeList}"> 
				            <tr class="dataRow">
				            	<td style="width:10px;">&nbsp;</td>
				                <td>${item.prize_name}</td>
				                <td width="1%">&nbsp;</td>
				                <td>${item.count}</td>
				                <td width="1%">&nbsp;</td>
				                <td title="${item.agency_code}">${item.agency_code}</td>
				                <td width="1%">&nbsp;</td>
				                <td title="${item.agency_name}">${item.agency_name}</td>
				                <td width="1%">&nbsp;</td>
				                <td title="${item.agency_addr}">${item.agency_addr}</td>
				                <td width="1%">&nbsp;</td>
				                <td>${item.total_win}</td>
				            </tr>
				        </c:forEach>  
		        	</table>
                </div>
	        </td>
	    </tr>
	</table>
 </div>
</body>
</html>