package cls.taishan.common.utils;

import java.util.Date;

public class FileUtils {
	
	private static final String FILE_PATH = "file";

	 /**
     * 生成保存文件url
     * 
     * @param directory
     * @param suffixName
     * @return
     * @see
     */
    public static String generationFileDirectory(String directory) {
        return directory + "/" + FILE_PATH + "/" + DateUtils.parseDate(new Date());
    }
    
}
