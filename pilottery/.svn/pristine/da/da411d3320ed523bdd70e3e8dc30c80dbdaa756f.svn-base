<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/views/common/taglibs.jsp"%>
<html><body>
  <div class="bgsuper">
	<table width="100%" border="0" cellspacing="0" cellpadding="0">
	    <tr>
		<td class="title4">
		    <table width="100%" border="0" cellspacing="0" cellpadding="0" style="color:#fff;font-size:18px;">
			<tr>
			    <td width="51%">Control Parameters</td>
			    <td width="37%" align="right"><a href="#" onclick="cancelEditGameControlParameter(${gameManagementForm.controlParameter.gameCode});" onmouseout="MM_swapImgRestore()" onmouseover="MM_swapImage('Image27','','${basePath}/img/cz-hover.png',1)"><img src="${basePath}/img/cz.png" width="32" height="42" id="Image27" title="Cancel"/></a></td>
			    <td width="2%" align="right">|</td>
			    <td width="10%" align="right"><a href="#" onclick="prompt4();" onmouseout="MM_swapImgRestore()" onmouseover="MM_swapImage('Image18','','${basePath}/img/save-hover.png',1)"><img src="${basePath}/img/save.png" width="32" height="42" id="Image18" title="Save"/></a></td>
			</tr>
		    </table>
		</td>
	    </tr>
	    <tr>
		  <td class="nr">
			<div style="height:210px; overflow:auto;">
			    <table width="100%" border="0" cellspacing="0" cellpadding="0" style="font-size:14px; line-height:30px;">
				<input type="hidden" name="controlParameter.gameCode" value="${gameManagementForm.controlParameter.gameCode}"/>
				<input type="hidden" name="controlParameter.limitBigPrize" value="${gameManagementForm.controlParameter.limitBigPrize}"/>
				<input type="hidden" name="controlParameter.limitPayment" value="${gameManagementForm.controlParameter.limitPayment}"/>
				<tr>
					<td>Big-Prize Amount：${gameManagementForm.controlParameter.limitBigPrize} KHR</td>
				</tr>
				<tr>
					<td>Payout Limit：${gameManagementForm.controlParameter.limitPayment} KHR</td>
				</tr>
				<tr>
					<td>Allowable Refund Time：<input type="text" name="controlParameter.cancelSec" value="${gameManagementForm.controlParameter.cancelSec}" onblur="value=value.replace(/[^0-9]/g,'')" style="width: 80px;"/> Sec</td>
				</tr>
				<tr>
					<td>Sales Countdown：<input type="text" name="controlParameter.issueCloseAlertTime" value="${gameManagementForm.controlParameter.issueCloseAlertTime}" onblur="value=value.replace(/[^0-9]/g,'')" style="width: 80px;"/> Sec</td>
				</tr>
				<tr>
					<td>Common Teller Payout Limit：<input type="text" name="controlParameter.salerPayLimit" value="${gameManagementForm.controlParameter.salerPayLimit}" onblur="value=value.replace(/[^0-9]/g,'')" style="width: 80px;"/> KHR</td>
				</tr>
				<tr>
					<td>Common Teller Refund Limit：<input type="text" name="controlParameter.salerCancelLimit" value="${gameManagementForm.controlParameter.salerCancelLimit}" onblur="value=value.replace(/[^0-9]/g,'')" style="width: 80px;"/> KHR</td>
				</tr>
				<tr>
					<td>1st-Level Region Payout Limit：<input type="text" name="controlParameter.limitPayment2" value="${gameManagementForm.controlParameter.limitPayment2}" onblur="value=value.replace(/[^0-9]/g,'')" style="width: 80px;"/> KHR</td>
				</tr>
				<tr>
					<td>1st-Level Region Refund Limit：<input type="text" name="controlParameter.limitCancel2" value="${gameManagementForm.controlParameter.limitCancel2}" onblur="value=value.replace(/[^0-9]/g,'')" style="width: 80px;"/> KHR</td>
				</tr>
			     </table>
			</div>
		  </td>
	   </tr>
       </table>
    </div>
</body></html>