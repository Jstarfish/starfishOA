package cls.pilottery.dao;

import cls.pilottery.model.WhCpNomatchDetail;
import cls.pilottery.model.WhCpNomatchDetailKey;

public interface WhCpNomatchDetailMapper {
    int deleteByPrimaryKey(WhCpNomatchDetailKey key);

    int insert(WhCpNomatchDetail record);

    int insertSelective(WhCpNomatchDetail record);

    WhCpNomatchDetail selectByPrimaryKey(WhCpNomatchDetailKey key);

    int updateByPrimaryKeySelective(WhCpNomatchDetail record);

    int updateByPrimaryKey(WhCpNomatchDetail record);
}