package cls.taishan.web.report.service.impl;

import cls.taishan.system.model.*;
import cls.taishan.web.report.dao.ReportDao;
import cls.taishan.web.report.form.ReportForm;
import cls.taishan.web.report.model.DayReport;
import cls.taishan.web.report.model.Dealer;
import cls.taishan.web.report.model.IssueChlReport;
import cls.taishan.web.report.model.IssueSysReport;
import cls.taishan.web.report.model.MonthReport;
import cls.taishan.web.report.service.ReportService;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

/**
 * Created by Reno Main on 2016/10/9.
 */
@Service
public class ReportServiceImpl implements ReportService {

    @Autowired
    private ReportDao reportDao;

    @Override
    public Integer getChannelDayCount(ReportForm form) {
        return reportDao.getChannelDayCount(form);
    }

    @Override
    public List<DayReport> getChannelDayReport(ReportForm form) {
        return reportDao.getChannelDayReport(form);
    }

    @Override
    public Integer getChannelMonthCount(ReportForm form) {
        return reportDao.getChannelMonthCount(form);
    }

    @Override
    public List<MonthReport> getChannelMonthReport(ReportForm form) {
        return reportDao.getChannelMonthReport(form);
    }

    @Override
    public Integer getIssueChlCount(ReportForm form) {
        return reportDao.getIssueChlCount(form);
    }

    @Override
    public List<IssueChlReport> getIssueChlReport(ReportForm form) {
        return reportDao.getIssueChlReport(form);
    }

    @Override
    public Integer getIssueSysCount(ReportForm form) {
        return reportDao.getIssueSysCount(form);
    }

    @Override
    public List<IssueSysReport> getIssueSysReport(ReportForm form) {
        return reportDao.getIssueSysReport(form);
    }

    @Override
    public List<Dealer> queryDealerList() {
        return reportDao.queryDealerList();
    }
}
