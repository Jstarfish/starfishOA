package cls.pilottery.web.area.model;

public class City implements Comparable<City>{


	private Long cityCode;
	private String cityName;
	private Long pid;
	private Long agencyCode;
	private String agencyName;
    private boolean checked;
	
	public boolean isChecked() {
		return checked;
	}

	public void setChecked(boolean checked) {
		this.checked = checked;
	}

	public Long getCityCode() {
		return cityCode;
	}
	
	public void setCityCode(Long cityCode) {
		this.cityCode = cityCode;
	}
	
	public String getCityName() {
		return cityName;
	}
	
	public void setCityName(String cityName) {
		this.cityName = cityName;
	}
	
	public Long getPid() {
		return pid;
	}
	
	public void setPid(Long pid) {
		this.pid = pid;
	}
	
	public Long getAgencyCode() {
		return agencyCode;
	}
	
	public void setAgencyCode(Long agencyCode) {
		this.agencyCode = agencyCode;
	}
	
	public String getAgencyName() {
		return agencyName;
	}
	
	public void setAgencyName(String agencyName) {
		this.agencyName = agencyName;
	}

	@Override
	public int hashCode() {
		final int prime = 31;
		int result = 1;
		result = prime * result + ((agencyCode == null) ? 0 : agencyCode.hashCode());
		result = prime * result + ((agencyName == null) ? 0 : agencyName.hashCode());
		result = prime * result + (checked ? 1231 : 1237);
		result = prime * result + ((cityCode == null) ? 0 : cityCode.hashCode());
		result = prime * result + ((cityName == null) ? 0 : cityName.hashCode());
		result = prime * result + ((pid == null) ? 0 : pid.hashCode());
		return result;
	}

	@Override
	public boolean equals(Object obj) {
		if (this == obj)
			return true;
		if (obj == null)
			return false;
		if (getClass() != obj.getClass())
			return false;
		City other = (City) obj;
		if (agencyCode == null) {
			if (other.agencyCode != null)
				return false;
		} else if (!agencyCode.equals(other.agencyCode))
			return false;
		if (agencyName == null) {
			if (other.agencyName != null)
				return false;
		} else if (!agencyName.equals(other.agencyName))
			return false;
		if (checked != other.checked)
			return false;
		if (cityCode == null) {
			if (other.cityCode != null)
				return false;
		} else if (!cityCode.equals(other.cityCode))
			return false;
		if (cityName == null) {
			if (other.cityName != null)
				return false;
		} else if (!cityName.equals(other.cityName))
			return false;
		if (pid == null) {
			if (other.pid != null)
				return false;
		} else if (!pid.equals(other.pid))
			return false;
		return true;
	}

	@Override
	public int compareTo(City arg0) {
		 if(this.cityCode > arg0.cityCode){  
	            return 1;  
	        }else if(this.cityCode <arg0.cityCode){  
	            return -1;  
	        }
		return 0;
	}

	

	
}
