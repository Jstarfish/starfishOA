//解析石家庄一厂物流代码
//该函数基于jquery
// add by dzg
// 2015-9-14
//-------------返回对象属性说明-------------
//1、planCode 方案号
//2、batchCode 批次号
//3、packUnit 包装单位箱盒本字符串
//4、packUnitValue 包装单位值 1,2,3
//5、packUnitCode 包装单位编码  箱则箱号，盒则盒号，本则本号
//6、ticketNum 总票数
//7、amount 总金额
//8、groupCode 奖组
//9、firstPkgCode 包装首本，本则当前本号

//modify by dzg 2015-9-17
//支持多个方案 

//modify by dzg 2015-10-14
//增加缓存，支持同一次连续入库的重复检测
//缓存将使用array存储：方案-批次-标号（箱盒本）


SJZPrinter = function() {
	var trunkLen = 63;// 箱签长度
	var boxLen = 33;// 盒签长度
	var ticketLen = 29;// 票长度
	var transCode = "";// 当前物流码

	var planCode = "";// 方案编码
	var planName ="";// 方案名称
	var batchCode = ""; //批次号码
	var amountPerTicket = 0;// 单票金额
	var firstTrunkCodeOfBatch = 1;// 批次首箱号
	var totalTicketNumOfGroup = 0;// 奖组总票数
	var firstPackCodeOfBatch = 1;// 批次首本数，用于根据本号获取顺序存放的箱号
	var planList;//方案信息json
	
	var objList;//将用数组存储对象，用于检测重复

	// ----------------------箱子包装定义
	// 63位，箱号编码的规则包含产品编码、生产批次、箱起号和箱止号。
	// 方案5 + 批次5 +箱号5+每箱本数3+每本张数3+分组号4+4组箱数+分组首箱号5+6生产批号+6出厂时间+7本箱首本号+ 4重量+6备用
	// J0001 14901 09600 040 025 1011 0800 08801 002800 150614 0383961 13.5
	// guardz
	// -------------------------------

	// 获取方案编号
	var planCodePos = 0;
	var planCodeLen = 5;

	// 获取批次
	var batchCodePos = 5;
	var batchCodeLen = 5;

	// 获取箱子编号
	var boxCodePos = 5 + 5;
	var boxCodeLen = 5;

	// 获取每箱本数
	var packNumPerBoxPos = 5 + 5 + 5;
	var packNumPerBoxLen = 3;

	// 获取每本张数
	var ticketNumPerPackPos = 5 + 5 + 5 + 3;
	var ticketNumPerPackLen = 3;

	// 如下为了计算奖组
	// 每组箱数
	var trunkNumPerGroupPos = 5 + 5 + 5 + 3 + 3 + 4;
	var trunkNumPerGroupLen = 4;
	// 每组首箱
	var firstTrunkPerGroupPos = 5 + 5 + 5 + 3 + 3 + 4 + 4;
	var firstTrunkPerGroupLen = 5;

	// 每箱首本号
	var firstPkgOfTrunkPos = 5 + 5 + 5 + 3 + 3 + 4 + 4 + 5 + 6 + 6;
	var firstPkgOfTrunkLen = 7;

	// ----------------------盒子包装定义
	// 33位，产品编码+生产批次+每箱盒数+每箱本数+每本张数+本号起号+本号止号（5位+5位+3位+3位+3位+7位+7位）
	// J2015 00002 005 100 100 0000021 0000040
	// 计算盒号格式：箱号 xxxxx- 盒号xx
	// 箱号=起始本/每箱本数
	// 盒号=起始本 mod 每箱本数 /每箱盒数
	// -------------------------------

	// 每箱盒数
	var boxNumPerTrunkPos = 5 + 5;
	var boxNumPerTrunkLen = 3;
	
	// 获取每箱本数
	var packNumPerBTrunkPos = 5 + 5 + 3;
	var packNumPerBTrunkLen = 3;


	// 本号起号
	var boxStartPackCodePos = 5 + 5 + 3 + 3 + 3;
	var boxStartPackCodeLen = 7;

	// 本号止号
	var boxEndPackCodePos = 5 + 5 + 3 + 3 + 3 + 7;
	var boxEndPackCodeLen = 7;

	// 获取盒子标签的每本张数
	var ticketNumPerPackOfBoxPos = 5 + 5 + 3 + 3;
	var ticketNumPerPackOfBoxLen = 3;

	// ----------------------票定义
	// 29位，产品编号+产品批次+生产批量+本批本号+票号+每本张数（5位+5位+6位+7位+3位+3位）
	// J2015 00002 000200 0012791 199 100
	// -------------------------------
	// 本号止号
	var packCodeOfTicketPos = 5 + 5 + 6;
	var packCodeOfTicketLen = 7;

	// 获取票标签的每本张数
	var ticketNumPerPackOfTicketPos = 5 + 5 + 6 + 7 + 3;
	var ticketNumPerPackOfTicketLen = 3;

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
	

	
	
	//用于批量导入
	function getPackInfo(tCode) {
		
		fpi = new Object();	
		transCode = handleString(tCode);

		if (isNullObj(transCode) || transCode.length == 0)
		{
			fpi.errCode = 1;
			fpi.errMessage ="请输入条形码！";
			return fpi;
		}

		var len = transCode.length;
		if(len == trunkLen || len == boxLen ||len ==ticketLen)
		{
		}else{
			fpi.errCode = 1;
			fpi.errMessage ="条码不符合规格！";
			return fpi;
		}
		
		var objRet = null;
		if (len == trunkLen) {
			objRet = getTrunInfo();
		} else if (len == boxLen) {
			objRet = getBoxInfo();
		} else if (len == ticketLen) {
			objRet = getPackageInfo();
		}
		//返回方案名称
		if(objRet != null)
		{
			if(objRet.planCode !=planCode ||  objRet.batchCode != batchCode)
			{
				objRet.errCode =1;
				objRet.errMessage ="该计划或批次不符合定义 ！";
				return objRet;
			}
			
			if(putObject(objRet) >0)
			{
				objRet.errCode =1;
				objRet.errMessage ="条码已经存在，请尝试另一个！";
				return objRet;
			}
			objRet.errCode =0;
			objRet.planName = planName;
		}

		return objRet;
		

		return null;
	}
	
	/*
	 * 新增用于批量导入之外的任意方案，任意批次的初始化
	 */
	function initInfoForPlans(plist)
	{
		planList= plist;
	}
	
	/*
	 * 用户非批量导入时使用
	 * 使用时，需要先解析出方案和批次，然后获取当前批次的信息进行计算
	 * 
	 */
	function getPackInfoExt(tCode) {
		
		//用于前面的验证及其返回
		fpi = new Object();			
		transCode = handleString(tCode);
		if (isNullObj(transCode) || transCode.length == 0)
		{
			fpi.errCode = 1;
			fpi.errMessage ="请输入条形码！";
			return fpi;
		}
		

		var len = transCode.length;
		if(len == trunkLen || len == boxLen ||len ==ticketLen)
		{
		}else{
			fpi.errCode = 1;
			fpi.errMessage ="条码不符合规格！";
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
			fpi.errMessage ="批次无效！";
			return fpi;
		}

		amountPerTicket = parseInt(batchinfo.amount);// 单票金额
		totalTicketNumOfGroup = parseInt(batchinfo.ticketsEveryGroup);// 奖组总票数

		var objRet = null;
		if (len == trunkLen) {
			objRet = getTrunInfo();
		} else if (len == boxLen) {
			objRet = getBoxInfo();
		} else if (len == ticketLen) {
			objRet = getPackageInfo();
		}
		//返回方案名称
		if(objRet != null)
		{
			if(putObject(objRet) >0)
			{
				objRet.errCode =1;
				objRet.errMessage ="条码已经存在，请尝试另一个！";
				return objRet;
			}
			objRet.errCode =0;
			objRet.planName = batchinfo.planName;
		}

		return objRet;
	}

	/*
	 * 获取箱签内容
	 */
	function getTrunInfo() {

		pi = new Object();
		pi.packUnit = "Trunk";
		pi.packUnitValue =1;

		// 临时变量
		var tmpStr = "";
		var tmpInt = 0;

		// 如下为了计算奖组
		var boxseq = 0;// 缓存本箱号
		var boxnum = 0;// 每组箱数
		var firstboxseq = 0;// 首箱序号
		var packnum = 0;
		var ticketnum = 0;

		// 获取方案
		tmpStr = "";
		tmpStr = transCode.substring(planCodePos, planCodePos + planCodeLen);
		pi.planCode = tmpStr;

		// 获取批次
		tmpStr = "";
		tmpStr = transCode.substring(batchCodePos, batchCodePos + batchCodeLen);
		pi.batchCode = tmpStr;

		// 获取箱子编号
		tmpStr = "";
		tmpStr = transCode.substring(boxCodePos, boxCodePos + boxCodeLen);
		pi.packUnitCode = tmpStr;
		boxseq = parseInt(tmpStr);

		// 获取每组箱子数
		tmpStr = "";
		tmpStr = transCode.substring(trunkNumPerGroupPos, trunkNumPerGroupPos
				+ trunkNumPerGroupLen);
		boxnum = parseInt(tmpStr);

		// 首箱序号
		tmpStr = "";
		tmpStr = transCode.substring(firstTrunkPerGroupPos,
				firstTrunkPerGroupPos + firstTrunkPerGroupLen);
		firstboxseq = parseInt(tmpStr);

		// 如下计算总数及其总价
		// 每箱本数
		tmpStr = "";
		tmpStr = transCode.substring(packNumPerBoxPos, packNumPerBoxPos
				+ packNumPerBoxLen);
		packnum = parseInt(tmpStr);

		// 每本张数
		tmpStr = "";
		tmpStr = transCode.substring(ticketNumPerPackPos, ticketNumPerPackPos
				+ ticketNumPerPackLen);
		ticketnum = parseInt(tmpStr);

		// 计算公式 组号 = (boxseq -first+1) / boxnum
		// 新的计算公式是：奖组号 = （ 箱号（从箱签上获取）-批次首箱号（包装信息） + 1 ） * 每箱本数（从箱签上获取） *
		// 每本张数（从箱签上获取）/ 每个奖组张数（从批次包装文件获取）+1
		tmpInt = Math.floor(((boxseq - firstTrunkCodeOfBatch + 1) * packnum * ticketnum)
				/ totalTicketNumOfGroup);
				
		var tceil =Math.floor(((boxseq - firstTrunkCodeOfBatch + 1) * packnum * ticketnum)
				% totalTicketNumOfGroup);
		if (tceil != 0)
		{
			tmpInt = tmpInt + 1;
		}
		pi.groupCode = FormatNum(tmpInt+'',2);

		pi.ticketNum = packnum * ticketnum;
		pi.amount = pi.ticketNum * amountPerTicket;

		// 获取首箱首本号
		tmpStr = "";
		tmpStr = transCode.substring(firstPkgOfTrunkPos, firstPkgOfTrunkPos
				+ firstPkgOfTrunkLen);
		pi.firstPkgCode = tmpStr;

		return pi;
	}

	/*
	 * 获取盒签内容
	 */
	function getBoxInfo() {

		pi = new Object();
		pi.packUnit = "Box";
		pi.packUnitValue =2;

		// 临时变量
		var tmpStr = "";
		var tmpInt = 0;

		// 如下为了计算张数 和 盒子序号
		// 张数=
		var packnumpertrunk = 0;// 每箱本数
		var boxnumertrunk =0; // 每箱盒数
		var packstartpackcode = 0;// 起始本号
		var packendpackcode = 0;// 结束本号
		var trunkcode = 0;//箱号，用于计算盒子号
		var boxcode = 0;//用于计算盒子号 

		// 获取方案
		tmpStr = "";
		tmpStr = transCode.substring(planCodePos, planCodePos + planCodeLen);
		pi.planCode = tmpStr;

		// 获取批次
		tmpStr = "";
		tmpStr = transCode.substring(batchCodePos, batchCodePos + batchCodeLen);
		pi.batchCode = tmpStr;

		// 获取每箱合数
		tmpStr = "";
		tmpStr = transCode.substring(boxNumPerTrunkPos, boxNumPerTrunkPos
				+ boxNumPerTrunkLen);
		boxnumertrunk = parseInt(tmpStr);
		
		// 获取每箱本数
		tmpStr = "";
		tmpStr = transCode.substring(packNumPerBTrunkPos, packNumPerBTrunkPos
				+ packNumPerBTrunkLen);
		packnumpertrunk = parseInt(tmpStr);
		
		
		// 起始本号
		tmpStr = "";
		tmpStr = transCode.substring(boxStartPackCodePos, boxStartPackCodePos
				+ boxStartPackCodeLen);
		packstartpackcode = parseInt(tmpStr);
		pi.firstPkgCode = tmpStr;

		// 结束本号
		tmpStr = "";
		tmpStr = transCode.substring(boxEndPackCodePos, boxEndPackCodePos
				+ boxEndPackCodeLen);
		packendpackcode = parseInt(tmpStr);


		// 新计算盒号格式：箱号 xxxxx- 盒号xx
		// 箱号=起始本/每箱本数
		// 盒号=起始本 mod 每箱本数 /每箱盒数
		
		trunkcode =  Math.floor(packstartpackcode/packnumpertrunk) + 1;
		tmpInt = Math.floor(packnumpertrunk/boxnumertrunk);//每盒本数
		boxcode =  Math.floor(packstartpackcode % packnumpertrunk /tmpInt) + 1;
		pi.packUnitCode = FormatNum(trunkcode+"",5)+"-"+FormatNum(boxcode+"",2);

		// 如下计算总数及其总价
		// 每本张数
		tmpStr = "";
		tmpStr = transCode.substring(ticketNumPerPackOfBoxPos,
				ticketNumPerPackOfBoxPos + ticketNumPerPackOfBoxLen);
		tmpInt = parseInt(tmpStr);
		var tnperpack =tmpInt;

		pi.ticketNum = (packendpackcode-packstartpackcode+1) * tmpInt;
		pi.amount = pi.ticketNum * amountPerTicket;
		
		//计算奖组
		tmpInt = Math.floor(((trunkcode - firstTrunkCodeOfBatch + 1) * packnumpertrunk * tnperpack)
				/ totalTicketNumOfGroup);
				
		var tceil =Math.floor(((trunkcode - firstTrunkCodeOfBatch + 1) * packnumpertrunk * tnperpack)
				% totalTicketNumOfGroup);
		if (tceil != 0)
		{
			tmpInt = tmpInt + 1;
		}
		
		pi.groupCode = FormatNum(tmpInt+'',2);

		return pi;
	}

	/*
	 * 获取票本标签内容
	 */
	function getPackageInfo() {

		pi = new Object();
		pi.packUnit = "Package";
		pi.packUnitValue =3;

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
		tmpStr = transCode.substring(packCodeOfTicketPos, packCodeOfTicketPos
				+ packCodeOfTicketLen);
		pi.packUnitCode = tmpStr;
		pi.firstPkgCode = tmpStr;

		// 如下计算总数及其总价
		// 每本张数
		tmpInt = 0
		tmpStr = "";
		tmpStr = transCode.substring(ticketNumPerPackOfTicketPos,
				ticketNumPerPackOfTicketPos + ticketNumPerPackOfTicketLen);
		tmpInt = parseInt(tmpStr);
		pi.ticketNum = tmpInt;
		var tnperpack =tmpInt;
		
		
		//计算奖组
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
		var keyin = objin.planCode+''+objin.batchCode + ''+objin.packUnitCode;
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
		initInfo : initInfo,
		getPackInfoExt:getPackInfoExt,
		initInfoForPlans:initInfoForPlans,
		removeObject : removeObject,
		clearObjects : clearObjects
	}
}();
