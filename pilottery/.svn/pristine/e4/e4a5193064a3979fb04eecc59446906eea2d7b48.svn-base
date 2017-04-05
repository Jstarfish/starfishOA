
/**
 * @author  heqiang  2014/09/25
 * @version 1.0
 */

/***----------------------------------------------------------------------------------------------***/
function showBox(url, title, height, width) {

    var mydiv = document.getElementById("mydiv");
    if(mydiv == null) {
        mydiv = document.createElement("div"); 
        mydiv.id = "mydiv";

        var str = 
            '<div id="fullbg"></div>' +
            '<div id="dialog" style="height:'+height+'px;width:'+width+'px">' +
                '<div class="title" onmousedown="mouseDown(event)">'+title+'<div class="close"><a href="#" onclick="closeBox();"></a></div></div>' +
                '<div class="container">' +
                    '<iframe id="ifdialog" src="' + url + '" frameborder="0" scrolling="auto" style="width:100%; height:100%;"/>' +
                '</div>' +
            '</div>';

        mydiv.innerHTML= str;

        document.body.appendChild(mydiv);
    }

	openBox();

    document.getElementById("dialog").onmouseout = mouseUp;
    window.onmouseup = mouseUp;
    window.onmousemove = mouseMove;
}


//显示灰色 jQuery 遮罩层 
function openBox() {
    var height = window.document.body.offsetHeight;
    //var height = window.document.body.innerHeight;
    var width = window.document.body.offsetWidth;

    var fullbg = document.getElementById("fullbg");
    fullbg.style.display = "block";

    var dialog = document.getElementById("dialog");

	var left = (width - parseInt(dialog.style.width))/2;
    dialog.style.left = left + "px";
    dialog.style.top = "20px";

//    if(parseInt(dialog.style.height) > height) {
//    	dialog.style.height = height;
//    }
//    if(parseInt(dialog.style.width) > width) {
//    	dialog.style.width = width;
//    }

    dialog.style.display = "block";
}


//关闭灰色 jQuery 遮罩 
function closeBox() {
//	document.getElementById("fullbg").style.display = "none";
//	document.getElementById("dialog").style.display = "none";
	mydiv.parentNode.removeChild(mydiv);

    window.onmouseup = function(){};
    window.onmousemove = function(){};
}



//鼠标拖拽效果

var down = false;

var mX, mY, dX, dY;

function mouseDown(event) {
  down = true;
  mX = event.clientX;
  mY = event.clientY;
  dX = parseInt(dialog.style.left);
  dY = parseInt(dialog.style.top);
}

function mouseUp()
{
  if (down)
  {
      down = false;
  }
}

//鼠标在指定区域移动时会触发此事件
function mouseMove(event) {
  //必先判断鼠标左键已被在指定区域按下
  if (down) {
      //设置该层坐标等于原坐标加上鼠标移动的坐标
	  //dialog.style.left=dX+event.clientX-mX;
      //dialog.style.top=dY+event.clientY-mY;
	  
	  var left = dX + event.clientX - mX;
	  var top = dY + event.clientY - mY;
	  
	  left = left<=0 ? 0:left;
	  top = top<=0 ? 0:top;

      dialog.style.left = left + "px";
      dialog.style.top = top + "px";

  }
}


/***----------------------------------------------------------------------------------------------***/


function showPage(url,title) {

    var mydiv = document.getElementById("mydiv");
    if(mydiv == null) {
        mydiv = document.createElement("div"); 
        mydiv.id = "mydiv";

       /**
       var str = 
            '<div id="fullbg"></div>' +
            '<div id="dialog" style="height: 100%;left: 50px;top: 0px;right: 0px;">' +
                '<div class="title">'+title+'<div class="close"><a href="#" onclick="closePage();"></a></div></div>' +
                '<div class="container">' +
                    '<iframe id="ifdialog" src="' + url + '" frameborder="0" scrolling="auto" style="width:100%; height:100%;"/>' +
                '</div>' +
            '</div>';
        **/

        var str = 
            '<div id="fullbg"></div>' +
            '<div id="dialog" style="height: 100%;left: 300px;top: 0px;right: 0px;">' +
                '<div class="big-title">'+title+'<div class="close"><a href="#" onclick="closePage();"></a></div></div>' +
                '<div class="big-container">' +
                    '<iframe id="ifdialog" src="' + url + '" frameborder="0" scrolling="auto" style="width:100%; height:100%;"/>' +
                '</div>' +
            '</div>';

        mydiv.innerHTML= str;

        document.body.appendChild(mydiv);
    }

	openPage();

}

//显示灰色 jQuery 遮罩层 
function openPage() {
    var fullbg = document.getElementById("fullbg");
    fullbg.style.display = "block";

    var dialog = document.getElementById("dialog");
    dialog.style.display = "block";
}


//关闭灰色 jQuery 遮罩 
function closePage() {
	mydiv.parentNode.removeChild(mydiv);
}

