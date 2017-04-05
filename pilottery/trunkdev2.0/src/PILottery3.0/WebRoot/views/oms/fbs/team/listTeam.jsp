<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/views/common/taglibs.jsp"%>
<html>
<head>

<title>Team List</title>

<%@ include file="/views/common/meta.jsp" %>
<link rel="stylesheet" type="text/css" href="${basePath}/css/style.css" />
<link rel="stylesheet" href="${basePath}/component/messageBox/myJsBox.css" type="text/css"/>
<script type="text/javascript" src="${basePath}/component/messageBox/myJsBox.js"></script>
<script type="text/javascript" src="${basePath}/component/My97DatePicker/WdatePicker.js"></script>
<script type="text/javascript" src="${basePath}/js/jquery/jquery-1.9.1.js"></script>

<script type="text/javascript" charset="UTF-8">
function delte(teamCode){
	var msg = "Are you sure you want to delete?";
	showDialog("delteTeam('"+teamCode+"')","Delete",msg);
}

function delteTeam(teamCode) {
   
	var url="team.do?method=deleteTeam&teamCode=" + teamCode;
			$.ajax({
				url : url,
				dataType : "json",
				scriptCharset: 'utf-8',
				async : false,
				success : function(r){
			            if(r.message!='' && r.message!=null){
				            closeDialog();
			            	showError(r.message);
				        }
			            else{
			            	closeDialog();	
			            	window.location.reload(); 
				       }
			}
			});
	  
}

</script>

</head>
<body>
    <!-- 顶部标题块 -->
    <div id="title">Teams</div>
    
    <!-- 查询条件块 -->
    <div class="queryDiv">
            <div class="right">
                <table width="260" border="0" cellspacing="0" cellpadding="0">
                    <tr style="height:50px;line-height:50px">
                        <td align="right">
                            <input type="button" value="New Team"  onclick="showBox('team.do?method=initAddTeam','New Team',380,660);" class="button-normal"></input>
                        </td>
                    </tr>
                </table>
            </div>
    </div>
    
    <!-- 列表表头块 -->
    <div id="headDiv">
        <table width="100%" border="0" cellpadding="0" cellspacing="0">
            <tr>
                <td>
                    <table class="datatable">
                        <tr class="headRow">
                        <td style="width:10px;">&nbsp;</td>
                            <td style="width:15%">Team Code</td>
                            <td width="1%" >|</td>
                            <td style="width:15%">Short Name</td>
                            <td width="1%" >|</td>
                            <td style="width:15%">Full Name</td>
                            <td width="1%" >|</td>
                            <td style="width:15%">Country</td>
                            <td width="1%" >|</td>
                            <td style="width:20%">Remark</td>
                            <td width="1%" >|</td>
                            <td style="width:*%">Operation</td>
                        </tr>
                    </table>
                 </td>
                 <!-- 表头和下方数据对齐 -->
                 <td style="width:17px;background:#2aa1d9"></td>
             </tr>
        </table>
    </div>
    
    <!-- 列表内容块 -->
    <div id="bodyDiv">
        <table class="datatable">
         <c:forEach var="data" items="${teamList}" varStatus="status" >
            <tr class="dataRow">
            <td style="width:10px;">&nbsp;</td>
                <td style="width:15%">${data.teamCode }</td>
                <td width="1%" >&nbsp;</td>
                <td style="width:15%" title="${data.shortName }">${data.shortName }</td>
                <td width="1%" >&nbsp;</td>
                <td style="width:15%" title="${data.fullName }">${data.fullName }</td>
                <td width="1%" >&nbsp;</td>
                <td style="width:15%" title="${data.countryName }">${data.countryName }</td>
                <td width="1%" >&nbsp;</td>
                <td style="width:20%" title="${data.remark }">${data.remark }</td>
                <td width="1%" >&nbsp;</td>
                <td style="width:*%">
                    <span><a href="#" onclick="showBox('team.do?method=modifyTeamInit&teamCode=${data.teamCode }','Edit',400,700);">Edit</a></span>&nbsp;|
                    <span><a href="#" onclick="delte('${data.teamCode }')">Delete</a></span>
                </td>
            </tr>
            </c:forEach>
        </table>
      ${pageStr} 
    </div>
</body>
</html>