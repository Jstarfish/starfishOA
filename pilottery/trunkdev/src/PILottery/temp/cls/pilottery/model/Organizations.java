package cls.pilottery.model;

public class Organizations {
    private String orgCode;

    private String orgName;

    private Short orgType;

    private Short orgStatus;

    private String superOrg;

    private String phone;

    private Short directorAdmin;

    private Integer persons;

    private String address;

    public String getOrgCode() {
        return orgCode;
    }

    public void setOrgCode(String orgCode) {
        this.orgCode = orgCode == null ? null : orgCode.trim();
    }

    public String getOrgName() {
        return orgName;
    }

    public void setOrgName(String orgName) {
        this.orgName = orgName == null ? null : orgName.trim();
    }

    public Short getOrgType() {
        return orgType;
    }

    public void setOrgType(Short orgType) {
        this.orgType = orgType;
    }

    public Short getOrgStatus() {
        return orgStatus;
    }

    public void setOrgStatus(Short orgStatus) {
        this.orgStatus = orgStatus;
    }

    public String getSuperOrg() {
        return superOrg;
    }

    public void setSuperOrg(String superOrg) {
        this.superOrg = superOrg == null ? null : superOrg.trim();
    }

    public String getPhone() {
        return phone;
    }

    public void setPhone(String phone) {
        this.phone = phone == null ? null : phone.trim();
    }

    public Short getDirectorAdmin() {
        return directorAdmin;
    }

    public void setDirectorAdmin(Short directorAdmin) {
        this.directorAdmin = directorAdmin;
    }

    public Integer getPersons() {
        return persons;
    }

    public void setPersons(Integer persons) {
        this.persons = persons;
    }

    public String getAddress() {
        return address;
    }

    public void setAddress(String address) {
        this.address = address == null ? null : address.trim();
    }
}