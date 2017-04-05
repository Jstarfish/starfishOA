<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/views/common/taglibs.jsp"%>
<html><body>
  <div id="riskControl">
	<div class="bg">
		<table width="100%" border="0" cellspacing="0" cellpadding="0">
			<tr>
				<td class="title4"><table id="butt" width="100%" border="0" cellspacing="0" cellpadding="0" style="color:#fff;font-size:18px;">
					<tr>
						<td width="58%">游戏风控</td>
						<td width="31%" align="right" >
							<input type="checkbox" id="ch_emails" name="ch_emails" data-on="开" data-off="关" checked="checked" style="display:none;">
							<span classname="tzCheckBox checked" id="tzCheckBox" class="checked">
								<span class="tzCBContent">开</span>
								<span class="tzCBPart"></span>
							</span>
						</td>
					        <td width="11%" align="right"><a href="#" onmouseout="MM_swapImgRestore()" onmouseover="MM_swapImage('Image19','','${basePath}/img/edit-hover.png',1)"></a></td>
						<td align="right"><a href="#" onclick="editRiskControl(${gameManagementForm.gameParameterHistory.gameCode});"
														onmouseout="MM_swapImgRestore()"
														onmouseover="MM_swapImage('Image15','','${basePath}/img/edit-hover.png',1)"><img
															src="${basePath}/img/edit.png" width="32" height="42"
															id="Image15" title="编辑" /></a></td>
					</tr>
				</table></td>
			</tr>
			<tr>
				<td class="nr">
				    <div style="height:210px; overflow:auto;">
					<table width="100%" border="0" cellspacing="0" cellpadding="0" style="font-size:14px; color:#5e6d81; line-height:30px;">
						<c:if test="${gameParameter.gameCode==6}">
						<tr>
							<td width="33%">玩法名称</td>
							<td width="33%">风控阈值</td>
							<td width="34%">最大赔付金额</td>
						</tr>
						<c:forEach items="${riskControlListTTY}" var="row" varStatus="s">
						<tr>
							<td>${ruleMap[row.temp_ruleCode]}</td>
							<td><fmt:formatNumber type="number" value="${row.temp_riskThreshold}" /></td> 
							<td><fmt:formatNumber type="number" value="${row.temp_maxClaimsAmount}" /></td> 
						</tr>
						</c:forEach>
						</c:if>
						<c:if test="${gameParameter.gameCode==11}">
						<tr>
							<td>风控阈值</td>
							<td><fmt:formatNumber type="number" value="${riskControlK3.paramA}" /></td>
						</tr>
						<tr>
							<td>最大赔付金额</td>
							<td><fmt:formatNumber type="number" value="${riskControlK3.paramB}" /></td>
						</tr>
					    </c:if>
					    <c:if test="${gameParameter.gameCode==12}">
						<tr>
							<td>风控阈值</td>
							<td><fmt:formatNumber type="number" value="${riskControl11X5.paramA}" /></td>
						</tr>
						<tr>
							<td>最大赔付金额</td>
							<td><fmt:formatNumber type="number" value="${riskControl11X5.paramB}" /></td>
						</tr>
					    </c:if>
					</table>
				    </div>
				</td>
			</tr>
		</table>
	</div>
 </div>
</body></html>