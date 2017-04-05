<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<%@ include file="/views/common/taglibs.jsp" %>
<html>
<head>
    <title>Match Details</title>

    <link rel="stylesheet" type="text/css" href="${basePath}/css/pop-up.css"/>

    <script type="text/javascript" src="${basePath}/js/myJs.js"></script>
    <script type="text/javascript" src="${basePath}/js/jquery/jquery-1.9.1.js"></script>
    <script type="text/javascript">
        function doClose() {
            window.parent.closeBox();
        }
    </script>
</head>
<body>
<div id="tck">
    <div class="mid">
        <table width="100%" border="0" cellspacing="0" cellpadding="0">
            <tr>
                <td align="right" width="25%">Match No.：</td>
                <td align="left" width="25%">${match.matchCode}</td>
                <td align="right" width="25%">Issue：</td>
                <td align="left">${match.fbsIssueNumber}</td>
            </tr>
            <tr>

                <td align="right">Sale Status：</td>
                <td align="left">
                    <c:choose>
                        <c:when test="${match.isSale==1 }">Sale </c:when>
                        <c:when test="${match.isSale!=1 }">Sale Forbid</c:when>
                    </c:choose>
                </td>
                <td align="right">Match Status：</td>
                <td align="left">
                    <c:choose>
                        <c:when test="${match.status==1 }">Arranged</c:when>
                        <c:when test="${match.status==2 }">Opened</c:when>
                        <c:when test="${match.status==3 }">Closed</c:when>
                        <c:when test="${match.status==4 }">Drawing</c:when>
                        <c:when test="${match.status==5 }">Reward Completed</c:when>
                        <c:when test="${match.status==6 }">Draw Finished</c:when>
                    </c:choose>
                </td>
            </tr>
            <tr>
                <td align="right">Home Team：</td>
                <td align="left">${match.homeTeamName}</td>
                <td align="right">Guest Team：</td>
                <td align="left">${match.guestTeamName}</td>
            </tr>
            <tr>
                <td align="right">Match Begin Time：</td>
                <td align="left"><fmt:formatDate value="${match.matchStartDate}" pattern="yyyy-MM-dd HH:mm:ss"/></td>
                <td align="right">Match End Time：</td>
                <td align="left"><fmt:formatDate value="${match.matchEndDate}" pattern="yyyy-MM-dd HH:mm:ss"/></td>
            </tr>
            <tr>
                <td align="right">Sale Begin Time：</td>
                <td align="left"><fmt:formatDate value="${match.beginSaleDate}" pattern="yyyy-MM-dd HH:mm:ss"/></td>
                <td align="right">Sale End Time：</td>
                <td align="left"><fmt:formatDate value="${match.endSaleDate}" pattern="yyyy-MM-dd HH:mm:ss"/></td>
            </tr>
            <tr>
                <td align="right">310 Handicap：</td>
                <td align="left">${match.winLevelLosScore}</td>
                <td align="right">30 Handicap：</td>
                <td align="left">${match.winLosScore}</td>
            </tr>
            <tr>
                <td align="right">Competition：</td>
                <td align="left">${match.competitionName}</td>
                <td align="right">Match Result：</td>
                <td align="left">
                    <c:if test="${match.status > 5}">
                        ${match.homeScore} : ${match.guestScore }
                    </c:if>
                </td>
            </tr>

        </table>
    </div>
</div>

</body>
</html>