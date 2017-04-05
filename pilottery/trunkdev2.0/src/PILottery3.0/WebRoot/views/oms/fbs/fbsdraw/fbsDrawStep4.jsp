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
        var matchStatus = "${fbsMatch.matchStatus}";
        function onProgress() {
            if (matchStatus == 5) {
                window.location.href = "fbsDraw.do?method=queryDrawResult&matchCode=" +${matchCode};
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
    </script>
</head>
<body onload="onProgress()">
<div id="title">Drawing</div>
<div id="mainDiv">
    <div class="jdt"
         style="background: url(views/oms/fbs/fbsdraw/img/fbsbj-4.png) no-repeat left top;width:850px;"></div>
    <div class="xd" style="width:850px">
        <span style="margin-left: 30px;">1.Type In Result</span>
        <span style="margin-left: 25px;">2.Wait For Result</span>
        <span style="margin-left: 25px;">3.Show Result</span>
        <span class="zi" style="margin-left: 25px;">4.Drawing</span>
        <span style="margin-left: 25px;">5.Show Result</span>
        <span style="margin-left: 25px;">6.Finish</span>
    </div>
    <div class="CPage">
        <table width="100%" cellpadding="0" cellspacing="0">
            <tr height="90">
                <td align="center">
                    <img id="p_img" src="views/oms/fbs/fbsdraw/img/around.gif" width="120" height="120"
                         style="margin-top:50px;"/>
                </td>
            </tr>
        </table>
    </div>

</div>

</body>
</html>