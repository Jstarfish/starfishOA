<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/views/common/taglibs.jsp"%>
<html>
<head>
<title>List of Terminals</title>

<link rel="stylesheet" type="text/css" href="${basePath}/css/city-list.css" />
<link rel="stylesheet" type="text/css" href="${basePath}/css/style.css" />

<script type="text/javascript" src="${basePath}/js/jquery/jquery-1.9.1.js"></script>
<link rel="stylesheet" href="${basePath}/component/messageBox/myJsBox.css" type="text/css"/>
<script type="text/javascript" src="${basePath}/component/messageBox/myJsBox.js"></script>
<script type="text/javascript" src="${basePath}/js/oms/myJs.js"></script>
<script type="text/javascript" charset="UTF-8" >
jQuery(document).ready(function($) {
	initQueryCondition("#queryType","#queryString",'10','12','20');
});
function initQueryCondition(typeid,stringid,aglen,termlen,max){
	var initval = $(typeid).val();
	if( initval == 1 ){
		$(stringid).unbind("keyup");
		$(stringid).unbind("afterpaste");
		$(stringid).bind("keyup",function(){
			this.value=this.value.replace(/[^\d]/g,'');
		});
		$(stringid).bind("afterpaste",function(){
			this.value=this.value.replace(/[^\d]/g,'');
		});
		$(stringid).attr("maxLength",aglen);
	}else if( initval == 2 ){
		$(stringid).unbind("keyup");
		$(stringid).unbind("afterpaste");
		$(stringid).bind("keyup",function(){
			this.value=this.value.replace(/[^A-Za-z0-9\u1780-\u17ff\u4e00-\u9fa5]/g,'');
		});
		$(stringid).bind("afterpaste",function(){
			this.value=this.value.replace(/[^A-Za-z0-9\u1780-\u17ff\u4e00-\u9fa5]/g,'');
		});
		$(stringid).attr("maxLength",max);
	}else if(initval == 3){
		$(stringid).unbind("keyup");
		$(stringid).unbind("afterpaste");
		$(stringid).bind("keyup",function(){
			this.value=this.value.replace(/[^\d]/g,'');
		});
		$(stringid).bind("afterpaste",function(){
			this.value=this.value.replace(/[^\d]/g,'');
		});
		$(stringid).attr("maxLength",termlen);
	}else{
		$(stringid).unbind("keyup");
		$(stringid).unbind("afterpaste");
	
		$(stringid).attr("maxLength",max);
	}
	$(typeid).bind("change",function(){
		$(stringid).val("");
		var val = $(this).val();
		if(val == 1 ){
			$(stringid).unbind("keyup");
			$(stringid).unbind("afterpaste");
			$(stringid).bind("keyup",function(){
				this.value=this.value.replace(/[^\d]/g,'');
			});
			$(stringid).bind("afterpaste",function(){
				this.value=this.value.replace(/[^\d]/g,'');
			});
			$(stringid).attr("maxLength",aglen);
		}else if(val == 2 ){
			$(stringid).unbind("keyup");
			$(stringid).unbind("afterpaste");
			$(stringid).bind("keyup",function(){
				this.value=this.value.replace(/[^A-Za-z0-9\u1780-\u17ff\u4e00-\u9fa5]/g,'');
			});
			$(stringid).bind("afterpaste",function(){
				this.value=this.value.replace(/[^A-Za-z0-9\u1780-\u17ff\u4e00-\u9fa5]/g,'');
			});
			$(stringid).attr("maxLength",max);
		}else if(val == 3){
			$(stringid).unbind("keyup");
			$(stringid).unbind("afterpaste");
			$(stringid).bind("keyup",function(){
				this.value=this.value.replace(/[^\d]/g,'');
			});
			$(stringid).bind("afterpaste",function(){
				this.value=this.value.replace(/[^\d]/g,'');
			});
			$(stringid).attr("maxLength",termlen);
		}else{
			$(stringid).unbind("keyup");
			$(stringid).unbind("afterpaste");
			$(stringid).attr("maxLength",max);
		}
	});
}
function updateQuery(){
	var typeId = document.getElementById("queryType");
	var obj = document.getElementById("queryString");
	if (typeId.value == 1 || typeId.value == 3) {
		obj.value=obj.value.replace(/[^\d]/g,'');
	}
	if (typeId.value == 2) {
		obj.value=obj.value.replace(/[^A-Za-z0-9\u1780-\u17ff\u4e00-\u9fa5]/g,'');
	}
	$("#queryForm").attr("action", "terminal.do?method=queryTerminal");
	$("#queryForm").submit();
}

