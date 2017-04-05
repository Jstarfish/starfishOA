<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/views/common/taglibs.jsp"%>
<html>
<head>

<title>修改仓库信息</title>

<%@ include file="/views/common/meta.jsp" %>
<link rel="stylesheet" type="text/css" href="${basePath}/css/style.css"/>
<link rel="stylesheet" type="text/css" href="${basePath}/css/pop-up.css"/>
<link rel="stylesheet" href="${basePath}/component/messageBox/myJsBox.css" type="text/css"/>
<link rel="stylesheet" type="text/css" href="${basePath}/css/validate.css"/>

<script type="text/javascript" src="${basePath}/js/myJs.js"></script>
<script type="text/javascript" src="${basePath}/component/messageBox/myJsBox_zh.js"></script>
<script type="text/javascript" src="${basePath}/component/My97DatePicker/WdatePicker.js"></script>
<script type="text/javascript" src="${basePath}/js/jquery/jquery-1.9.1.js"></script>
<script type="text/javascript" src="${basePath}/js/regexEnum.js"></script>

<style type="text/css">
.datatable {
    border-collapse: collapse;
    border:1px solid #ccc;
    background: #fff;
    font-family: "微软雅黑";
    font-size: 12px;
}
.datatable img {
    line-height: 20px;
    vertical-align: middle;
    display:block;
}
.datatable th {
    background-color: #2aa1d9;
    height: 35px;
    line-height: 35px;
    color: #fff;
    text-align: left;
    padding-left: 5px;
    font-size: 12px;
}
.datatable td {
    border-bottom: 1px solid #e4e5e5;
    height: 35px;
    line-height: 35px;
    text-align: left;
    padding-left: 10px;
    font-size: 12px;
}
.datatable caption {
    color: #33517A;
    padding-top: 3px;
    padding-bottom: 8px;
}
.datatable tr:hover, .datatable tr.hilite {
    background-color: #f3f4f4;
    color: #000000;
}
.address-area {
    border:1px solid #40a7da;
    background-color:#FFF;
    width:91.9%;
    color:#000;
    font-size:14px;
    vertical-align:middle;
}
</style>

<script type="text/javascript" charset="UTF-8">
function doClose() {
    window.parent.closeBox();
}

//验证非空
function isNotEmptyString(value) {
    return value != '' ? true : false;
}

$(document).ready(function(){
	//提交与提交前校验
    $("#okButton").bind("click", function(){
        var result = true;
        
        if (!checkFormComm('modifyWarehouseForm')) {
        	result = false;
        }
        
        if (!doCheck("warehouseName", isNotEmptyString($("#warehouseName").val()), "不可为空")) {
            result = false;
        }
        
        if (!doCheck("contactPhone", isNotEmptyString($("#contactPhone").val()), "不可为空")) {
            result = false;
        }
        
        if (!doCheck("warehouseAddress", isNotEmptyString($("#warehouseAddress").val()), "不可为空")) {
            result = false;
        }

        if (result) {
            button_off("okButton");
            $("#modifyWarehouseForm").submit();
        }
    });
});
</script>

