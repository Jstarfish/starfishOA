var $ = function(obj) {
	return document.getElementById(obj);
};
var StringBuilder = function() {
	this._buffer = [];
};
StringBuilder.prototype.append = function(str) {
	this._buffer.push(String(str));
};
StringBuilder.prototype.toString = function() {
	return this._buffer.join('');
};
StringBuilder.prototype.clear = function() {
	this._buffer = [];
};

var menu_data = new Array();// 所有菜单的集合
var menu_data_tree = new Array();// 菜单树的关系集合

// 添加菜单内容 id 父id 显示内容 菜单链接 显示位置 显示图片
function menu_add(id, pid, title, url, target, icon) {
	var urlx = url;
	if(url == null || url =="" || url.indexOf("#") >=0)
	{
		urlx = "javascript:void(0);";
	}else{
		urlx = getRootPath()+url;
	}
	var arr = new Array();
	arr["id"] = id;
	arr["pid"] = pid;
	arr["title"] = title;
	arr["url"] = urlx;
	arr["target"] = target;
	arr["icon"] = icon;
	menu_data[id] = arr;

	if (!menu_data_tree[pid]) {
		menu_data_tree[pid] = new Array();
	}
	menu_data_tree[pid].push(id);
}


function make_title(url,title,ulid)
{
	//alert(url);
//	if(url.length > 0 && url.href != "#")
//		document.getElementById('title').innerHTML=title;
	
	if (typeof (ulid) == "undefined" || ulid.length <= 0) 
		return "";
	var obj = document.getElementById(ulid);
	hideSuperfishUl(obj);
//	if(typeof (ulid) != "undefined" )
//	{
//		obj.style.display="none";
//		obj.style.visibility="hidden";
//	}	
	//$(ulid).css("display: none; visibility: hidden;");
}


//add by dzg cp and merged by superfish
function showSuperfishUl(ulid)
{
	if (typeof (ulid) == "undefined" 
	|| ulid.length <= 0) 
	return "";
	var obj = document.getElementById("ulmenu"+ulid);

	if (typeof (obj) == "undefined" 
		|| obj == null) 
		return;

	obj.style.display = 'block';
	//$(obj).addClass("sfHover").find('>ul:hidden').css('visibility','visible');
}

function hideSuperfishUl(obj)
{
	if (typeof (obj) == "undefined" || obj == null) 
		return;
	
	obj.style.display = 'none';
	//$(['li.sfHover']).removeClass("sfHover").find('>ul').hide().css('visibility','hidden');
	
}

function make_menu(id){
	
	var arr = menu_data_tree["1"];// 得到一级菜单的集合
	if(arr ==null || typeof (arr) == "undefined")
		return;
	var def_id = id ? id : arr[0];// id为空默认选中主菜单的第一个节点
	var rootpath = getRootPath();// 得到根路径
	var str = new StringBuilder();// 生成一级菜单的字符串
	
	str.append("<ul class=\"sf-menu sf-js-enabled sf-shadow\">");
	for ( var i in arr) {
		var data = menu_data[arr[i]];
		var orherdata = menu_data_tree[data["id"]];
		var css="kk";

		str.append("<li onmouseover=\"showSuperfishUl("+data["id"]+");\">");
		
		if (typeof (orherdata) != "undefined" && orherdata.length != 0) {
			css="sf-with-ul";
			str.append("<a href=\""+data["url"]+"\" target=\""+data["target"]+"\" class=\""+css+"\" onclick=\"return false;\">"+data["title"]);
		}else{
			css="kk";
			str.append("<a href=\""+data["url"]+"\" target=\""+data["target"]+"\" class=\""+css+"\" onclick=\"make_title('"+ data["url"] +"','"+data["title"]+"','')\">"+data["title"]);
		}

		if(typeof (orherdata) != "undefined" && orherdata.length != 0)
		{
			//alert(data["title"]+" has "+orherdata.length);
			str.append("<span class=\"sf-sub-indicator\">&#187;</span>");
		}
		str.append("</a>");
		str.append(make_other(data["id"]));
		str.append("</li>");
	}
	str.append("</ul>");
	document.getElementById('menus').innerHTML=str.toString() + document.getElementById('menus').innerHTML;	
}

function make_other(def_id){

	if(def_id=='0')
		return "";
	var arr = menu_data_tree[def_id];
	if (typeof (arr) == "undefined" || arr.length <= 0) 
		return "";
	
	var stro = new StringBuilder();
	var ulid ="ulmenu"+def_id;
	stro.append("<ul id=\"" +ulid +"\">");
	
	for ( var i in arr) 
	{
		//菜单信息
		var data = menu_data[arr[i]];
		if (data == null ||typeof (data) == "undefined" )
			continue;

		stro.append("<li>");		
		var arr2 = menu_data_tree[arr[i]];
		if (typeof (arr2) != "undefined" && arr2.length > 0) {
			stro.append("<a href=\""+data["url"]+"\" target=\""+data["target"]+"\" class=\"sf-with-ul\" onclick=\"make_title('"+ data["url"] +"','"+data["title"]+"','"+ulid+"')\">"+data["title"]);  
			stro.append("<span class=\"sf-sub-indicator\">&#187;</span>");
			stro.append("</a>");
			stro.append(menu_other(arr2,ulid));
		}else{
			stro.append("<a href=\""+data["url"]+"\" target=\""+data["target"]+"\" onclick=\"make_title('"+ data["url"] +"','"+data["title"]+"','"+ulid+"')\">"+data["title"]+"</a>");  
		}
		
		stro.append("</li>");

    }    
	stro.append("</ul>");
	return stro.toString();                
}

//三级菜单
function menu_other(oarr,ulid){
	var strs = new StringBuilder();
	strs.append("<ul>");
	for ( var j in oarr) {
		
		//获取菜单
		var temparr = menu_data[oarr[j]];			
        strs.append("<li><a href=\""+temparr["url"]+"\" target=\""+temparr["target"]+"\" onclick=\"make_title('"+ temparr["url"] +"','"+temparr["title"]+"','"+ulid+"')\">"+temparr["title"]+"</a>");
		//var arr2 = menu_data_tree[temparr["id"]];
		//if (typeof (arr2) != "undefined" && arr2.length != 0) {
		//	strs.append(menu_other(arr2));
		//}
        strs.append("</li>");
	}
	strs.append("</ul>");
	return strs.toString();
}

// js get root path
function getRootPath() {
	var curWwwPath = window.document.location.href;
	var pathName = window.document.location.pathname;
	var pos = curWwwPath.indexOf(pathName);
	var localhostPaht = curWwwPath.substring(0, pos);
	var projectName = pathName
			.substring(0, pathName.substr(1).indexOf('/') + 1);
	return (localhostPaht + projectName);
}