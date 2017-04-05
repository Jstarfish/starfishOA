package cls.pilottery.pos.common.model;

public class MethodInfo {
	private String methodName;	//方法名字
	private String methodCode;	//对应接口规范中方法编码
	private Class<?> className;	//方法所在的类名
	public String getMethodName() {
		return methodName;
	}
	public void setMethodName(String methodName) {
		this.methodName = methodName;
	}
	public String getMethodCode() {
		return methodCode;
	}
	public void setMethodCode(String methodCode) {
		this.methodCode = methodCode;
	}
	public Class<?> getClassName() {
		return className;
	}
	public void setClassName(Class<?> className) {
		this.className = className;
	}
	@Override
	public String toString() {
		return "MethodInfo [className=" + className + ", methodCode=" + methodCode + ", methodName=" + methodName + "]";
	}
}
