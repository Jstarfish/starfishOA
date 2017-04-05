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

	function approvePass(msg) {
        findObj('msgTip').innerText = msg;
        findObj('msgTip').style.color = "#000000";
        //findObj('p_img').style.visibility = 'hidden';
        findObj('p_img').style.display = 'none';
        findObj('disNext').style.display = 'none';
        findObj('nextBtn').style.display = 'block';
        //findObj('nextBtn').style.visibility = 'visible';
        findObj('refBtn').style.display = 'inline';
	}

    var status = "${status}";
    var matchRate = "";

    function getData() {
        $.ajax({
            async:true,
            type: 'POST',  
            url: "gameDraw.do?method=asyncData&gameCode=${gameDrawInfo.gameCode}&issueNumber=${gameDrawInfo.issueNumber}",
            //data:"userId=" + userId + "&username=" + username
	        timeout: 5000,
	        error: function() {
	            //alert("请求超时！");
	            return "error";
	        },
            success: function (obj) {
            	status = JSON.parse(obj).drawStatus;
            	matchRate = JSON.parse(obj).winnerProcess;
            }
        });
    }

    function onProgress() {

		if(status == 6) {
			matchRate= matchRate == null ? "" : matchRate;

			var str = "";
			var num1 = "";
			var num2 = "";
			var per = "";
			if(matchRate!="") {
			    var nums = matchRate.split("/");
			    num1 = nums[0];
			    num2 = nums[1];
			    per = num1/num2*100 + "%";
			    str = 'Matched Ticket Count:'
				    + num1 + '\tTotal Ticket Count:' 
				    + num2 + '\tPercentage:' + per;
			}
			
	        findObj('msgTip').innerText = 'The draw numbers have been entered correctly, waiting for processing...\n' + str;

		} else if (status >= 7) {
			approvePass('The draw numbers have been approved!');

			return;
		} else if (status == -1) {
			findObj('p_img').style.display = 'none';
	        findObj('msgTip').style.color = "#000000";
			findObj('msgTip').innerText = 'The draw numbers have been entered correctly!';
	        return;
		}

		status = getData();
		setTimeout("onProgress()",2000);
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
    <div class="jdt" style="background: url(views/oms/game-draw/img/jdt-4.gif) no-repeat left top;">
    </div>
    <div class="xd">
        <span class="zi">1. Select Game</span>
        <span class="zi">2. Organize Data</span>
        <span class="zi">3. Backup</span>
        <span class="zi">4. Result Entry</span>
        <span>5. Drawing</span>
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
                                    <span style="font-size: 24px;">4. Result Entry</span>
                                    <span style="float:right">Issue:${gameDrawInfo.issueNumber}</span>
                                    <span style="float:right">&nbsp;&nbsp;|&nbsp;&nbsp;</span>
                                    <span style="float:right">Game:${gameDrawInfo.shortName}</span>
	                            </td>
	                        </tr>
	                        <tr height="90">
	                            <td align="center">
	                                <img id="p_img" src="views/oms/game-draw/img/around.gif" width="120" height="120" style="margin-top:50px;"/>
	                            </td>
	                        </tr>
	                        <tr>
	                            <td align="center" height="80">
	                                <span id="msgTip" style="color: #cac9c9;text-shadow: 1px 1px 1px #fff;">Please wait for the second-time entry...</span>
	                            </td>
	                        </tr>
	                        <tr><td></td></tr>
	                    </table>
                    </div>
                </td>
                <td align="right">
                    <img id="disNext" src="views/oms/game-draw/img/right-disb.png" alt="下一步" width="60" height="60"/>
	                <a href="gameDraw.do?method=waitGamePrize&gameCode=${gameDrawInfo.gameCode}&issueNumber=${gameDrawInfo.issueNumber}">
	                    <img id="nextBtn" style="display:none" src="views/oms/game-draw/img/right-hover.png" alt="下一步"/>
	                </a>
                </td>
            </tr>
            <tr height="60">
                <td align="center" valign="middle">
                    <!-- <img src="views/oms/game-draw/img/print.png" width="124" height="29"/>
                    <img id="pImg" src="views/oms/game-draw/img/xian.gif" width="3" height="19" />
                    <c:choose>
	                    <c:when test="${status < 0}">
	                        <img src="views/oms/game-draw/img/refresh.png" width="102" height="29"/>
	                    </c:when>
	                    <c:otherwise> 
		                    <a href="gameDraw.do?method=restart&gameCode=${gameDrawInfo.gameCode}&issueNumber=${gameDrawInfo.issueNumber}">
		                        <img id="refreshBtn" src="views/oms/game-draw/img/refresh1.png" width="102" height="29"/>
		                    </a>
	                    </c:otherwise> 
                    </c:choose> -->
                    <span id="refBtn" class="refresh" onclick="restart()" style="display:none">
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
