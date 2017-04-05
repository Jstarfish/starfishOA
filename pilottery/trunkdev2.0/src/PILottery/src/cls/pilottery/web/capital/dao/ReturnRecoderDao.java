package cls.pilottery.web.capital.dao;

import java.util.List;

import cls.pilottery.web.capital.form.ReturnRecoderForm;
import cls.pilottery.web.capital.model.returnmodel.ReturnRecoder;

public interface ReturnRecoderDao {

	// 总记录数
	public Integer getReturnCount(ReturnRecoderForm returnRecoderForm);

	// 每页显示的List
	public List<ReturnRecoder> getReturnList(ReturnRecoderForm returnRecoderForm);

	// 审批初始化 查询所需信息
	public ReturnRecoder getReturnInfoById(String returnNo);

	// 还货审批 更新申请状态
	public void updateReturnApproval(ReturnRecoder returnRecoder);
}
