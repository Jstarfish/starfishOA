package cls.taishan.web.service;

import cls.taishan.web.model.control.WingSearchInputParam;
import cls.taishan.web.model.control.WingSearchOutputParam;

public interface WingSearchService {
	public int doSearch(WingSearchInputParam in, WingSearchOutputParam out);
}
