<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/views/common/taglibs.jsp"%>
<html>
<head>
<title>游戏开奖</title>
<%@ include file="/views/common/meta.jsp" %>

<script type="text/javascript" src="${basePath}/views/oms/game-draw/js/jquery-1.9.1.js"></script> 
<link type="text/css" rel="stylesheet" href="${basePath}/views/oms/game-draw/css/myStyle.css" />
<script type="text/javascript" src="${basePath}/views/oms/game-draw/js/myJs.js"></script>

<style type="text/css">

</style>


<script type="text/javascript">

function restart(){
    window.location.href="gameDraw.do?method=restart&gameCode=${gameDrawInfo.gameCode}&issueNumber=${gameDrawInfo.issueNumber}";
}
</script>

</head>
<body onload="">
<form:form id="gameDrawForm" name="gameDrawForm" method="post" action="">
<div id="title">手工开奖</div>

<div id="mainDiv">
    <div class="jdt" style="background: url(views/oms/game-draw/img/jdt-7.gif) no-repeat left top;">
    </div>
    <div class="xd">
        <span class="zi">1. 选择游戏</span>
        <span class="zi">2. 开奖数据整理</span>
        <span class="zi">3. 数据备份</span>
        <span class="zi">4. 开奖号码录入</span>
        <span class="zi">5. 中奖数据检索</span>
        <span class="zi">6. 派奖</span>
        <span class="zi">7. 生成中奖统计表</span>
        <span>8. 数据稽核</span>
        <span>9. 确认开奖</span>
    </div>
    <div class="CPage">
        <table width="900" border="0" align="center" cellpadding="0" cellspacing="0">
            <tr>
                <td width="820" align="left" valign="middle">
                    <div class="tab">
                            <table border="0" cellpadding="0" cellspacing="0" height="100%" width="100%">
                                <tr>
                                    <td colspan="4" class="tit">
                                        <span style="font-size: 24px;">7. 生成中奖统计表</span>
                                    </td>
                                </tr>
                                <tr height="10"></tr>
                                <tr height="30">
                                    <td align="right">游戏名称：</td>
                                    <td><input id="shortName" name="shortName" type="text" value="${gameDrawInfo.shortName}" class="_text"/></td>
                                    <td align="right">游戏期号：</td>
                                    <td><input id="issueNumber" name="issueNumber" type="text" value="${gameDrawInfo.issueNumber}" class="_text"/></td>
                                </tr>
                                <tr height="30">
                                    <td align="right">开奖结果：</td>
                                    <td><input id="draw_result" name="draw_result" type="text" value="${gamePrizeInfo.draw_result}" class="_text"/></td>
                                    <td align="right">投注总额：</td>
                                    <td><input id="sale_total_amount" name="sale_total_amount" type="text" value="${gamePrizeInfo.sale_total_amount}" class="_text"/></td>
                                </tr>
                                <tr height="30">
                                    <td align="right">奖池余额：</td>
                                    <td><input id="pool_left_amount" name="pool_left_amount" type="text" value="${gamePrizeInfo.pool_left_amount < 0 ? 0 : gamePrizeInfo.pool_left_amount}" class="_text"/></td>
                                    <td></td>
                                    <td></td>
                                </tr>
                                <tr height="10"></tr>
                                <tr><td colspan="4" align="center" valign="top">
                                    <table border="0" cellpadding="0" cellspacing="0" width="95%" class="tabxian">
                                     <tr class="biaot">
	                                     <td align="center">奖级</td>
	                                     <td align="center">中奖注数</td>
	                                     <td align="center">派奖金额</td>
                                     </tr>

                                     <c:forEach items="${gamePrizeInfo.prizes}" var="item">
	                                    <tr class="jjzi">
	                                     <td>${item.prize_name}</td>
	                                     <td>${item.prize_num}</td>
	                                     <td><fmt:formatNumber value="${item.prize_amount}" pattern="#,###"/></td>
	                                    </tr>
                                     </c:forEach>
                                    </table></td>
                                </tr>
                            </table>
                        </div>
                </td>
                <td align="right">
                    <a href="gameDraw.do?method=dataCheck&gameCode=${gameDrawInfo.gameCode}&issueNumber=${gameDrawInfo.issueNumber}">
                        <img id="nextBtn" style="" src="views/oms/game-draw/img/right-hover.png" alt="下一步"/>
                    </a>
                </td>
            </tr>
            <tr height="60">
                <td align="center" valign="middle">
                   <!-- <img src="views/oms/game-draw/img/print.png" width="124" height="29"/>
                   <img src="views/oms/game-draw/img/xian.gif" width="3" height="19" />
                   <a href="gameDraw.do?method=restart&gameCode=${gameDrawInfo.gameCode}&issueNumber=${gameDrawInfo.issueNumber}">
                       <img id="refreshBtn" src="views/oms/game-draw/img/refresh1.png" width="102" height="29"/>
                   </a> -->
                   
                    <span class="refresh" onclick="restart()">
                        <a href="#">重新开奖</a>
                    </span>
                </td>
            </tr>
        </table>
    </div>
</div>

</form:form>
</body>
</html>
