package cls.taishan.cncp.cmi.service;

import cls.taishan.cncp.cmi.dao.TransFerDao;
import cls.taishan.cncp.cmi.entity.Res5004Model;
import cls.taishan.cncp.cmi.model.*;

import javax.inject.Inject;

import lombok.extern.log4j.Log4j;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * Created by Reno Main on 2016/9/13.
 */
@Log4j
@javax.inject.Singleton
public class TransFerService {
    @Inject
    private TransFerDao transFerDao;

    public long getNextSeq() {
        return transFerDao.getNextSeq();
    }

    public void lotteryBet(Req1002Msg paraMap) {
        transFerDao.lotteryBet(paraMap);
    }

    public Res5003Msg lotteryQuery(String ticketId){
       return transFerDao.lotteryQuery(ticketId);
    }

    public List<Res5004Model> payOffQuery(String game, Integer issue){
        Map<String,Object> paraMap = new HashMap<String,Object>();
        paraMap.put("game",game);
        paraMap.put("issue",issue);
        return transFerDao.payOffQuery(paraMap);
    }

    public void updateLottery(String ticketId,String tsn,boolean success,String errorMsg){
        Map<String,Object> paramMap = new HashMap<String,Object>();
        paramMap.put("ticketId",ticketId);
        paramMap.put("responseCode",0);
        paramMap.put("responseMsg","");
        paramMap.put("errorMsg",errorMsg);
        if(success){
            //出票成功
        	paramMap.put("tsn",tsn);
        	log.info("执行存储过程：p_cncp_ticket_succ");
            transFerDao.updateLotterySuccess(paramMap);
        }else{
            //出票失败
        	log.info("执行存储过程：p_cncp_ticket_fail");
            transFerDao.updateLotteryFail(paramMap);
        }
        log.info("执行结果:[responseCode:"+paramMap.get("responseCode")+",responseMsg:"+paramMap.get("responseMsg")+"]");
        
    }

    public String queryGameName(Integer gameCode){
        return transFerDao.queryGameName(gameCode);
    }

	public int getOrderCountByTicketId(String ticketId) {
		return transFerDao.getOrderCountByTicketId(ticketId);
	}

}
