//对Date的扩展，将 Date 转化为指定格式的String
//月(M)、日(d)、小时(h)、分(m)、秒(s)、季度(q) 可以用 1-2 个占位符， 
//年(y)可以用 1-4 个占位符，毫秒(S)只能用 1 个占位符(是 1-3 位的数字) 
//例子： 
//(new Date()).format("yyyy-MM-dd hh:mm:ss.S") ==> 2006-07-02 08:09:04.423 
//(new Date()).format("yyyy-M-d h:m:s.S")      ==> 2006-7-2 8:9:4.18 
Date.prototype.format = function (fmt) { //author: meizz 
 var o = {
     "M+": this.getMonth() + 1, //月份 
     "d+": this.getDate(), //日 
     "h+": this.getHours(), //小时 
     "m+": this.getMinutes(), //分 
     "s+": this.getSeconds(), //秒 
     "q+": Math.floor((this.getMonth() + 3) / 3), //季度 
     "S": this.getMilliseconds() //毫秒 
 };
 if (/(y+)/.test(fmt)) fmt = fmt.replace(RegExp.$1, (this.getFullYear() + "").substr(4 - RegExp.$1.length));
 for (var k in o)
 if (new RegExp("(" + k + ")").test(fmt)) fmt = fmt.replace(RegExp.$1, (RegExp.$1.length == 1) ? (o[k]) : (("00" + o[k]).substr(("" + o[k]).length)));
 return fmt;
}

/**  
 * 数字格式转换成千分位  
 *@param{Object}num  
 */  
function toThousand(num) {   
// 1.先去除空格,判断是否空值和非数
	num = num + "";   
	num = num.replace(/[ ]/g, ""); // 去除空格
    if (num == "") {   
    	return;   
    }   
    if (isNaN(num)){  
    	return;   
    }   
    // 2.针对是否有小数点，分情况处理
    var index = num.indexOf(".");   
    if (index==-1) {// 无小数点
      var reg = /(-?\d+)(\d{3})/;   
        while (reg.test(num)) {   
        	num = num.replace(reg, "$1,$2");   
        }   
    } else {   
        var intPart = num.substring(0, index);   
        var pointPart = num.substring(index + 1, num.length);   
        var reg = /(-?\d+)(\d{3})/;   
        while (reg.test(intPart)) {   
        	intPart = intPart.replace(reg, "$1,$2");   
        }   
       num = intPart +"."+ pointPart;   
    }   
return num;   
}   
  
/**
 * 去除千分位
 * 
 * @param{Object}num
 */  
function cancelTousand(num){  
   num = num.replace(/[ ]/g, "");// 去除空格
   num=num.replace(/,/gi,'');  
   return num;  
} 


//jquery validate验证控件扩展
$.validator.setDefaults({
    highlight: function (element) {
        $(element).closest('.form-group').removeClass('has-success').addClass('has-error');
    },
    success: function (element) {
        element.closest('.form-group').removeClass('has-error').addClass('has-success');
    },
    errorElement: "span",
    errorPlacement: function (error, element) {
        if (element.is(":radio") || element.is(":checkbox")) {
            error.appendTo(element.parent().parent().parent());
        } else {
            error.appendTo(element.parent());
        }
    },
    errorClass: "help-block m-b-none",
    validClass: "help-block m-b-none"
});

$.validator.addMethod(
	 "notEqualTo", //验证方法名称
	 function(value, element, param) {//验证规则
         return this.optional(element) || $(param) != value;
	 }, 
	 '不能和原密码相同'//验证提示信息
);
