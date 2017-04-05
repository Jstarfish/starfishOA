<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<%@ include file="/views/common/taglibs.jsp" %>
<html>
<head>
    <title>足彩比赛开奖</title>
    <%@ include file="/views/common/meta.jsp" %>
    <link rel="stylesheet" type="text/css" href="${basePath}/css/city-list.css"/>
    <link rel="stylesheet" type="text/css" href="${basePath}/css/style.css"/>
    <link type="text/css" rel="stylesheet" href="${basePath}/views/oms/game-draw/css/myStyle.css"/>

    <link rel="stylesheet" href="${basePath}/component/messageBox/myJsBox.css" type="text/css"/>
    <script type="text/javascript" src="${basePath}/component/messageBox/myJsBox_zh.js"></script>
    <script type="text/javascript" src="${basePath}/js/jquery/jquery.form.js"></script>
    <script type="text/javascript" src="${basePath}/js/jquery/jquery-1.9.1.js"></script>
    <script type="text/javascript" src="${basePath}/component/My97DatePicker/WdatePicker.js"></script>
    <script type="text/javascript" src="${basePath}/js/oms/myJs.js"></script>
    <script type="text/javascript" src="${basePath}/js/oms/city-list.js"></script>
    <script type="text/javascript">
        function approveWait(msg) {
            findObj('msgTip').innerText = msg;
            findObj('msgTip').style.color = "#000000";
            findObj('p_img').style.display = 'none';
            findObj('disNext').style.display = 'none';
            findObj('nextBtn').style.display = 'none';
        }

        function approvePass(msg) {
            findObj('msgTip').innerText = msg;
            findObj('msgTip').style.color = "#000000";
            findObj('p_img').style.display = 'none';
            findObj('disNext').style.display = 'none';
            findObj('nextBtn').style.display = 'block';
        }

        function approveConfuse(msg) {
            findObj('msgTip').innerText = msg;
            findObj('msgTip').style.color = "#000000";
            findObj('p_img').style.display = 'none';
            findObj('disNext').style.display = 'none';
            findObj('nextBtn').style.display = 'none';
            findObj('refBtn').style.display = 'inline';
        }

        var status = "${fbsMatch.drawStatus}";
        function onProgress() {
            if (status == 6) {
                approveWait('开奖号码录入成功，等待处理中...!');
            }
            if (status == 7) {
                approvePass('开奖号码确认通过');
                return;
            }
            if (status == 8) {
                approveConfuse('开奖号码审核失败，两次开奖结果不一致，请重新开奖...!');
                return;
            }

            status = getData();
            setTimeout("onProgress()", 2000);
        }

        function getData() {
            $.ajax({
                async: true,
                type: 'POST',
                url: "fbsDraw.do?method=fbsAsyncData&matchCode=${fbsMatch.matchCode}",
                timeout: 5000,
                error: function () {
                    return "error";
                },
                success: function (obj) {
                    status = JSON.parse(obj).drawStatus;
                }
            });
        }
        function formSum(matchCode) {
            window.location.href = "fbsDraw.do?method=showFbsResult&matchCode=" + matchCode;
        }
        function restart(matchCode) {
            window.location.href = "fbsDraw.do?method=restartFirstFbsDraw&matchCode=${fbsMatch.matchCode}";
        }
    </script>
</head>
<body onload="onProgress()">
<div id="title">第一次开奖</div>
<div id="mainDiv">
    <div class="jdt"
         style="background: url(views/oms/fbs/fbsdraw/img/fbsbj-2.png) no-repeat left top;width:850px;"></div>
    <div class="xd" style="width:850px">
        <span style="margin-left: 30px;">1.录入比赛结果</span>
        <span class="zi" style="margin-left: 25px;">2.等待再次录入开奖数据</span>
        <span style="margin-left: 25px;">3.显示比赛结果</span>
        <span style="margin-left: 25px;">4.开奖中</span>
        <span style="margin-left: 25px;">5.显示开奖结果</span>
        <span style="margin-left: 25px;">6.开奖完成</span>
    </div>
    <div class="CPage">
        <table width="100%" cellpadding="0" cellspacing="0">
            <tr height="90">
                <td align="center">
                    <img id="p_img" src="views/oms/fbs/fbsdraw/img/around.gif" width="120" height="120"
                         style="margin-top:50px;"/>
                </td>
            </tr>
            <tr>
                <td align="center" height="80">
                    <span id="msgTip" style="color: #cac9c9;text-shadow: 1px 1px 1px #fff;">正在等待第二次录入，请稍后...</span>
                </td>
            </tr>
            <tr>
                <td align="center">
                    <img id="disNext" style="display:none" src="views/oms/fbs/fbsdraw/img/right-disb.png" alt="下一步"
                         width="60" height="60"/>
                    <a href="#">
                        <img id="nextBtn" style="display:none" src="views/oms/fbs/fbsdraw/img/right-hover.png"
                             onclick="formSum(${fbsMatch.matchCode})" alt="下一步"/>
                    </a>
                </td>
            </tr>
            <tr height="60">
                <td align="center" valign="middle">
                    <span id="refBtn" class="refresh" onclick="restart(${fbsMatch.matchCode})" style="display:none">
                        <a href="#">重新开奖</a>
                    </span>

                </td>
            </tr>
        </table>
    </div>

</div>

</body>
</html>