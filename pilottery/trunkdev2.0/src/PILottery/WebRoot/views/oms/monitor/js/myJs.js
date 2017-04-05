
/***
 * myJs.js
 * author:heqiang
 */

/**--------------------------------------------------------------*/

/**
 * 获得表单元素
 * id: 表单元素id
 */
function findObj(id) {
    var obj = document.getElementById(id);
    return obj;
}

/**-----------------------**/

/**
 * 校验函数
 * id: 要验证的表单元素id
 * regex: 正则表达式
 */
function doCheck(id,regex,msg) {
    var result = false;
    var value = findObj(id).value;
    var tipObj = findObj(id+"Tip");

    if(typeof(regex)=="boolean") {
        result = regex;
    } else {
        result = regex.test(value);
    }

    if(!result) {
        tipObj.innerHTML = msg;
        tipObj.className="tip_error";
    } else {
    	tipObj.innerText = "";
        tipObj.className="tip_init";
    }

    return result;
}

//document.write('<script type="text/javascript" src="./js/monitor/regexEnum.js"></script>');


/**------------------------------------------------------------------------------**/

var operHtml = "";
function updateRow(tableObj,dataList,params) {
	
	if(dataList == null) {
		return;
	}

    // 根据表头，获得table每列的宽度集合,和每列id对应的属性名称集合
    var cellsMapper = new Array();
    var cells = tableObj.rows[0].cells;
    for (var i = 0; i < cells.length; i++) {
        cellsMapper[i] = cells[i].id;
    }

    // 获得当前表行数
    var rowCount = tableObj.rows.length;

    // 重新设置每个单元格innerText
    for (var i =0; i < dataList.length; i++) {
        var obj = dataList[i];
        var row = tableObj.rows[i];

        for (var n = 0; n < cellsMapper.length; n++) {
            var cell = row.cells[n];
            if(cellsMapper[n] != "") {
            	cell.innerText = typeof(obj[cellsMapper[n]]) == "undefined" ? "" : obj[cellsMapper[n]];
            	//添加title
            	cell.title=typeof(obj[cellsMapper[n]]) == "undefined" ? "" : obj[cellsMapper[n]];
            }
        }

        // 更新操作列的内容
        if (params != null) {
        	var lastCell = row.cells[row.cells.length-1];
        	operHtml = operHtml == "" ? lastCell.innerHTML : operHtml;
            var tempStr = operHtml;
            for(var j = 0;j < params.length; j++) {
            	tempStr = replaceAll(tempStr,"{"+j+"}",obj[params[j]]);
            	
            	tempStr = hiddenPlaceholder(tempStr);
            }
            lastCell.innerHTML = tempStr;
        }
    }
};

//网络延迟隐藏占位符
function hiddenPlaceholder(tempStr){
	tempStr = replaceAll(tempStr,'style="display: none;"',"");
	return tempStr;
};
// 替换操作列参数占位符
function replaceAll(str,s1,s2){
    while (str.indexOf(s1) != -1) {        
        str = str.replace(s1, s2);        
    }
	return str;
}


function num_format(num){
    var str = num.toString();
    var num = str.split(".");
    num[0] = num[0]==null?"":num[0];
    num[1] = num[1]==null?"":num[1];
    var arr = num[0].split("");
    var temp = "";
    var index = 0;
    for (var i = arr.length - 1; i >= 0; i--) {
    if (index % 3 == 0 && index != 0) {
        temp = arr[i] + "," + temp;
    } else {
        temp = arr[i] + temp;
    }
    ++index;
    }
    if(num[1]!="") {
        temp = temp + "." + num[1];
    }
    return temp;
}

/**--------------------------------------------------------------------------------------**/
// 下拉框级联

/***
// js 面向对象
function Person(){
    //这里定义了一个属性后，创建对象时将自动赋值给新对象
    this.name='test';
    //如果这样使用，则表示该属性是私有的
    var age = 90;
    //下面使用this，表示这是Person类的一个公开方法，可以访问私有方法
    this.show=function(){
        window.alert(age+''+name);
    }
    //这里表示是Person的一个私有的方法
    function show2(){
    }
}
*/


/***
 * 下拉框级联函数
 * SelectUtil(p_id, sub_id, list, key, value, p_key)
 * 
 * parent_id         父下拉框id
 * child_id          子下拉框id
 * jsonArray         json对象列表
 * filed             json属性名称 (对应option的value)
 * text_filed        json属性名称 (对应option的text)
 * p_filed           json属性名称 (父级的key)
 */

