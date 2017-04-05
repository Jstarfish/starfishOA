<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/views/common/taglibs.jsp"%>

<html>
<head>
<title>游戏开奖</title>
<link rel="stylesheet" type="text/css" href="${basePath}/css/style.css" />
<link rel="stylesheet" type="text/css" href="${basePath}/css/pop-up.css" />
<link rel="stylesheet" type="text/css" href="${basePath}/css/validate.css" />

<link rel="stylesheet" href="${basePath}/component/messageBox/myJsBox.css" type="text/css"/>
<script type="text/javascript" src="${basePath}/component/messageBox/myJsBox.js"></script>

<script type="text/javascript" src="${basePath}/js/oms/myJs.js"></script>
<script type="text/javascript" src="${basePath}/js/jquery/jquery-1.9.1.js"></script>


<link type="text/css" rel="stylesheet" href="${basePath}/views/oms/game-draw/css/myStyle.css" />


<style type="text/css">

</style>
<script type="text/javascript">


function doSubmit() {
    var url="centerSelect.do?method=printInfo&carId=${expirydateForm.carId}";
    // document.expirydateForm.submit();
   // showBox(url,'打印兑奖单',500,800);
    showPage(url,'打印兑奖单');
    
}

</script>
</head>

<body>
<form:form modelAttribute="expirydateForm" action="centerSelect.do?method=printInfo" method="post" id="expirydateForm" name="expirydateForm">
<form:hidden path="carId"/>
<div id="title">中心兑奖 </div>
<div id="mainDiv">
    <div class="jdt" style="background: url(views/game-draw/img/zxdjbj-4.png) no-repeat left top;">
    </div>
    <div class="xd"  style="width:650px">
          	<span >1.查询</span>
        	<span >2.中奖录入数据</span>
        	<span >3.中奖信息</span>
    		<span class="zi">4.打印兑奖单</span>
    </div>
    <div class="CPage">
        <table width="900" border="0" cellpadding="0" cellspacing="0">
            <tr>
                <td width="820" align="left" valign="middle">
                    <div class="tab">
                        <table border="0" cellpadding="0" cellspacing="0" height="100%" width="100%">
                            <tr>
                                <td colspan="3" class="tit">
                                    <span style="font-size: 24px;">4. 打印兑奖单</span>
                                </td>
                                 			
                            </tr>
                        
									
	<tr>
		<td width="130" align="right"><img src="<%=request.getContextPath() %>/img/right.png" width="49" height="49" /></td>
		<td width="170" colspan="2" align="left" ><span style="font-size:18px; text-align:left;">兑奖完成！</span>
		</td>
	</tr>
	<tr>
		<td colspan="3" align="center" height="80">
		
			<input type="button"  onclick="doSubmit()" value="打印兑奖凭证" class="btn-pz"></input>
			</td>
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

</form:form>
</body>
</html>