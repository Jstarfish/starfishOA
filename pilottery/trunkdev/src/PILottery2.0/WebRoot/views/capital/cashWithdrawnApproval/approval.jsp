
<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8"%>
<%@ include file="/views/common/taglibs.jsp"%>
<%@ include file="/views/common/meta.jsp"%>
<html>
<head>
<title>Cash Withdrawn Approval</title>
<link rel="stylesheet" type="text/css" href="${basePath}/css/style.css" />
<link rel="stylesheet" type="text/css" href="${basePath}/css/pop-up.css" />
<link rel="stylesheet" 	href="${basePath}/component/messageBox/myJsBox.css" type="text/css" />
<link rel="stylesheet" type="text/css"	href="${basePath}/css/validate.css" />
<script type="text/javascript"	src="${basePath}/component/messageBox/myJsBox.js"></script>
<script type="text/javascript" src="${basePath}/js/myJs.js"></script>
<script type="text/javascript"	src="${basePath}/js/jquery/jquery-1.9.1.js"></script>
<script type="text/javascript" src="${basePath}/js/regexEnum.js"></script>
<script type="text/javascript" charset="UTF-8">
	function doSubmit() {
		button_off("okBtn");
		$('#approveForm').submit();
	}

	function doClose() {
		window.parent.closeBox();
	}
</script>
</head>
<body>
	<form action="cashWithdrawn.do?method=approveWithdrawn" id="approveForm" method="POST">
		<input type="hidden" name="fundNo" value="${withdrawnInfo.fundNo}">
		 <div class="pop-body">
		<table width="100%" border="0" cellspacing="0" cellpadding="0">
			<tbody style="font-size: 14px;">
				<tr height="10px">
					<td colspan="2"></td>
				</tr>
				<tr>
					<td align="right"> Approve:</td>
					<td align="center">
						<input  type="radio" name="checkResult" value="1" checked="checked"/> Allow 
						&nbsp;&nbsp;&nbsp;&nbsp;
						<input  type="radio" name="checkResult" value="2" /> Deny
					</td>
					<td><span id="checkResultTip" class="tip_init"></span></td>
				</tr>
			</tbody>
		</table>
		</div>
				
		<div class="pop-footer">
            <span class="left">
                 <input type="button" id="okBtn"  onclick="doSubmit();" class="button-normal" value='OK'></input>
            </span>
            <span class="right">
                <input id="cancelButton" type="button" value="Cancel" class="button-normal" onclick="doClose();""></input>
            </span>
        </div> 
	</form>
</body>
</html>