/*function SelectUtil(parent_id, child_id, jsonArray, filed, text_filed, p_filed) {

    var parent_obj = findObj(parent_id);
    var child_obj = findObj(child_id);

    // 下拉框选中
    this.checkOption = function(id ,value) {
        var selectObj = findObj(id);

        for(var i=0; i < selectObj.options.length; i++) {
            if(selectObj.options[i].value==value) {
                selectObj.options[i].selected = true;
            }
        }
    };

    // 根据选中的值，初始化下级下拉框
    this.casecade = function() {
        var value = parent_obj.value;
        child_obj.options.length = 0;

        if(value != 0){
            child_obj.options.add(new Option("--<spring:message code='myJs.js.code1'/>--", 0));//全部

            for(var i=0; i < jsonArray.length; i++) {
                if(value == jsonArray[i][p_filed]) {
                    var option = new Option(jsonArray[i][text_filed],areaList[i][filed]);
                    child_obj.options.add(option);
                }
            }
        }
    };

    parent_obj.onchange = this.casecade;

}*/


/**--------------------------------------------------------------**/




/**** 添加历史事件eventlist ***/

function addEventRow(dataList) {

    if(typeof(dataList)=="undefined") {
        return false;
    }

    var tableObj = findObj("dataRows");

    if(tableObj.rows.length>200) {
    	for(var i = 200; i < tableObj.rows.length;i++) {
    		tableObj.deleteRow(i);
    	}
    }

    // 根据表头，获得table每列的宽度集合,和每列id对应的属性名称集合
    var cellsMapper = new Array();
    var cells = tableObj.rows[0].cells;
    for (var i = 0; i < cells.length; i++) {
        cellsMapper[i] = cells[i].id;
    }

    // 事件级别（1=信息；2=警告；3=错误；4=致命）对应的 css
    for (var i =0; i < dataList.length; i++) {
        var obj = dataList[i];
        var newRow = tableObj.insertRow(1);

        switch(obj["eventLevel"]) {
	        case 2:
                newRow.className = "dataRow warn";
                findObj("audio1").play();
	            break;
	        case 3:
                newRow.className = "dataRow error";
                findObj("audio2").play();
	            break;
	        case 4:
                newRow.className = "dataRow error";
                findObj("audio3").play();
	            break;
	        default:
	            newRow.className = "dataRow";
	        break;
	    }

        for (var n = 0; n < cellsMapper.length; n++) {
            var cell = newRow.insertCell(n);
            cell.innerText = obj[cellsMapper[n]];
            cell.title=typeof(obj[cellsMapper[n]]) == "undefined" ? "" : obj[cellsMapper[n]];
        }

        newRow.cells[4].title = obj["eventContent"];
    }

}
/**--------------------销售站排行----------------------------------**/
function updateAgencyRow(tableObj,dataList) {

    // 根据表头，获得table每列的宽度集合,和每列id对应的属性名称集合
    var cellsMapper = new Array();
    var cells = tableObj.rows[0].cells;
    for (var i = 0; i < cells.length; i++) {
        cellsMapper[i] = cells[i].id;
    }

    // 获得当前表行数
    var rowCount = tableObj.rows.length;

    // 重新设置每个单元格innerText
    for (var i =0; i < dataList.length; i++) {
        var obj = dataList[i];
        var row = tableObj.rows[i+1];

        for (var n = 0; n < cellsMapper.length; n++) {
            if(cellsMapper[n]=="cellNumber"){
            	 var cell = row.cells[n];  //为销售站排行增加序列号
        		cell.innerText=i+1;
        	}else{
        		 var cell = row.cells[n];
        		cell.innerText = obj[cellsMapper[n]];
            	cell.title=typeof(obj[cellsMapper[n]]) == "undefined" ? "" : obj[cellsMapper[n]];
        	}
        }
    }
};
/*-----------------------------------销售站列表数据-------------------------------------------*/
function updateAgencyListRow(tableObj,dataList,params) {

    // 根据表头，获得table每列的宽度集合,和每列id对应的属性名称集合
	var cellsMapper = new Array();
    var cells = tableObj.rows[0].cells;
    for (var i = 0; i < cells.length; i++) {
        cellsMapper[i] = cells[i].id;
    }

    // 获得当前表行数
    var rowCount = tableObj.rows.length;

    // 重新设置每个单元格innerText
    for (var i =0; i < dataList.length; i++) {
        var obj = dataList[i];
        var row = tableObj.rows[i+1];

        for (var n = 0; n < cellsMapper.length; n++) {
            var cell = row.cells[n];
            if(cellsMapper[n] != "") {
            	cell.innerText = typeof(obj[cellsMapper[n]]) == "undefined" ? "" : obj[cellsMapper[n]];
            	//添加title
            	cell.title=typeof(obj[cellsMapper[n]]) == "undefined" ? "" : obj[cellsMapper[n]];
            }
        }

        // 更新操作列的内容
        if (params != null && obj.agencyType != 4) {
        	var lastCell = row.cells[row.cells.length-1];
        	operHtml = operHtml == "" ? lastCell.innerHTML : operHtml;
            var tempStr = operHtml;alert(operHtml);
            for(var j = 0;j < params.length; j++) {
            	tempStr = replaceAll(tempStr,"{"+j+"}",obj[params[j]]);
            	
            	tempStr = hiddenPlaceholder(tempStr);
            }
            lastCell.innerHTML = tempStr;
        }
    }
};

