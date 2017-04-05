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
			    <td width="51%">告警阈值</td>
			    <td width="37%" align="right"><a href="#" onclick="editGameParameter(${gameManagementForm.gameParameterDynamic.gameCode},2);" onmouseout="MM_swapImgRestore()" onmouseover="MM_swapImage('Image7','','${basePath}/img/edit-hover.png',1)"><img src="${basePath}/img/edit.png" width="32" height="42" id="Image7" title="编辑" /></a></td>
			</tr>
		    </table>
		</td>
	    </tr>
	    <tr>
		<td class="nr" style="height:200px">
		    <table width="100%" border="0" cellspacing="0" cellpadding="0" style="font-size:14px; color:#5e6d81; line-height:30px;">			
			
			<tr>
				<td>单票销售金额告警阈值：<fmt:formatNumber type="number" value="${gameManagementForm.gameParameterDynamic.auditSingleTicketSale}" /> 瑞尔</td>
			</tr>
			<tr>
				<td>单票兑奖金额告警阈值：<fmt:formatNumber type="number" value="${gameManagementForm.gameParameterDynamic.auditSingleTicketPay}" /> 瑞尔</td>
			</tr>
			<tr>
				<td>单票退票金额告警阈值：<fmt:formatNumber type="number" value="${gameManagementForm.gameParameterDynamic.auditSingleTicketCancel}" /> 瑞尔</td>
			</tr>
		    </table>
		</td>
	   </tr>
       </table>
    </div>
</div>
</body></html>