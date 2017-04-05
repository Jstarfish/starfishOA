<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/views/common/taglibs.jsp"%>
<html>
<head>
<title>Game Drawing</title>
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
<div id="title">Manual Drawing</div>

<div id="mainDiv">
    <div class="jdt" style="background: url(views/oms/game-draw/img/jdt-7.gif) no-repeat left top;">
    </div>
    <div class="xd">
        <span class="zi">1. Select Game</span>
        <span class="zi">2. Organize Data</span>
        <span class="zi">3. Backup</span>
        <span class="zi">4. Result Entry</span>
        <span class="zi">5. Drawing</span>
        <span class="zi">6. Distribution</span>
        <span class="zi">7. Statistics</span>
        <span>8. Check</span>
        <span>9. Confirm</span>
    </div>
    <div class="CPage">
        <table width="900" border="0" align="center" cellpadding="0" cellspacing="0">
            <tr>
                <td width="820" align="left" valign="middle">
                    <div class="tab">
                            <table border="0" cellpadding="0" cellspacing="0" height="100%" width="100%">
                                <tr>
                                    <td colspan="4" class="tit">
                                        <span style="font-size: 24px;">7. Statistics</span>
                                    </td>
                                </tr>
                                <tr height="10"></tr>
                                <tr height="30">
                                    <td align="right">Game:</td>
                                    <td><input id="shortName" name="shortName" type="text" value="${gameDrawInfo.shortName}" class="_text"/></td>
                                    <td align="right">Issue:</td>
                                    <td><input id="issueNumber" name="issueNumber" type="text" value="${gameDrawInfo.issueNumber}" class="_text"/></td>
                                </tr>
                                <tr height="30">
                                    <td align="right">Draw Result:</td>
                                    <td><input id="draw_result" name="draw_result" type="text" value="${gamePrizeInfo.draw_result}" class="_text"/></td>
                                    <td align="right">Total Bet Amount:</td>
                                    <td><input id="sale_total_amount" name="sale_total_amount" type="text" value="${gamePrizeInfo.sale_total_amount}" class="_text"/></td>
                                </tr>
                                <tr height="30">
                                    <td align="right">Pool Amount:</td>
                                    <td><input id="pool_left_amount" name="pool_left_amount" type="text" value="${gamePrizeInfo.pool_left_amount < 0 ? 0 : gamePrizeInfo.pool_left_amount}" class="_text"/></td>
                                    <td></td>
                                    <td></td>
                                </tr>
                                <tr height="10"></tr>
                                <tr><td colspan="4" align="center" valign="top">
                                    <table border="0" cellpadding="0" cellspacing="0" width="95%" class="tabxian">
                                     <tr class="biaot">
	                                     <td align="center">Prize Level:</td>
	                                     <td align="center">Winning Bets</td>
	                                     <td align="center">Prize to Distribute</td>
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
                        <a href="#">Re-drawing</a>
                    </span>
                </td>
            </tr>
        </table>
    </div>
</div>

</form:form>
</body>
</html>
