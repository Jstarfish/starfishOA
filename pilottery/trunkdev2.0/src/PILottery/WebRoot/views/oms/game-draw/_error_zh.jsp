<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/views/common/taglibs.jsp"%>
<html>
<head>
<title>游戏开奖</title>
<%@ include file="/views/common/meta.jsp" %>

<link type="text/css" rel="stylesheet" href="${basePath}/views/oms/game-draw/css/myStyle.css" />
<script type="text/javascript" src="${basePath}/views/oms/game-draw/js/myJs.js"></script>

<style type="text/css">

</style>


<script type="text/javascript">


</script>

</head>
<body>
<div id="title">手工开奖 </div>

<div id="mainDiv">
    <div class="CPage">
	    <div class="tab" style="width:820px;margin-left:auto;margin-right:auto;">
	        <table border="0" cellpadding="0" cellspacing="0" height="100%"  width="100%">
	         <tr>
	             <td colspan="2" class="tit">
	                 <span>游戏名称：${gameDrawInfo.shortName}</span>
	                 <span>&nbsp;&nbsp;|&nbsp;&nbsp;</span>
	                 <span>游戏期号：${gameDrawInfo.issueNumber}</span>
	             </td>
	         </tr>
	         <tr height="90"></tr>
	         <tr height="90">
	             <td width="35%" align="right">
	                 <img src="views/oms/game-draw/img/error.png" width="49" height="49" />
	             </td>
	             <td>
	                 <div style="color:#000;font-size:18px;padding-left:10px">
	                   <span> 期次开奖过程中出现错误!<br/></span>
                       <span> 请点击 <a href="gameDraw.do?method=manualDraw">重新开奖</a> 返回</span>
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
