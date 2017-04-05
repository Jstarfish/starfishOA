/***
 * 
 */


/***
 * 
function MM_swapImgRestore() { //v3.0
    var i,x,a=document.MM_sr;
    for(i=0;a&&i<a.length&&(x=a[i])&&x.oSrc;i++)
       x.src=x.oSrc;
}

function MM_findObj(n, d) { //v4.01
    var p,i,x;
    if(!d) d=document;
    if((p=n.indexOf("?"))>0&&parent.frames.length) {
        d=parent.frames[n.substring(p+1)].document;
        n=n.substring(0,p);
    }
    if(!(x=d[n])&&d.all) x=d.all[n];
    for (i=0;!x&&i<d.forms.length;i++)
        x=d.forms[i][n];
    for(i=0;!x&&d.layers&&i<d.layers.length;i++)
        x=MM_findObj(n,d.layers[i].document);
    if(!x && d.getElementById)
        x=d.getElementById(n);

    return x;
}

function MM_swapImage() { //v3.0
   var i,j=0,x,a=MM_swapImage.arguments;
   document.MM_sr=new Array;
   for(i=0;i<(a.length-2);i+=3)
      if ((x=MM_findObj(a[i]))!=null) {
         document.MM_sr[j++]=x;
         if(!x.oSrc) x.oSrc=x.src;
         x.src=a[i+2];
      }
}
*/

/*** -------------------------     -------------------------*/

/**
 * 设置图片透明度
 */
function visible(cursor,i){
    var n=i>0?20:50;
    if (-[1,]){
        cursor.style.opacity=20/n;
    }else{
        cursor.filters.alpha.opacity=n;
    }
}

/**
 * 切换图片
 * id: 表单元素id
 * src: 图片的路径
 */
function MM_swapImage(id,src) {
	findObj(id).src = src;
}

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
    	tipObj.innerText = "*";
        tipObj.className="tip_init";
    }
    return result;
}

function switch_obj(btnId1, btnId2) {
	var btnObj1 = findObj(btnId1);
	btnObj1.style.display = "none";
	var btnObj2 = findObj(btnId2);
	btnObj2.style.display = "inline";
}
