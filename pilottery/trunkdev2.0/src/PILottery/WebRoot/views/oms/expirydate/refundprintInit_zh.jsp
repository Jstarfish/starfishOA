<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/views/common/taglibs.jsp"%>
<html>
<head>
<title>游戏开奖</title>
<link rel="stylesheet" type="text/css" href="${basePath}/css/style.css" />
<link rel="stylesheet" type="text/css" href="${basePath}/css/pop-up.css" />
<link rel="stylesheet" type="text/css" href="${basePath}/css/validate.css" />

<link rel="stylesheet" href="${basePath}/component/messageBox/myJsBox.css" type="text/css"/>
<script type="text/javascript" src="${basePath}/component/messageBox/myJsBox_zh.js"></script>
<script type="text/javascript" src="${basePath}/js/oms/myJs.js"></script>
<script type="text/javascript" src="${basePath}/js/jquery/jquery-1.9.1.js"></script>
<link type="text/css" rel="stylesheet" href="${basePath}/views/oms/game-draw/css/myStyle.css" />
<script type="text/javascript">
function doSubmit() {
	var  url="${basePath}/refundquery.do?method=refunInfoPrint&reqtsn=${refundForm.reqtsn}";
	showPage(url,'打印');
}

</script>
</head>

<body>
<form action="refundquery.do?refunInfoPrint" method="post" id="refundForm" name="refundForm">

<div id="title">中心退票 </div>
<div id="mainDiv">
   <div class="jdt" style="background: url(views/oms/game-draw/img/zxtpbj-3.png) no-repeat left top;">
    </div>
    <div class="xd">
        <span style="margin-left: 40px;">1.退票</span>
        <span style="margin-left: 120px;">2.退票信息</span>
        <span class="zi" style="margin-left: 90px;">3.打印退票信息</span>   
    </div>
    <div class="CPage">
        <table width="900" border="0" cellpadding="0" cellspacing="0">
            <tr>
                <td width="820" align="left" valign="middle">
                    <div class="tab">
                        <table border="0" cellpadding="0" cellspacing="0" height="100%" width="100%">
                            <tr>
                                <td colspan="3" class="tit">
                                    <span style="font-size: 24px;">3. 打印退票信息</span>
                                </td>
                                 			
                            </tr>
                        
									
	<tr>
		<td width="130" align="right"><img src="<%=request.getContextPath() %>/img/right.png" width="49" height="49" /></td>
		<td width="170" colspan="2" align="left" ><span style="font-size:18px; text-align:left;">退票完成!</span>
		</td>
	</tr>
	<tr>
		<td colspan="3" align="center" height="80">
		
			<input type="button"  onclick="doSubmit()" value="打印退票凭证" class="btn-pz"></input></td>
		</tr>
                        </table>
                    </div>

                </td>
                <td align="right">
                 
                </td>
            </tr>
            <tr height="60">
                <td align="center" valign="middle">
		         
                </td>
                <td></td>
            </tr>
        </table>
    </div>

</div>

</form>
</body>
</html>