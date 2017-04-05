package cls.pilottery.web.marketManager.model;

import java.io.Serializable;

public class InventoryTreeModel implements Serializable {
	private static final long serialVersionUID = 331016874247377021L;
	private String id;
	private String pId;
	private String name;
	private int isFull;
	private boolean open;
	private boolean nocheck;
	private int type;
	public String getId() {
		return id;
	}
	public void setId(String id) {
		this.id = id;
	}
	public String getPId() {
		return pId;
	}
	public void setPId(String pId) {
		this.pId = pId;
	}
	public int getIsFull() {
		return isFull;
	}
	public void setIsFull(int isFull) {
		this.isFull = isFull;
		if(isFull == 0){
			this.nocheck = true;
			this.open = true;
		}
	}
	public String getName() {
		return name;
	}
	public void setName(String name) {
		this.name = name;
	}
	public boolean isOpen() {
		return open;
	}
	public void setOpen(boolean open) {
		this.open = open;
	}
	public boolean isNocheck() {
		return nocheck;
	}
	public void setNocheck(boolean nocheck) {
		this.nocheck = nocheck;
	}
	public int getType() {
		return type;
	}
	public void setType(int type) {
		this.type = type;
	}
}
