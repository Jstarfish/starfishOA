<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/views/common/taglibs.jsp"%>
<html>
<head>
<title>增加销售站</title>

<link rel="stylesheet" type="text/css" href="${basePath}/css/style.css" />
<link rel="stylesheet" type="text/css" href="${basePath}/css/pop-up.css" />
<link rel="stylesheet" type="text/css" href="${basePath}/css/validate.css" />

<link rel="stylesheet" href="${basePath}/component/MessageBox/myJsBox.css" type="text/css"/>
<script type="text/javascript" src="${basePath}/component/messageBox/myJsBox.js"></script>

<script type="text/javascript" src="${basePath}/js/oms/myJs.js"></script>

<style type="text/css">


</style>


<script type="text/javascript" charset="UTF-8" >
    function doSubmit() {
        var result = true;
        
        if(!doCheck("areatype",/^[^0]$/,"* 请选择！")) {
        	result = false;
        }

        if(!doCheck("parentArea",/^[0-9]+$/,"* 不能为空，1-9的数字！")) {
            result = false;
        }

        if(result) {

         
        	
        	button_off("okBtn");
        }
    }


</script>


</head>
<body>
    <form action="">
	    <div class="pop-body">
	        <table width="100%" border="0" cellspacing="0" cellpadding="0" >
	            <tr>
	                <td align="right" width="25%">区域级别：</td>
	                <td align="center" width="35%">
	                    <select id="areatype" name="type" class="select-big">
	                        <option value="0" >---请选择---</option>
	                        <option value="1" >北京</option>
	                        <option value="2" >上海</option>          
	                    </select>
	                </td>
	                <td width="*%"><span id="areatypeTip" class="tip_init">*</span></td>
	            </tr>
	            <tr>
	                <td align="right">上级区域名称：</td>
	                <td align="center"><input id="parentArea" type="text" class="text-big"></input></td>
	                <td><span id="parentAreaTip" class="tip_init">*</span></td>
	            </tr>
	            <tr><td align="right">区域名称：</td><td></td><td></td></tr>
	            <tr><td align="right">区域编码：</td><td></td><td></td></tr>
	            <tr><td align="right">销售站数量：</td><td></td><td></td></tr>
	            <tr><td align="right">销售员数量：</td><td></td><td></td></tr>
	            <tr><td align="right">终端机数量：</td><td></td><td></td></tr>
	        </table>
        </div>
        <div class="pop-footer">
            <span class="left"><input id="okBtn" type="button" value="提交" onclick="doSubmit();" class="button-normal"></input></span>
            <span class="right"><input type="reset" value="重置" class="button-normal"></input></span>
        </div>
    </form>
</body>
</html>