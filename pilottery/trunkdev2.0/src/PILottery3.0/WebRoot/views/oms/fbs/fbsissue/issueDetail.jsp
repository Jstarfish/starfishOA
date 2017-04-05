<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<%@ include file="/views/common/taglibs.jsp" %>
<html>
<head>
    <title>Issue Details</title>
    <%@ include file="/views/common/meta.jsp" %>
    <link rel="stylesheet" type="text/css" href="${basePath}/css/city-list.css"/>
    <link rel="stylesheet" type="text/css" href="${basePath}/css/style.css"/>
    <link type="text/css" rel="stylesheet" href="${basePath}/views/oms/game-draw/css/myStyle.css"/>

    <link rel="stylesheet" href="${basePath}/component/messageBox/myJsBox.css" type="text/css"/>
    <script type="text/javascript" src="${basePath}/component/messageBox/myJsBox.js"></script>
    <script type="text/javascript" src="${basePath}/js/jquery/jquery-1.9.1.js"></script>
    <script type="text/javascript" src="${basePath}/component/My97DatePicker/WdatePicker.js"></script>
    <script type="text/javascript" src="${basePath}/js/oms/myJs.js"></script>
    <script type="text/javascript" src="${basePath}/js/oms/city-list.js"></script>
</head>
<body>
<div id="title">
    <span>Issue Details</span>
</div>
<div class="queryDiv">
    <div id="left">
    <span>Issue Number：
    <input class="text-normal-noedit" value="${issueNumber}"
           type="text"/></span>
    <span>Issue Time：
    <input class="text-big-noedit" value="${issueTime}"
           type="text"/></span>
    </div>
</div>
<div id="headDiv">
    <table width="100%" border="0" cellpadding="0" cellspacing="0">
        <tr>
            <td>
                <table class="datatable" id="exportPdf">
                    <tr class="headRow">
                        <td style="width: 10px;">&nbsp;</td>
                        <td style="width:3%">Match Code</td>
                        <th width="1%">|</th>
                        <td style="width:3%">Competition</td>
                        <th width="1%">|</th>
                        <td style="width:3%">Home Team</td>
                        <th width="1%">|</th>
                        <td style="width:5%">30 Handicap</td>
                        <th width="1%">|</th>
                        <td style="width:5%">310 Handicap</td>
                        <th width="1%">|</th>
                        <td style="width:3%">Guest Team</td>
                        <th width="1%">|</th>
                        <td style="width:6%">Start Time</td>
                        <th width="1%">|</th>
                        <td style="width:6%">Sale Start Time</td>
                        <th width="1%">|</th>
                        <td style="width:6%">Sale End Time</td>
                    </tr>
                </table>
            </td>
            <td style="width:17px;background:#2aa1d9"></td>
        </tr>
    </table>
</div>

<div id="bodyDiv">
    <table class="datatable" id="exportPdfData">
        <c:forEach var="data" items="${pageDataList}" varStatus="status">
            <tr class="dataRow">
                <td style="width: 10px;">&nbsp;</td>
                <td style="width:3%">${data.matchCode}</td>
                <td width="1%">&nbsp;</td>
                <td style="width:3%" title="${data.matchComp}">${data.matchComp}</td>
                <td width="1%">&nbsp;</td>
                <td style="width:3%" title="${data.homeTeam}">${data.homeTeam} </td>
                <td width="1%">&nbsp;</td>
                <td style="width:5%">${data.score30} </td>
                <td width="1%">&nbsp;</td>
                <td style="width:5%">${data.score310} </td>
                <td width="1%">&nbsp;</td>
                <td style="width:3%" title="${data.guestTeam}">${data.guestTeam} </td>
                <td width="1%">&nbsp;</td>
                <td style="width:6%">${data.matchStartTime}</td>
                <td width="1%">&nbsp;</td>
                <td style="width:6%">${data.beginSaleTime}</td>
                <td width="1%">&nbsp;</td>
                <td style="width:6%">${data.endSaleTime}</td>
            </tr>
        </c:forEach>
    </table>
    ${pageStr }
</div>

</body>
</html>