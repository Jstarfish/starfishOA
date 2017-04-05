<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="/views/common/meta.jsp" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<link rel="stylesheet" href="${basePath}/css/cncp/common.css"/>
<title>Insert title here</title>
<style>
body {
	font-family: "Times New Roman", Times, serif, "微软雅黑";
}
</style>
<script type="text/javascript" charset="UTF-8">
function print() {
	var fundNo = '${fundNo }';
	var index = parent.layer.getFrameIndex(window.name);
	
	var index = parent.layer.open({
		  type: 2,
		  title: 'Top Up',
		  //maxmin: true,
		  shadeClose: true, //点击遮罩关闭层
		  area : ['1220px' , '720px'],
		  content: 'capital.do?method=printCertificate&fundNo='+fundNo,
		  end:function close(){
			  window.parent.location.reload();
		  }
	  });
	//layer.full(index);
	layer.close(index);
}
</script>
</head>
<body>
<div id="success_page">
	<div style="padding:50px;">
			<table width="100%" border="0" cellspacing="0" cellpadding="0"">
				<tr>
					<td width="30%" align="right" valign="top"><img alt="success"
						src="${basePath}/img/successTip.png" width="49" height="49">
					</td>
					<td width="50%" colspan="3" valign="top">
						<p>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Top Up Success！</p>
						<br /><br /><br />
						<table>
							<tr>
								<td>
									<div style="height: 500px;">
										<button class="report-print-button" type="button"
											onclick="print();">
											<table width="100%" border="0" cellspacing="0"
												cellpadding="0">
												<tbody>
													<tr>
														<td><img src="${basePath}/img/icon-printer.png"
															width="18" height="17" /></td>
														<td></td>
														<td></td>
														<td style="color: #fff;">Print</td>
													</tr>
												</tbody>
											</table>
										</button>
									</div>
								</td>
							</tr>
						</table>
					</td>
				</tr>
			</table>
		</div>
</div> 
</body>
</html>