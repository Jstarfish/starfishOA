<%@page import="java.util.Map"%>
<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8"%>
<%@ include file="/views/common/taglibs.jsp"%>
<html>
<head>
<title>账户余额</title>
<%@ include file="/views/common/meta.jsp"%>
<link rel="stylesheet" type="text/css" href="${basePath}/css/style.css" />
<link rel="stylesheet" href="${basePath}/component/messageBox/myJsBox.css" type="text/css" />
<script type="text/javascript" src="${basePath}/component/messageBox/myJsBox_zh.js"></script>
<script type="text/javascript" src="${basePath}/component/My97DatePicker/WdatePicker.js"></script>
<script type="text/javascript" src="${basePath}/js/jquery/jquery-1.9.1.js"></script>
</head>
 <body>
 <div id="title">账户余额</div>
	<div id="headDiv">
		<table width="100%" border="0" cellpadding="0" cellspacing="0">
            <tr>
                <td>
                    <table class="datatable">
                        <tr class="headRow">
                        <td style="width:10px;">&nbsp;</td>
						<td style="width: 15%">账户余额(瑞尔)</td>
						<th width="1%">|</th>
						<td style="width: 15%">信用额度(瑞尔)</td>
						<th width="1%">|</th>
						<td style="width: 15%">佘票金额(瑞尔)</td>
						<th width="1%">|</th>
						<td style="width: 15%">当前欠款金额(瑞尔)</td>
						<th width="1%">|</th>
						<td style="width: 15%">最近还款时间</td>
						<th width="1%">|</th>
						<td style="width: 15%">最近还款金额(瑞尔)</td>
				</tr>
		</table>
		</td>
		<td style="width:17px;background:#2aa1d9"></td>
             </tr>
        </table>
    </div>
	
	<!-- 列表内容块 -->
	<div id="bodyDiv" style="top:76px;">
        <table class="datatable">
				<tr class="dataRow">
					<td style="width:10px;">&nbsp;</td>
					<td style="width: 15%;text-align: right"><fmt:formatNumber value="${balance.accountBalance}" /></td>
					<td width="1%">&nbsp;</td>
					<td style="width: 15%;text-align: right" ><fmt:formatNumber value="${balance.creditLimit}" /></td>
					<td width="1%">&nbsp;</td>
					<td style="width: 15%;text-align: right"><fmt:formatNumber value="${balance.maxAmountTickets}" /></td>
					<td width="1%">&nbsp;</td>
					<td style="width: 15%;text-align: right" >
					
 						<c:if test="${balance.accountBalance >= 0}">
 							0
 						</c:if>
						<c:if test="${balance.accountBalance < 0}">
							<fmt:formatNumber value="${-balance.accountBalance}" />
						</c:if>
						 <%-- ${balance.accountBalance < 0 ? -balance.accountBalance : 0}  --%>
					</td> 
					<td width="1%">&nbsp;</td>
					<td style="width: 15%" ><fmt:formatDate value="${balance.repayTime}" pattern="yyyy-MM-dd HH:mm:ss"/></td>
					<td width="1%">&nbsp;</td>
					<td style="width: 15%;text-align: right"><fmt:formatNumber value="${balance.repayAmount}" /></td>
				</tr>
			</tbody>
		</table>
	</div>
	</div>
</body>

</html>