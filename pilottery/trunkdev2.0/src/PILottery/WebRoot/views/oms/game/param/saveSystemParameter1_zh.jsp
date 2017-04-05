<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/views/common/taglibs.jsp"%>
<html><body>
    <div class="bg" style="width:460px">
	<table width="100%" border="0" cellspacing="0" cellpadding="0">
	    <tr>
		<td class="title">
		    <table width="100%" border="0" cellspacing="0" cellpadding="0" style="color:#fff;font-size:18px;">
			<tr>
			    <td width="51%">销售站告警阈值</td>
			    <td width="37%" align="right"><a href="#" onclick="edit('sale');" onmouseout="MM_swapImgRestore()" onmouseout="MM_swapImgRestore()" onmouseover="MM_swapImage('Image17','','${basePath}/img/edit-hover.png',1)"><img src="${basePath}/img/edit.png" width="32" height="42" id="Image17" title="编辑" /></a></td>
			</tr>
		    </table>
		</td>
	    </tr>
	    <tr>
		<td class="nr" style="height:220px">
		    <table width="100%" border="0" cellspacing="0" cellpadding="0" style="font-size:14px; color:#5e6d81; line-height:30px;">
			<tr>
				<td>销售站每天退票告警票数：${gameManagementForm.str_sysParamValue0}</td>
			</tr>
			<tr>
				<td>销售站每天退票告警金额：<fmt:formatNumber type="number" value="${gameManagementForm.str_sysParamValue1}" /> KHR</td>
			</tr>
			<tr>
				<td>销售站每天兑奖告警票数：${gameManagementForm.str_sysParamValue2}</td>
			</tr>
			<tr>
				<td>销售站每天兑奖告警金额：<fmt:formatNumber type="number" value="${gameManagementForm.str_sysParamValue3}" /> KHR</td>
			</tr>			
		    </table>
		</td>
	   </tr>
       </table>
    </div>
</body></html>