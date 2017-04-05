<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<%@ include file="/views/common/taglibs.jsp" %>
<html>
<head>
    <title>Fbs Match Draw</title>
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
        function toOver() {
            location.href = "fbsDraw.do?method=initFbsDraw";
        }

        var matchStatus = "${fbsMatch.matchStatus}";
        function onProgress() {
            if (matchStatus == 6) {
                finishDraw();
                return;
            }
            matchStatus = getData();
            setTimeout("onProgress()", 2000);
        }

        function getData() {
            $.ajax({
                async: true,
                type: 'POST',
                url: "fbsDraw.do?method=queryMatchStatus&matchCode=${matchCode}",
                timeout: 5000,
                error: function () {
                    return "error";
                },
                success: function (obj) {
                    matchStatus = JSON.parse(obj).matchStatus;
                }
            });
        }

        function finishDraw() {
            $.ajax({
                async: true,
                type: 'POST',
                url: "fbsDraw.do?method=finishFbsDraw&matchCode=${matchCode}",
                timeout: 5000,
                error: function () {
                    return "error";
                },
                success: function (obj) {
                    $('#finishDraw').css("display", "block");
                    $('#roundDraw').css("display", "none");
                    $('#toOver').css("display", "block");
                }
            });
        }

    </script>
</head>
<body onload="onProgress()">
<div id="title">Draw Finish</div>
<div id="mainDiv">
    <div class="jdt"
         style="background: url(views/oms/fbs/fbsdraw/img/fbsbj-6.png) no-repeat left top;width:850px;"></div>
    <div class="xd" style="width:850px">
        <span style="margin-left: 30px;">1.Type In Result</span>
        <span style="margin-left: 25px;">2.Wait For Result</span>
        <span style="margin-left: 25px;">3.Show Result</span>
        <span style="margin-left: 25px;">4.Drawing</span>
        <span style="margin-left: 25px;">5.Show Result</span>
        <span class="zi" style="margin-left: 25px;">6.Finish</span>
    </div>
    <div class="CPage">
        <table width="80%" border="0" cellpadding="0" cellspacing="0">
            <tbody>
            <tr>
                <td align="left" valign="middle">
                    <div class="tab" style="height:500px;">
                        <table border="0" cellpadding="0" cellspacing="0" height="100%" width="100%" class="tabxian">
                            <tbody>
                            <tr>
                                <td class="tit"><span style="font-size: 24px;">6.Draw Finish </span></td>
                            </tr>
                            <tr>
                                <td align="center">
                                    <img id="roundDraw" src="views/oms/fbs/fbsdraw/img/around.gif" width="120"
                                         height="120"
                                         style="margin-top:50px;"/>
                                    <div align="center" id="finishDraw" style="
                                        display: none;
                                        padding-top: 150px;
                                        height: 38px;
                                        line-height: 38px;
                                        background: white;
                                        font-size: 24px;
                                        color: #2aa1d9;
                                        padding-left: 15px;">Draw Finish
                                    </div>
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <div align="center" id="toOver" style="display: none;padding-top: 150px">
                                        <input type="button" value="Confirm" onclick="toOver();"
                                               class="button-normal"/>
                                    </div>
                                </td>
                            </tr>
                            </tbody>
                        </table>
                    </div>
                </td>
            </tr>
            <tr height="80">
                <td align="center" valign="middle">
                </td>
                <td></td>
            </tr>
            </tbody>
        </table>
    </div>

</div>

</body>
</html>