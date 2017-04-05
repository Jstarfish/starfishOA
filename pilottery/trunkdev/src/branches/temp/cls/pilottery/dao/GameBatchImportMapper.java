package cls.pilottery.dao;

import cls.pilottery.model.GameBatchImport;

public interface GameBatchImportMapper {
    int deleteByPrimaryKey(String importNo);

    int insert(GameBatchImport record);

    int insertSelective(GameBatchImport record);

    GameBatchImport selectByPrimaryKey(String importNo);

    int updateByPrimaryKeySelective(GameBatchImport record);

    int updateByPrimaryKey(GameBatchImport record);
}