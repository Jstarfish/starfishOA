<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/views/common/taglibs.jsp"%>
<html>
<head>
<title>更新时间 </title>
<link rel="stylesheet" type="text/css" href="${basePath}/css/style.css" />
<link rel="stylesheet" type="text/css" href="${basePath}/css/pop-up.css" />
<link rel="stylesheet" type="text/css" href="${basePath}/css/validate.css" />
<link rel="stylesheet" href="${basePath}/component/messageBox/myJsBox.css" type="text/css"/>
<script type="text/javascript" src="${basePath}/js/jquery/jquery-1.9.1.js"></script>
<script type="text/javascript" src="${basePath}/component/messageBox/myJsBox_zh.js"></script>
<script type="text/javascript" src="${basePath}/js/oms/myJs.js"></script>
<script type="text/javascript" src="${basePath}/component/My97DatePicker/WdatePicker.js"></script>
<script type="text/javascript">
function doSubmit() {
    var result = true;
    /*if (!doCheck("time_type",/^[^0]$/,"* 请选择！")) {
        result = false;
    }*/
    if (result) {
        button_off("okBtn");
        $("#editUpdateTime").submit();
    }
}
function changeType() {
    if ($("#time_type").val()==1) {
        $("#inputTime").show();
    } else {
        $("#inputTime").hide();
    }
}
</script>
</head>

<body>
  <form action="updatePlan.do?method=changeupdatetime" id="editUpdateTime" method="post">
    <div class="pop-body">
      <table width="100%" border="0" cellspacing="0" cellpadding="0">
        <tr>
          <td align="right" width="25%">计划名称:</td>
          <td align="center" width="35%">
            <input class="text-big" style="border: none;" disabled="disabled" type="text" value="${updatePlan.planName}"/>
            <input type="hidden"  name="planId" value="${updatePlan.planId}">
          </td>
          <td width="*%"><span id="planNameTip" class="tip_init"></span></td>
        </tr>
        <tr>
          <td align="right">选择方式:</td>
          <td align="center">
            <select id="time_type" name="timeType" class="select-big" onchange="changeType()">
              <option value="1">指定时间</option>
              <option value="2">立即更新</option>
            </select>
          </td>
          <td><span id="provinceTip" class="tip_init">*</span></td>
        </tr>
        <tr id="inputTime">
          <td align="right">更新时间:</td>
          <td align="center">
            <input id="updateDate" name="updateDate" class="Wdate text-big" value="${updatePlan.updateDate}" onfocus="WdatePicker({dateFmt:'yyyy-MM-dd HH:mm:ss',readOnly:true})"/>
          </td>
          <td><span id="updateDateTip" class="tip_init"></span></td>
        </tr>
      </table>
    </div>
    <div class="pop-footer">
      <span class="left">
        <input id="okBtn" type="button" value="提交" onclick="doSubmit();" class="button-normal"></input>
      </span>
      <span class="right">
        <input type="reset" value="重置" class="button-normal"></input>
      </span>
    </div>
  </form>
</body>
</html>
