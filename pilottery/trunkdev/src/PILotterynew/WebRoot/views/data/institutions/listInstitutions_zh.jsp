<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/views/common/taglibs.jsp"%>
<html>
<head>

<title>部门列表</title>

<%@ include file="/views/common/meta.jsp" %>
<link rel="stylesheet" type="text/css" href="${basePath}/css/style.css" />
<link rel="stylesheet" href="${basePath}/component/messageBox/myJsBox.css" type="text/css"/>
<script type="text/javascript" src="${basePath}/component/messageBox/myJsBox_zh.js"></script>
<script type="text/javascript" src="${basePath}/component/My97DatePicker/WdatePicker.js"></script>
<script type="text/javascript" src="${basePath}/js/jquery/jquery-1.9.1.js"></script>

<script type="text/javascript" charset="UTF-8">
function updateQuery() {
	 $("#institutionsForm").submit();
}
function delte(orgCode){
	var msg = "确认删除吗?";
	showDialog("delteInstitutions('"+orgCode+"')","删除",msg);
}
function delteInstitutions(areaCode) {
   

	var url="institutions.do?method=deleteInstitutions&orgCode=" + areaCode;
	  
	 
			$.ajax({
				url : url,
				dataType : "json",
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
function openwin(url,title,height,width) { 
	window.open (url, title, "height='+height, width='+width, toolbar=no, menubar=no, scrollbars=no, resizable=no, location=no, status=no")

}
</script>

</head>
<body>
    <!-- 顶部标题块 -->
    <div id="title">部门列表</div>
    
    <!-- 查询条件块 -->
    <div class="queryDiv">
        <form action="institutions.do?method=listInstitutions" method="POST" id="institutionsForm" method="post">
            <div class="left">
                <span>部门编码: <input id="orgCode" name="orgCode" value="${institutionsForm.orgCode }" class="text-normal" maxlength="4"/></span>
                <span>部门名称: <input id="orgName" name="orgName" value="${institutionsForm.orgName }" class="text-normal" /></span>
                <input type="button" value="查询" onclick="updateQuery();" class="button-normal"></input>
            </div>
            <div class="right">
                <table width="260" border="0" cellspacing="0" cellpadding="0">
                 <c:if test="${orgCode=='00'}">
                    <tr style="height:50px;line-height:50px">
                        <td align="right">
                            <input type="button" value="新增部门"  onclick="showBox('institutions.do?method=addInit','新增部门',650,700);" class="button-normal"></input>
                        </td>
                    </tr>
                    </c:if>
                </table>
            </div>
        </form>
    </div>
    
    <!-- 列表表头块 -->
    <div id="headDiv">
        <table width="100%" border="0" cellpadding="0" cellspacing="0">
            <tr>
                <td>
                    <table class="datatable">
                        <tr class="headRow">
                        <td style="width:10px;">&nbsp;</td>
                            <td style="width:20%">部门编码</td>
                             <td width="1%" >|</td>
                            <td style="width:20%">部门名称</td>
                             <td width="1%" >|</td>
                            <td style="width:20%">负责人</td>
                             <td width="1%" >|</td>
                            <td style="width:20%">联系电话</td>
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
         <c:forEach var="data" items="${pageDataList}" varStatus="status" >
            <tr class="dataRow">
            <td style="width:10px;">&nbsp;</td>
                <td style="width:20%">${data.orgCode }</td>
                 <td width="1%" >&nbsp;</td>
                <td style="width:20%" title="${data.orgName }">${data.orgName }</td>
                 <td width="1%" >&nbsp;</td>
                <td style="width:20%" title="${data.directorAdmin }">${data.directorAdmin }</td>
                 <td width="1%" >&nbsp;</td>
                <td style="width:20%">${data.phone }</td>
                 <td width="1%" >&nbsp;</td>
                <td style="width:*%">
                    <span><a href="#" onclick="showBox('institutions.do?method=getInstitutionsCode&orgCode=${data.orgCode }','部门详情',550,930)">详情</a></span>&nbsp;|
                    <c:if test="${orgCode=='00'}">
                    <span><a href="#" onclick="showBox('institutions.do?method=modyInit&orgCode=${data.orgCode }','修改',650,700);">修改</a></span>&nbsp;|
                    </c:if>
                    <span><a href="#" onclick="delte('${data.orgCode }')">删除</a></span>
                </td>
            </tr>
            </c:forEach>
        </table>
      ${pageStr} 
    </div>
</body>
</html>