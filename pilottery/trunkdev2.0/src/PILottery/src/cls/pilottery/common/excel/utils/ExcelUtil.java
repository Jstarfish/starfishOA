package cls.pilottery.common.excel.utils;

import java.io.ByteArrayOutputStream;
import java.io.Closeable;
import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.lang.reflect.Field;
import java.math.BigDecimal;
import java.net.URLEncoder;
import java.text.DateFormat;
import java.text.DecimalFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Collection;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.TreeMap;

import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.poi.hssf.usermodel.HSSFCell;
import org.apache.poi.hssf.usermodel.HSSFCellStyle;
import org.apache.poi.hssf.usermodel.HSSFFont;
import org.apache.poi.hssf.usermodel.HSSFRow;
import org.apache.poi.hssf.usermodel.HSSFSheet;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.apache.poi.openxml4j.exceptions.InvalidFormatException;
import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.DateUtil;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.Sheet;
import org.apache.poi.ss.usermodel.Workbook;
import org.apache.poi.ss.usermodel.WorkbookFactory;
import org.apache.poi.ss.util.CellRangeAddress;
import org.apache.poi.ss.util.CellReference;
import org.apache.poi.ss.util.RegionUtil;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import cls.pilottery.common.constants.SysConstants;
import cls.pilottery.oms.report.model.MisReport3136;
import cls.pilottery.web.system.model.User;
import cls.pilottery.web.system.model.UserLanguage;

public final class ExcelUtil implements Closeable {
	private static final Logger LOG = LoggerFactory.getLogger(ExcelUtil.class);
	/**
	 * 时日类型的数据默认格式化方式
	 */
	private DateFormat format = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
	private int startRow;
	private String sheetName;
	private String excelFilePath;
	private Workbook workbook;

	/**
	 * 构造方法，传入需要操作的excel文件路径
	 * 
	 * @param excelFilePath
	 *            需要操作的excel文件的路径
	 * @throws IOException
	 *             IO流异常
	 * @throws InvalidFormatException
	 *             非法的格式异常
	 */
	public ExcelUtil(String excelFilePath) throws IOException, InvalidFormatException {
		this.startRow = 0;
		this.sheetName = "Sheet1";
		this.excelFilePath = excelFilePath;
		this.workbook = createWorkbook();
	}

	/**
	 * 构造方法，传入需要操作的excel文件路径
	 * 
	 * @param excelFilePath
	 *            需要操作的excel文件的路径
	 * @throws IOException
	 *             IO流异常
	 * @throws InvalidFormatException
	 *             非法的格式异常
	 */
	public ExcelUtil() throws IOException, InvalidFormatException {
		this.startRow = 0;
		this.sheetName = "Sheet1";
		this.excelFilePath = "";
		this.workbook = createWorkbook();
	}

	/**
	 * 通过数据流操作excel，仅用于读取数据
	 * 
	 * @param inputStream
	 *            excel数据流
	 * @throws IOException
	 *             IO流异常
	 * @throws InvalidFormatException
	 *             非法的格式异常
	 */
	public ExcelUtil(InputStream inputStream) throws IOException, InvalidFormatException {
		this.startRow = 0;
		this.sheetName = "Sheet1";
		this.excelFilePath = "";
		this.workbook = WorkbookFactory.create(inputStream);
	}

	/**
	 * 通过数据流操作excel
	 * 
	 * @param inputStream
	 *            excel数据流
	 * @param outFilePath
	 *            输出的excel文件路径
	 * @throws IOException
	 *             IO流异常
	 * @throws InvalidFormatException
	 *             非法的格式异常
	 */
	public ExcelUtil(InputStream inputStream, String outFilePath) throws IOException, InvalidFormatException {
		this.startRow = 0;
		this.sheetName = "Sheet1";
		this.excelFilePath = outFilePath;
		this.workbook = WorkbookFactory.create(inputStream);
	}

	/**
	 * 开始读取的行数，这里指的是标题内容行的行数，不是数据开始的那行
	 * 
	 * @param startRow
	 *            开始行数
	 */
	public void setStartRow(int startRow) {
		if (startRow < 1) {
			throw new RuntimeException("最小为1");
		}
		this.startRow = --startRow;
	}

