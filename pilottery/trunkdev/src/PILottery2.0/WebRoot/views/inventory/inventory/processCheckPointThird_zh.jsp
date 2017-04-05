<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8"%>
<%@ include file="/views/common/taglibs.jsp"%>
<%@ include file="/views/common/meta.jsp"%>

<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>无标题文档</title>
<link rel="stylesheet" href="${basePath}/component/messageBox/myJsBox.css" type="text/css"/>
<link rel="stylesheet" type="text/css" href="${basePath}/css/validate.css" />
<script type="text/javascript" src="${basePath}/component/messageBox/myJsBox.js"></script>
<link rel="stylesheet" type="text/css" href="${basePath}/css/style.css" />
  <script type="text/javascript" src="${basePath}/js/myJs.js"></script>
<script type="text/javascript"
	src="${basePath}/js/jquery/jquery-1.9.1.js"></script>
<script type="text/javascript"
	src="${basePath}/views/inventory/goodsReceipts/js/TransCodeHandler.js"></script>
<link href="${basePath}/views/inventory/goodsReceipts/css/style3.css"
	rel="stylesheet" type="text/css" />
<style type="text/css">
body {
	margin: 0;
	padding: 0;
	margin: 0px;
	padding: 0px;
	font: 14px/20px "微软雅黑", Arial, Helvetica, sans-serif;
	background: #f2f1f1;
	width: 100%;
	height: 100%;
}

select {
	outline: none;
}

ul {
	list-style: none;
}

a {
	text-decoration: none;
}
</style>
<script>
$(document).ready(function(){	
	 $("#submitok").click(function(){
		 
		        
		         switch_obj("submitok","waitBtn");
				 $("#checkPointParmat").attr("action", "inventory.do?method=checkPointFinish");
				 $('#checkPointParmat').submit();
		   
	  }); 
});

function findObj(id) {
	var obj = document.getElementById(id);
	return obj;
}
function switch_obj(btnId1, btnId2) {
	var btnObj1 = findObj(btnId1);
	btnObj1.style.display = "none";
	var btnObj2 = findObj(btnId2);
	btnObj2.style.display = "inline";
}
</script>
</head>

