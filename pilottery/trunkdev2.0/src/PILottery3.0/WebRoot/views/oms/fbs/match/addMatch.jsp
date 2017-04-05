<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<%@ include file="/views/common/taglibs.jsp" %>
<html>
<head>

    <title>New Match</title>

    <%@ include file="/views/common/meta.jsp" %>
    <link rel="stylesheet" type="text/css" href="${basePath}/css/style.css"/>
    <link rel="stylesheet" type="text/css" href="${basePath}/css/pop-up.css"/>
    <link rel="stylesheet" type="text/css" href="${basePath}/css/validate.css"/>
    <link rel="stylesheet" href="${basePath}/component/messageBox/myJsBox.css"
          type="text/css"/>
    <script type="text/javascript" src="${basePath}/component/messageBox/myJsBox.js"></script>
    <script type="text/javascript" src="${basePath}/js/myJs_zh.js"></script>
    <script type="text/javascript" src="${basePath}/js/jquery/jquery-1.9.1.js"></script>
    <script type="text/javascript" src="${basePath}/component/My97DatePicker/WdatePicker.js"></script>

    <script type="text/javascript" charset="UTF-8">
        function switchTeams() {
            var competition = $('#competition').val();
            $('#homeTeamCode').empty();
            $('#guestTeamCode').empty();
            $('#homeTeamCode').append("<option value=''>--Please Select--</option>");
            $('#guestTeamCode').append("<option value=''>--Please Select--</option>");
            if (competition == '') {
                return false;
            }

            $.ajax({
                url: "fbsGame.do?method=getTeamsByComptt&competition=" + competition,
                dataType: "json",
                async: false,
                success: function (result) {
                    if (result != '' && result != null) {
                        for (var i = 0; i < result.length; i++) {
                            $('#homeTeamCode').append("<option value='" + result[i].teamCode + "'>" + result[i].shortName + "</option>");
                            $('#guestTeamCode').append("<option value='" + result[i].teamCode + "'>" + result[i].shortName + "</option>");
                        }
                    }
                }
            });
        }

        function doClose() {
            window.parent.closeBox();
        }

        function isNull(data) {
            return (data == "" || data == undefined || data == null);
        }

        $(document).ready(
                function () {
                    $("#okButton").bind(
                            "click",
                            function () {
                                var result = true;
                                if (isNull(trim($("#matchCode").val()))) {
                                    ckSetFormOjbErrMsg('matchCode', 'Not Empty');
                                    result = false;
                                }
                                if (isNull(trim($("#competition").val()))) {
                                    ckSetFormOjbErrMsg('competition', 'Not Empty');
                                    result = false;
                                }
                                if (isNull(trim($("#fbsIssueNumber").val()))) {
                                    ckSetFormOjbErrMsg('fbsIssueNumber', 'Not Empty');
                                    result = false;
                                }
                                if (isNull(trim($("#matchStartDate").val()))) {
                                    ckSetFormOjbErrMsg('matchStartDate', 'Not Empty');
                                    result = false;
                                }
                                if (isNull(trim($("#matchEndDate").val()))) {
                                    ckSetFormOjbErrMsg('matchEndDate', 'Not Empty');
                                    result = false;
                                }
                                if (isNull(trim($("#beginSaleDate").val()))) {
                                    ckSetFormOjbErrMsg('beginSaleDate', 'Not Empty');
                                    result = false;
                                }
                                if (isNull(trim($("#endSaleDate").val()))) {
                                    ckSetFormOjbErrMsg('endSaleDate', 'Not Empty');
                                    result = false;
                                }
                                if (isNull(trim($("#homeTeamCode").val()))) {
                                    ckSetFormOjbErrMsg('homeTeamCode', 'Not Empty');
                                    result = false;
                                }
                                if (isNull(trim($("#guestTeamCode").val()))) {
                                    ckSetFormOjbErrMsg('guestTeamCode', 'Not Empty');
                                    result = false;
                                }
                                if (isNull(trim($("#winLevelLosScore").val()))) {
                                    ckSetFormOjbErrMsg('winLevelLosScore', 'Not Empty');
                                    result = false;
                                }

                                if (result) {
                                    $("#matchForm").submit();
                                }
                            });
                });
        function setMatchCode(dateVal) {
            $.ajax({
                url: "fbsGame.do?method=setMatchCode&matchDate=" + dateVal + "&issueCode=" +${issueNumber},
                dataType: "json",
                async: false,
                success: function (result) {
                    $("#matchCode").val(result);

                    $("#matchEndDate").val("");
                    $("#beginSaleDate").val("");
                    $("#endSaleDate").val("");
                }
            });
        }
        function checkThisVlue(obj) {
            var guestTeam = $(obj).val();
            var homeTeam = $('#homeTeamCode').val();
            if (homeTeam == guestTeam) {
                document.getElementById("guestTeamCodeTip").innerHTML = 'The team is same as home team';
                $("#guestTeamCodeTip").css("color", "red");
                $(obj).val(0);
            } else {
                document.getElementById("guestTeamCodeTip").innerHTML = '';
            }
        }
        function checkHomeVlue(obj) {
            var homeTeam = $(obj).val();
            var guestTeam = $('#guestTeamCode').val();
            if (homeTeam == guestTeam) {
                document.getElementById("homeTeamCodeTip").innerHTML = 'The team is same as guest team';
                $("#homeTeamCodeTip").css("color", "red");
                $(obj).val(0);
            } else {
                document.getElementById("homeTeamCodeTip").innerHTML = '';
            }
        }
        function checkPreDate(idVal, obj, nextObj) {
            if (nextObj != '') {
                $('#' + nextObj).val("");
            }
            var dateStr = $('#' + idVal).val();
            if (dateStr == '') {
                $(obj).val("");
            }
        }
    </script>
    <style type="text/css">
        .pop-body table tr td {
            padding: 10px 5px;
        }
    </style>