	/**
	 * 设置需要读取的sheet名字，不设置默认的名字是Sheet1，也就是excel默认给的名字，所以如果文件没有自已修改，这个方法也就不用调了
	 * 
	 * @param sheetName
	 *            需要读取的Sheet名字
	 */
	public void setSheetName(String sheetName) {
		// Sheet sheet = this.workbook.getSheet(sheetName);
		// if (null == sheet) {
		// throw new RuntimeException("sheetName:" + sheetName + " is not exist");
		// }
		this.sheetName = sheetName;
	}

	/**
	 * 设置时间数据格式
	 * 
	 * @param format
	 *            格式
	 */
	public void setFormat(String format) {
		this.format = new SimpleDateFormat(format);
	}

	/**
	 * 解析读取excel文件
	 * 
	 * @param clazz
	 *            对应的映射类型
	 * @param <T>
	 *            泛型
	 * @return 读取结果
	 */
	public <T> List<T> parse(Class<T> clazz) {
		List<T> resultList = null;
		try {
			Sheet sheet = workbook.getSheet(this.sheetName);
			if (null != sheet) {
				resultList = new ArrayList<T>(sheet.getLastRowNum() - 1);
				Row row = sheet.getRow(this.startRow);

				Map<String, Field> fieldMap = new HashMap<String, Field>();
				Map<String, String> titleMap = new HashMap<String, String>();

				Field[] fields = clazz.getDeclaredFields();
				// 这里开始处理映射类型里的注解
				for (Field field : fields) {
					if (field.isAnnotationPresent(MapperCell.class)) {
						MapperCell mapperCell = field.getAnnotation(MapperCell.class);
						fieldMap.put(mapperCell.cellName(), field);
					}
				}

				for (Cell title : row) {
					CellReference cellRef = new CellReference(title);
					titleMap.put(cellRef.getCellRefParts()[2], title.getRichStringCellValue().getString());
				}

				for (int i = this.startRow + 1; i <= sheet.getLastRowNum(); i++) {
					T t = clazz.newInstance();
					Row dataRow = sheet.getRow(i);
					for (Cell data : dataRow) {
						CellReference cellRef = new CellReference(data);
						String cellTag = cellRef.getCellRefParts()[2];
						String name = titleMap.get(cellTag);
						Field field = fieldMap.get(name);
						if (null != field) {
							field.setAccessible(true);
							getCellValue(data, t, field);
						}
					}
					resultList.add(t);
				}
			} else {
				throw new RuntimeException("sheetName:" + this.sheetName + " is not exist");
			}
		} catch (InstantiationException e) {

		} catch (IllegalAccessException e) {

		} catch (ParseException e) {

		} catch (Exception e) {

		}
		return resultList;
	}

