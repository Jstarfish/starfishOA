<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8"%>
<%@ include file="/views/common/taglibs.jsp"%>
<html>
<head>
<title>Management Inst Setting</title>
<%@ include file="/views/common/meta.jsp"%>
<link rel="stylesheet" type="text/css" href="${basePath}/css/style.css" />
<link rel="stylesheet" type="text/css" href="${basePath}/css/pop-up.css" />
<link rel="stylesheet" type="text/css" href="${basePath}/css/validate.css" />
<link rel="stylesheet" href="${basePath}/component/messageBox/myJsBox.css" type="text/css" />
<script type="text/javascript" src="${basePath}/component/messageBox/myJsBox_zh.js"></script>
<script type="text/javascript" src="${basePath}/js/jquery/jquery-1.9.1.js"></script>
<script type="text/javascript" src="${basePath}/js/myJs_zh.js"></script>
<script type="text/javascript" src="${basePath}/js/oms/city-list.js"></script>

<script type="text/javascript">
	function doClose(){
		window.parent.closeBox();
	}
</script>
</head>
<body>
	<form id="orgForm" name="orgForm" action="user.do?method=saveInstSetting" method="post">
		<div class="pop-body">
			<input type="hidden" name="userId" value="${user.id }"/>
			<table width="100%" border="0" cellspacing="0" cellpadding="0">
				<tr>
					<td align="right" width="20%">User Name：</td>
					<td align="left" width="35%">${user.loginId }</td>
				</tr>
				<tr>
					<td align="right" width="20%">Real Name：</td>
					<td align="left" width="35%">${user.realName }</td>
				</tr>
				<tr>
					<td align="right" width="20%">Institution：</td>
					<td align="left" width="35%">${user.institutionName }</td>
				</tr>
			</table>
			
			<div style="padding:0 20px; margin-top:10px; ">
                 <div style="position:relative; z-index:1000px;">
                   <table class="datatable" id="table1_head" width="100%">
                     <tbody><tr>
                       <th width="4%">&nbsp;</th>
                       <th width="45%">Institution Code</th>
                       <th width="6%">|</th>
                       <th width="45%">Institution Name</th>
                     </tr>
                   </tbody></table>
                 </div>
                 <div id="box" style="border:1px solid #ccc;">
                   <table id="oltable" class="datatable" cellpadding="0" cellspacing="0" width="100%">
                     <tbody>
                      <c:forEach var="item"	items="${orgsList}" varStatus="i">
	                     <tr>
	                       <td style="width:4%">
	                       		<input type="checkbox" name="mOrgCode" value="${item.orgCode}" 
	                       			<c:forEach var="mo" items="${manageOrgList}" varStatus="k">
	                       				<c:if test="${item.orgCode == mo.orgCode}"> checked="checked"</c:if>
	                       			</c:forEach>
	                       		></input>
	                       </td>
	                       <td style="width:45%">${item.orgCode}</td>
	                       <td style="width:10%">&nbsp;</td>
	                       <td style="width:45%">${item.orgName}</td>
	                     </tr>
                     </c:forEach>
                   </tbody></table>
                 </div>
            </div>
		</div>
		<div class="pop-footer">
			<span class="left">
				<input id="okBtn" type="submit" value='Submit' class="button-normal"></input>
			</span> 
			<span class="right">
				<input type="button" value="Cancel" onclick="doClose();" class="button-normal"></input>
			</span>
		</div>
	</form>
</body>
</html>