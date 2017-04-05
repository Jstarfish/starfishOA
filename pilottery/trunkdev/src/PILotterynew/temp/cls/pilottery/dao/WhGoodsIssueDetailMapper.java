package cls.pilottery.dao;

import cls.pilottery.model.WhGoodsIssueDetail;
import cls.pilottery.model.WhGoodsIssueDetailKey;

public interface WhGoodsIssueDetailMapper {
    int deleteByPrimaryKey(WhGoodsIssueDetailKey key);

    int insert(WhGoodsIssueDetail record);

    int insertSelective(WhGoodsIssueDetail record);

    WhGoodsIssueDetail selectByPrimaryKey(WhGoodsIssueDetailKey key);

    int updateByPrimaryKeySelective(WhGoodsIssueDetail record);

    int updateByPrimaryKey(WhGoodsIssueDetail record);
}