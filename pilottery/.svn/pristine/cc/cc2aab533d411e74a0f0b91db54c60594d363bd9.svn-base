<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/views/common/taglibs.jsp"%>
<html><body>
    <div class="bgsuper" style="width:460px">
	<table width="100%" border="0" cellspacing="0" cellpadding="0">
	    <tr>
		<td class="title1">
		    <table width="100%" border="0" cellspacing="0" cellpadding="0" style="color:#fff;font-size:18px;">
			<tr>
			    <td width="55%">Outlet Default Parameters</td>
			    <td width="33%" align="right"><a href="#" onclick="cancel('agency');" onmouseout="MM_swapImgRestore()" onmouseover="MM_swapImage('Image27','','${basePath}/img/cz-hover.png',1)"><img src="${basePath}/img/cz.png" width="32" height="42" id="Image27" title="Cancel"/></a></td>
			    <td width="2%" align="right">|</td>
			    <td width="10%" align="right"><a href="#" onclick="prompt('agency');" onmouseout="MM_swapImgRestore()" onmouseover="MM_swapImage('Image18','','${basePath}/img/save-hover.png',1)"><img src="${basePath}/img/save.png" width="32" height="42" id="Image18" title="Save"/></a></td>
			</tr>
		    </table>
		</td>
	    </tr>
	    <tr>
		<td class="nr" style="height:220px">
		    <table width="100%" border="0" cellspacing="0" cellpadding="0" style="font-size:14px; line-height:30px;">
			<tr>
				<td>Payout Commission：<input type="text" name="str_sysParamValue4" value="${gameManagementForm.str_sysParamValue4}" onblur="value=value.replace(/[^0-9]/g,'')" style="width: 120px;"/> ‰</td>
			</tr>
			<tr>
				<td>Sales Commission：<input type="text" name="str_sysParamValue5" value="${gameManagementForm.str_sysParamValue5}" onblur="value=value.replace(/[^0-9]/g,'')" style="width: 120px;"/> ‰</td>
			</tr>
			<tr>
				<td>Payout Claiming Scope：
					<select name="str_sysParamValue6" class="select-normal">
					  <option value ="1" <c:if test="${gameManagementForm.str_sysParamValue6==1}"> selected </c:if>>Center</option>
					  <option value ="2" <c:if test="${gameManagementForm.str_sysParamValue6==2}"> selected </c:if>>1st-level Region</option>
					  <option value ="3" <c:if test="${gameManagementForm.str_sysParamValue6==3}"> selected </c:if>>2nd-level Region</option>
					  <option value ="4" <c:if test="${gameManagementForm.str_sysParamValue6==4}"> selected </c:if>>Outlet</option>
					</select>						
				</td>
			</tr>
			<tr>
				<td>Permanent Credit Limit：<input type="text" name="str_sysParamValue7" value="${gameManagementForm.str_sysParamValue7}" onblur="value=value.replace(/[^0-9]/g,'')" style="width: 120px;"/> KHR</td>
			</tr>			
		    </table>
		</td>
	   </tr>
       </table>
    </div>
</body></html>
