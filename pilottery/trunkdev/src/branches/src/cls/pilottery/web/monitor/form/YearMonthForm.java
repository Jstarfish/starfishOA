package cls.pilottery.web.monitor.form;

import java.io.Serializable;

public class YearMonthForm implements Serializable {

	private static final long serialVersionUID = 1L;

	private String year;

	private String month;
	
	private String insCode;

	
	public String getInsCode() {
	
		return insCode;
	}

	
	public void setInsCode(String insCode) {
	
		this.insCode = insCode;
	}

	public YearMonthForm() {

	}

	public String getYear() {

		return year;
	}

	public void setYear(String year) {

		this.year = year;
	}

	public String getMonth() {

		return month;
	}

	public void setMonth(String month) {

		this.month = month;
	}


	public YearMonthForm(String year , String month , String insCode) {

		this.year = year;
		this.month = month;
		this.insCode = insCode;
	}
	public YearMonthForm(String year , String insCode) {
		
		this.year = year;
		this.insCode = insCode;
	}

	
}
