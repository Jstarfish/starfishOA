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

function showMsg() {
    if("${msg}" != null) {
        //alert("${msg}");
        doCheck("drawNumber",false,"${msg}");
    }
}
	//showMsg();

    function checkDrawNumber(){
        // 开奖号码格式 
        // 双色球:(01,02,03,04,05,06|07) 
        // 3D:(1,2,3)
        // KOC6HC:{01,02,03,04,05,06,07}
        var regex1;
        var errMsg = '* 开奖号码格式不正确!';

        //if("双色球" == findObj("gameCode").value) {
        //	regex1 = /^(([0-9]{2}\,){5})+([0-9]{2}\|[0-9]{2})$/;
        //} else if("3D" == findObj("gameCode").value) {
        //	regex1 = /^(([0-9]{1}\,){2})+([0-9]{1})$/
        //}

        if(6 == findObj("gameCode").value) {
            regex1 = /^(([0-9]{1}\,){3})+([0-9]{1})$/;
        } else if(7 == findObj("gameCode").value) {
        	regex1 = true;
        	var str = findObj("drawNumber").value;
        	var arr = str.split(",");
        	for(var i in arr){
            	if(arr[i] == null) {
                    regex1 = false;
                    break;
                }
                // 验证开奖号码是否有重复，如果有重复返回false
        		if(str.indexOf(arr[i]) != str.lastIndexOf(arr[i])) {
        			regex1 = false;
        			errMsg = '* 开奖号码不能有重复!';
        			break;
        	    } else if(arr[i] > 40 || arr[i] < 1){
        	        regex1 = false;
                    errMsg = '* 七龙星开奖号码只能01到40!';
                    break;
            	}
        	}

        	if(regex1) {
        	    regex1 = /^(([0-9]{2}\,){6})+([0-9]{2})$/;
        	}
        }else if(13 == findObj("gameCode").value) {
        	var str = findObj("drawNumber").value;
        	var regex13 = /^([0-9]{2})$/;
        	if(regex13.test(str)){
        		if(parseInt(str) > 0 && parseInt(str) < 41){
            		regex1 = true;
                }else{
                	regex1 = false;
                }
        	}else{
        		regex1 = false;
        	}
        } else {
        	regex1 = false;
        }

        var result = doCheck("drawNumber",regex1,errMsg);
    	return result;
    }
    
	function doSubmit() {
	    if(checkDrawNumber()){
	    	switch_obj("nextBtn","waitBtn");
	    	document.gameDrawForm.submit();
	    } 
	    return false;
	}

	window.onload= function(){
		showMsg();
    };

</script>

</head>
<body>
<form action="gameDraw.do?method=inputDrawNumber" method="post" id="gameDrawForm" name="gameDrawForm">
<div id="title">手工开奖</div>

<div id="mainDiv">
    <div class="jdt"  style="background: url(views/oms/game-draw/img/jdt-4.gif) no-repeat left top;">
    </div>
    <div class="xd">
        <span class="zi">1. 选择游戏</span>
        <span class="zi">2. 开奖数据整理</span>
        <span class="zi">3. 数据备份</span>
        <span class="zi">4. 开奖号码录入</span>
        <span>5. 中奖数据检索</span>
        <span>6. 派奖</span>
        <span>7. 生成中奖统计表</span>
        <span>8. 数据稽核</span>
        <span>9. 确认开奖</span>
    </div>
    <div class="CPage">
        <table width="900" border="0" align="center" cellpadding="0" cellspacing="0">
            <tr>
                <td width="820" align="left" valign="middle">
                    <div class="tab">
                        <table border="0" cellpadding="0" cellspacing="0" height="100%" width="100%;">
                            <tr>
                                <td colspan="3" class="tit">
                                    <span style="font-size: 24px;">4. 开奖号码录入</span>
                                </td>
                            </tr>
                            <tr height="50"></tr>
                            <tr height="60">
                                <td width="30%" class="lz">游戏名称：</td>
                                <td width="38%">
                                    <input id="gameCode" name="gameCode" type="hidden" value="${gameDrawInfo.gameCode}" class="my_input"/>
                                    <input id="shortName" name="shortName" type="text" value="${gameDrawInfo.shortName}" class="my_input" disabled style="background-color:#f2f1f1"/>
                                </td>
                                <td width="*%"><span class="tip_init">*</span></td>
                            </tr>
                            <tr height="60">
                                <td class="lz">游戏期号：</td>
                                <td>
                                    <input id="issueNumber" name="issueNumber" type="text" value="${gameDrawInfo.issueNumber}" class="my_input" readonly style="background-color:#f2f1f1"/>
                                </td>
                                <td><span class="tip_init">*</span></td>
                            </tr>
                            <tr height="60">
                                <td class="lz">开奖号码：</td>
                                <td>
                                    <input id="drawNumber" name="drawNumber" type="text" value="" class="my_input" onblur="checkDrawNumber()"/>
                                </td>
                                <td><span id="drawNumberTip" class="tip_init">*</span></td>
                            </tr>

                            <tr></tr>
                       </table>
                   </div>
                </td>
                <td align="right">
	                <a href="#" onclick="doSubmit()">
	                    <img id="nextBtn" src="views/oms/game-draw/img/right-hover.png" alt="下一步"/>
	                </a>
	                <img id="waitBtn" style="display:none" src="views/oms/game-draw/img/wait.gif" height="60px" width="60px"/>
                </td>
            </tr>
            <tr height="60">
                <td align="center" valign="middle">
					<!-- <img src="views/oms/game-draw/img/print.png" width="124" height="29"/>
                    <img src="views/oms/game-draw/img/xian.gif" width="3" height="19" />
                    <img src="views/oms/game-draw/img/refresh.png" width="102" height="29"/> -->
                </td>
            </tr>
        </table>
    </div>
</div>

</form>
</body>
</html>
