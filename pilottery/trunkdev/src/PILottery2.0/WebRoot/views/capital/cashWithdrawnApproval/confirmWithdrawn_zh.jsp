<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/views/common/taglibs.jsp"%>
<html>
<head>
<title>确认提现</title>
<%@ include file="/views/common/meta.jsp" %>
<link rel="stylesheet" type="text/css" href="${basePath}/css/style.css"/>
<link rel="stylesheet" type="text/css" href="${basePath}/css/pop-up.css"/>
<link rel="stylesheet" href="${basePath}/component/messageBox/myJsBox.css" type="text/css"/>
<link rel="stylesheet" type="text/css" href="${basePath}/css/validate.css"/>
<script type="text/javascript" src="${basePath}/js/myJs.js"></script>
<script type="text/javascript" src="${basePath}/component/messageBox/myJsBox.js"></script>
<script type="text/javascript" src="${basePath}/component/My97DatePicker/WdatePicker.js"></script>
<script type="text/javascript" src="${basePath}/js/jquery/jquery-1.9.1.js"></script>
<script type="text/javascript" src="${basePath}/js/regexEnum.js"></script>
<script type="text/javascript" charset="UTF-8">
function doClose() {
    window.parent.closeBox();
}
</script>
</head>
<body>
    <form action="cashWithdrawn.do?method=confirm" id="cashWithdrawnForm" method="POST">
    <input type="hidden" name="fundNo" value="${withdrawnInfo.fundNo}">
    	<div class="pop-body">
			<table width="100%" border="0" cellspacing="0" cellpadding="0">
				<tr></tr>
				<tr>
					<td align="right" width="50%">提现金额:</td>
					<td align="left"><fmt:formatNumber value="${withdrawnInfo.applyAmount}" />
					 <span id="planCodeTip" class="tip_init"></span></td>
				</tr>
				
				<tr>
					<td align="right">提现部门:</td>
					<td align="left">${withdrawnInfo.aoName}
					 <span id="fullNameTip" class="tip_init"></span></td>
				</tr>
			</table>
		</div>
        
         <div class="pop-footer">
            <span class="left">
                <input id="okButton" type="submit" value="提交" class="button-normal"></input>
            </span>
            <span class="right">
                <input type="button" value="取消" onclick="doClose();" class="button-normal"></input>
            </span>
        </div> 
    </form>
</body>
</html>


