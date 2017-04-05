<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/views/common/taglibs.jsp"%>
<html><body>
  <div class="bg">
	<table width="100%" border="0" cellspacing="0" cellpadding="0">
	    <tr>
		<td class="title4">
		    <table width="100%" border="0" cellspacing="0" cellpadding="0" style="color:#fff;font-size:18px;">
			<tr>
			    <td width="51%">Control Parameters</td>
			    <td width="37%" align="right"><a href="#" onclick="editGameControlParameter(${gameManagementForm.controlParameter.gameCode});" onmouseout="MM_swapImgRestore()" onmouseover="MM_swapImage('Image17','','${basePath}/img/edit-hover.png',1)"><img src="${basePath}/img/edit.png" width="32" height="42" id="Image17" title="Edit" /></a></td>
			</tr>
		    </table>
		</td>
	    </tr>
	    <tr>
		<td class="nr">
		  <div style="height:210px; overflow:auto;">
		    <table width="100%" border="0" cellspacing="0" cellpadding="0" style="font-size:14px;color:#5e6d81;  line-height:30px;"> 
			<tr>
				<td>Big-Prize Amount：<fmt:formatNumber type="number" value="${gameManagementForm.controlParameter.limitBigPrize}" /> KHR</td>
			</tr>
			<tr>
				<td>Payout Limit：<fmt:formatNumber type="number" value="${gameManagementForm.controlParameter.limitPayment}" /> KHR</td>
			</tr>
			<tr>
				<td>Allowable Refund Time：${gameManagementForm.controlParameter.cancelSec} Sec</td>
			</tr>
			<tr>
				<td>Sales Countdown：${gameManagementForm.controlParameter.issueCloseAlertTime} Sec</td>
			</tr>
			<!-- 
			<tr>
				<td>Common Teller Payout Limit：<fmt:formatNumber type="number" value="${gameManagementForm.controlParameter.salerPayLimit}" /> KHR</td>
			</tr>
			<tr>
				<td>Common Teller Refund Limit：<fmt:formatNumber type="number" value="${gameManagementForm.controlParameter.salerCancelLimit}" /> KHR</td>
			</tr>
			<tr>
				<td>1st-Level Region Payout Limit：<fmt:formatNumber type="number" value="${gameManagementForm.controlParameter.limitPayment2}" /> KHR</td>
			</tr>
			<tr>
				<td>1st-Level Region Refund Limit：<fmt:formatNumber type="number" value="${gameManagementForm.controlParameter.limitCancel2}" /> KHR</td>
			</tr>
			 -->
		    </table>
		  </div>
		</td>
	   </tr>
       </table>
    </div>
</body></html>