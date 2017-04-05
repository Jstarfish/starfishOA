
//document.write("script language='javascript' src='myJs.js'></script");

/**
 * @description   弹出窗口
 * @param url  	  连接
 * @param title   标题
 * @param height  窗口高度 
 * @param width   窗口宽度 
 */
function showBox(url, title, height, width) {

    var mydiv = document.getElementById("mydiv");
    if(mydiv == null) {
        mydiv = document.createElement("div"); 
        mydiv.id = "mydiv";

        var str = 
            '<div id="fullbg"></div>' +
            '<div id="dialog" style="height:'+height+'px;width:'+width+'px">' +
                '<div class="title" onmousedown="mouseDown(event)">'+title+'<a href="#" onclick="closeDiv();">关闭</a></div>' +
                '<div class="container">' +
                    '<iframe id="ifdialog" src="' + url + '" frameborder="0" scrolling="auto" style="width:100%; height:100%;"/>' +
                '</div>' +
            '</div>';

        mydiv.innerHTML= str;

        document.body.appendChild(mydiv);
    }

    //显示弹出窗
    showDiv();

	//绑定事件
    document.getElementById("dialog").onmouseout = mouseUp;
    window.onmouseup = mouseUp;
    window.onmousemove = mouseMove;

}


//显示灰色 jQuery 遮罩层 
function showDiv() {
    var height = window.document.body.offsetHeight;
    var width = window.document.body.offsetWidth;

    var fullbg = document.getElementById("fullbg");
    fullbg.style.display = "block";

    var dialog = document.getElementById("dialog");

	var left = (width - parseInt(dialog.style.width))/2;
    dialog.style.left = left;
    dialog.style.top = "20px";

    dialog.style.display = "block";
}


//关闭灰色 jQuery 遮罩 
function closeDiv() {
//	document.getElementById("fullbg").style.display = "none";
//	document.getElementById("dialog").style.display = "none";
	mydiv.parentNode.removeChild(mydiv);
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

      dialog.style.left = left;
      dialog.style.top = top;

  }
}

