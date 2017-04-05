<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<%@ include file="/views/common/taglibs.jsp" %>
<html>
<head>
    <title></title>
    <link rel="stylesheet" type="text/css" href="${basePath}/css/style.css"/>
    <link rel="stylesheet" type="text/css" href="${basePath}/css/pop-up.css"/>
    <link rel="stylesheet" type="text/css" href="${basePath}/css/validate.css"/>
    <script type="text/javascript" src="${basePath}/js/jquery/jquery-1.9.1.js"></script>
    <script type="text/javascript" src="${basePath}/js/jquery/jquery.form.js"></script>
    <link rel="stylesheet" href="${basePath}/component/messageBox/myJsBox.css" type="text/css"/>
    <script type="text/javascript" src="${basePath}/component/messageBox/myJsBox_zh.js"></script>
    <script type="text/javascript" src="${basePath}/component/My97DatePicker/WdatePicker.js"></script>
    <script type="text/javascript" src="${basePath}/js/oms/myJs.js"></script>
    <script type="text/javascript" charset="UTF-8">
        jQuery(document).ready(function ($) {
            $("input[type='text']").each(
                    function () {
                        $(this).keypress(function (e) {
                            var key = window.event ? e.keyCode : e.which;
                            if (key.toString() == "13") {
                                return false;
                            }
                        });
                    }
            );
            $("#endSaleTime").click(function () {
                document.getElementById("endTip").innerHTML = "*";
                $("#endTip").css("color", "#CDC9C9");
            });

        });

        function checkFormData() {
            var end = $("#endSaleTime").val();
            if (end == "") {
                document.getElementById("endTip").innerHTML = "请输入销售截止时间";
                $("#endTip").css("color", "red");
                return false;
            }
            return true;
        }

        function doSubmit() {
            if (checkFormData()) {
                $("#matchUpdateForm").attr("action", "fbsDraw.do?method=submitUpdatMatch");
                button_off("okBtn");
                $("#matchUpdateForm").submit();
            }
        }
    </script>
</head>
<body>
<form:form modelAttribute="FbsMatchForm" id="matchUpdateForm" method="post">
    <div class="pop-body">
        <table width="100%" border="0" cellspacing="0" cellpadding="0" style="height: 120px;">
            <input type="hidden" name="matchCode" value="${fbsMatch.matchCode}">
            <tr>
                <td align="right" width="30%">场次状态：</td>
                <td height="30px" align="left">
                    <select class="select-normal" id="saleStatus" name="saleStatus">
                        <c:if test="${fbsMatch.saleStatus == 0}">
                            <option value="0" selected>禁用</option>
                            <option value="1">可用</option>
                        </c:if>
                        <c:if test="${fbsMatch.saleStatus == 1}">
                            <option value="0">禁用</option>
                            <option value="1" selected>可用</option>
                        </c:if>
                    </select>
                </td>
            </tr>
            <tr>
                <td align="right" width="30%">销售截止时间：</td>
                <td>
                    <input id="beginSaleDate" type="hidden" value="${fbsMatch.beginSaleTime}"/>
                    <input id="matchStartDate" type="hidden" value="${fbsMatch.matchStartTime}"/>
                    <input id="endSaleTime" name="endSaleTime"
                           value="${fbsMatch.endSaleTime}" class="Wdate"
                           type="text"
                           onFocus="WdatePicker({dateFmt:'yyyy-MM-dd HH:mm:ss',minDate:'#F{$dp.$D(\'beginSaleDate\')}',maxDate:'#F{$dp.$D(\'matchStartDate\')}'})"/>
                    <span id="startTip" style="color:#CDC9C9">*</span>
                </td>
            </tr>
        </table>
    </div>
    <div class="pop-footer">
        <span class="left"><input id="okBtn" type="button" value="提交" onclick="doSubmit();"
                                  class="button-normal"/></span>
        <span class="right"><input type="reset" value="重置" class="button-normal"/></span>
    </div>
</form:form>
</body>
</html>
