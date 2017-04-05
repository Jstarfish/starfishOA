<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<%@ include file="/views/common/taglibs.jsp" %>
<html>
<head>
    <title>期次比赛编辑</title>
    <%@ include file="/views/common/meta.jsp" %>
    <link rel="stylesheet" type="text/css" href="${basePath}/css/city-list.css"/>
    <link rel="stylesheet" type="text/css" href="${basePath}/css/style.css"/>
    <link type="text/css" rel="stylesheet" href="${basePath}/views/oms/game-draw/css/myStyle.css"/>

    <link rel="stylesheet" href="${basePath}/component/messageBox/myJsBox.css" type="text/css"/>
    <script type="text/javascript" src="${basePath}/component/messageBox/myJsBox_zh.js"></script>
    <script type="text/javascript" src="${basePath}/js/jquery/jquery-1.9.1.js"></script>
    <script type="text/javascript" src="${basePath}/component/My97DatePicker/WdatePicker.js"></script>
    <script type="text/javascript" src="${basePath}/js/oms/myJs.js"></script>
    <script type="text/javascript" src="${basePath}/js/oms/city-list.js"></script>

    <script type="text/javascript" charset="UTF-8">

        function deleteMatch(matchCode){
            var msg = "确认删除吗?";
            showDialog("doDelete('"+matchCode+"')","删除",msg);
        }

        function doDelete(matchCode) {

            var url="fbsGame.do?method=deleteMatch&matchCode=" + matchCode;
            $.ajax({
                url : url,
                dataType : "json",
                async : false,
                success : function(r){
                    if(r.message!='' && r.message!=null){
                        closeDialog();
                        showError(r.message);
                    }
                    else{
                        closeDialog();
                        window.location.reload();
                    }
                }
            });
        }
    </script>

</head>
<body>
<div id="title">期次编号：${issueNumber}</div>

    <div class="queryDiv">
            <div class="right">
                <table width="100" border="0" cellspacing="0" cellpadding="0" style="margin-top:2px;">
                    <tr style="height:50px;line-height:50px">
                        <input id="issueCode" type="hidden" value="${issueNumber}"/>
                        <input id="issueStart" type="hidden" value="${issueStart}"/>
                        <input id="issueEnd" type="hidden" value="${issueEnd}"/>
                        <td>
                            <input type="button" value="添加比赛" onclick="showBox('fbsGame.do?method=initAddMatch&issueNum=${issueNumber}&issueStart=${issueStart}&issueEnd=${issueEnd}','新增比赛',640,800);" class="button-normal"/>
                        </td>
                        <td align="right">
                            &nbsp;
                        </td>
                    </tr>
                </table>
                </span>
            </div>
</div>
<div id="headDiv">
    <table width="100%" border="0" cellpadding="0" cellspacing="0">
        <tr>
            <td>
                <table class="datatable" id="exportPdf">
                    <tr class="headRow">
                        <td style="width: 10px;">&nbsp;</td>
                        <td style="width:3%">比赛编号</td>
                        <td width="1%">|</td>
                        <td style="width:3%">所属期次</td>
                        <td width="1%">|</td>
                        <td style="width:3%">主队</td>
                        <td width="1%">|</td>
                        <td style="width:3%">客队</td>
                        <td width="1%">|</td>
                        <td style="width:6%">销售开始时间</td>
                        <td width="1%">|</td>
                        <td style="width:6%">销售截止时间</td>
                        <td width="1%">|</td>
                        <td style="width:6%">操作</td>
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
                <td style="width:3%">${data.matchIssue}</td>
                <td width="1%">&nbsp;</td>
                <td style="width:3%" title="${data.homeTeam}">${data.homeTeam} </td>
                <td width="1%">&nbsp;</td>
                <td style="width:3%" title="${data.guestTeam}">${data.guestTeam} </td>
                <td width="1%">&nbsp;</td>
                <td style="width:6%">${data.beginSaleTime}</td>
                <td width="1%">&nbsp;</td>
                <td style="width:6%">${data.endSaleTime}</td>
                <td width="1%">&nbsp;</td>
                <td style="width:6%">
                    <span><a href="#" onclick="showBox('fbsGame.do?method=getMatchDetail&matchCode=${data.matchCode }','比赛详情',400,800)">详情</a></span>&nbsp;|
                    <span><a href="#" onclick="showBox('fbsGame.do?method=initEditMatch&matchCode=${data.matchCode }&issueStart=${issueStart}&issueEnd=${issueEnd}','修改比赛',640,800);">修改</a></span>&nbsp;|
                    <span><a href="#" onclick="deleteMatch('${data.matchCode }')">删除</a></span>
                </td>
            </tr>
        </c:forEach>
    </table>
    ${pageStr }
</div>

</body>
</html>