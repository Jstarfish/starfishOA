<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/views/common/taglibs.jsp"%>
<html>
<head>
<title>游戏开奖</title>
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
<div id="title">手工开奖</div>

<div id="mainDiv">
    <div class="jdt"  style="background: url(views/oms/game-draw/img/jdt-5.gif) no-repeat left top;">
    </div>
    <div class="xd">
        <span class="zi">1. 选择游戏</span>
        <span class="zi">2. 开奖数据整理</span>
        <span class="zi">3. 数据备份</span>
        <span class="zi">4. 开奖号码录入</span>
        <span class="zi">5. 中奖数据检索</span>
        <span>6. 派奖</span>
        <span>7. 生成中奖统计表</span>
        <span>8. 数据稽核</span>
        <span>9. 确认开奖</span>
    </div>
    <div class="CPage">
        <table width="900" border="0" align="center" cellpadding="0" cellspacing="0">
            <tr>
                <td width="820" align="left" valign="middle">
                    <div class="tab">
                        <table border="0" cellpadding="0" cellspacing="0" height="100%" width="100%;">
                            <tr>
                                <td class="tit">
                                    <span style="font-size: 24px;">5. 中奖数据检索</span>
                                    <span style="float:right">游戏期号：${gameDrawInfo.issueNumber}</span>
                                    <span style="float:right">&nbsp;&nbsp;|&nbsp;&nbsp;</span>
                                    <span style="float:right">游戏名称：${gameDrawInfo.shortName}</span>
                                </td>
                            </tr>
                            <tr height="90">
                                <td align="center">
                                    <img src="views/oms/game-draw/img/around.gif" width="120" height="120" style="margin-top:50px;"/>
                                </td>
                            </tr>
                            <tr>
                                <td align="center" height="80">
                                    <span style="color: #cac9c9;text-shadow: 1px 1px 1px #fff;">正在算奖，请稍等...</span>
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