	private void getCellValue(Cell cell, Object o, Field field) throws IllegalAccessException, ParseException {
		switch (cell.getCellType()) {
		case Cell.CELL_TYPE_BLANK:
			break;
		case Cell.CELL_TYPE_BOOLEAN:
			field.setBoolean(o, cell.getBooleanCellValue());
			break;
		case Cell.CELL_TYPE_ERROR:
			field.setByte(o, cell.getErrorCellValue());
			break;
		case Cell.CELL_TYPE_FORMULA:
			field.set(o, cell.getCellFormula());
			break;
		case Cell.CELL_TYPE_NUMERIC:
			if (DateUtil.isCellDateFormatted(cell)) {
				if (field.getType().getName().equals(Date.class.getName())) {
					field.set(o, cell.getDateCellValue());
				} else {
					field.set(o, format.format(cell.getDateCellValue()));
				}
			} else {
				if (field.getType().isAssignableFrom(Integer.class) || field.getType().getName().equals("int")) {
					field.setInt(o, (int) cell.getNumericCellValue());
				} else if (field.getType().isAssignableFrom(Short.class) || field.getType().getName().equals("short")) {
					field.setShort(o, (short) cell.getNumericCellValue());
				} else if (field.getType().isAssignableFrom(Float.class) || field.getType().getName().equals("float")) {
					field.setFloat(o, (float) cell.getNumericCellValue());
				} else if (field.getType().isAssignableFrom(Byte.class) || field.getType().getName().equals("byte")) {
					field.setByte(o, (byte) cell.getNumericCellValue());
				} else if (field.getType().isAssignableFrom(Double.class) || field.getType().getName().equals("double")) {
					field.setDouble(o, cell.getNumericCellValue());
				} else if (field.getType().isAssignableFrom(String.class)) {
					String s = String.valueOf(cell.getNumericCellValue());
					if (s.contains("E")) {
						s = s.trim();
						BigDecimal bigDecimal = new BigDecimal(s);
						s = bigDecimal.toPlainString();
					}
					field.set(o, s);
				} else {
					field.set(o, cell.getNumericCellValue());
				}
			}
			break;
		case Cell.CELL_TYPE_STRING:
			if (field.getType().getName().equals(Date.class.getName())) {
				field.set(o, format.parse(cell.getRichStringCellValue().getString()));
			} else {
				field.set(o, cell.getRichStringCellValue().getString());
			}
			break;
		default:
			field.set(o, cell.getStringCellValue());
			break;
		}
	}

	private Workbook createWorkbook() throws IOException, InvalidFormatException {
		Workbook workbook = null;
		if (!"".equals(this.excelFilePath) && null != this.excelFilePath) {
			File file = new File(this.excelFilePath);
			if (!file.exists()) {
				LOG.warn("文件:{} 不存在！创建此文件！", this.excelFilePath);
				if (!file.createNewFile()) {
					throw new IOException("文件创建失败");
				}
				workbook = new XSSFWorkbook();
			} else {
				workbook = WorkbookFactory.create(file);
			}
		} else {
			workbook = new XSSFWorkbook();
		}
		return workbook;
	}

	/**
	 * 将数据写入excel文件
	 * 
	 * @param list
	 *            数据列表
	 * @param <T>
	 *            泛型
	 * @return 写入结果
	 */
	public <T> boolean createExcel(List<T> list) {
		if (null == this.excelFilePath || "".equals(this.excelFilePath))
			throw new NullPointerException("excelFilePath is null");
		boolean result = false;
		FileOutputStream fileOutputStream = null;
		if (null != list && !list.isEmpty()) {
			T test = list.get(0);
			Map<String, Field> fieldMap = new HashMap<String, Field>();
			Map<Integer, String> titleMap = new TreeMap<Integer, String>();
			Field[] fields = test.getClass().getDeclaredFields();
			for (Field field : fields) {
				if (field.isAnnotationPresent(MapperCell.class)) {
					MapperCell mapperCell = field.getAnnotation(MapperCell.class);
					fieldMap.put(mapperCell.cellName(), field);
					titleMap.put(mapperCell.order(), mapperCell.cellName());
				}
			}
			try {
				Sheet sheet = workbook.createSheet(this.sheetName);
				Collection<String> values = titleMap.values();
				String[] s = new String[values.size()];
				values.toArray(s);
				// 生成标题行
				Row titleRow = sheet.createRow(0);
				for (int i = 0; i < s.length; i++) {
					Cell cell = titleRow.createCell(i);
					cell.setCellValue(s[i]);
				}
				// 生成数据行
				for (int i = 0, length = list.size(); i < length; i++) {
					Row row = sheet.createRow(i + 1);
					for (int j = 0; j < s.length; j++) {
						Cell cell = row.createCell(j);
						for (Map.Entry<String, Field> data : fieldMap.entrySet()) {
							if (data.getKey().equals(s[j])) {
								Field field = data.getValue();
								field.setAccessible(true);
								cell.setCellValue(field.get(list.get(i)).toString());
								break;
							}
						}
					}
				}
				File file = new File(this.excelFilePath);
				if (!file.exists()) {
					if (!file.createNewFile()) {
						throw new IOException("文件创建失败");
					}
				}
				fileOutputStream = new FileOutputStream(file);
				workbook.write(fileOutputStream);
			} catch (IOException e) {
				LOG.error("流异常", e);
			} catch (IllegalAccessException e) {
				LOG.error("反射异常", e);
			} catch (Exception e) {
				LOG.error("其他异常", e);
			} finally {
				if (null != fileOutputStream) {
					try {
						fileOutputStream.close();
					} catch (IOException e) {
						LOG.error("关闭流异常", e);
					}
				}
			}
			result = true;
		}
		return result;
	}

