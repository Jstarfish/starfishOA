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
	var msg = "您确认删除"+packageVersion+" 软件版本吗?";
	showDialog("operSoftVersion('"+url+"')","删除版本",msg);
	
}

function promptDisable(url,packageVersion) {
	
	//var msg = "您确认禁用"+packageVersion+" 软件版本吗?";
	var msg = "您确认禁用"+packageVersion+" 软件版本吗?";
	showDialog("operSoftVersion('"+url+"')","禁用版本",msg);
	
}

function promptEnable(url,packageVersion) {
	
	//var msg = "您确认启用"+packageVersion+" 软件版本吗?";
	var msg = "您确认启用"+packageVersion+" 软件版本吗?";
	showDialog("operSoftVersion('"+url+"')","启用版本",msg);
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
		<span>软件版本管理</span>
	</div>
	<div class="queryDiv">
		<div class="left">
		
		</div>
		<div class="right">
			<table width="260" border="0" cellspacing="0" cellpadding="0">
				<tr style="height:50px;line-height:50px">
					<td align="right">
						<input type="button" value="新增软件版本" onclick="showBox('tmversionPackage.do?method=addSoftVerPackage','新增软件版本',300,700)" class="button-normal"></input>
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
                   <td style="width:10%" class="nowrap">软件版本号</td>
                   <th width="1%">|</th>
                   <td style="width:15%" class="nowrap">描述</td>
                   <th width="1%">|</th>
                   <td style="width:10%" class="nowrap">终端机型号</td>
                   <th width="1%">|</th>
                   <td style="width:15%" class="nowrap">发布日期</td>
                   <th width="1%">|</th>
                   <td style="width:10%">状态</td>
                   <th width="1%">|</th>
                   <td style="width:*%" class="nowrap noprint">操作</td>
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
    					禁用
    				</c:if>
    				<c:if test="${data.isValid == 3}">
    					删除
    				</c:if>
    				<c:if test="${data.isValid == 1}">
    					启用
    				</c:if>
    			</td>
    			<td style="width:*%" class="operate">
    				<c:if test="${data.isValid == 1}"><%--启用状态 --%>
    					<span>
    						<a href="#" onclick="promptDisable('tmversionPackage.do?method=editValidByCode&packVer=${data.packageVersion}&termType=${data.terminalType}&valid=2','${data.packageVersion }')">禁用</a>
    					</span> | 
    					<span>
    						<a href="#" onclick="promptDelete('tmversionPackage.do?method=editValidByCode&packVer=${data.packageVersion}&termType=${data.terminalType}&valid=3','${data.packageVersion }')">删除</a>
    					</span>
    				</c:if>
    				<c:if test="${data.isValid == 2}"><%--禁用状态 --%>
    					<span>
    						<a href="#" onclick="promptEnable('tmversionPackage.do?method=editValidByCode&packVer=${data.packageVersion}&termType=${data.terminalType}&valid=1','${data.packageVersion }')">启用</a>
    					</span> | 
    					<span>
    						<a href="#" onclick="promptDelete('tmversionPackage.do?method=editValidByCode&packVer=${data.packageVersion}&termType=${data.terminalType}&valid=3','${data.packageVersion }')">删除</a>
    					</span>
    				</c:if>
    				<c:if test="${data.isValid == 3}"><%--删除状态 --%>
    					&nbsp;&nbsp;&nbsp;---
    				</c:if>
    				<!--<c:choose>
						<c:when test="${data.isValid == 2}" >
							<span><a href="#" onclick="promptEnable('tmversionPackage.do?method=editValidByCode&packVer=${data.packageVersion}&termType=${data.terminalType}&valid=1','${data.packageVersion }')">启用</a></span> |
							<span>禁用</span>
						</c:when>
							
						<c:when test="${data.isValid == 1}" >
							<span>启用</span> |
							<span><a href="#" onclick="promptDisable('tmversionPackage.do?method=editValidByCode&packVer=${data.packageVersion}&termType=${data.terminalType}&valid=3','${data.packageVersion }')">禁用</a></span>
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
