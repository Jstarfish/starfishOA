package cls.taishan.web.report.dao;

import cls.taishan.system.model.*;
import cls.taishan.web.report.form.ReportForm;
import cls.taishan.web.report.model.DayReport;
import cls.taishan.web.report.model.Dealer;
import cls.taishan.web.report.model.IssueChlReport;
import cls.taishan.web.report.model.IssueSysReport;
import cls.taishan.web.report.model.MonthReport;

import org.apache.ibatis.annotations.Select;
import org.springframework.stereotype.Service;

import java.util.List;

/**
 * Created by Reno Main on 2016/10/9.
 */
@Service
public interface ReportDao {

    Integer getChannelDayCount(ReportForm form);

    List<DayReport> getChannelDayReport(ReportForm form);

    Integer getChannelMonthCount(ReportForm form);

    List<MonthReport> getChannelMonthReport(ReportForm form);

    Integer getIssueChlCount(ReportForm form);

    List<IssueChlReport> getIssueChlReport(ReportForm form);

    Integer getIssueSysCount(ReportForm form);

    List<IssueSysReport> getIssueSysReport(ReportForm form);

    List<Dealer> queryDealerList();
}
