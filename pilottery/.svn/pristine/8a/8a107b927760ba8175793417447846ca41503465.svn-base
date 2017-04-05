<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/views/common/taglibs.jsp"%>
<html><body>
<div id="gameParameter2">
    <div class="bgsuper">
	<table width="100%" border="0" cellspacing="0" cellpadding="0">
	    <tr>
		<td class="title1">
		    <table width="100%" border="0" cellspacing="0" cellpadding="0" style="color:#fff;font-size:18px;">
			<tr>
			    <td width="51%">告警阈值</td>
			    <td width="37%" align="right"><a href="#" onclick="cancelEditGameParameter(${gameParameter.gameCode},2);" onmouseout="MM_swapImgRestore()" onmouseover="MM_swapImage('Image7','','${basePath}/img/cz-hover.png',1)"><img src="${basePath}/img/cz.png" width="32" height="42" id="Image7" title="取消编辑"/></a></td>
			    <td width="2%" align="right">|</td>
			    <td width="10%" align="right"><a href="#" onclick="prompt(2);" onmouseout="MM_swapImgRestore()" onmouseover="MM_swapImage('Image8','','${basePath}/img/save-hover.png',1)"><img src="${basePath}/img/save.png" width="32" height="42" id="Image8" title="保存"/></a></td>
			</tr>
		    </table>
		</td>
	    </tr>
	    <tr>
		<td class="nr" style="height:200px">
		    <table width="100%" border="0" cellspacing="0" cellpadding="0" style="font-size:14px; line-height:30px;">
			<input type="hidden" name="gameParameterDynamic.gameCode" value="${gameParameter.gameCode}"/>						
			<tr>
				<td>单票销售金额告警阈值：<input type="text" name="gameParameterDynamic.auditSingleTicketSale" value="${gameParameter.auditSingleTicketSale}" style="width: 80px;" onblur="value=value.replace(/[^0-9]/g,'')" maxLength=9/> 瑞尔</td>
			</tr>
			<tr>
				<td>单票兑奖金额告警阈值：<input type="text" name="gameParameterDynamic.auditSingleTicketPay" value="${gameParameter.auditSingleTicketPay}" style="width: 80px;" onblur="value=value.replace(/[^0-9]/g,'')" maxLength=9/> 瑞尔</td>
			</tr>
			<tr>
				<td>单票退票金额告警阈值：<input type="text" name="gameParameterDynamic.auditSingleTicketCancel" value="${gameParameter.auditSingleTicketCancel}" style="width: 80px;" onblur="value=value.replace(/[^0-9]/g,'')" maxLength=9/> 瑞尔</td>
			</tr>
		    </table>
		</td>
	   </tr>
       </table>
    </div>
</div>
</body></html>