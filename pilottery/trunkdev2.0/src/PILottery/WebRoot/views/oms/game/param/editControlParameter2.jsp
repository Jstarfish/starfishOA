<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/views/common/taglibs.jsp"%>
<html><body>
<div id="gameParameter3">
    <div class="bgsuper">
	<table width="100%" border="0" cellspacing="0" cellpadding="0">
	    <tr>
		<td class="title2">
		    <table width="100%" border="0" cellspacing="0" cellpadding="0" style="color:#fff;font-size:18px;">
			<tr>
			    <td width="51%">Service Period</td>
			    <td width="37%" align="right"><a href="#" onclick="cancelEditGameParameter(${gameParameter.gameCode},3);" onmouseout="MM_swapImgRestore()" onmouseover="MM_swapImage('Image7','','${basePath}/img/cz-hover.png',1)"><img src="${basePath}/img/cz.png" width="32" height="42" id="Image7" title="Cancel"/></a></td>
			    <td width="2%" align="right">|</td>
			    <td width="10%" align="right"><a href="#" onclick="prompt(3);" onmouseout="MM_swapImgRestore()" onmouseover="MM_swapImage('Image8','','${basePath}/img/save-hover.png',1)"><img src="${basePath}/img/save.png" width="32" height="42" id="Image8" title="Save"/></a></td>
			</tr>
		    </table>
		</td>
	    </tr>
	    <tr>
		<td class="nr" style="height:200px">
		    <table width="100%" border="0" cellspacing="0" cellpadding="0" style="font-size:14px; line-height:30px;">
			<input type="hidden" name="gameParameterDynamic.gameCode" value="${gameParameter.gameCode}"/>					
			<tr>
				<td>Service Period 1：
					<input type="text" id="st1" name="gameParameterDynamic.serviceTime1" value="${gameParameter.serviceTime1}" 
						onblur="javascript:checkRegex('st1');" style="width: 180px;"/>				
				</td>
			</tr>
			<tr>
				<td>Service Period 2：
					<input type="text" id="st2" name="gameParameterDynamic.serviceTime2" value="${gameParameter.serviceTime2}" 
						onblur="javascript:checkRegex('st2');" style="width: 180px;"/>				
				</td>
			</tr>	
		    </table>
		</td>
	   </tr>
       </table>
    </div>
</div>
</body></html>