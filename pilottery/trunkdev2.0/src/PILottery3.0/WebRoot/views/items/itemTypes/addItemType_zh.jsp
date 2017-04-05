<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/views/common/taglibs.jsp"%>
<html>
<head>

<title>添加物品</title>

<%@ include file="/views/common/meta.jsp" %>
<link rel="stylesheet" type="text/css" href="${basePath}/css/style.css"/>
<link rel="stylesheet" type="text/css" href="${basePath}/css/pop-up.css"/>
<link rel="stylesheet" href="${basePath}/component/messageBox/myJsBox.css" type="text/css"/>
<link rel="stylesheet" type="text/css" href="${basePath}/css/validate.css"/>

<script type="text/javascript" src="${basePath}/js/myJs.js"></script>
<script type="text/javascript" src="${basePath}/component/messageBox/myJsBox_zh.js"></script>
<script type="text/javascript" src="${basePath}/component/My97DatePicker/WdatePicker.js"></script>
<script type="text/javascript" src="${basePath}/js/jquery/jquery-1.9.1.js"></script>
<script type="text/javascript" src="${basePath}/js/regexEnum.js"></script>

<script type="text/javascript" charset="UTF-8">
function doClose() {
    window.parent.closeBox();
}

//验证非空
function isNotEmptyString(value) {
    return value != '' ? true : false;
}

$(document).ready(function(){
    $("#okButton").bind("click", function(){
        var result = true;
        
        if (!checkFormComm('newItemTypeForm')) {
        	result = false;
        }
        
        if (!doCheck("itemName", isNotEmptyString($("#itemName").val()), "不可为空")) {
            result = false;
        }
        
        if (!doCheck("baseUnitName", isNotEmptyString($("#baseUnitName").val()), "不可为空")) {
            result = false;
        }
        
        if (result) {
        	button_off("okButton");
            $("#newItemTypeForm").submit();
        }
    });
});
</script>

</head>
<body>
    <form action="item.do?method=addItemType" id="newItemTypeForm" method="POST">
    
        <div class="pop-body">
            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                <tr>
                    <td align="right" width="25%">物品名称：</td>
                    <td align="left" width="30%">
                        <input id="itemName" name="itemName" class="text-big" maxLength="60" isCheckSpecialChar="true" cMaxByteLength="50"/>
                    </td>
                    <td><span id="itemNameTip" class="tip_init">*</span></td>
                </tr>
                <tr>
                    <td align="right" width="25%">单位名称：</td>
                    <td align="left" width="30%">
                        <input id="baseUnitName" name="baseUnitName" value="个" class="text-big" maxLength="40" isCheckSpecialChar="true" cMaxByteLength="20"/>
                    </td>
                    <td><span id="baseUnitNameTip" class="tip_init">*</span></td>
                </tr>
            </table>
        </div>
        
        <div class="pop-footer">
            <span class="left">
                <input id="okButton" type="button" value="确定" class="button-normal"></input>
            </span>
            <span class="right">
                <input id="cancelButton" type="button" value="取消" class="button-normal" onclick="doClose();"></input>
            </span>
        </div>
        
    </form>
</body>
</html>