/***----------------------------------------------------------------------------------------------***/
function showDialog(func, title, msg) {

    var mydiv = document.getElementById("mydiv");
    if(mydiv == null) {
        mydiv = document.createElement("div"); 
        mydiv.id = "mydiv";

        var str = 
            '<div id="fullbg"></div>' +
            '<div id="dialog" style="height:220px;width:400px">' +
                '<div class="title" onmousedown="mouseDown(event)">'+title+'<div class="close"><a href="#" onclick="closeDialog();"></a></div></div>' +
                '<div class="container">' +
                    '<table border="0" cellspacing="0" cellpadding="0" width="100%" height="100%" style="word-wrap:break-word;">' +
                        '<tr><td width="25%"><div class="question"><div></td><td style="font-size:14px;padding: 0px 50px 0px 10px;word-break: keep-all">' + msg + '</td></tr>' +
                        '<tr height="60px">' +
                            '<td colspan="2" class="fotter">' +
                                '<input id="ok_button" type="button" onclick="' + func + '" class="my-button" value="确 定" style="float:left;margin-left:50px"></input>' +
                                '<input type="button" class="my-button" value="取 消" onclick="closeDialog()" style="float:right;margin-right:50px"></input>' +
                            '</td>' +
                        '</tr>' +
                    '</table>' +
                '</div>' +
            '</div>';

        mydiv.innerHTML= str;
        document.body.appendChild(mydiv);
    }

	openDialog();

    document.getElementById("dialog").onmouseout = mouseUp;
    window.onmouseup = mouseUp;
    window.onmousemove = mouseMove;
}

function dialogOk() {
    alert("确定！");
}


function openDialog() {
    var height = window.document.body.offsetHeight;
    var width = window.document.body.offsetWidth;

    var fullbg = document.getElementById("fullbg");
    fullbg.style.display = "block";

    var dialog = document.getElementById("dialog");

	var left = (width - parseInt(dialog.style.width))/2;
    dialog.style.left = left + "px";
    dialog.style.top = "100px";

    dialog.style.display = "block";
}


//关闭灰色 jQuery 遮罩 
function closeDialog() {

	mydiv.parentNode.removeChild(mydiv);

    window.onmouseup = function(){};
    window.onmousemove = function(){};
}


/***----------------------------------------------------------------------------------------------***/
function showMsg(title,msg,imgSrc,func) {
	var okFunc = func == null ? "" : func;

    var mydiv = document.getElementById("mydiv");
    if(mydiv == null) {
        mydiv = document.createElement("div"); 
        mydiv.id = "mydiv";

        var str = 
            '<div id="fullbg"></div>' +
            '<div id="dialog" style="height:220px;width:350px">' +
                '<div class="title" onmousedown="mouseDown(event)">'+title+'<div class="close"><a href="#" onclick="closeDialog();"></a></div></div>' +
                '<div class="container">' +
                    '<table border="0" cellspacing="0" cellpadding="0" width="100%" height="100%" style="word-wrap:break-word;">' +
                        '<tr><td width="30%"><div class="' + imgSrc + '"></div></td><td style="font-size:14px;padding: 0px 50px 0px 10px;">' + msg + '</td></tr>' +
                        '<tr height="60px">' +
                            '<td colspan="2" class="fotter">' +
                                '<input type="button" id="jsOKButton" onclick="' + okFunc + ';closeMsg();" class="my-button" value="确 定" style="float:right;margin-right:30px;"></input>' +
                            '</td>' +
                        '</tr>' +
                    '</table>' +
                '</div>' +
            '</div>';

        mydiv.innerHTML= str;
        document.body.appendChild(mydiv);
    }
    
	openMsg();

    var okButton = document.getElementById("jsOKButton");
    if (okButton != null) {
        //okButton.focus();
    }
    document.getElementById("dialog").onmouseout = mouseUp;
    window.onmouseup = mouseUp;
    window.onmousemove = mouseMove;
}

function showWarnBack(msg,backUrl) {
	var mydiv = document.getElementById("mydiv");
    if(mydiv == null) {
        mydiv = document.createElement("div"); 
        mydiv.id = "mydiv";
        var str = 
            '<div id="fullbg"></div>' +
            '<div id="dialog" style="height:220px;width:350px">' +
                '<div class="title" onmousedown="mouseDown(event)">Information<div class="close"><a href="#" onclick="closeDialog();"></a></div></div>' +
                '<div class="container">' +
                    '<table border="0" cellspacing="0" cellpadding="0" width="100%" height="100%" style="word-break: break-all;">' +
                        '<tr><td width="30%"><div class="warn"></div></td><td style="font-size:14px;padding: 0px 50px 0px 10px;">' + msg + '</td></tr>' +
                        '<tr height="60px">' +
                            '<td colspan="2" class="fotter">' +
                                '<a href="' + backUrl + '" onclick="closeMsg();" style="float:right;margin-right:30px;"><button class="my-button">返回</button></a>' +
                            '</td>' +
                        '</tr>' +
                    '</table>' +
                '</div>' +
            '</div>';

        mydiv.innerHTML= str;
        document.body.appendChild(mydiv);
    }

	openMsg();

    document.getElementById("dialog").onmouseout = mouseUp;
    window.onmouseup = mouseUp;
    window.onmousemove = mouseMove;
}


function openMsg() {
    var height = window.document.body.offsetHeight;
    var width = window.document.body.offsetWidth;

    var fullbg = document.getElementById("fullbg");
    fullbg.style.display = "block";

    var dialog = document.getElementById("dialog");

	var left = (width - parseInt(dialog.style.width))/2;
    dialog.style.left = left + "px";
    dialog.style.top = "100px";

    dialog.style.display = "block";
}


//关闭灰色 jQuery 遮罩 
function closeMsg() {

	mydiv.parentNode.removeChild(mydiv);

    window.onmouseup = function(){};
    window.onmousemove = function(){};
}


function showRight() {
    showMsg("Information","Congratulations, the operation is successful!","right");
}

function showWarn(warnMsg) {
    showMsg("Information",warnMsg,"warn");
}

function showError(errorMsg) {
    showMsg("Information",errorMsg,"error");
}







