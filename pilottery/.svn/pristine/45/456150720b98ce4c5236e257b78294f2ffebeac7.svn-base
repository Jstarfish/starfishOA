<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/views/common/taglibs.jsp"%>
<html>
<head>
<title>发送公告</title>
<%@ include file="/views/common/meta.jsp" %>
<script type="text/javascript" src="${basePath}/js/jquery/jquery-1.9.1.js"></script>
<script type="text/javascript" src="${basePath}/js/ztree/jquery.ztree.core-3.5.js"></script>
<script type="text/javascript" src="${basePath}/js/ztree/jquery.ztree.excheck-3.5.js"></script>
<script type="text/javascript" src="${basePath}/js/myJs_zh.js"></script>
<script type="text/javascript" src="${basePath}/component/messageBox/myJsBox_zh.js"></script>
<%@ include file="/views/oms/notify/notice_zh.jsp" %>

<link rel="stylesheet" type="text/css" href="${basePath}/component/messageBox/myJsBox.css" />
<link rel="stylesheet" type="text/css" href="${basePath}/css/zTreeStyle/zTreeStyle.css" />
<link rel="stylesheet" type="text/css" href="${basePath}/css/style.css" />
<link rel="stylesheet" type="text/css" href="${basePath}/css/oms_notice.css" />
<script type="text/javascript">
    var zNodes =[];

    var setting = {
        check: {
            enable: true,
            chkboxType:
            {
                Y:"",
                N:""
            }
        },
        data: {
            simpleData: {
                enable: true,
                idKey: 'id',
                pIdKey: 'pId'
            }
        }
    };
    
    $(document).ready(function(){
        $.fn.zTree.init($("#treeDemo"), setting, zNodes);
        tsmsg.setBasePath('${basePath}');
    });
    
    function jumpTo(url){
		window.location.href = url;
	} 

	function reLoad(){
		window.location.reload();
	}
</script>
 <c:forEach items="${list}" var="p">
 <script type="text/javascript">
     var arr = new Array();
     arr["id"] = '${p.id}';
     arr["pId"] = '${p.pid}';
     arr["name"] = '${p.name}';
     //alert(arr["id"]+", "+arr["pId"]+", "+arr["name"]);
     zNodes.push(arr);
 </script>
 </c:forEach>

<style>


</style>

</head>
<body>
<div id="title">销售站公告</div>
<!--中间部分开始-->
<div style="position:absolute;top:39px;bottom:0px;width:100%;">
    <!--左侧列表开始-->
    <div id="left1">
        <div class="tit">区域选择</div>
        <div>
            <ul id="treeDemo" class="ztree"></ul>
        </div>
        <div class="button-div" style="padding:10px" onclick="return tsmsg.addar();">添加到通知接收列表</div>
        <div class="tit">需要指定销售站发公告：</div>
        <div>
            <textarea id="txtagencys" name="txtagencys" cols="30" rows="8" class="textarea1" onkeyup="this.value=this.value.replace(/[^\d;]/g,'')" placeholder="输入销售站编码，多个用';'隔开"></textarea>
        </div>
        <div class="button-div" style="padding:10px" onclick="return tsmsg.addag();">添加到通知接收列表</div>
    </div>
    <!--左侧列表结束-->
    <!--右侧列表开始-->
    <form:form modelAttribute="notice" id="planForm">
    <div id="right1">
        <div class="tit1"  style="border-bottom:1px solid #e2e2e3;">通知接收列表(请选择最多20个区域)</div>
        <div class="div1">
            <ul id="selectedobjs"></ul> 
        </div>

        <table width="100%" border="0" cellspacing="0" cellpadding="0">
            <tr>
                <td align="right" style="padding-right:30px;">
                    <div class="button-div" style="width:100px;height:30px;line-height:30px;"
                     onclick="return tsmsg.clsobj();">全部清空</div>
                </td>
            </tr>
        </table>
        <input id="txtresvobjs" name ="objIds" type="hidden"/><!-- 存地域code码，用逗号分隔 -->
        <input id="txcitynames" name="objNames" type="hidden"/><!-- 存地域名字 , 用逗号分隔-->
        <input id="level_id" name="level_id" type="hidden"/><!-- 存区域级别标签 , 用逗号分隔-->
        <div class="tit1" style="margin-top:20px;">公告名称<span id="txtmsgtitleTip"></span></div>
        <input name="title" id="txtmsgtitle" tabindex="1" type="text" class="input-text1" maxlength="300" placeholder="长度限50字符">
        <div><span id="txtmsgcontentTip"></span></div>
        <textarea id="txtmsgcontent" name="content" rows="10" class="textarea2" maxlength="2000" placeholder="请输入消息内容，长度限200字符"></textarea>

        <table width="100%" border="0" cellspacing="0" cellpadding="0">
            <tr>
                <td align="left" style="padding-left:30px;">
                    <div class="button-div" style="width:68px;height:30px;line-height:30px" onclick="return tsmsg.clscc();">清空</div>
                </td>
                <td align="right" style="padding-right:30px;">
                    <div id="button-div" class="button-div" style="width:68px;height:30px;line-height:30px" onclick="tsmsg.sendMsg();">发送</div>
                </td>
            </tr>
        </table>
    </div>
    </form:form>

</div>
</body>

</html>

