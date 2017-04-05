<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/views/common/taglibs.jsp"%>
<html>
<head>
<title>Fbs Draw</title>
<%@ include file="/views/common/meta.jsp" %>

<link type="text/css" rel="stylesheet" href="${basePath}/views/oms/fbs/fbsdraw/css/myStyle.css" />
<script type="text/javascript" src="${basePath}/views/oms/fbs/fbsdraw/js/myJs.js"></script>

	<script type="text/javascript">

		function doReload(){

			location.href="fbsDraw.do?method=initFbsDraw";
//			window.parent.location.reload();
		}
	</script>

</head>
<body>
<div id="title">Fbs Draw </div>

<div id="mainDiv">
    <div class="CPage">
	    <div class="tab" style="width:820px;margin-left:auto;margin-right:auto;">
	        <table border="0" cellpadding="0" cellspacing="0" height="100%"  width="100%">
	         <tr height="90"></tr>
	         <tr height="90">
	             <td width="35%" align="right">
	                 <img src="views/oms/fbs/fbsdraw/img/error.png" width="49" height="49" />
	             </td>
	             <td>
	                 <div style="color:#000;font-size:18px;padding-left:10px">
	                   <span> Match ${newmatchCode} is drawing,no more match could be drawed!<br/></span>
                       <span> Please press <a href="#" onclick="doReload()">go back</a></span>
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
