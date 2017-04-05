<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/views/common/taglibs.jsp"%>
<html>
<head>
<title>Issue Details Monitor</title>
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
	                <div onclick="menulink(div1)">Transaction Data</div>
	                <div onclick="menulink(div2)">Drawing Data</div>
	                <div onclick="menulink(div3)">High-Level Prize Winning Data</div>
	            </div>
	        </td>
	        <td width="*%">
	           <div id="div1" style="height:100%;">
	               <ul>
	                   <li>Total Sales Amount (Riels):<span id="issueSaleAmount">&nbsp;&nbsp;<fmt:formatNumber value="${gameIssue.issueSaleAmount}" pattern="#,###"/></span></li>
	                   <li>Tickets Sold:<span id="issueSaleTickets">&nbsp;&nbsp;${gameIssue.issueSaleTickets}</span></li>
	                   <li>Refund Amount (Riels):<span id="issueCancelAmount">&nbsp;&nbsp;<fmt:formatNumber value="${gameIssue.issueCancelAmount}" pattern="#,###"/></span></li>
	                   <li>Tickets Refunded:<span id="issueCancelTickets">&nbsp;&nbsp;${gameIssue.issueCancelTickets}</span></li>
	                   <li>Risk-Control Enabled:<span id="isOpenRisk">&nbsp;&nbsp;
	                   	<c:if test="${gameIssue.isOpenRisk == 1}">Yes</c:if>
	                   	<c:if test="${gameIssue.isOpenRisk == 0}">No</c:if></span></li>
	                   <li>Rejected Amount (Riels):<span id="issueRickAmount">&nbsp;&nbsp;<fmt:formatNumber value="${gameIssue.issueRickAmount}" pattern="#,###"/></span></li>
	                   <li>Tickets Rejected:<span id="issueRickTickets">&nbsp;&nbsp;${gameIssue.issueRickTickets}</span></li>
	               </ul>
	            </div>

	            <div id="div2" style="height:100%;display:none">
					<ul>
	                   <li>Sales Amount (Riels):&nbsp;&nbsp;<fmt:formatNumber value="${gameIssue.issueSaleAmount}" pattern="#,###"/></span></li>
	                   <li>Initial Pool (Riels):<span id="poolStartAmount">&nbsp;&nbsp;<fmt:formatNumber value="${gameIssue.poolStartAmount}" pattern="#,###"/></span></li>
	                   <li>Entry Clerk 1:<span id="firstDrawUser">&nbsp;&nbsp;${gameIssue.firstDrawUser}</span></li>
	                   <li>Entry Clerk 2:<span id="secondDrawUser">&nbsp;&nbsp;${gameIssue.secondDrawUser}</span></li>
	                   <li>Final Pool (Riels):<span id="poolCloseAmount">&nbsp;&nbsp;<fmt:formatNumber value="${gameIssue.poolCloseAmount}" pattern="#,###"/></span></li>
	                   <li>Draw Numbers:<span id="winningResult">&nbsp;&nbsp;${gameIssue.finalDrawNumber}</span></li>
	               </ul>
	               
	        <!-- 高等级数据 -->
			<table style="width:100%" class="datatable">
				<tr>
					<th width="1px">&nbsp;</th>
					<th width="30%">Prize Level</th>
					<th width="2%">|</th>
					<th width="30%">Award (Riels)</th>
					<th width="2%">|</th>
					<th width="30%">Winning Bets</th>
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
			                <td style="width:15%" title="Prize Level Name">Prize Level Name</td>
			                <th width="1%">|</th>
			                <td style="width:15%" title="Winning Bets">Winning Bets</td>
			                <th width="1%">|</th>
			                <td style="width:15%" title="Outlet Code">Outlet Code</td>
			                <th width="1%">|</th>
			                <td style="width:15%" title="Outlet Name">Outlet Name</td>
			                <th width="1%">|</th>
			                <td style="width:15%" title="Outlet Address">Outlet Address</td>
			                <th width="1%">|</th>
			                <td style="width:*%" title="Winning Bets in Outlet">Winning Bets in Outlet</td>
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