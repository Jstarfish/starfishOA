<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/views/common/taglibs.jsp"%>
<html>
<head>
<title>软件版本管理</title>
<%@ include file="/views/common/meta.jsp" %>
<link rel="stylesheet" type="text/css" href="${basePath}/css/style.css" />
<script type="text/javascript" src="${basePath}/js/jquery/jquery-1.9.1.js"></script>
<link rel="stylesheet" href="${basePath}/component/messageBox/myJsBox.css" type="text/css"/>
<script type="text/javascript" src="${basePath}/component/messageBox/myJsBox.js"></script>
<script type="text/javascript" src="${basePath}/js/oms/myJs.js"></script>

<script type="text/javascript" charset="UTF-8" > 
function promptDelete(url,packageVersion) {
	
	//var msg = "您确认删除"+packageVersion+" 软件版本吗?";
	var msg = "Are you sure you want to delete version"+packageVersion+" ?";
	showDialog("operSoftVersion('"+url+"')","Delete Version",msg);
	
}

function promptDisable(url,packageVersion) {
	
	//var msg = "您确认禁用"+packageVersion+" 软件版本吗?";
	var msg = "Are you sure you want to disable version"+packageVersion+" ?";
	showDialog("operSoftVersion('"+url+"')","Disable Version",msg);
	
}

function promptEnable(url,packageVersion) {
	
	//var msg = "您确认启用"+packageVersion+" 软件版本吗?";
	var msg = "Are you sure you want to enable version"+packageVersion+" ?";
	showDialog("operSoftVersion('"+url+"')","Enable Version",msg);
}

function operSoftVersion(url){
	button_off("ok_button");
	$.ajax({
		url : url,
		dataType : "json",
		method : "post",
		async : false,
		success : function(r){
	            if(r.reservedSuccessMsg!='' && r.reservedSuccessMsg!=null){
		            closeDialog();
	            	showError(decodeURI(r.reservedSuccessMsg));
		        }
	            else{
	            	window.location.reload(); 
		       }
		}
	});
}
</script>
</head>
<body>
	<div id="title">
		<span>Software Version Management</span>
	</div>
	<div class="queryDiv">
		<div class="left">
		
		</div>
		<div class="right">
			<table width="260" border="0" cellspacing="0" cellpadding="0">
				<tr style="height:50px;line-height:50px">
					<td align="right">
						<input type="button" value="New Version" onclick="showBox('tmversionPackage.do?method=addSoftVerPackage','New Version',300,700)" class="button-normal"></input>
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
	</div>
	<div id="headDiv">
        <table width="100%" border="0" cellpadding="0" cellspacing="0">
        	<tr><td>
            <table class="datatable">
                <tr class="headRow">
               	   <td style="width: 10px;">&nbsp;</td>
                   <td style="width:10%" class="nowrap">Version</td>
                   <th width="1%">|</th>
                   <td style="width:15%" class="nowrap">Description</td>
                   <th width="1%">|</th>
                   <td style="width:10%" class="nowrap">Machine</td>
                   <th width="1%">|</th>
                   <td style="width:15%" class="nowrap">Release Time</td>
                   <th width="1%">|</th>
                   <td style="width:10%">Status</td>
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
    			<td style="width:10%" title="${data.packageVersion }">${data.packageVersion }</td>
    			<td width="1%">&nbsp;</td>
    			<td style="width:15%" title="${data.packageDescription }">${data.packageDescription }</td>
    			<td width="1%">&nbsp;</td>
    			<td style="width:10%">${data.terminalTypes.typeName}</td>
    			<td width="1%">&nbsp;</td>
    			<td style="width:15%">${data.releaseDateToChar }</td>
    			<td width="1%">&nbsp;</td>
    			<td style="width:10%">
    				<c:if test="${data.isValid == 2}">
    					Disable
    				</c:if>
    				<c:if test="${data.isValid == 3}">
    					Delete
    				</c:if>
    				<c:if test="${data.isValid == 1}">
    					Enable
    				</c:if>
    			</td>
    			<td style="width:*%" class="operate">
    				<c:if test="${data.isValid == 1}"><%--启用状态 --%>
    					<span>
    						<a href="#" onclick="promptDisable('tmversionPackage.do?method=editValidByCode&packVer=${data.packageVersion}&termType=${data.terminalType}&valid=2','${data.packageVersion }')">Disable</a>
    					</span> | 
    					<span>
    						<a href="#" onclick="promptDelete('tmversionPackage.do?method=editValidByCode&packVer=${data.packageVersion}&termType=${data.terminalType}&valid=3','${data.packageVersion }')">Delete</a>
    					</span>
    				</c:if>
    				<c:if test="${data.isValid == 2}"><%--禁用状态 --%>
    					<span>
    						<a href="#" onclick="promptEnable('tmversionPackage.do?method=editValidByCode&packVer=${data.packageVersion}&termType=${data.terminalType}&valid=1','${data.packageVersion }')">Enable</a>
    					</span> | 
    					<span>
    						<a href="#" onclick="promptDelete('tmversionPackage.do?method=editValidByCode&packVer=${data.packageVersion}&termType=${data.terminalType}&valid=3','${data.packageVersion }')">Delete</a>
    					</span>
    				</c:if>
    				<c:if test="${data.isValid == 3}"><%--删除状态 --%>
    					&nbsp;&nbsp;&nbsp;---
    				</c:if>
    				<!--<c:choose>
						<c:when test="${data.isValid == 2}" >
							<span><a href="#" onclick="promptEnable('tmversionPackage.do?method=editValidByCode&packVer=${data.packageVersion}&termType=${data.terminalType}&valid=1','${data.packageVersion }')">Enable</a></span> |
							<span>Disable</span>
						</c:when>
							
						<c:when test="${data.isValid == 1}" >
							<span>Enable</span> |
							<span><a href="#" onclick="promptDisable('tmversionPackage.do?method=editValidByCode&packVer=${data.packageVersion}&termType=${data.terminalType}&valid=3','${data.packageVersion }')">Disable</a></span>
						</c:when>
					</c:choose>-->
    			</td>
    		</tr>
    		</c:forEach>
    	</table>
    	${pageStr }
   	</div>
</body>
</html>
