package cls.pilottery.dao;

import cls.pilottery.model.ItemIssueDetail;
import cls.pilottery.model.ItemIssueDetailKey;

public interface ItemIssueDetailMapper {
    int deleteByPrimaryKey(ItemIssueDetailKey key);

    int insert(ItemIssueDetail record);

    int insertSelective(ItemIssueDetail record);

    ItemIssueDetail selectByPrimaryKey(ItemIssueDetailKey key);

    int updateByPrimaryKeySelective(ItemIssueDetail record);

    int updateByPrimaryKey(ItemIssueDetail record);
}