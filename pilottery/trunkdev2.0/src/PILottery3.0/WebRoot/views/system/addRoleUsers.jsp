<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8"%>
<%@ include file="/views/common/taglibs.jsp"%>
<%@ include file="/views/common/meta.jsp"%>

<html>
<head>
<title>编辑角色用户</title>
<link rel="stylesheet" type="text/css" href="${basePath}/css/style.css" />
<link rel="stylesheet" type="text/css" href="${basePath}/css/validate.css" />
<link rel="stylesheet" type="text/css" href="${basePath}/views/system/css/bootstrap.min.css" />
<script type="text/javascript" src="${basePath}/js/jquery/jquery-1.9.1.js"></script>
<script type="text/javascript" src="${basePath}/views/system/js/bootstrap.min.js"></script>
<script type="text/javascript" src="${basePath}/views/system/js/multiselect.min.js"></script>
<script type="text/javascript" src="${basePath}/js/myJs.js"></script>
<style>
.github.ribbon {
	position: fixed;
	display: block;
	top: 40px;
	right: 0;
	border: 0;
	z-index: 1001;
}

#wrap {
	padding-top: 70px;
}

#home h1 {
	margin-bottom: 30px;
}
#demo,
#examples,
#support,
#download {
	padding-top: 40px;
}

</style>
<script type="text/javascript">
	function saveRole() {
		var canSubmit = true;
		if (canSubmit) {
			button_off("okButton");
			$("#roleForm").submit();
		}
	}
	jQuery(document).ready(function($) {
		$('#undo_redo').multiselect();
	});
	
	function doClose(){
		window.parent.closeBox();
	}
</script>
</head>
<body>
	<form:form modelAttribute="roleForm" id="roleForm"
		action="role.do?method=saveRoleUser">
		<input type="hidden" id="roleid" name="roleid" value="${role.id}"/>
		<div class="pop-body">
			<table class="content_box">
				<tr>
					<td class="left"></td>
					<td>
						<table>
							<tr>
								<td class="f_left_td" style="width:50px"></td>
								<td class="f_left_td" style="height:50px" colspan="2" >
								 <font color=""style="front:14px/ 20px '微软雅黑', Arial, Helvetica, sans-serif">Current Role Name： ${role.name}</font>
								</td>
								<td class="f_left_td" style="width:50px"></td>
							</tr>
							<tr>
								 <td class="f_left_td" style="width:50px"></td>  
								<td class="f_left_td" colspan="2">
									<div class="row"  style="width:820px">
										<div class="col-xs-5">
											<select name="undo_redo" id="undo_redo" class="form-control" size="24"  multiple="multiple">
												<c:forEach var="u1" items="${allUsers}"> 
													<option value="${u1.id}">${u1.realName}(${u1.institutionName})</option>
												</c:forEach> 
											</select>
										</div>
										
										<div class="col-xs-1">
											<button type="button" id="undo_redo_rightAll" class="btn btn-default btn-block"><i class="glyphicon glyphicon-forward"></i></button>
											<button type="button" id="undo_redo_rightSelected" class="btn btn-default btn-block"><i class="glyphicon glyphicon-chevron-right"></i></button>
											<button type="button" id="undo_redo_leftSelected" class="btn btn-default btn-block"><i class="glyphicon glyphicon-chevron-left"></i></button>
											<button type="button" id="undo_redo_leftAll" class="btn btn-default btn-block"><i class="glyphicon glyphicon-backward"></i></button>
										</div>
										
										<div class="col-xs-5">
											<select name="undo_redo_to" id="undo_redo_to" class="form-control" size="24" multiple="multiple">
												<c:forEach var="u2" items="${currUsers}" > 
													<option value="${u2.id}">${u2.realName}(${u2.institutionName})</option>
												</c:forEach>
											</select>
										</div>
									</div>
								</td>
								<!-- <td class="f_left_td" style="width:50px"></td>	 -->							
							</tr>
							<!-- <tr>
								<td class="f_left_td" style="width:50px"></td>
								<td align="center" colspan="2">
									<input type="button" onclick="saveRole()" value="Submit" class="button-normal" />
								</td>
								<td class="f_left_td" style="width:50px"></td>
							</tr> -->
						</table>
					</td>
					<td class="right"></td>
				</tr>
			</table>
		</div>

	<!-- <div style="position: absolute;	bottom: 0px;left:0px;right: 0px;background-color: #f9fafc;	height: 60px;border-top:1px solid #eaedf1;">
		<span style="float: left;margin-left: 50px;margin-top:15px;">
		<input id="okButton" type="button" onclick="saveRole()" value='Submit' class="button-normal"></input></span> 
		<span style="float: right;margin-right: 50px;margin-top:15px;">			
		<input type="button" value="Cancel" onclick="doClose();" class="button-normal"></input></span>
	</div> -->
		
	<div class="pop-footer">
		<span style="float: left;margin-left: 50px;margin-top:5px;">
		<input id="okButton" type="button" onclick="saveRole()" value='Submit' class="button-normal"></input></span> 
		<span style="float: right;margin-right: 50px;margin-top:5px;">			
		<input type="button" value="Cancel" onclick="doClose();" class="button-normal"></input></span>
	</div>
	</form:form>
</body>
</html>