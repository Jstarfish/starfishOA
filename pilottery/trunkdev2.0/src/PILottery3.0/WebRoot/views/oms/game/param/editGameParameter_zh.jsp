<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/views/common/taglibs.jsp"%>
<html><body>
	<div class="bgsuper">
		<table width="100%" border="0" cellspacing="0" cellpadding="0">
			<tr>
				<td class="title2"><table width="100%" border="0" cellspacing="0" cellpadding="0" style="color:#fff;font-size:18px;">
					<tr>
						<td>普通规则参数</td>
						<td align="right"><a href="#" onclick="cancelEditGameParam(${gameManagementForm.normalRuleParameter.gameCode});" onmouseout="MM_swapImgRestore()"
													onmouseover="MM_swapImage('Image11','','${basePath}/img/cz-hover.png',1)"><img
															src="${basePath}/img/cz.png" width="32" height="42"
															id="Image11" title="取消编辑" /></a></td>
						<td width="2%" align="right">|</td>
						<td width="10%" align="right"><a href="#" onclick="prompt3();"
														onmouseout="MM_swapImgRestore()"
														onmouseover="MM_swapImage('Image12','','${basePath}/img/save-hover.png',1)"><img
															src="${basePath}/img/save.png" width="32" height="42"
															id="Image12" title="保存" /></a></td>
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
								${gameManagementForm.normalRuleParameter.singleBetAmount}  瑞尔
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
								<input type="text" name="normalRuleParameter.singleLineMaxAmount" value="${gameManagementForm.normalRuleParameter.singleLineMaxAmount}" onblur="value=value.replace(/[^0-9]/g,'')" style="width: 80px;"/>				
							</td>
						</tr>
						<tr>
							<td>单票最大销售限额：
								<input type="text" name="normalRuleParameter.singleTicketMaxAmount" value="${gameManagementForm.normalRuleParameter.singleTicketMaxAmount}" onblur="value=value.replace(/[^0-9]/g,'')" style="width: 80px;"/>  瑞尔
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
</body></html>