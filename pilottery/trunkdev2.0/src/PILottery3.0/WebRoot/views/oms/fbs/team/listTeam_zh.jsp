<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/views/common/taglibs.jsp"%>
<html>
<head>

<title>球队列表</title>

<%@ include file="/views/common/meta.jsp" %>
<link rel="stylesheet" type="text/css" href="${basePath}/css/style.css" />
<link rel="stylesheet" href="${basePath}/component/messageBox/myJsBox.css" type="text/css"/>
<script type="text/javascript" src="${basePath}/component/messageBox/myJsBox_zh.js"></script>
<script type="text/javascript" src="${basePath}/component/My97DatePicker/WdatePicker.js"></script>
<script type="text/javascript" src="${basePath}/js/jquery/jquery-1.9.1.js"></script>

<script type="text/javascript" charset="UTF-8">

function delte(teamCode){
	var msg = "确认删除吗?";
	showDialog("delteTeam('"+teamCode+"')","删除",msg);
}

function delteTeam(teamCode) {
   
	var url="team.do?method=deleteTeam&teamCode=" + teamCode;
			$.ajax({
				url : url,
				dataType : "json",
				contentType: "application/x-www-form-urlencoded; charset=UTF-8", 
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
    <div id="title">球队列表</div>
    
    <!-- 查询条件块 -->
    <div class="queryDiv">
            <div class="right">
                <table width="260" border="0" cellspacing="0" cellpadding="0">
                    <tr style="height:50px;line-height:50px">
                        <td align="right">
                            <input type="button" value="新增球队"  onclick="showBox('team.do?method=initAddTeam','新增球队',380,600);" class="button-normal"></input>
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
                            <td style="width:15%">球队编码</td>
                            <td width="1%" >|</td>
                            <td style="width:15%">球队简称</td>
                            <td width="1%" >|</td>
                            <td style="width:15%">球队全称</td>
                            <td width="1%" >|</td>
                            <td style="width:15%">所属地区</td>
                             <td width="1%" >|</td>
                            <td style="width:20%">备注信息</td>
                             <td width="1%" >|</td>
                            <td style="width:*%">操作</td>
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
                    <span><a href="#" onclick="showBox('team.do?method=modifyTeamInit&teamCode=${data.teamCode }','修改',400,700);">修改</a></span>&nbsp;|
                    <span><a href="#" onclick="delte('${data.teamCode }')">删除</a></span>
                </td>
            </tr>
            </c:forEach>
        </table>
      ${pageStr} 
    </div>
</body>
</html>