var confirmDisable = 'Are you sure you want to disable this terminal';//您确认禁用 终端机
var disableTerminal = 'Disable Terminal';//禁用 终端
var confirmEnable = 'Are you sure you want to enable this terminal';//您确认启用终端机
var enableTerminal = 'Enable Terminal';//启用终端
var confirmReturn = 'Are you sure you want to delete this terminal';//您确认清退终端机
var returnTerminal = 'Delete Terminal';//退机终端

function promptDisable(url,terminalCodeToChar) {
	var msg = confirmDisable + ": "+terminalCodeToChar+"?";
	showDialog("operTerminal('"+url+"')",disableTerminal,msg);

}

function promptEnable(url,terminalCodeToChar) {

	var msg = confirmEnable+": "+terminalCodeToChar+"?";
	showDialog("operTerminal('"+url+"')",enableTerminal,msg);
}


function promptReturn(url,terminalCodeToChar) {

	var msg = confirmReturn+": "+terminalCodeToChar+"?";
	showDialog("operTerminal('"+url+"')",returnTerminal,msg);
}

function operTerminal(url){
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

function doExport(){
	location.href = $('.docExport a').attr('href');
}

function clearValue(){
	$(".text-normal").val('');
	$(".select-normal").val(0);
}
function exportcsv(){
	$("#queryForm").attr("action", "terminal.do?method=exportCSV");
	$("#queryForm").submit();
}
</script>
</head>
<body>
	<div id="title">
   		<span>Terminal Management</span>
	</div>

	<div class="queryDiv">
   		<form:form modelAttribute="terminalForm" action="terminal.do?method=queryTerminal" id="queryForm">
   		<input type="hidden" id="pageIndex1" name="pageIndex1" value="${pageIndex1}">
   			<div class="left">
				<span>
				<span>
   			          Institution：<select name="areaCode" class="select-normal" id="areaCode">
						    <option value="">--Please Select--</option>
						    <c:forEach var="data" items="${orgList}">
						     <option value="${data.orgCode}" <c:if test="${terminalForm.areaCode==data.orgCode }">selected</c:if>>${data.orgName }</option>
						    </c:forEach>
						</select>
   			    </span>
					<form:select path="terminalQueryType.typeValue" class="select-normal" id="queryType">
						<form:options items="${terminalQueryTypes}"/>
					</form:select>
				</span>
				<span><form:input path="terminalQueryString" id="queryString" class="text-normal" autocomplete="off"/></span>
				<span>Terminal Status：
					<form:select path="terminalStatus.value" class="select-normal" id="terminalStatus">
						<form:options items="${terminalStatusForm}"/>
				     </form:select>
				</span>
				<input type="button" value='Query' onclick="updateQuery();" class="button-normal"></input>
				<input type="button" value='Clear' class="button-normal" onclick="clearValue()"></input>
   			</div>
   			<div class="right">
   				<table width="300" border="0" cellspacing="0" cellpadding="0">
                    <tr style="height:50px;line-height:50px">
                      <td align="right">
                        <input type="button" value='New Terminal' onclick="showBox('terminal.do?method=addTerminal&fatherArea=${row.agencyCode}&areaType=5','New Terminal',400,700)" class="button-normal"></input>
                      </td>
                    </tr>
                  </table>
   			</div>
   		</form:form>
	</div>

	<div id="headDiv">
        <table width="100%" border="0" cellpadding="0" cellspacing="0">
            <tr><td>
            <table class="datatable" id="exportPdf">
                <tr class="headRow">
                  <td style="width: 10px;">&nbsp;</td>
                   <td style="width:120px">Terminal Code</td>
                   <td width="1%">|</td>
                   <td style="width:120px">Outlet Code</td>
                   <td width="1%">|</td>
                   <td style="width:12%">Outlet Name</td>
                   <td width="1%">|</td>
                   <td style="width:9%">UID</td>
                   <td width="1%">|</td>
                   <td style="width:100px">Machine Model</td>
                   <td width="1%">|</td>
                   <td style="width:145px">MAC Address</td>
                   <td width="1%">|</td>
                   <td style="width:50px">Status</td>
                   <td width="1%">|</td>
                   <td style="width:*%" class="no-print">Operation</td>
                </tr>
            </table>
           </td>
           <td style="width:17px;background:#2aa1d9"></td>
          </tr>
       </table>
    </div>

    <div id="bodyDiv">
    	<table class="datatable" id="exportPdfData">
    		<c:forEach var="data" items="${pageDataList}" varStatus="status" >
    		<tr class="dataRow">
    		<td style="width: 10px;">&nbsp;</td>
    			<td style="width:120px">${data.terminalCodeToChar }</td>
    			<td width="1%">&nbsp;</td>
                <td style="width:120px">${data.agencyCodeToChar }</td>
                <td width="1%">&nbsp;</td>
                <td style="width:12%" title="${data.agencyName }">${data.agencyName }</td>
                <td width="1%">&nbsp;</td>
                <td style="width:9%">${data.uniqueCode }</td>
                <td width="1%">&nbsp;</td>
                <td style="width:100px">${data.terminalTypeName }</td>
                <td width="1%">&nbsp;</td>
                <td style="width:145px">${data.macAddress }</td>
                <td width="1%">&nbsp;</td>
                <td style="width:50px">  <c:forEach var="sta" items="${terminalStatusForm}">
                <c:if test="${sta.key==data.terminalStatus.value }">
                ${sta.value}
                </c:if>
                </c:forEach></td>
                <td width="1%">&nbsp;</td>
                <td style="width:*%" class="no-print">
                	<c:choose>
						<c:when test="${data.terminalStatus.value == 1}">
							<span>Enable</span> |
							<span><a href="#" onclick="promptDisable('terminal.do?method=disableTerminalByCode&terminalcode=${data.terminalCode}&unicode=${data.uniqueCode}&mac=${data.macAddress}','${data.terminalCodeToChar}');">Disable</a></span> |
							<span><a href="#" onclick="promptReturn('terminal.do?method=returnTerminalByCode&terminalcode=${data.terminalCode}&unicode=${data.uniqueCode}&mac=${data.macAddress}','${data.terminalCodeToChar}')">Delete</a></span> |
							<span><a href="#" onclick="showBox('terminal.do?method=editTerminal&terminalcode=${data.terminalCode}','Edit Terminal',400,700)">Edit</a></span>
						</c:when>
						<c:when test="${data.terminalStatus.value == 2}">
							<span><a href="#" onclick="promptEnable('terminal.do?method=enableTerminalByCode&terminalcode=${data.terminalCode}&unicode=${data.uniqueCode}&mac=${data.macAddress}','${data.terminalCodeToChar}');">Enable</a></span> |
							<span>Disable</span> |
							<span><a href="#" onclick="promptReturn('terminal.do?method=returnTerminalByCode&terminalcode=${data.terminalCode}&unicode=${data.uniqueCode}&mac=${data.macAddress}','${data.terminalCodeToChar}')">Delete</a></span> |
												<span><a href="#" onclick="showBox('terminal.do?method=editTerminal&terminalcode=${data.terminalCode}','Edit Terminal',400,700)">Edit</a></span>
						</c:when>
						<c:when test="${data.terminalStatus.value == 3}">
							<span>Enable</span> |
							<span>Disable</span> |
							<span>Delete</span> |
							<span>Edit</span>
						</c:when>
					</c:choose>
                </td>
    		</tr>
    		</c:forEach>
    	</table>
    	${pageStr }
    </div>

</body>
</html>