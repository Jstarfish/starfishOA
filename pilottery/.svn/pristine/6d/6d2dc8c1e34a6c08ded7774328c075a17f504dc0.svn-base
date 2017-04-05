<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/views/common/taglibs.jsp"%>
<html><body>
    <div class="bg" style="width:460px">
	<table width="100%" border="0" cellspacing="0" cellpadding="0">
	    <tr>
		<td class="title1">
		    <table width="100%" border="0" cellspacing="0" cellpadding="0" style="color:#fff;font-size:18px;">
			<tr>
			    <td width="51%">Outlet Default Parameters</td>
			    <td width="37%" align="right"><a href="#" onclick="edit('agency');" onmouseout="MM_swapImgRestore()" onmouseout="MM_swapImgRestore()" onmouseover="MM_swapImage('Image14','','${basePath}/img/edit-hover.png',1)"><img src="${basePath}/img/edit.png" width="32" height="42" id="Image14" title="Edit" /></a></td>
			</tr>
		    </table>
		</td>
	    </tr>
	    <tr>
		<td class="nr" style="height:220px">
		    <table width="100%" border="0" cellspacing="0" cellpadding="0" style="font-size:14px; color:#5e6d81; line-height:30px;">
			<tr>
				<td>Payout Commission：${gameManagementForm.str_sysParamValue4} ‰</td>
			</tr>
			<tr>
				<td>Sales Commission：${gameManagementForm.str_sysParamValue5} ‰</td>
			</tr>
			<tr>
				<td>Payout Claiming Scope：
					<c:if test="${gameManagementForm.str_sysParamValue6==1}">
						Center
					</c:if>
					<c:if test="${gameManagementForm.str_sysParamValue6==2}">
						1st-level Institution
					</c:if>
					<c:if test="${gameManagementForm.str_sysParamValue6==3}">
						2nd-level Institution
					</c:if>
					<c:if test="${gameManagementForm.str_sysParamValue6==4}">
						Outlet
					</c:if>
				</td>
			</tr>
			<tr>
				<td>Permanent Credit Limit：<fmt:formatNumber type="number" value="${gameManagementForm.str_sysParamValue7}" /> KHR</td>
			</tr>			
		    </table>
		</td>
	   </tr>
       </table>
    </div>
</body></html>