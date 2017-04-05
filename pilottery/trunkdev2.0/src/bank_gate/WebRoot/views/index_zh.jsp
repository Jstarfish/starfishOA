<%@ page language="java" contentType="text/html; charset=UTF-8"   pageEncoding="UTF-8"%>
<%@ include file="/views/common/taglibs.jsp" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>

<head>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="renderer" content="webkit">
	<%@ include file="/views/common/meta.jsp" %>
    <title>无纸化管理平台 - 主页</title>

    <link rel="shortcut icon" href="favicon.ico"> 
    <link href="${basePath}/css/bootstrap.min.css?v=3.3.6" rel="stylesheet">
    <link href="${basePath}/css/font-awesome.min.css?v=4.4.0" rel="stylesheet">
    <link href="${basePath}/css/animate.css" rel="stylesheet">
    <link href="${basePath}/css/style.css?v=4.1.0" rel="stylesheet">
    <link rel="stylesheet" href="${basePath}/css/plugins/sweetalert/sweetalert.css">
    
      <!-- 全局js -->
    <script src="${basePath}/js/jquery.min.js?v=2.1.4"></script>
    <script src="${basePath}/js/bootstrap.min.js?v=3.3.6"></script>
    <script src="${basePath}/js/plugins/metisMenu/jquery.metisMenu.js"></script>
    <script src="${basePath}/js/plugins/slimscroll/jquery.slimscroll.min.js"></script>
    <script src="${basePath}/js/plugins/layer/layer.min.js"></script>
    <script src="${basePath}/js/plugins/sweetalert/sweetalert.min.js"></script>
    <script type="text/javascript" src="${basePath}/js/contabs.js"></script>
   
    <script src="${basePath}/js/plugins/pace/pace.min.js"></script>
    
    <script type="text/javascript">
	    var menuList = new Array();// 所有菜单的集合
	    var menuTree = new Array();// 菜单树的关系集合
	    var iconArr = ["fa-sitemap","fa-shopping-cart","fa-dollar","fa-bar-chart","fa-leaf","fa-gift","fa-folder"];  //图表，美金
	    	
		<c:forEach items="${menuList}" var="p">
			initMenuList('${p.id}','${p.parentId}','${p.remark}','${p.url}','${p.menuLevel}','');
		</c:forEach>

		function initMenuList(id,pid,name,url,level,icon){
			var menu = new Array();
			menu["id"] = id;
			menu["pid"] = pid;
			menu["name"] = name;
			menu["level"] = level;
			menu["icon"] = icon;
			/* if(url == "undefined"){
				url = "#"; 
			}else{
				url = str.replace(/(^\s*)|(\s*$)/g,"")
				if(url.length==0||url == "#"){
					url = "#";
				}else{
					url=getRootPath() + url;
				}
			} */
			menu["url"] = url;
			menuList[id] = menu;

			if(!menuTree[pid]){
				menuTree[pid] = new Array();
			}
			menuTree[pid].push(id);
		};

		function getRootPath() {
			var curWwwPath = window.document.location.href;
			var pathName = window.document.location.pathname;
			var pos = curWwwPath.indexOf(pathName);
			var localhostPaht = curWwwPath.substring(0, pos);
			var projectName = pathName.substring(0, pathName.substr(1).indexOf('/') + 1);
			return (localhostPaht + projectName);
		}

		function makeMenu(){
			var fstLevel = menuTree[0];
			
			
			var menuStr = "";
			var index = 0;
			for(var i in fstLevel){		//一级菜单
				//alert(menuList[fstLevel[i]].name);
				var scdLevel  = menuTree[fstLevel[i]];
				if(scdLevel){
					menuStr += "<li><a href=\"" + menuList[fstLevel[i]].url + "\"><i class=\"fa "+iconArr[index++]+"\"></i><span class=\"nav-label\">" + menuList[fstLevel[i]].name
					+ "</span><span class=\"fa arrow\"></span></a>";
					
					menuStr += "<ul class=\"nav nav-second-level\">";
					for(var j in scdLevel){
						//alert(menuList[scdLevel[j]].name);
						var thdLevel = menuTree[scdLevel[j]];
						
						if(thdLevel){		//三级
							menuStr += "<li><a href=\""+menuList[scdLevel[j]].url+"\">"+menuList[scdLevel[j]].name+" <span class=\"fa arrow\"></span></a><ul class=\"nav nav-third-level\">";
								
							for(var k in thdLevel){
								//alert(menuList[thdLevel[k]].name);
								menuStr += "<li><a class=\"J_menuItem\" href=\""+menuList[scdLevel[k]].url+"\" >"+menuList[scdLevel[k]].name+"</a></li>";
							}
							
							menuStr += "</ul></li>";
						}else{
							menuStr += "<li><a class=\"J_menuItem\" href=\""+menuList[scdLevel[j]].url+"\">"+menuList[scdLevel[j]].name+"</a></li>";
						}
					}
					
					menuStr += "</ul></li>";
				}else{
					menuStr += "<li><a class=\"J_menuItem\" href=\""+menuList[fstLevel[i]].url+"\"><i class=\"fa "+iconArr[index++]+"\"></i> <span class=\"nav-label\">"
						+ menuList[fstLevel[i]].name+"</span></a></li>"
				}
				
			}
			
			$("#side-menu").append(menuStr);
			
			$("#side-menu a").attr("target","iframe0");

		    // MetsiMenu
		    $('#side-menu').metisMenu();
		    
		    $('#side-menu>li').click(function () {
		        if ($('body').hasClass('mini-navbar')) {
		            NavToggle();
		        }
		    });
		    $('#side-menu>li li a').click(function () {
		        if ($(window).width() < 769) {
		            NavToggle();
		        }
		    });
		}
		
		function logout(){
			swal({
		        title: "您确定要退出系统吗？",
		        type: "warning",
		        showCancelButton: true,
		        cancelButtonText:"取消",
		        confirmButtonColor: "#DD6B55",
		        confirmButtonText: "退出",
		        closeOnConfirm: false
		    }, function () {
		    	window.top.location.href="${basePath}";
		    });
		}
    </script>
    
    <script src="${basePath}/js/hplus.js?v=4.1.0"></script>
     
