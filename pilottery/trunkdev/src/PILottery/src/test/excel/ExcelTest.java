package test.excel;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

import org.apache.poi.openxml4j.exceptions.InvalidFormatException;
import org.junit.Test;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import cls.pilottery.common.excel.enty.MyTest;
import cls.pilottery.common.excel.utils.ExcelUtil;


public class ExcelTest {
	   private static final Logger LOG = LoggerFactory.getLogger(ExcelTest.class);

	    @Test
	    public void test() {
	        try {
	            createExcel();
	        } catch (IOException e) {
	            LOG.error("异常", e);
	        } catch (InvalidFormatException e) {
	            LOG.error("异常", e);
	        }
	    }

	    private void createExcel() throws IOException, InvalidFormatException {
	    	
	    	   List<MyTest> tests=new ArrayList<MyTest>();
	           for(int i=0;i<100;i++){
	           MyTest test1=new MyTest();
	           test1.setAddress("北京"+i);
	           test1.setLat(100*i);
	           test1.setName("yyh"+i);
	           test1.setPhone("139"+i);
	           test1.setType(i);
	           tests.add(test1);
	           }
	           if (null != tests && !tests.isEmpty()) {
	           ExcelUtil create = new ExcelUtil("E:/data2.xlsx");
	            create.setSheetName("活动信息数据");
	            boolean result = create.createExcel(tests);
	            LOG.debug("结果:{}", result);
	            create.close();
	            
	        } else {
	            LOG.debug("没有结果");
	        }
	      
	    }
}
