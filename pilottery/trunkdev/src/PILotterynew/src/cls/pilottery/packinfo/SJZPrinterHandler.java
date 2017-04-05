package cls.pilottery.packinfo;

import org.apache.commons.lang.StringUtils;

import cls.pilottery.web.plans.model.Plan;


public class SJZPrinterHandler implements PackUnitHandle {

	private int trunkLen = "J000114901096000400251011080008801002800150614038396113.5guardz"
			.length();
	private int boxLen = "J00011490100510010000000010000020".length();
	private int ticketLen = "J2015000020002000012799199100".length();
	private int safeCodeLen = "J2015000020013842184DKTSANFUBVYUNAORAG016"
			.length();
	private String transCode = "";

	private String planCode = "";
	private long amountPerTicket = 0;
	private int firstTrunkCodeOfBatch = 0;// 批次首箱号
	private int totalTicketNumOfGroup = 0;// 奖组总票数
	

	// ----------------------箱子包装定义
	// 63位，箱号编码的规则包含产品编码、生产批次、箱起号和箱止号。
	// 方案5 + 批次5 +箱号5+每箱本数3+每本张数3+分组号4+4组箱数+分组首箱号5+6生产批号+6出厂时间+7本箱首本号+ 4重量+6备用
	// J0001 14901 09600 040 025 1011 0800 08801 002800 150614 0383961 13.5
	// guardz
	// -------------------------------

	// 获取方案编号
	private int planCodePos = 0;
	private int planCodeLen = 5;

	// 获取批次
	private int batchCodePos = 5;
	private int batchCodeLen = 5;

	// 获取箱子编号
	private int boxCodePos = 5 + 5;
	private int boxCodeLen = 5;

	// 获取每箱本数
	private int packNumPerBoxPos = 5 + 5 + 5;
	private int packNumPerBoxLen = 3;

	// 获取每本张数
	private int ticketNumPerPackPos = 5 + 5 + 5 + 3;
	private int ticketNumPerPackLen = 3;

	// 如下为了计算奖组
	// 每组箱数
	private int trunkNumPerGroupPos = 5 + 5 + 5 + 3 + 3 + 4;
	private int trunkNumPerGroupLen = 4;
	// 每组首箱
	private int firstTrunkPerGroupPos = 5 + 5 + 5 + 3 + 3 + 4 + 4;
	private int firstTrunkPerGroupLen = 5;
	
	// 每箱首本号
	private int firstPkgOfTrunkPos = 5 + 5 + 5 + 3 + 3 + 4 + 4 + 5 + 6 + 6;
	private int firstPkgOfTrunkLen = 7;


	// ----------------------盒子包装定义
	// 33位，产品编码+生产批次+每箱盒数+每箱本数+每本张数+本号起号+本号止号（5位+5位+3位+3位+3位+7位+7位）
	// J2015 00002 005 100 100 0000021 0000040
	// -------------------------------

	// 每箱盒数
	private int boxNumPerTrunkPos = 5 + 5;
	private int boxNumPerTrunkLen = 3;
	// 每箱本数
	private int boxPkgNumPerTrunkPos = 5 + 5 + 3;
	private int boxPkgNumPerTrunkLen = 3;

	// 本号起号
	private int boxStartPackCodePos = 5 + 5 + 3 + 3 + 3;
	private int boxStartPackCodeLen = 7;

	// 本号止号
	private int boxEndPackCodePos = 5 + 5 + 3 + 3 + 3 + 7;
	private int boxEndPackCodeLen = 7;

	// 获取盒子标签的每本张数
	private int ticketNumPerPackOfBoxPos = 5 + 5 + 3 + 3;
	private int ticketNumPerPackOfBoxLen = 3;

	// ----------------------票定义
	// 29位，产品编号+产品批次+生产批量+本批本号+票号+每本张数（5位+5位+6位+7位+3位+3位）
	// J2015 00002 000200 0012791 199 100
	// -------------------------------
	// 本号止号
	private int packCodeOfTicketPos = 5 + 5 + 6;
	private int packCodeOfTicketLen = 7;

	// 获取票标签的每本张数
	private int ticketNumPerPackOfTicketPos = 5 + 5 + 6 + 7 + 3;
	private int ticketNumPerPackOfTicketLen = 3;

	// 保安区条码
	// 41位，产品编号+产品批次+本批本号+票号+保安码+快速兑奖标识（5位+5位+7位+3位+16位+5位）
	// J2015 00002 0013842 184 DKTSANFUBVYUNAOR AG016

