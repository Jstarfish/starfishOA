<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/views/common/taglibs.jsp"%>
<html>
<head>
<title></title>
<%@ include file="/views/common/meta.jsp" %>
<link rel="stylesheet" type="text/css" href="${basePath}/css/style.css" />
<link rel="stylesheet" href="${basePath}/component/messageBox/myJsBox.css" type="text/css"/>
<script type="text/javascript" src="${basePath}/component/messageBox/myJsBox_zh.js"></script>
<script type="text/javascript" src="${basePath}/component/My97DatePicker/WdatePicker.js"></script>
<script type="text/javascript" src="${basePath}/js/jquery/jquery-1.9.1.js"></script>
<script type="text/javascript">

$(function() {
    $('#sel').change(function() {
    	var select = $('#sel').val();
    		if(select == 0){
    			$('#orgCode').val('');
				$('#operAdminName').val('');
				$('#marketAdminName').val('');
				$('#agencyCode').val(''); 
				$('#span1').hide();
				$('#span2').hide();
				$('#span3').hide();
				$('#span4').hide();
    		}
			if (select == 1) {
				$('#span1').show();
				$('#orgCode').val('');
				$('#marketAdminName').val('');
				$('#agencyCode').val(''); 
				$('#span2').hide();
				$('#span3').hide();
				$('#span4').hide();
			}
			if (select == 2) {
				$('#span2').show();
				$('#operAdminName').val('');
				$('#marketAdminName').val('');
				$('#agencyCode').val(''); 
				$('#span3').hide();
				$('#span4').hide();
				$('#span1').hide();
			}
			if (select == 3) {
				$('#span3').show();
				$('#orgCode').val('');
				$('#operAdminName').val('');
				$('#marketAdminName').val('');
				$('#span2').hide();
				$('#span1').hide();
				$('#span4').hide();
			}
			if (select == 4) {
				$('#span4').show();
				$('#orgCode').val('');
				$('#operAdminName').val('');
				$('#agencyCode').val('');
				$('#span2').hide();
				$('#span3').hide();
				$('#span1').hide();
			}
		});
    var selType = '${form.selType }';
    $('#sel').val(selType);
    $('#sel').trigger('change');
	});
var company = "${applicationScope.useCompany}";
function operateLogDetails(operNo,operModeId){
	if(operModeId == 1){
		if(company == 2){
			showBox('operateLog.do?method=outletAccountLogDetail&operNo='+operNo,'详情',550,800);
		}else{
			showBox('operateLog.do?method=outletAccountLogDetail&operNo='+operNo,'详情',300,650);
		}
	}
	if(operModeId == 2){
		showBox('operateLog.do?method=orgAccountLogDetail&operNo='+operNo,'详情',550,800);
	}
	if(operModeId == 3){
		showBox('operateLog.do?method=mmAccountLogDetail&operNo='+operNo,'详情',250,650);
	}
	if(operModeId == 4){
		showBox('operateLog.do?method=outletGameAuthLogDetail&operNo='+operNo,'详情',500,930);
	}
}
</script>
</head>
<body>
<div id="title">Operation Log Query </div>
<div class="queryDiv">
    <form id="form" action="operateLog.do?method=listOperateLog" method="post">
        <div class="left"> 
            <span>Operation Type:
                <select class="select-normal" name="operModeId" >
            			<option value="">--All--</option>
                   	   <c:forEach var="obj" items="${operateTypeList}" varStatus="var">
                   	   		<c:if test="${obj.operModeId == form.operModeId}">
                   	   			<option value="${obj.operModeId}" selected="selected">${obj.operModeName}</option>
                   	   		</c:if>
                   	   		<c:if test="${obj.operModeId != form.operModeId}">
                   	   			<option value="${obj.operModeId}">${obj.operModeName}</option>
                   	   		</c:if>
                   	   </c:forEach>
                    </select>
            </span> 
            <span>Status:
                <select name="operStatus" id="operStatus" class="select-normal">
                    <option value="">--All--</option>
                    <option value="1" <c:if test="${form.operStatus == 1}">selected="selected"</c:if>>Normal</option>
                    <option value="2" <c:if test="${form.operStatus == 2}">selected="selected"</c:if>>Abnormal</option>     
                </select>
            </span> 
             <span>Date:
                <input name="startTime" value="${form.startTime }" class="Wdate text-normal" onfocus="WdatePicker({lang:'zh-cn',dateFmt:'yyyy-MM-dd',readOnly:true})"/> 
                 	-
                <input name="endTime" value="${form.endTime }" class="Wdate text-normal" onfocus="WdatePicker({lang:'zh-cn',dateFmt:'yyyy-MM-dd',readOnly:true})"/>
             </span>
             <span>
              <select name="selType" id="sel" class="select-normal">
              		<option value="0">--Select--</option>
					<option	value='1'>Operator</option>
					<option	value='2'>Institution</option>
					<option	value='3'>Outlet</option>
					<option	value='4'>MarketManager</option>
			</select>
			</span>
			<span id="span1">
				<input type="text" name="operAdminName" class="text-normal" value="${form.operAdminName }"> 
			</span>
             
             <span id="span2"  style="display: none">
				<select class="select-normal" name="orgCode" >
           		 	<c:if test="${sessionScope.current_user.institutionCode == 00}">
           		 		<option value="">--All--</option>
           		 		<c:forEach var="obj" items="${orgList}" varStatus="s">
                   	   		<c:if test="${obj.orgCode != form.orgCode}">
                   	   			<option value="${obj.orgCode}">${obj.orgName}</option>
                   	   		</c:if>
                   	   		<c:if test="${obj.orgCode == form.orgCode}">
                   	   			<option value="${obj.orgCode}" selected="selected">${obj.orgName}</option>
                   	   		</c:if>
                  	  		</c:forEach>
           		 	</c:if>
           			<c:if test="${sessionScope.current_user.institutionCode != 00}">
           				<c:forEach var="obj" items="${orgList}" varStatus="s">
                   	   		<c:if test="${obj.orgCode == form.cuserOrg}">
                   	   			<option value="${obj.orgCode}" selected="selected">${obj.orgName}</option>
                   	   		</c:if>
                  	  		</c:forEach>
           		 	</c:if>
                   </select>
			</span>
			
			<span id="span3"  style="display: none">
				<input type="text" name="agencyCode" class="text-normal" value="${form.agencyCode }"> 
			</span>
			
			<span id="span4"  style="display: none">
				<input type="text" name="marketAdminName" class="text-normal" value="${form.marketAdminName }"> 
			</span>
             <input type="submit" value="Query" class="button-normal"></input>
        </div>
    </form>    
