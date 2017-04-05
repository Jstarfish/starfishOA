<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/views/common/taglibs.jsp"%>
<html>
<head>
<title>游戏开奖</title>
<%@ include file="/views/common/meta.jsp" %>

<link type="text/css" rel="stylesheet" href="${basePath}/views/oms/game-draw/css/myStyle.css" />
<script type="text/javascript" src="${basePath}/views/oms/game-draw/js/myJs.js"></script>

<link rel="stylesheet" href="${basePath}/component/messageBox/myJsBox.css" type="text/css"/>
<script type="text/javascript" src="${basePath}/component/messageBox/myJsBox_zh.js"></script>
<style type="text/css">

</style>


<script type="text/javascript">

	var ss =1;
	function onProgress() {

		if(ss == 2) {
			if("${flg}" == "exists") {
				findObj('msg').style.color="#000000";
				findObj('msg').innerHTML='备份完成!<br/><br/>' + 
				'${fileName} (文件大小：${fileSize} kb)<br/><br/>'+
				'销售金额:<fmt:formatNumber value="${gameDrawInfo.isssueSaleAmount}" pattern="#,###"/>;&nbsp;'+
				'销售票数:${gameDrawInfo.isssueSaleTickets};&nbsp;'+
				'销售注数:${gameDrawInfo.isssueSaleBets};';
		        //findObj('p_img').style.visibility = 'hidden';
		        findObj('p_img').style.display = 'none';
		        findObj('disNnext').style.display = 'none';
		        findObj('nextBtn').style.display = 'block';
		        findObj('oper_div').style.display = 'block';
			    return;
			} else {
		        findObj('p_img').style.display = 'none';
				findObj('msg').style.color = "red";
				findObj('msg').innerHTML='备份文件不存在!';
	
			    return;
			}
		}

	    ss++;
        setTimeout("onProgress()",1000);
	}

    function print1() {
    	showPage('gameDraw.do?method=step3_print&type=1&gameCode=${gameDrawInfo.gameCode}&issueNumber=${gameDrawInfo.issueNumber}',
    	    	'打印报表');

    }
	
    function print2() {
        showPage('gameDraw.do?method=step3_print&type=2&gameCode=${gameDrawInfo.gameCode}&issueNumber=${gameDrawInfo.issueNumber}',
                '打印报告单');

    }
    
</script>

</head>
<body onload="onProgress()">
<form:form>
<div id="title">手工开奖</div>

<div id="mainDiv">
    <div class="jdt" style="background: url(views/oms/game-draw/img/jdt-3.gif) no-repeat left top;">
    </div>
    <div class="xd">
        <span class="zi">1. 选择游戏</span>
        <span class="zi">2. 开奖数据整理</span>
        <span class="zi">3. 数据备份</span>
        <span>4. 开奖号码录入</span>
        <span>5. 中奖数据检索</span>
        <span>6. 派奖</span>
        <span>7. 生成中奖统计表</span>
        <span>8. 数据稽核</span>
        <span>9. 确认开奖</span>
    </div>
    <div class="CPage">
        <table width="900" border="0" cellpadding="0" cellspacing="0">
            <tr>
                <td width="820" align="left" valign="middle">
                    <div class="tab">
                        <table border="0" cellpadding="0" cellspacing="0" height="100%" width="100%;">
                            <tr>
                                <td class="tit">
	                                <span style="font-size: 24px;">3. 数据备份</span>
	                                <span style="float:right">游戏期号：${gameDrawInfo.issueNumber}</span>
	                                <span style="float:right">&nbsp;&nbsp;|&nbsp;&nbsp;</span>
	                                <span style="float:right">游戏名称：${gameDrawInfo.shortName}</span>
                                </td>
                            </tr>
                            <tr height="90">
                                <td align="center">
                                    <img id="p_img" src="views/oms/game-draw/img/around.gif" width="120" height="120" style="margin-top:50px;"/>
                                </td>
                            </tr>
                            <tr>
                                <td align="center" height="80">
                                    <span id="msg" style="color: #cac9c9;text-shadow: 1px 1px 1px #fff;">正在备份数据，请稍等...</span>
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
                        <a href="#">打印报表</a>
                    </span>
                    <img src="views/oms/game-draw/img/xian.gif" width="3" height="19" style="vertical-align: middle;" />
                    <span class="print" onclick="print2()">
                        <a href="#">打印报告单</a>
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
