package cls.pilottery.pos.common.interceptior;

import java.io.IOException;
import java.io.InputStream;
import java.util.Arrays;

import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.log4j.Logger;
import org.springframework.web.servlet.HandlerInterceptor;
import org.springframework.web.servlet.ModelAndView;

import com.itextpdf.text.pdf.codec.Base64.OutputStream;

import cls.pilottery.common.utils.TEAUtil;
import cls.pilottery.common.utils.ZipUtil;
import cls.pilottery.pos.common.constants.PosConstant;
import cls.pilottery.pos.common.model.BaseResponse;

/*
 * 实现对请求参数的加密解密功能
 */
public class EncryptAndZipInterceptor implements HandlerInterceptor {
	private static Logger log = Logger.getLogger(EncryptAndZipInterceptor.class); 
	/*
	 * 返回false时请求结束
	 */
	@Override
	public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler)  {
		try {
			byte[] bytes = new byte[1024 * 1024];
			InputStream is = request.getInputStream();
			int nRead = 1;
			int nTotalRead = 0;
			while (nRead > 0) {
				nRead = is.read(bytes, nTotalRead, bytes.length - nTotalRead);
				if (nRead > 0){
					nTotalRead = nTotalRead + nRead;
				}
			}
			byte[] result = Arrays.copyOf(bytes, nTotalRead);
			
			//log.debug("接收到的原始请求数据为："+Arrays.toString(result));
			log.debug("对请求数据进行解密...");
			byte[] deResult = TEAUtil.decryptByTea(result);
			//log.debug("解密后的数据为："+Arrays.toString(deResult));
			
			log.debug("对请求数据进行解压缩...");
			byte[] uzResult = ZipUtil.infater(deResult);
			//log.debug("解压之后的数据为："+Arrays.toString(uzResult));
			
			request.setAttribute("req", new String(uzResult,PosConstant.CHAR_SET));
			
		} catch (IOException e) {
			e.printStackTrace();
			log.error("对请求数据进行解密和解压缩时出现异常！", e);
			BaseResponse res = new BaseResponse(10500);
			request.setAttribute("res", res);
			return true;
		}
		return true;
	}
	
	@Override
	public void postHandle(HttpServletRequest request, HttpServletResponse response, Object handler, ModelAndView model) throws Exception {
		String res = (String)request.getAttribute("res");
		log.debug("对响应数据进行压缩...");
		byte[] zipBytes = ZipUtil.deflater(res.getBytes("utf-8"));
		//log.debug("压缩响应json成功，压缩后数据为："+Arrays.toString(zipBytes));
		log.debug("对响应数据进行加密...");
		byte[] enBytes = TEAUtil.encryptByTea(zipBytes);
		//log.debug("加密成功，加密后的字节数组为："+Arrays.toString(enBytes));
		
		ServletOutputStream out = response.getOutputStream();
		out.write(enBytes);
		out.flush();
	}
	
	@Override
	public void afterCompletion(HttpServletRequest request, HttpServletResponse response, Object handler, Exception exception) throws Exception {
		
	}

}
