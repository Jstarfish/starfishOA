<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/views/common/taglibs.jsp"%>
<html>
<head>
<title>Fbs Draw</title>
<%@ include file="/views/common/meta.jsp" %>

<link type="text/css" rel="stylesheet" href="${basePath}/views/oms/fbs/fbsdraw/css/myStyle.css" />
<script type="text/javascript" src="${basePath}/views/oms/fbs/fbsdraw/js/myJs.js"></script>


</head>
<body>
<div id="title">Fbs Draw</div>

<div id="mainDiv">
    <div class="CPage">
	    <div class="tab" style="width:820px;margin-left:auto;margin-right:auto;">
	        <table border="0" cellpadding="0" cellspacing="0" height="100%"  width="100%">
	         <tr>
	             <td colspan="2" class="tit">
					 <span>Match Code：${matchCode}</span>
	                 <span>&nbsp;&nbsp;|&nbsp;&nbsp;</span>
					 <span>Match Teams：${matchStr}</span>
	             </td>
	         </tr>
	         <tr height="90"></tr>
	         <tr height="90">
	             <td width="35%" align="right">
	                 <img src="views/oms/fbs/fbsdraw/img/error.png" width="49" height="49" />
	             </td>
	             <td>
	                 <div style="color:#000;font-size:18px;padding-left:10px">
	                   <span> Error During Issue Draw Process!!<br/></span>
                       <span> Please Press <a href="fbsDraw.do?method=secondFbsDraw&matchCode=${matchCode}">Draw The Second Step Again</a> Return</span>
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
