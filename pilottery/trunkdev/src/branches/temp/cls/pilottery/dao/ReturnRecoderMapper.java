package cls.pilottery.dao;

import cls.pilottery.model.ReturnRecoder;

public interface ReturnRecoderMapper {
    int deleteByPrimaryKey(String returnNo);

    int insert(ReturnRecoder record);

    int insertSelective(ReturnRecoder record);

    ReturnRecoder selectByPrimaryKey(String returnNo);

    int updateByPrimaryKeySelective(ReturnRecoder record);

    int updateByPrimaryKey(ReturnRecoder record);
}