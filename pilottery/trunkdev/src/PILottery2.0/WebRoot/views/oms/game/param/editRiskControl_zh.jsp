<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/views/common/taglibs.jsp"%>
<html><body>
	<div class="bgsuper" style="height: 260px;">
		<table width="100%" border="0" cellspacing="0" cellpadding="0">
			<tr>
				<td class="title4"><table id="butt" width="100%" border="0" cellspacing="0" cellpadding="0" style="color:#fff;font-size:18px;">
					<tr>
						<td width="58%">游戏风控</td>
					        <td width="11%" align="right"><a href="#" onmouseout="MM_swapImgRestore()" onmouseover="MM_swapImage('Image19','','${basePath}/img/edit-hover.png',1)"></a></td>
						<td align="right"><a href="#" onclick="cancelEditRiskControl(${gameParameter.gameCode});" onmouseout="MM_swapImgRestore()"
														onmouseover="MM_swapImage('Image15','','${basePath}/img/cz-hover.png',1)"><img
															src="${basePath}/img/cz.png" width="32" height="42"
															id="Image15" title="取消编辑" /></a></td>
						<td width="2%" align="right">|</td>
						<td width="10%" align="right"><a href="#" onclick="prompt7(${gameParameter.gameCode});"
														onmouseout="MM_swapImgRestore()"
														onmouseover="MM_swapImage('Image16','','${basePath}/img/save-hover.png',1)"><img
															src="${basePath}/img/save.png" width="32" height="42"
															id="Image16" title="保存" /></a></td>
					</tr>
				</table></td>
			</tr>
			<tr>
				<td class="nr">
				    <div style="height:210px; overflow:auto;">
					<table width="100%" border="0" cellspacing="0" cellpadding="0" style="font-size:14px; line-height:30px;">
						<input type="hidden" name="gameParameterHistory.gameCode" value="${gameParameter.gameCode}"/>
						<input type="hidden" name="gameParameterHistory.hisHisCode" value="${gameParameter.hisHisCode}"/>
						<input type="hidden" name="gameParameterHistory.isOpenRisk" value="${gameParameter.isOpenRisk}"/>
						<c:if test="${gameParameter.gameCode==6}">
						<input type="hidden" name="listSize" value="${listSize}"/>
						<tr>
							<td width="33%">玩法名称</td>
							<td width="33%">风控阈值</td>
							<td width="34%">最大赔付金额</td>
						</tr>
						<c:forEach items="${riskControlListTTY}" var="row" varStatus="s">
						<tr>
							<td>${ruleMap[row.temp_ruleCode]}</td><input type="hidden" name="gameParam${s.index}.temp_ruleCode" value="${row.temp_ruleCode}"/>
							<td><input type="text" name="gameParam${s.index}.temp_riskThreshold" value="${row.temp_riskThreshold}" onblur="value=value.replace(/[^0-9]/g,'')" style="width:80px;"/></td>
							<td><input type="text" name="gameParam${s.index}.temp_maxClaimsAmount" value="${row.temp_maxClaimsAmount}" onblur="value=value.replace(/[^0-9]/g,'')" style="width:80px;"/></td>
						</tr>
						</c:forEach>
						</c:if>
						<c:if test="${gameParameter.gameCode==11}">
						<tr>
							<td>风控阈值</td>
							<td><input type="text" name="gameParam.paramA" value="${riskControlK3.paramA}" onblur="value=value.replace(/[^0-9]/g,'')" style="width:80px;"/></td>
						</tr>
						<tr>
							<td>最大赔付金额</td>
							<td><input type="text" name="gameParam.paramB" value="${riskControlK3.paramB}" onblur="value=value.replace(/[^0-9]/g,'')" style="width:80px;"/></td>
						</tr>
						</c:if>
						<c:if test="${gameParameter.gameCode==12}">
						<tr>
							<td>风控阈值</td>
							<td><input type="text" name="gameParam.paramA" value="${riskControl11X5.paramA}" onblur="value=value.replace(/[^0-9]/g,'')" style="width:80px;"/></td>
						</tr>
						<tr>
							<td>最大赔付</td>
							<td><input type="text" name="gameParam.paramB" value="${riskControl11X5.paramB}" onblur="value=value.replace(/[^0-9]/g,'')" style="width:80px;"/></td>
						</tr>
						</c:if>
					</table>
				    </div>
				</td>
			</tr>
		</table>
	</div>
</body></html>