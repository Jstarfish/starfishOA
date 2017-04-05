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

        function deleteMatch() {
            var checks = $("#bodyDiv").find("input[type='checkbox']");
            var params = "";
            for (var i = 0; i < checks.length; i++) {
                if (checks[i].type == "checkbox" && checks[i].checked == true) {
                    params = params + checks[i].value;
                }
                if (i != checks.length - 1) {
                    params = params + ";";
                }
            }
            var issueCode =  $("#issueCode").val();
            var url = "fbsIssue.do?method=submitEditMatch&issueCode="+issueCode+"&matchCode=" + params;
            $.ajax({
                url: url,
                dataType: "json",
                async: false,
                success: function (r) {
                    if (r.msg != '' && r.msg!= null) {
                        showError(decodeURI(r.msg));
                    }else {
                        window.location.reload();
                    }
                }
            });
        }

        function checkAll() {
            var checks = $("#bodyDiv").find("input[type='checkbox']");
            if (checks[0].checked == true) {
                for (var i = 0; i < checks.length; i++) {
                    if (checks[i].type == "checkbox") {
                        checks[i].checked = false;
                    }
                }
            } else {
                for (var i = 0; i < checks.length; i++) {
                    if (checks[i].type == "checkbox") {
                        checks[i].checked = true;
                    }
                }
            }
        }

        function submitForm() {
            $("#fbsMatchForm").submit();
        }
        function clearForm() {
            $("#matchDate").val('');
            $("#startQueryTime").val('');
            $("#endQueryTime").val('');
        }
    </script>

</head>
<body>
<div id="title">期次编号：${issueNumber}</div>

    <div class="queryDiv">
        <form:form modelAttribute="fbsMatchForm" action="fbsIssue.do?method=editMatch&fbsIssueNumber=${issueNumber}">
            <div class="left">
         <span>比赛日期：
      <form:input path="matchDate" id="matchDate"
                  value="${fbsMatchForm.matchDate}"
                  class="Wdate"
                  type="text"
                  onFocus="WdatePicker({dateFmt:'yyyy-MM-dd'})"/>
         </span>
          <span>
      比赛时间：<input id="startQueryTime" name="startQueryTime" value="${fbsMatchForm.startQueryTime}"
                  class="Wdate"
                  type="text"
                  onFocus="WdatePicker({dateFmt:'yyyy-MM-dd HH:mm:ss'})"/>
                     </span>
                      <span>
                    - <input id="endQueryTime" name="endQueryTime" value="${fbsMatchForm.endQueryTime}"
                             class="Wdate"
                             type="text"
                             onFocus="WdatePicker({dateFmt:'yyyy-MM-dd HH:mm:ss',minDate:'#F{$dp.$D(\'startQueryTime\')}'})"/>
                     </span>
                <input type="button" value="查询" onclick="submitForm();" class="button-normal"/>
                <input type="button" class="button-normal" value="清除" onclick="clearForm()">
            </div>

            <div class="right">
                <table width="100" border="0" cellspacing="0" cellpadding="0" style="margin-top:2px;">
                    <tr style="height:50px;line-height:50px">
                        <input id="issueCode" type="hidden" value="${issueNumber}"/>
                        <td>
                            <input type="button" value="删除" onclick="deleteMatch()" class="button-normal"/>
                        </td>
                        <td align="right">
                            &nbsp;
                        </td>
                    </tr>
                </table>
                </span>
            </div>
        </form:form>
</div>
<div id="headDiv">
    <table width="100%" border="0" cellpadding="0" cellspacing="0">
        <tr>
            <td>
                <table class="datatable" id="exportPdf">
                    <tr class="headRow">
                        <td style="width: 10px;">&nbsp;</td>
                        <td style="width:2%">
                            <a href="#" onclick="checkAll()" style="color: white">全选</a></td>
                        <th width="1%">|</th>
                        <td style="width:3%">比赛编号</td>
                        <th width="1%">|</th>
                        <td style="width:3%">所属联赛</td>
                        <th width="1%">|</th>
                        <td style="width:3%">主队</td>
                        <th width="1%">|</th>
                        <td style="width:3%">客队</td>
                        <th width="1%">|</th>
                        <td style="width:6%">比赛日期</td>
                        <th width="1%">|</th>
                        <td style="width:6%">开始时间</td>
                        <th width="1%">|</th>
                        <td style="width:6%">结束时间</td>
                        <th width="1%">|</th>
                        <td style="width:6%">销售时间</td>
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
                <td style="width:2%">
                    <input type="checkbox" value="${data.mathCode}"/>
                </td>
                <td width="1%">&nbsp;</td>
                <td style="width:3%">${data.mathCode}</td>
                <td width="1%">&nbsp;</td>
                <td style="width:3%">${data.matchComp}</td>
                <td width="1%">&nbsp;</td>
                <td style="width:3%">${data.homeTeam} </td>
                <td width="1%">&nbsp;</td>
                <td style="width:3%">${data.guestTeam} </td>
                <td width="1%">&nbsp;</td>
                <td style="width:6%">${data.matchDate}</td>
                <td width="1%">&nbsp;</td>
                <td style="width:6%">${data.matchStartTime}</td>
                <td width="1%">&nbsp;</td>
                <td style="width:6%">${data.matchEndTime}</td>
                <td width="1%">&nbsp;</td>
                <td style="width:6%">${data.beginSaleTime}</td>
            </tr>
        </c:forEach>
    </table>
    ${pageStr }
</div>

</body>
</html>