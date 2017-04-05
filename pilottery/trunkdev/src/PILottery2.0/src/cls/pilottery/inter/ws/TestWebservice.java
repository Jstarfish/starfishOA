package cls.pilottery.inter.ws;

import java.util.List;

import javax.jws.WebMethod;
import javax.jws.WebService;
import javax.jws.soap.SOAPBinding;
import javax.jws.soap.SOAPBinding.Style;
import javax.xml.ws.Endpoint;

import org.springframework.beans.factory.annotation.Autowired;

import cls.pilottery.web.system.form.UserForm;
import cls.pilottery.web.system.model.User;
import cls.pilottery.web.system.service.UserService;

import com.alibaba.fastjson.JSON;

@WebService
@SOAPBinding(style=Style.RPC)
public class TestWebservice {
	
	@Autowired
	private UserService userService;
	
	@WebMethod
	public String login(String reqParam){
		return "success";
	}
	
	@WebMethod
	public String userList(){
		UserForm userForm = new UserForm();
		userForm.setBeginNum(0);
		userForm.setEndNum(100);
		List<User> list = userService.getUserList(userForm);
		return JSON.toJSONString(list);
	}
	
	public static void main(String[] args) {
		try {
			TestWebservice ws = new TestWebservice();
			Endpoint.publish("http://localhost:8081/test", ws);
			System.out.println("webservice published");
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
}