	public <T> void createReport(HttpServletResponse response, List<T> list, String showFileName) throws Exception {
		// 定义输出类型
		response.reset();
		response.setContentType("application/msexcel");
		response.setHeader("Pragma", "public");
		response.setHeader("Cache-Control", "max-age=30");
		response.setHeader("Content-disposition", "attachment; filename=" + new String(showFileName.getBytes("gb2312"), "iso8859-1"));

		// 生成Excel并响应客户端
		ServletOutputStream out = response.getOutputStream();
		ByteArrayOutputStream bos = (ByteArrayOutputStream) getStream(list);
		response.setContentLength(bos.size());
		bos.writeTo(out);
		out.close();
		out.flush();
		bos.close();
		bos.flush();
	}

	public <T> OutputStream getStream(List<T> list) {
		ByteArrayOutputStream fileOutputStream = new ByteArrayOutputStream();
		if (null != list && !list.isEmpty()) {
			T test = list.get(0);
			Map<String, Field> fieldMap = new HashMap<String, Field>();
			Map<Integer, String> titleMap = new TreeMap<Integer, String>();
			Field[] fields = test.getClass().getDeclaredFields();
			for (Field field : fields) {
				if (field.isAnnotationPresent(MapperCell.class)) {
					MapperCell mapperCell = field.getAnnotation(MapperCell.class);
					fieldMap.put(mapperCell.cellName(), field);
					titleMap.put(mapperCell.order(), mapperCell.cellName());
				}
			}
			try {
				Sheet sheet = workbook.createSheet(this.sheetName);
				Collection<String> values = titleMap.values();
				String[] s = new String[values.size()];
				values.toArray(s);
				// 生成标题行
				Row titleRow = sheet.createRow(0);
				for (int i = 0; i < s.length; i++) {
					Cell cell = titleRow.createCell(i);
					cell.setCellValue(s[i]);
				}
				// 生成数据行
				for (int i = 0, length = list.size(); i < length; i++) {
					Row row = sheet.createRow(i + 1);
					for (int j = 0; j < s.length; j++) {
						Cell cell = row.createCell(j);
						for (Map.Entry<String, Field> data : fieldMap.entrySet()) {
							if (data.getKey().equals(s[j])) {
								Field field = data.getValue();
								field.setAccessible(true);
								cell.setCellValue(field.get(list.get(i)).toString());
								break;
							}
						}
					}
				}

				workbook.write(fileOutputStream);
			} catch (IOException e) {
				LOG.error("流异常", e);
			} catch (IllegalAccessException e) {
				LOG.error("反射异常", e);
			} catch (Exception e) {
				LOG.error("其他异常", e);
			} finally {
				if (null != fileOutputStream) {
					try {
						fileOutputStream.close();
					} catch (IOException e) {
						LOG.error("关闭流异常", e);
					}
				}
			}

		}
		return fileOutputStream;
	}

