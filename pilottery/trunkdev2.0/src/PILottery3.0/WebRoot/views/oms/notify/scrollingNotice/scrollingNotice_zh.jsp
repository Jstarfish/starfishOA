<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/views/common/taglibs.jsp"%>
<html>
<head>
<title></title>
<script type="text/javascript" src="${basePath}/js/jquery/jquery-1.9.1.js"></script>
<script type="text/javascript" src="${basePath}/js/jquery/jquery.form.js"></script>
<link rel="stylesheet" type="text/css" href="${basePath}/css/style.css" />
<link rel="stylesheet" type="text/css" href="${basePath}/css/game.css"/>
<link rel="stylesheet" href="${basePath}/component/messageBox/myJsBox.css" type="text/css"/>
<script type="text/javascript" src="${basePath}/component/messageBox/myJsBox_zh.js"></script>
<script type="text/javascript" src="${basePath}/js/myJs.js"></script>
<script type="text/javascript">

function edit(seq){
	var obj = document.getElementsByTagName('textarea');
	if(obj.length > 0){
		showError('请先保存其他参数！');
		return false;
	};
	
	$('#rollingNotice').ajaxSubmit({
		type : 'POST',
		url : 'tmnotice.do?method=editScrollingNotice&seq='+seq,
		success : function(data) {
			$("#"+seq).html(data);
		}
	});
};

//取消编辑
function cancel(seq){
	$('#rollingNotice').ajaxSubmit({
		type : 'POST',
		url : 'tmnotice.do?method=updateScrollingNotice&seq='+seq+"&f1=cancel",
		success : function(data) {
			$("#"+seq).html(data);
		}
	});
	/*$('#rollingNotice').attr("action","tmnotice.do?method=getScrollingNotice");
	$('#rollingNotice').submit();*/
	
};
//异步存储
function prompt(seq) {
	var msg = "确定要修改吗?";
	showDialog("update('"+seq+"')","确认",msg);
}
function update(seq){
	button_off("ok_button");
	$('#rollingNotice').ajaxSubmit({
		type : 'POST',
		url : 'tmnotice.do?method=updateScrollingNotice&seq='+seq,
		success : function(data) {
			$("#"+seq).html(data);
			closeDialog();
		}
	});
};
function MM_swapImgRestore() { //v3.0
  var i,x,a=document.MM_sr; for(i=0;a&&i<a.length&&(x=a[i])&&x.oSrc;i++) x.src=x.oSrc;
}
function MM_preloadImages() { //v3.0
  var d=document; if(d.images){ if(!d.MM_p) d.MM_p=new Array();
    var i,j=d.MM_p.length,a=MM_preloadImages.arguments; for(i=0; i<a.length; i++)
    if (a[i].indexOf("#")!=0){ d.MM_p[j]=new Image; d.MM_p[j++].src=a[i];}}
}

function MM_findObj(n, d) { //v4.01
  var p,i,x;  if(!d) d=document; if((p=n.indexOf("?"))>0&&parent.frames.length) {
    d=parent.frames[n.substring(p+1)].document; n=n.substring(0,p);}
  if(!(x=d[n])&&d.all) x=d.all[n]; for (i=0;!x&&i<d.forms.length;i++) x=d.forms[i][n];
  for(i=0;!x&&d.layers&&i<d.layers.length;i++) x=MM_findObj(n,d.layers[i].document);
  if(!x && d.getElementById) x=d.getElementById(n); return x;
}

function MM_swapImage() { //v3.0
  var i,j=0,x,a=MM_swapImage.arguments; document.MM_sr=new Array; for(i=0;i<(a.length-2);i+=3)
   if ((x=MM_findObj(a[i]))!=null){document.MM_sr[j++]=x; if(!x.oSrc) x.oSrc=x.src; x.src=a[i+2];}
}
</script>
</head>
<body>
<div id="title">滚动字幕</div>
<form id="rollingNotice" method="post">
<div id="right2" style="height:100%; width:85%;">
<table width="100%" border="0" cellspacing="0" cellpadding="0">
	<tr>
		<td>
			<div style="float: left; position: relative; top: 50%; left: 10%;"></div>
		</td>
		<td><div class="game">
				<div id="caption1">
					<div class="bg" style="width: 460px;">
						<table width="100%" border="0" cellspacing="0" cellpadding="0">
							<tr>
								<td class="title"><table width="100%" border="0"
										cellspacing="0" cellpadding="0"
										style="color: #fff; font-size: 18px;">
										<tr>
											<td>Lucky5滚动字幕1</td>
											<td align="right"><a href="#"
												onclick="edit('caption1');"
												onmouseout="MM_swapImgRestore()"
												onmouseover="MM_swapImage('Image11','','${basePath}/img/edit-hover.png',1)">
												<img src="${basePath}/img/edit.png" width="32" height="42"
													title="编辑" id="Image11" /></a></td>
										</tr>
									</table></td>
							</tr>
							<tr>
								<td class="nr" style="height: 220px; white-space:normal">
									<div style="margin: 0 auto; width: 460px; word-wrap: break-word;">
										${scrollingNotice1}
									</div>
								</td>
							</tr>
						</table>
					</div>
				</div>

				<div id="caption2">
					<div class="bg" style="width: 460px;">
						<table width="100%" border="0" cellspacing="0" cellpadding="0">
							<tr>
								<td class="title1"><table width="100%" border="0"
										cellspacing="0" cellpadding="0"
										style="color: #fff; font-size: 18px;">
										<tr>
											<td>Lucky5滚动字幕2</td>
											<td align="right"><a href="#"
												onclick="edit('caption2');"
												onmouseout="MM_swapImgRestore()"
												onmouseover="MM_swapImage('Image11','','${basePath}/img/edit-hover.png',1)">
												<img src="${basePath}/img/edit.png" width="32" height="42"
													title="编辑" id="Image11" /></a></td>
										</tr>
									</table></td>
							</tr>
							<tr>
								<td class="nr" style="height: 220px; white-space:normal">
									<div style="margin: 0 auto; width: 460px;">
										${scrollingNotice2}</div>
								</td>
							</tr>
						</table>
					</div>
				</div>

				<div id="caption3">
					<div class="bg" style="width: 460px;">
						<table width="100%" border="0" cellspacing="0" cellpadding="0">
							<tr>
								<td class="title2"><table width="100%" border="0"
										cellspacing="0" cellpadding="0"
										style="color: #fff; font-size: 18px;">
										<tr>
											<td>Lucky5滚动字幕3</td>
											<td align="right"><a href="#"
												onclick="edit('caption3');"
												onmouseout="MM_swapImgRestore()"
												onmouseover="MM_swapImage('Image11','','${basePath}/img/edit-hover.png',1)">
												<img src="${basePath}/img/edit.png" width="32" height="42"
													title="编辑" id="Image11" /></a></td>
										</tr>
									</table></td>
							</tr>
							<tr>
								<td class="nr" style="height: 220px; white-space:normal">
									<div
										style="margin: 0 auto; width: 460px; word-wrap: break-word; word-break: break-all;">
										${scrollingNotice3}</div>
 								</td>
							</tr>
						</table>
					</div>
				</div>
			</div></td>
	</tr>
</table>
</div>
</form>
</body>
</html>