package cls.taishan.common.exception;

public class ConnectTimeoutException extends Exception{

	private static final long serialVersionUID = 1090593898377937190L;

	public ConnectTimeoutException() {
		super();
	}

	public ConnectTimeoutException(String msg) {
		super(msg);
	}

	public ConnectTimeoutException(Throwable e) {
		super(e);
	}

	public ConnectTimeoutException(String msg, Throwable e) {
		super(msg, e);
	}
}