	/**
	 * 获取指定单元格的值
	 * 
	 * @param rowNumber
	 *            行数，从1开始
	 * @param cellNumber
	 *            列数，从1开始
	 * @return 该单元格的值
	 */
	public String getCellValue(int rowNumber, int cellNumber) {
		String result;
		checkRowAndCell(rowNumber, cellNumber);
		Sheet sheet = this.workbook.getSheet(this.sheetName);
		Row row = sheet.getRow(--rowNumber);
		Cell cell = row.getCell(--cellNumber);
		switch (cell.getCellType()) {
		case Cell.CELL_TYPE_BLANK:
			result = cell.getStringCellValue();
			break;
		case Cell.CELL_TYPE_BOOLEAN:
			result = String.valueOf(cell.getBooleanCellValue());
			break;
		case Cell.CELL_TYPE_ERROR:
			result = String.valueOf(cell.getErrorCellValue());
			break;
		case Cell.CELL_TYPE_FORMULA:
			result = cell.getCellFormula();
			break;
		case Cell.CELL_TYPE_NUMERIC:
			if (DateUtil.isCellDateFormatted(cell)) {
				result = format.format(cell.getDateCellValue());
			} else {
				result = String.valueOf(cell.getNumericCellValue());
			}
			break;
		case Cell.CELL_TYPE_STRING:
			result = cell.getRichStringCellValue().getString();
			break;
		default:
			result = cell.getStringCellValue();
			break;
		}
		return result;
	}

	private void checkRowAndCell(int rowNumber, int cellNumber) {
		if (rowNumber < 1) {
			throw new RuntimeException("rowNumber less than 1");
		}
		if (cellNumber < 1) {
			throw new RuntimeException("cellNumber less than 1");
		}
	}

	@Override
	public void close() throws IOException {
		this.workbook.close();

	}

	public void createReport(HttpServletRequest request, HttpServletResponse response, Map<?, ?> reportInfo, MisReport3136 resultSum) throws Exception {
		// 设置文件响应信息
		String fileTitle = ((String) reportInfo.get("reportTitle")).trim().replaceAll(",", "").replaceAll("\\(", "").replaceAll("\\)", "").replaceAll(" ", "_");
		if ("".equals(fileTitle)) {
			fileTitle = "export";
		}
		String showFileName = URLEncoder.encode(fileTitle + ".xls", "UTF-8");
		showFileName = new String(showFileName.getBytes("iso8859-1"), "gb2312");
		// 定义输出类型
		response.reset();
		response.setContentType("application/msexcel");
		response.setHeader("Pragma", "public");
		response.setHeader("Cache-Control", "max-age=30");
		response.setHeader("Content-disposition", "attachment; filename=" + new String(showFileName.getBytes("gb2312"), "iso8859-1"));

		// 生成Excel并响应客户端

		ByteArrayOutputStream bos = (ByteArrayOutputStream) getStream(reportInfo, resultSum, request);
		ServletOutputStream out = response.getOutputStream();
		response.setContentLength(bos.size());
		bos.writeTo(out);
		out.close();
		out.flush();
		bos.close();
		bos.flush();

	}

