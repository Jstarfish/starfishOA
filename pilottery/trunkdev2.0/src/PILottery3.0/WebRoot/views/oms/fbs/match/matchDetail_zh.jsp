<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<%@ include file="/views/common/taglibs.jsp" %>
<html>
<head>
    <title>比赛细信息</title>

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
                <td align="right" width="25%">比赛编号：</td>
                <td align="left" width="25%">${match.matchCode}</td>
                <td align="right" width="25%">所属期号：</td>
                <td align="left">${match.fbsIssueNumber}</td>
            </tr>
            <tr>
                <td align="right">销售状态：</td>
                <td align="left">
                    <c:choose>
                        <c:when test="${match.isSale==1 }">可售</c:when>
                        <c:when test="${match.isSale!=1 }">不可售</c:when>
                    </c:choose>
                </td>
                <td align="right">比赛状态：</td>
                <td align="left">
                    <c:choose>
                        <c:when test="${match.status==1 }">预排</c:when>
                        <c:when test="${match.status==2 }">开始销售</c:when>
                        <c:when test="${match.status==3 }">销售结束</c:when>
                        <c:when test="${match.status==4 }">开奖中</c:when>
                        <c:when test="${match.status==5 }">算奖完成</c:when>
                        <c:when test="${match.status==6 }">开奖完成</c:when>
                    </c:choose>
                </td>
            </tr>
            <tr>
                <td align="right">主队名称：</td>
                <td align="left">${match.homeTeamName}</td>
                <td align="right">客队名称：</td>
                <td align="left">${match.guestTeamName}</td>
            </tr>
            <tr>
                <td align="right">比赛开始时间：</td>
                <td align="left"><fmt:formatDate value="${match.matchStartDate}" pattern="yyyy-MM-dd HH:mm:ss"/></td>
                <td align="right">比赛结束时间：</td>
                <td align="left"><fmt:formatDate value="${match.matchEndDate}" pattern="yyyy-MM-dd HH:mm:ss"/></td>
            </tr>
            <tr>
                <td align="right">销售开始时间：</td>
                <td align="left"><fmt:formatDate value="${match.beginSaleDate}" pattern="yyyy-MM-dd HH:mm:ss"/></td>
                <td align="right">销售结束时间：</td>
                <td align="left"><fmt:formatDate value="${match.endSaleDate}" pattern="yyyy-MM-dd HH:mm:ss"/></td>
            </tr>
            <tr>
                <td align="right">胜平负让球数：</td>
                <td align="left">${match.winLevelLosScore}</td>
                <td align="right">胜负让球数：</td>
                <td align="left">${match.winLosScore}</td>
            </tr>
            <tr>
                <td align="right">联赛名称：</td>
                <td align="left">${match.competitionName}</td>
                <td align="right">比赛结果：</td>
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