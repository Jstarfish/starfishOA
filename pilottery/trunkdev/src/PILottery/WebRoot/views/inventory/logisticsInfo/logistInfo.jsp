<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/views/common/taglibs.jsp"%>
<html>
<head>

<title>LogistInfo</title>

<%@ include file="/views/common/meta.jsp"%>
<link rel="stylesheet" type="text/css" href="${basePath}/css/style.css" />
<link rel="stylesheet" href="${basePath}/component/messageBox/myJsBox.css"	type="text/css" />
<script type="text/javascript" src="${basePath}/component/messageBox/myJsBox.js"></script>
<script type="text/javascript" src="${basePath}/component/My97DatePicker/WdatePicker.js"></script>
<script type="text/javascript" src="${basePath}/js/myJs.js"></script>
<script type="text/javascript" src="${basePath}/js/jquery/jquery-1.9.1.js"></script>

<script type="text/javascript" charset="UTF-8">
	$(function(){
		$('#queryType').val('${form.queryType}');
		changeSelect();
		$('#planCode').val('${form.planCode}');
		changeBatch();
		$('#batchCode').val('${form.batchCode}');
		$('#specification').val('${form.specification}');
		
		
	});

	function doSubmit() {
		var select = $('#queryType').val();
		if(select == 1){
			var logisticsCode = $('#logisticsCode').val();
			if(!logisticsCode){
				showError('Logistics Code Cannot Be Empty');
				return false;
			}
			if(logisticsCode.getCBytesLength()>29){
				showError('Logistics Code Illegal');
				return false;
			}
		}else{
			var planCode = $('#planCode').val();
			var batchCode = $('#batchCode').val();
			var specification = $('#specification').val();
			var packUnitCode = $('#packUnitCode').val();
			if(!planCode){
				showError('Plan Code Cannot Be Empty');
				return false;
			}
			if(!batchCode){
				showError('Batch Code Cannot Be Empty');
				return false;
			}
			if(!specification){
				showError('Specification Cannot Be Empty');
				return false;
			}
			if(!packUnitCode){
				showError('Code Cannot Be Empty');
				return false;
			}
		}
		
		document.getElementById("queryForm").submit();
	}

	function changeSelect(){
		var select = $('#queryType').val();
		if(select == 1){
			$('#span1').show();
			$('#span2').val('');
			$('#span3').val('');
			$('#span4').val('');
			$('#span5').val('');
			$('#span2').hide();
			$('#span3').hide();
			$('#span4').hide();
			$('#span5').hide();
		}else{
			$('#span1').hide();
			$('#span1').val('');
			$('#span2').show();
			$('#span3').show();
			$('#span4').show();
			$('#span5').show();
		}
	}

	function changeBatch(){
		var planCode = $('#planCode').val();
		$('#batchCode').empty();
		$('#batchCode').append("<option value=''>--Please Select--</option>"); 
		if(planCode == ''){
			return false;
		}
		
		$.ajax({
			url : "logistics.do?method=getBatchList&planCode=" + planCode,
			dataType : "json",
			async : false,
			success : function(result){
	            if(result != '' && result !=null){
		            for(var i=0;i<result.length;i++){
		            	 $('#batchCode').append("<option value='"+result[i].batchNo+"'>"+result[i].batchNo+"</option>"); 
		            }
		        }
			}
		});	
	}
</script>

</head>
<body>
	<!-- 顶部标题块 -->
	<div id="title">Logistics Information</div>
	<!-- 查询条件块 -->
	<div class="queryDiv">
		<form action="logistics.do?method=initLogistics" id="queryForm" method="POST">
			<div class="center">
				<select class="select-normal" id="queryType" name="queryType" value="${form.queryType }" onchange="changeSelect();">
					<option value="1">By Logistics Code </option>
					<option value="2">By Specification </option>
				</select>
				<span id="span1">Logistics Code: <input name="logisticsCode" value="${form.logisticsCode }" id="logisticsCode" class="text-normal" style="width:300px;" maxlength="34" />
				</span> 
				<span id="span2" style="display: none">Plan Code:
					<select name="planCode" id="planCode" class="select-normal" onchange="changeBatch();">
						<option value="">--Please Select--</option>
						 <c:forEach var="obj" items="${planList}" varStatus="s">
						 	<c:if test="${obj.planCode == form.planCode}">
                   	   			<option value="${obj.planCode}" selected="selected">${obj.fullName}</option>
                   	   		</c:if>
                   	   		<c:if test="${obj.planCode != form.planCode}">
                   	   			<option value="${obj.planCode}">${obj.fullName}</option>
                   	   		</c:if>
						 </c:forEach>
					</select>
				</span> 
				<span id="span3"  style="display: none">Batch Code: 
					<select name="batchCode" id="batchCode" class="select-normal" value="${form.batchCode }">
						<option value="">--Please Select--</option>
					</select>
				</span> 
				<span id="span4"  style="display: none">Specification: 
					<select name="specification" id="specification" class="select-normal" value="${form.specification }">
						<option value="">--Please Select--</option>
						<option value="1">Trunk</option>
						<option value="2">Box</option>
						<option value="3">Package</option>
						<option value="4">Ticket</option>
					</select>
				</span> 
				<span id="span5"  style="display: none">Code: <input name="packUnitCode" id="packUnitCode" value="${form.packUnitCode }" class="text-normal"/>
				</span> 
				<input type="button" value="Query" onclick="doSubmit();" class="button-normal"></input>
			</div>
		</form>
	</div>

	<!-- 列表表头块 -->
	<div id="headDiv">
		<table width="100%" border="0" cellpadding="0" cellspacing="0">
			<tr>
				<td>
					<table class="datatable">
						<tr class="headRow">
							<td style="width: 10px;">&nbsp;</td>
							<td>Date</td>
							<th width="1%">|</th>
							<td>Warehouse</td>
							<th width="1%">|</th>
							<td>Type</td>
							<th width="1%">|</th>
							<td>Operator</td>
						</tr>
					</table>
				</td>
				<!-- 表头和下方数据对齐 -->
				<td style="width: 17px; background: #2aa1d9"></td>
			</tr>

			<div id="bodyDiv">
				<table class="datatable">
					<c:if test="${payout!=null }">
						<tr class="dataRow">
							<td style="width: 10px;">&nbsp;</td>
							<td width="1%">&nbsp;</td>
							<td><fmt:formatDate value="${payout.payoutDate }"
									pattern="yyyy-MM-dd HH:mm:ss" /></td>
							<td width="1%">&nbsp;</td>
							<td>Payout At Outlet--${payout.outlet}</td>
							<td></td>
							<td></td>
						</tr>
					</c:if>
					<c:forEach var="data" items="${logistics}" varStatus="status">
						<tr class="dataRow">
							<td style="width: 10px;">&nbsp;</td>
							<td><fmt:formatDate value="${data.time }" pattern="yyyy-MM-dd HH:mm:ss" /></td>
							<td width="1%">&nbsp;</td>
							<td>${data.wareHouseType}</td>
							<td width="1%">&nbsp;</td>
							<td>${data.type}</td>
							<td width="1%">&nbsp;</td>
							<td>${data.operatorName}</td>
						</tr>
					</c:forEach>
				</table>
			</div>
		</table>
	</div>
</body>
</html>