</head>

<body onload="makeMenu();" class="fixed-sidebar full-height-layout gray-bg" style="overflow:hidden;">
    <div id="wrapper" style="overflow: hidden;">
        <!--左侧导航开始-->
        <nav class="navbar-default navbar-static-side" role="navigation">
            <div class="nav-close"><i class="fa fa-times-circle"></i>
            </div>
            <div class="sidebar-collapse">
                <ul class="nav" id="side-menu">
                    <li class="nav-header" style="background-color: rgb(39, 160, 215);">
                        <div class="dropdown profile-element">
                            <span><img alt="image" src="${basePath}/img/LOGO.png"/></span>
                        </div>
                        <div class="logo-element"><img alt="image" src="${basePath}/img/logo-small.png" />
                        </div>
                    </li>
                    
                </ul>
            </div>
        </nav>
        <!--左侧导航结束-->
        <!--右侧部分开始-->
        <div id="page-wrapper" class="gray-bg dashbard-1">
            <div class="row border-bottom">
                <nav class="navbar navbar-static-top" role="navigation" style="margin-bottom: 0">
                    <div class="navbar-header"><a class="navbar-minimalize minimalize-styl-2 btn btn-primary " href="#"><i class="fa fa-bars"></i> </a>
                      <!--  <form role="search" class="navbar-form-custom" method="post" action="search_results.html">
                            <div class="form-group">
                                <input type="text" placeholder="请输入您需要查找的内容 …" class="form-control" name="top-search" id="top-search">
                            </div>
                        </form>-->
                    </div>
                    <ul class="nav navbar-top-links navbar-right">
                     	<!--
                     	<li class="hidden-xs">
                            <a href="index_v1.html" class="J_menuItem" data-index="0"><i class="fa fa-desktop"></i> 电脑票平台</a>
                        </li>
                         <li class="hidden-xs">
                            <a href="index_v1.html" class="J_menuItem" data-index="0"><i class=" fa fa-ticket"></i> 即开票平台</a>
                        </li>
                         <li class="hidden-xs">
                            <a href="index_v1.html" class="J_menuItem" data-index="0"><i class="fa fa-mobile "></i> 手机APP平台</a>
                        </li>
                         <li class="hidden-xs">
                            <a href="index_v1.html" class="J_menuItem" data-index="0"><i class="fa fa-book"></i> 无纸化平台</a>
                        </li>
                       
                         <li class="dropdown">
                            <a class="dropdown-toggle count-info" href="#" data-toggle="dropdown">
                                <i class="fa fa-bell"></i> <span class="label label-primary">8</span>
                            </a>
                            <ul class="dropdown-menu dropdown-alerts">
                                <li>
                                    <a href="mailbox.html">
                                        <div>
                                            <i class="fa fa-envelope fa-fw"></i> 您有16条未读消息
                                            <span class="pull-right text-muted small">4分钟前</span>
                                        </div>
                                    </a>
                                </li>
                                <li class="divider"></li>
                                <li>
                                    <a href="profile.html">
                                        <div>
                                            <i class="fa fa-qq fa-fw"></i> 3条新回复
                                            <span class="pull-right text-muted small">12分钟钱</span>
                                        </div>
                                    </a>
                                </li>
                                <li class="divider"></li>
                                <li>
                                    <div class="text-center link-block">
                                        <a class="J_menuItem" href="notifications.html">
                                            <strong>查看所有 </strong>
                                            <i class="fa fa-angle-right"></i>
                                        </a>
                                    </div>
                                </li>
                            </ul>
                        </li> -->
                         <li class="dropdown">
                            <p class="dropdown-toggle count-info" data-toggle="dropdown" href="#">
                                <i class="fa fa-user"></i> ${sessionScope.currentUser.loginId}
                            </p>
                            <!-- <ul class="dropdown-menu dropdown-alerts">
                                <li><a href="form_avatar.html">修改头像</a>
                                </li>
                                <li><a href="profile.html">个人资料</a>
                                </li>
                                <li><a href="contacts.html">联系我们</a>
                                </li>
                                <li><a href="mailbox.html">信箱</a>
                                </li>
                                <li class="divider"></li>
                                <li><a href="login.html">安全退出</a>
                                </li>
                            </ul> -->
                        </li>
                        <li style="margin-right: 30px;">
                        	<a class="dropdown-toggle count-info" data-toggle="dropdown" style="color:#27a0d7;" onclick="logout();">
                                <i class="fa fa-sign-out"></i> 登出</i>
                            </a>
                        </li>
                    </ul>
                </nav>
            </div>
            <div class="row J_mainContent" id="content-main">
                <iframe class="J_iframe" name="iframe0" width="100%" height="100%" src="index_v1.html?v=4.0" frameborder="0" data-id="index_v1.html" seamless></iframe>
            </div>
            <div class="footer">
                <div class="pull-right">&copy; 2016-2017  China LotSynergy </div>
            </div>
        </div>
        <!--右侧部分结束-->
    </div>
</body>

</html>
