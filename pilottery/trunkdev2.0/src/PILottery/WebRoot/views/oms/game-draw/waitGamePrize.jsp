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

    var status = "${status}";

	function getData() {
	    $.ajax({
	        async:true,
	        type: 'POST',  
	        url: "gameDraw.do?method=asyncData",
	        //data:"userId=" + userId + "&username=" + username
	        timeout: 5000,
	        error: function() {
	            //alert("请求超时！");
	            return "error";
	        },
	        success: function (obj) {
	            status = JSON.parse(obj).issueStatus;
	        }
	    });
	}

	var ss = 1;
	function onProgress() {
	ss++;
	if(ss == 3) {
		window.location.href="gameDraw.do?method=dataRetrieval&gameCode=${gameDrawInfo.gameCode}&issueNumber=${gameDrawInfo.issueNumber}";
	}
	setTimeout("onProgress()",1000);
	}

    function restart(){
        window.location.href="gameDraw.do?method=restart&gameCode=${gameDrawInfo.gameCode}&issueNumber=${gameDrawInfo.issueNumber}";
    }

</script>

</head>
<body onload="onProgress()">
<form:form>
<div id="title">Manual Drawing</div>

<div id="mainDiv">
    <div class="jdt"  style="background: url(views/oms/game-draw/img/jdt-5.gif) no-repeat left top;">
    </div>
    <div class="xd">
        <span class="zi">1. Select Game</span>
        <span class="zi">2. Organize Data</span>
        <span class="zi">3. Backup</span>
        <span class="zi">4. Result Entry</span>
        <span class="zi">5. Drawing</span>
        <span>6. Distribution</span>
        <span>7. Statistics</span>
        <span>8. Check</span>
        <span>9. Confirm</span>
    </div>
    <div class="CPage">
        <table width="900" border="0" align="center" cellpadding="0" cellspacing="0">
            <tr>
                <td width="820" align="left" valign="middle">
                    <div class="tab">
                        <table border="0" cellpadding="0" cellspacing="0" height="100%" width="100%;">
                            <tr>
                                <td class="tit">
                                    <span style="font-size: 24px;">5. Drawing</span>
                                    <span style="float:right">Issue:${gameDrawInfo.issueNumber}</span>
                                    <span style="float:right">&nbsp;&nbsp;|&nbsp;&nbsp;</span>
                                    <span style="float:right">Game:${gameDrawInfo.shortName}</span>
                                </td>
                            </tr>
                            <tr height="90">
                                <td align="center">
                                    <img src="views/oms/game-draw/img/around.gif" width="120" height="120" style="margin-top:50px;"/>
                                </td>
                            </tr>
                            <tr>
                                <td align="center" height="80">
                                    <span style="color: #cac9c9;text-shadow: 1px 1px 1px #fff;">Calculating prizes, please wait...</span>
                                </td>
                            </tr>
                            <tr><td></td></tr>
                        </table>
                    </div>
                </td>
                <td align="right">
	                <a href="gameDraw.do?method=dataRetrieval&gameCode=${gameDrawInfo.gameCode}&issueNumber=${gameDrawInfo.issueNumber}">
	                    <img id="nextBtn" src="views/oms/game-draw/img/right-hover.png" alt="下一步"/>
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
