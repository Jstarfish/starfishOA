<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/views/common/taglibs.jsp"%>
<html>
<head>
<title>Register Damaged Goods</title>
<%@ include file="/views/common/meta.jsp" %>

<link rel="stylesheet" type="text/css" href="${basePath}/css/style.css" />
<link rel="stylesheet" href="${basePath}/component/messageBox/myJsBox.css" type="text/css"/>
<link rel="stylesheet" href="${basePath}/css/zTreeStyle/zTreeStyle.css" type="text/css">
<script type="text/javascript" src="${basePath}/component/messageBox/myJsBox.js"></script>
<script type="text/javascript" src="${basePath}/js/jquery/jquery-1.9.1.js"></script>
<script type="text/javascript" src="${basePath}/js/ztree/jquery.ztree.core-3.5.js"></script>
<script type="text/javascript" src="${basePath}/js/ztree/jquery.ztree.excheck-3.5.js"></script>
<script type="text/javascript" src="${basePath}/js/myJs.js"></script>
<style type="text/css">
	 #container{
		min-width: 1280px; 
		width:expression(document.body.clientWidth < 1280? "1280px": "auto" ); 
	 }
	 .clear{
	 margin-top:10px;
	 }
	 /*排期样式*/
	#main1{
		width:90%;
		margin:0 auto;
		padding:0;
		}
	#main1 .set{
		width:40%;
		float:left;}
	#main1 .set .sj{
		background:#fff;
		border:1px solid #27a0d7;
		-moz-box-shadow:0px 3px 5px #999 inset;               /* For Firefox3.6+ */
		-webkit-box-shadow:0px 3px 5px #999 inset;            /* For Chrome5+, Safari5+ */
		box-shadow:0px 3px 5px #999 inset;                    /* For Latest Opera */
		}
	#main1 .cs{
		margin:10px;}
	#main1 .jiantou{
		position:absolute;
		top:30%;
		left:35%;
		}
	#main1 .show{
		width:55%;
		box-shadow:0px 3px 5px #999 ;  
		background:#fff;      
		height:490px;
		}
	.hongzid{
		color:#fd0505;
		font-weight:bold;}
	.ztree{
		margin-top: 10px;
		border: 1px solid #617775;
		background: #f0f6e4;
		width: 220px;
		height: 260px;
		overflow-y: scroll;
		overflow-x: auto;
	}
</style>
<script type="text/javascript">
	var setting = {
		check: {
			enable: true
		},
		data: {
			simpleData: {
				enable: true
			}
		}
		
	};

	var zNodes =[
	 			{ id:1, pId:0, name:"随意勾选 1", open:true},
	 			{ id:11, pId:1, name:"随意勾选 1-1", open:true},
	 			{ id:111, pId:11, name:"随意勾选 1-1-1"},
	 			{ id:112, pId:11, name:"随意勾选 1-1-2"},
	 			{ id:12, pId:1, name:"随意勾选 1-2", open:true},
	 			{ id:121, pId:12, name:"随意勾选 1-2-1"},
	 			{ id:122, pId:12, name:"随意勾选 1-2-2"},
	 			{ id:2, pId:0, name:"随意勾选 2", checked:true, open:true},
	 			{ id:21, pId:2, name:"随意勾选 2-1"},
	 			{ id:22, pId:2, name:"随意勾选 2-2", open:true},
	 			{ id:221, pId:22, name:"随意勾选 2-2-1", checked:true},
	 			{ id:222, pId:22, name:"随意勾选 2-2-2"},
	 			{ id:23, pId:2, name:"随意勾选 2-3"}
	 		];

	$(document).ready(function(){
		setting.check.chkboxType = { "Y" : "", "N" : "" };
		$.fn.zTree.init($("#treeDemo"), setting, zNodes);
	});

</script>
</head>

<body>
<div id="title">Register Damaged Goods</div>
<div id="container">
<!--排期开始-->
<div id="main1">
<div class="set">
<form action="">
    <div class="sj" style="margin-top: 50px">
      <div class="cs" style="overflow-y: auto;overflow-x: hidden;height: 472px;">
      <table id="tb1" width="100%" border="0" cellspacing="0" cellpadding="0"  height="450" >
		  <tr>
		    <td width="35%" align="right"><span class="lz">方案:</span></td>
		    <td width="*%">&nbsp;&nbsp;
		    	<select class="select-normal" style="width: 200px">
		    		<option>test1</option>
		    		<option>test2</option>
		    		<option>test3</option>
		    	</select>
			</td>
		  </tr>
		  <tr>
		    <td align="right"> <span class="lz">批次:</span></td>
		    <td>&nbsp;&nbsp;
		    	<select class="select-normal" style="width: 200px">
		    		<option>test1</option>
		    		<option>test2</option>
		    		<option>test3</option>
		    	</select>
		    </td>
		  </tr>
		  <tr>
		  	<td>&nbsp;</td>
		    <td>
		    <div>
				<ul id="treeDemo" class="ztree"></ul>
			</div>
		    </td>
		  </tr>
		</table>
      </div>
    </div>
     <div class="clear">
        <input type="button" class="button-normal" style="float:right;" value="Add" onclick="add();"/>
     </div>
</form>
</div>
<div id="previewDiv" style="float:right;">
  <div class="show" style="margin-top:50px;width:670px;overflow-y:auto">
    <table class="datatable" >
        <tr class="headRow">
          <td scope="col">序号</td>
          <td scope="col">方案</td>
          <td scope="col">批次</td>
          <td scope="col">箱/盒/本</td>
          <td scope="col">签号</td>
          <td scope="col">金额</td>
        </tr>
        
     <c:forEach items="${issueList}" var="n" varStatus="s">
        <tr class="dataRow">
        </tr>
    </c:forEach>  
    </table>
  </div>

  <div class="clear"> 
    <input id="nextBtn" type="button" class="button-normal" onclick="saveData();"  value="Save" style="float:right;"/>
  </div>

</div>
</div>
<!--排期结束-->
</div>
</body>
</html>
