package cls.pilottery.oms.business.model.notifymodel;

import java.util.ArrayList;
import java.util.List;

import cls.pilottery.common.model.BaseEntity;

public class TreeNode extends BaseEntity{

	/**
	 * 
	 */
	private static final long serialVersionUID = 7174188303692467385L;
	public String id;
    public String pid;
    public String name;
    public String ename;
    public Integer mlevel;
    public boolean open;
    public boolean checked;
    public boolean nocheck = false;
    public List<?> nodes = new ArrayList<Object>();

    
    public TreeNode() {
        super();
    }
    
    public TreeNode(String id, String pid, String name, String ename,
            boolean open) {
        super();
        this.id = id;
        this.pid = pid;
        this.name = name;
        this.ename = ename;
        this.open = open;
        
    }
    public TreeNode(String id, String pid, String name, String ename,Integer level,
            boolean open) {
        super();
        this.id = id;
        this.pid = pid;
        this.name = name;
        this.ename = ename;
        this.mlevel = level;
        this.open = open;
        
    }
    
    public TreeNode(String id, String pid, String name, String ename,Integer level,
            boolean open, boolean checked) {
        super();
        this.id = id;
        this.pid = pid;
        this.name = name;
        this.ename = ename;
        this.open = open;
        this.mlevel = level;
        this.checked = checked;
    }



    

    public Integer getMlevel() {
        return mlevel;
    }

    public void setMlevel(Integer mlevel) {
        this.mlevel = mlevel;
    }

    public boolean isNocheck() {
        return nocheck;
    }

    public void setNocheck(boolean nocheck) {
        this.nocheck = nocheck;
    }

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public List<?> getNodes() {
        return nodes;
    }

    public void setNodes(List<?> nodes) {
        this.nodes = nodes;
    }

    public String getPid() {
        return pid;
    }

    public void setPid(String pid) {
        this.pid = pid;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getEname() {
        return ename;
    }

    public void setEname(String ename) {
        this.ename = ename;
    }

    public boolean isOpen() {
        return open;
    }

    public void setOpen(boolean open) {
        this.open = open;
    }

    public boolean isChecked() {
        return checked;
    }

    public void setChecked(boolean checked) {
        this.checked = checked;
    }
}
