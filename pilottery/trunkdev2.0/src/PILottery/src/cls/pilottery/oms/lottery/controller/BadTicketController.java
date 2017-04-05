package cls.pilottery.oms.lottery.controller;

import cls.pilottery.common.EnumConfigEN;
import cls.pilottery.common.constants.SysConstants;
import cls.pilottery.common.utils.LocaleUtil;
import cls.pilottery.common.utils.PageUtil;
import cls.pilottery.oms.lottery.form.BadTicketForm;
import cls.pilottery.oms.lottery.form.SaleGamepayinfoForm;
import cls.pilottery.oms.lottery.model.BadTicket;
import cls.pilottery.oms.lottery.model.Betinfo;
import cls.pilottery.oms.lottery.service.BadTicketService;
import cls.pilottery.oms.lottery.service.ExpirydateService;
import cls.pilottery.oms.lottery.vo.SaleGamepayinfoVo;
import cls.pilottery.web.system.model.User;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;

import javax.servlet.http.HttpServletRequest;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

/**
 * Created by Reno Main on 2016/5/19.
 */
@Controller
@RequestMapping("badticketquery")
public class BadTicketController {

    @Autowired
    private BadTicketService badTicketService;


    /**
     * 列表查询 数据分页处理
     */
    @RequestMapping(params = "method=badticketlist")
    public String badticket(HttpServletRequest request, ModelMap model, BadTicketForm badTicketForm) {
        model.addAttribute("pageDataList", new ArrayList<BadTicket>());
        model.addAttribute("pageStr", PageUtil.getPageStr(request, 0));
        return LocaleUtil.getUserLocalePath("oms/badticket/badticketlist", request);
    }
        /**
         * 列表查询 数据分页处理
         */
    @RequestMapping(params = "method=badticketquery")
    public String badticketQuerylist(HttpServletRequest request, ModelMap model, BadTicketForm badTicketForm) {

        Integer count = this.badTicketService.queryBadTicketCount(badTicketForm);
        List<BadTicket> badTicketList = new ArrayList<BadTicket>();
        int pageIndex = PageUtil.getPageIndex(request);
        if (count != null && count.intValue() > 0) {
            badTicketForm.setBeginNum((pageIndex - 1) * PageUtil.pageSize);
            badTicketForm.setEndNum((pageIndex - 1) * PageUtil.pageSize + PageUtil.pageSize);
            badTicketList = badTicketService.queryBadTicket(badTicketForm);
            if (badTicketList != null && badTicketList.size() > 0) {
                for (int i = 0; i < badTicketList.size(); i++) {
                    List<Betinfo> betInfo = badTicketList.get(i).getBetlist();
                    StringBuffer betStr = new StringBuffer("");
                    if (betInfo != null && betInfo.size() > 0) {
                        for (int j = 0; j < betInfo.size(); j++) {
                            if (j >= 1) {
                                betStr.append("\r\n");
                            }
                            betStr.append("/").append(betInfo.get(j).getPlay());
                            betStr.append("/").append(betInfo.get(j).getBettingnumber());
                            betStr.append("/").append(betInfo.get(j).getMultiple());
                            betStr.append("/").append(betInfo.get(j).getLineAmount());

                            badTicketList.get(i).setBetlistStr(betStr.toString());
                        }
                    }
                }
            }
        }

        model.addAttribute("pageDataList", badTicketList);
        model.addAttribute("pageStr", PageUtil.getPageStr(request, count));
        model.addAttribute("badTicketForm", badTicketForm);

        return LocaleUtil.getUserLocalePath("oms/badticket/badticketlist", request);
    }

}
