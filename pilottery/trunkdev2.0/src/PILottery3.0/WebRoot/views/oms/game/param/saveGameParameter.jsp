<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/views/common/taglibs.jsp"%>
<html><body>
  <div id="gameParameter">
	<div class="bg">
		<table width="100%" border="0" cellspacing="0" cellpadding="0">
			<tr>
				<td class="title2"><table width="100%" border="0" cellspacing="0" cellpadding="0" style="color:#fff;font-size:18px;">
					<tr>
						<td>Rule Parameters</td>
						<td align="right"><a href="#" onclick="editGameParam(${gameManagementForm.normalRuleParameter.gameCode});" onmouseout="MM_swapImgRestore()"
													onmouseover="MM_swapImage('Image11','','${basePath}/img/edit-hover.png',1)"><img
															src="${basePath}/img/edit.png" width="32" height="42"
															id="Image11" title="Edit" /></a></td>						
					</tr>
				</table></td>
			</tr>
			<tr>
				<td class="nr">
				    <div style="height:210px; overflow:auto;">
					<table width="100%" border="0" cellspacing="0" cellpadding="0" style="font-size:14px; color:#5e6d81; line-height:30px;">
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
								<fmt:formatNumber type="number" value="${gameManagementForm.normalRuleParameter.singleBetAmount}" /> KHR				
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
								${gameManagementForm.normalRuleParameter.singleLineMaxAmount}				
							</td>
						</tr>
						<tr>
							<td>Max. Sales Amount per Ticket：
								<fmt:formatNumber type="number" value="${gameManagementForm.normalRuleParameter.singleTicketMaxAmount}" /> KHR	
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
</div>
</body></html>