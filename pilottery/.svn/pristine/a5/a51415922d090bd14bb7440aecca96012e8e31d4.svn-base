<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8"%>
<%@ include file="/views/common/taglibs.jsp"%>
<html>
<head>
<title></title>
<link rel="stylesheet" type="text/css" href="${basePath}/css/game.css"/>
<link rel="stylesheet" type="text/css" href="${basePath}/css/style.css"/>
<script type="text/javascript" src="${basePath}/js/jquery/jquery-1.9.1.js"></script>
</head>
<body style="overflow:hidden;">
<div id="title">${gameManagementForm.gameInfo.shortName}&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Issue：${issueNumber}</div>
	<div style="height:100%; width:100%;">
		<div id="right2" style="left:0px;width: 100%">
			<table width="100%" border="0" cellspacing="0" cellpadding="0">
				<tr>
					<td>
						<div style="float: left; position: relative; top: 50%; left: 10%;"></div>
					</td>
					<td><div class="game">
						  <div id="gameInfo">
							<div class="bg">
								<table width="100%" border="0" cellspacing="0" cellpadding="0" >
									<tr>
										<td class="title">
											<table width="100%" border="0" cellspacing="0" cellpadding="0" style="color:#fff;font-size:18px;">
												<tr>
													<td width="51%">Basic Parameters</td>
												</tr>
											</table></td>
									</tr>
									<tr>
										<td class="nr" >
										<div style="height:210px; overflow:auto;">
											<table width="100%" border="0" cellspacing="0"
												cellpadding="0" style="font-size:14px; color:#5e6d81; line-height:30px;">
												<tr>
													<td>Game Code：${gameManagementForm.gameInfo.gameCode}</td>
												</tr>
												<tr>
													<td>Game Tag：${gameManagementForm.gameInfo.gameMark}</td>
												</tr>
												<tr>
													<td>Game Name：${gameManagementForm.gameInfo.fullName}</td>
												</tr>
												<tr>
													<td>Game Abbr：${gameManagementForm.gameInfo.shortName}</td>
												</tr>
												<tr>
													<td>Game Type：
														<c:if test="${gameManagementForm.gameInfo.basicType==1}">Keno</c:if>
														<c:if test="${gameManagementForm.gameInfo.basicType==2}">Lotto</c:if>
														<c:if test="${gameManagementForm.gameInfo.basicType==3}">Digit</c:if>
														<c:if test="${gameManagementForm.gameInfo.basicType==4}">Sports</c:if>
													</td>
												</tr>
												<tr>
													<td>Issuance Company：${gameManagementForm.gameInfo.issuingOrganization}</td>
												</tr>
											</table>
										</div>
										</td>
									</tr>
								</table>
							</div>
						  </div>
					      <div id="gamePolicyParam">
							<div class="bg">
								<table width="100%" border="0" cellspacing="0" cellpadding="0">
									<tr>
										<td class="title1"><table width="100%" border="0" cellspacing="0" cellpadding="0" style="color:#fff;font-size:18px;">
												<tr>
													<td width="51%">Policy Parameters</td>
												</tr>
											</table></td>
									</tr>
									<tr>
										<td class="nr">
										<div style="height:210px; overflow:auto;">
											<table width="100%" border="0" cellspacing="0"
												cellpadding="0" style="font-size:14px; color:#5e6d81; line-height:30px;">
												<tr>
													<td>Theoretical Payback Rate：${gameManagementForm.gamePolicyParam.theoryRate} ‰</td>
												</tr>
												<tr>
													<td>Charity Fund Rate：${gameManagementForm.gamePolicyParam.fundRate} ‰</td>
												</tr>
												<tr>
													<td>Adjustment Fund Rate：${gameManagementForm.gamePolicyParam.adjRate} ‰</td>
												</tr>
												<tr>
													<td>Tax Exemption Threshold：${gameManagementForm.gamePolicyParam.taxThreshold}
													</td>
												</tr>
												<tr>
													<td>Tax Rate：${gameManagementForm.gamePolicyParam.taxRate} ‰</td>
												</tr>
												<tr>
													<td>Payout Period：${gameManagementForm.gamePolicyParam.drawLimitDay} </td>
												</tr>
											</table>
										</div>
										</td>
									</tr>
								</table>
							</div>
						  </div>
						  <div id="gameParameter">
							<div class="bg" >
								<table width="100%" border="0" cellspacing="0" cellpadding="0">
									<tr>
										<td class="title2"><table width="100%" border="0" cellspacing="0" cellpadding="0" style="color:#fff;font-size:18px;">
												<tr>
													<td>Rule Parameters</td>
												</tr>
											</table></td>
									</tr>
									<tr>
										<td class="nr">
										<div style="height:210px; overflow:auto;">
											<table width="100%" border="0" cellspacing="0"
												cellpadding="0" style="font-size:14px; color:#5e6d81; line-height:30px;">
												<tr>
													<td>Draw Mode：
															<c:if test="${gameManagementForm.normalRuleParameter.drawMode==1}">Quick-draw</c:if>
															<c:if test="${gameManagementForm.normalRuleParameter.drawMode==2}">Internal</c:if>
															<c:if test="${gameManagementForm.normalRuleParameter.drawMode==3}">External</c:if>
													</td>
												</tr>
												<tr>
													<td>Cost per Bet：<fmt:formatNumber value="${gameManagementForm.normalRuleParameter.singleBetAmount}" type="number"/> Riels</td>
												</tr>
												<tr>
													<td>Max. Issues per Ticket：${gameManagementForm.normalRuleParameter.singleTicketMaxIssues}</td>
												</tr>
												<tr>
													<td>Max. Betlines per Ticket：${gameManagementForm.normalRuleParameter.singleTicketMaxLine}</td>
												</tr>
												<tr>
													<td>Max. Multiplier per Betline：${gameManagementForm.normalRuleParameter.singleLineMaxAmount}</td>
												</tr>
												<tr>
													<td>Max. Sales Amount per Ticket：<fmt:formatNumber value="${gameManagementForm.normalRuleParameter.singleTicketMaxAmount}" type="number"/> Riels</td>
												</tr>
												<tr>
													<td>
													Abandoned Award Destination：
															<c:if test="${gameManagementForm.normalRuleParameter.abandonRewardCollect==1}">Pool</c:if> 
															<c:if test="${gameManagementForm.normalRuleParameter.abandonRewardCollect==2}">Adjustment fund</c:if> 
															<c:if test="${gameManagementForm.normalRuleParameter.abandonRewardCollect==3}">Charity fund</c:if> 
													</td>
												</tr>
											</table>
										</div>
										</td>
									</tr>
								</table>
							</div>
						  </div>
						  <div id="gameControlParameter">
							<div class="bg" >
								<table width="100%" border="0" cellspacing="0" cellpadding="0">
									<tr>
										<td class="title4"><table width="100%" border="0" cellspacing="0" cellpadding="0" style="color:#fff;font-size:18px;">
												<tr>
													<td>Control Parameters</td>
												</tr>
											</table></td>
									</tr>
									<tr>
										<td class="nr">
										<div style="height:210px; overflow:auto;">
											<table width="100%" border="0" cellspacing="0"
												cellpadding="0" style="font-size:14px; color:#5e6d81; line-height:30px;">
												<tr>
													<td>Big-Prize Amount：<fmt:formatNumber type="number" value="${gameManagementForm.controlParameter.limitBigPrize}" /> Riels</td>
												</tr>
												<tr>
													<td>Payout Limit：<fmt:formatNumber type="number" value="${gameManagementForm.controlParameter.limitPayment}" /> Riels</td>
												</tr>
												<tr>
													<td>Allowable Refund Time：${gameManagementForm.controlParameter.cancelSec} Seconds</td>
												</tr>
												<tr>
													<td>Sales Countdown：${gameManagementForm.controlParameter.issueCloseAlertTime} Seconds</td>
												</tr>
												<!-- 
												<tr>
													<td>Common Teller Payout Limit：<fmt:formatNumber type="number" value="${gameManagementForm.controlParameter.salerPayLimit}" /> Riels</td>
												</tr>
												<tr>
													<td>Common Teller Refund Limit：<fmt:formatNumber type="number" value="${gameManagementForm.controlParameter.salerCancelLimit}" /> Riels</td>
												</tr>
												<tr>
													<td>Institution Payout Limit：<fmt:formatNumber type="number" value="${gameManagementForm.controlParameter.limitPayment2}" /> Riels</td>
												</tr>
												<tr>
													<td>Institution Refund Limit：<fmt:formatNumber type="number" value="${gameManagementForm.controlParameter.limitCancel2}" /> Riels</td>
												</tr> -->
											</table>
										</div>
										</td>
									</tr>
								</table>
							</div>
						  </div>
						  <div id="gameRule">
							<div class="bg" >
								<table width="100%" border="0" cellspacing="0" cellpadding="0">
									<tr>
										<td class="title2"><table width="100%" border="0" cellspacing="0" cellpadding="0" style="color:#fff;font-size:18px;">
												<tr>
													<td>Subtype Rules</td>
												</tr>
											</table></td>
									</tr>
									<tr>
										<td class="nr">
										<div style="height:210px; overflow:auto;">
											<table width="100%" border="0" cellspacing="0"
												cellpadding="0" style="font-size:14px; color:#5e6d81; line-height:30px;" >
												<tr>
													<td width="40%">Subtype Name</td><td>Rule Description</td>
												</tr>
												<c:forEach var="gameRule" items="${gameManagementForm.gameRuleList}" >
												<tr>
													<td>${gameRule.ruleName}</td>
													<td>${gameRule.ruleDesc}</td>
												</tr>
												</c:forEach>
											</table>
											</div>
										</td>
									</tr>
								</table>
							</div>
						  </div>
						  <div id="gameWinRule">
							<div class="bg" >
								<table width="100%" border="0" cellspacing="0" cellpadding="0">
									<tr>
										<td class="title3"><table width="100%" border="0" cellspacing="0" cellpadding="0" style="color:#fff;font-size:18px;">
												<tr>
													<td>Winning Rules</td>
												</tr>
											</table></td>
									</tr>
									<tr>
										<td class="nr">
										<div style="height:210px; overflow:auto;">
											<table width="100%" border="0" cellspacing="0"
												cellpadding="0" style="font-size:14px; color:#5e6d81; line-height:30px;">
												<tr>
													<td width="40%">Rule Name</td>
													<td>Rule Description</td>
												</tr>
												<c:forEach var="gameWinRule" items="${gameManagementForm.gameWinRuleList}">
												<tr>
													<td>${gameWinRule.wRuleName}</td>
													<td>${gameWinRule.wRuleDesc}</td>
												</tr>
												</c:forEach>
											</table>
										</div>
										</td>
									</tr>
								</table>
							</div>
						  </div>
						  <div id="gamePrizeRule">
							<div class="bg" >
								<table width="100%" border="0" cellspacing="0" cellpadding="0">
									<tr>
										<td class="title5">
											<table width="100%" border="0" cellspacing="0" cellpadding="0" style="color:#fff;font-size:18px;">
												<tr>
													<td>Prize Levels</td>
												</tr>
											</table></td>
									</tr>
									<tr>
										<td class="nr">
										<div style="height:210px; overflow:auto;">
											<table width="100%" border="0" cellspacing="0"
												cellpadding="0" style="font-size:14px; color:#5e6d81; line-height:30px;">
												<c:if test="${gameManagementForm.gameInfo.gameCode == 6}">
												<tr>
										          	<td colspan="3">Special Award Enabled： 
											            <c:if test="${gameManagementForm.isSpecial==1}">Yes</c:if>
											            <c:if test="${gameManagementForm.isSpecial==0}">No</c:if>
										       	 	</td>
										       	</tr>
												</c:if>
												<c:if test="${gameManagementForm.gameInfo.gameCode == 7}">
												<tr>
										          	<td colspan="3">1st-Prize Lower Limit： 
											            <fmt:formatNumber type="number" value="${gameManagementForm.fdbd}" />
										       	 	</td>
										       	</tr>
										       	<tr>
										          	<td colspan="3">1st-Prize Upper Limit： 
											            <fmt:formatNumber type="number" value="${gameManagementForm.fdfd}" />
										       	 	</td>
										       	</tr>
										       	<tr>
										          	<td colspan="3">Chump Change： 
											            <fmt:formatNumber type="number" value="${gameManagementForm.fdmin}" />
										       	 	</td>
										       	</tr>
												</c:if>
												<tr>
													<td width="50%">Name</td>
													<td width="50%">Award</td>
												</tr>
												<c:forEach var="s" items="${gameManagementForm.gamePrizeRuleList}" >
												<tr>
													<td>${s.pruleName}</td>
													<td><fmt:formatNumber type="number" value="${s.levelPrize}" /></td>
												</tr>
												</c:forEach>
											</table>
										</div>
										</td>
									</tr>
								</table>
							</div>
						  </div>
						  <div id="riskControl" >
						  <c:if test="${gameManagementForm.gameParameterHistory.gameCode==5}">
							<div class="bg" >
								<table width="100%" border="0" cellspacing="0" cellpadding="0">
									<tr>
										<td class="title4"><table id="butt" width="100%" border="0" cellspacing="0" cellpadding="0" style="color:#fff;font-size:18px;">
												<tr>
													<td width="58%">Risk Control</td>
													<td width="31%" align="right" >
														<c:if test="${gameManagementForm.gameParameterHistory.isOpenRisk==1}"><img src="${basePath}/img/on_en.png"/></c:if>
														<c:if test="${gameManagementForm.gameParameterHistory.isOpenRisk==0}"><img src="${basePath}/img/off_en.png"/></c:if>
													</td>
												</tr>
											</table></td>
									</tr>
									<tr>
										<td class="nr">
										<div style="height:210px; overflow:auto;">
											<table id="riskTab" width="100%" border="0" cellspacing="0" cellpadding="0" style="font-size:14px; color:#5e6d81; line-height:30px;">
												<tr>
													<td width="33%">Subtype</td>
													<td width="33%">Limited Number Of Bets</td>
												</tr>
												<c:forEach var="s" items="${riskControlListSSC}" >
												<tr>
													<td>${ruleMap[s.paramA]}</td>
													<td><fmt:formatNumber type="number" value="${s.paramB}" /></td>
												</tr>
												</c:forEach>
											</table>
										</div>
										</td>
									</tr>
								</table>
							</div>
						</c:if>
						<c:if test="${gameManagementForm.gameParameterHistory.gameCode==6}">
							<div class="bg" >
								<table width="100%" border="0" cellspacing="0" cellpadding="0">
									<tr>
										<td class="title4"><table id="butt" width="100%" border="0" cellspacing="0" cellpadding="0" style="color:#fff;font-size:18px;">
												<tr>
													<td width="58%">Risk Control</td>
													<td width="31%" align="right" >
														<c:if test="${gameManagementForm.gameParameterHistory.isOpenRisk==1}"><img src="${basePath}/img/on_en.png"/></c:if>
														<c:if test="${gameManagementForm.gameParameterHistory.isOpenRisk==0}"><img src="${basePath}/img/off_en.png"/></c:if>
													</td>
												</tr>
											</table></td>
									</tr>
									<tr>
										<td class="nr">
										<div style="height:210px; overflow:auto;">
											<table id="riskTab" width="100%" border="0" cellspacing="0" cellpadding="0" style="font-size:14px; color:#5e6d81; line-height:30px;">
												<tr>
													<td width="33%">Subtype</td>
													<td width="33%">Threshold</td>
													<td width="34%">Compensation</td>
												</tr>
												<c:forEach var="s" items="${riskControlListTTY}" >
												<tr>
													<td>${ruleMap[s.temp_ruleCode]}</td>
													<td><fmt:formatNumber type="number" value="${s.temp_riskThreshold}" /></td>
													<td><fmt:formatNumber type="number" value="${s.temp_maxClaimsAmount}" /></td>
												</tr>
												</c:forEach>
											</table>
										</div>
										</td>
									</tr>
								</table>
							</div>
						</c:if>
						  <c:if test="${gameManagementForm.gameParameterHistory.gameCode==11}">
							<div class="bg" >
								<table width="100%" border="0" cellspacing="0" cellpadding="0">
									<tr>
										<td class="title4"><table id="butt" width="100%" border="0" cellspacing="0" cellpadding="0" style="color:#fff;font-size:18px;">
												<tr>
													<td width="58%">Risk Control</td>
													<td width="31%" align="right" >
														<c:if test="${gameManagementForm.gameParameterHistory.isOpenRisk==1}"><img src="${basePath}/img/on_en.png"/></c:if>
														<c:if test="${gameManagementForm.gameParameterHistory.isOpenRisk==0}"><img src="${basePath}/img/off_en.png"/></c:if>
													</td>
												</tr>
											</table></td>
									</tr>
									<tr>
										<td class="nr">
										<div style="height:210px; overflow:auto;">
											<table id="riskTab" width="100%" border="0" cellspacing="0" cellpadding="0" style="font-size:14px; color:#5e6d81; line-height:30px;">
												<tr>
													<td>Threshold</td>
													<td><fmt:formatNumber type="number" value="${riskControlK3.paramA}" /></td>
												</tr>
												<tr>
													<td>Compensation</td>
													<td><fmt:formatNumber type="number" value="${riskControlK3.paramB}" /></td>
												</tr>
											</table>
										</div>
										</td>
									</tr>
								</table>
							</div>
						</c:if>
						<c:if test="${gameManagementForm.gameParameterHistory.gameCode==12 or gameManagementForm.gameParameterHistory.gameCode==13}">
							<div class="bg" >
								<table width="100%" border="0" cellspacing="0" cellpadding="0">
									<tr>
										<td class="title4"><table id="butt" width="100%" border="0" cellspacing="0" cellpadding="0" style="color:#fff;font-size:18px;">
												<tr>
													<td width="58%">Risk Control</td>
													<td width="31%" align="right" >
														<c:if test="${gameManagementForm.gameParameterHistory.isOpenRisk==1}"><img src="${basePath}/img/on_en.png"/></c:if>
														<c:if test="${gameManagementForm.gameParameterHistory.isOpenRisk==0}"><img src="${basePath}/img/off_en.png"/></c:if>
													</td>
												</tr>
											</table></td>
									</tr>
									<tr>
										<td class="nr">
										<div style="height:210px; overflow:auto;">
											<table id="riskTab" width="100%" border="0" cellspacing="0" cellpadding="0" style="font-size:14px; color:#5e6d81; line-height:30px;">
												<tr>
													<td>Threshold</td>
													<td><fmt:formatNumber type="number" value="${riskControl11X5.paramA}" /></td>
												</tr>
												<tr>
													<td>Compensation</td>
													<td><fmt:formatNumber type="number" value="${riskControl11X5.paramB}" /></td>
												</tr>
											</table>
										</div>
										</td>
									</tr>
								</table>
							</div>
						  </c:if>
					    </div>
						<div id="gamePool">
							<div class="bg" >
								<table width="100%" border="0" cellspacing="0" cellpadding="0">
									<tr>
										<td class="title"><table width="100%" border="0" cellspacing="0" cellpadding="0" style="color:#fff;font-size:18px;">
												<tr>
													<td>Pool Parameters</td>
												</tr>
											</table></td>
									</tr>
									<tr>
										<td class="nr">
										<div style="height:210px; overflow:auto;">
											<table width="100%" border="0" cellspacing="0"
												cellpadding="0" style="font-size:14px; color:#5e6d81; line-height:30px;">
												<tr>
													<td>Pool Name：${gameManagementForm.gamePool.poolName}</td>
												</tr>
												<tr>
													<td>Pool Description：${gameManagementForm.gamePool.poolDesc}</td>
												</tr>
											</table>
										</div>
										</td>
									</tr>
								</table>
							</div>
						  </div>
						</div>
					</td>
				</tr>
			</table>
		</div>
	</div>
</body>
</html>