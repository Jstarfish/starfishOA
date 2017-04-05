package cls.pilottery.fbs.msg;

/**
 * Created by Reno Main on 2016/6/12.
 */
public class DrawConfirmRsp12024 implements java.io.Serializable {
    private static final long serialVersionUID = 4697452198441721002L;
    private String version = "1.0.0";
    private int type;
    private int func;
    private long token;
    private int msn;
    private long when;
    private int rc;		//返回消息错误码

    public int getFunc() {
        return func;
    }

    public void setFunc(int func) {
        this.func = func;
    }

    public int getMsn() {
        return msn;
    }

    public void setMsn(int msn) {
        this.msn = msn;
    }

    public int getRc() {
        return rc;
    }

    public void setRc(int rc) {
        this.rc = rc;
    }

    public static long getSerialVersionUID() {
        return serialVersionUID;
    }

    public long getToken() {
        return token;
    }

    public void setToken(long token) {
        this.token = token;
    }

    public int getType() {
        return type;
    }

    public void setType(int type) {
        this.type = type;
    }

    public String getVersion() {
        return version;
    }

    public void setVersion(String version) {
        this.version = version;
    }

    public long getWhen() {
        return when;
    }

    public void setWhen(long when) {
        this.when = when;
    }
}