	private OutputStream getStream(Map<?, ?> reportInfo, MisReport3136 resultSum, HttpServletRequest request) throws Exception {
		User user = (User) request.getSession().getAttribute(SysConstants.CURR_LOGIN_USER_SESSION);
		boolean lan = user.getUserLang().equals(UserLanguage.EN);
		// 实例化HSSFWorkbook
		HSSFWorkbook wb = new HSSFWorkbook();
		HSSFSheet sheet = wb.createSheet("Sheet");

		SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		String createDate = df.format(new Date());
		HSSFRow row, row1, row2 = null;
		HSSFCell cell = null;
		int colNum = 5;
		// 加标题、查询条件及制表日期等

		sheet.addMergedRegion(new CellRangeAddress(0, 1, 0, colNum - 1));
		row = sheet.createRow(0);
		cell = row.createCell(0);
		cell.setCellValue("" + reportInfo.get("reportTitle"));
		cell.setCellStyle(this.getStyle("TITLE", wb));

		sheet.addMergedRegion(new CellRangeAddress(2, 2, 0, colNum * 2 / 3));
		row = sheet.createRow(2);
		cell = row.createCell(0);
		String queryString = reportInfo.get("queryInfo").toString();

		cell.setCellValue("" + reportInfo.get("queryInfo"));
		cell.setCellStyle(this.getStyle("CONDITION", wb));
		sheet.setColumnWidth(0, (queryString.getBytes().length * 128));
		sheet.addMergedRegion(new CellRangeAddress(2, 2, colNum * 2 / 3 + 1, colNum - 1));
		cell = row.createCell(colNum * 2 / 3 + 1);
		String dataString = "";
		if (lan) {
			dataString = "Create Date:" + createDate;
			cell.setCellValue("Create Date:" + createDate);
		} else {
			dataString = "制表时间：" + createDate;
			cell.setCellValue("制表时间：" + createDate);

		}
		cell.setCellStyle(this.getStyle("CONDITION", wb));
		//sheet.setColumnWidth(colNum * 2 / 3 + 1, (dataString.getBytes().length * 256));
		for(int i=0;i<colNum;i++){
			sheet.setColumnWidth(i, 2560*2);
		}
		
		int rowIndex = 3; // 记录行的位置，去掉标题查询条件行，默认从3（第四行）开始
		// String title1=report3136.code1
		String code1 = lan ? "Items" : "项目";
		row = sheet.createRow(rowIndex);
		cell = row.createCell(0);
		cell.setCellValue(code1);
		cell.setCellStyle(this.getStyle("CONTENT", wb));
		cell = row.createCell(1);
		
		CellRangeAddress ca1 = new CellRangeAddress(3, 3, 1, colNum * 2 / 3 - 1);
		sheet.addMergedRegion(ca1);
		String code2 = lan ? "Adjustment Fund" : "调节基金";
		String code4 = lan ? "Prize Pool" : "奖池资金";
		cell.setCellValue(code2);
		cell.setCellStyle(this.getMergeStyle("CONTENT", wb));
		this.setRegionBorder(HSSFCellStyle.BORDER_THIN,ca1,sheet,wb);
		cell = row.createCell(colNum * 2 / 3);
		
		CellRangeAddress ca2 = new CellRangeAddress(3, 3, colNum * 2 / 3, colNum - 1);
		sheet.addMergedRegion(ca2);
		cell.setCellValue(code4);
		cell.setCellStyle(this.getMergeStyle("CONTENT", wb));
		this.setRegionBorder(HSSFCellStyle.BORDER_THIN,ca2,sheet,wb);

		row = sheet.createRow(++rowIndex);
		cell = row.createCell(0);
		cell.setCellValue("");
		cell.setCellStyle(this.getStyle("CONTENT", wb));

		cell = row.createCell(1);
		String code5 = lan ? "Initial Balance" : "期初余额";
		cell.setCellValue(code5);
		cell.setCellStyle(this.getStyle("CONTENT", wb));

		cell = row.createCell(2);
		DecimalFormat dff = new DecimalFormat("#,##0");
		String adjbefore = resultSum != null ? dff.format(resultSum.getAdjbefore()) : "0";
		cell.setCellValue(adjbefore);
		cell.setCellStyle(this.getStyle("CONTENT", wb));

		cell = row.createCell(3);
		cell.setCellValue(code5);
		cell.setCellStyle(this.getStyle("CONTENT", wb));

		cell = row.createCell(4);
		String poolbefore = resultSum != null ? dff.format(resultSum.getPoolbefore()) : "0";
		cell.setCellValue(poolbefore);
		cell.setCellStyle(this.getStyle("CONTENT", wb));

		row1 = sheet.createRow(5);

		row2 = sheet.createRow(6);
		sheet.addMergedRegion(new CellRangeAddress(5, 6, 0, 0));
		cell = row1.createCell(0);

		String code6 = lan ? "Items Added" : "加项";
		cell.setCellValue(code6);
		cell.setCellStyle(this.getStyle("CONTENT", wb));

		cell = row1.createCell(1);
		String code7 = lan ? "Roll-in" : "本期计提";
		cell.setCellValue(code7);
		cell.setCellStyle(this.getStyle("CONTENT", wb));
		cell = row1.createCell(2);
		String adjissue = resultSum != null ? dff.format(resultSum.getAdjissue()) : "0";
		cell.setCellValue(adjissue);
		cell.setCellStyle(this.getStyle("CONTENT", wb));
		cell = row1.createCell(3);
		cell.setCellValue(code7);
		cell.setCellStyle(this.getStyle("CONTENT", wb));
		cell = row1.createCell(4);
		String poolissue = resultSum != null ? dff.format(resultSum.getPoolissue()) : "0";
		cell.setCellValue(poolissue);
		cell.setCellStyle(this.getStyle("CONTENT", wb));
		cell = row2.createCell(1);
		String code8 = lan ? "From Abandoned Award" : "弃奖转入";
		cell.setCellValue(code8);
		cell.setCellStyle(this.getStyle("CONTENT", wb));
		cell = row2.createCell(2);
		String adjabandon = resultSum != null ? dff.format(resultSum.getAdjabandon()) : "0";
		cell.setCellValue(adjabandon);
		cell.setCellStyle(this.getStyle("CONTENT", wb));
		cell = row2.createCell(3);
		String code9 = lan ? "From Adjustment Fund" : "调节基金转入";
		cell.setCellValue(code9);
		cell.setCellStyle(this.getStyle("CONTENT", wb));
		cell = row2.createCell(4);
		String pooladj = resultSum != null ? dff.format(resultSum.getPooladj()) : "0";
		cell.setCellValue(pooladj);
		cell.setCellStyle(this.getStyle("CONTENT", wb));

		row1 = sheet.createRow(7);

		row2 = sheet.createRow(8);
		sheet.addMergedRegion(new CellRangeAddress(7, 8, 0, 0));
		cell = row1.createCell(0);
		String code10 = lan ? "Items Deducted" : "减项";
		cell.setCellValue(code10);
		cell.setCellStyle(this.getStyle("CONTENT", wb));
		cell = row1.createCell(1);
		String code11 = lan ? "Roll to Prize Pool" : "转出到奖池";
		cell.setCellValue(code11);
		cell.setCellStyle(this.getStyle("CONTENT", wb));
		cell = row1.createCell(2);

		String adjpool = resultSum != null ? dff.format(resultSum.getAdjpool()) : "0";
		cell.setCellValue(adjpool);
		cell.setCellStyle(this.getStyle("CONTENT", wb));
		cell = row1.createCell(3);

		String code12 = lan ? "Issue High-Level Payout" : "本期高等奖金额";
		cell.setCellValue(code12);
		cell.setCellStyle(this.getStyle("CONTENT", wb));

		cell = row1.createCell(4);

		String poolhdreward = resultSum != null ? dff.format(resultSum.getPoolhdreward()) : "0";
		cell.setCellValue(poolhdreward);
		cell.setCellStyle(this.getStyle("CONTENT", wb));

		cell = row2.createCell(1);
		String code13 = lan ? "Special Prize" : "设置特别奖";
		cell.setCellValue(code13);
		cell.setCellStyle(this.getStyle("CONTENT", wb));
		cell = row2.createCell(2);
		String adspec = resultSum != null ? dff.format(resultSum.getAdspec()) : "0";
		cell.setCellValue(adspec);
		cell.setCellStyle(this.getStyle("CONTENT", wb));

		cell = row2.createCell(3);

		cell.setCellValue("--------");
		cell.setCellStyle(this.getStyle("CONTENT", wb));
		cell = row2.createCell(4);

		cell.setCellValue("--------");
		cell.setCellStyle(this.getStyle("CONTENT", wb));

		row = sheet.createRow(9);

		cell = row.createCell(0);
		cell.setCellValue("");
		cell.setCellStyle(this.getStyle("CONTENT", wb));
		cell = row.createCell(1);
		String code14 = lan ? "Final Balance" : "期末余额";
		cell.setCellValue(code14);
		cell.setCellStyle(this.getStyle("CONTENT", wb));
		cell = row.createCell(2);
		String adjafter = resultSum != null ? dff.format(resultSum.getAdjafter()) : "0";
		cell.setCellValue(adjafter);
		cell.setCellStyle(this.getStyle("CONTENT", wb));
		cell = row.createCell(3);
		cell.setCellValue(code14);
		cell.setCellStyle(this.getStyle("CONTENT", wb));

		cell = row.createCell(4);
		String poolafter = resultSum != null ? dff.format(resultSum.getPoolafter()) : "0";
		cell.setCellValue(poolafter);
		cell.setCellStyle(this.getStyle("CONTENT", wb));

		ByteArrayOutputStream bos = new ByteArrayOutputStream();
		wb.write(bos);
		return bos;
	}
	
