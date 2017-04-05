package cls.pilottery.pos.system.dao;

import java.util.List;

import cls.pilottery.pos.system.model.wh.InstoreRecord070001Res;

public interface WhManagerDao {

	List<InstoreRecord070001Res> getInstorRecordList(String orgCode);

}
