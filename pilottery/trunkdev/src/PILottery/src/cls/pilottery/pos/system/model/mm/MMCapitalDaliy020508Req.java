package cls.pilottery.pos.system.model.mm;

import java.io.Serializable;

public class MMCapitalDaliy020508Req implements Serializable {
	private static final long serialVersionUID = -2355068233168984851L;
	private String follow;
	private int count;
	public String getFollow() {
		return follow;
	}
	public void setFollow(String follow) {
		this.follow = follow;
	}
	public int getCount() {
		return count;
	}
	public void setCount(int count) {
		this.count = count;
	}
}
