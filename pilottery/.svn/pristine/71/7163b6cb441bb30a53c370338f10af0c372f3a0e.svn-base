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
	<script type="text/javascript" src="${basePath}/component/messageBox/myJsBox.js"></script>
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
			$("#fbsIssueCode").click(function () {
				document.getElementById("codeTip").innerHTML = "*";
				$("#codeTip").css("color", "#CDC9C9");
			});
			$("#issueStartTime").click(function () {
				document.getElementById("startTip").innerHTML = "*";
				$("#startTip").css("color", "#CDC9C9");
			});
			$("#issueEndTime").click(function () {
				document.getElementById("endTip").innerHTML = "*";
				$("#endTip").css("color", "#CDC9C9");
			});
			$("#issueDate").click(function () {
				document.getElementById("dateTip").innerHTML = "*";
				$("#dateTip").css("color", "#CDC9C9");
			});
		});

		function checkFormData() {
			var issue = $("#fbsIssueCode").val();
			var oldIssue = $("#oldIssueCode").val();
			var start = $("#issueStartTime").val();
			var end = $("#issueEndTime").val();
			var datev = $("#issueDate").val();
			if (issue == "") {
				document.getElementById("codeTip").innerHTML = "Please Enter Issue Number";
				$("#codeTip").css("color", "red");
				return false;
			} else {
				if (oldIssue > issue || oldIssue.length > issue.length) {
					document.getElementById("codeTip").innerHTML = "Please Enter Legal Issue Number";
					$("#codeTip").css("color", "red");
					return false;
				}
			}
			if (start == "") {
				document.getElementById("startTip").innerHTML = "Please Enter Issue Start Time";
				$("#startTip").css("color", "red");
				return false;
			}
			if (end == "") {
				document.getElementById("endTip").innerHTML = "Please Enter Issue End Time";
				$("#endTip").css("color", "red");
				return false;
			}
			if (datev == "") {
				document.getElementById("dateTip").innerHTML = "Please Enter Issue Date";
				$("#dateTip").css("color", "red");
				return false;
			}
			return true;
		}

		function doSubmit() {
			if (checkFormData()) {
				$("#issueAddForm").attr("action", "fbsIssue.do?method=submitAdd");
				button_off("okBtn");
				$("#issueAddForm").submit();
			}
		}
		function resetIssueDate(){
			$("#issueDate").val("");
		}
	</script>
</head>
<body>
<form:form modelAttribute="issueAddForm" id="issueAddForm" method="post">
	<div class="pop-body">
		<table width="100%" border="0" cellspacing="0" cellpadding="0" style="height: 120px;">
			<tr>
				<td align="right" width="30%">Issue Number：</td>
				<td>
					<input id="oldIssueCode" name="oldIssueCode" value="${maxIssue}"
						   type="hidden"/>
					<input id="fbsIssueCode" name="fbsIssueCode" value="${maxIssue}" class="text-normal"
						   type="text" placeholder="Max Issue:${maxIssue}"/>
					<span id="codeTip" style="color:#CDC9C9">*</span>
				</td>
			</tr>
			<tr>
				<td align="right" width="30%">Start Time：</td>
				<td>
					<input id="maxIssueCodeDate" value="${maxIssueCodeDate}"
						   type="hidden"/>
					<input id="issueStartTime" name="issueStartTime" value="" class="Wdate"
						   type="text"
						   onFocus="WdatePicker({dateFmt:'yyyy-MM-dd HH:mm:ss',minDate:'#F{$dp.$D(\'maxIssueCodeDate\')}',maxDate:'#F{$dp.$D(\'issueEndTime\')}'})"/>
					<span id="startTip" style="color:#CDC9C9">*</span>
				</td>
			</tr>
			<tr>
				<td align="right" width="30%">End Time：</td>
				<td>
					<input id="issueEndTime" name="issueEndTime" value="" class="Wdate"
						   type="text"
						   onchange="resetIssueDate()"
						   onFocus="WdatePicker({dateFmt:'yyyy-MM-dd HH:mm:ss',minDate:'#F{$dp.$D(\'issueStartTime\')}'})"/>
					<span id="endTip" style="color:#CDC9C9">*</span>
				</td>
			</tr>
			<tr>
				<td align="right" width="30%">Issue Date：</td>
				<td>
					<input id="issueDate" name="issueDate" value="" class="Wdate"
						   type="text"
						   onFocus="WdatePicker({dateFmt:'yyyy-MM-dd',minDate:'#F{$dp.$D(\'issueStartTime\')}',maxDate:'#F{$dp.$D(\'issueEndTime\')}'})"/>
					<span id="dateTip" style="color:#CDC9C9">*</span>
				</td>
			</tr>
		</table>
	</div>
	<div class="pop-footer">
        <span class="left"><input id="okBtn" type="button" value="Submit" onclick="doSubmit();"
								  class="button-normal"/></span>
		<span class="right"><input type="reset" value="Reset" class="button-normal"/></span>
	</div>
</form:form>
</body>
</html>