	// 本号止号
	private int packOfSafeCodePos = 5 + 5;
	private int packOfSafeCodeLen = 7;

	// 票号
	private int ticketOfSafeCodePos = 5 + 5 + 7;
	private int ticketOfSafeCodeLen = 3;

	// 保安码
	private int safeCodeOfSafeCodePos = 5 + 5 + 7 + 3;
	private int safeCodeOfSafeCodeLen = 16;

	// 快速兑奖标识
	private int paySignOfSafeCodePos = 5 + 5 + 7 + 3 + 16;
	private int paySignOfSafeCodeLen = 5;
	
	/*
	 * 构造方法
	 */
	public SJZPrinterHandler(String planCode, long amountPerTicket,
			int batchFirstTrunkCode, int totalTicketNumOfGroup) {
		this.planCode = planCode;
		this.amountPerTicket = amountPerTicket;
		this.firstTrunkCodeOfBatch = batchFirstTrunkCode;
		this.totalTicketNumOfGroup = totalTicketNumOfGroup;
	}

	public SJZPrinterHandler(Plan p) {
		this.planCode = p.getPlanCode();
		this.amountPerTicket = p.getFaceValue();
		this.firstTrunkCodeOfBatch = 1;
	}

	public PackInfo getPackInfo(String transCode) {

		this.transCode = transCode;
		if (StringUtils.isEmpty(transCode))
			return null;

		int len = transCode.trim().length();
		if (len == trunkLen) {
			return getTrunInfo();
		} else if (len == boxLen) {

			return getBoxInfo();
		} else if (len == ticketLen) {
			return getPackageInfo();
		} else if (len == safeCodeLen) {
			return getSafeCodeInfo();
		}

		return null;
	}
	
	
	/*
	 * 
	 */
	public PackInfo getPayoutPackInfo(String transCode) {

		this.transCode = transCode;
		if (StringUtils.isEmpty(transCode))
			return null;

		int len = transCode.trim().length();
		if (len == ticketLen) {
			return getPackageInfo();
		} else if (len == safeCodeLen) {
			return getSafeCodeInfo();
		}

		return null;
	}
	

	/*
	 * 获取箱签内容
	 */
	private PackInfo getTrunInfo() {

		PackInfo pi = new PackInfo();
		pi.setPackUnit(EunmPackUnit.Trunck);

		// 临时变量
		String tmpStr = "";
		int tmpInt = 0;

		// 如下为了计算奖组
		int boxseq = 0;// 缓存本箱号
		int boxnum = 0;// 每组箱数
		int firstboxseq = 0;// 首箱序号
		int packnum = 0;
		int ticketnum = 0;

		// 获取方案
		tmpStr = "";
		tmpStr = this.transCode.substring(this.planCodePos, this.planCodePos
				+ this.planCodeLen);
		pi.setPlanCode(tmpStr);

		// 获取批次
		tmpStr = "";
		tmpStr = this.transCode.substring(this.batchCodePos, this.batchCodePos
				+ this.batchCodeLen);
		pi.setBatchCode(tmpStr);

		// 获取箱子编号
		tmpStr = "";
		tmpStr = this.transCode.substring(this.boxCodePos, this.boxCodePos
				+ this.boxCodeLen);
		pi.setPackUnitCode(tmpStr);
		boxseq = Integer.parseInt(tmpStr);

		// 获取每组箱子数
		tmpStr = "";
		tmpStr = this.transCode.substring(this.trunkNumPerGroupPos,
				this.trunkNumPerGroupPos + this.trunkNumPerGroupLen);
		boxnum = Integer.parseInt(tmpStr);

		// 首箱序号
		tmpStr = "";
		tmpStr = this.transCode.substring(this.firstTrunkPerGroupPos,
				this.firstTrunkPerGroupPos + this.firstTrunkPerGroupLen);
		firstboxseq = Integer.parseInt(tmpStr);
		
		// 首本号
		tmpStr = "";
		tmpStr = this.transCode.substring(this.firstPkgOfTrunkPos,
				this.firstPkgOfTrunkPos + this.firstPkgOfTrunkLen);
		pi.setFirstPkgCode(tmpStr);
		

		// 如下计算总数及其总价
		// 每箱本数
		tmpStr = "";
		tmpStr = this.transCode.substring(this.packNumPerBoxPos,
				this.packNumPerBoxPos + this.packNumPerBoxLen);
		packnum = Integer.parseInt(tmpStr);

		// 每本张数
		tmpStr = "";
		tmpStr = this.transCode.substring(this.ticketNumPerPackPos,
				this.ticketNumPerPackPos + this.ticketNumPerPackLen);
		ticketnum = Integer.parseInt(tmpStr);

		// 计算公式 组号 = (boxseq -first+1) / boxnum
		// 新的计算公式是：奖组号 = （ 箱号（从箱签上获取）-批次首箱号（包装信息） + 1 ） * 每箱本数（从箱签上获取） *
		// 每本张数（从箱签上获取）/ 每个奖组张数（从批次包装文件获取）+1
		if (this.totalTicketNumOfGroup > 0) {
			tmpInt = ((boxseq - this.firstTrunkCodeOfBatch + 1) * packnum * ticketnum)
					/ this.totalTicketNumOfGroup + 1;
			pi.setGroupCode(tmpInt + "");
		}

		pi.setTicketNum(packnum * ticketnum);
		pi.setAmount(pi.getTicketNum() * this.amountPerTicket);

		return pi;
	}

