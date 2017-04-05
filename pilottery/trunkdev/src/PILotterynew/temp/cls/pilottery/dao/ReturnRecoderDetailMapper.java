package cls.pilottery.dao;

import cls.pilottery.model.ReturnRecoderDetail;
import cls.pilottery.model.ReturnRecoderDetailKey;

public interface ReturnRecoderDetailMapper {
    int deleteByPrimaryKey(ReturnRecoderDetailKey key);

    int insert(ReturnRecoderDetail record);

    int insertSelective(ReturnRecoderDetail record);

    ReturnRecoderDetail selectByPrimaryKey(ReturnRecoderDetailKey key);

    int updateByPrimaryKeySelective(ReturnRecoderDetail record);

    int updateByPrimaryKey(ReturnRecoderDetail record);
}