package cls.pilottery.pos.system.model;

import java.io.Serializable;

public class BatchInfo implements Serializable {
	private static final long serialVersionUID = -3508920588191577540L;
	private String batchNo;
	private int boxesEveryTrunk;
	private int packsEvenyTrunk;
	private int ticketsEveryPack;
	public String getBatchNo() {
		return batchNo;
	}
	public void setBatchNo(String batchNo) {
		this.batchNo = batchNo;
	}
	public int getBoxesEveryTrunk() {
		return boxesEveryTrunk;
	}
	public void setBoxesEveryTrunk(int boxesEveryTrunk) {
		this.boxesEveryTrunk = boxesEveryTrunk;
	}
	public int getPacksEvenyTrunk() {
		return packsEvenyTrunk;
	}
	public void setPacksEvenyTrunk(int packsEvenyTrunk) {
		this.packsEvenyTrunk = packsEvenyTrunk;
	}
	public int getTicketsEveryPack() {
		return ticketsEveryPack;
	}
	public void setTicketsEveryPack(int ticketsEveryPack) {
		this.ticketsEveryPack = ticketsEveryPack;
	}
}
