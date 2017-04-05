<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/views/common/taglibs.jsp"%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title></title>
<%@ include file="/views/common/meta.jsp" %>
<link rel="stylesheet" type="text/css" href="${basePath}/css/pop-up.css" />
<script type="text/javascript" src="${basePath}/js/jquery/jquery-1.9.1.js"></script>
</head>
<script type="text/javascript" >
	function doClose(){
		window.parent.closeBox();
	}
</script>

<body style="margin:0;">
<div id="tck" >
  <div class="mid">
    <table width="100%" border="0" cellspacing="0" cellpadding="0" >
      <tr>
        <td  align="right" class="td"  width="25%">用户名称：</td>
        <td  align="left" class="td"  width="20%">${user.loginId}</td>
        <td  class="td" align="right" width="25%">真实姓名：</td>
        <td class="td" align="left" > ${user.realName}</td>
      </tr>
      
      <tr>
        <td  align="right" class="td" >性别：</td>
        <td  align="left" class="td">	
        <c:choose>
          <c:when test="${user.gender==2}">女</c:when>
          <c:otherwise>男</c:otherwise>
        </c:choose></td>
        <td  class="td" align="right">所属部门：</td>
        <td class="td" align="left" > ${user.institutionName}</td>
      </tr>
      
      <tr>
        <td  align="right" class="td" >出生日期：</td>
        <td  align="left" class="td"><fmt:formatDate value="${user.birthday}" pattern="yyyy-MM-dd"/>	</td>
        <td  class="td" align="right">是否市场管理员：</td>
        <td class="td" align="left" >
        <c:choose>
           <c:when test="${user.isCollector==1}">是</c:when>
           <c:otherwise>否</c:otherwise>
        </c:choose></td>
      </tr>
      
      <tr>
        <td  align="right" class="td" >移动电话：</td>
        <td  align="left" class="td">${user.mobilePhone}	</td>
        <td  class="td" align="right">办公电话：</td>
        <td class="td" align="left" > ${user.officePhone}</td>
      </tr>
      
      <tr>
        <td  align="right" class="td" >住宅电话：</td>
        <td  align="left" class="td">${user.homePhone}	</td>
        <td  class="td" align="right">电子邮件：</td>
        <td class="td" align="left" > ${user.email}</td>
      </tr>
      
      <tr>
        <td  align="right" class="td" >家庭住址：</td>
        <td  align="left" class="td">${user.homeAddress}	</td>
        <td  class="td" align="right">备注：</td>
        <td class="td" align="left" > ${user.remark}</td>
      </tr>
      
      </table>
      </div>
</div>

</body>
</html>