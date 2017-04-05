<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/views/common/taglibs.jsp"%>
<html>
<head>
<title>Game Drawing</title>
<%@ include file="/views/common/meta.jsp" %>

<link type="text/css" rel="stylesheet" href="${basePath}/views/oms/game-draw/css/myStyle.css" />
<script type="text/javascript" src="${basePath}/views/oms/game-draw/js/myJs.js"></script>
<script type="text/javascript" src="${basePath}/views/oms/game-draw/js/jquery-1.9.1.js"></script> 

<link rel="stylesheet" href="${basePath}/component/messageBox/myJsBox.css" type="text/css"/>
<script type="text/javascript" src="${basePath}/component/messageBox/myJsBox.js"></script>
<style type="text/css">

</style>


<script type="text/javascript">

	function approvePass(msg) {
	    findObj('msgTip').innerText = msg;
	    findObj('msgTip').style.color = "#000000";
	    //findObj('p_img').style.visibility = 'hidden';
	    findObj('p_img').style.display = 'none';
	    //findObj('disNnext').style.display = 'none';
	    //findObj('nextBtn').style.display = 'block';
	    findObj('disPrint').style.display = 'none';
	    findObj('printBtn').style.display = 'inline';
	    //findObj('nextBtn').style.visibility = 'visible';
	}

   function approvePass2(msg) {
        findObj('msgTip').innerText = msg;
        findObj('msgTip').style.color = "#000000";
        findObj('p_img').style.display = 'none';
        findObj('_print').style.display = 'inline';
    }

    var status = 0;
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
	        }
	    });
	}

	function onProgress() {
		getData();
		if(status == 16) {
			approvePass2('Congratulations, the drawing is done!');
			return;
		}

	setTimeout("onProgress()",1000);
	}

	function print() {

		showPage('gameDraw.do?method=printDrawNotice&gameCode=${gameDrawInfo.gameCode}&issueNumber=${gameDrawInfo.issueNumber}','Draw Notice');
		//window.location.href="gameDraw.do?method=printDrawNotice&gameCode=${gameDrawInfo.gameCode}&issueNumber=${gameDrawInfo.issueNumber}";
    }

</script>

</head>
<body onload="onProgress()">
<form:form>
<div id="title">Manual Drawing</div>

<div id="mainDiv">
    <div class="jdt"  style="background: url(views/oms/game-draw/img/jdt-9.gif) no-repeat left top;">
    </div>
    <div class="xd">
        <span class="zi">1. Select Game</span>
        <span class="zi">2. Organize Data</span>
        <span class="zi">3. Backup</span>
        <span class="zi">4. Result Entry</span>
        <span class="zi">5. Drawing</span>
        <span class="zi">6. Distribution</span>
        <span class="zi">7. Statistics</span>
        <span class="zi">8. Check</span>
        <span class="zi">9. Confirm</span>
    </div>
    <div class="CPage">
        <table width="900" border="0" align="center" cellpadding="0" cellspacing="0">
            <tr>
                <td width="820" align="left" valign="middle">
                    <div class="tab">
                        <table border="0" cellpadding="0" cellspacing="0" height="100%" width="100%;">
                            <tr>
                                <td class="tit">
                                    <span style="font-size: 24px;">9. Confirm</span>
                                    <span style="float:right">Issue:${gameDrawInfo.issueNumber}</span>
                                    <span style="float:right">&nbsp;&nbsp;|&nbsp;&nbsp;</span>
                                    <span style="float:right">Game:${gameDrawInfo.shortName}</span>
                                </td>
                            </tr>
                            <tr height="90">
                                <td align="center" height="90">
                                    <img id="p_img" src="views/oms/game-draw/img/around.gif" width="120" height="120" style="margin-top:50px;"/>
                                </td>
                            </tr>
                            <tr>
                                <td align="center" height="80">
                                    <span id="msgTip" style="color: #cac9c9;text-shadow: 1px 1px 1px #fff;">Wait for the back-end to process data...</span>
                                </td>
                            </tr>
                            <tr></tr>
                        </table>
                    </div>
                </td>
                <td align="right">
	                <img id="disNnext" src="views/oms/game-draw/img/right-disb.png" alt="下一步" width="60" height="60"/>
	                <a href="#">
	                    <img id="nextBtn" style="display:none" src="views/oms/game-draw/img/right-hover.png" alt="下一步"/>
	                </a>
                </td>
            </tr>
            <tr height="60">
                <td align="center" valign="middle">
	                <!-- <img id="disPrint" src="views/oms/game-draw/img/print.png" width="124" height="29" id="printBtn" />
	                <span onclick="print()">
	                    <img id="printBtn" style="display:none;"" src="views/oms/game-draw/img/print1.png" width="124" height="29"/>
	                </span>
	                <img src="views/oms/game-draw/img/xian.gif" width="3" height="19" />
	                <img src="views/oms/game-draw/img/refresh.png" width="102" height="29"/> -->
	                
	                <span id="_print" class="print" style="display:none">
                        <a onclick="print()">Print Draw Notice</a>
                    </span>
                </td>
            </tr>
        </table>
    </div>
</div>

</form:form>
</body>
</html>