	/*
	 * 获取盒签内容
	 */
	private PackInfo getBoxInfo() {
		PackInfo pi = new PackInfo();
		pi.setPackUnit(EunmPackUnit.Box);

		// 临时变量
		String tmpStr = "";
		int tmpInt = 0;

		// 如下为了计算张数 和 盒子序号
		int packnumperpertrunk = 0;// 每箱本数
		int boxnumpertrunk = 0;//每箱盒数
		int packstartpackcode = 0;// 起始本号
		int packendpackcode = 0;// 结束本号

		// 获取方案
		tmpStr = "";
		tmpStr = this.transCode.substring(this.planCodePos, this.planCodePos
				+ this.planCodeLen);
		pi.setPlanCode(tmpStr);

		// 获取批次
		tmpStr = "";
		tmpStr = this.transCode.substring(this.batchCodePos, this.batchCodePos
				+ this.batchCodeLen);
		pi.setBatchCode(tmpStr);

		// 获取每箱合数
		tmpStr = "";
		tmpStr = this.transCode.substring(this.boxNumPerTrunkPos,
				this.boxNumPerTrunkPos + this.boxNumPerTrunkLen);
		boxnumpertrunk = Integer.parseInt(tmpStr);

		// 起始本号
		tmpStr = "";
		tmpStr = this.transCode.substring(this.boxStartPackCodePos,
				this.boxStartPackCodePos + this.boxStartPackCodeLen);
		pi.setFirstPkgCode(tmpStr);
		packstartpackcode = Integer.parseInt(tmpStr);

		// 结束本号
		tmpStr = "";
		tmpStr = this.transCode.substring(this.boxEndPackCodePos,
				this.boxEndPackCodePos + this.boxEndPackCodeLen);
		packendpackcode = Integer.parseInt(tmpStr);
		
		//计算每箱本数
		tmpStr = "";
		tmpStr = this.transCode.substring(this.boxPkgNumPerTrunkPos,
				this.boxPkgNumPerTrunkPos + this.boxPkgNumPerTrunkLen);
		packnumperpertrunk = Integer.parseInt(tmpStr);
		
		// 计算公式 盒号 
		int trunkcode =  (int) (Math.floor(packstartpackcode/packnumperpertrunk)) + 1;
		tmpInt = (int)Math.floor(packnumperpertrunk/boxnumpertrunk);//每盒本数
		int boxcode =  (int)Math.floor(packstartpackcode % packnumperpertrunk /tmpInt) + 1;
		String packUnitCode =String.format("%05d", trunkcode) +"-"+String.format("%02d", boxcode);
		pi.setPackUnitCode(packUnitCode);
	
		// 如下计算总数及其总价
		// 每本张数
		tmpStr = "";
		tmpStr = this.transCode.substring(this.ticketNumPerPackOfBoxPos,
				this.ticketNumPerPackOfBoxPos + this.ticketNumPerPackOfBoxLen);
		tmpInt = Integer.parseInt(tmpStr);

		pi.setTicketNum((packendpackcode-packstartpackcode+1) * tmpInt);
		pi.setAmount(pi.getTicketNum() * this.amountPerTicket);

		return pi;
	}

