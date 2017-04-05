/**
 * 获得表单元素
 * id: 表单元素id
 */
function findObj(id) {
	var obj = document.getElementById(id);
	return obj;
}

/**
 * 校验函数
 * id: 要验证的表单元素id
 * regex: 正则表达式
 */ 
function doCheck(id,regex,msg) {
    var result;
    var value = findObj(id).value;
    var tipObj = findObj(id+"Tip");

    if(typeof(regex)=="boolean") {
    	result = regex;
    } else {
    	result = regex.test(value);
    }

    if(!result) {
    	tipObj.innerText = msg;
    	tipObj.className="tip_error";
    } else {
    	tipObj.innerText="";
    	tipObj.innerText = "*";
        tipObj.className="tip_init";
    }
    return result;
}




/**
 * 防止按钮重复点击
 * --------------------------------***/
function button_off(btnId) {
	var btnObj = findObj(btnId);
    btnObj.className += " button-wait";
    btnObj.value = "";
    btnObj.onclick = null;
}

function exportPdf() {
    var html = document.documentElement.outerHTML;
    
    var input1 = document.createElement("input");
    input1.type = "hidden";
    input1.name = "htmlStr";
    input1.value = encodeURIComponent(html);

    var form1 = document.createElement("form");
    form1.appendChild(input1);
    //document.body.appendChild(form1);
    form1.action = "export.do";
    form1.method="post";
    form1.submit();

}

/*
 * add by huangchy 
 * 数字千分位格式化
 */
function toThousands(num) {
    return (num || 0).toString().replace(/(\d)(?=(?:\d{3})+$)/g, '$1,');
}

function trim(str){ 
	return str.replace(/(^\s*)|(\s*$)/g, "");
}


/*
 * 用于公共的form中字符串及其长度验证
 * 验证原理：遍历form中的所有元素，符合指定标签的text and textarea 元素进行验证
 * 定义两个扩展标签isCheckSpecialChar=true;cMaxByteLength=10;
 * 如果定义isCheckSpecialChar且true，则校验是否包含特殊char
 * 如果定义cMaxByteLength且true 则按照字符编码校验长度
 */
function checkFormComm(formid)
{
	var resultB = true;
	var xform = findObj(formid);
	if(!isNullObj(xform))
	{
		for (var i = 0; i < xform.elements.length; i++) 
		{
			var tobj = xform.elements[i];
	        if ((!isNullObj(tobj)) && (tobj.type == "text" ||tobj.type == "textarea")) {
	            
	        	if(!ckIsTextContainSpeChars(tobj))
	        	{
	        		 resultB = false;
	        		 //考虑break提高效率
					 continue;
	        	}
	        	if(!isLenThanMaxByteLen(tobj))
	        	{
	        		 resultB = false;
	        		 //考虑break提高效率
	        	}
	        }
	    }
	}
	
	return resultB;
}

/*
 * 检测长度
 */
function isLenThanMaxByteLen(objc)
{
	var resultBL = true;
	if(!isNullObj(objc))
	{
		var dobj = objc.getAttribute("cMaxByteLength");
		if(!isNullObj(dobj))
    	{
			var csid = objc.id;
			var cstext = objc.value;
			var cslen = dobj;
			var tipObj = findObj(csid+"Tip");
			tipObj.innerText = '';
	    	tipObj.className="tip_init";
			
    		if((!isNullObj(csid)) && (!isNullAndEmpty(cstext)) && cslen >0)
    		{
    			if(cstext.getCBytesLength() > cslen)
    			{
    				ckSetFormOjbErrMsg(csid,"Exceeds length limit.");
    				resultBL = false;
    			}
    		}	        		
    	}    	
	}	
	return resultBL;
}

/*
 * 检查是否含有特殊字符串
 */
function ckIsTextContainSpeChars(objc)
{
	var resultBL = true;
	if(!isNullObj(objc))
	{
		var dobj = objc.getAttribute("isCheckSpecialChar");
		if(!isNullObj(dobj))
    	{
			var csid = objc.id;
			var cstext = objc.value;
			
			var tipObj = findObj(csid+"Tip");
			tipObj.innerText = '';
	    	tipObj.className="tip_init";
	    	
			var regx = new  RegExp("[`~#$^&*|<>/……（）—|‘”“']");
    		if((!isNullObj(csid)) && (!isNullAndEmpty(cstext)))
    		{
    			if(regx.test(cstext))
    			{
    				ckSetFormOjbErrMsg(csid,"Illegal characters detected.");
    				resultBL = false;
    			}
    		}	        		
    	}    	
	}	
	return resultBL;
}

/*
 * 设置显示错误信息
 */
function ckSetFormOjbErrMsg(sid,smsg)
{
	if((!isNullObj(sid)) && (!isNullObj(smsg)))
	{
		var tipObj = findObj(sid+"Tip");
		
		if(!isNullObj(tipObj))
		{
			tipObj.innerText = smsg;
	    	tipObj.className="tip_error";
		}
	}
}

/*
 * 判断对象是否为空
 * add by dzg
 */
function isNullObj(obj)
{
	if(typeof(obj)== "undefined" || obj == null)
		return true;
	return false;
}

function isNullAndEmpty(obj)
{
	if(typeof(obj)== "undefined" || obj == null)
		return true;
	
	return (trim(obj).length <= 0);
}
/*
 * 获取unicode字符的字节长度
 * add by dzg 
 * 主要用于非asc的中文及其柬埔寨文字符集长度判断
 * C = Combodia and China + English
 */
String.prototype.getCBytesLength = function() {   
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
};

function checkSpecialChars(objId){
	var obj = document.getElementById(objId);
	if(obj){
		var cstext = obj.value;
		var regx = new  RegExp("[`~$^<>/#……*（）&—|‘”“']");
		if(regx.test(cstext)) {
			return false;
		}
	}
	return true;
}

function checkMaxLength(objId){
	var obj = document.getElementById(objId);
	if(obj){
		var cstext = obj.value;
		var maxLength = obj.getAttribute("cMaxByteLength");
		
		if(cstext.getCBytesLength() > maxLength){
			return false;
		}
	}
	return true;
}


