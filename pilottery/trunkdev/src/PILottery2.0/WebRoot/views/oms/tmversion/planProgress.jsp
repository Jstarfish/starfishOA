<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/views/common/taglibs.jsp"%>
<html>
<head>
<title>Download Progress</title>
<link rel="stylesheet" type="text/css" href="${basePath}/css/style.css" />
<link rel="stylesheet" type="text/css" href="${basePath}/css/pop-up.css" />
<link rel="stylesheet" type="text/css" href="${basePath}/css/validate.css" />
<link rel="stylesheet" href="${basePath}/component/messageBox/myJsBox.css" type="text/css"/>
<script type="text/javascript" src="${basePath}/component/messageBox/myJsBox.js"></script>
<script type="text/javascript" src="${basePath}/js/oms/myJs.js"></script>
<script type="text/javascript" src="${basePath}/js/jquery/jquery-1.9.1.js"></script>
<style type="text/css">
	.datatable tr:hover, .datatable tr.hilite {
	    background-color: #2aa1d9;
	    color: #ffffff;
	}
</style>
<script type="text/javascript" charset="UTF-8">
function doClose() {
    window.parent.closeBox();
}
</script>
</head>

<body>
  <div class="pop-body">
    <table class="datatable"  border="0">
      <tr class="headRow">
        <td width="10%">Terminal Code</td>
        <td width="10%" >Version</td>
        <td  width="10%">Download Time</td>
        <td  width="10%">Download File</td>
        <td  width="10%">Progress</td>
        <td  width="10%">Completed</td>
        <td  width="10%">Completion Time</td>
      </tr>
      <c:forEach var="term" items="${terms}">
        <tr class="dataRow">
          <td width="10%;"><c:out value="${term.termCodeTochar}"/></td>
          <td width="10%"><c:out value="${term.pkgVer}"/></td>
          <td  width="10%"><c:out value="${term.startDate}"/></td>
          <td  width="10%"><c:out value="${term.curFile}"/></td>
          <td  width="10%"><c:out value="${term.curFileProgress}"/></td>
          <td  width="10%"><c:out value="${term.isCompleteStr}"/></td>
          <td  width=10%><c:out value="${term.endDate}"/></td>
        </tr>
      </c:forEach>
    </table>
  </div>
  <div class="pop-footer">
    <span class="left"></span>
    <span class="right">
      <input type="button" value="Close" onclick="doClose();" class="button-normal"></input>
    </span>
  </div>
</body>
</html>