	/*
	 * 获取票本标签内容
	 */
	private PackInfo getPackageInfo() {
		PackInfo pi = new PackInfo();
		pi.setPackUnit(EunmPackUnit.pkg);

		// 临时变量
		String tmpStr = "";
		int tmpInt = 0;

		// 获取方案
		tmpStr = "";
		tmpStr = this.transCode.substring(this.planCodePos, this.planCodePos
				+ this.planCodeLen);
		pi.setPlanCode(tmpStr);

		// 获取批次
		tmpStr = "";
		tmpStr = this.transCode.substring(this.batchCodePos, this.batchCodePos
				+ this.batchCodeLen);
		pi.setBatchCode(tmpStr);

		// 本号
		tmpStr = "";
		tmpStr = this.transCode.substring(this.packCodeOfTicketPos,
				this.packCodeOfTicketPos + this.packCodeOfTicketLen);
		pi.setPackUnitCode(tmpStr);

		// 如下计算总数及其总价
		// 每本张数
		tmpStr = "";
		tmpStr = this.transCode.substring(this.ticketNumPerPackOfTicketPos,
				this.ticketNumPerPackOfTicketPos
						+ this.ticketNumPerPackOfTicketLen);
		tmpInt = Integer.parseInt(tmpStr);

		pi.setTicketNum(tmpInt);
		pi.setAmount(pi.getTicketNum() * this.amountPerTicket);
		return pi;
	}

	/*
	 * 获取票标签内容
	 */
	private PackInfo getPackageTicketInfo() {
		PackInfo pi = new PackInfo();
		pi.setPackUnit(EunmPackUnit.pkg);

		// 临时变量
		String tmpStr = "";
		int tmpInt = 0;

		// 获取方案
		tmpStr = "";
		tmpStr = this.transCode.substring(this.planCodePos, this.planCodePos
				+ this.planCodeLen);
		pi.setPlanCode(tmpStr);

		// 获取批次
		tmpStr = "";
		tmpStr = this.transCode.substring(this.batchCodePos, this.batchCodePos
				+ this.batchCodeLen);
		pi.setBatchCode(tmpStr);

		// 本号
		tmpStr = "";
		tmpStr = this.transCode.substring(this.packCodeOfTicketPos,
				this.packCodeOfTicketPos + this.packCodeOfTicketLen);
		pi.setFirstPkgCode(tmpStr);

		tmpStr = "";
		tmpStr = this.transCode.substring(this.ticketNumPerPackOfTicketPos,
				this.ticketNumPerPackOfTicketPos + this.ticketNumPerPackOfTicketLen);
		
		pi.setPackUnitCode(tmpStr);
		
		pi.setTicketNum(1);
		pi.setAmount(pi.getTicketNum() * this.amountPerTicket);
		return pi;
	}

	
	
	/*
	 * 获取票保安区标签内容
	 */
	private PackInfo getSafeCodeInfo() {
		PackInfo pi = new PackInfo();
		pi.setPackUnit(EunmPackUnit.ticket);

		// 临时变量
		String tmpStr = "";

		// 获取方案
		tmpStr = "";
		tmpStr = this.transCode.substring(this.planCodePos, this.planCodePos
				+ this.planCodeLen);
		pi.setPlanCode(tmpStr);

		// 获取批次
		tmpStr = "";
		tmpStr = this.transCode.substring(this.batchCodePos, this.batchCodePos
				+ this.batchCodeLen);
		pi.setBatchCode(tmpStr);

		// 本号
		tmpStr = "";
		tmpStr = this.transCode.substring(this.packOfSafeCodePos,
				this.packOfSafeCodePos + this.packOfSafeCodeLen);
		pi.setFirstPkgCode(tmpStr);

		// 票号
		tmpStr = "";
		tmpStr = this.transCode.substring(this.ticketOfSafeCodePos,
				this.ticketOfSafeCodePos + this.ticketOfSafeCodeLen);
		pi.setPackUnitCode(tmpStr);

		// 保安码
		tmpStr = "";
		tmpStr = this.transCode.substring(this.safeCodeOfSafeCodePos,
				this.safeCodeOfSafeCodePos + this.safeCodeOfSafeCodeLen);
		pi.setSafetyCode(tmpStr);

		// 快速兑奖标志 
		tmpStr = "";
		tmpStr = this.transCode.substring(this.paySignOfSafeCodePos,
				this.paySignOfSafeCodePos + this.paySignOfSafeCodeLen);
		pi.setPaySign(tmpStr);

		// 如下计算总数及其总价
		// 每本张数
		pi.setTicketNum(1);
		pi.setAmount(pi.getTicketNum() * this.amountPerTicket);
		return pi;
	}

}
