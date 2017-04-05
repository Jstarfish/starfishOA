//如下用于所有的界面操作
//该函数基于jquery，及其ztree
// add by dzg
// 2013-12-2

tsmsg = function() {
	var idforlist = "selectedobjs";//树状的最外层<ul/>标签的id
	var idforagencys = "txtagencys";//输入销售站编码textarea的id
	var idforresvobj = "txtresvobjs";//存地域code的标签id
	var nameforresvobj = "txcitynames";//存地域名的标签id
	var levelId = "level_id";//存区域级别标签id
	var idformsgcontent = "txtmsgcontent";
	var idformsgtitle ="txtmsgtitle";
	var displayPosition = "position";//显示位置标签id
	var displayTime = "displayTime";//显示时间标签id
	var areapre = "_";
	var agencypre = "4_";
	var splitchar = "|";
	var objarr = null;
	var objidpre = "mobj_li_";
	var treeid = "treeDemo";
	var resvlistobj = null
	var xclassName = "cha";
	var xgetagencyurl = "tmnotice.do?method=asysGetAgencysByIDS";
	var xgetTerminalurl = "tmnotice.do?method=asysGetTerminalsByIDS";
	var xsendmsgurl = "tmnotice.do?method=sendNotice";
	var xsendmsgurl2 = "tmnotice.do?method=sendNotice2";//发送销售站公告
	var sendIMInfoUrl = "tmnotice.do?method=sendIMInfoData";//发送即时消息
	var sendTicketInfoUrl = "tmnotice.do?method=sendTicketData";//发送票面信息消息
	var listPageUrl = "tmnotice.do?method=notifyList";//升级计划列表页面
	var basepath ="";

	//设置路径
	function setBasePath(bpath)
	{
		basepath = bpath;
	}
	
	//内部函数用于生成对象id，目标是remove
	function getListObjId(objid, objtype) {
		if ((!isNullObj(objtype)) && (!isNullObj(objid))) {
			if(objtype == "4")
				return objidpre + agencypre + objid;
			else
				return objidpre + objtype + areapre + objid;
		}
		return null;
	}
	
	/**
	 * 检测添加的地域个数
	 * 不能超过20个地域
	 */
	function testCityNum(){
		var flag = false;
		var existCityNum = 0;
		var cityCodes = $("#"+idforresvobj).val();
		if (cityCodes != '') {
			existCityNum = cityCodes.split(",").length;
		}
		if (existCityNum > 20) {
			flag = true;
		}
		return flag;
	}

	//内部函数用于显示列表对象
	function showObj(treeNode, objtype) {
		var objid = getListObjId(treeNode.id, objtype);

		//检测是否已经包含对象
		if (isContain(treeNode.id))
			return;

		if (!resvlistobj)
			resvlistobj = $("#" + idforlist);
		resvlistobj.append("<li id='" + objid + "'> <a href='#'>"
				+ treeNode.name + "<span class='" + xclassName
				+ "' onclick=\" return tsmsg.removeObj('" + objid
				+ "','"+objtype+"','"+treeNode.id+"','"+treeNode.name+"')\">*</span></a></li>");

		var cobj = document.getElementById(idforresvobj);
		var cNameObj = document.getElementById(nameforresvobj);
		var levelObj = document.getElementById(levelId);
		if (!isNullObj(cobj)) {
			if (cobj.value != '') {
	//			cobj.value += (splitchar + objid);
				cobj.value += "," + treeNode.id;
				cNameObj.value += "," + treeNode.name + "(" + treeNode.id + ")";
				levelObj.value += "," + objtype;
			} else {
				cobj.value += treeNode.id;
				cNameObj.value += treeNode.name + "(" + treeNode.id + ")";
				levelObj.value += objtype;
			}
		}
		objid = null;
		cobj = null;
		cNameObj = null;
		levelObj = null;
	}

	//内部函数用于，判断是对象是否为空
	function isNullObj(obj) {
		if (typeof (obj) == "undefined" || obj == null)
			return true;
		return false;
	}

	//用于检测是否已经包含该对象，如果包含则跳过
	function isContain(objid) {
		var cobj = document.getElementById(idforresvobj);
		var flag = false;
		if (!isNullObj(cobj)) {
			var cobjv = cobj.value;
			if (cobjv!='') {
				var array = cobjv.split(",");
				for (var i=0; i<array.length; i++) {
					if (array[i]==objid) {
						flag = true;
						break;
					}
				}
			}
//			if (!isNullObj(cobjv)) {
//				return cobjv.indexOf(objid) >= 0;
//			}
		}
		return flag;
	}

	//外部函数，用于清除某一个对象
	function removeObj(objid, level, id, name) {
		var plist = document.getElementById(idforlist);//树状的最外层<ul/>标签的id
		var sonobj = document.getElementById(objid);//每一个地域的<li/>标签id
		var cobj = document.getElementById(idforresvobj);//存地域code的标签id
		var cNameObj = document.getElementById(nameforresvobj);//存地域名的标签id
		var levelObj = document.getElementById(levelId);//区域级别
		if ((!isNullObj(plist)) && (!isNullObj(sonobj)) && (!isNullObj(cobj))) {
			plist.removeChild(sonobj);
			if (cobj.value.indexOf(",")>-1) {//如果是多个值
				var array = cobj.value.split(",");
				var nameArray = cNameObj.value.split(",");
				var levelArray = levelObj.value.split(",");
				for (var i=0; i<array.length; i++) {
					if (array[i]==id) {
						array.splice(i,1);
						nameArray.splice(i,1);
						levelArray.splice(i,1);
					}
				}
				cobj.value = array.join(",");
				cNameObj.value = nameArray.join(",");
				levelObj.value = levelArray.join(",");
//				if (cobj.value.indexOf(id) > 0) {//如果不是最前的元素
//					cobj.value = cobj.value.replace(","+id, "");
//					cNameObj.value = cNameObj.value.replace(","+name+"("+id+")", "");
//					levelObj.value = levelObj.value.replace(","+level, "");
//				} else {//如果是第一个元素
//					cobj.value = cobj.value.replace(id+",", "");
//					cNameObj.value = cNameObj.value.replace(name+"("+id+"),", "");
//					levelObj.value = levelObj.value.replace(level+",", "");
//				}
			} else {
				cobj.value = "";
				cNameObj.value = "";
				levelObj.value = "";
			}
			
		}
		plist = null;
		sonobj = null;
		cobj = null;
		cNameObj = null;
		levelObj = null;
	}

	//清空选择对象
	function clearObjs() {
		objarr = null;
		var obj = document.getElementById(idforresvobj);//存地域code的标签id
//		var cNameObj = document.getElementById(nameforresvobj);//存地域名的标签id
		if (isNullObj(obj))
			alert(idforresvobj + "对象异常");
		obj.value = "";

		obj = null;
		obj = document.getElementById(nameforresvobj);//存地域名的标签id
		if (isNullObj(obj)) {
			alert(nameforresvobj + "对象异常");
		}
		obj.value = "";
		
		obj = null;
		obj = document.getElementById(levelId);
		if (isNullObj(obj))
			alert(levelId + "对象异常");
		obj.value = "";
		
		obj = null;
		obj = document.getElementById(idforlist);
		if (isNullObj(obj))
			alert(idforlist + "对象异常");
		obj.innerHTML = "";
	}

	//清空消息内容
	function clearMsgContent() {
		var obj = document.getElementById(idformsgcontent);
		var obj2 = document.getElementById(idformsgtitle);
		if (!isNullObj(obj))
			obj.value = "";
		if (!isNullObj(obj2))
			obj2.value = "";
	}

	//把所有选择节点添加到列表
	function addTreeOjbs() {
		var zTree = $.fn.zTree.getZTreeObj(treeid);
		if (!isNullObj(zTree)) {
			nodes = zTree.getCheckedNodes(true);
			//alert(nodes.length);
			if (nodes != null && nodes.length > 0) {
				$.each(nodes, function(n, node) {
					showObj(node, node.level);
				});
			} else {
				//alert('请选择区域');
				showMsg("信息提示","请选择区域","warn");
			}
		} else {
			alert('invalid tree');
		}
	}

	//外部函数用于获取销售站
	function getAgencys() {
		var obj = document.getElementById(idforagencys);//输入销售站编码textarea的id
		if (isNullObj(obj)) {
			alert(idforagencys + "对象异常");
			showMsg("信息提示",idforagencys + "对象异常！请联系开发人员！","warn");
			return;
		}
		var objv = obj.value;
		if (objv==''||objv==undefined) {
			showMsg("信息提示","销售站编码不能为空！","warn");
			return;
		}

//		var regags = new RegExp("^\d{6,12}([;|;]\d{6,12})*$");
//		if (!regags.test(objv)) {
//			alert("销售站编码异常，或格式不符合规定！");
//			return;
//		}
		
		var loadUrl = xgetagencyurl;
		var loadData = "&ids=" + objv + "&dt=" + new Date().getTime();
		$.ajax({
			url : loadUrl,
			data : loadData,
			method : 'POST',
			success : function(data) {
				if(isNullObj(data))
				{
					//alert("该销售站编码不存在！");
					showMsg("信息提示","该销售站编码不存在！","warn");
					return;
				}
				var xobj = eval('(' + data + ')'); 
				
				if (xobj != null &&(!isNullObj(xobj.list)) && xobj.list.length > 0) {
					$(xobj.list).each(function(index, agency) {

						var node = {
							id : agency.id,
							name : agency.name
						};
						showObj(node, 4);
					});
				} else {
					if((!isNullObj(xobj.list)) && xobj.list.length <= 0)
					{
						//alert("该销售站编码不存在！");
						showMsg("信息提示","该销售站编码不存在！","warn");
					}else
					{
						alert(data);
					}
											
				}
			}
		});
	}
	
	//外部函数用于获取终端机
	function getTerminals() {
		var obj = document.getElementById(idforagencys);//输入终端机编码textarea的id
		if (isNullObj(obj)) {
			//alert(idforagencys + "对象异常");
			showMsg("信息提示",idforagencys + "对象异常！请联系开发人员！","warn");
		}
		var objv = obj.value;
		if (objv==''||objv==undefined) {
			//alert("终端机编码不能为空！");
			showMsg("信息提示","终端机编码不能为空！","warn");
			return;
		}

//		var regags = new RegExp("^\d{6,12}([;|;]\d{6,12})*$");
//		if (!regags.test(objv)) {
//			alert("销售站编码异常，或格式不符合规定！");
//			return;
//		}
		
		var loadUrl = xgetTerminalurl;
		var loadData = "&ids=" + objv + "&dt=" + new Date().getTime();
		$.ajax({
			url : loadUrl,
			data : loadData,
			method : 'POST',
			success : function(data) {
				if(isNullObj(data))
				{
					//alert("该终端机编码不存在！");
					showMsg("信息提示","该终端机编码不存在！","warn");
					return;
				}
				var xobj = eval('(' + data + ')'); 
				
				if (xobj != null &&(!isNullObj(xobj.list)) && xobj.list.length > 0) {
					$(xobj.list).each(function(index, agency) {

						var node = {
							id : agency.id,
							name : agency.name
						};
						showObj(node, 4);
					});
				} else {
					if((!isNullObj(xobj.list)) && xobj.list.length <= 0)
					{
						//alert("该终端机编码不存在！");
						showMsg("信息提示","该终端机编码不存在！","warn");
					}else
					{
						alert(data);
					}
											
				}
			}
		});
	}
	
	String.prototype.getBytesLength = function() {   
	    var totalLength = 0;     
	    var charCode;  
	    for (var i = 0; i < this.length; i++) {  
	        charCode = this.charCodeAt(i);  
	        if (charCode < 0x007f)  {     
	            totalLength++;     
	        } else if ((0x0080 <= charCode) && (charCode <= 0x07ff))  {     
	            totalLength += 2;     
	        } else if ((0x0800 <= charCode) && (charCode <= 0xffff))  {     
	            totalLength += 3;   
	        } else{  
	            totalLength += 4;   
	        }          
	    }  
	    return totalLength;   
	}
	
	/**
	 * 即时消息发送
	 */
	function sendIMInfo(){
		var cobj = document.getElementById(idforresvobj);//存地域code的标签id
		var cNameObj = document.getElementById(nameforresvobj);//存地域名的标签id
		var levelObj = document.getElementById(levelId);//区域级别
		var postionId = document.getElementById(displayPosition);//显示位置id
		var displayTimeId = document.getElementById(displayTime);//显示时间
		var ccontent = document.getElementById(idformsgcontent);//公告内容id
		var cityCodeLen = cobj.value.split(",").length;
		var cityNameLent = cNameObj.value.split(",").length;
		
		if (isNullObj(cobj.value) || cobj.value=='' || cityCodeLen < 1)
		{
			//alert("通知接收列表不能为空！");
			showMsg("信息提示","通知接收列表不能为空！","warn");
			return;
		}
		
		if (isNullObj(cNameObj.value) || cNameObj.value == '' || cityNameLent < 1){
			//alert("发送区域名字参数有误！");
			showMsg("信息提示","发送区域名字参数有误！","warn");
			return;
		}
		if (testCityNum()) {
			//alert("发送对象最多20个！");
			showMsg("信息提示","发送对象最多20个！","warn");
			return;
		}
		if (postionId.value==0) {
			displayTimeId.value = 0;
		} else {
			if (displayTimeId.value=='' || Number(displayTimeId.value)<10 || Number(displayTimeId.value)>3600) {
				//alert("请输入大于10小于3600的显示时间");
				showMsg("信息提示","请输入大于10小于3600的显示时间！","warn");
				return;
			}
		}
		if (ccontent.value.length == 0) {
			//alert("请输入消息内容！");
			showMsg("信息提示","请输入消息内容！","warn");
			return;
		}
		
		var str = escape(ccontent.value);
		var ent="%0A";
		var arr=str.split(ent);
		if (arr.length>3) {
			//alert("消息内容不要超过3行");
			showMsg("信息提示","消息内容不要超过3行！","warn");
			return;
		}
		
		if (ccontent.value.getBytesLength() > 200) {
			//alert("消息内容不能超过200字符！汉字算3个字符");
			showMsg("信息提示","消息内容不能超过200字符！汉字算3个字符！","warn");
			return;
		}
		
		var url = sendIMInfoUrl;
//		var loadData = "&objs=" + cobj.value + "&nameObjs=" + encodeURI(cNameObj.value) + "&levelId=" + levelObj.value + "&postionId=" + postionId.value + "&displayTime=" + displayTimeId.value + "&content=" + encodeURI(ccontent.value) + "&dt=" + new Date().getTime();
		div_off("button-div");
		$.ajax({
			url : url,
			data : $("#planForm").serialize(),
			type : 'post',
			async : false,
			contentType: "application/x-www-form-urlencoded; charset=utf-8",
			success : function(data) {
				if (data == 1) {
					showMsg('','发送成功！','right','reLoad()');
				} else {
					showMsg('','发送失败!','error','reLoad()');
				}
				/*if (data != null && data.length > 0) {
					alert(data);
				} */
			}
		});
	}
	
	//发送消息
	function sendMsg() {
		var ctitle = document.getElementById(idformsgtitle);//公告名称id
		var ccontent = document.getElementById(idformsgcontent);//公告内容id
		var cobj = document.getElementById(idforresvobj);//存地域code的标签id
		var cNameObj = document.getElementById(nameforresvobj);//存地域名的标签id
		var cityCodeLen = cobj.value.split(",").length;
		var cityNameLent = cNameObj.value.split(",").length;
		
		if (isNullObj(cobj.value) || cobj.value=='' || cityCodeLen < 1)
		{
			//alert("通知接收列表不能为空！");
			showMsg("信息提示","通知接收列表不能为空！","warn");
			return;
		}
		
		if (isNullObj(cNameObj.value) || cityNameLent < 1)
		{
			//alert("发送区域名字参数有误！");
			showMsg("信息提示","发送区域名字参数有误！","warn");
			return;
		}
		
		if (testCityNum()) {
			//alert("发送对象最多20个！");
			showMsg("信息提示","发送对象最多20个！","warn");
			return;
		}
			
		if (isNullObj(ctitle.value) || ctitle.value.length <= 0) {
			alert("公告名称不能为空！");
			showMsg("信息提示","公告名称不能为空！","warn");
			return;
		}
		
		if (isNullObj(ccontent.value) || ccontent.value.length==0) {
			//alert("公告内容不能为空！");
			showMsg("信息提示","公告内容不能为空！","warn");
			return;
		}
		
		if (ctitle.value.length > 50) {
			//alert("公告名称不能超过50字符");
			showMsg("信息提示","公告名称不能超过50字符","warn");
			return;
		}
		
		var str = escape(ccontent.value);
		var ent="%0A";
		var arr=str.split(ent);
		if (arr.length>3) {
			//alert("公告内容不要超过3行");
			showMsg("公告内容不要超过3行!","warn");
			return;
		}
		
		if (ccontent.value.length > 200) {
			//alert("公告内容不能超过200字符");
			showMsg("信息提示","公告内容不能超过200字符！","warn");
			return;
		}

//		var loadUrl = xsendmsgurl;
		var loadUrl = xsendmsgurl2;
//		var loadData = "&objs=" + cobj.value + "&nameObjs=" + encodeURI(cNameObj.value) + "&title=" + encodeURI(ctitle.value) +"&content=" + encodeURI(ccontent.value) +"&dt=" + new Date().getTime();
//		
		div_off("button-div");
		$.ajax({
			url : loadUrl,
			data : $("#planForm").serialize(),
			type : 'post',
			dataType : "text",
			async : false,
			contentType: "application/x-www-form-urlencoded; charset=utf-8",
			success : function(data) {
				if (data == 1) {
					//alert("发送成功!");
					//window.location.href = listPageUrl;
					showMsg('','发送成功!','right','jumpTo(\''+listPageUrl+'\')');
				} else {
					//alert("发送失败!");
					showMsg('','发送失败!','error','reLoad()');
				}
			}
		});
	}
	
	function div_off(btnId) {
		var btnObj = findObj(btnId);
	    btnObj.className += " div-wait";
	    btnObj.innerText = "";
	    btnObj.onclick = null;
	}
	
	/**
	 * 票面信息发布
	 */
	function publisTicketInfo(sInfo, fInfo){
		//div_off("button-div");
		var url = sendTicketInfoUrl;
		$.ajax({
			url : url,
			data : $("#planForm").serialize(),
			type : 'post',
			async : false,
			contentType: "application/x-www-form-urlencoded; charset=utf-8",
			success : function(data) {
				if (data==1) {
					showMsg('',sInfo,'right','reLoad()');
				} else {
					showMsg('',fInfo,'error','reLoad()');
				}
			}
		});
	}
	
	
	return {
		addTer : getTerminals,
		addag : getAgencys,
		addar : addTreeOjbs,
		clscc : clearMsgContent,
		clsobj : clearObjs,
		removeObj : removeObj,
		sendMsg : sendMsg,
		setBasePath:setBasePath,
		sendIMInfo : sendIMInfo,
		publisTicketInfo:publisTicketInfo
	}
}();
