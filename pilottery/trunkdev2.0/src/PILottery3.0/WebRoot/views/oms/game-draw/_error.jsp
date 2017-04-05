<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/views/common/taglibs.jsp"%>
<html>
<head>
<title>Game Drawing</title>
<%@ include file="/views/common/meta.jsp" %>

<link type="text/css" rel="stylesheet" href="${basePath}/views/oms/game-draw/css/myStyle.css" />
<script type="text/javascript" src="${basePath}/views/oms/game-draw/js/myJs.js"></script>

<style type="text/css">

</style>


<script type="text/javascript">


</script>

</head>
<body>
<div id="title">Manual Drawing </div>

<div id="mainDiv">
    <div class="CPage">
	    <div class="tab" style="width:820px;margin-left:auto;margin-right:auto;">
	        <table border="0" cellpadding="0" cellspacing="0" height="100%"  width="100%">
	         <tr>
	             <td colspan="2" class="tit">
	                 <span>Game:${gameDrawInfo.shortName}</span>
	                 <span>&nbsp;&nbsp;|&nbsp;&nbsp;</span>
	                 <span>Issue:${gameDrawInfo.issueNumber}</span>
	             </td>
	         </tr>
	         <tr height="90"></tr>
	         <tr height="90">
	             <td width="35%" align="right">
	                 <img src="views/oms/game-draw/img/error.png" width="49" height="49" />
	             </td>
	             <td>
	                 <div style="color:#000;font-size:18px;padding-left:10px">
	                   <span> Error occurred during drawing!<br/></span>
                       <span> Please click <a href="gameDraw.do?method=manualDraw">Restart</a> to go back.</span>
                     </div>
                 </td>
	         </tr>
	         <tr></tr>
	        </table>
	    </div>
    </div>
</div>

</body>
</html>