</head>
<body>
	<form action="warehouses.do?method=modifyWarehouse" id="modifyWarehouseForm" method="POST">
		<div class="pop-body">
			<table width="100%" border="0" cellspacing="0" cellpadding="0" style="margin-top:25px;">
				<tr>
					<td width="25%" align="right">仓库编号：</td>
					<td width="35%" align="center">
						<input id="warehouseCode" name="warehouseCode" class="text-big-noedit" value="${details.warehouseCode}" readonly="readonly"></input>
					</td>
					<td><span id="warehouseCodeTip" class="tip_init">*</span></td>
				</tr>
				<tr>
					<td width="25%" align="right">仓库名称：</td>
					<td width="35%" align="center">
						<input id="warehouseName" name="warehouseName" class="text-big" value="${details.warehouseName}" maxlength="40" isCheckSpecialChar="true" cMaxByteLength="500"></input>
					</td>
					<td><span id="warehouseNameTip" class="tip_init">*</span></td>
				</tr>
				<tr>
					<td width="25%" align="right">机构编号：</td>
					<td width="35%" align="center">
						<input id="institutionCode" name="institutionCode" class="text-big-noedit" value="${details.orgCode}" readonly="readonly"></input>
					</td>
					<td><span id="institutionCodeTip" class="tip_init">*</span></td>
				</tr>
				<tr>
					<td width="25%" align="right">机构名称：</td>
					<td width="35%" align="center">
						<input id="institutionName" name="institutionName" class="text-big-noedit" value="${details.orgName}" readonly="readonly"></input>
					</td>
					<td><span id="institutionNameTip" class="tip_init">*</span></td>
				</tr>
				<tr>
					<td width="25%" align="right">联系电话：</td>
					<td width="35%" align="center">
						<input id="contactPhone" name="contactPhone" class="text-big" value="${details.phone}" maxlength="40" isCheckSpecialChar="true" cMaxByteLength="15"></input>
					</td>
					<td><span id="contactPhoneTip" class="tip_init">*</span></td>
				</tr>
				<tr>
					<td width="25%" align="right">负责人：</td>
					<td width="35%" align="center">
				    	<select id="contactPerson" name="contactPerson" class="select-big">
	                    	<option value="${details.directorAdmin}">${details.directorName}</option>
	                        <c:forEach var="director" items="${availableDirectors}" varStatus="status">
	                        	<option value="${director.id}">${director.realName}</option>
	                        </c:forEach>
	                	</select>
                    </td>
                    <td><span id="contactPersonTip" class="tip_init">*</span></td>
				</tr>
				<tr>
					<td width="25%" align="right">仓库状态：</td>
					<td width="35%" align="center">
						<c:if test="${details.status == 1}">
							<input id="status" name="status" class="text-big-noedit" value="启用" readonly="readonly"></input>
						</c:if>
						<c:if test="${details.status == 2}">
							<input id="status" name="status" class="text-big-noedit" value="停用" readonly="readonly"></input>
						</c:if>
						<c:if test="${details.status == 3}">
							<input id="status" name="status" class="text-big-noedit" value="盘点中" readonly="readonly"></input>
						</c:if>
					</td>
					<td><span id="statusTip" class="tip_init">*</span></td>
				</tr>
				<tr>
					<td width="25%" align="right">仓库地址：</td>
					<td width="35%" align="center">
						<textarea id="warehouseAddress" name="warehouseAddress" rows="4" class="address-area" style="width:200px" maxlength="600" isCheckSpecialChar="true" cMaxByteLength="500">${details.address}</textarea>
					</td>
					<td><span id="warehouseAddressTip" class="tip_init">*</span></td>
				</tr>
			</table>
	
			<div style="padding:0 20px; margin-top:10px;margin-bottom:30px;">
				<table style="width:100%" class="datatable">
					<tr>
						<th width="1px">&nbsp;</th>
						<th width="21%">管理员编码</th>
						<th width="2%">|</th>
						<th width="21%">管理员登录名</th>
						<th width="2%">|</th>
						<th width="21%">真实姓名</th>
						<th width="2%">|</th>
						<th width="21%">联系电话</th>
						<th width="2%">|</th>
						<th width="*%" style="padding-left:9px;">管理员</th>
					</tr>
					<c:forEach var="manager" items="${availableManagers}" varStatus="status">
						<tr>
							<td width="1px">&nbsp;</td>
							<td width="21%" title="${manager.id}">${manager.id}</td>
							<td width="2%">&nbsp;</td>
							<td width="21%" title="${manager.loginId}">${manager.loginId}</td>
							<td width="2%">&nbsp;</td>
							<td width="21%" title="${manager.realName}">${manager.realName}</td>
							<td width="2%">&nbsp;</td>
							<td width="21%" title="${manager.mobilePhone}">${manager.mobilePhone}</td>
							<td width="2%">&nbsp;</td>
							<td width="*%">
								<c:if test="${manager.isWarehouseManger == 1}">
									<input type="checkbox" id="warehouseManager" name="warehouseManager" value="${manager.id}" checked="checked"/>
								</c:if>
								<c:if test="${manager.isWarehouseManger != 1}">
									<input type="checkbox" id="warehouseManager" name="warehouseManager" value="${manager.id}"/>
								</c:if>
							</td>
						</tr>
					</c:forEach>
				</table>
			</div>
		</div>
		
	    <div class="pop-footer">
	    	<span class="left">
	        	<input id="okButton" type="button" value="确定" class="button-normal"></input>
	        </span>
	        <span class="right">
	            <input id="cancelButton" type="button" value="取消" class="button-normal" onclick="doClose();"></input>
	        </span>
		</div>
	</form>
</body>
</html>