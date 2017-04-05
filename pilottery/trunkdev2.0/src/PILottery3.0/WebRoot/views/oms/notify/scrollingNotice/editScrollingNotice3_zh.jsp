<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8"%>
<%@ include file="/views/common/taglibs.jsp"%>
<html>
<body>
	<div class="bgsuper" style="width: 460px;">
		<table width="100%" border="0" cellspacing="0" cellpadding="0">
			<tr>
				<td class="title2">
				<table width="100%" border="0" cellspacing="0" cellpadding="0"
						style="color: #fff; font-size: 18px;">
						<tr>
							<td width="51%">Lucky5滚动字幕3</td>
							<td width="37%" align="right"><a href="#"
								onclick="cancel('caption3');" onmouseout="MM_swapImgRestore()"
								onmouseover="MM_swapImage('Image27','','${basePath}/img/cz-hover.png',1)"><img
									src="${basePath}/img/cz.png" width="32" height="42"
									id="Image27" title="取消编辑" /></a></td>
							<td width="2%" align="right">|</td>
							<td width="10%" align="right"><a href="#"
								onclick="prompt('caption3');" onmouseout="MM_swapImgRestore()"
								onmouseover="MM_swapImage('Image18','','${basePath}/img/save-hover.png',1)"><img
									src="${basePath}/img/save.png" width="32" height="42"
									id="Image18" title="保存" /></a></td>
						</tr>
					</table>
				</td>
			</tr>
			<tr>
				<td class="nr" style="height: 220px">
					<div  style="margin: 0 auto; width: 460px;">
						<textarea id="caption3" name="sysDefaultValue" maxlength="100"
							rows="5" class="edui-editor" style="width: 465px;height:218px;
							 margin-left: -8; font-size: 35;">${scrollingNotice3}
						</textarea> 
					</div>
				</td>
			</tr>
		</table>
	</div>
</body>
</html>