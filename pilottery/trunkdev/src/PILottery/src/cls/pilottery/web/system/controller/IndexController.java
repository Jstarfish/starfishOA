package cls.pilottery.web.system.controller;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

@Controller
@RequestMapping("index")
public class IndexController {
    @RequestMapping(params = "method=mainRequest")
    public String mainRequest(HttpServletRequest request,HttpServletResponse response) {
        return "_main/main";
    }

    @RequestMapping(params="method=logout")
    public String logout(HttpServletRequest request,HttpServletResponse response) {
        
        try {
            request.getSession().invalidate();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return "login";
    }
    
    @RequestMapping
    public String index(HttpServletRequest request,HttpServletResponse response) {
        return "login";
    }

}
