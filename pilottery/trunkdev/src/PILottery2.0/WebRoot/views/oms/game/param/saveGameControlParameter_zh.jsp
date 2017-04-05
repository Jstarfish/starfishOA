<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/views/common/taglibs.jsp"%>
<html><body>
  <div class="bg">
	<table width="100%" border="0" cellspacing="0" cellpadding="0">
	    <tr>
		<td class="title4">
		    <table width="100%" border="0" cellspacing="0" cellpadding="0" style="color:#fff;font-size:18px;">
			<tr>
			    <td width="51%">游戏控制参数</td>
			    <td width="37%" align="right"><a href="#" onclick="editGameControlParameter(${gameManagementForm.controlParameter.gameCode});" onmouseout="MM_swapImgRestore()" onmouseover="MM_swapImage('Image17','','${basePath}/img/edit-hover.png',1)"><img src="${basePath}/img/edit.png" width="32" height="42" id="Image17" title="编辑" /></a></td>
			</tr>
		    </table>
		</td>
	    </tr>
	    <tr>
		<td class="nr">
		  <div style="height:210px; overflow:auto;">
		    <table width="100%" border="0" cellspacing="0" cellpadding="0" style="font-size:14px;color:#5e6d81;  line-height:30px;"> 
			<tr>
				<td>大奖金额：<fmt:formatNumber type="number" value="${gameManagementForm.controlParameter.limitBigPrize}" /> KHR</td>
			</tr>
			<tr>
				<td>游戏兑奖限额：<fmt:formatNumber type="number" value="${gameManagementForm.controlParameter.limitPayment}" /> KHR</td>
			</tr>
			<tr>
				<td>允许退票时间：${gameManagementForm.controlParameter.cancelSec} 秒</td>
			</tr>
			<tr>
				<td>销售关闭倒数提醒：${gameManagementForm.controlParameter.issueCloseAlertTime} 秒</td>
			</tr>
			<tr>
				<td>普通销售员兑奖限额：<fmt:formatNumber type="number" value="${gameManagementForm.controlParameter.salerPayLimit}" /> KHR</td>
			</tr>
			<tr>
				<td>普通销售员退票限额：<fmt:formatNumber type="number" value="${gameManagementForm.controlParameter.salerCancelLimit}" /> KHR</td>
			</tr>
			<tr>
				<td>一级区域兑奖限额：<fmt:formatNumber type="number" value="${gameManagementForm.controlParameter.limitPayment2}" /> KHR</td>
			</tr>
			<tr>
				<td>一级区域退票限额：<fmt:formatNumber type="number" value="${gameManagementForm.controlParameter.limitCancel2}" /> KHR</td>
			</tr>
		    </table>
		  </div>
		</td>
	   </tr>
       </table>
    </div>
</body></html>