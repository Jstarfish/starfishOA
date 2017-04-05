package cls.taishan.web.issue.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import cls.taishan.common.constants.EnumConfig;
import cls.taishan.common.entity.BasePageResult;
import cls.taishan.common.utils.LocaleUtil;
import cls.taishan.web.issue.form.IssueForm;
import cls.taishan.web.issue.model.Issue;
import cls.taishan.web.issue.service.IssueService;
import cls.taishan.web.order.model.Game;
import cls.taishan.web.order.service.OrderService;
import lombok.extern.log4j.Log4j;


@Log4j
@Controller
@RequestMapping("/issue")
public class IssueController {

	@Autowired
	private IssueService issueService;
	
	@Autowired
	private OrderService orderService;
	
	private Map<Integer, String> issueStatus = new HashMap<Integer, String>();
	
	@ModelAttribute("issueStatus")
	public Map<Integer, String> getIssueStatus(HttpServletRequest request,ModelMap model) {

		if (request != null)
			this.issueStatus = LocaleUtil.getUserLocaleEnum("issueStatus", request);
		return issueStatus;
	}

	@RequestMapping(params = "method=initIssueList")
	public String initIssueList(HttpServletRequest request,ModelMap model) {
		
		List<Game> gameList = orderService.getGameList();
		model.addAttribute("gameList",gameList);
		return LocaleUtil.getUserLocalePath("issue/issueList", request);
	}

	@ResponseBody
	@RequestMapping(params = "method=issueList")
	public Object issueList(HttpServletRequest request, ModelMap model, IssueForm form) {
		BasePageResult<Issue> result = new BasePageResult<Issue>();
		try {
			int totalCount = issueService.getIssueCount(form);
			if (totalCount > 0) {
				form.setBeginNum(((form.getPageindex() - 1) * form.getPageSize()));
				form.setEndNum((form.getPageindex() * form.getPageSize()));
			} else {
				form.setBeginNum(0);
				form.setEndNum(0);
			}
			List<Issue> issue = issueService.getIssueList(form);
			result.setResult(issue);
			result.setTotalCount(totalCount);
		} catch (Exception e) {
			log.error("期次查询错误",e);
		}
		return result;
	}

}
