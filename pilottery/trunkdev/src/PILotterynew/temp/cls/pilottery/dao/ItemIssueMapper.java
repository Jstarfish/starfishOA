package cls.pilottery.dao;

import cls.pilottery.model.ItemIssue;

public interface ItemIssueMapper {
    int deleteByPrimaryKey(String iiNo);

    int insert(ItemIssue record);

    int insertSelective(ItemIssue record);

    ItemIssue selectByPrimaryKey(String iiNo);

    int updateByPrimaryKeySelective(ItemIssue record);

    int updateByPrimaryKey(ItemIssue record);
}