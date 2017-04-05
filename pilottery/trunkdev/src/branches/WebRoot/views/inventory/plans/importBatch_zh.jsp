<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/views/common/taglibs.jsp"%>
<html>
<head>

<title>New Plan</title>

<%@ include file="/views/common/meta.jsp"%>
<link rel="stylesheet" type="text/css" href="${basePath}/css/style.css" />
<link rel="stylesheet" type="text/css" href="${basePath}/css/pop-up.css" />
<link rel="stylesheet" href="${basePath}/component/messageBox/myJsBox.css"
	type="text/css" />
<link rel="stylesheet" type="text/css" href="${basePath}/css/validate.css" />
<script type="text/javascript" src="${basePath}/js/myJs.js"></script>
<script type="text/javascript" src="${basePath}/component/messageBox/myJsBox.js"></script>
<script type="text/javascript"
	src="${basePath}/component/My97DatePicker/WdatePicker.js"></script>
<script type="text/javascript" src="${basePath}/js/jquery/jquery-1.9.1.js"></script>
<script type="text/javascript" src="${basePath}/js/regexEnum.js"></script>
<style type="text/css">
.wait {
    height:120px;
    width:120px;
    background:url(./component/messageBox/img/wait.gif) no-repeat center;
}


</style>
<script type="text/javascript" charset="UTF-8">
	function doClose() {
		window.parent.closeBox();
	}

	//验证非空
	function isNull(data) {
		return (data == "" || data == undefined || data == null);
	}

	function isSelected(value) {
		return value != 0 ? true : false;
	}

	function importBatch() {
		if (doCheck("batch", !isNull($("#batch").val()), "Can't be empty")) {
			
			 button_off("okButton");
			 getWait();
			
			$("#importBat").submit();
		}
	}
	function getWait(){
		// document.getElementById("stopwait").style.display = "block";
		 
		 document.getElementById("stopwait").style.display = "none";
		 document.getElementById("waitTable").style.display = "block";
	}

</script>
</head>
<body>
	<form id="importBat" action="plans.do?method=importBatch&planCode=${planCode}"
		method="POST">
		<!-- TODO -->
		<div id="stopwait" class="pop-body">
			<input name="planCode" value="${planCode}" hidden="true" />
			<table width="100%" border="0" cellspacing="0" cellpadding="0"  style="margin-top:55px">
				<tr>
					<td align="right" width="30%">批次:</td>
					<td align="left"><input id="batch" name="batch" class="text-big"
						maxLength="10" /> <span id="batchTip" class="tip_init">*</span></td>
				</tr>
			</table>
		</div>
		<div class="pop-footer">
			<span class="left"> <input id="okButton" type="button" value="提交"
				class="button-normal" onclick="importBatch();"></input>
			</span> <span class="right"> <input id="cancelButton" type="button" value="取消"
				class="button-normal" onclick="doClose();"></input>
			</span>
		</div>
      
        <table id="waitTable" border="0" cellspacing="0" cellpadding="0" width="100%" height="100%" style="display: none;"><tbody><tr><td align="center"><div class="wait"></div></td></tr></tbody></table>
      
      
        
	</form>
</body>
</html>