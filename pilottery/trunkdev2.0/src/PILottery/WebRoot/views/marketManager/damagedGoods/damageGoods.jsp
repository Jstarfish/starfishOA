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
	setting.check.chkboxType = { "Y" : "", "N" : "" };
	
	function changeBatch(){
		var planCode = $('#plan').val();
		$('#batch').empty();
		$('#tree').empty();
		$('#batch').append("<option value=''>--Please Select--</option>"); 
		if(planCode == ''){
			return false;
		}
		
		$.ajax({
			url : "damegeGood.do?method=getBatchListByPlan&planCode=" + planCode,
			dataType : "json",
			async : false,
			success : function(result){
	            if(result != '' && result !=null){
		            for(var i=0;i<result.length;i++){
		            	 $('#batch').append("<option value='"+result[i].batchNo+"'>"+result[i].batchNo+"</option>"); 
		            }
		        }
			}
		});	
	}

	function getTree(){
		var planCode = $('#plan').val();
		var batchNo = $('#batch').val();
		$('#tree').empty();
		if(planCode == '' || !batchNo){
			return false;
		}
		
		$.ajax({
			url : "damegeGood.do?method=getTreeByBatch&planCode=" + planCode+"&batchNo="+batchNo,
			dataType : "json",
			async : false,
			success : function(result){
	            if(result != '' && result !=null){
	            	$.fn.zTree.init($("#tree"), setting, result);
		        }
			}
		});	
	}

	function checkRepeat(){
		var treeObj=$.fn.zTree.getZTreeObj("tree");
		var nodes=treeObj.getCheckedNodes(true);
		for(var i=0;i<nodes.length;i++){
			for(var k=i+1;k<nodes.length;k++){
				if(nodes[i].id == nodes[k].pId){
					treeObj.cancelSelectedNode(nodes[i]);
					showError('Repeat to choose!');
		        	return false;
				}
			}
		}
		return true;
	}

	function save(){
		var planCode = $('#plan').val();
		var batchNo = $('#batch').val();
		var status = $('#status').val();
		if(!status){
			showError('Please select the reason!');
        	return false;
		}
		if(!planCode){
			showError('Please select the plan!');
        	return false;
		}
		if(!batchNo){
			showError('Please select the batch!');
        	return false;
		}
		
		var treeObj=$.fn.zTree.getZTreeObj("tree");
		if(!treeObj){
        	showError('No Data Selected!');
        	return false;
        }
        var nodes=treeObj.getCheckedNodes(true);
        
        if(!nodes || nodes.length <= 0){
        	showError('No Data Selected!');
        	return false;
        }else{
            var flag = checkRepeat();
			if(checkRepeat()){
	        	var damageArray = "";
	            for(var i=0;i<nodes.length;i++){
	            	damageArray += "#" +nodes[i].type+","+ nodes[i].id;
	            }
	            $('#damageArray').val(damageArray);
	            button_off("okBtn");
	            $('#damageForm').submit();
			}
        }

        /*$.ajax({
			url : "damegeGood.do?method=damageGoods",
			dataType : "",
			type : "post",
			async : false,
			data : {"planCode":$('#plan').val(),"batchNo":$('#batch').val(),"damageArray":damageArray},
			success : function(result){
	            //alert(result);
			}
		});	*/
	}
</script>
</head>

<body>
<div id="title">Register Damaged Goods</div>
<div id="container">
<!--排期开始-->
<div id="main1">
<div class="set">
<form id="damageForm" action="damegeGood.do?method=damageGoods" method="post">
    <div class="sj" style="margin-top: 50px;width:686px;">
      <div class="cs" style="overflow-y: auto;overflow-x: hidden;height: 580px;width:670px; ">
      <table id="tb1" width="100%" border="0" cellspacing="0" cellpadding="0"  height="580" >
      	 <tr>
		    <td width="120px;" align="right"><span class="lz">Reason:</span></td>
		    <td width="*%">&nbsp;&nbsp;
		    	<select id="status" name="status" class="select-big">
		    		<option value=''>--Please Select--</option>
               	   	<option value="41">stolen</option>
               	   	<option value="42">damage</option>
               	   	<option value="43">missing</option>
		    	</select>
			</td>
		  </tr>
		  <tr>
		    <td width="35%" align="right"><span class="lz">Plan:</span></td>
		    <td width="*%">&nbsp;&nbsp;
		    	<select id="plan" name="planCode" class="select-big" onchange="changeBatch();">
		    		<option value=''>--Please Select--</option>
		    		<c:forEach var="obj" items="${planList}" varStatus="plan">
               	   		<option value="${obj.planCode}">${obj.planName}</option>
               	    </c:forEach>
		    	</select>
			</td>
		  </tr>
		  <tr>
		    <td align="right"> <span class="lz">Batch:</span></td>
		    <td>&nbsp;&nbsp;
		    	<input type="hidden" id="damageArray" name="damageArray" value=""/>
		    	<select id="batch" name="batchNo" class="select-big" onchange="getTree();">
		    	</select>
		    </td>
		  </tr>
		  <tr>
				<td colspan="2">
					<div class="zTreeDemoBackground left" style="padding: overflow: no;">
						<div style="font-size: 18px; background: #2aa1d9; color: #fff; padding: 8px; width: 670px;">
							Inventory Information
						</div>
						<ul id="tree" class="ztree" style="margin-top: 0;border:0 ;background: #fff;width: 660px;height: 360px;"></ul>
					</div>
				</td>
			</tr>
		</table>
      </div>
    </div>
     <div class="clear">
        <input type="button" id="okBtn" class="button-normal" style="float:right;" value="Submit" onclick="save();"/>
     </div>
</form>
</div>
</div>
<!--排期结束-->
</div>
</body>
</html>
