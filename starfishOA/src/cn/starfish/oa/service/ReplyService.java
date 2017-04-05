package cn.starfish.oa.service;

import java.util.List;

import cn.starfish.oa.base.DaoSupport;
import cn.starfish.oa.domain.PageBean;
import cn.starfish.oa.domain.Reply;
import cn.starfish.oa.domain.Topic;

public interface ReplyService extends DaoSupport<Reply> {

	/**
	 * 查询指定主题中所有的回复列表，排序：按发表时间升序排列。
	 * 
	 * @param topic
	 * @return
	 */
	@Deprecated
	List<Reply> findByTopic(Topic topic);

	/**
	 * 查询分页信息
	 * 
	 * @param pageNum
	 * @param pageSize
	 * @param topic
	 * @return
	 */
	@Deprecated
	PageBean getPageBeanByTopic(int pageNum, int pageSize, Topic topic);

}
