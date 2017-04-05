<%@ page pageEncoding="UTF-8"%>
<script type="text/javascript" charset="UTF-8" >
function SelectUtil(parent_id, child_id, jsonArray, filed, text_filed, p_filed) {

    var parent_obj = findObj(parent_id);
    var child_obj = findObj(child_id);


    this.checkOption = function(id ,value) {
        var selectObj = findObj(id);

        for(var i=0; i < selectObj.options.length; i++) {
            if(selectObj.options[i].value==value) {
                selectObj.options[i].selected = true;
            }
        }
    };

  
    this.casecade = function() {
        var value = parent_obj.value;
        child_obj.options.length = 0;
        if(value != 0){
            child_obj.options.add(new Option("--全部--", 0));
            for(var i=0; i < jsonArray.length; i++) {
                if(value == jsonArray[i][p_filed]) {
                    var option = new Option(jsonArray[i][text_filed],areaList[i][filed]);
                    option.title=jsonArray[i][text_filed];
                    child_obj.options.add(option);
                }
            }
        }
        //兼容专用浏览器,普通浏览器不需要！
        if(value == 0){
        	child_obj.options.add(new Option("", ""));
        }
    };

    parent_obj.onchange = this.casecade;

}

/**------------------------------------------------------**/

function refreshTime(){
	Date.prototype.format = function(format){ 
		var o = { 
		"M+" : this.getMonth()+1, //month 
		"d+" : this.getDate(), //day 
		"h+" : this.getHours(), //hour 
		"m+" : this.getMinutes(), //minute 
		"s+" : this.getSeconds(), //second 
		"q+" : Math.floor((this.getMonth()+3)/3), //quarter 
		"S" : this.getMilliseconds() //millisecond 
		} ;

		if(/(y+)/.test(format)) { 
		format = format.replace(RegExp.$1, (this.getFullYear()+"").substr(4 - RegExp.$1.length)); 
		} 

		for(var k in o) { 
		if(new RegExp("("+ k +")").test(format)) { 
		format = format.replace(RegExp.$1, RegExp.$1.length==1 ? o[k] : ("00"+ o[k]).substr((""+ o[k]).length)); 
		} 
		} 
		return format; 
		} ;
		var timeText =  document.getElementById("refreshTime");
	timeText.innerText ="刷新时间:  "+ new Date().format("yyyy-MM-dd hh:mm:ss");
};

/**-----------------------------------------------------**/

function  network(textStatus){
	var statusHtml = document.getElementById("networkState");
	var reconnectImg = document.getElementById('reconnectImg');
	var disconnectImg = document.getElementById('disconnectImg');
	var connectImg = document.getElementById('connectImg');
	reconnectImg.style.display="none";
	disconnectImg.style.display="none";
	connectImg.style.display="none";
	if(textStatus=="timeout"){
		reconnectImg.style.display="block";
		statusHtml.style.color="green";
	}else if(textStatus=="error"){
		disconnectImg.style.display="block";
		statusHtml.style.color="red";
	}else if(textStatus=="success"){
		connectImg.style.display="block";
		statusHtml.style.color="green";
	}
};

/**----------------------------------------------------------------**/
function getUSDate(){
		dayName = new Array("", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday");
		monName = new Array("January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December");
		now = new Date();
		var nowdate;
		var strDay;
			if ((now.getDate() == 1) || (now.getDate() != 11) && (now.getDate() % 10 == 1)){ 		// Correction for 11th and 1st/21st/31st
				strDay = "st ";
			}else if ((now.getDate() == 2) || (now.getDate() != 12) && (now.getDate() % 10 == 2)){ 	// Correction for 12th and 2nd/22nd/32nd
				strDay = "nd ";
			}else if ((now.getDate() == 3) || (now.getDate() != 13) && (now.getDate() % 10 == 3)){ 	// Correction for 13th and 3rd/23rd/33rd
				strDay = "rd ";
			}else{
				strDay = "th ";
			}
		nowdate=dayName[now.getDay()]+"   "+now.getDate() +"  "+monName[now.getMonth()]+", "+now.getFullYear();
		return nowdate;
		};
		
function getCurrentDate(){
	Date.prototype.format = function(format){ 
		var o = { 
		"M+" : this.getMonth()+1, //month 
		"d+" : this.getDate(), //day 
		"h+" : this.getHours(), //hour 
		"m+" : this.getMinutes(), //minute 
		"s+" : this.getSeconds(), //second 
		"q+" : Math.floor((this.getMonth()+3)/3), //quarter 
		"S" : this.getMilliseconds() //millisecond 
		} ;

		if(/(y+)/.test(format)) { 
		format = format.replace(RegExp.$1, (this.getFullYear()+"").substr(4 - RegExp.$1.length)); 
		} 

		for(var k in o) { 
		if(new RegExp("("+ k +")").test(format)) { 
			format = format.replace(RegExp.$1, RegExp.$1.length==1 ? o[k] : ("00"+ o[k]).substr((""+ o[k]).length)); 
		} 
		} 
		return format; 
		} ;
		if("zh_CN"=="en_US"){
			return getUSDate();
		} else {
			return  new Date().format("yyyy 年 MM 月 dd 日");//yyyy-MM-dd
		}
};


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
                    '<table border="0" cellspacing="0" cellpadding="0" width="100%" height="100%" style="word-break: break-all;">' +
                        '<tr><td width="25%"><div class="question"><div></td><td style="font-size:14px;padding: 0px 50px 0px 10px;">' + msg + '</td></tr>' +
                        '<tr height="60px">' +
                            '<td colspan="2" class="fotter">' +
                                '<input id="ok_button" type="button" onclick="' + func + '" class="my-button" value="&nbsp;&nbsp;&nbsp;&nbsp;确定&nbsp;&nbsp;&nbsp;&nbsp;" style="float:left;margin-left:50px"></input>' +
                                '<input type="button" class="my-button" value="取消" onclick="closeDialog()" style="float:right;margin-right:50px"></input>' +
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
};


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
                    '<table border="0" cellspacing="0" cellpadding="0" width="100%" height="100%" style="word-break: break-all;">' +
                        '<tr><td width="30%"><div class="' + imgSrc + '"></div></td><td style="font-size:14px;padding: 0px 50px 0px 10px;">' + msg + '</td></tr>' +
                        '<tr height="60px">' +
                            '<td colspan="2" class="fotter">' +
                                '<input type="button" onclick="closeMsg();' + okFunc + '" class="my-button" value="确定" style="float:right;margin-right:30px;"></input>' +
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



function showError(errorMsg) {
    showMsg("信息提示","<strong>错误原因: </strong>"+errorMsg,"error");//信息提示  错误原因
};

function showRight() {
    showMsg("信息提示","操作成功","right",'doReload()');
};

function doReload(){
    window.parent.location.reload();
};

function showWarn(warnMsg) {
    showMsg("信息提示",warnMsg,"warn");
};

</script>

