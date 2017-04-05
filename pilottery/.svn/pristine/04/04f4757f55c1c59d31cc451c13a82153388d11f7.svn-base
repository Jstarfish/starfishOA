package cls.taishan.web.service.Impl;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import cls.taishan.web.jtdao.Impl.WingSearchDAOImpl;
import cls.taishan.web.model.control.WingSearchInputParam;
import cls.taishan.web.model.control.WingSearchOutputParam;
import cls.taishan.web.service.WingSearchService;

@Service
public class WingSearchServiceImpl implements WingSearchService {
	
	@Autowired
	private WingSearchDAOImpl searchDaoImpl;
	
	@Override
	public int doSearch(WingSearchInputParam in, WingSearchOutputParam out) {
		return searchDaoImpl.searchTrade(in, out);
	}

}
