package cls.pilottery.common.excel.enty;

import cls.pilottery.common.excel.utils.MapperCell;

public class MyTest {
	   @MapperCell(cellName = "名称", order = 0)
	    private String name;

	    @MapperCell(cellName = "联系电话", order = 1)
	    private String phone;

	    @MapperCell(cellName = "地址", order = 2)
	    private String address;

	    @MapperCell(cellName = "一级分类ID", order = 3)
	    private int type;

	    @MapperCell(cellName = "经度", order = 4)
	    private double lat;

	    @Override
	    public String toString() {
	        return "MyTest{" +
	                "name='" + name + '\'' +
	                ", phone='" + phone + '\'' +
	                ", address='" + address + '\'' +
	                ", type=" + type +
	                ", lat=" + lat +
	                '}';
	    }

		public String getName() {
			return name;
		}

		public void setName(String name) {
			this.name = name;
		}

		public String getPhone() {
			return phone;
		}

		public void setPhone(String phone) {
			this.phone = phone;
		}

		public String getAddress() {
			return address;
		}

		public void setAddress(String address) {
			this.address = address;
		}

		public int getType() {
			return type;
		}

		public void setType(int type) {
			this.type = type;
		}

		public double getLat() {
			return lat;
		}

		public void setLat(double lat) {
			this.lat = lat;
		}
	    
}
