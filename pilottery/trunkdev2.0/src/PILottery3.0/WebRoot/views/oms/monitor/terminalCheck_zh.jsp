<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8"%>
<%@ include file="/views/common/taglibs.jsp"%>
<html>
<head>
<title>巡检</title>
<%@ include file="/views/common/meta.jsp"%>
<link rel="stylesheet" type="text/css" href="${basePath}/css/style.css" />
<link rel="stylesheet" href="${basePath}/component/messageBox/myJsBox.css" type="text/css" />
<script type="text/javascript" src="${basePath}/component/messageBox/myJsBox_zh.js"></script>
<script type="text/javascript" src="${basePath}/component/My97DatePicker/WdatePicker.js"></script>
<script type="text/javascript" src="${basePath}/js/jquery/jquery-1.9.1.js"></script>

<style type="text/css">
#refreshBtn{
    position: relative;
    display: inline-block;
    line-height: 24px;
    color: #fff;
    cursor: pointer;
    border:1px;
    background-color: #90cd00;
    font-size:12px;
    margin-top:12px;
    margin-right:20px;
    float:right;
}
#refreshBtn:hover {
  background-color: #9bdb03;

}
</style>
</head>
<body>
	 <div id="title">巡检</div>
	 <div class="queryDiv">
		<form action="terminalCheck.do?method=listCheckRecords" id="form"
			method="post">
			<div class="left">
				<span>部门: 
            		<select class="select-normal" name="orgCode" >
            		 	<c:if test="${sessionScope.current_user.institutionCode == 00}">
            		 		<option value="">--所有--</option>
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
            	<span>巡检人:
            		<input id="termCheckName" name="termCheckName" value="${form.termCheckName }" class="text-normal">
                </span>
                <span>日期:
                     <input name="beginDate" value="${form.beginDate }" class="Wdate text-normal" onfocus="WdatePicker({lang:'zh-cn',dateFmt:'yyyy-MM-dd',readOnly:true})"/> 
                    	-
                    <input name="endDate" value="${form.endDate }" class="Wdate text-normal" onfocus="WdatePicker({lang:'zh-cn',dateFmt:'yyyy-MM-dd',readOnly:true})"/>
                </span>
                <input type="submit" value="查询" class="button-normal"></input>
            </div>
		</form>
	</div> 
	<div id="headDiv">
		<table width="100%" border="0" cellpadding="0" cellspacing="0">
			<tr>
				<td>
					<table class="datatable">
						<tr class="headRow">
							<td style="width:10px;">&nbsp;</td>
							<td style="width: 12%">站点编号</td>
							<th width="1%">|</th>
							<td style="width: 12%">站点名称</td>
							<th width="1%">|</th>
							<td style="width: 12%">终端机编号</td>
							<th width="1%">|</th>
							<td style="width: 12%">巡检时间</td>
							<th width="1%">|</th>
							<td style="width: 15%">巡检人</td>
						</tr>
					</table>
				</td>
				<td style="width: 17px; background: #2aa1d9"></td>
			</tr>
		</table>
	</div>
	<div id="bodyDiv">
		<table class="datatable" id="dataRows">
			<c:forEach var="data" items="${pageDataList}" varStatus="status">
				<tr class="dataRow">	
					<td style="width:10px;">&nbsp;</td>
					<td style="width: 12%">${data.agencyCode }</td>
					<td width="1%">&nbsp;</td>
					<td style="width: 12%" title="${data.agencyName }">${data.agencyName }</td>
					<td width="1%">&nbsp;</td>
					<td style="width: 12%" title="${data.terminalCode }">${data.terminalCode }</td>
					<td width="1%">&nbsp;</td>
					<td style="width: 12%" title="${data.checkTime }"><fmt:formatDate value="${data.checkTime }"  pattern="yyyy-MM-dd HH:mm:ss"/></td>
					<td width="1%">&nbsp;</td>
					<td style="width: 15%" title="${data.termCheckName }">${data.termCheckName }</td>
					<td width="1%">&nbsp;</td>
				</tr>
			</c:forEach>
		</table>
		${pageStr}
		</div>
</body>
</html>