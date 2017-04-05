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
        <td  align="right" class="td"  width="25%">User Name：</td>
        <td  align="left" class="td"  width="20%">${user.loginId}</td>
        <td  class="td" align="right" width="25%">Real Name：</td>
        <td class="td" align="left" > ${user.realName}</td>
      </tr>
      
      <tr>
        <td  align="right" class="td" >Gender：</td>
        <td  align="left" class="td">	
        <c:choose>
          <c:when test="${user.gender==2}">Female</c:when>
          <c:otherwise>Male</c:otherwise>
        </c:choose></td>
        <td  class="td" align="right">Institution：</td>
        <td class="td" align="left" > ${user.institutionName}</td>
      </tr>
      
      <tr>
        <td  align="right" class="td" >Date of Birth：</td>
        <td  align="left" class="td"><fmt:formatDate value="${user.birthday}" pattern="yyyy-MM-dd"/>	</td>
        <td  class="td" align="right">Market Manager：</td>
        <td class="td" align="left" >
        <c:choose>
           <c:when test="${user.isCollector==1}">YES</c:when>
           <c:otherwise>NO</c:otherwise>
        </c:choose></td>
      </tr>
      
      <tr>
        <td  align="right" class="td" >Mobile Phone：</td>
        <td  align="left" class="td">${user.mobilePhone}	</td>
        <td  class="td" align="right">Office Phone：</td>
        <td class="td" align="left" > ${user.officePhone}</td>
      </tr>
      
      <tr>
        <td  align="right" class="td" >Home Phone：</td>
        <td  align="left" class="td">${user.homePhone}	</td>
        <td  class="td" align="right">Email：</td>
        <td class="td" align="left" > ${user.email}</td>
      </tr>
      
      <tr>
        <td  align="right" class="td" >Home Address：</td>
        <td  align="left" class="td">${user.homeAddress}	</td>
        <td  class="td" align="right">Remarks：</td>
        <td class="td" align="left" > ${user.remark}</td>
      </tr>
      
      </table>
      </div>
</div>

</body>
</html>