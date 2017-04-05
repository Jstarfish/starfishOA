<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/views/common/taglibs.jsp"%>
<html>
<head>
<title>Game Drawing</title>
<%@ include file="/views/common/meta.jsp" %>

<link type="text/css" rel="stylesheet" href="${basePath}/views/oms/game-draw/css/myStyle.css" />
<script type="text/javascript" src="${basePath}/views/oms/game-draw/js/myJs.js"></script>

<link rel="stylesheet" href="${basePath}/component/messageBox/myJsBox.css" type="text/css"/>
<script type="text/javascript" src="${basePath}/component/messageBox/myJsBox.js"></script>
<style type="text/css">

</style>


<script type="text/javascript">

	var ss =1;
	function onProgress() {

		if(ss == 2) {
			if("${flg}" == "exists") {
				findObj('msg').style.color="#000000";
				findObj('msg').innerHTML='Backup complete!<br/><br/>' + 
				'${fileName} (File Size:${fileSize} kb)<br/><br/>'+
				'Total Sales Amount:<fmt:formatNumber value="${gameDrawInfo.isssueSaleAmount}" pattern="#,###"/>;&nbsp;'+
				'Tickets Sold:${gameDrawInfo.isssueSaleTickets};&nbsp;'+
				'Bets Sold:${gameDrawInfo.isssueSaleBets};';
		        //findObj('p_img').style.visibility = 'hidden';
		        findObj('p_img').style.display = 'none';
		        findObj('disNnext').style.display = 'none';
		        findObj('nextBtn').style.display = 'block';
		        findObj('oper_div').style.display = 'block';
			    return;
			} else {
		        findObj('p_img').style.display = 'none';
				findObj('msg').style.color = "red";
				findObj('msg').innerHTML='Backup file does not exist!';
	
			    return;
			}
		}

	    ss++;
        setTimeout("onProgress()",1000);
	}

    function print1() {
    	showPage('gameDraw.do?method=step3_print&type=1&gameCode=${gameDrawInfo.gameCode}&issueNumber=${gameDrawInfo.issueNumber}',
    	    	'Print Statement');

    }
	
    function print2() {
        showPage('gameDraw.do?method=step3_print&type=2&gameCode=${gameDrawInfo.gameCode}&issueNumber=${gameDrawInfo.issueNumber}',
                'Print Report');

    }
    
</script>

</head>
<body onload="onProgress()">
<form:form>
<div id="title">Manual Drawing</div>

<div id="mainDiv">
    <div class="jdt" style="background: url(views/oms/game-draw/img/jdt-3.gif) no-repeat left top;">
    </div>
    <div class="xd">
        <span class="zi">1. Select Game</span>
        <span class="zi">2. Organize Data</span>
        <span class="zi">3. Backup</span>
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
                        <table border="0" cellpadding="0" cellspacing="0" height="100%" width="100%;">
                            <tr>
                                <td class="tit">
	                                <span style="font-size: 24px;">3. Backup</span>
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
                                    <span id="msg" style="color: #cac9c9;text-shadow: 1px 1px 1px #fff;">Backing up data, please wait...</span>
                                </td>
                            </tr>
                            <tr><td></td></tr>
                        </table>
                    </div>

                </td>
                <td align="right">
                    <img id="disNnext" src="views/oms/game-draw/img/right-disb.png" alt="下一步" width="60" height="60"/>
                    <a href="gameDraw.do?method=dataBackup&gameCode=${gameDrawInfo.gameCode}&issueNumber=${gameDrawInfo.issueNumber}">
                        <img id="nextBtn" style="display:none" src="views/oms/game-draw/img/right-hover.png" alt="下一步"/>
                    </a>
                </td>
            </tr>
            <tr height="60">
                <td align="center" valign="middle">
                <div id="oper_div" style="display:none;">
                    <span class="print" onclick="print1()">
                        <a href="#">Print Statement</a>
                    </span>
                    <img src="views/oms/game-draw/img/xian.gif" width="3" height="19" style="vertical-align: middle;" />
                    <span class="print" onclick="print2()">
                        <a href="#">Print Report</a>
                    </span>
                </div>
                </td>
            </tr>
        </table>
    </div>
</div>

</form:form>
</body>
</html>
