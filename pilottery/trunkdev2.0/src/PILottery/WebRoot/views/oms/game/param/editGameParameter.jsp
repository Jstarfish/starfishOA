<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/views/common/taglibs.jsp"%>
<html><body>
	<div class="bgsuper">
		<table width="100%" border="0" cellspacing="0" cellpadding="0">
			<tr>
				<td class="title2"><table width="100%" border="0" cellspacing="0" cellpadding="0" style="color:#fff;font-size:18px;">
					<tr>
						<td>Rule Parameters</td>
						<td align="right"><a href="#" onclick="cancelEditGameParam(${gameManagementForm.normalRuleParameter.gameCode});" onmouseout="MM_swapImgRestore()"
													onmouseover="MM_swapImage('Image11','','${basePath}/img/cz-hover.png',1)"><img
															src="${basePath}/img/cz.png" width="32" height="42"
															id="Image11" title="Cancel" /></a></td>
						<td width="2%" align="right">|</td>
						<td width="10%" align="right"><a href="#" onclick="prompt3();"
														onmouseout="MM_swapImgRestore()"
														onmouseover="MM_swapImage('Image12','','${basePath}/img/save-hover.png',1)"><img
															src="${basePath}/img/save.png" width="32" height="42"
															id="Image12" title="Save" /></a></td>
					</tr>
				</table></td>
			</tr>
			<tr>
				<td class="nr">
				    <div style="height:210px; overflow:auto;">
					<table width="100%" border="0" cellspacing="0" cellpadding="0" style="font-size:14px; line-height:30px;">
						<input type="hidden" name="normalRuleParameter.gameCode" value="${gameManagementForm.normalRuleParameter.gameCode}"/>		
						<input type="hidden" name="normalRuleParameter.singleBetAmount" value="${gameManagementForm.normalRuleParameter.singleBetAmount}"/>	
						<input type="hidden" name="normalRuleParameter.singleTicketMaxLine" value="${gameManagementForm.normalRuleParameter.singleTicketMaxLine}"/>	
						<input type="hidden" name="normalRuleParameter.singleTicketMaxIssues" value="${gameManagementForm.normalRuleParameter.singleTicketMaxIssues}"/>	
						<input type="hidden" name="normalRuleParameter.drawMode" value="${gameManagementForm.normalRuleParameter.drawMode}"/>
						<input type="hidden" name="normalRuleParameter.abandonRewardCollect" value="${gameManagementForm.normalRuleParameter.abandonRewardCollect}"/>
						<tr>
							<td>Draw Mode：
								<c:if test="${gameManagementForm.normalRuleParameter.drawMode==1}">
									Quick-draw
								</c:if>
								<c:if test="${gameManagementForm.normalRuleParameter.drawMode==2}">
									Internal
								</c:if>
								<c:if test="${gameManagementForm.normalRuleParameter.drawMode==3}">
									External
								</c:if>
							</td>
						</tr>
						<tr>
							<td>Cost per Bet：
								${gameManagementForm.normalRuleParameter.singleBetAmount}  KHR				
							</td>
						</tr>
						<tr>
							<td>Max. Issues per Ticket：
								${gameManagementForm.normalRuleParameter.singleTicketMaxIssues} 		
							</td>
						</tr>	
						<tr>
							<td>Max. Betlines per Ticket：
								${gameManagementForm.normalRuleParameter.singleTicketMaxLine}				
							</td>
						</tr>	
						<tr>
							<td>Max. Multiplier per Betline：
								<input type="text" name="normalRuleParameter.singleLineMaxAmount" value="${gameManagementForm.normalRuleParameter.singleLineMaxAmount}" onblur="value=value.replace(/[^0-9]/g,'')" style="width: 80px;"/>				
							</td>
						</tr>
						<tr>
							<td>Max. Sales Amount per Ticket：
								<input type="text" name="normalRuleParameter.singleTicketMaxAmount" value="${gameManagementForm.normalRuleParameter.singleTicketMaxAmount}" onblur="value=value.replace(/[^0-9]/g,'')" style="width: 80px;"/>  KHR			
							</td>
						</tr>
						<tr>
							<td>Abandoned Award Destination：
								<c:if test="${gameManagementForm.normalRuleParameter.abandonRewardCollect==1}">
									Pool
								</c:if>
								<c:if test="${gameManagementForm.normalRuleParameter.abandonRewardCollect==2}">
									Adjustment fund
								</c:if>
								<c:if test="${gameManagementForm.normalRuleParameter.abandonRewardCollect==3}">
									Charity fund
								</c:if>
							</td>
						</tr>
					 </table>
				    </div>
				</td>
			</tr>
		</table>
	</div>
</body></html>