<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/views/common/taglibs.jsp"%>
<html><body>
    <div class="bg" style="width:460px">
	<table width="100%" border="0" cellspacing="0" cellpadding="0">
	    <tr>
		<td class="title1">
		    <table width="100%" border="0" cellspacing="0" cellpadding="0" style="color:#fff;font-size:18px;">
			<tr>
			    <td width="51%">销售站默认参数</td>
			    <td width="37%" align="right"><a href="#" onclick="edit('agency');" onmouseout="MM_swapImgRestore()" onmouseout="MM_swapImgRestore()" onmouseover="MM_swapImage('Image14','','${basePath}/img/edit-hover.png',1)"><img src="${basePath}/img/edit.png" width="32" height="42" id="Image14" title="编辑" /></a></td>
			</tr>
		    </table>
		</td>
	    </tr>
	    <tr>
		<td class="nr" style="height:220px">
		    <table width="100%" border="0" cellspacing="0" cellpadding="0" style="font-size:14px; color:#5e6d81; line-height:30px;">
			<tr>
				<td>销售站默认兑奖佣金比例：${gameManagementForm.str_sysParamValue4} ‰</td>
			</tr>
			<tr>
				<td>销售站默认销售佣金比例：${gameManagementForm.str_sysParamValue5} ‰</td>
			</tr>
			<tr>
				<td>销售站默认兑奖范围：
					<c:if test="${gameManagementForm.str_sysParamValue6==1}">
						中心
					</c:if>
					<c:if test="${gameManagementForm.str_sysParamValue6==2}">
						一级区域
					</c:if>
					<c:if test="${gameManagementForm.str_sysParamValue6==3}">
						二级区域
					</c:if>
					<c:if test="${gameManagementForm.str_sysParamValue6==4}">
						销售站
					</c:if>
				</td>
			</tr>
			<tr>
				<td>销售站默认永久授信额度：<fmt:formatNumber type="number" value="${gameManagementForm.str_sysParamValue7}" /> KHR</td>
			</tr>			
		    </table>
		</td>
	   </tr>
       </table>
    </div>
</body></html>