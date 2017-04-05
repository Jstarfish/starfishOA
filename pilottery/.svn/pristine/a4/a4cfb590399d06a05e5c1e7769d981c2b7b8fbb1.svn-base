<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/views/common/taglibs.jsp"%>
<html>
<head>
<title>Outlet Notice</title>
<%@ include file="/views/common/meta.jsp" %>
<script type="text/javascript" src="${basePath}/js/jquery/jquery-1.9.1.js"></script>
<link rel="stylesheet" href="${basePath}/component/messageBox/myJsBox.css" type="text/css"/>
<script type="text/javascript" src="${basePath}/component/messageBox/myJsBox.js"></script>
<script type="text/javascript" src="${basePath}/js/oms/myJs.js"></script>
<script type="text/javascript" src="${basePath}/component/My97DatePicker/WdatePicker.js"></script>
<link rel="stylesheet" type="text/css" href="${basePath}/css/style.css" />
<script type="text/javascript" charset="UTF-8" > 
var existName = 'This name already exists, please input again';
var charactValid = '* Not empty, Chinese, English, digit, and no special characters';
var correct = 'Congratulations, you have entered correctly';
var length = 'Not empty and not more than 20 characters';
var error = 'Your input is incorrect';
var select = '* Please select';
var hint = 'Please select a terminal or a institution!';
var region = 'Institution';
var version = 'Select version';
var confirm = 'Confirm';
function updateQuery(){
	$("#queryForm").submit();
}
function clearValue(){
	$(".text-normal").val('');
}
function toSendNotifyPage(url){
	window.location.href = url;
}
</script>
</head>
<body>
	<div id="title">
		<span>Outlet Notice</span>
	</div>
	<div class="queryDiv">
		<form:form modelAttribute="terminalNoticeForm" action="tmnotice.do?method=notifyList" id="queryForm">
		<div class="left">
			<span>Send Time：
				<input readonly="readonly" type="text" id="sendStartTime" name="sendStartTime" value="${terminalNoticeForm.sendStartTime }" class="Wdate text-normal" onFocus="var sendEndTime=$dp.$('sendEndTime');WdatePicker({onpicked:function(){sendEndTime.focus();},maxDate:'#F{$dp.$D(\'sendEndTime\')}'})"/>
			</span>- 
			<span>
				<input readonly="readonly" type="text" id="sendEndTime" name="sendEndTime" value="${terminalNoticeForm.sendEndTime }" class="Wdate text-normal" onFocus="WdatePicker({minDate:'#F{$dp.$D(\'sendStartTime\')}'})"/>
			</span>
			<span>Notice Title：<form:input path="terminalNotice.title" id="t_title" class="text-normal" maxlength="100"/></span>
			<span>Sender：<form:input path="adminName" id="adminName" class="text-normal" maxlength="100"/></span>
			<input type="button" value="Query" onclick="updateQuery();" class="button-normal"></input>
			<input type="button" value="Clear" class="button-normal" onclick="clearValue();"></input>
		</div>
		<div class="right">
			<table width="260" border="0" cellspacing="0" cellpadding="0">
				<tr style="height:50px;line-height:50px">
					<td align="right">
						<input type="button" value="Send" onclick="toSendNotifyPage('tmnotice.do?method=sendTMNotify');" class="button-normal"></input>
					</td>
					<td style="width:30px"></td>
					<td align="right" style="display: none">
						<a href="#" onclick="">
							<img src="img/printx.png" width="53" height="24" style="margin-top:10px;" onclick="myPrint();"/>
						</a>
					</td>
					<td align="right" style="display: none">
						<a href="#" onclick="">
							<img src="img/daochu.png" width="53" height="24" style="margin-top:10px;"  onclick="doExport();"/>
						</a>
					</td>
				</tr>
			</table>
		</div>
		</form:form>
	</div>
	<div id="headDiv">
        <table width="100%" border="0" cellpadding="0" cellspacing="0">
        	<tr><td>
            <table class="datatable">
                <tr class="headRow">
              	   <td style="width: 10px;">&nbsp;</td>
                   <td style="width:15%" class="nowrap">Notice Title</td>
                   <th width="1%">|</th>
                   <td style="width:15%" class="nowrap">Send Time</td>
                   <th width="1%">|</th>
                   <td style="width:15%" class="nowrap">Sender</td>
                   <th width="1%">|</th>
                   <td style="width:20%" class="nowrap">Target Outlet</td>
                   <th width="1%">|</th>
                   <td style="width:*%" class="nowrap noprint">Operation</td>
                </tr>
            </table>
           </td>
           <td style="width:17px;background:#2aa1d9"></td>
          </tr>
        </table>
    </div>
	<div id="bodyDiv">
    	<table class="datatable">
    		<c:forEach var="data" items="${pageDataList}" varStatus="status" >
    			<tr class="dataRow">
    				<td style="width: 10px;">&nbsp;</td>
    				<td style="width:15%" title="${data.title }">${data.title }</td>
    				<td width="1%">&nbsp;</td>
                   <td style="width:15%">${data.sendTimeToChar}</td>
    				<td width="1%">&nbsp;</td>
                   <td style="width:15%" title="${data.adminRealname}">${data.adminRealname}</td>
    				<td width="1%">&nbsp;</td>
                   <td style="width:20%" title="${data.objNames}">${data.objNames}</td>
    				<td width="1%">&nbsp;</td>
                   <td style="width:*%" class="operate">
                   		<span><a href="#" onclick="showBox('tmnotice.do?method=noticeDetail&noticeId=${data.noticeId}','Details',400,700)">Details</a></span> 
                   </td>
    			</tr>
    		</c:forEach>
    	</table>
    	${pageStr }
    </div>
</body>
</html>
