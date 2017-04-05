package cls.pilottery.common.utils;

import java.io.BufferedWriter;
import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.OutputStreamWriter;
import java.util.ArrayList;
import java.util.Iterator;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.Map.Entry;

import javax.servlet.http.HttpServletResponse;

import org.apache.commons.beanutils.BeanUtils;

public class CSVUtils {
	/**
	 * 导出为CVS文件
	 * 
	 * @param exportData
	 */
	public synchronized static File createCSVFile(List<Map<String,String>> exportData,
			LinkedHashMap<String, String> rowMapper, String outPutPath) {
		File csvFile = null;
		BufferedWriter csvFileOutputStream = null;
		try {
			csvFile = File.createTempFile("temp", ".csv", new File(outPutPath));
			// GB2312使正确读取分隔符","
			csvFileOutputStream = new BufferedWriter(new OutputStreamWriter(
					new FileOutputStream(csvFile), "GB2312"), 1024);
			// 写入文件头部
			for (Iterator<Entry<String,String>> propertyIterator = rowMapper.entrySet().iterator(); propertyIterator
					.hasNext();) {
				Entry<String,String> propertyEntry = propertyIterator.next();
				csvFileOutputStream.write("\""+ propertyEntry.getValue().toString() + "\"");
				if (propertyIterator.hasNext()) {
					csvFileOutputStream.write(",");
				}
			}
			csvFileOutputStream.newLine();
			// 写入文件内容
			for (Iterator<Map<String,String>> iterator = exportData.iterator(); iterator.hasNext();) {
				   Object row = iterator.next();
				for (Iterator<Entry<String,String>> propertyIterator = rowMapper.entrySet().iterator(); propertyIterator.hasNext();) {
					Entry<String,String> propertyEntry = propertyIterator.next();
					csvFileOutputStream.write("\""+ BeanUtils.getProperty(row,propertyEntry.getKey().toString())
									.toString() + "\"");
					if (propertyIterator.hasNext()) {
						csvFileOutputStream.write(",");
					}
				}
				if (iterator.hasNext()) {
					csvFileOutputStream.newLine();
				}
			}
			csvFileOutputStream.flush();
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			try {
				csvFileOutputStream.close();
			} catch (IOException e) {
				e.printStackTrace();
			}
		}
		return csvFile;
	}

	/**
	 * 导出为CSV文件
	 * 
	 * @param response
	 * @param exportData
	 * @param propertyNames
	 * @param fileName
	 * @param outputPath
	 * @throws FileNotFoundException
	 */
	public static void exportToCSVFile(HttpServletResponse response,
			List<Map<String,String>> exportData, LinkedHashMap<String,String> rowMapper, String fileName,
			String outputPath) throws FileNotFoundException {
		File csvFile = createCSVFile(exportData, rowMapper, outputPath);
		csvFile.delete();
	}

	public static void main(String[] args) {
		List<Map<String,String>> exportData = new ArrayList<Map<String,String>>();
		Map<String, String> row1 = new LinkedHashMap<String, String>();
		row1.put("1", "华彩科技");
		row1.put("2", "中关村融科资讯大厦A座");
		row1.put("3", "柬埔寨彩票");
		row1.put("4", "10");
		exportData.add(row1);
		row1 = new LinkedHashMap<String, String>();
		row1.put("1", "华彩科技");
		row1.put("2", "中关村融科资讯大厦A座");
		row1.put("3", "上海彩票");
		row1.put("4", "n...");
		exportData.add(row1);
		LinkedHashMap<String,String> headerMap = new LinkedHashMap<String,String>();
		headerMap.put("1", "公司名称");
		headerMap.put("2", "地址");
		headerMap.put("3", "项目");
		headerMap.put("4", "人数");
		CSVUtils.createCSVFile(exportData, headerMap, "F:/");
	}
}

