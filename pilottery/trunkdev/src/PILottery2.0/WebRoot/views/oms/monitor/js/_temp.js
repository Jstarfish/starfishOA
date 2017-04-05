
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
        setTimeout(function (){
            tipObj.innerHTML="";
        },3000);
        tipObj.className="tip_error";
    }

    return result;
}

//document.write('<script type="text/javascript" src="./js/monitor/regexEnum.js"></script>');



/**------------------------------------------------------------------------------**/


function updateData(dataList,tableId) {
    if(typeof(dataList)=="undefined") {
        return false;
    }

    var tableObj = findObj(tableId);

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
            cell.innerText = obj[cellsMapper[n]];
        }
    }
}



/**------------------------------------------------------------------------------**/
// 清空列表
function clearRow() {
    var objTable = findObj("dataRows");
    var count = objTable.rows.length;

    //alert(objTable.rows.length);
    for (var i = 1; i < count; i++) {
        objTable.deleteRow(1);
    }
}


//添加新的数据行
function addRow(dataList) {

	 if(typeof(dataList)=="undefined") {
	     return false;
	 }
	
	 var tableObj = findObj("dataRows");
	
	 // 根据表头，获得每列id对应的属性名称集合
	 var cellsMapper = new Array();
	 var cells = tableObj.rows[0].cells;
	 for (var i = 0; i < cells.length; i++) {
	     cellsMapper[i] = cells[i].id;
	 }
	
	 // 获得当前表行数
	 var rowCount = tableObj.rows.length;
	
	 for(var i =0; i < dataList.length; i++) {
	     var obj = dataList[i];
	     var newRow = tableObj.insertRow(rowCount++);
	     newRow.className="dataRow";
	
	     for (var n = 0; n < cellsMapper.length; n++) {
	         var cell = newRow.insertCell(n);
	         cell.innerText = obj[cellsMapper[n]];
	     }
	 }

}

// 给数据行添加操作列
function addRowOperate(dataList,htmlStr,params) {

    var tableObj = findObj("dataRows");
    var cellCount = tableObj.rows[0].cells.length;

    for(var i =0; i < dataList.length; i++) {
    	var obj = dataList[i];
    	// 取得最后一列单元格，添加操作html
    	var cell = tableObj.rows[i+1].cells[cellCount-1];
    	cell.className = "xqzi";

    	var tempStr = htmlStr;
    	for(var j = 0;j < params.length; j++) {
    		tempStr = replaceAll(tempStr,"{"+j+"}",obj[params[j]]);
    	}
    	cell.innerHTML = tempStr;
    }

}


/****----------***/

function updateRow(dataList,params) {
    if(typeof(dataList)=="undefined") {
        return false;
    }

    var tableObj = findObj("dataRows");

    // 根据表头，获得table每列的宽度集合,和每列id对应的属性名称集合
    var cellsMapper = new Array();
    var cells = tableObj.rows[0].cells;
    for (var i = 0; i < cells.length; i++) {
        cellsMapper[i] = cells[i].id;
    }

    // 获得当前表行数
    var rowCount = tableObj.rows.length;

    // 返回数据条数比当前数据行少，删除多余row
    if(dataList.length - (rowCount - 1) < 0) {
        for(var i = dataList.length; i < rowCount - 1; i++) {
            tableObj.deleteRow(i);
        }
    // 返回数据条数比当前数据行多，添加新row
    } else {
        for(var i = rowCount - 1; i < dataList.length; i++) {
            var newRow = tableObj.insertRow(rowCount++);
            newRow.className="dataRow";

            for (var n = 0; n < cellsMapper.length; n++) {
                var cell = newRow.insertCell(n);
            }
        }
    }

    var operDiv = findObj("operateDiv");
    var htmlStr = operDiv != null ? operDiv.innerHTML : "";
    var operFlg = htmlStr != "" && typeof(params) != "undefined";

    // 重新设置每个单元格innerText
    for (var i =0; i < dataList.length; i++) {
        var obj = dataList[i];
        var row = tableObj.rows[i+1];
	       
        for (var n = 0; n < cellsMapper.length; n++) {
            var cell = row.cells[n];
            cell.innerText = obj[cellsMapper[n]];
        }

        if(operFlg) {
        	var lastCell = row.cells[row.cells.length-1];

        	var tempStr = htmlStr;
        	for(var j = 0;j < params.length; j++) {//alert(obj[params[i]]);
        		tempStr = replaceAll(tempStr,"{"+j+"}",obj[params[j]]);
        	}
        	lastCell.innerHTML = tempStr;
        	lastCell.className="xqzi";
        }
    }
}

function replaceAll(str,s1,s2){
    while (str.indexOf(s1) != -1) {        
        str = str.replace(s1, s2);        
    }  
	return str;
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
 * field             json属性名称 (对应option的value)
 * text_field        json属性名称 (对应option的text)
 * p_field           json属性名称 (父级的key)
 */

function SelectUtil(parent_id, child_id, jsonArray, field, text_field, p_field) {

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
            child_obj.options.add(new Option("--全部--", 0));

            for(var i=0; i < jsonArray.length; i++) {
                if(value == jsonArray[i][p_field]) {
                    var option = new Option(jsonArray[i][text_field],areaList[i][field]);
                    child_obj.options.add(option);
                }
            }
        }
    };

    parent_obj.onchange = this.casecade;

}


/**--------------------------------------------------------------**/




/**** 添加历史事件eventlist ***/

function addEventRow(dataList) {
	var evenSound = document.getElementById("audio_player"); 
    if(typeof(dataList)=="undefined") {
        return false;
    }

    var tableObj = findObj("dataRows");

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
                evenSound.play();
	            break;
	        case 3:
                newRow.className = "dataRow error";
                evenSound.play();
	            break;
	        case 4:
                newRow.className = "dataRow error";
                evenSound.play();
	            break;
	        default:
	            newRow.className = "dataRow";
	        break;
	    }

        for (var n = 0; n < cellsMapper.length; n++) {
            var cell = newRow.insertCell(n);
            cell.innerText = obj[cellsMapper[n]];
        }

        newRow.cells[4].title = obj["eventContent"];
    }

}
/**--------------------刷新时间----------------------------------**/

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
	timeText.innerText ="刷新时间："+ new Date().format("yyyy-MM-dd hh:mm:ss");
};

/**--------------------刷新网络状态----------------------------------**/

function  network(textStatus){
	var statusHtml = document.getElementById("networkState");
	var networkStateImg = document.getElementById('networkStateImg');
	var imgSrc = networkStateImg.src.substring(0,networkStateImg.src.lastIndexOf('/'));
	if(textStatus=="timeout"){
		networkStateImg.src=imgSrc+'/reconnect.gif';
		statusHtml.innerText="正在获取数据...";
		statusHtml.style.color="green";
	}else if(textStatus=="error"){
		networkStateImg.src=imgSrc+'/disconnect.png';
		statusHtml.innerText="网络已断开！";
		statusHtml.style.color="red";
	}else if(textStatus=="success"){
		networkStateImg.src=imgSrc+'/connect.png';
		statusHtml.innerText='网络已连接！';
		statusHtml.style.color="green";
	}
};

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