	private HSSFCellStyle getStyle(String type,HSSFWorkbook wb){
		// 创建表头样式
		HSSFCellStyle cellStyle = wb.createCellStyle();
		// 设置字体
		HSSFFont font = wb.createFont();
		
		if("TITLE".equals(type)){
			// 文本位置(居中)
			cellStyle.setAlignment(HSSFCellStyle.ALIGN_CENTER);
			cellStyle.setVerticalAlignment(HSSFCellStyle.VERTICAL_CENTER);
			font.setFontHeightInPoints((short) 20);// 字体大小
			font.setBoldweight(HSSFFont.BOLDWEIGHT_BOLD);// 加粗
			font.setFontName("宋体");
			cellStyle.setFont(font);
			//设置边框
			cellStyle.setBorderLeft(HSSFCellStyle.BORDER_NONE);
			cellStyle.setBorderRight(HSSFCellStyle.BORDER_NONE);
			cellStyle.setBorderTop(HSSFCellStyle.BORDER_NONE);
			cellStyle.setBorderBottom(HSSFCellStyle.BORDER_NONE);
			
		}else if("CONTENT".equals(type)){
			// 文本位置(居中)
			cellStyle.setAlignment(HSSFCellStyle.ALIGN_CENTER);
			font.setFontHeightInPoints((short) 10);// 字体大小
			font.setBoldweight(HSSFFont.BOLDWEIGHT_NORMAL);
			font.setFontName("宋体");
			cellStyle.setFont(font);
			//设置边框
			cellStyle.setBorderLeft(HSSFCellStyle.BORDER_THIN);
			cellStyle.setBorderRight(HSSFCellStyle.BORDER_THIN);
			cellStyle.setBorderTop(HSSFCellStyle.BORDER_THIN);
			cellStyle.setBorderBottom(HSSFCellStyle.BORDER_THIN);
		}else if("CONDITION".equals(type)){
			// 文本位置(居中)
			cellStyle.setAlignment(HSSFCellStyle.ALIGN_LEFT);
			cellStyle.setVerticalAlignment(HSSFCellStyle.VERTICAL_CENTER);
			font.setFontHeightInPoints((short) 10);// 字体大小
			font.setBoldweight(HSSFFont.BOLDWEIGHT_NORMAL);
			font.setFontName("宋体");
			cellStyle.setFont(font);
			//设置边框
			cellStyle.setBorderLeft(HSSFCellStyle.BORDER_NONE);
			cellStyle.setBorderRight(HSSFCellStyle.BORDER_NONE);
			cellStyle.setBorderTop(HSSFCellStyle.BORDER_NONE);
			cellStyle.setBorderBottom(HSSFCellStyle.BORDER_NONE);
		}
		return cellStyle;
	}
	
	private void setRegionBorder(int border, CellRangeAddress region, Sheet sheet,HSSFWorkbook wb){
		RegionUtil.setBorderBottom(border,region, sheet, wb);
		RegionUtil.setBorderLeft(border,region, sheet, wb);
		RegionUtil.setBorderRight(border,region, sheet, wb);
		RegionUtil.setBorderTop(border,region, sheet, wb);
	}
	
	private HSSFCellStyle getMergeStyle(String type,HSSFWorkbook wb){
		// 创建表头样式
		HSSFCellStyle cellStyle = wb.createCellStyle();
		// 设置字体
		HSSFFont font = wb.createFont();
		cellStyle.setAlignment(HSSFCellStyle.ALIGN_CENTER);
		font.setFontHeightInPoints((short) 10);// 字体大小
		font.setBoldweight(HSSFFont.BOLDWEIGHT_NORMAL);
		font.setFontName("宋体");
		cellStyle.setFont(font);
		
		return cellStyle;
	}

}