</div>
<div id="headDiv">
    <table width="100%"  border="0" cellpadding="0" cellspacing="0">
       <tr><td>
            <table class="datatable">
            	<tr class="headRow">
            		<td style="width:10px;">&nbsp;</td>
					<td style="width: 10%">Operation Time</td>
					<td width="1%">|</td>
                    <td style="width: 10%">Operator</td>
                    <td width="1%">|</td>
                    <td style="width: 10%">Operation Type</td>
                    <td width="1%">|</td>
                    <td style="width: 10%">Status</td>
                    <td width="1%">|</td>
                    <td style="width: 10%">Institution</td>
                    <td width="1%">|</td>
                    <td style="width: 10%">Outlet</td>
                    <td width="1%">|</td>
                    <td style="width: 10%">Market Manager</td>
                    <td width="1%">|</td>
                    <td style="width:*%">Operation</td>
				</tr>
			</table>
		</td><td style="width:17px;background:#2aa1d9"></td></tr>
    </table>
</div>
<div id="bodyDiv">
	<table class="datatable">
    	<c:forEach var="row" items="${pageDataList}">
        <tr class="dataRow">
        	<td style="width:10px;">&nbsp;</td>
        	<td style="width: 10%"><fmt:formatDate value="${row.operTime}" pattern="yyyy-MM-dd HH:mm:ss"/></td>
        	<td width="1%">&nbsp;</td>
        	<td style="width: 10%">${row.operAdminName}</td>
        	<td width="1%">&nbsp;</td>
        	<td style="width: 10%">${row.operModeName}</td>
        	<td width="1%">&nbsp;</td>
        	<td style="width: 10%">
        		<c:if test="${row.operStatus == 2}"><font color=red style="font-weight:bold">Abnormal</font></c:if>
        		<c:if test="${row.operStatus == 1}">Normal</c:if>
        	</td>
        	<td width="1%">&nbsp;</td>
        	<td style="width: 10%">${row.orgName}</td>
        	<td width="1%">&nbsp;</td>
        	<td style="width: 10%">${row.agencyCode}</td>
        	<td width="1%">&nbsp;</td>
        	<td style="width: 10%">${row.marketAdminName}</td>
        	<td width="1%">&nbsp;</td>
        	<td width="*%" class="xqzi">
				<span>
					<a href="#" id="logOperate" onclick="operateLogDetails('${row.operNo}','${row.operModeId }')" >Details</a>
				</span>
			</td>
        	</tr>
        	</c:forEach>
    </table>
    ${pageStr }
</div>
</body>
</html>