</head>
<body>
<form action="fbsGame.do?method=addMatch" id="matchForm" method="POST">
    <div class="pop-body">
        <table width="100%" border="0" cellspacing="0" cellpadding="0">
            <tr>
                <td align="right" width="30%">Match No.：</td>
                <td align="left">
                    <input id="matchCode" name="matchCode" class="text-big-noedit" maxLength="10"
                           readonly="readonly"/>
                    <span id="matchCodeTip" class="tip_init"> *1~10 Number </span>
                </td>
            </tr>
            <tr>
                <td align="right">Competition：</td>
                <td align="left">
                    <select name="competition" class="select-big" id="competition" onchange="switchTeams();">
                        <option value="">--Please Select--</option>
                        <c:forEach var="data" items="${competitionList}">
                            <option value="${data.competitionCode}">${data.competitionName }</option>
                        </c:forEach>
                    </select>
                    <span id="competitionTip" class="tip_init"> *</span></td>
            </tr>
            <tr>
                <td align="right">Issue：</td>
                <td align="left">
                    <input id="fbsIssueNumber" name="fbsIssueNumber"
                           value="${issueNumber}" class="text-big" maxLength="10"
                           oninput="this.value=this.value.replace(/[^\d,]/g,'')"/>
                    <span id="fbsIssueNumberTip" class="tip_init"></span>
                </td>
            </tr>
            <tr>
                <td align="right">Match Begin Time：</td>
                <td align="left">
                    <input id="startIssueTime" value="${issueStart}" type="hidden"/>
                    <input id="endIssueTime" value="${issueEnd}" type="hidden"/>
                    <input id="matchStartDate" name="matchStartDate" class="Wdate text-big"
                           onfocus="WdatePicker({lang:'zh',minDate:'#F{$dp.$D(\'startIssueTime\')}',maxDate:'#F{$dp.$D(\'endIssueTime\')}',dateFmt:'yyyy-MM-dd HH:mm:ss'})"
                           onchange="setMatchCode(this.value)"
                           onblur="setMatchCode(this.value)" maxlength="40"/>
                    <span id="matchStartDateTip" class="tip_init"></span>
                </td>
            </tr>
            <tr>
                <td align="right">Match End Time：</td>
                <td align="left">
                    <input id="matchEndDate" name="matchEndDate" class="Wdate text-big"
                           onfocus="WdatePicker({lang:'zh',minDate:'#F{$dp.$D(\'matchStartDate\')}',
							   maxDate:'#F{$dp.$D(\'endIssueTime\')}',dateFmt:'yyyy-MM-dd HH:mm:ss'})"
                           maxlength="40" onchange="checkPreDate('matchStartDate',this,'beginSaleDate')"/>
                    <span id="matchEndDateTip" class="tip_init"></span>
                </td>
            </tr>
            <tr>
                <td align="right">Sale Begin Time：</td>
                <td align="left">
                    <input id="beginSaleDate" name="beginSaleDate" class="Wdate text-big"
                           onfocus="WdatePicker({lang:'zh',maxDate:'#F{$dp.$D(\'matchStartDate\')}',
							   dateFmt:'yyyy-MM-dd HH:mm:ss'})" maxlength="40"
                           onchange="checkPreDate('matchEndDate',this,'endSaleDate')"/>
                    <span id="beginSaleDateTip" class="tip_init"></span>
                </td>
            </tr>
            <tr>
                <td align="right">Sale End Time：</td>
                <td align="left">
                    <input id="endSaleDate" name="endSaleDate" class="Wdate text-big"
                           onfocus="WdatePicker({lang:'zh',maxDate:'#F{$dp.$D(\'matchStartDate\')}',
							   minDate:'#F{$dp.$D(\'beginSaleDate\')}',
							   dateFmt:'yyyy-MM-dd HH:mm:ss'})" maxlength="40"
                           onchange="checkPreDate('beginSaleDate',this,'')"/>
                    <span id="endSaleDateTip" class="tip_init"></span>
                </td>
            </tr>
            <tr>
                <td align="right">Home Team：</td>
                <td align="left">
                    <select name="homeTeamCode" class="select-big" id="homeTeamCode"
                            onchange="checkHomeVlue(this)">
                        <option value="">--Please Select--</option>
                    </select>
                    <span id="homeTeamCodeTip" class="tip_init"></span>
                </td>
            </tr>
            <tr>
                <td align="right">Guest Team：</td>
                <td align="left">
                    <select name="guestTeamCode" class="select-big" id="guestTeamCode"
                            onchange="checkThisVlue(this)">
                        <option value="">--Please Select--</option>
                    </select>
                    <span id="guestTeamCodeTip" class="tip_init"></span>
                </td>
            </tr>
            <tr>
                <td align="right">310 Handicap：</td>
                <td align="left">
                    <select name="winLevelLosScore" class="select-big" id="winLevelLosScore">
                        <option value="-7">-7</option>
                        <option value="-6">-6</option>
                        <option value="-5">-5</option>
                        <option value="-4">-4</option>
                        <option value="-3">-3</option>
                        <option value="-2">-2</option>
                        <option value="-1">-1</option>
                        <option value="0">0</option>
                        <option value="1">1</option>
                        <option value="2">2</option>
                        <option value="3">3</option>
                        <option value="4">4</option>
                        <option value="5">5</option>
                        <option value="6">6</option>
                        <option value="7">7</option>
                    </select>
                    <span id="winLevelLosScoreTip" class="tip_init"> * Number </span>
                </td>
            </tr>
            <tr>
                <td align="right">30 Handicap：</td>
                <td align="left">
                    <select name="winLosScore" class="select-big" id="winLosScore">
                        <option value="-7.5">-7.5</option>
                        <option value="-6.5">-6.5</option>
                        <option value="-5.5">-5.5</option>
                        <option value="-4.5">-4.5</option>
                        <option value="-3.5">-3.5</option>
                        <option value="-2.5">-2.5</option>
                        <option value="-1.5">-1.5</option>
                        <option value="-0.5">-0.5</option>
                        <option value="0.5">0.5</option>
                        <option value="1.5">1.5</option>
                        <option value="2.5">2.5</option>
                        <option value="3.5">3.5</option>
                        <option value="4.5">4.5</option>
                        <option value="5.5">5.5</option>
                        <option value="6.5">6.5</option>
                        <option value="7.5">7.5</option>
                    </select>
                    <span id="winLosScoreTip" class="tip_init"> * Number </span>
                </td>
            </tr>

        </table>
    </div>

    <div class="pop-footer">
			<span class="left"> 
				<input id="okButton" type="button" value='Submit' class="button-normal"></input>
			</span> 
			<span class="right"> 
				<input type="button" value="Cancel" onclick="doClose();" class="button-normal"></input>
			</span>
    </div>

</form>
</body>
</html>