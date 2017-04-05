<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/views/common/taglibs.jsp"%>
<html>
<head>
<title>Instant Message</title>
<%@ include file="/views/common/meta.jsp" %>
<script type="text/javascript" src="${basePath}/js/jquery/jquery-1.9.1.js"></script>
<script type="text/javascript" src="${basePath}/js/ztree/jquery.ztree.core-3.5.js"></script>
<script type="text/javascript" src="${basePath}/js/ztree/jquery.ztree.excheck-3.5.js"></script>
<script type="text/javascript" src="${basePath}/js/myJs_zh.js"></script>
<script type="text/javascript" src="${basePath}/component/messageBox/myJsBox.js"></script>
<%@ include file="/views/oms/notify/notice.jsp" %>

<link rel="stylesheet" type="text/css" href="${basePath}/component/messageBox/myJsBox.css" />
<link rel="stylesheet" type="text/css" href="${basePath}/css/zTreeStyle/zTreeStyle.css" />
<link rel="stylesheet" type="text/css" href="${basePath}/css/style.css" />
<link rel="stylesheet" type="text/css" href="${basePath}/css/oms_notice.css" />
<script type="text/javascript">

	var zNodes =[];
	var setting = {
		check: {
			enable: true,
			chkboxType://s:级联子节点，p:父节点
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

	function inputCheck(obj){
		obj.value = obj.value.replace(/[^\d]/g,""); 
	}

	function changeTo(obj){
		var val = obj.value;
		if (val==1) {
			$("#showTime").show();
		} else {
			$("#showTime").hide();
		}
	}

	function reLoad(){
		window.location.reload();
	}
</script>
<c:forEach items="${list}" var="p">
	<script type="text/javascript">
	var arr = new Array();
	arr["id"] = ${p.id};
	arr["pId"] = ${p.pid};
	arr["name"] = '${p.name}';
	zNodes.push(arr);
	</script>
</c:forEach>
</head>
<body>
<div id="title">Instant Message</div>
<!--中间部分开始-->
<div style="position:absolute;top:39px;bottom:0px;width:100%;">
<!--左侧列表开始-->
<div id="left1">
	<div class="tit">Select Institution</div>
	<div>
		<ul id="treeDemo" class="ztree"></ul>
	</div>
	<div class="button-div" style="padding:10px" onclick="return tsmsg.addar();">Add to List</div>
	<div class="tit">Select terminal：</div>
	<div>
    	<textarea id="txtagencys" name="txtagencys" cols="30" rows="8" class="textarea1" onkeyup="this.value=this.value.replace(/[^\d;]/g,'')" placeholder="Please enter the terminal code, separated by ';', maximum 20 agencies"></textarea>
   	</div>
    <div class="button-div" style="padding:10px" onclick="return tsmsg.addTer();">Add to List</div>
</div>
<!--左侧列表结束-->
<!--右侧列表开始-->
<form:form modelAttribute="notice" id="planForm">
<div id="right1">
	<div class="tit1"  style=" border-bottom:1px solid #e2e2e3;">List of receivers</div>
	<div class="div1">
	   <ul id="selectedobjs"></ul> 
	</div>
   
	<table width="100%" border="0" cellspacing="0" cellpadding="0">
		<tr>
			<td align="right" style="padding-right:30px;">
				<div class="button-div" style="width:100px;height:30px;line-height:30px;"
				 onclick="return tsmsg.clsobj();">Clear All</div>
			</td>
		</tr>
	</table>
 	<input id="txtresvobjs" name ="objIds" type="hidden"/><!-- 存地域code码，用逗号分隔 -->
 	<input id="txcitynames" name="objNames" type="hidden"/><!-- 存地域名字 , 用逗号分隔-->
 	<input id="level_id" name="levelIds" type="hidden"/><!-- 存区域级别标签 , 用逗号分隔-->
	<div class="tit1" style="margin-top:20px;">
  		Display Position：
		<select id="position" name="positionId" class="select-big" onchange="changeTo(this);">
			<c:forEach items="${displayPosition}" var="p">
				<option value="${p.key }">${p.value}</option>
			</c:forEach>
		</select> 
  		&nbsp;&nbsp;&nbsp;&nbsp;
  		<span id="showTime" style="display: none;">Duration (second)：<input name="displayTime" id="displayTime" tabindex="1" type="text" class="text-big" style="width: 150px;" onkeyup="inputCheck(this)" maxlength="4"/><span id="displayTimeTip""></span></span>
	</div>
	<textarea id="txtmsgcontent" name="content" rows="10" class="textarea2" maxlength="1500" placeholder="Message content cannot be more than 1500 characters!"></textarea>
	
	<table width="100%" border="0" cellspacing="0" cellpadding="0">
		<tr>
			<td align="left" style="padding-left:30px;">
			    <div class="button-div" style="width:68px;height:30px;line-height:30px" onclick="return tsmsg.clscc();">Clear</div>
			</td>
			<td align="right" style="padding-right:30px;">
				<div id="button-div" class="button-div" style="width:68px;height:30px;line-height:30px" onclick="tsmsg.sendIMInfo();">Send</div>
			</td>
		</tr>
	</table>
</div>
</form:form>
<!--右侧列表结束-->
</div>
</body>
</html>

