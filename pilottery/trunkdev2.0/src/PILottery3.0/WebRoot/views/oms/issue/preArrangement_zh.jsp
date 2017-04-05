<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/views/common/taglibs.jsp"%>
<html>
<head>
</head>
<body>
  <!-- <div class="jiantou"><img src="${basePath}/img/show.gif" width="70" height="45"/></div> -->
  <div class="show" style="margin-top:40px;width:670px;overflow-y:auto">
    <table class="datatable" >
        <tr class="headRow">
          <td scope="col">期号</td>
          <td scope="col">开始时间</td>
          <td scope="col">结束时间</td>
        </tr>
        
     <c:forEach items="${issueList}" var="n" varStatus="s">
        <tr class="dataRow">
          <td ><span  class="hongzid">${n.issueNumber}</span></td>
          <td ><fmt:formatDate value="${n.planStartTime}" pattern="yyyy-MM-dd HH:mm:ss"/></td>
          <td ><fmt:formatDate value="${n.planCloseTime}" pattern="yyyy-MM-dd HH:mm:ss"/></td>
        </tr>
    </c:forEach>  
    </table>
  </div>

  <div class="clear"> 
    <input id="nextBtn" type="button" class="button-normal" onclick="saveData();"  value="保存" style="float:right;"/>
  </div>
</body>
</html>