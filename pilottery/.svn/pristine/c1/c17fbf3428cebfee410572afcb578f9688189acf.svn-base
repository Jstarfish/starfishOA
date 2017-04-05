<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8"%>
	<%@ include file="/views/common/taglibs.jsp"%>
<%@ include file="/views/common/meta.jsp" %>
<html>
<head>
<title>添加日志</title>
<link rel="stylesheet" type="text/css" href="${basePath}/css/style.css" />
<link rel="stylesheet" type="text/css" href="${basePath}/css/pop-up.css" />
<link rel="stylesheet" href="${basePath}/component/messageBox/myJsBox.css" type="text/css" />
<link rel="stylesheet" type="text/css" href="${basePath}/css/validate.css" />
<script type="text/javascript" src="${basePath}/component/messageBox/myJsBox.js"></script>
<script type="text/javascript" src="${basePath}/component/My97DatePicker/WdatePicker.js"></script>
<script type="text/javascript" src="${basePath}/js/myJs.js"></script>
<script type="text/javascript" src="${basePath}/js/jquery/jquery-1.9.1.js"></script>
<script type="text/javascript" src="${basePath}/js/regexEnum.js"></script>
<script type="text/javascript" charset="UTF-8">
function doSubmit(){
    var result = true;

	if(!doCheck("terminalCode",!terminalCode.value == "",'* 终端编码不能为空！')) {//
	    result = false;
	}
	
	if(!doCheck("applyArg1",!applyArg1.value == "",'* 扩展参数不能为空！')) {//
	    result = false;
	}
	
	if(result){
		$("#addForm").submit();
	}
}

function doClose() {
	window.parent.closeBox();
}
</script>
</head>
<body>
    <form action="trace.do?method=addTrace" method="POST" id="addForm">
        <div class="pop-body">
            <table width="100%" border="0" cellspacing="0" cellpadding="0" >
                <tr>
                    <td class="td" align="right" width="30%">终端编码：</td>
                    <td align="center" width="35%">
                        <input id="terminalCode" name="terminalCode" type="text" class="text-big-noedit"></input>
                    </td>
                    <td><span id="terminalCodeTip" class="tip_init">*</span></td>
                </tr>
                
             <tr>
				<td class="td" align="right">申请类型：</td>
				<td class="td" align="left">
				<select name="applyType"  class="select-big">
					   <c:forEach var="item" items="${reqestTypes}">
					      <option value="${item.key}"
					      <c:if test="${UploadTraceForm.applyType==item.key}">selected</c:if>>${item.value}</option>
					   </c:forEach>
				</select>
				<td><span id="applyTypeTip" class="tip_init"></span></td>
			</tr>
			
                
                <tr>
				<td class="td" align="right">扩展参数：</td>
				<td class="td" align="left"><input type="text" name="applyArg1" class="text-big-noedit"  id="applyArg1"/>
				<td><span id="applyArg1Tip" class="tip_init"></span></td>
				</tr>
				
            </table>
        </div><div class="pop-footer">
		<span class="left">
			<input id="okButton" type="button" value='添加' onclick="doSubmit();" class="button-normal"></input>
		</span> 
		<span class="right">			
			<input type="button" value="取消" onclick="doClose();" class="button-normal"></input>
		</span>
	</div>
</form>
</body>
</html>
