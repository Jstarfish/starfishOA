//解析石家庄一厂保安区代码
//该函数基于jquery
// add by dzg
// 2015-12-14
//-------------返回对象属性说明-------------
//1、planCode 方案号
//2、batchCode 批次号
//3、ticketNum 总票数==都是1
//4、amount 单票销售额==单位瑞尔
//5、groupCode 奖组
//6、firstPkgCode 所属本号
//7、ticketCode 票号
//8、safetyCode 保安区码
//9、paySign 兑奖标识码



SJZPrinterForSC = function() {
	
	var safetyLen = 41;// 保安区码长度
	var transCode = "";// 当前物流码

	var planCode = "";// 方案编码
	var planName ="";// 方案名称
	var batchCode = ""; //批次号码
	var amountPerTicket = 0;// 单票金额
	var tnperpack =0;//每包多少票用于计算奖组
	var firstTrunkCodeOfBatch = 1;// 批次首箱号
	var totalTicketNumOfGroup = 0;// 奖组总票数
	var firstPackCodeOfBatch = 1;// 批次首本数，用于根据本号获取顺序存放的箱号
	var planList;//方案信息json
	
	var objList;//将用数组存储对象，用于检测重复

	

	// ----------------------标签定义
	// 41位，产品编号+产品批次+本批本号+票号+保安码+快速兑奖标识（5位+5位+7位+3位+16位+5位）
	// J2015 00002 0013842 184 DKTSANFUBVYUNAOR AG016
	// -------------------------------
	
	// 获取方案编号
	var planCodePos = 0;
	var planCodeLen = 5;

	// 获取批次
	var batchCodePos = 5;
	var batchCodeLen = 5;

	// 获取本号
	var pkgCodeOfSafetyPos = 5 + 5;
	var pkgCodeOfSafetyLen = 7;

	// 获取票号
	var ticketCodeOfSafetyPos = 5 + 5 + 7;
	var ticketCodeOfSafetyLen = 3;

	// 获取保安码
	var safetyCodeOfSafetyPos = 5 + 5 + 7 + 3;
	var safetyCodeOfSafetyLen = 16;
	
	// 获取兑奖标志
	var paySignOfSafetyPos = 5 + 5 + 7 + 3 + 16;
	var paySignOfSafetyLen = 5;

	//初始化：方案号、方案名称、批次号、单票金额、奖组总票数
	function initInfo(pCode,pName, bCode, aPerTicket, tTicketNumOfGroup) {
		planCode = pCode;
		batchCode = bCode;
		planName = pName;
		amountPerTicket = aPerTicket;
		firstTrunkCodeOfBatch = 1;
		totalTicketNumOfGroup = tTicketNumOfGroup;
		firstPackCodeOfBatch = 1;

	}
	
	
	/*
	 * 新增用于批量导入之外的任意方案，任意批次的初始化
	 */
	function initInfoForPlans(plist)
	{
		planList= plist;
	}
	
	/*
	 * 解码 
	 */
	function getPackInfo(tCode) {
		
		//用于前面的验证及其返回
		fpi = new Object();			
		transCode = handleString(tCode);
		if (isNullObj(transCode) || transCode.length == 0)
		{
			fpi.errCode = 1;
			fpi.errMessage ="请扫描条形码！";
			return fpi;
		}
		

		var len = transCode.length;
		if(len == safetyLen)
		{
		}else{
			fpi.errCode = 1;
			fpi.errMessage ="条形码不符合规范！";
			return fpi;
		}
		
		//检测方案和批次
		// 获取方案
		
		var vpcode = transCode.substring(planCodePos, planCodePos + planCodeLen);
		var vbcode = transCode.substring(batchCodePos, batchCodePos + batchCodeLen);
		var batchinfo =getBatchInfo(vpcode,vbcode);
		if(batchinfo == null)
		{
			fpi.errCode = 1;
			fpi.errMessage ="批次无效 ！";
			return fpi;
		}

		amountPerTicket = parseInt(batchinfo.amount);// 单票金额
		totalTicketNumOfGroup = parseInt(batchinfo.ticketsEveryGroup);// 奖组总票数
		//tnperpack = parseInt(batchinfo.ticketsEveryGroup);// 每本多少票

		var objRet = getSafetyCodeInfo();
		
		//返回方案名称
		if(objRet != null)
		{
			if(putObject(objRet) >0)
			{
				objRet.errCode =1;
				objRet.errMessage ="条形码已经存在,请尝试另一个！";
				return objRet;
			}
			objRet.errCode =0;
			objRet.planName = batchinfo.planName;
			objRet.amount = amountPerTicket;
		}

		return objRet;
	}

	

	/*
	 * 获取票本标签内容
	 */
	function getSafetyCodeInfo() {

		pi = new Object();
		pi.ticketNum = 1;
		pi.packUnitValue = 4;

		// 临时变量
		var tmpStr = "";
		var tmpInt = 0;

		// 获取方案
		tmpStr = "";
		tmpStr = transCode.substring(planCodePos, planCodePos + planCodeLen);
		pi.planCode = tmpStr;

		// 获取批次
		tmpStr = "";
		tmpStr = transCode.substring(batchCodePos, batchCodePos + batchCodeLen);
		pi.batchCode = tmpStr;

		// 本号
		tmpStr = "";
		tmpStr = transCode.substring(pkgCodeOfSafetyPos, pkgCodeOfSafetyPos
				+ pkgCodeOfSafetyLen);
		pi.firstPkgCode = tmpStr;
		
		// 票号
		tmpStr = "";
		tmpStr = transCode.substring(ticketCodeOfSafetyPos, ticketCodeOfSafetyPos
				+ ticketCodeOfSafetyLen);
		pi.ticketCode = tmpStr;
		
		
		// 保安区码
		tmpStr = "";
		tmpStr = transCode.substring(safetyCodeOfSafetyPos, safetyCodeOfSafetyPos
				+ safetyCodeOfSafetyLen);
		pi.safetyCode = tmpStr;
		
		// 兑奖标识码
		tmpStr = "";
		tmpStr = transCode.substring(paySignOfSafetyPos, paySignOfSafetyPos
				+ paySignOfSafetyLen);
		pi.paySign = tmpStr;


		//计算奖组
		tmpInt = 0;		
		tmpInt = Math.floor((parseInt(pi.firstPkgCode) * tnperpack)
				/ totalTicketNumOfGroup);
		
		var tceil =Math.floor((parseInt(pi.firstPkgCode) * tnperpack)
				% totalTicketNumOfGroup);
		if (tceil != 0)
		{
			tmpInt = tmpInt + 1;
		}
		
		pi.groupCode = FormatNum(tmpInt+'',2);

		
		pi.amount = pi.ticketNum * amountPerTicket;
		return pi;
	}

	// 内部函数用于，判断是对象是否为空
	function isNullObj(obj) {
		if (typeof (obj) == "undefined" || obj == null)
			return true;
		return false;
	}
	
	// 格式化数字，前补0
	function FormatNum(Source,Length){ 
		var strTemp=""; 
		for(i=1;i<=Length-Source.length;i++){ 
			strTemp+="0"; 
		} 
		return strTemp+Source; 
	} 
	
	/*
	 * 根据方案及其批次号，获取当前批次的信息
	 */
	function getBatchInfo(gpcode,gbcode)
	{
		if(planList==null || planList.length <=0)
			return null;
		
		for(var i=0; i<planList.length; i++)  
		{  
		     if(planList[i].batchNo ==gbcode && planList[i].planCode==gpcode )
	    	 {
		    	 return planList[i];
	    	 }
		} 
	}
	
	/*
     * 把对象存入缓存，存入之前需要检测重复
	 * 0 正常 1 重复 2 其他系统异常
	 */
	function putObject(objin)
	{
		if(objin == null)
			return 0;
		if(objList == null || objList.length  <= 0)
			objList = new Array();
		var keyin = objin.planCode+''+objin.batchCode + ''+objin.firstPkgCode+ ''+objin.ticketCode;
		if(findObject(keyin) >= 0)
		{
			return 1;
		}else
		{
			objList.push(keyin);
			return 0;
		}		
	}
	
	/*
     * 把对象存入缓存，存入之前需要检测重复检测
	 * 返回包含对象的索引，默认-1
	 */
	function findObject(key)
	{
		var result = (-1);
		if(key != null && objList != null && objList.length > 0)
		{
			for( var i = 0; i < objList.length; i++ ) 
			{ 
				if( objList[i] == key ) 
				{ 
					result = i; 
					break; 
				} 
			} 
		}
		return result; 
	}

	/*
     * 移除对象
	 * key = 方案+批次+标号（箱盒本）
	 */
	function removeObject(dkey)
	{
		var dkindex = findObject(dkey);
		if(dkindex > 0)
		{
			 var part1 = objList.slice( 0, dkindex); 
			 var part2 = objList.slice( dkindex+1 );
			objList = part1.concat( part2 );
		}else if(dkindex ==0){
			objList.shift();
		}
		
	}
	
	/*
     * 清空缓存对象
	 */
	function clearObjects()
	{
		if(objList != null && objList.length > 0)
		{
			for( var i = 0; i < objList.length; i++ ) 
			{ 
				objList.shift();
			} 
			objList = null;
		}
	}
	
	/*
     * 处理输入的字符串对象，去掉前面的特殊字符
	 */
	function handleString(strin)
	{
		var strv= strin;
		if(strv != null && strv.length > 0)
		{					 
			 while(strv.length >0)
			 {
				var kv = strv.charCodeAt(0);
				if(kv < 48 || kv >112 )
					strv = strv.slice(1);
				else
					break;					
			 }
		}
		return strv;
	}
	
	return {
		getPackInfo : getPackInfo,
		initInfoForPlans:initInfoForPlans,
		removeObject : removeObject,
		clearObjects : clearObjects
	}
}();
