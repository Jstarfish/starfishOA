<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8"%>
<%@ include file="/views/common/taglibs.jsp"%>
<html>
<head>

<title>List of Account Balance</title>

<%@ include file="/views/common/meta.jsp"%>
<link rel="stylesheet" type="text/css" href="${basePath}/css/style.css" />
<link rel="stylesheet" href="${basePath}/component/messageBox/myJsBox.css" type="text/css" />
<script type="text/javascript" src="${basePath}/component/messageBox/myJsBox.js"></script>
<script type="text/javascript" src="${basePath}/component/My97DatePicker/WdatePicker.js"></script>
<script type="text/javascript" src="${basePath}/js/jquery/jquery-1.9.1.js"></script>
</head>
 <body>
 <div id="title">Account Balance</div>
	<div id="headDiv">
		<table width="100%" border="0" cellpadding="0" cellspacing="0">
            <tr>
                <td>
                    <table class="datatable">
                        <tr class="headRow">
                        	<td style="width:10px;">&nbsp;</td>
							<td style="width: 15%">Account Balance(riels)</td>
							<th width="1%">|</th>
							<td style="width: 15%">Credit Limit(riels)</td>
							<th width="1%">|</th>
							<td style="width: 15%">Current Debt(riels)</td>
							<th width="1%">|</th>
							<td style="width: 15%">Latest Date of Top Up</td>
							<th width="1%">|</th>
							<td style="width: 15%">Top Up Amount(riels)</td>
						</tr>
					</table>
					 </td>
                 <td style="width:17px;background:#2aa1d9"></td>
             </tr>
        </table>
    </div>
		
	<div id="bodyDiv" style="top:76px;">
        <table class="datatable">
				<tr class="dataRow">
					<td style="width:10px;">&nbsp;</td>
					
					<td style="width: 15%;text-align: right"><fmt:formatNumber value="${balance.accountBalance}" /></td>
					<td width="1%">&nbsp;</td>
					<td style="width: 15%;text-align: right"><fmt:formatNumber value="${balance.creditLimit}" /></td>
					<td width="1%">&nbsp;</td>
					<td style="width: 15%;text-align: right">
						 <c:if test="${balance.accountBalance >= 0}">
 							0
 						</c:if>
						<c:if test="${balance.accountBalance <= 0}">
						<fmt:formatNumber value="${-balance.accountBalance}" />
						</c:if> 
					</td> 
					<td width="1%">&nbsp;</td>
					<td style="width: 15%" ><fmt:formatDate value="${balance.applyDate}" pattern="yyyy-MM-dd HH:mm:ss"/></td>
					<td width="1%">&nbsp;</td>
					<td style="width: 15%;text-align: right"><fmt:formatNumber value="${balance.applyAmount}" /></td>
					<td width="1%">&nbsp;</td>
				</tr>
			</tbody>
		</table>
	</div>
</body>
</html>