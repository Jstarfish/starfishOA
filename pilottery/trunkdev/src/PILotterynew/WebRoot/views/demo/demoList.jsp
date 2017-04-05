<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/views/common/taglibs.jsp"%>
<html>
<head>
<title>用户列表</title>
<%@ include file="/views/common/meta.jsp" %>

<link rel="stylesheet" type="text/css" href="${basePath}/css/style.css" />

<link rel="stylesheet" href="${basePath}/component/messageBox/myJsBox.css" type="text/css"/>
<script type="text/javascript" src="${basePath}/component/messageBox/myJsBox.js"></script>
<script type="text/javascript" src="${basePath}/js/jquery/jquery-1.9.1.js"></script>
<script type="text/javascript" src="${basePath}/js/myJs.js"></script>
<script type="text/javascript" charset="UTF-8" > 

function prompt(userid, action) {
	switch(action){
	case 3:
		var msg = "Are you sure you want to delete the user?";
		showDialog("deleteUser("+userid+")","Delete",msg);
		break;
	default: 
		break;
	
	}
	
};
function deleteUser(userid) {
	var url = "demo.do?method=deleteDemo&userId=" + userid;
	$.get(url,	
		function(result){
			closeDialog();				
			window.location.reload(); 
		});
};
</script>

</head>
<body>
<div id="title">User Inquiry</div>
	<div class="queryDiv">
	<form:form modelAttribute="demoForm" action="demo.do?method=demoList">
		<div class="cx">
			<div class="left">
				<span>Login Name：
			   	 	<form:input path="userName" maxlength="20" class="text-normal"/>
			    </span>
				<button class="button-normal">Query</button>
		    </div>
		    <div class="right"> 
  				<table width="100" border="0" cellspacing="0" cellpadding="0" style="margin-top:2px;">
				  <tr style="height:50px;line-height:50px">
				    <td><input type="button" class="button-normal" value="New Demo" 
				    onclick="showBox('demo.do?method=newDemo','New Demo',350,700)"/></td>
				    <td align="right">
						&nbsp;
	               	</td>
				  </tr>
				</table>
		    </div>
		</div>
	</form:form>
	</div>
	<div id="headDiv" style="position:fixed;width:100%;z-index: 2;">
	<table width="100%"  border="0" cellpadding="0" cellspacing="0">
       <tr><td>
		<table id="row" style="float:left;" class="datatable">
		<thead>
		<tr class="headRow">
		<td style="width:10%" scope="col">User Code</td> 
		<td style="width:12%" scope="col">Login Name</td> 
		<td style="width:12%" scope="col">User Name</td> 
		<td style="width:12%" scope="col">Email</td> 
		<td style="width:16%" scope="col">Telephone</td> 
		<td style="width:*%" scope="col">Operation</td> 
		</tr>
		</thead>
        </table>
        <td style="width:17px;background:#2aa1d9;"></td></tr>
    </table>
	</div>
	
    <div id="bodyDiv">
        <table class="datatable" id="exportPdfData">
        	<%int i = 0;%>
            <c:forEach var="u" items="${pageDataList}" varStatus="status" >
            
            <tr class="dataRow">
            	<td style="width:10%">${u.id}</td> 
				<td style="width:12%" scope="col">${u.account}</td> 
				<td style="width:12%" scope="col">${u.realname}</td> 
				<td style="width:12%" scope="col">${u.email}</td> 
				<td style="width:16%" scope="col">${u.tel}</td> 
				<td style="width:*%" scope="col">
					<a href="#" onclick="showBox('demo.do?method=editDemo&userId=${u.id}','Edit Demo',350,700)" >Edit Info</a>
					 |
					<a href="#" onclick="prompt('${u.id}', 3)">Delete</a>			
				</td> 
            </tr>
		</c:forEach>
        </table>
        ${pageStr }
    </div>
</html>
