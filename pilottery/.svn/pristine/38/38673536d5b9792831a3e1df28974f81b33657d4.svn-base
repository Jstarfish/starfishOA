package cls.taishan.web.jtdao.Impl;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpMethod;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Repository;
import org.springframework.web.client.RestTemplate;

import cls.taishan.common.constants.SysConstants;
import cls.taishan.common.utils.PropertiesUtil;
import cls.taishan.web.jtdao.WingRestDAO;
import cls.taishan.web.model.rest.WingBaseRes;
import lombok.extern.log4j.Log4j;

@Log4j
@Repository
public class WingRestDAOImpl implements WingRestDAO {
	
	@Autowired
	private RestTemplate restTemplate;

	@Override
	public WingBaseRes loginRest(String in) {
		WingBaseRes out = new WingBaseRes();
		String url = PropertiesUtil.readValue("wing.url") + PropertiesUtil.readValue("wing.login_uri");

		HttpHeaders headers = new HttpHeaders();
		headers.add("Content-Type", "application/x-www-form-urlencoded");
		
		out = doRest(in, url, headers);
		
		return out;
	}


	@Override
	public WingBaseRes validateRest(String in, String token) {
		WingBaseRes out = new WingBaseRes();
		String url = PropertiesUtil.readValue("wing.url") + PropertiesUtil.readValue("wing.validate_uri");

		HttpHeaders headers = new HttpHeaders();
		headers.add("Content-Type", "application/json");
		headers.add("Authorization", "Bearer " + token);

		out = doRest(in, url, headers);

		return out;
	}

	@Override
	public WingBaseRes commitRest(String token) {
		WingBaseRes out = new WingBaseRes();
		String url = PropertiesUtil.readValue("wing.url") + PropertiesUtil.readValue("wing.commit_uri");

		HttpHeaders headers = new HttpHeaders();
		headers.add("Content-Type", "application/json");
		headers.add("Authorization", "Bearer " + token);

		out = doRest("{}", url, headers);

		return out;

	}

	@Override
	public WingBaseRes transMoneyRest(String in, String token) {
		WingBaseRes out = new WingBaseRes();
		String url = PropertiesUtil.readValue("wing.url") + PropertiesUtil.readValue("wing.transmoney_uri");

		HttpHeaders headers = new HttpHeaders();
		headers.add("Content-Type", "application/json");
		headers.add("Authorization", "Bearer " + token);

		out = doRest(in, url, headers);

		return out;
	}
	
	private WingBaseRes doRest(String json, String url, HttpHeaders headers) {

		HttpStatus status;
		HttpEntity<String> requestEntity;
		ResponseEntity<String> responseEntity = null;
		int httpStatusCode;
		String baseMessage = "<Access Wing REST Service> ";
		String errorMessage = "";
		WingBaseRes out = new WingBaseRes();

		// 组装请求信息
		requestEntity = new HttpEntity<String>(json, headers);

		log.info("<Access Wing REST Service> Wing URL is: " + url);

		try {
			responseEntity = restTemplate.exchange(url, HttpMethod.POST, requestEntity, String.class);
		} catch (Exception e) {
			e.printStackTrace();
			
			String err = e.toString();

			if (err.toLowerCase().contains("connection timed out")) {
				errorMessage = String.format("URL [%s] Connection timed out", url);
				log.error(baseMessage + errorMessage);
				out.setErrorMessage(errorMessage);
				out.setErrorCode(SysConstants.WING_REST_TIMEOUT);
				return out;
			} else {
				if (err.length() > 100) err = err.substring(1, 100);
				errorMessage = String.format("URL [%s] other connection error. [%s]", url, err);
				log.error(baseMessage + errorMessage);
				out.setErrorMessage(errorMessage);
				out.setErrorCode(SysConstants.WING_REST_CONNECTION);
				return out;
			}
		}

		String body = responseEntity.getBody();
		log.info(baseMessage + String.format("URL [%s] response: [%s]", url, body));
		
		status = responseEntity.getStatusCode();
		httpStatusCode = status.value();

		if (httpStatusCode != 200) {
			errorMessage = String.format("URL [%s] Wing return error: [%s]", url, body);
			log.error(baseMessage + errorMessage);
			out.setHttpStatus(httpStatusCode);
			out.setErrorMessage(errorMessage);
			out.setErrorCode(SysConstants.WING_REST_RETURN_ERROR);
			return out;
		}	
		
		out.setHttpStatus(httpStatusCode);
		out.setErrorMessage(errorMessage);
		out.setErrorCode(SysConstants.WING_REST_SUCC);
		out.setJsonString(body);

		return out;

	}
}
