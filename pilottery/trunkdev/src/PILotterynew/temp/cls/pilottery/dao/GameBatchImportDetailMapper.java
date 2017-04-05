package cls.pilottery.dao;

import cls.pilottery.model.GameBatchImportDetail;

public interface GameBatchImportDetailMapper {
    int deleteByPrimaryKey(String importNo);

    int insert(GameBatchImportDetail record);

    int insertSelective(GameBatchImportDetail record);

    GameBatchImportDetail selectByPrimaryKey(String importNo);

    int updateByPrimaryKeySelective(GameBatchImportDetail record);

    int updateByPrimaryKey(GameBatchImportDetail record);
}