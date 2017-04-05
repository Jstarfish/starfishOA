<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/views/common/meta.jsp" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>渠道游戏权限设置</title>
<link rel="stylesheet" href="${basePath}/css/bootstrap.min.css?v=3.3.6">
<link rel="stylesheet" href="${basePath}/css/cncp/common.css">
<link rel="stylesheet"
	href="${basePath}/css/plugins/sweetalert/sweetalert.css">

<script src="${basePath}/js/jquery.min.js"></script>
<script src="${basePath}/js/bootstrap.min.js"></script>
<script src="${basePath}/js/plugins/validate/jquery.validate.min.js"></script>
<script src="${basePath}/js/plugins/validate/messages_zh.min.js"></script>
<script src="${basePath}/js/plugins/sweetalert/sweetalert.min.js"></script>
<script src="${basePath}/js/cncp/common.js"></script>
<style type="text/css">
	.modal-footer{
		position:fixed;
		bottom:0;
		width:100%;
		background:#F5F5F5;
	}
</style>

<script type="text/javascript">
function checkbox(obj)
{
  if(obj.checked){
    obj.value=1;
  }else{
    obj.value=0;  
}
}

/* $().ready(function () {
    $("#form").validate({
    	onsubmit:true,
    	onfocusout:false,
    	onkeyup :false,
    	submitHandler: doSubmit
    });
});
 */
function doSubmit(){
	
	$.ajax({
	   type: "POST",
	   url: "dealer.do?method=updateGamePermissions",
	   data: $('#form').serialize(),
	   success: function(msg){
	     if(msg=='success'){
	    	 var index = parent.layer.getFrameIndex(window.name); 
	    	 parent.layer.close(index);  
	     }else{
	    	 sweetAlert("设置游戏权限出错", msg, "error");
	     }
	   }
	});
} 
</script>
</head>
<body style="overflow-y:auto;margin:15px;">
<div class="ibox-content">
	<form  method="post" id="form">
		<table class="table table-striped table-hover table-bordered">
			<thead>
				<tr>
					<th width="20%">游戏名称</th>
					<th width="20%">游戏类型</th>
					<th width="20%">是否可销售</th>
					<th width="*%">销售佣金比例 (‰)</th>
				</tr>
			</thead>
			<tbody>
				<c:forEach var="game" items="${gamePermission}" varStatus="s">
					<tr height="32">
						<input type="hidden" name="gpList[${s.index }].gameCode" id="gameCode" value="${game.gameCode }">
						<input type="hidden" name="gpList[${s.index }].dealerCode" id="dealerCode" value="${game.dealerCode }">
						<td>${game.gameName }</td>
						<td>
							<c:choose>
							<c:when test="${game.gameType == 1}">基诺</c:when>
							<c:when test="${game.gameType == 2}">乐透</c:when>
							<c:when test="${game.gameType == 3}">数字</c:when>
							<c:otherwise>其他</c:otherwise>
						</c:choose>
						</td>
						<td>
						  <input type="checkbox"  value="${game.isSale }" name="gpList[${s.index }].isSale" onclick="this.value=this.checked?1:0" <c:if test="${game.isSale == 1}">checked="checked"</c:if>/> 
						</td>
							<td><input id="saleComm" type="text" name="gpList[${s.index }].saleCommissionRate" size="8" maxlength="3" class="input-sm form-control"
								onblur="if(this.value == '')this.value='0';" value="${game.saleCommissionRate }"  
								onkeyup="this.value=this.value.replace(/[^\d,]/g,'')">
							</td>
					</tr>
				</c:forEach>
			</tbody>
		</table>
		 <div class="form-group col-md-8 col-sm-offset-5 text-center" >
             <button class="btn btn-primary" type="button" onclick="doSubmit()">提交</button>
         </div>
	</form>
</div>
</body>
</html>