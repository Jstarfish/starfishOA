package cls.pilottery.web.items.entity;

import java.io.Serializable;
import java.util.Date;

//2.1.10.3
//与数据库表字段一一对应，不在系统中使用
public class ItemReceipt implements Serializable {

	private static final long serialVersionUID = 3335140661950538261L;

	private String irNo;            //入库单编号（IR12345678）//IR_NO//CHAR(10)//非空
	private Integer createAdmin;    //建立人//CREATE_ADMIN//NUMBER(4)
	private String receiveOrg;      //入库仓库所属单位//RECEIVE_ORG//CHAR(2)
	private String receiveWh;       //入库仓库//RECEIVE_WH//CHAR(4)
	private Date receiveDate;       //入库时间//RECEIVE_DATE//DATE
	
    public String getIrNo() {
        return irNo;
    }
    public void setIrNo(String irNo) {
        this.irNo = irNo == null ? null : irNo.trim();
    }
    
    public Integer getCreateAdmin() {
        return createAdmin;
    }
    public void setCreateAdmin(Integer createAdmin) {
        this.createAdmin = createAdmin;
    }
    
    public String getReceiveOrg() {
        return receiveOrg;
    }
    public void setReceiveOrg(String receiveOrg) {
        this.receiveOrg = receiveOrg == null ? null : receiveOrg.trim();
    }
    
    public String getReceiveWh() {
        return receiveWh;
    }
    public void setReceiveWh(String receiveWh) {
        this.receiveWh = receiveWh == null ? null : receiveWh.trim();
    }
    
    public Date getReceiveDate() {
        return receiveDate;
    }
    public void setReceiveDate(Date receiveDate) {
        this.receiveDate = receiveDate;
    }
}
