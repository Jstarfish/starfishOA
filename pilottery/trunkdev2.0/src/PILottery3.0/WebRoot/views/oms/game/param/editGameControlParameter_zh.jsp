<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/views/common/taglibs.jsp"%>
<html><body>
  <div class="bgsuper">
	<table width="100%" border="0" cellspacing="0" cellpadding="0">
	    <tr>
		<td class="title4">
		    <table width="100%" border="0" cellspacing="0" cellpadding="0" style="color:#fff;font-size:18px;">
			<tr>
			    <td width="51%">游戏控制参数</td>
			    <td width="37%" align="right"><a href="#" onclick="cancelEditGameControlParameter(${gameManagementForm.controlParameter.gameCode});" onmouseout="MM_swapImgRestore()" onmouseover="MM_swapImage('Image27','','${basePath}/img/cz-hover.png',1)"><img src="${basePath}/img/cz.png" width="32" height="42" id="Image27" title="取消编辑"/></a></td>
			    <td width="2%" align="right">|</td>
			    <td width="10%" align="right"><a href="#" onclick="prompt4();" onmouseout="MM_swapImgRestore()" onmouseover="MM_swapImage('Image18','','${basePath}/img/save-hover.png',1)"><img src="${basePath}/img/save.png" width="32" height="42" id="Image18" title="保存"/></a></td>
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
					<td>大奖金额：${gameManagementForm.controlParameter.limitBigPrize} 瑞尔</td>
				</tr>
				<tr>
					<td>游戏兑奖限额：${gameManagementForm.controlParameter.limitPayment} 瑞尔</td>
				</tr>
				<tr>
					<td>允许退票时间：<input type="text" name="controlParameter.cancelSec" value="${gameManagementForm.controlParameter.cancelSec}" onblur="value=value.replace(/[^0-9]/g,'')" style="width: 80px;"/> 秒</td>
				</tr>
				<tr>
					<td>销售关闭倒数提醒：<input type="text" name="controlParameter.issueCloseAlertTime" value="${gameManagementForm.controlParameter.issueCloseAlertTime}" onblur="value=value.replace(/[^0-9]/g,'')" style="width: 80px;"/> 秒</td>
				</tr>
				<!-- 
				<tr>
					<td>普通销售员兑奖限额：<input type="text" name="controlParameter.salerPayLimit" value="${gameManagementForm.controlParameter.salerPayLimit}" onblur="value=value.replace(/[^0-9]/g,'')" style="width: 80px;"/> KHR</td>
				</tr>
				<tr>
					<td>普通销售员退票限额：<input type="text" name="controlParameter.salerCancelLimit" value="${gameManagementForm.controlParameter.salerCancelLimit}" onblur="value=value.replace(/[^0-9]/g,'')" style="width: 80px;"/> KHR</td>
				</tr>
				<tr>
					<td>一级区域兑奖限额：<input type="text" name="controlParameter.limitPayment2" value="${gameManagementForm.controlParameter.limitPayment2}" onblur="value=value.replace(/[^0-9]/g,'')" style="width: 80px;"/> KHR</td>
				</tr>
				<tr>
					<td>一级区域退票限额：<input type="text" name="controlParameter.limitCancel2" value="${gameManagementForm.controlParameter.limitCancel2}" onblur="value=value.replace(/[^0-9]/g,'')" style="width: 80px;"/> KHR</td>
				</tr>
				 -->
			     </table>
			</div>
		  </td>
	   </tr>
       </table>
    </div>
</body></html>