/**--------------------刷新时间----------------------------------**/

/*function refreshTime(){
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
	timeText.innerText ="<spring:message code='myJs.js.code2'/>："+ new Date().format("yyyy-MM-dd hh:mm:ss");//刷新时间
};*/

/**--------------------刷新网络状态----------------------------------**/

/*function  network(textStatus){
	var statusHtml = document.getElementById("networkState");
	var reconnectImg = document.getElementById('reconnectImg');
	var disconnectImg = document.getElementById('disconnectImg');
	var connectImg = document.getElementById('connectImg');
	reconnectImg.style.display="none";
	disconnectImg.style.display="none";
	connectImg.style.display="none";
	if(textStatus=="timeout"){
		reconnectImg.style.display="block";
		statusHtml.innerText="<spring:message code='myJs.js.code3'/>...";//正在获取数据
		statusHtml.style.color="green";
	}else if(textStatus=="error"){
		disconnectImg.style.display="block";
		statusHtml.innerText="<spring:message code='myJs.js.code4'/>！";//网络已断开
		statusHtml.style.color="red";
	}else if(textStatus=="success"){
		connectImg.style.display="block";
		statusHtml.innerText="<spring:message code='myJs.js.code5'/>！";//网络已连接
		statusHtml.style.color="green";
	}
};*/

/*--------------------------------- 期次状态为不可操作---------------------------------------*/
function issueStatus(obj,params){
	if(params[0]=='issueNumber'){
		if(obj.issueStatus!='13'){
//			/alert(obj.issueStatus);
			document.getElementById('issueOperate').style.color="grey";
			document.getElementById('issueOperate').removeAttribute("onclick");
			document.getElementById('issueOperate').removeAttribute("href");
		}
	}
};

function tellerCheckOut(){
	
	document.getElementById('tellerCheckOut').style.color="grey";
	document.getElementById('tellerCheckOut').removeAttribute("onclick");
	document.getElementById('tellerCheckOut').removeAttribute("href");
};
/*--------------------------------- 解析url字符串---------------------------------------*/
function getUrlParam(url,name){  
    var pattern = new RegExp("[?&]"+name+"\=([^&]+)", "g");  
    var matcher = pattern.exec(url);  
    var items = null;  
    if(null != matcher){  
            try{  
                   items = decodeURIComponent(decodeURIComponent(matcher[1]));  
            }catch(e){  
                    try{  
                            items = decodeURIComponent(matcher[1]);  
                    }catch(e){  
                            items = matcher[1];  
                    }  
            }  
    }  
    return items;  
}; 

/*--------------------------------- 列表操作项---------------------------------------*/

function listOperation(url){
	
	
	
};

/*--------------------------------- 终端机汇总信息---------------------------------------*/

function  terminalSum(){
	var connectedCountText = document.getElementById("connectedCount");
	var noConnectedCountText = document.getElementById("noConnectedCount");
	var checkedCountText = document.getElementById("checkedCount");
	var areaText = document.getElementById("areaName");
	$.ajax({
        async:true,
        type: 'get',
        url: "terminal.do?method=ajaxTerminalSumm",
        timeout: 5000,
        dataType: "json",
        error: function(XMLHttpRequest,textStatus,errorThrown) {
            // alert("请求超时！");
            return "error";
        },
        success: function (result) {
        	var terminal = result;
        	areaText.innerText= ""+terminal.areaText;
        	connectedCountText.innerText= ""+terminal.connectedCount;
        	noConnectedCountText.innerText= ""+terminal.noConnectedCount;
        	checkedCountText.innerText= ""+terminal.checkedCount;
        }
    });
}

/*--------------------------------- 游戏销量x轴---------------------------------------*/

function xValue(){
	var xTime = ['08:00','08:10','08:20','08:30','08:40','08:50',
	        	 '09:00','09:10','09:20','09:30','09:40','09:50',
	        	 '10:00','10:10','10:20','10:30','10:40','10:50',
	        	 '11:00','11:10','11:20','11:30','11:40','11:50',
	        	 '12:00','12:10','12:20','12:30','12:40','12:50',
	        	 '13:00','13:10','13:20','13:30','13:40','13:50',
	        	 '14:00','14:10','14:20','14:30','14:40','14:50',
	        	 '15:00','15:10','15:20','15:30','15:40','15:50',
	        	 '16:00','16:10','16:20','16:30','16:40','16:50',
	        	 '17:00','17:10','17:20','17:30','17:40','17:50',
	        	 '18:00','18:10','18:20','18:30','18:40','18:50',
	        	 '19:00','19:10','19:20','19:30','19:40','19:50',
	        	 '20:00','20:10','20:20','20:30','20:40','20:50',
	        	 '21:00','21:10','21:20','21:30','21:40','21:50',
	        	 '22:00'];
	return xTime;
};
