<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/views/common/taglibs.jsp"%>
<html><body>
<div id="gameParameter">
    <div class="bg">
	<table width="100%" border="0" cellspacing="0" cellpadding="0">
	    <tr>
		<td class="title1">
		    <table width="100%" border="0" cellspacing="0" cellpadding="0" style="color:#fff;font-size:18px;">
			<tr>
			    <td width="51%">Warning Limit</td>
			    <td width="37%" align="right"><a href="#" onclick="editGameParameter(${gameManagementForm.gameParameterDynamic.gameCode},2);" onmouseout="MM_swapImgRestore()" onmouseover="MM_swapImage('Image7','','${basePath}/img/edit-hover.png',1)"><img src="${basePath}/img/edit.png" width="32" height="42" id="Image7" title="Edit" /></a></td>
			</tr>
		    </table>
		</td>
	    </tr>
	    <tr>
		<td class="nr" style="height:200px">
		    <table width="100%" border="0" cellspacing="0" cellpadding="0" style="font-size:14px; color:#5e6d81; line-height:30px;">			
			
			<tr>
				<td>Ticket Sales Limit：<fmt:formatNumber type="number" value="${gameManagementForm.gameParameterDynamic.auditSingleTicketSale}" /> KHR</td>
			</tr>
			<tr>
				<td>Ticket Payout Limit：<fmt:formatNumber type="number" value="${gameManagementForm.gameParameterDynamic.auditSingleTicketPay}" /> KHR</td>
			</tr>
			<tr>
				<td>Ticket Refund Limit：<fmt:formatNumber type="number" value="${gameManagementForm.gameParameterDynamic.auditSingleTicketCancel}" /> KHR</td>
			</tr>
		    </table>
		</td>
	   </tr>
       </table>
    </div>
</div>
</body></html>