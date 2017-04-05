package cls.pilottery.oms.issue.model;

import java.util.ArrayList;
import java.util.List;

public class HighPrize {
	
    private String prize_level;
    private List<Location> location = new ArrayList<Location>();
    
	public String getPrize_level() {
		return prize_level;
	}
	public void setPrize_level(String prize_level) {
		this.prize_level = prize_level;
	}
	public List<Location> getLocation() {
		return location;
	}
	public void setLocation(List<Location> location) {
		this.location = location;
	}
}
