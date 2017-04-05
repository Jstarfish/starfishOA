<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/views/common/taglibs.jsp"%>
<html>
<head>
<title></title>
<%@ include file="/views/common/meta.jsp" %>
<script type="text/javascript" src="${basePath}/js/jquery/jquery-1.9.1.js"></script>
<script type="text/javascript" src="${basePath}/js/jquery/jquery.form.js"></script>
<link rel="stylesheet" type="text/css" href="${basePath}/css/validate.css" />
<link rel="stylesheet" type="text/css" href="${basePath}/css/style.css" />
<script type="text/javascript" src="${basePath}/js/myJs.js"></script>
<script type="text/javascript">
function showYue(gameCode,id){
	$().ajaxSubmit({
		type : 'POST',
		url : 'gameManagement.do?method=showYue&gameCode='+gameCode,
		success : function(data) { 
			$("#"+id).html(data);
		}
	});
}
function updateView(){
	var result = true;
    if(!doCheck("adjAmount",/^[0-9]{1,12}$/,"* 1-12位数字")) {
    	result = false;
    }
    if(!doCheck("adjDesc",/^.{1,50}$/,"* 1-50个字符")) {
        result = false;
    }
    if(result) {
    	$("#createForm").attr("action","gameManagement.do?method=savePoolAdj");
    	button_off("butt");
		$("#createForm").submit();
    }
}
</script>
</head>
<body>
<div id="title">奖池调整</div>

<div style="width:650px; height:300px; background-color: white;margin-left:auto;margin-right:auto;">
	<form:form modelAttribute="createForm" method="post">

		<table width="100%" border="0" cellspacing="0" cellpadding="0" height="200px">
        <thead>
	        <tr>
	           <td colspan="2" style="background:#2aa1d9;height:42px;font-size:18px;color:#fff;
               line-height:42px;padding-left:20px;padding-right:10px;">
                   奖池调整
               </td>
	        </tr>
        </thead>
		<tbody style="font-size:14px;">
		      <tr height="10px"><td colspan="2"></td></tr>
			  <tr style="height: 35px;">
				<td width="30%" align="right">游戏名称：&nbsp;&nbsp;&nbsp;</td>
			    <td>			
					<form:select path="gamePoolAdj.gameCode" class="select-big" id="gameCode" onchange="showYue(this.value,'showYue');">
						<c:forEach items="${games}" var="s">
							<form:option value="${s.gameCode}">${s.shortName}</form:option>
						</c:forEach>
					</form:select>
				</td>
			  </tr> 
			  <tr style="height: 35px;">
			    <td align="right">奖池余额：&nbsp;&nbsp;&nbsp;</td>
			    <td>
			    	<span id="showYue">${gamePool.poolAmountAfter}</span>
				</td>
			  </tr>
			  <tr style="height: 35px;">
				<td align="right">变更金额：&nbsp;&nbsp;&nbsp;</td>
				<td>
			    	<form:input path="gamePoolAdj.adjAmount" id="adjAmount" class="text-big" maxlength="12" onblur="value=value.replace(/[^0-9]/g,'')"/>&nbsp;&nbsp;&nbsp;&nbsp;
			    	<span id="adjAmountTip"></span>
				</td>
			  </tr>
			  <tr style="height: 35px;">
				<td align="right">变更类型：&nbsp;&nbsp;&nbsp;</td>
				<td>
					调节基金拨入
					<input type="hidden" name="gamePoolAdj.poolAdjType" value="4"/>
				</td>
			  </tr>
			  <tr style="height: 35px;">
				<td align="right">变更备注：&nbsp;&nbsp;&nbsp;</td>
				<td>
			    	<form:input path="gamePoolAdj.adjDesc" id="adjDesc" class="text-big" maxlength="50" />&nbsp;&nbsp;&nbsp;&nbsp;
			    	<span id="adjDescTip"></span>
				</td>
			  </tr>
			  <tr height="20px"><td colspan="2"></td></tr>
			  <tr>
				  <td></td>
				  <td align="center" style="padding-right:150px;">
				    <input type="button" id="butt" onclick="updateView();" class="button-normal" value='提交'>
				  </td>
			  </tr>
			  </tbody>
			</table>
	</form:form>
</div>
</body>
</html>