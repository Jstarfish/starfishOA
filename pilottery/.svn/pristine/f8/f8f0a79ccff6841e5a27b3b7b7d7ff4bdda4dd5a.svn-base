<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/views/common/taglibs.jsp"%>
<html>
<head>
<title>Game Drawing</title>
<%@ include file="/views/common/meta.jsp" %>

<link type="text/css" rel="stylesheet" href="${basePath}/views/oms/game-draw/css/myStyle.css" />
<script type="text/javascript" src="${basePath}/views/oms/game-draw/js/myJs.js"></script>

<style type="text/css">

</style>

<script type="text/javascript">

function chooseGame() {
    var val = findObj('gameCode').value;
    findObj('issueNumber').value = "";

    <c:forEach items="${manualDrawList}" var="item">
        var gcode = "${item.gameCode}";
        if(val == gcode){
            findObj('issueNumber').value = "${item.issueNumber}";
            //findObj('shortName').value = "${item.shortName}";
        }
    </c:forEach>
    
    checkIssueNumber();
}

function checkIssueNumber(){       
    var bool = findObj("issueNumber").value!="";
    var result = doCheck("issueNumber",bool,'* Please select a game!');

    return result;
}

function doSubmit() {
    if(checkIssueNumber()) {
        document.gameDrawForm.submit();
    }
    return false;
}

</script>
</head>

<body>
<form action="gameDraw.do?method=chooseGame" method="post" id="gameDrawForm" name="gameDrawForm">
<div id="title">Manual Drawing</div>
<div id="mainDiv">
    <div class="jdt" style="background: url(views/oms/game-draw/img/jdt-1.gif) no-repeat left top;">
    </div>
    <div class="xd">
        <span class="zi">1. Select Game</span>
        <span>2. Organize Data</span>
        <span>3. Backup</span>
        <span>4. Result Entry</span>
        <span>5. Drawing</span>
        <span>6. Distribution</span>
        <span>7. Statistics</span>
        <span>8. Check</span>
        <span>9. Confirm</span>
    </div>
    <div class="CPage">
        <table width="900" border="0" cellpadding="0" cellspacing="0">
            <tr>
                <td width="820" align="left" valign="middle">
                    <div class="tab">
                        <table border="0" cellpadding="0" cellspacing="0" height="100%" width="100%">
                            <tr>
                                <td colspan="3" class="tit">
                                    <span style="font-size: 24px;">1. Select Game</span>
                                </td>
                            </tr>
                            <tr height="50"><td colspan="3"></td></tr>
                            <tr height="60">
                                <td width="30%" class="lz">Game:</td>
                                <td width="38%">
                                    <select id="gameCode" name="gameCode" class="my_select" onchange="chooseGame()">
                                        <option value="" selected="selected">Please select a game</option>
                                        <c:forEach items="${manualDrawList}" var="item">
                                            <option value="${item.gameCode}">${item.shortName}</option>
                                        </c:forEach>
                                    </select>
                                   
                                </td>
                                <td width="*%"><span id="issueNumberTip" class="tip_init">*</span></td>
                            </tr>
                            <tr height="60">
                                <td class="lz">
                                    <span>Issue:</span>
                                </td>
                                <td align="left">
                                    <input id="issueNumber" name="issueNumber" type="text" value="" class="my_input" readonly="readonly" style="background-color:#f2f1f1"/>
                                </td>
                                <td><span class="tip_init">*</span></td>
                            </tr>
                            <tr><td colspan="3"></td></tr>
                        </table>
                    </div>

                </td>
                <td align="right">
                    <img id="nextBtn" onclick="doSubmit()" src="views/oms/game-draw/img/right-hover.png" alt="下一步"/>
                    <a href="${basePath}/export/exportPdfFromHtmlServlet"></a>
                </td>
            </tr>
            <tr height="60">
                <td align="center" valign="middle">
		           <!-- <img src="views/oms/game-draw/img/print.png" width="124" height="29"/>
		            <img src="views/oms/game-draw/img/xian.gif" width="3" height="19" />
		            <img src="views/oms/game-draw/img/refresh.png" width="102" height="29"/> -->
                </td>
                <td></td>
            </tr>
        </table>
    </div>

</div>

</form>
</body>
</html>
