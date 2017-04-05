<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/views/common/taglibs.jsp"%>
<html><body>
  <div id="gameParameter">
	<div class="bg">
		<table width="100%" border="0" cellspacing="0" cellpadding="0">
			<tr>
				<td class="title2"><table width="100%" border="0" cellspacing="0" cellpadding="0" style="color:#fff;font-size:18px;">
					<tr>
						<td>普通规则参数</td>
						<td align="right"><a href="#" onclick="editGameParam(${gameManagementForm.normalRuleParameter.gameCode});" onmouseout="MM_swapImgRestore()"
													onmouseover="MM_swapImage('Image11','','${basePath}/img/edit-hover.png',1)"><img
															src="${basePath}/img/edit.png" width="32" height="42"
															id="Image11" title="编辑" /></a></td>						
					</tr>
				</table></td>
			</tr>
			<tr>
				<td class="nr">
				    <div style="height:210px; overflow:auto;">
					<table width="100%" border="0" cellspacing="0" cellpadding="0" style="font-size:14px; color:#5e6d81; line-height:30px;">
						<tr>
							<td>开奖模式：
								<c:if test="${gameManagementForm.normalRuleParameter.drawMode==1}">
									快开
								</c:if>
								<c:if test="${gameManagementForm.normalRuleParameter.drawMode==2}">
									内部算奖
								</c:if>
								<c:if test="${gameManagementForm.normalRuleParameter.drawMode==3}">
									外部算奖
								</c:if>
							</td>
						</tr>
						<tr>
							<td>单注投注金额：
								<fmt:formatNumber type="number" value="${gameManagementForm.normalRuleParameter.singleBetAmount}" /> KHR				
							</td>
						</tr>
						<tr>
							<td>多期销售限制：
								${gameManagementForm.normalRuleParameter.singleTicketMaxIssues}		
							</td>
						</tr>	
						<tr>
							<td>单票最大投注行数：
								${gameManagementForm.normalRuleParameter.singleTicketMaxLine}			
							</td>
						</tr>	
						<tr>
							<td>单行最大倍数：
								${gameManagementForm.normalRuleParameter.singleLineMaxAmount}				
							</td>
						</tr>
						<tr>
							<td>单票最大销售限额：
								<fmt:formatNumber type="number" value="${gameManagementForm.normalRuleParameter.singleTicketMaxAmount}" /> KHR	
							</td>
						</tr>
						<tr>
							<td>弃奖去处：
								<c:if test="${gameManagementForm.normalRuleParameter.abandonRewardCollect==1}">
									奖池
								</c:if>
								<c:if test="${gameManagementForm.normalRuleParameter.abandonRewardCollect==2}">
									调节基金
								</c:if>
								<c:if test="${gameManagementForm.normalRuleParameter.abandonRewardCollect==3}">
									公益金
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