<body>
	<form method="post" action="" id="checkPointParmat" name="checkPointParmat">
		<input type="hidden" name="cpNo" id="cpNo" value="${result.cpNo}">

		<div id="container">
			<!--header-->
			<div class="header">
				<!--用户信息区开始-->
				<!--用户信息区结束-->
				<div id="title">库存盘点</div>
			</div>
			<!--header end-->
			<!--开奖开始-->
			<div id="main">
				<div class="jdt">
					<img src="views/inventory/goodsReceipts/images/jdt3_3.png" width="1000" height="30" />
					 <div class="xd-cn">
						<span class="zi">1.扫描物品</span>
					 	<span class="zi">2.盘点完成</span>
					 	<span  class="zi">3.盘点统计</span>
					 </div>
				</div>
			
				<div class="bd">
					<table width="100%" border="0" align="center" cellpadding="0" cellspacing="0">
						<tr>
							<td>
								<div class="tab">
									<div class="tabn">
										<table border="0" cellpadding="0" cellspacing="0" width="100%" valign="top">
											<tr>
												<td>
													<table width="90%" border="0" align="center" cellpadding="0" cellspacing="0" style="margin-top: 30px;">
														<tr>
															<td width="30%" style="border-bottom: 1px dashed #ccc; padding-bottom: 15px;" class="hoz">
																差异 :<span class="lz2"><fmt:formatNumber value='${result.cbeforeNum-result.cafterNum}'  type='number'/></span>张
															</td>
															<td width="30%" style="border-bottom: 1px dashed #ccc; padding-bottom: 15px;">
																盘点前 : <span class="lz2"> <fmt:formatNumber value='${result.cbeforeNum}'  type='number'/></span>张
															</td>
															<td style="border-bottom: 1px dashed #ccc; padding-bottom: 15px;">
																盘点后 : <span class="lz2"> <fmt:formatNumber value='${result.cafterNum}'  type='number'/></span>张
															</td>
														</tr>
														<tr>
															<td>
																利润和损失 : <span class="lz2"><fmt:formatNumber value='${result.cbeforeNum-result.cafterNum}'  type='number'/></span>张									
															</td>
															<td colspan="2">
																结果 : 
																<span class="lz2">
																	<c:choose>
																		<c:when test="${result.cresult==1}">一致</c:when>
																		<c:when test="${result.cresult==2}">盘亏</c:when>
																		<c:otherwise>盘盈</c:otherwise>
																	</c:choose>
																</span>
															</td>
														</tr>											
														<tr>
															<td colspan="3">
															<!-- 列表差异 -->
																<!-- table header -->															
																<div style="position:relative; z-index:1000px;margin-top: 10px;">
														         <table class="datatable" id="table1_head" width="100%">
														           <tbody>
															           <tr>
															           	<th width="10%" align="center">方案</th>
															           	<th width="2%">|</th>
																		<th width="10%">批次</th>
																		<th width="2%">|</th>
																		<th width="10%">单位</th>
																		<th width="2%">|</th>
																		<th width="10%">标志</th>
																		<th width="2%">|</th>
																		<th width="15%">差异 (本)</th>
																		<th width="2%">|</th>
																		<th width="15%">选择</th>
															           </tr>
														         	</tbody>
														         </table>
														       </div>
														       <!-- table header end-->
														       
														       <!-- table list -->
														       <div id="box" style="border:1px solid #ccc;">
														         <table id="fatable" class="datatable" cellpadding="0" cellspacing="0" width="100%">
														           <tbody>
														           	<c:set var="totaldiff" value="0" scope="page"/>
														           	<c:forEach var="item" items="${itemList}" varStatus="status" step="1">
														           		<c:if test="${item.diffPkg < 0}">
																		<tr>
																			<td width="10%" align="center">${item.planCode}</td>
																			<td width="2%">&nbsp;</td>
																			<td width="10%">${item.batchNo}</td>
																			<td width="2%">&nbsp;</td>
																			<td width="10%">
																				<c:choose>
																					<c:when test="${item.validNumber=='1' }">箱</c:when>
																					<c:when test="${item.validNumber=='2' }">盒</c:when>
																					<c:otherwise>
														                                                                               本
														                           	</c:otherwise>
														                        </c:choose>
																			</td>
																			<td width="2%">&nbsp;</td>
																			<td width="10%">
																				<c:choose>
																					<c:when test="${item.validNumber=='1' }">
																						${item.trunNo}
																					</c:when>
																					<c:when test="${item.validNumber=='2' }">
																						${item.boxNo}
																					</c:when>
																					<c:otherwise>
														                                ${item.packageNo}
														                           	</c:otherwise>
														                        </c:choose>
																			</td>
																			<td width="2%">&nbsp;</td>
																			<td width="15%" align="right"><fmt:formatNumber value='${item.diffPkg}'  type='number'/></td>
																			<td width="2%">&nbsp;</td>
																			<td width="15%" align="right">																			
																				<input type="checkbox" id="recordId" name="recordId" value="${item.seqNo}" align="left"></input>
																			</td>
																								
																			<c:set value="${totaldiff + item.diffPkg}" var="totaldiff" />  
																		</tr>
																		</c:if>
																	</c:forEach>
														        	<tr>
																		<td colspan="11" align="right">总差异 ： <fmt:formatNumber value='${totaldiff}'  type='number'/>  本</td>
																	</tr>
																	</tbody>
														        </table>
														       </div>
														       <!-- table list end-->
															</td>
														</tr>
														<tr>
															<td colspan="3">
																<div id="djxs">
																	<table width="100%" border="0" align="center" cellpadding="0" cellspacing="0" style="margin-top: 10px;">
																		<tr>
													                       <td style="padding-top:20px; " colspan="4" >
														                       备注 :<textarea name="remark" rows="5" class="edui-editor1" value="填写1 - 500字符,非强制性的" onfocus="if(this.value=='填写1 - 500字符,非强制性的'){this.value='';}"  onblur="if(this.value==''){this.value='填写1 - 500字符,非强制性的';}"></textarea>
														                    </td>
													                    </tr>
																	</table>
																</div>
															</td>
														</tr>
													</table>
												</td>
											</tr>
											<tr>
												<td>
													<div style="margin: 10px 40px; float: right;">
														<button id="submitok" type="button"  class="gl-btn2">完成</button>
														 <img id="waitBtn"  class="gl-btn2"  style="display:none" src="views/inventory/goodsReceipts/images/wait.gif" height="25px" width="35px"/>
													</div>
												</td>
											</tr>
										</table>
									</div>
								</div>
							</td>
						</tr>
					</table>
				</div>

			</div>
			<!--开奖结束-->

		</div>
	</form>
</body>
</html>
