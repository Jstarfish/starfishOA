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
<div id="title">${gameManagementForm.gameInfo.shortName}&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;期次：${issueNumber}</div>
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
													<td width="51%">游戏基本参数</td>
												</tr>
											</table></td>
									</tr>
									<tr>
										<td class="nr" >
										<div style="height:210px; overflow:auto;">
											<table width="100%" border="0" cellspacing="0"
												cellpadding="0" style="font-size:14px; color:#5e6d81; line-height:30px;">
												<tr>
													<td>游戏编码：${gameManagementForm.gameInfo.gameCode}</td>
												</tr>
												<tr>
													<td>游戏标识：${gameManagementForm.gameInfo.gameMark}</td>
												</tr>
												<tr>
													<td>游戏名称：${gameManagementForm.gameInfo.fullName}</td>
												</tr>
												<tr>
													<td>游戏缩写：${gameManagementForm.gameInfo.shortName}</td>
												</tr>
												<tr>
													<td>游戏类型：
														<c:if test="${gameManagementForm.gameInfo.basicType==1}">基诺</c:if>
														<c:if test="${gameManagementForm.gameInfo.basicType==2}">乐透</c:if>
														<c:if test="${gameManagementForm.gameInfo.basicType==3}">数字</c:if>
													</td>
												</tr>
												<tr>
													<td>发行单位名称：${gameManagementForm.gameInfo.issuingOrganization}</td>
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
													<td width="51%">政策参数</td>
												</tr>
											</table></td>
									</tr>
									<tr>
										<td class="nr">
										<div style="height:210px; overflow:auto;">
											<table width="100%" border="0" cellspacing="0"
												cellpadding="0" style="font-size:14px; color:#5e6d81; line-height:30px;">
												<tr>
													<td>理论返奖率：${gameManagementForm.gamePolicyParam.theoryRate} ‰</td>
												</tr>
												<tr>
													<td>公益金比例：${gameManagementForm.gamePolicyParam.fundRate} ‰</td>
												</tr>
												<tr>
													<td>调节基金比例：${gameManagementForm.gamePolicyParam.adjRate} ‰</td>
												</tr>
												<tr>
													<td>中奖缴税起征点：${gameManagementForm.gamePolicyParam.taxThreshold}
													</td>
												</tr>
												<tr>
													<td>中奖缴税比例：${gameManagementForm.gamePolicyParam.taxRate} ‰</td>
												</tr>
												<tr>
													<td>兑奖期：${gameManagementForm.gamePolicyParam.drawLimitDay} </td>
												</tr>
											</table>
										</div>
										</td>
									</tr>
								</table>
							</div>
						  </div>
						  <!-- 
						  <div id="gameParameter">
							<div class="bg" >
								<table width="100%" border="0" cellspacing="0" cellpadding="0">
									<tr>
										<td class="title2"><table width="100%" border="0" cellspacing="0" cellpadding="0" style="color:#fff;font-size:18px;">
												<tr>
													<td>普通规则参数</td>
												</tr>
											</table></td>
									</tr>
									<tr>
										<td class="nr">
										<div style="height:210px; overflow:auto;">
											<table width="100%" border="0" cellspacing="0"
												cellpadding="0" style="font-size:14px; color:#5e6d81; line-height:30px;">
												<tr>
													<td>开奖模式：<c:if test="${gameManagementForm.normalRuleParameter.drawMode==1}">快开</c:if>
															<c:if test="${gameManagementForm.normalRuleParameter.drawMode==2}">内部算奖</c:if>
															<c:if test="${gameManagementForm.normalRuleParameter.drawMode==3}">外部算奖</c:if>
													</td>
												</tr>
												<tr>
													<td>单注投注金额：${gameManagementForm.normalRuleParameter.singleBetAmount}</td>
												</tr>
												<tr>
													<td>多期销售限制：${gameManagementForm.normalRuleParameter.singleTicketMaxIssues}</td>
												</tr>
												<tr>
													<td>单行最大倍数：${gameManagementForm.normalRuleParameter.singleLineMaxAmount}</td>
												</tr>
												<tr>
													<td>单票最大投注行数：${gameManagementForm.normalRuleParameter.singleTicketMaxLine}</td>
												</tr>
												<tr>
													<td>单票最大销售限额：${gameManagementForm.normalRuleParameter.singleTicketMaxAmount}</td>

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
													<td>游戏控制参数</td>
												</tr>
											</table></td>
									</tr>
									<tr>
										<td class="nr">
										<div style="height:210px; overflow:auto;">
											<table width="100%" border="0" cellspacing="0"
												cellpadding="0" style="font-size:14px; color:#5e6d81; line-height:30px;">
												<tr>
													<td>大奖金额：${gameManagementForm.controlParameter.limitBigPrize}</td>
												</tr>
												<tr>
													<td>游戏兑奖限额：${gameManagementForm.controlParameter.limitPayment}</td>
												</tr>
												<tr>
													<td>允许退票时间：${gameManagementForm.controlParameter.cancelSec} 秒</td>
												</tr>
												<tr>
													<td>销售关闭倒数提醒：${gameManagementForm.controlParameter.issueCloseAlertTime} 秒</td>
												</tr>
												<tr>
													<td>普通销售员兑奖限额：${gameManagementForm.controlParameter.salerPayLimit}</td>
												</tr>
												<tr>
													<td>普通销售员退票限额：${gameManagementForm.controlParameter.salerCancelLimit}</td>
												</tr>
												<tr>
													<td>一级区域兑奖限额：${gameManagementForm.controlParameter.limitPayment2}</td>
												</tr>
												<tr>
													<td>一级区域退票限额：${gameManagementForm.controlParameter.limitCancel2}</td>
												</tr>
											</table>
										</div>
										</td>
									</tr>
								</table>
							</div>
						  </div>
						   -->
						  <div id="gameRule">
							<div class="bg" >
								<table width="100%" border="0" cellspacing="0" cellpadding="0">
									<tr>
										<td class="title2"><table width="100%" border="0" cellspacing="0" cellpadding="0" style="color:#fff;font-size:18px;">
												<tr>
													<td>玩法规则</td>
												</tr>
											</table></td>
									</tr>
									<tr>
										<td class="nr">
										<div style="height:210px; overflow:auto;">
											<table width="100%" border="0" cellspacing="0"
												cellpadding="0" style="font-size:14px; color:#5e6d81; line-height:30px;" >
												<tr>
													<td width="40%">玩法名称</td><td>规则描述</td>
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
													<td>游戏中奖规则</td>
												</tr>
											</table></td>
									</tr>
									<tr>
										<td class="nr">
										<div style="height:210px; overflow:auto;">
											<table width="100%" border="0" cellspacing="0"
												cellpadding="0" style="font-size:14px; color:#5e6d81; line-height:30px;">
												<tr>
													<td width="40%">规则名称</td>
													<td>规则描述</td>
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
													<td>奖级规则</td>
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
										          	<td colspan="3">是否启用特殊奖级： 
											            <c:if test="${gameManagementForm.isSpecial==1}">是</c:if>
											            <c:if test="${gameManagementForm.isSpecial==0}">否</c:if>
										       	 	</td>
										       	</tr>
												</c:if>
												<c:if test="${gameManagementForm.gameInfo.gameCode == 7}">
												<tr>
										          	<td colspan="3">保底金额： 
											            <fmt:formatNumber type="number" value="${gameManagementForm.fdbd}" />
										       	 	</td>
										       	</tr>
										       	<tr>
										          	<td colspan="3">封顶金额： 
											            <fmt:formatNumber type="number" value="${gameManagementForm.fdfd}" />
										       	 	</td>
										       	</tr>
										       	<tr>
										          	<td colspan="3">抹零金额： 
											            <fmt:formatNumber type="number" value="${gameManagementForm.fdmin}" />
										       	 	</td>
										       	</tr>
												</c:if>
												<tr>
													<td width="50%">奖级名称</td>
													<td width="50%">奖级奖金</td>
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
						  <c:if test="${gameManagementForm.gameParameterHistory.gameCode==6}">
							<div class="bg" >
								<table width="100%" border="0" cellspacing="0" cellpadding="0">
									<tr>
										<td class="title4"><table id="butt" width="100%" border="0" cellspacing="0" cellpadding="0" style="color:#fff;font-size:18px;">
												<tr>
													<td width="58%">游戏风控</td>
													<td width="31%" align="right" >
														<c:if test="${gameManagementForm.gameParameterHistory.isOpenRisk==1}"><img src="${basePath}/img/on.png"/></c:if>
														<c:if test="${gameManagementForm.gameParameterHistory.isOpenRisk==0}"><img src="${basePath}/img/off.png"/></c:if>
													</td>
												</tr>
											</table></td>
									</tr>
									<tr>
										<td class="nr">
										<div style="height:210px; overflow:auto;">
											<table id="riskTab" width="100%" border="0" cellspacing="0" cellpadding="0" style="font-size:14px; color:#5e6d81; line-height:30px;">
												<tr>
													<td width="33%">玩法名称</td>
													<td width="33%">风控阈值</td>
													<td width="34%">最大赔付金额</td>
												</tr>
												<c:forEach var="s" items="${riskControlList}" >
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
						<c:if test="${gameManagementForm.gameParameterHistory.gameCode==5 || gameManagementForm.gameParameterHistory.gameCode==11 || gameManagementForm.gameParameterHistory.gameCode==12}">
							<div class="bg" >
								<table width="100%" border="0" cellspacing="0" cellpadding="0">
									<tr>
										<td class="title4"><table id="butt" width="100%" border="0" cellspacing="0" cellpadding="0" style="color:#fff;font-size:18px;">
												<tr>
													<td width="58%">游戏风控</td>
													<td width="31%" align="right" >
														<c:if test="${gameManagementForm.gameParameterHistory.isOpenRisk==1}"><img src="${basePath}/img/on.png"/></c:if>
														<c:if test="${gameManagementForm.gameParameterHistory.isOpenRisk==0}"><img src="${basePath}/img/off.png"/></c:if>
													</td>
												</tr>
											</table></td>
									</tr>
									<tr>
										<td class="nr">
										<div style="height:210px; overflow:auto;">
											<table id="riskTab" width="100%" border="0" cellspacing="0" cellpadding="0" style="font-size:14px; color:#5e6d81; line-height:30px;">
												<tr>
													<td>风控阈值</td>
													<td><fmt:formatNumber type="number" value="${riskControl.temp_riskThreshold}" /></td>
												</tr>
												<tr>
													<td>最大赔付金额</td>
													<td><fmt:formatNumber type="number" value="${riskControl.temp_maxClaimsAmount}" /></td>
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
													<td>游戏奖池参数</td>
												</tr>
											</table></td>
									</tr>
									<tr>
										<td class="nr">
										<div style="height:210px; overflow:auto;">
											<table width="100%" border="0" cellspacing="0"
												cellpadding="0" style="font-size:14px; color:#5e6d81; line-height:30px;">
												<tr>
													<td>奖池名称：${gameManagementForm.gamePool.poolName}</td>
												</tr>
												<tr>
													<td>奖池描述：${gameManagementForm.gamePool.poolDesc}</td>
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